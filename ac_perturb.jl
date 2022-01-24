using Distributed;
addprocs(20);
@everywhere using PowerModels, Gurobi, Ipopt, Random, Distributions;
@everywhere using CSV;
@everywhere include("solver_run_ac.jl");
@everywhere const GUROBI_ENV = Gurobi.Env();
@everywhere using DataFrames;


list_file = readdir("./data");

list_file_hard = [
    "case1888rte.m"
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
run_time_dict = Dict();
inf_case = Dict() #the infeasible perturb case
model_name = []
run_time_list = []
inf_case_list = []

println("Number of processes: ", nprocs())
println("Number of workers: ", nworkers())


for itema in list_file_hard

    if occursin(".m", itema)
        network_data = parse_file("./data/" * itema)
        load_keys = [i for i in keys(network_data["load"])]
        gen_keys = [i for i in keys(network_data["gen"])]
        σ_load = Dict()
        load_distrn = Dict()
    
        for i in 1:length(load_keys)
            if network_data["load"][load_keys[i]]["pd"] != 0
                σ_load[load_keys[i]] = abs(network_data["load"][load_keys[i]]["pd"] * 0.03)
                load_distrn[load_keys[i]] = Normal(0, σ_load[load_keys[i]])
            else
                σ_load[load_keys[i]] = 0
                load_distrn[load_keys[i]] = Uniform(0, 0.0000001)
            end
        end
    
    
        perturbResult_dict[itema] = pmap(ω -> run_Ipopt_para_ac(network_data, load_distrn, load_keys, gen_keys), 1:1000)
    
        ter_status_itema = []
        run_time_itema = []
        load_info_itema = []
    
        for profile in perturbResult_dict[itema]
            if typeof(profile[1]) != Float64
                #push to infeasible_list
                # push!(infeasible_list, (i, σ_load[load_keys[i]], load_distrn[load_keys[i]]))
    
                # infeasible_load_dict = Dict("index" => i, "σ_load" => σ_load[load_keys[i]], "load_distrn" => load_distrn[load_keys[i]])
    
                push!(ter_status_itema, profile[1])
                push!(load_info_itema, profile[4])
            end
    
            push!(run_time_itema, profile[3])
        end
    
        run_time_mean = mean(run_time_itema)   # mean of running time
        run_time_stddev = std(run_time_itema)  # standard deviation of running time
        run_time_dict[itema] = Dict("run_time_mean" => run_time_mean, "run_time_stddev" => run_time_stddev)
        push!(run_time_list, run_time_dict[itema])
    
    
        inf_case[itema] = Dict("ter_status" => ter_status_itema, "load_info_itema" => load_info_itema)
        push!(inf_case_list, inf_case[itema])
        push!(model_name, itema)
    end

end


result_cat_dict = Dict("case_name" => model_name, "run_time_distribution" => run_time_list,
    "infeasible_list" => inf_case_list)

df_result = DataFrame(result_cat_dict)
CSV.write("result_perturb.csv", df_result, bufsize = 2^29)
