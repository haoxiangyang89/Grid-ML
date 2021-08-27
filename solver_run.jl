function run_diffd_para(network_data, load_distrn, load_keys)
    network_data_new = deepcopy(network_data)
    for i in 1:length(load_keys)
        network_data_new["load"][load_keys[i]]["pd"] += rand(load_distrn[load_keys[i]])
    end
    # run the test with Ipopt
    r_ipopt = run_dc_opf(network_data_new,
                        optimizer_with_attributes(Ipopt.Optimizer, "linear_solver" => "ma27", "print_level" => 0));

    # run the test with Gurobi
    r_gurobi = run_dc_opf(network_data_new,
                        optimizer_with_attributes(() -> Gurobi.Optimizer(GUROBI_ENV),"OutputFlag" => 0));

    if (r_ipopt["termination_status"] == LOCALLY_SOLVED) & (r_gurobi["termination_status"] == OPTIMAL)
        gen_ipopt = Dict();
        for g in keys(network_data["gen"])
            if g in keys(r_ipopt["solution"]["gen"])
                gen_ipopt[g] = r_ipopt["solution"]["gen"][g]["pg"];
            else
                gen_ipopt[g] = 0.0;
            end
        end

        gen_gurobi = Dict();
        for g in keys(network_data["gen"])
            if g in keys(r_gurobi["solution"]["gen"])
                gen_gurobi[g] = r_gurobi["solution"]["gen"][g]["pg"];
            else
                gen_gurobi[g] = 0.0;
            end
        end

        # calculate the difference
        objDiff = [r_ipopt["objective"], r_gurobi["objective"], r_ipopt["objective"] - r_gurobi["objective"]];
        pgDiff = [sum(gen_ipopt[g] for g in keys(network_data_new["gen"])),
                  sum(gen_gurobi[g] for g in keys(network_data_new["gen"])),
                  sum(abs(gen_ipopt[g] - gen_gurobi[g]) for g in keys(network_data_new["gen"]))];
        timeDiff = [r_ipopt["solve_time"], r_gurobi["solve_time"], r_ipopt["solve_time"] - r_gurobi["solve_time"]];
    else
        objDiff = [r_ipopt["termination_status"], r_gurobi["termination_status"]];
        pgDiff = Inf;
        timeDiff = r_ipopt["solve_time"] - r_gurobi["solve_time"];
    end
    return objDiff,pgDiff,timeDiff;
end

function run_diff_solver(filepath,filename)
    try
        fileAdd = filepath*filename;
        network_data = parse_file(fileAdd);

        # run the test with Ipopt
        r_ipopt = run_dc_opf(network_data,
                            optimizer_with_attributes(Ipopt.Optimizer, "linear_solver" => "ma27", "print_level" => 0));

        gen_ipopt = Dict();
        for g in keys(network_data["gen"])
            if g in keys(r_ipopt["solution"]["gen"])
                gen_ipopt[g] = r_ipopt["solution"]["gen"][g]["pg"];
            else
                gen_ipopt[g] = 0.0;
            end
        end

        # run the test with Gurobi
        r_gurobi = run_dc_opf(network_data,
                            optimizer_with_attributes(() -> Gurobi.Optimizer(GUROBI_ENV),"OutputFlag" => 0));

        gen_gurobi = Dict();
        for g in keys(network_data["gen"])
            if g in keys(r_gurobi["solution"]["gen"])
                gen_gurobi[g] = r_gurobi["solution"]["gen"][g]["pg"];
            else
                gen_gurobi[g] = 0.0;
            end
        end

        # calculate the difference
        objDiff = [r_ipopt["objective"], r_gurobi["objective"], r_ipopt["objective"] - r_gurobi["objective"]];
        pgDiff = [sum(gen_ipopt[g] for g in keys(network_data["gen"])),
                  sum(gen_gurobi[g] for g in keys(network_data["gen"])),
                  sum(abs(gen_ipopt[g] - gen_gurobi[g]) for g in keys(network_data["gen"]))
                 ];
        timeDiff = [r_ipopt["solve_time"], r_gurobi["solve_time"], r_ipopt["solve_time"] - r_gurobi["solve_time"]];
        condDiff = [r_ipopt["termination_status"], r_gurobi["termination_status"]];
        return filename, [objDiff, pgDiff, timeDiff, condDiff];
    catch e
        println(filename);
        e
        return filename;
    end
end
