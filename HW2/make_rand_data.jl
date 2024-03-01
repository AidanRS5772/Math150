using Random
using CSV
using DataFrames

# Generate two sets of 100 random numbers each from 0 to 1
set1 = rand(100)
set2 = rand(100)

# Create a DataFrame
df = DataFrame(Set1 = set1, Set2 = set2)

# Save the DataFrame to a CSV file
CSV.write("random_data_p4.csv", df)