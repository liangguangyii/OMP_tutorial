## OpenMP in Fortran

### Visual Studio
���ɽ����������Ŀ����->Fortran->����->OpenMP֧��->��

### ����ָ�����

- [ ] ��!$OMP��ͷ��ָ�����
- [ ] ������&��ʼ���µ�һ����Ҫ��ͷ����!$OMP

### ͷ�ļ�

```fortran
use omp_lib
```

����

```fortran
include 'omp_lib.h'
```

### ���ÿ⺯��
- [ ] omp_set_num_threads() �����߳������պ�������call���ʹ��
- [ ] omp_get_max_threads() ��ȡ����߳���
- [ ] omp_get_num_threads() ��ȡ�߳���
- [ ] omp_get_thread_num() ��ȡ�̺߳�
- [ ] omp_get_wtime() ��ȡ��ǰʱ��

### ��Ҫָ��

- [ ] parallel
- [ ] do
- [ ] sections
- [ ] atomic
- [ ] single ֻ����һ���߳�ִ�У������߳�����
- [ ] barrier ���������̵߳�ͬ�����ȵ����̵߳ȴ��󵽵��߳�
- [ ] critical �ڲ��п���ֻ����ͬʱ��һ���߳̽��룬�����̵߳ȴ�
- [ ] master
- [ ] flush
- [ ] atomic
- [ ] ordered

**critical master atomic flush ordered�����û����Ӧ���Ӿ䣬 ����parallel�������������䲻�����������ʹ��**

�����ǹ���critical��single��һЩ˵����

�ȳ�ʼ��OMP������

```fortran
use omp_lib
implicit none
    
integer:: tid, mcpu
    
mcpu = omp_get_max_threads()
tid = omp_get_thread_num()
    
call omp_set_num_threads(mcpu)
```

��ͨ���У�

```fortran
!$omp parallel default(none) private(tid, mcpu)
print "(a)", "--------------during parallel--------------"
mcpu = omp_get_num_threads()
tid = omp_get_thread_num()
print "(a,x,i2,x,a,x,i2,x,a)", "thread", tid, "of", mcpu, "CPUs"
!$omp end parallel
```

���Ϊ��
```fortran
--------------during parallel--------------
--------------during parallel--------------
thread  0 of 16 CPUs
thread  1 of 16 CPUs
--------------during parallel--------------
--------------during parallel--------------
--------------during parallel--------------
--------------during parallel--------------
--------------during parallel--------------
thread  6 of 16 CPUs
thread  2 of 16 CPUs
thread  5 of 16 CPUs
--------------during parallel--------------
thread  7 of 16 CPUs
--------------during parallel--------------
--------------during parallel--------------
--------------during parallel--------------
thread  9 of 16 CPUs
--------------during parallel--------------
thread  4 of 16 CPUs
thread 11 of 16 CPUs
--------------during parallel--------------
--------------during parallel--------------
thread 14 of 16 CPUs
--------------during parallel--------------
thread  3 of 16 CPUs
--------------during parallel--------------
thread  8 of 16 CPUs
thread 12 of 16 CPUs
thread 15 of 16 CPUs
thread 13 of 16 CPUs
thread 10 of 16 CPUs
```

���Կ����������߳�ͬʱִ�У���������Ľ���ǻ��ҵġ�


����cirticalָ�
```fortran
!$omp parallel default(none) private(tid, mcpu)
!$omp critical
print "(a)", "--------------during parallel(critical)--------------"
mcpu = omp_get_num_threads()
tid = omp_get_thread_num()
print "(a,x,i2,x,a,x,i2,x,a)", "thread", tid, "of", mcpu, "CPUs"
!$omp end critical
!$omp end parallel
```
���Ϊ��
```fortran
--------------during parallel(critical)--------------
thread  0 of 16 CPUs
--------------during parallel(critical)--------------
thread  8 of 16 CPUs
--------------during parallel(critical)--------------
thread 12 of 16 CPUs
--------------during parallel(critical)--------------
thread  3 of 16 CPUs
--------------during parallel(critical)--------------
thread  2 of 16 CPUs
--------------during parallel(critical)--------------
thread  4 of 16 CPUs
--------------during parallel(critical)--------------
thread  1 of 16 CPUs
--------------during parallel(critical)--------------
thread 11 of 16 CPUs
--------------during parallel(critical)--------------
thread 10 of 16 CPUs
--------------during parallel(critical)--------------
thread 15 of 16 CPUs
--------------during parallel(critical)--------------
thread 14 of 16 CPUs
--------------during parallel(critical)--------------
thread 13 of 16 CPUs
--------------during parallel(critical)--------------
thread  7 of 16 CPUs
--------------during parallel(critical)--------------
thread  6 of 16 CPUs
--------------during parallel(critical)--------------
thread  5 of 16 CPUs
--------------during parallel(critical)--------------
thread  9 of 16 CPUs
```

ʵ�����൱�ڴ���ִ���ˣ���Ϊֻ��һ���߳̿��Խ����ٽ�����

����singleָ�

```fortran
!$omp parallel default(none) private(tid, mcpu)
!$omp single
print "(a)", "--------------during parallel(single)--------------"
mcpu = omp_get_num_threads()
tid = omp_get_thread_num()
print "(a,x,i2,x,a,x,i2,x,a)", "thread", tid, "of", mcpu, "CPUs"
!$omp end single
!$omp end parallel
```

���Ϊ��
```fortran
--------------during parallel(single)--------------
thread 12 of 16 CPUs
```

ִֻ����һ���̣߳������̶߳������ˡ�

### ��Ҫ�Ӿ�
- [ ] private private�����ı�������̳����ڲ����������ֵ�������¶���
- [ ] shared ��shared���в���ʱ������ִ��critical���⾺��
- [ ] default(private|shared|none) ���������б���Ĭ������
- [ ] reduction

