using PlotlyJS
using LinearAlgebra

x = [-2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2.0]
y = [0, -0.21, 0, 0.64, 1, 0.64, 0, -0.21, 0]

function make_A(order, x)
    out = ones(length(x))
    for i in 1:order
        out = hcat(x.^i,out)
    end

    return out
end

A = make_A(6, x)


vals = (A' * A) \ (A' * y)

display(vals)

function poly_regress(vals, T)
	tot = 0
	for i in 0:(length(vals)-1)
		tot = tot .+ vals[end-i] .* T .^ i
	end

	return tot
end

T = LinRange(-2, 2, 100)
ds = scatter(x = x, y = y, mode = "markers")
fs = scatter(x = T, y = poly_regress(vals, T), mode = "line")

error = abs.(y.-poly_regress(vals, x))
avg_er = sum(error)/length(error)
println("Average Error: $(avg_er)")

l = Layout(yaxis=attr(range=[-1, 1.5]))

plot([ds, fs], l)


