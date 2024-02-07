using PlotlyJS

logistic(t, a, p) = p * exp(a * t) / (1 + p * (exp(a * t) - 1))

p_vals = [0.2, 0.8, 2.0]
a_vals = [0.5, 2.0]

scatters = []
T = LinRange(0, 10, 100)
for a_val in a_vals
    for p_val in p_vals
        push!(scatters, scatter(x=T, y=logistic.(T, a_val, p_val), name="p_0 = $(p_val) , α = $(a_val)"))
    end
end

plot([scatters...])