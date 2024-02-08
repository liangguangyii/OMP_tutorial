## OpenMP in Fortran

### 编译指导语句

- [ ] 以!$OMP开头的指导语句
- [ ] 换行以&开始，新的一行需要开头加上!$OMP

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

### 主要子句
- [ ] private
- [ ] shared
- [ ] default(private|shared|none) 并行区域中变量默认属性
- [ ] reduction