# perturb ac for large test cases
using Distributed;
addprocs(30);
@everywhere using JuMP, PowerModels, Gurobi, Ipopt, Random, Distributions;
@everywhere using CSV;
@everywhere include("solver_run_ac.jl");
@everywhere const GUROBI_ENV = Gurobi.Env();
@everywhere using DataFrames;


list_file = readdir("./data/");
perturbed_file = readdir("./data/perturb/");

perturbResult_dict = Dict();
run_time_dict = Dict();
inf_case = Dict();

println("Number of processes: ", nprocs())
println("Number of workers: ", nworkers())

function exist_perturb_file(perturbed_file, itema)
    perturb_data_file = itema[1:end-2] * "_" * "perturb" * ".csv"
    if perturb_data_file in perturbed_file
        return true
    end
    return false
end

function compile_ipopt()
    mp = Model(Ipopt.Optimizer);
    @variable(mp, x1 >= 0);
    @variable(mp, x2 >= 0);
    @constraint(mp, x1 + 2x2 <= 1);
    @constraint(mp, 2x1 + x2 <= 1);
    @objective(mp, Max, x1 + x2);
    optimize!(mp);
end
pmap(ω -> compile_ipopt(), 1:nprocs())

# read in the hyper parameters for testing
m_file = ARGS[1];
σ = parse(Float64, ARGS[2]);
n = parse(Int64, ARGS[3]);
index = parse(Int64, ARGS[4]);
time_lim = parse(Float64, ARGS[5]);

case_name = AbstractString[]
obj_val = Float64[]
time_limit = Float64[]
solve_time = Float64[]
Optimal = []
dual_feasibility = []
primal_feasibility = []
esti_obj_val = []
dual_infeasibility = []
constraint_violation = []
overall_nlp = []
complementarity = []
var_bound_violation = []
esti_Optimal = []

network_data = parse_file("./data/" * m_file)
load_keys = [i for i in keys(network_data["load"])]
branch_keys = [i for i in keys(network_data["branch"])]
gen_keys = [i for i in keys(network_data["gen"])]
bus_keys = [i for i in keys(network_data["bus"])]
σ_load = Dict()
load_distrn = Dict()

for i in 1:length(load_keys)
    if network_data["load"][load_keys[i]]["pd"] != 0
        σ_load[load_keys[i]] = abs(network_data["load"][load_keys[i]]["pd"] * σ)
        load_distrn[load_keys[i]] = Normal(0, σ_load[load_keys[i]])
    else
        σ_load[load_keys[i]] = 0
        load_distrn[load_keys[i]] = Uniform(0, 0.0000001)
    end
end

va_dict = Dict()
vm_dict = Dict()
for bus_key in keys(network_data["bus"])
    va_key = "va" * "_" * bus_key
    va_value = []

    vm_key = "vm" * "_" * bus_key
    vm_value = []

    va_dict[va_key] = va_value
    vm_dict[vm_key] = vm_value
end

qg_dict = Dict()
pg_dict = Dict()
for gen_key in keys(network_data["gen"])
    qg_key = "qg" * "_" * gen_key
    qg_value = []

    pg_key = "pg" * "_" * gen_key
    pg_value = []

    qg_dict[qg_key] = qg_value
    pg_dict[pg_key] = pg_value
end


qf_dict = Dict()
qt_dict = Dict()
pf_dict = Dict()
pt_dict = Dict()
for branch_key in keys(network_data["branch"])
    qf_key = "qf" * "_" * branch_key
    qf_value = []

    qt_key = "qt" * "_" * branch_key
    qt_value = []

    pf_key = "pf" * "_" * branch_key
    pf_value = []

    pt_key = "pt" * "_" * branch_key
    pt_value = []

    pf_dict[pf_key] = pf_value
    pt_dict[pt_key] = pt_value
    qt_dict[qt_key] = qt_value
    qf_dict[qf_key] = qf_value

end

pd_dict = Dict()
qd_dict = Dict()
for load_key in keys(network_data["load"])
    pd_key = "pd" * "_" * load_key
    pd_value = []

    qd_key = "qd" * "_" * load_key
    qd_value = []

    pd_dict[pd_key] = pd_value
    qd_dict[qd_key] = qd_value

end

pd_perturb_list = []
qd_perturb_list = []

perturbResult_dict = pmap(ω -> run_Ipopt_para_ac(ω, m_file, network_data, load_distrn, load_keys, gen_keys, time_lim), 1:n)

