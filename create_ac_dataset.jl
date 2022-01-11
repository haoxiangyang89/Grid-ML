using PowerModels, Ipopt, Gurobi
using CSV;
using DataFrames;
using JuMP

list_file = readdir("./data/hard_case/Julia_Solvable")
solver = optimizer_with_attributes(Ipopt.Optimizer, "tol" => 1e-6)
case_name = AbstractString[]
case_obj = Float64[]
case_solve_time = Float64[]
case_ter_status = TerminationStatusCode[]
case_dual_status = ResultStatusCode[]
case_primal_status = ResultStatusCode[]
case_obj_lb = Float64[]
case_solution = []




for itema in list_file
    if occursin("case", itema)
        # result = run_opf(data_path * itema, ACPPowerModel, solver)
        result = run_ac_opf("./data/hard_case/Julia_Solvable/" * itema, Ipopt.Optimizer)
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

#for Gurobi solver
# # obtain the numerical issue cases
# for iKey in keys(result_ter_cat)
#     if result_ter_cat[iKey] == NUMERICAL_ERROR
#         push!(NumList, iKey)
#     end
# end
# # numerical issues are mostly caused by infeasibility as well

# for iKey in keys(result_ter_cat)
#     if result_ter_cat[iKey] == OPTIMAL
#         push!(OptList, iKey)
#     end
# end

# for iKey in keys(result_ter_cat)
#     if result_ter_cat[iKey] == INFEASIBLE
#         push!(InfeasList, iKey)
#     end
# end

dict_cat = Dict("case_name" => case_name, "solve_time" => case_solve_time, "termination_status" => case_ter_status, "dual_status" => case_dual_status,
    "primal_status" => case_primal_status, "objective" => case_obj, "objective_lb" => case_obj_lb, "solution" => case_solution)

df_result = DataFrame(dict_cat)
CSV.write("result.csv", df_result, bufsize = 2^26)

