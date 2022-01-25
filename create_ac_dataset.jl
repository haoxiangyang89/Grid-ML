using PowerModels, Ipopt, Gurobi
using CSV;
using DataFrames;
using JuMP

list_file = readdir("./data/")
case_name = AbstractString[]
case_obj = Float64[]
case_solve_time = Float64[]
case_ter_status = TerminationStatusCode[]
case_dual_status = ResultStatusCode[]
case_primal_status = ResultStatusCode[]
case_obj_lb = Float64[]
case_solution = []



for itema in list_file
    if occursin(".m", itema)
        # result = run_opf(data_path * itema, ACPPowerModel, solver)

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




        result = run_ac_opf(network_data_new,
            optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0, "max_wall_time" => 4000.0))
        push!(case_name, itema)
        push!(case_solve_time, result["solve_time"])
        push!(case_ter_status, result["termination_status"])
        push!(case_primal_status, result["primal_status"])
        push!(case_dual_status, result["dual_status"])
        push!(case_obj, result["objective"])
        push!(case_obj_lb, result["objective_lb"])
        push!(case_solution, result["solution"])
    end
end

dict_cat = Dict("case_name" => case_name, "solve_time" => case_solve_time, "termination_status" => case_ter_status, "dual_status" => case_dual_status,
    "primal_status" => case_primal_status, "objective" => case_obj, "objective_lb" => case_obj_lb, "solution" => case_solution)

df_result = DataFrame(dict_cat)
CSV.write("result_cat.csv", df_result, bufsize = 2^29)

