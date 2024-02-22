program main
    use omp_lib
    use iso_fortran_env
    implicit none
    
    integer:: tid, mcpu
    
    integer:: nsteps,i, i_omp
    real(kind=8):: start_time, end_time
    real(kind=8):: pi, x, dx, interval=1D0
    real(kind=8):: start_time_omp, end_time_omp
    real(kind=8):: pi_omp, x_omp, dx_omp
    real(kind=8), allocatable:: pi_omp_array(:)
    
    !*******************************************************************************
    !different types of parallel regions
    mcpu = omp_get_max_threads()
    tid = omp_get_thread_num()
    
    call omp_set_num_threads(mcpu)
    
    nsteps = 1000000000
    dx = interval/nsteps
    
    
    !print "(a,x,i2,x,a,x,i2,x,a)", "thread", tid, "of", mcpu, "CPUs"
    !print "(a)", "--------------before parallel--------------"
    !print *
    !
    !!$omp parallel default(none) private(tid, mcpu)
    !print "(a)", "--------------during parallel--------------"
    !mcpu = omp_get_num_threads()
    !tid = omp_get_thread_num()
    !print "(a,x,i2,x,a,x,i2,x,a)", "thread", tid, "of", mcpu, "CPUs"
    !!$omp end parallel
    !
    !print *
    !
    !!$omp parallel default(none) private(tid, mcpu)
    !!$omp critical
    !print "(a)", "--------------during parallel(critical)--------------"
    !mcpu = omp_get_num_threads()
    !tid = omp_get_thread_num()
    !print "(a,x,i2,x,a,x,i2,x,a)", "thread", tid, "of", mcpu, "CPUs"
    !!$omp end critical
    !!$omp end parallel
    !
    !print *
    !
    !!$omp parallel default(none) private(tid, mcpu)
    !!$omp single
    !print "(a)", "--------------during parallel(single)--------------"
    !mcpu = omp_get_num_threads()
    !tid = omp_get_thread_num()
    !print "(a,x,i2,x,a,x,i2,x,a)", "thread", tid, "of", mcpu, "CPUs"
    !!$omp end single
    !!$omp end parallel
    
    
    !*******************************************************************************
    !calculate pi
    
    !print *
    !print "(a)", "--------------calculate pi--------------"
    !
    !
    !call CPU_TIME(start_time)
    !
    !pi = 0D0
    !do i = 1, nsteps
    !    x = (dble(i) - 0.5D0) * dx
    !    pi = pi + 4D0*dx/(1D0 + x**2)
    !end do
    !
    !call CPU_TIME(end_time)
    !
    !write(*,"(a,2x,f22.17)") "pi=", pi
    !write(*,"(a,2x,f22.17)") "time=", end_time - start_time
    
    !*******************************************************************************
    !reduction case
    
    print *
    print "(a)", "--------------calculate pi(omp)--------------"    
    
    start_time_omp = omp_get_wtime()
    !call CPU_TIME(start_time_omp)
    
    pi_omp = 0D0
    
    !$omp parallel default(shared) private(i_omp, x_omp) reduction(+:pi_omp)
    !$omp do
    do i_omp = 1, nsteps
        x_omp = (dble(i_omp) - 0.5D0) * dx
        pi_omp = pi_omp + 4D0*dx/(1D0 + x_omp**2)
    end do
    !$omp end do
    !$omp end parallel 
    
    end_time_omp = omp_get_wtime()
    !call CPU_TIME(end_time_omp)
    
    write(*,"(a,2x,f22.17)") "pi=", pi_omp
    write(*,"(a,2x,f22.17)") "time=", end_time_omp - start_time_omp
    
    
    !*******************************************************************************
    !parallel in array
    
    !print *
    !print "(a)", "--------------calculate pi(omp)--------------"
    !
    !
    !allocate(pi_omp_array(mcpu))
    !pi_omp_array = 0D0
    !
    !start_time_omp = omp_get_wtime()
    !
    !!$omp parallel default(shared) private(x_omp, i_omp, tid)
    !tid = omp_get_thread_num()
    !!$omp do
    !do i_omp = 1, nsteps
    !    x_omp = (dble(i_omp) - 0.5D0) * dx
    !    pi_omp_array(tid+1) = pi_omp_array(tid+1) + 4D0*dx/(1D0 + x_omp*x_omp)
    !end do
    !!$omp end do
    !!$omp end parallel
    !
    !pi_omp = sum(pi_omp_array)
    !
    !end_time_omp = omp_get_wtime()
    !
    !
    !
    !
    !write(*,"(a,2x,f22.17)") "pi=", pi_omp
    !write(*,"(a,2x,f22.17)") "time=", end_time_omp - start_time_omp
    
    
end program main