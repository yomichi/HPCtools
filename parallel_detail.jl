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

function makejobs(jobfile)
    jobs = Job[]
    io = open(jobfile)
    for (jobid, line) in enumerate(eachline(io))
        push!(jobs, Job(line, jobid))
    end
    close(io)
    jobs2 = Tuple{Job, Int}[(j,n) for j in jobs]
    return jobs2
end

