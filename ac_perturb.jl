using Distributed;

addprocs(20);
@everywhere using PowerModels, Gurobi, Ipopt, Random, Distributions;
@everywhere using CSV;
@everywhere include("solver_run_ac.jl");
@everywhere const GUROBI_ENV = Gurobi.Env();
using DataFrames;


list_file_hard = readdir("./data/hard_case/Julia_Solvable")
perturbResult_dict = Dict();
run_time_dict = Dict();
inf_case = Dict() #the infeasible perturb case
model_name = []



for itema in list_file_hard

    if occursin(".m", itema)
        network_data = parse_file("./data/hard_case/Julia_Solvable/" * itema)
        load_keys = [i for i in keys(network_data["load"])]
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


        perturbResult_dict[itema] = pmap(ω -> run_Ipopt_para_ac(network_data, load_distrn, load_keys), 1:1000)

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

        inf_case[itema] = Dict("ter_status" => ter_status_itema, "load_info_itema" => load_info_itema)
        push!(model_name, itema)
    end

end

result_cat_dict = Dict("case_name" => model_name, "run_time_distribution" => run_time_dict,
    "infeasible_list" => inf_case)

df_result = DataFrame(result_cat_dict)
CSV.write("result_perturb.csv", df_result, bufsize = 2^29)

