using Random
using PlotlyJS

function step(pos)
    seed = rand()
    if seed < .5
        return pos + 1
    else
        return pos - 1
    end
end

function track_steps(num)
    out = []    
    pos = 0
    for _ in 1:num
        push!(out, pos)
        pos = step(pos)
    end

    out
end

function expected_dist(len, trails)
    out = []

    for _ in 1:trails
        pos = 0
        for _ in 1:len
            pos = step(pos)
        end
        
        push!(out, pos)
    end

    return out
end

function expected_max_dist(len, trials)
    out = []

    for _ in 1:trials
        steps = track_steps(len)
        max = maximum(abs.(steps))
        push!(out, max)
    end

    return out
end

len = 1000
trials = 10^6
data = expected_max_dist(len, trials)
avg = sum(data)/trials
println("avg: $(avg)")

bin_start = minimum(data) - 1
bin_end = maximum(data) + 1

# Create the histogram
hist = histogram(x=data, autobinx=false, xbins_start=bin_start, xbins_end=bin_end, xbins_size=2)

layout = Layout(title="Distance after 1000 steps", xaxis_title="Distance", yaxis_title="Frequency")

plot(hist, layout)
