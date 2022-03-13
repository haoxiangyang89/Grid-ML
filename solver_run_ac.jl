function run_Ipopt_para_ac(itema, network_data, load_distrn, load_keys, gen_keys, time_lim)

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


    for i in 1:length(load_keys)
        network_data_new["load"][load_keys[i]]["pd"] += rand(load_distrn[load_keys[i]])
    end

    out_file_name = "./data/perturb_output/" * itema[1:end-2] * "perturb_output" * ".csv"

    # run the test with Ipopt
    r_ipopt = run_ac_opf(network_data_new,
        optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0, "max_wall_time" => time_lim, "file_print_level" => 3,
            "output_file" => out_file_name))


    obj_val = r_ipopt["objective"]
    Optimal = r_ipopt["termination_status"]
    solve_time = r_ipopt["solve_time"]
    primal_feasibility = r_ipopt["primal_status"]
    dual_feasibility = r_ipopt["dual_status"]
    time_limit = time_lim

    # initialize variables
    esti_obj_val = 0
    dual_infeasibility = 0
    constraint_violation = 0
    overall_nlp = 0
    complementarity = 0
    var_bound_violation = 0
    esti_Optimal = 0

    open(out_file_name, "r") do file_object
        for line in eachline(file_object)



            if occursin("Objective...............", line)
                esti_obj_val = line[55:end]
            end

            if occursin("Dual infeasibility....", line)
                dual_infeasibility = line[55:end]
            end


            if occursin("Constraint violation....", line)
                constraint_violation = line[55:end]
            end

            if occursin("Overall NLP error....", line)
                overall_nlp = line[55:end]
            end

            if occursin("Complementarity..", line)
                complementarity = line[55:end]
            end

            if occursin("Variable bound violation", line)
                var_bound_violation = line[55:end]
            end

            if occursin("EXIT:", line)
                esti_Optimal = line[7:end]
            end

        end

    end




    return obj_val, Optimal, solve_time, primal_feasibility, dual_feasibility, time_limit, network_data_new["load"], r_ipopt["solution"]["bus"], r_ipopt["solution"]["gen"], r_ipopt["solution"]["branch"], esti_obj_val, dual_infeasibility, constraint_violation, overall_nlp, complementarity, var_bound_violation,esti_Optimal
end

