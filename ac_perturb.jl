using Distributed;
addprocs(20);
@everywhere using PowerModels, Gurobi, Ipopt, Random, Distributions;
@everywhere using CSV;
@everywhere include("solver_run_ac.jl");
@everywhere const GUROBI_ENV = Gurobi.Env();
@everywhere using DataFrames;


list_file = readdir("./data/");
perturbed_file = readdir("./data/perturb/");

perturbResult_dict = Dict();
run_time_dict = Dict();
inf_case = Dict() #the infeasible perturb case


println("Number of processes: ", nprocs())
println("Number of workers: ", nworkers())


for itema in list_file
    if occursin(".m", itema)
    
        model_name = []
        run_time_list = []
        inf_case_list = []
        ter_status_itema = []
        run_time_itema = []
        load_info_itema = []
        pd_list_itema = []
        obj = []
    
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
        for profile in perturbResult_dict[itema]
            pd_dict_profile = Dict()
            #push to infeasible_list
            # push!(infeasible_list, (i, σ_load[load_keys[i]], load_distrn[load_keys[i]]))
    
            # infeasible_load_dict = Dict("index" => i, "σ_load" => σ_load[load_keys[i]], "load_distrn" => load_distrn[load_keys[i]])
            push!(model_name, itema)
            push!(obj, profile[1])
            push!(ter_status_itema, profile[2])
            push!(run_time_itema, profile[4])
    
            pd_keys = [i for i in keys(profile[5])]
            for keys in pd_keys
                # store the pd information
                # push!(pd_list_itema, profile[4][keys]["pd"])
                pd_dict_profile[keys] = profile[5][keys]["pd"]
            end
            push!(pd_list_itema, pd_dict_profile)
        end
        result = Dict("case_name" => model_name, "pd" => pd_list_itema, "objective value" => obj,
            "ter_status" => ter_status_itema, "run_time" => run_time_itema)
    
        result = DataFrame(result)
        CSV.write("./data/perturb/" * itema[1:end-2] * "_"*"perturb" * ".csv", result, bufsize = 2^30)
    
    end
end

