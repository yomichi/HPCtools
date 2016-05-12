#!/home/i0014/i001400/opt/julia/bin/julia

include("parallel_detail.jl")

function addnodes()
    nodefile = get(ENV,"PBS_NODEFILE","")
    if !ispath(nodefile)
        error("nodefile ($nodefile) does not exist.")
    end
    nodes = Tuple{ASCIIString,Int}[(n,24) for n in split(readall(`sort -u $nodefile`))]
    if length(nodes) == 1
        ps = addprocs()
    else
        ps = addprocs(nodes)
    end
    @sync for p in procs()
        @async remotecall_fetch(p, include, "parallel_detail.jl")
    end
    return ps
end
