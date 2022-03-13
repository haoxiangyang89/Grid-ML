function sol_min(result, df_result)

    

    for bus_key in [i for i in keys(result["solution"]["bus"])]

        va_key = "va" * "_" * bus_key
        va_value = []
        push!(va_value, string(result["solution"]["bus"][bus_key]["va"]))


        vm_key = "vm" * "_" * bus_key
        vm_value = []
        push!(vm_value, string(result["solution"]["bus"][bus_key]["vm"]))

        df_result[!, va_key] = va_value
        df_result[!, vm_key] = vm_value

    end

    for gen_key in [i for i in keys(result["solution"]["gen"])]

        qg_key = "qg" * "_" * gen_key
        qg_value = []
        push!(qg_value, string(result["solution"]["gen"][gen_key]["qg"]))

        pg_key = "pg" * "_" * gen_key
        pg_value = []
        push!(pg_value, string(result["solution"]["gen"][gen_key]["pg"]))

        df_result[!, qg_key] = qg_value
        df_result[!, pg_key] = pg_value
        

    end

    for branch_key in [i for i in keys(result["solution"]["branch"])]
        qf_key = "qf" * "_" * branch_key
        qf_value = []
        push!(qf_value, string(result["solution"]["branch"][branch_key]["qf"]))
    
        qt_key = "qt" * "_" * branch_key
        qt_value = []
        push!(qt_value, string(result["solution"]["branch"][branch_key]["qt"]))
    
        pf_key = "pf" * "_" * branch_key
        pf_value = []
        push!(pf_value, string(result["solution"]["branch"][branch_key]["pf"]))
    
        pt_key = "pt" * "_" * branch_key
        pt_value = []
        push!(pt_value, string(result["solution"]["branch"][branch_key]["pt"]))

        df_result[!, qf_key] = qf_value
        df_result[!, qt_key] = qt_value
        df_result[!, pf_key] = pf_value
        df_result[!, pt_key] = pt_value
    
    end



end