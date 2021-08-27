# compare the solvers for all cases
using Distributed;

addprocs(20);
@everywhere using PowerModels, Gurobi, Ipopt, Random, Distributions;
@everywhere using JLD,HDF5;
@everywhere include("solver_run.jl");
@everywhere const GUROBI_ENV = Gurobi.Env();

list_file = readdir("./data");
result_Gurobi = Dict();
result_Ipopt = Dict();

itema = "case5.m";
pmap(i -> run_diff_solver("./data/",itema), 1:20);

# nominal condition run
list_run = [];
list_error = [];
objDiff_dict = Dict();
pgDiff_dict = Dict();
timeDiff_dict = Dict();
cond_dict = Dict();

list_run = [itema for itema in list_file if occursin(".m",itema)];
solver_result = pmap(fn -> run_diff_solver("./data/",fn), list_run);
for j in 1:length(solver_result)
    if length(solver_result[j]) == 2
        objDiff_dict[solver_result[j][1]] = solver_result[j][2][1];
        pgDiff_dict[solver_result[j][1]] = solver_result[j][2][2];
        timeDiff_dict[solver_result[j][1]] = solver_result[j][2][3];
        cond_dict[solver_result[j][1]] = solver_result[j][2][4];
    end
end
save("nominal.jld","results", [objDiff_dict, pgDiff_dict, timeDiff_dict, cond_dict]);
