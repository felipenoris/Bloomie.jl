module Bloomie

import Libdl
import DataFrames
import Match
using Printf

#=
export bopen, bclose, bdp, bdh, bbars, bport, beqs

import TimeSeries
import TimeSeriesIO
import AbstractTrees
=#

function __init__()
	check_deps()
end

include("deps.jl")
include("blpapi.jl")
include("session.jl")
include("response.jl")

#=
include("static.jl")
include("historical.jl")
include("intraday.jl")
include("port.jl")
include("screen.jl")
=#

end
