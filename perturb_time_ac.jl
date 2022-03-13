using Distributed;
addprocs(20);
@everywhere using PowerModels, Gurobi, Ipopt, Random, Distributions;
@everywhere using CSV;
@everywhere include("parse_dict.jl");
@everywhere using DataFrames;

list_file = readdir("./data/")
perturb_file = readdir("./data/perturb/")
gen_data_file = readdir("./data/perturb/perturb_time_data/")
stop_time = Float64[100, 200, 400, 600, 800, 1000] # the time to stop solver
round = [i for i in 1:1000]

case_name = AbstractString[]
objective_value_100 = []
objective_value_200 = []
objective_value_400 = []
objective_value_600 = []
objective_value_800 = []
objective_value_1000 = []
dual_inf_100 = []
dual_inf_200 = []
dual_inf_400 = []
dual_inf_600 = []
dual_inf_800 = []
dual_inf_1000 = []
cv_100 = []
cv_200 = []
cv_400 = []
cv_600 = []
cv_800 = []
cv_1000 = []
nlp_err_100 = []
nlp_err_200 = []
nlp_err_400 = []
nlp_err_600 = []
nlp_err_800 = []
nlp_err_1000 = []

function exist_in_datafile(gen_data_file, itema)
    for time in stop_time
        data_file_name = itema[1:end-2] * "_" * string(time) * ".csv"
        if (data_file_name in gen_data_file) == false
            return false
        end
    end
    return true

end

function exist_perturb_file(perturb_file, itema)
    perturb_data_file = itema[1:end-2] * "_" * "perturb" * ".csv"
    if perturb_data_file in perturb_file
        return true
    end
    return false
end