iterNo = 0;
for profile in perturbResult_dict

    global iterNo = iterNo + 1;

    pd_dict_profile = Dict()

    case_name_r = m_file * "_" * string(iterNo)
    push!(case_name, case_name_r)
    push!(obj_val, profile[1])
    push!(Optimal, profile[2])
    push!(solve_time, profile[3])
    push!(primal_feasibility, profile[4])
    push!(dual_feasibility, profile[5])
    push!(time_limit, profile[6])
    push!(esti_obj_val, profile[11])
    push!(dual_infeasibility, profile[12])
    push!(constraint_violation, profile[13])
    push!(overall_nlp, profile[14])
    push!(complementarity, profile[15])
    push!(var_bound_violation, profile[16])
    push!(esti_Optimal, profile[17])

    for branch_key in [i for i in keys(profile[10])]
        qf_key = "qf" * "_" * branch_key
        push!(qf_dict[qf_key], string(profile[10][branch_key]["qf"]))

        qt_key = "qt" * "_" * branch_key
        push!(qt_dict[qt_key], string(profile[10][branch_key]["qt"]))

        pf_key = "pf" * "_" * branch_key
        push!(pf_dict[pf_key], string(profile[10][branch_key]["pf"]))

        pt_key = "pt" * "_" * branch_key
        push!(pt_dict[pt_key], string(profile[10][branch_key]["pt"]))

    end

    for gen_key in [i for i in keys(profile[9])]
        qg_key = "qg" * "_" * gen_key
        push!(qg_dict[qg_key], string(profile[9][gen_key]["qg"]))

        pg_key = "pg" * "_" * gen_key
        push!(pg_dict[pg_key], string(profile[9][gen_key]["pg"]))

    end

    for bus_key in [i for i in keys(profile[8])]

        va_key = "va" * "_" * bus_key
        push!(va_dict[va_key], string(profile[8][bus_key]["va"]))


        vm_key = "vm" * "_" * bus_key
        push!(vm_dict[vm_key], string(profile[8][bus_key]["vm"]))
    end

    pd_dict_profile = Dict()
    qd_dict_profile = Dict()
    for load_key in [i for i in keys(profile[7])]
        pd_key = "pd" * "_" * load_key
        qd_key = "qd" * "_" * load_key
        push!(pd_dict[pd_key], string(profile[7][load_key]["pd"]))
        push!(qd_dict[qd_key], string(profile[7][load_key]["qd"]))
        pd_dict_profile[load_key] = profile[7][load_key]["pd"]
        qd_dict_profile[load_key] = profile[7][load_key]["qd"]
    end
    push!(pd_perturb_list, pd_dict_profile)
    push!(qd_perturb_list, qd_dict_profile)

end

result = DataFrame()
result[!, "case_name"] = case_name
result[!, "obj_val"] = obj_val
result[!, "solve_time"] = solve_time
result[!, "Optimal"] = Optimal
result[!, "primal_feasibility"] = primal_feasibility
result[!, "dual_feasibility"] = dual_feasibility
result[!, "obj_val"] = obj_val
result[!, "time_limit"] = time_limit
result[!, "esti_obj_val"] = esti_obj_val
result[!, "dual_infeasibility"] = dual_infeasibility
result[!, "constraint_violation"] = constraint_violation
result[!, "overall_nlp"] = overall_nlp
result[!, "complementarity"] = complementarity
result[!, "var_bound_violation"] = var_bound_violation
result[!, "esti_Optimal"] = esti_obj_val

for va_key in keys(va_dict)
    result[!, va_key] = va_dict[va_key]
end

for vm_key in keys(vm_dict)
    result[!, vm_key] = vm_dict[vm_key]
end

for pg_key in keys(pg_dict)
    if length(pg_dict[pg_key]) != 0
        result[!, pg_key] = pg_dict[pg_key]
    end
end

for qg_key in keys(qg_dict)
    if length(qg_dict[qg_key]) != 0
        result[!, qg_key] = qg_dict[qg_key]
    end
end

for pf_key in keys(pf_dict)
    result[!, pf_key] = pf_dict[pf_key]
end

for pt_key in keys(pt_dict)
    result[!, pt_key] = pt_dict[pt_key]
end

for qf_key in keys(qf_dict)
    result[!, qf_key] = qf_dict[qf_key]
end

for qt_key in keys(qt_dict)
    result[!, qt_key] = qt_dict[qt_key]
end

for pd_key in keys(pd_dict)
    result[!, pd_key] = pd_dict[pd_key]
end

for qd_key in keys(qd_dict)
    result[!, qd_key] = qd_dict[qd_key]
end

CSV.write("./data/perturb/$(m_file[1:end-2])_perturb_$(time_lim)_$(σ)_$(index).csv", result, bufsize = 2^31)

perturbResult_dict_ntl = pmap(ω -> run_ac_noTimeLim(ω, m_file, network_data, load_keys, gen_keys, pd_perturb_list[ω], qd_perturb_list[ω]), 1:n)

