program main
    use omp_lib
    implicit none
    
    integer:: tid, mcpu
    
    mcpu = omp_get_max_threads()
    tid = omp_get_thread_num()
    
    call omp_set_num_threads(mcpu)
    
    
    print "(a,x,i2,x,a,x,i2,x,a)", "thread", tid, "of", mcpu, "CPUs"
    print "(a)", "--------------before parallel--------------"
    print *
    
    !$omp parallel default(none) private(tid, mcpu)
    print "(a)", "--------------during parallel--------------"
    mcpu = omp_get_num_threads()
    tid = omp_get_thread_num()
    print "(a,x,i2,x,a,x,i2,x,a)", "thread", tid, "of", mcpu, "CPUs"
    !$omp end parallel
    
    print *
    
    !$omp parallel default(none) private(tid, mcpu)
    !$omp critical
    print "(a)", "--------------during parallel(critical)--------------"
    mcpu = omp_get_num_threads()
    tid = omp_get_thread_num()
    print "(a,x,i2,x,a,x,i2,x,a)", "thread", tid, "of", mcpu, "CPUs"
    !$omp end critical
    !$omp end parallel
    
    print *
    
    !$omp parallel default(none) private(tid, mcpu)
    !$omp single
    print "(a)", "--------------during parallel(single)--------------"
    mcpu = omp_get_num_threads()
    tid = omp_get_thread_num()
    print "(a,x,i2,x,a,x,i2,x,a)", "thread", tid, "of", mcpu, "CPUs"
    !$omp end single
    !$omp end parallel
    
end program main