for itema in list_file
    if occursin(".m", itema) && (itema == "case5.m")
        if exist_perturb_file(perturb_file, itema)
            if (exist_in_datafile(gen_data_file, itema)) == false

                network_data = parse_file("./data/" * itema)

                pd_pro_ls = []

                df = CSV.read("./data/perturb/" * string(itema[1:end-2]) * "_" * "perturb.csv", DataFrame)

                for pd_profile in df[!, "pd"]
                    push!(pd_pro_ls, pd_profile[16:end-1])
                end

                pd_ls = []
                for pd_pro in pd_pro_ls
                    push!(pd_ls, parse2dict(pd_pro))

                end

                for iter in round

                    

                    network_data_new = deepcopy(network_data)

                    gen_keys = [i for i in keys(network_data["gen"])]

                    #relax the inf term
                    for i in 1:length(gen_keys)
                        if network_data_new["gen"][gen_keys[i]]["qmax"] == Inf
                            network_data_new["gen"][gen_keys[i]]["qmax"] = 10^20
                        end

                        if network_data_new["gen"][gen_keys[i]]["qmax"] == -Inf
                            network_data_new["gen"][gen_keys[i]]["qmax"] = -10^20
                        end

                        if network_data_new["gen"][gen_keys[i]]["qmin"] == Inf
                            network_data_new["gen"][gen_keys[i]]["qmin"] = 10^20
                        end

                        if network_data_new["gen"][gen_keys[i]]["qmin"] == -Inf
                            network_data_new["gen"][gen_keys[i]]["qmin"] = -10^20
                        end
                    end

                    if haskey(network_data_new, "dcline")
                        dcline_keys = [i for i in keys(network_data["dcline"])]

                        for i in 1:length(dcline_keys)
                            if network_data_new["dcline"][dcline_keys[i]]["qmaxf"] == Inf
                                network_data_new["dcline"][dcline_keys[i]]["qmaxf"] = 10^20
                            end

                            if network_data_new["dcline"][dcline_keys[i]]["qmaxf"] == -Inf
                                network_data_new["dcline"][dcline_keys[i]]["qmaxf"] = -10^20
                            end

                            if network_data_new["dcline"][dcline_keys[i]]["qmint"] == Inf
                                network_data_new["dcline"][dcline_keys[i]]["qmint"] = 10^20
                            end

                            if network_data_new["dcline"][dcline_keys[i]]["qmint"] == -Inf
                                network_data_new["dcline"][dcline_keys[i]]["qmint"] = -10^20
                            end

                            if network_data_new["dcline"][dcline_keys[i]]["qminf"] == Inf
                                network_data_new["dcline"][dcline_keys[i]]["qminf"] = 10^20
                            end

                            if network_data_new["dcline"][dcline_keys[i]]["qminf"] == -Inf
                                network_data_new["dcline"][dcline_keys[i]]["qminf"] = -10^20
                            end

                            if network_data_new["dcline"][dcline_keys[i]]["qmaxt"] == Inf
                                network_data_new["dcline"][dcline_keys[i]]["qmaxt"] = 10^20
                            end

                            if network_data_new["dcline"][dcline_keys[i]]["qmaxt"] == -Inf
                                network_data_new["dcline"][dcline_keys[i]]["qmaxt"] = -10^20
                            end
                        end
                    end
                    #modify the demand 
                    pd_keys = [i for i in keys(network_data_new["load"])]
                    for key in pd_keys
                        network_data_new["load"][key]["pd"] = pd_ls[iter][parse(Float64, key)]
                    end

                    for time in stop_time
                        push!(case_name, itema)
                        out_file_name = "./data/perturb/perturb_time_data/" * itema[1:end-2] * "_" * string(time) *"_"* string(iter) * ".csv"
                        pmap(ω -> run_ac_opf(network_data_new, optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0, "max_wall_time" => time, "file_print_level" => 3,
                                "output_file" => out_file_name)), 1:1000)
                    
                        open(out_file_name, "r") do file_object
                            for line in eachline(file_object)
                                if occursin("Objective...............", line)
                                    if time == 100
                                        push!(objective_value_100, line[29:50])
                                    end
                    
                                    if time == 200
                                        push!(objective_value_200, line[29:50])
                                    end
                    
                                    if time == 400
                                        push!(objective_value_400, line[29:50])
                                    end
                    
                                    if time == 600
                                        push!(objective_value_600, line[29:50])
                                    end
                    
                                    if time == 800
                                        push!(objective_value_800, line[29:50])
                                    end
                    
                                    if time == 1000
                                        push!(objective_value_1000, line[29:50])
                                    end
                                end
                    
                                if occursin("Dual infeasibility....", line)
                                    if time == 100
                                        push!(dual_inf_100, line[29:50])
                                    end
                    
                                    if time == 200
                                        push!(dual_inf_200, line[29:50])
                                    end
                    
                                    if time == 400
                                        push!(dual_inf_400, line[29:50])
                                    end
                    
                                    if time == 600
                                        push!(dual_inf_600, line[29:50])
                                    end
                    
                                    if time == 800
                                        push!(dual_inf_800, line[29:50])
                                    end
                    
                                    if time == 1000
                                        push!(dual_inf_1000, line[29:50])
                                    end
                                end
                    
                    
                                if occursin("Constraint violation....", line)
                                    if time == 100
                                        push!(cv_100, line[29:50])
                                    end
                    
                                    if time == 200
                                        push!(cv_200, line[29:50])
                                    end
                    
                                    if time == 400
                                        push!(cv_400, line[29:50])
                                    end
                    
                                    if time == 600
                                        push!(cv_600, line[29:50])
                                    end
                    
                                    if time == 800
                                        push!(cv_800, line[29:50])
                                    end
                    
                                    if time == 1000
                                        push!(cv_1000, line[29:50])
                                    end
                                end
                    
                                if occursin("Overall NLP error....", line)
                                    if time == 100
                                        push!(nlp_err_100, line[29:50])
                                    end
                    
                                    if time == 200
                                        push!(nlp_err_200, line[29:50])
                                    end
                    
                                    if time == 400
                                        push!(nlp_err_400, line[29:50])
                                    end
                    
                                    if time == 600
                                        push!(nlp_err_600, line[29:50])
                                    end
                    
                                    if time == 800
                                        push!(nlp_err_800, line[29:50])
                                    end
                    
                                    if time == 1000
                                        push!(nlp_err_1000, line[29:50])
                                    end
                                end
                    
                            end
                        end
                    
                    end
                end
            end
        end
    end
end

dict_cat = Dict("case_name" => case_name, "obj_100" => objective_value_100, "obj_200" => objective_value_200, "obj_400" => objective_value_400,
    "obj_600" => objective_value_600, "obj_800" => objective_value_800, "obj_1000" => objective_value_1000, "dual_inf_100" => dual_inf_100, "dual_inf_200" => dual_inf_200,
    "dual_inf_400" => dual_inf_400, "dual_inf_600" => dual_inf_600, "dual_inf_800" => dual_inf_800, "dual_inf_1000" => dual_inf_1000, "cv_100" => cv_100, "cv_200" => cv_200,
    "cv_400" => cv_400, "cv_600" => cv_600, "cv_800" => cv_800, "cv_1000" => cv_1000, "nlp_err_100" => nlp_err_100, "nlp_err_200" => nlp_err_200,
    "nlp_err_400" => nlp_err_400, "nlp_err_600" => nlp_err_600, "nlp_err_800" => nlp_err_800, "nlp_err_1000" => nlp_err_1000)

df_result = DataFrame(dict_cat)
CSV.write("result_perturb_time.csv", df_result, bufsize = 2^30)