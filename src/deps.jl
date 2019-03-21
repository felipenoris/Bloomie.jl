
const blpapi = "C:/blp/DAPI/blpapi3_64.dll"

function check_deps()
    global blpapi
    if !isfile(blpapi)
        error("$(blpapi) does not exist. Please, check blpapi installation.")
    end

    if Libdl.dlopen_e(blpapi) in (C_NULL, nothing)
        error("$(blpapi) cannot be opened. Please, check blpapi installation.")
    end
end
