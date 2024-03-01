using CSV
using DataFrames
using PlotlyJS
using LinearAlgebra
using Random

df = CSV.read("random_data_p4.csv", DataFrame, header=false)

x = df.Column1
y = df.Column2

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

function random_perms(data, N)
    unique_perms = Set()
    while length(unique_perms) < N
        push!(unique_perms, shuffle(copy(data)))
    end

    return collect(unique_perms)
end

function r_2_change_trials(x,y, N)
    A = make_A(1, x)
    vals = (A' * A) \ (A' * y)
    f(t) = poly_regress(vals, t)
    r_2_init = regress_r2(x,y,f)

    high = 0
    low = 0
    for perm in random_perms(y, N)
        vals_temp = (A' * A) \ (A' * perm)
        f_temp(t) = poly_regress(vals_temp, t)
        r_2_temp = regress_r2(x,perm,f_temp)

        if r_2_temp >= r_2_init
            high += 1
        else
            low += 1
        end
    end

    return high/N , low/N
end

high_r , low_r = r_2_change_trials(x,y,1_000_000)

println("higher: ", high_r)
println("lower: ", low_p)