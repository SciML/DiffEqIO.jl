using DiffEqIO
using Base.Test

# Generate Data

using DiffEqBase, OrdinaryDiffEq

f_2dlinear = (t,u,du) -> du.=1.01u
prob = ODEProblem(f_2dlinear,rand(2,2),(0.0,1.0))
sol1 =solve(prob,Euler();dt=1//2^(4))

using DataFrames
df = DataFrame(sol1)

using ParameterizedFunctions

f = @ode_def LotkaVolterra begin
  dx = a*x - b*x*y
  dy = -c*y + d*x*y
end a=>1.5 b=>1 c=3 d=1

prob = ODEProblem(f,[1.0,1.0],(0.0,1.0))
sol2 =solve(prob,Tsit5())

df = DataFrame(sol2)

using CSV
CSV.write("out.csv",df)


# Use JLD

#=

using JLD
JLD.save("out.jld","sol",sol2)
=#
