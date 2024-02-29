using CSV
using DataFrames
using PlotlyJS
using LinearAlgebra

df = CSV.read("assessment_data.csv", DataFrame, header=false)

x = df.Column1
y = df.Column2

function make_A(order, x)
    out = ones(length(x))
    for i in 1:order
        out = hcat(x.^i,out)
    end

    return out
end

A = make_A(1, x)


vals = (A' * A) \ (A' * y)

display(vals)

function poly_regress(vals, t)
	tot = 0
	for i in 0:(length(vals)-1)
		tot = tot + vals[end-i] * (t ^ i)
	end

	return tot
end

function regress_r2(x::Vector,y::Vector,f::Function)
    ssr = sum((y.-f.(x)).^2)
    avg_y = sum(y)/length(y)
    sst = sum((y.-avg_y).^2)

    return 1-ssr/sst
end

f(t) = poly_regress(vals, t);

T = LinRange(minimum(x), maximum(x), 100)
ds = scatter(x = x, y = y, mode = "markers")
fs = scatter(x = T, y = f.(T), mode = "line")

r_2 = regress_r2(x, y, f)
println("r^2: $(r_2)")

plot([ds, fs])