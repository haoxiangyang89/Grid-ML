# read the matpower data and process it in PowerModels.jl
using PowerModels, Gurobi, Ipopt, Random, Distributions;
using CSV;
using DataFrames;

list_file = readdir("./data/hard_case/Julia_Solvable");
result_cat = Dict();
ErrorList = [];
NumList = [];
OptList = [];
InfeasList = [];
name = [];
ter_status = [];

for itema in list_file
    #    if occursin("pglib",itema)
    try
        if occursin("case", itema)
            # result = run_dc_opf("./data/hard_case/"*itema,Gurobi.Optimizer);
            result = run_ac_opf("./data/hard_case/Julia_Solvable/" * itema, Ipopt.Optimizer)
            result_cat[itema] = result["termination_status"]
        end
    catch
        push!(ErrorList, itema)
    end
end

# obtain the numerical issue cases
for iKey in keys(result_cat)
    if result_cat[iKey] == NUMERICAL_ERROR
        push!(NumList, iKey)
    end
end
# numerical issues are mostly caused by infeasibility as well

for iKey in keys(result_cat)
    if result_cat[iKey] == OPTIMAL
        push!(OptList, iKey)
    end
end

for iKey in keys(result_cat)
    if result_cat[iKey] == INFEASIBLE
        push!(InfeasList, iKey)
    end
end

df_ter_status = DataFrame(result_cat)
CSV.write("ter_status.csv", df_ter_status)