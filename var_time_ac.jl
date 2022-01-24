using PowerModels, Ipopt, Gurobi
using CSV;
using DataFrames;
using JuMP

list_file = readdir("./data/")
stop_time = Float64[100, 200, 400, 600, 800, 1000] # the time to stop solver
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

for itema in list_file
        if occursin(".m", itema)
                push!(case_name, itema)
        for time in stop_time
                out_file_name = "./data/gen_time_data/" * itema[1:end-2] * "_" * string(time) * ".csv"
        
        
                network_data = parse_file("./data/" * itema)
                gen_keys = [i for i in keys(network_data["gen"])]
        
                network_data_new = deepcopy(network_data)
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
        
                run_ac_opf(network_data_new,
                        optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0, "max_wall_time" => time,
                                "file_print_level" => 3,
                                "output_file" => out_file_name))
        
        
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

dict_cat = Dict("case_name" => case_name, "obj_100" => objective_value_100, "obj_200" => objective_value_200, "obj_400" => objective_value_400,
        "obj_600" => objective_value_600, "obj_800" => objective_value_800, "obj_1000" => objective_value_1000, "dual_inf_100" => dual_inf_100, "dual_inf_200" => dual_inf_200,
        "dual_inf_400" => dual_inf_400, "dual_inf_600" => dual_inf_600, "dual_inf_800" => dual_inf_800, "dual_inf_1000" => dual_inf_1000, "cv_100" => cv_100, "cv_200" => cv_200,
        "cv_400" => cv_400, "cv_600" => cv_600, "cv_800" => cv_800, "cv_1000" => cv_1000, "nlp_err_100" => nlp_err_100, "nlp_err_200" => nlp_err_200,
        "nlp_err_400" => nlp_err_400, "nlp_err_600" => nlp_err_600, "nlp_err_800" => nlp_err_800, "nlp_err_1000" => nlp_err_1000)

df_result = DataFrame(dict_cat)
CSV.write("result_time.csv", df_result, bufsize = 2^30)



