type Job
    cmd :: AbstractString
    jobid :: Int
end

function ex(job)
    output = "$(job.jobid).out"
    err = "$(job.jobid).err"
    println("start $(job.jobid)-th job on process $(myid()).")
    tic()
    run(pipeline(`sh -c $(job.cmd)`, stdout = output, stderr = err))
    t = toq()
    println("finish $(job.jobid)-th job on process $(myid()) ($t sec)")
    return nothing
end

