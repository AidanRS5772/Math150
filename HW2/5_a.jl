using CSV
using DataFrames
using PlotlyJS
using LinearAlgebra
using Statistics


df = CSV.read("assessment_data.csv", DataFrame, header=false)

x = df.Column1
y = df.Column2

function corelation(x,y)
    avg_xy = mean(x.*y)
    avg_x = mean(x)
    avg_y = mean(y)
    avg_x2 = mean(x.^2)
    avg_y2 = mean(y.^2)

    return (avg_xy - avg_x*avg_y)/(sqrt(avg_x2-avg_x^2)*sqrt(avg_y2-avg_y^2))
end

println(corelation(x,y))