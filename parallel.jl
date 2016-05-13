#!/usr/bin/env julia

const detail_script_path = joinpath(dirname(@__FILE__()), "detail",  "parallel_worker.jl")

include(detail_script_path)

function addnodes()
    nodefile = get(ENV,"PBS_NODEFILE","")
    if !ispath(nodefile)
        error("nodefile ($nodefile) does not exist.")
    end
    nodes = Tuple{ASCIIString,Int}[(n,24) for n in split(readall(`sort -u $nodefile`))]
    if length(nodes) == 1
        ps = addprocs(topology=:master_slave)
    else
        ps = addprocs(nodes, topology=:master_slave)
    end
    @sync for p in ps
        @async remotecall_fetch(p, include, detail_script_path)
    end
    return ps
end

function makejobs(jobfile)
    jobs = Job[]
    pbs_id = parse(Int, split(ENV["PBS_JOBID"], ".")[1])
    io = open(jobfile)
    for (jobid, line) in enumerate(eachline(io))
        push!(jobs, Job(line, jobid, pbs_id))
    end
    close(io)
    return jobs
end

if length(ARGS) != 1 
    info("usage: parallel.jl <jobfile>")
    exit()
elseif !ispath(ARGS[1])
    error("jobfile $(ARGS[1]) does not exist.")
end

jobs = makejobs(ARGS[1])
addnodes()
pmap(ex, jobs)