iterNo = 0;
for profile in perturbResult_dict_ntl

    global iterNo = iterNo + 1;

    pd_dict_profile = Dict()

    case_name_r = m_file * "_" * string(iterNo)
    push!(case_name, case_name_r)
    push!(obj_val, profile[1])
    push!(Optimal, profile[2])
    push!(solve_time, profile[3])
    push!(primal_feasibility, profile[4])
    push!(dual_feasibility, profile[5])
    push!(time_limit, profile[6])
    push!(esti_obj_val, profile[11])
    push!(dual_infeasibility, profile[12])
    push!(constraint_violation, profile[13])
    push!(overall_nlp, profile[14])
    push!(complementarity, profile[15])
    push!(var_bound_violation, profile[16])
    push!(esti_Optimal, profile[17])

    for branch_key in [i for i in keys(profile[10])]
        qf_key = "qf" * "_" * branch_key
        push!(qf_dict[qf_key], string(profile[10][branch_key]["qf"]))

        qt_key = "qt" * "_" * branch_key
        push!(qt_dict[qt_key], string(profile[10][branch_key]["qt"]))

        pf_key = "pf" * "_" * branch_key
        push!(pf_dict[pf_key], string(profile[10][branch_key]["pf"]))

        pt_key = "pt" * "_" * branch_key
        push!(pt_dict[pt_key], string(profile[10][branch_key]["pt"]))

    end

    for gen_key in [i for i in keys(profile[9])]
        qg_key = "qg" * "_" * gen_key
        push!(qg_dict[qg_key], string(profile[9][gen_key]["qg"]))

        pg_key = "pg" * "_" * gen_key
        push!(pg_dict[pg_key], string(profile[9][gen_key]["pg"]))

    end

    for bus_key in [i for i in keys(profile[8])]

        va_key = "va" * "_" * bus_key
        push!(va_dict[va_key], string(profile[8][bus_key]["va"]))


        vm_key = "vm" * "_" * bus_key
        push!(vm_dict[vm_key], string(profile[8][bus_key]["vm"]))
    end

    pd_dict_profile = Dict()
    qd_dict_profile = Dict()
    for load_key in [i for i in keys(profile[7])]
        pd_key = "pd" * "_" * load_key
        qd_key = "qd" * "_" * load_key
        push!(pd_dict[pd_key], string(profile[7][load_key]["pd"]))
        push!(qd_dict[qd_key], string(profile[7][load_key]["qd"]))
        pd_dict_profile[load_key] = profile[7][load_key]["pd"]
        qd_dict_profile[load_key] = profile[7][load_key]["qd"]
    end
    push!(pd_perturb_list, pd_dict_profile)
    push!(qd_perturb_list, qd_dict_profile)

end

result = DataFrame()
result[!, "case_name"] = case_name
result[!, "obj_val"] = obj_val
result[!, "solve_time"] = solve_time
result[!, "Optimal"] = Optimal
result[!, "primal_feasibility"] = primal_feasibility
result[!, "dual_feasibility"] = dual_feasibility
result[!, "obj_val"] = obj_val
result[!, "time_limit"] = time_limit
result[!, "esti_obj_val"] = esti_obj_val
result[!, "dual_infeasibility"] = dual_infeasibility
result[!, "constraint_violation"] = constraint_violation
result[!, "overall_nlp"] = overall_nlp
result[!, "complementarity"] = complementarity
result[!, "var_bound_violation"] = var_bound_violation
result[!, "esti_Optimal"] = esti_obj_val

for va_key in keys(va_dict)
    result[!, va_key] = va_dict[va_key]
end

for vm_key in keys(vm_dict)
    result[!, vm_key] = vm_dict[vm_key]
end

for pg_key in keys(pg_dict)
    if length(pg_dict[pg_key]) != 0
        result[!, pg_key] = pg_dict[pg_key]
    end
end

for qg_key in keys(qg_dict)
    if length(qg_dict[qg_key]) != 0
        result[!, qg_key] = qg_dict[qg_key]
    end
end

for pf_key in keys(pf_dict)
    result[!, pf_key] = pf_dict[pf_key]
end

for pt_key in keys(pt_dict)
    result[!, pt_key] = pt_dict[pt_key]
end

for qf_key in keys(qf_dict)
    result[!, qf_key] = qf_dict[qf_key]
end

for qt_key in keys(qt_dict)
    result[!, qt_key] = qt_dict[qt_key]
end

for pd_key in keys(pd_dict)
    result[!, pd_key] = pd_dict[pd_key]
end

for qd_key in keys(qd_dict)
    result[!, qd_key] = qd_dict[qd_key]
end

CSV.write("./data/perturb/$(m_file[1:end-2])_perturb_$(time_lim)_$(σ)_$(index)_ntl.csv", result, bufsize = 2^31)
