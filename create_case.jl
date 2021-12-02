# read the matpower data and process it in PowerModels.jl
using PowerModels, Gurobi, Ipopt, Random, Distributions;
using JLD, HDF5;

# read in the list of hard cases
# list_file = readdir("./data/hard_case/Solvable");
list_file = readdir("./data/hard_case/Julia_Solvable");

result_cat = Dict();
ErrorList = [];
NumList = [];
OptList = [];
InfeasList = [];

for itema in list_file
    #    if occursin("pglib",itema)
    try
        if occursin("case", itema)
            # result = run_dc_opf("./data/hard_case/"*itema,Gurobi.Optimizer);
            result = run_dc_opf("./data/hard_case/Julia_Solvable/" * itema,
                optimizer_with_attributes(Ipopt.Optimizer, "linear_solver" => "ma27"))
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

# Result:
# 1. using Gurobi, there are cases that could be solved, which are put in "Solvable" folder
# 2. the rest of the cases are all infeasible or numerical issue
# 3. solving the rest of the cases using Ipopt yields LOCALLY_INFEASIBLE for all


##

# alter the load portfolio to generate hard case
# read in the data
const GUROBI_ENV = Gurobi.Env();
network_data = parse_file("./data/pglib_opf_case2746wop_k.m")
load_keys = [i for i in keys(network_data["load"])]

# test changing load at one bus
result_load_1 = Dict()
for i = 1:length(load_keys)
    network_data_new = deepcopy(network_data)
    network_data_new["load"][load_keys[i]]["pd"] *= 1.5
    result = run_dc_opf(network_data_new,
        optimizer_with_attributes(() -> Gurobi.Optimizer(GUROBI_ENV),
            "OutputFlag" => 0))
    result_load_1[load_keys[i]] = result["termination_status"]
end

# test changing load at all buses with a normal distribution deviation
σ_load = Dict()
load_distrn = Dict()
for i = 1:length(load_keys)
    σ_load[load_keys[i]] = network_data["load"][load_keys[i]]["pd"] * 0.03
    load_distrn[load_keys[i]] = Normal(0, σ_load[load_keys[i]])
end

result_load_2 = []
errorLoad = Dict()
for iterNo = 1:1000
    network_data_new = deepcopy(network_data)
    for i = 1:length(load_keys)
        network_data_new["load"][load_keys[i]]["pd"] += rand(load_distrn[load_keys[i]])
    end
    result = run_dc_opf(network_data_new,
        optimizer_with_attributes(() -> Gurobi.Optimizer(GUROBI_ENV),
            "OutputFlag" => 0))
    push!(result_load_2, result["termination_status"])
    if result["termination_status"] != OPTIMAL
        errorLoad[iterNo] = network_data_new["load"]
    end
end

save("errorLoad.jld", "errorLoad", errorLoad);
