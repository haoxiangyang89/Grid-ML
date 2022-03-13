using PowerModels, Ipopt, Gurobi
using CSV;
using DataFrames;
using JuMP
include("sol_min.jl");

list_file = readdir("./data/")
normal_data = readdir("./data/normal")

function in_normal_data(normal_data, itema)

    file_name = itema[1:end-2] * ".csv"
    if (file_name in normal_data) == false
        return false
    end

    return true

end


for itema in list_file
    if occursin(".m", itema) && (!in_normal_data(normal_data, itema))
    
        print(itema)
    
        case_name = AbstractString[]
        obj_val = Float64[]
        time_limit = Float64[]
        solve_time = Float64[]
        Optimal = []
        dual_feasibility = []
        primal_feasibility = []
    
        out_file_name = "./data/normal/" * itema[1:end-2] * ".csv"
    
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
            optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 3, "max_cpu_time" => 3000.0))
    
        push!(case_name, itema[1:end-2])
        push!(solve_time, result["solve_time"])
        push!(Optimal, result["termination_status"])
        push!(primal_feasibility, result["primal_status"])
        push!(dual_feasibility, result["dual_status"])
        push!(obj_val, result["objective"])
        push!(time_limit, 3000.0)
    
        df_result = DataFrame()
    
        df_result[!, "case_name"] = case_name
        df_result[!, "solve_time"] = solve_time
        df_result[!, "Optimal"] = Optimal
        df_result[!, "primal_feasibility"] = primal_feasibility
        df_result[!, "dual_feasibility"] = dual_feasibility
        df_result[!, "obj_val"] = obj_val
        df_result[!, "time_limit"] = time_limit
    
        sol_min(result, df_result)
    
        CSV.write(out_file_name, df_result, bufsize = 2^29)
    end
end






