using CSV
using DataFrames
using PlotlyJS
using LinearAlgebra
using Statistics

x = collect(0:5)
y = [5.1, 4.2, 2.8, 2.2, 0.9, 0.3]

function make_A(order, x)
    out = ones(length(x))
    for i in 1:order
        out = hcat(x.^i,out)
    end

    return out
end

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

function corelation(x,y)
    avg_xy = mean(x.*y)
    avg_x = mean(x)
    avg_y = mean(y)
    avg_x2 = mean(x.^2)
    avg_y2 = mean(y.^2)

    return (avg_xy - avg_x*avg_y)/(sqrt(avg_x2-avg_x^2)*sqrt(avg_y2-avg_y^2))
end

A = make_A(1, x)


vals = (A' * A) \ (A' * y)

display(vals)

f(t) = poly_regress(vals, t);

T = LinRange(minimum(x), maximum(x), 100)
ds = scatter(x = x, y = y, mode = "markers")
fs = scatter(x = T, y = f.(T), mode = "line")

r_2 = regress_r2(x, y, f)
println("r^2: $(r_2)")

cor = corelation(x,y)
println("correlation: $(cor)")

plot([ds, fs])
