# select a list of hard case, perturb the demand, and then test
# those cases are selected as the two solvers' pg are very different from each other >= 1%

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
network_data = parse_file("./data/"*itema);
load_keys = [i for i in keys(network_data["load"])];
σ_load = Dict()
load_distrn = Dict()
for i in 1:length(load_keys)
    if network_data["load"][load_keys[i]]["pd"] != 0
        σ_load[load_keys[i]] = abs(network_data["load"][load_keys[i]]["pd"]*0.03)
        load_distrn[load_keys[i]] = Normal(0,σ_load[load_keys[i]])
    else
        σ_load[load_keys[i]] = 0;
        load_distrn[load_keys[i]] = Uniform(0,0);
    end
end
pmap(ω -> run_diffd_para(network_data, load_distrn, load_keys), 1:20);

list_file_hard = ["case1888rte.m"
                 "case6515rte.m"
                 "case89pegase.m"
                 "case1354pegase.m"
                 "pglib_opf_case2746wp_k__api.m"
                 "pglib_opf_case24_ieee_rts__api.m"
                 "case6470rte.m"
                 "case6468rte.m"
                 "case1951rte.m"
                 "pglib_opf_case2746wop_k__api.m"
                 "pglib_opf_case3012wp_k__api.m"
                 "case13659pegase.m"
                 "case2848rte.m"
                 "case30pwl.m"
                 "pglib_opf_case2383wp_k__api.m"
                 "pglib_opf_case3375wp_k__api.m"
                 "case2869pegase.m"
                 "case6495rte.m"
                 "pglib_opf_case30000_goc__api.m"
                 "case9241pegase.m"
                 "pglib_opf_case60_c.m"
                 "case2868rte.m"
                  ];
perturbResult_dict = Dict();

for itema in list_file_hard
    if occursin(".m",itema)
        network_data = parse_file("./data/"*itema);
        load_keys = [i for i in keys(network_data["load"])]
        σ_load = Dict()
        load_distrn = Dict()
        for i in 1:length(load_keys)
            if network_data["load"][load_keys[i]]["pd"] != 0
                σ_load[load_keys[i]] = abs(network_data["load"][load_keys[i]]["pd"]*0.03)
                load_distrn[load_keys[i]] = Normal(0,σ_load[load_keys[i]])
            else
                σ_load[load_keys[i]] = 0;
                load_distrn[load_keys[i]] = Uniform(0,0.0000001);
            end
        end
        perturbResult_dict[itema] = pmap(ω -> run_diffd_para(network_data, load_distrn, load_keys), 1:1000);
        save("stochastic.jld","results",perturbResult_dict);
    end
end
