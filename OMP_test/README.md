## OpenMP in Fortran

### Visual Studio
生成解决方案后，项目属性->Fortran->语言->OpenMP支持->是

### 编译指导语句

- [ ] 以!$OMP开头的指导语句
- [ ] 换行以&开始，新的一行需要开头加上!$OMP

### 头文件

```fortran
use omp_lib
```

或者

```fortran
include 'omp_lib.h'
```

### 常用库函数
- [ ] omp_set_num_threads() 设置线程数，空函数，与call配合使用
- [ ] omp_get_max_threads() 获取最大线程数
- [ ] omp_get_num_threads() 获取线程数
- [ ] omp_get_thread_num() 获取线程号
- [ ] omp_get_wtime() 获取当前时间

### 主要指令

- [ ] parallel
- [ ] do
- [ ] sections
- [ ] atomic
- [ ] single 只允许一个线程执行，其他线程跳过
- [ ] barrier 用于所有线程的同步，先到的线程等待后到的线程
- [ ] critical 在并行块中只允许同时有一个线程进入，其他线程等待
- [ ] master
- [ ] flush
- [ ] atomic
- [ ] ordered

**critical master atomic flush ordered这五个没有相应的子句， 除了parallel以外其他的主句不能与别的主句绑定使用**

以下是关于critical和single的一些说明：

先初始化OMP环境：

```fortran
use omp_lib
implicit none
    
integer:: tid, mcpu
    
mcpu = omp_get_max_threads()
tid = omp_get_thread_num()
    
call omp_set_num_threads(mcpu)
```

普通并行：

```fortran
!$omp parallel default(none) private(tid, mcpu)
print "(a)", "--------------during parallel--------------"
mcpu = omp_get_num_threads()
tid = omp_get_thread_num()
print "(a,x,i2,x,a,x,i2,x,a)", "thread", tid, "of", mcpu, "CPUs"
!$omp end parallel
```

结果为：
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

可以看到，由于线程同时执行，所以输出的结果是混乱的。


加上cirtical指令：
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
结果为：
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

实际上相当于串行执行了，因为只有一个线程可以进入临界区。

加上single指令：

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

结果为：
```fortran
--------------during parallel(single)--------------
thread 12 of 16 CPUs
```

只执行了一个线程，其他线程都跳过了。

### 主要子句
- [ ] private private申明的变量不会继承其在并行区域外的值，需重新定义
- [ ] shared 对shared进行操作时，必须执行critical避免竞争
- [ ] default(private|shared|none) 并行区域中变量默认属性
- [ ] reduction

