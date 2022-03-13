using PowerModels, Ipopt, Gurobi
using CSV;
using DataFrames;
using JuMP


list_file = readdir("./data/")
gen_data_file = readdir("./data/gen_time_data/")
output_file = readdir("./data/variant_time/")
stop_time = Float64[100, 200, 400, 600, 800, 1000] # the time to stop solver


# function exist_in_datafile(gen_data_file, itema)
#         for time in stop_time
#                 data_file_name = itema[1:end-2] * "_" * string(time) * ".csv"
#                 if (data_file_name in gen_data_file) == false
#                         return false
#                 end
#         end
#         return true

# end


for itema in list_file
        if occursin(".m", itema)
                print(itema)
        
                case_name = AbstractString[]
                obj_val = []
                time_limit = stop_time
                solve_time = []
                Optimal = []
                dual_feasibility = []
                constraint_violation = []
                var_bound_violation = []
                complementarity = []
                overall_nlp = []
        
                df_result = DataFrame()
                df_solution = DataFrame()
        
                out_file_name = "./data/variant_time/" * itema[1:end-2] * "_" * "time" * ".csv"
        
                for time in stop_time
        
                        pre_out_file_name = "./data/gen_time_data/" * itema[1:end-2] * "_" * string(time) * ".csv"
        
                        open(pre_out_file_name, "r") do file_object
                                for line in eachline(file_object)
        
        
        
                                        if occursin("Objective...............", line)
                                                push!(obj_val, line[29:50])
                                                case_name_time = itema[1:end-2] * "_" * string(time)
                                                push!(case_name, case_name_time)
                                        end
        
                                        if occursin("Dual infeasibility....", line)
                                                push!(dual_feasibility, line[29:50])
                                        end
        
        
                                        if occursin("Constraint violation....", line)
                                                push!(constraint_violation, line[29:50])
                                        end
        
                                        if occursin("Overall NLP error....", line)
                                                push!(overall_nlp, line[29:50])
        
                                        end
        
                                        if occursin("Complementarity..", line)
                                                push!(complementarity, line[29:50])
                                        end
        
                                        if occursin("Variable bound violation", line)
                                                push!(var_bound_violation, line[29:50])
                                        end
        
                                        if occursin("EXIT:", line)
                                                push!(Optimal, line[7:end])
                                        end
        
                                        if occursin("Total seconds", line)
                                                push!(solve_time, line[56:end])
                                        end
        
                                end
        
                        end
        
                end
        
                df_result[!, "case_name"] = case_name
                df_result[!, "solve_time"] = solve_time
                df_result[!, "Optimal"] = Optimal
                df_result[!, "dual_feasibility"] = dual_feasibility
                df_result[!, "obj_val"] = obj_val
                df_result[!, "time_limit"] = time_limit
                df_result[!, "overall_nlp"] = overall_nlp
                df_result[!, "constraint_violation"] = constraint_violation
                df_result[!, "var_bound_violation"] = var_bound_violation
                df_result[!, "complementarity"] = complementarity
        
        
        
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
        
        
                result_100 = run_ac_opf(network_data_new,
                        optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 3, "max_wall_time" => 100.0))
        
                result_200 = run_ac_opf(network_data_new,
                        optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 3, "max_wall_time" => 200.0))
        
                result_400 = run_ac_opf(network_data_new,
                        optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 3, "max_wall_time" => 400.0))
        
                result_600 = run_ac_opf(network_data_new,
                        optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 3, "max_wall_time" => 600.0))
        
                result_800 = run_ac_opf(network_data_new,
                        optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 3, "max_wall_time" => 800.0))
        
                result_1000 = run_ac_opf(network_data_new,
                        optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 3, "max_wall_time" => 1000.0))
        
        
                for bus_key in [i for i in keys(result_100["solution"]["bus"])]
                        va_key = "va" * "_" * bus_key
                        va_value = []
                        push!(va_value, string(result_100["solution"]["bus"][bus_key]["va"]))
                        push!(va_value, string(result_200["solution"]["bus"][bus_key]["va"]))
                        push!(va_value, string(result_400["solution"]["bus"][bus_key]["va"]))
                        push!(va_value, string(result_600["solution"]["bus"][bus_key]["va"]))
                        push!(va_value, string(result_800["solution"]["bus"][bus_key]["va"]))
                        push!(va_value, string(result_1000["solution"]["bus"][bus_key]["va"]))
        
                        vm_key = "vm" * "_" * bus_key
                        vm_value = []
                        push!(vm_value, string(result_100["solution"]["bus"][bus_key]["vm"]))
                        push!(vm_value, string(result_200["solution"]["bus"][bus_key]["vm"]))
                        push!(vm_value, string(result_400["solution"]["bus"][bus_key]["vm"]))
                        push!(vm_value, string(result_600["solution"]["bus"][bus_key]["vm"]))
                        push!(vm_value, string(result_800["solution"]["bus"][bus_key]["vm"]))
                        push!(vm_value, string(result_1000["solution"]["bus"][bus_key]["vm"]))
        
                        df_result[!, va_key] = va_value
                        df_result[!, vm_key] = vm_value
        
                end
        
                for gen_key in [i for i in keys(result_100["solution"]["gen"])]
                        qg_key = "qg" * "_" * gen_key
                        qg_value = []
                        push!(qg_value, string(result_100["solution"]["gen"][gen_key]["qg"]))
                        push!(qg_value, string(result_200["solution"]["gen"][gen_key]["qg"]))
                        push!(qg_value, string(result_400["solution"]["gen"][gen_key]["qg"]))
                        push!(qg_value, string(result_600["solution"]["gen"][gen_key]["qg"]))
                        push!(qg_value, string(result_800["solution"]["gen"][gen_key]["qg"]))
                        push!(qg_value, string(result_1000["solution"]["gen"][gen_key]["qg"]))
        
                        pg_key = "pg" * "_" * gen_key
                        pg_value = []
                        push!(pg_value, string(result_100["solution"]["gen"][gen_key]["pg"]))
                        push!(pg_value, string(result_200["solution"]["gen"][gen_key]["pg"]))
                        push!(pg_value, string(result_400["solution"]["gen"][gen_key]["pg"]))
                        push!(pg_value, string(result_600["solution"]["gen"][gen_key]["pg"]))
                        push!(pg_value, string(result_800["solution"]["gen"][gen_key]["pg"]))
                        push!(pg_value, string(result_1000["solution"]["gen"][gen_key]["pg"]))
        
                        df_result[!, qg_key] = qg_value
                        df_result[!, pg_key] = pg_value
        
                end

                for branch_key in [i for i in keys(result_100["solution"]["branch"])]
                        qf_key = "qf" * "_" * branch_key
                        qf_value = []
                        push!(qf_value, string(result_100["solution"]["branch"][branch_key]["qf"]))
                        push!(qf_value, string(result_200["solution"]["branch"][branch_key]["qf"]))
                        push!(qf_value, string(result_100["solution"]["branch"][branch_key]["qf"]))
                        push!(qf_value, string(result_100["solution"]["branch"][branch_key]["qf"]))
                        push!(qf_value, string(result_100["solution"]["branch"][branch_key]["qf"]))
                        push!(qf_value, string(result_100["solution"]["branch"][branch_key]["qf"]))
                
                
                        qt_key = "qt" * "_" * branch_key
                        qt_value = []
                        push!(qt_value, string(result_100["solution"]["branch"][branch_key]["qt"]))
                        push!(qt_value, string(result_200["solution"]["branch"][branch_key]["qt"]))
                        push!(qt_value, string(result_400["solution"]["branch"][branch_key]["qt"]))
                        push!(qt_value, string(result_600["solution"]["branch"][branch_key]["qt"]))
                        push!(qt_value, string(result_800["solution"]["branch"][branch_key]["qt"]))
                        push!(qt_value, string(result_1000["solution"]["branch"][branch_key]["qt"]))
                
                        pf_key = "pf" * "_" * branch_key
                        pf_value = []
                        push!(pf_value, string(result_100["solution"]["branch"][branch_key]["pf"]))
                        push!(pf_value, string(result_200["solution"]["branch"][branch_key]["pf"]))
                        push!(pf_value, string(result_400["solution"]["branch"][branch_key]["pf"]))
                        push!(pf_value, string(result_600["solution"]["branch"][branch_key]["pf"]))
                        push!(pf_value, string(result_800["solution"]["branch"][branch_key]["pf"]))
                        push!(pf_value, string(result_1000["solution"]["branch"][branch_key]["pf"]))
                
                        pt_key = "pt" * "_" * branch_key
                        pt_value = []
                        push!(pt_value, string(result_100["solution"]["branch"][branch_key]["pt"]))
                        push!(pt_value, string(result_200["solution"]["branch"][branch_key]["pt"]))
                        push!(pt_value, string(result_400["solution"]["branch"][branch_key]["pt"]))
                        push!(pt_value, string(result_600["solution"]["branch"][branch_key]["pt"]))
                        push!(pt_value, string(result_800["solution"]["branch"][branch_key]["pt"]))
                        push!(pt_value, string(result_1000["solution"]["branch"][branch_key]["pt"]))
                
                        df_result[!, qf_key] = qf_value
                        df_result[!, qt_key] = qt_value
                        df_result[!, pf_key] = pf_value
                        df_result[!, pt_key] = pt_value
                
                end
        
        
        
        
        
                CSV.write(out_file_name, df_result, bufsize = 2^30)
        
        end
end






