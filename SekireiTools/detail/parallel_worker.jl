type Job
    cmd :: AbstractString
    jobid :: Int
    pbs_id :: Int
end

function ex(job)
    output = "$(job.pbs_id)-$(myid()-1).out"
    err = "$(job.pbs_id)-$(myid()-1).err"
    println("start $(job.jobid)-th job on process $(myid()-1).")
    open(io->println(io, "start $(job.jobid)-th job on process $(myid()-1)."), output, "a")
    open(io->println(io, "start $(job.jobid)-th job on process $(myid()-1)."), err, "a")
    tic()
    run(pipeline(`sh -c $(job.cmd)`, stdout = output, stderr = err, append=true))
    t = toq()
    println("finish $(job.jobid)-th job on process $(myid()-1) ($t sec)")
    open(io->println(io, "finish $(job.jobid)-th job on process $(myid()-1) ($t sec)"), output, "a")
    open(io->println(io, "finish $(job.jobid)-th job on process $(myid()-1) ($t sec)"), err, "a")
    return nothing
end

