function run_Ipopt_para_ac(network_data, load_distrn, load_keys, gen_keys)

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

    for i in 1:length(load_keys)
            network_data_new["load"][load_keys[i]]["pd"] += rand(load_distrn[load_keys[i]])
    end
    # run the test with Ipopt
    r_ipopt = run_ac_opf(network_data_new,
        optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0, "max_cpu_time" => 2000.0))

    if (r_ipopt["termination_status"] == LOCALLY_SOLVED)
        gen_ipopt = Dict()
        for g in keys(network_data["gen"])
            if g in keys(r_ipopt["solution"]["gen"])
                gen_ipopt[g] = r_ipopt["solution"]["gen"][g]["pg"]
            else
                gen_ipopt[g] = 0.0
            end
        end


        obj_ac = r_ipopt["objective"]
        pg_sum_ac = sum(gen_ipopt[g] for g in keys(network_data_new["gen"]))
        time_ac = r_ipopt["solve_time"]

    else
        obj_ac = r_ipopt["termination_status"]
        pg_sum_ac = Inf
        time_ac = r_ipopt["solve_time"]
    end

    return obj_ac, pg_sum_ac, time_ac, network_data_new["load"]
end

