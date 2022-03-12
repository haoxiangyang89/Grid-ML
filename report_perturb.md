## **Result of Perturbing Loads For Selected MATPOWER Test Instances and Experiment of Related Works**

Our project investigates the ACOPF results solved by the Ipopt solver for the varying loads of selected cases. The case we choose are case5, case300, and case_ACTIVSg500. We create datasets of 1000 instances for each case being perturbed by its specific perturb settings.

#### **Case5**

We select 1000 varying loads instances by randomly perturbing the default loads' real power demand by normally distributed noise with its mean to be 0 and its variation proportional to the load. We set the solve time limit to be 1s.

When the variation factor is 0.05, 3.6% of instances cannot be solved within the time limit. Although their objective values cannot be solved exactly for those cases that reach the time limit, with their optimal status and feasibilities unknown, we can still estimate their objective values by the last iterations of their solving processes. We can also enumerate their dual infeasibility. All the other instances under these settings are feasible, with their optimal solutions being found. The mean value of time to solve the case is 0.099s, and the average objective value is 16938.536.

When the variation factor is 0.1,  3.7% perturbed instances cannot be solved within the time limit. Other instances are optimal and feasible. The mean value of solving time is 0.096s, and the average objective value is 16916.539.

When the variation factor is 0.2, 3.6% perturbed instances cannot be solved within the time limit. Other instances are optimal and feasible. The mean value of solving time is 0.093s, and the average objective value is 16837.139.

When the variation factor is 0.3, 3.0% perturbed instances cannot be solved within the time limit. 0.6% of instances are infeasible and non-optimal. Other instances are optimal and feasible. The mean value of solving time is 0.092s, and the average objective value is 17061.487.

When the variation factor is 0.5, 3.9% perturbed instances cannot be solved within the time limit. 8.2% of instances are infeasible and non-optimal. Other instances are optimal and feasible. The mean value of solving time is 0.103s. The average objective value is 17274.627.

 

| Case Name | Variation | TIME_LIMIT | Solve_Time Mean | reach TIME_LIMIT | LOCALLY_INFEASIBLE |
| --------- | --------- | ---------- | --------------- | ---------------- | ------------------ |
| case5.m   | 0.05      | 1          | 0.099           | 3.6%             | 0%                 |
| case5.m   | 0.1       | 1          | 0.096           | 3.7%             | 0%                 |
| case5.m   | 0.2       | 1          | 0.093           | 3.6%             | 0%                 |
| case5.m   | 0.3       | 1          | 0.092           | 3.0%             | 0.6%               |
| case5.m   | 0.5       | 1          | 0.103           | 3.9%             | 8.2%               |



#### **Case300**

We select 1000 varying loads instances by randomly perturbing the default loads' real power demand by normally distributed noise with its mean to be 0 and its variation proportional to the load. The solve time limit we set for all the instances of case300 is 6.0s initially. If there are over 50% instances under a certain perturb setting that cannot be solved in 6s, we adjust the solve time limit to be 8s, then 10s.

When the variation factor is 0.05, there are 0.1% instances that cannot be solved within the time limit. No case showed to be locally infeasible. The mean value of solving time is 1.155s. The average objective value is 718512.631. The average estimated(by the last iteration) objective value is  654757.888. 

When the variation factor is 0.1,  3.9% perturbed instances cannot be solved within 6s. No case showed to be locally infeasible. The mean value of solving time is 1.381s. The average objective value is 692182.811. The average estimated(by the last iteration) objective value is  660647.288. 

When the variation factor is 0.2, 28.8% perturbed instances cannot be solved within 6s. 0.1% of instances are locally infeasible. The mean value of solving time is 2.641s. The average objective value is 512155.440. The average estimated(by the last iteration) objective value is  694945.697. 

When the variation factor is 0.3, 48.2% perturbed instances cannot be solved 6s. 1.6% of instances are infeasible and non-optimal. The mean value of solving time is 3.685s. The average objective value is 372276.615, the average estimated (by the last iteration) average objective value is 704257.113. 

When the variation factor is 0.5, 81.8% perturbed instances cannot be solved within 6s. 4.2% of instances are infeasible and non-optimal. Other instances are optimal and feasible. The mean value of solving time is 5.377s. The average objective value is 129161.523, the average estimated (by the last iteration) average objective value is 704257.113. Then we adjust the time limit to 8s. 61.4% instances cannot be solved within 8s. 25.6% of instances are infeasible and non-optimal. The mean value of solving time is 6.866s. The average objective value is 286832.869, the average estimated (by the last iteration) average objective value is 724829.325. Finally, we set the time limit to be 10s, 36.3% of instances cannot be solved within 10s, 49.3% instances are locally infeasible, the mean of time to solve is 7.749, the average objective value is 477924.035, the average estimated (by the last iteration) average objective value is 729800.138.

| Case Name | Variation | TIME_LIMIT | Solve_Time Mean | reach TIME_LIMIT | LOCALLY_INFEASIBLE |
| --------- | --------- | ---------- | --------------- | ---------------- | ------------------ |
| case300.m | 0.05      | 6          | 1.155           | 0.1%             | 0%                 |
| case300.m | 0.1       | 6          | 1.381           | 3.9%             | 0%                 |
| case300.m | 0.2       | 6          | 2.641           | 28.8%            | 0.1%               |
| case300.m | 0.3       | 6          | 3.685           | 48.2%            | 1.6%               |
| case300.m | 0.5       | 6          | 5.377           | 81.8%            | 4.2%               |
| case300.m | 0.5       | 8          | 6.866           | 61.4%            | 25.6%              |
| case300.m | 0.5       | 10         | 7.749           | 36.3%            | 49.3%              |

#### **case_ACTIVSg500**
We select 1000 varying loads instances by randomly perturbing the default loads' real power demand by normally distributed noise with its mean to be 0 and its variation proportional to the load. We set the time limit to solve each instance of case_ACTIVSg500 as 10 seconds.

When the variation factor is 0.05, all instances are feasible and can be solved within the time limit of 10s. The mean solve time is 4.483, the mean objective value is 72620.389, the mean estimated objective value(by the last iteration) is 69068.508.

When the variation factor is 0.1, there are 1.4% of instances cannot be solved within the time limit. 1.1% of instances are locally infeasible. The mean solve time is 4.218, the mean objective value is 71508.948, the mean estimated objective value(by the last iteration) is 69305.371.

When the variation factor is 0.2, there are 15.2% of instances cannot be solved within the time limit. 79.2% of instances are locally infeasible. The mean solve time is 8.410, the mean objective value is 65404.642, the mean estimated objective value(by the last iteration) is 74311.838.

When the variation factor is 0.3, there are 11.6% of instances cannot be solved within the time limit. 88.4% of instances are locally infeasible. The mean solve time is 8.608, the mean objective value is 71277.723, the mean estimated objective value(by the last iteration) is 77972.268.

When the variation factor is 0.5, there are 8.6% of instances cannot be solved within the time limit. 91.4% of instances are locally infeasible. The mean solve time is 7.634, the mean objective value is 75282.861, the mean estimated objective value(by the last iteration) is 80201.620.

| Case Name         | Variation | TIME_LIMIT | Solve_Time Mean | reach TIME_LIMIT | LOCALLY_INFEASIBLE |
| ----------------- | --------- | ---------- | --------------- | ---------------- | ------------------ |
| case_ACTIVSg500.m | 0.05      | 10         | 4.483           | 0%               | 0%                 |
| case_ACTIVSg500.m | 0.1       | 10         | 4.218           | 1.4%             | 1.1%               |
| case_ACTIVSg500.m | 0.2       | 10         | 8.410           | 15.2%            | 79.2%              |
| case_ACTIVSg500.m | 0.3       | 10         | 8.608           | 11.6%            | 88.4%              |
| case_ACTIVSg500.m | 0.5       | 10         | 7.634           | 8.6%             | 91.2%              |




## **Numerical Experiment of Related Work**
### **ADMM**
After training parameter selection policy using Q-learning, [1] use ADMM to solve ACOPF.

#### **Performance on Traing Scheme**
Compared with SOTA penalty adjustment scheme in [2] that results in ADMM convergence in
879, 1400, and 525 iterations for 9-bus, 30-bus, and 118-bus systems, the RL policy reduces the number of ADMM iterations by at least 30%. It shows that RL avoids frequent fluctuations of residuals which prolongs the ADMM solving process.
![1647087987050.png](https://xg3.jiashumao.net/2022/03/12/Bq7lznIS.png)

#### **Generalization of RL Policy to Varying Loads**
[1] create a dataset of 50 test instances by randomly perturbing the default loads in the range [−10%, 10%] at each bus  for 9-bus, 30-bus, and 118-bus, they show that RL can reduce ADMM iterations by 28% to 50%
![1647088169655.png](https://xg3.jiashumao.net/2022/03/12/aOb5KmT4.png)

#### **Generalization of RL Policy to Generator and Line Outages**
They evaluate the ADMM convergence speed when applied to systems with 1) one generator removed and 2) one line disconnected.
![1647088309633.png](https://xg3.jiashumao.net/2022/03/12/oXzYIB5x.png)

#### **Generalization of RL Policy to Unseen Network Structures**
They found that policies trained in one network perform poorly in a completely different network.

### **DC3**
DC3[3] use the following algorithm to address bthe challenge that naive deep learning cannot enforce the hard constraints of OPF. 
![1647090046548.png](https://xg3.jiashumao.net/2022/03/12/Hv6nIBwt.png)

They assess our method on a 57-node power system test case available via the MATPOWER package. They conduct 5 runs over 1,200 input datapoints (with a train/test/validation ratio of 10:1:1). They see that DC3 runs about 10× faster than the PYPOWER optimizer, even when PYPOWER is fully parallelized.(Even when running on the CPU, DC3 takes 0.906±0.003 seconds, slightly faster than PYPOWER.)
![1647090260125.png](https://xg3.jiashumao.net/2022/03/12/e7fZVI2S.png)


## **Some thinkings**

#### **Datasets We Have Right Now**

For case5, we have overall 5000 load profiles, with 88 of them infeasible and 178 reaching the time limit. For case300, we have overall 7000 load profiles, with 2605 infeasible instances and 808 instances that cannot be solved within time limits. For case_ACTIVSg500, we have overall 5000 load profiles, with 2599 of them being infeasible, and 368 of them cannot be solved within the time limit.

#### **Supervised Learning**
Now that we have the above dataset. Given certain load profiles, we take the load information of each bus and generator as input, and the feasibility, solve time, solutions, and objective value as output. We can formulate the problem by an end-to-end deep neural network to predict the output. And thinking about techniques to be used to prove (experimentally or mathematically) the learned parameter can have the ability of generalization(at least for a specific network, we perturb its loading profiles, or outage some buses, line, generators,  we don't have to train the model again). [4] gives an example to prove its solver can guarantee generalization for DCOPF.

#### **Is There any Method to Solve ACOPF can guarantee Generalization for Completely Different Networks?** 

My intuition is: Given a relatively large network, suppose we already have some small sub-problem got well trained. We add consensus constraints first. Then we put the load information of the sub-problem to the trained model, we can predict the solution for the sub-problem, then we can use distributed algorithm to spread the solution out to solve the following solution. But there is some problem awaiting to be answered:

1. Can we guarantee the solution is feasible? If we cannot guarantee its feasibility, can we make sure the solution is close to the true solution?
2. How far between the predicted objective value and the ground truth
3. How fast will the algorithm be?   




#### **Reference**
[1] [[2110.11991v1\] A Reinforcement Learning Approach to Parameter Selection for Distributed Optimization in Power Systems (arxiv.org)](https://arxiv.org/abs/2110.11991v1)
[2] S. Mhanna, G. Verbic, and A. C. Chapman, “Adaptive ADMM for ˘
distributed AC optimal power flow,” IEEE Transactions on Power
Systems, vol. 34, no. 3, pp. 2025–2035, 2019.
[3] https://www.arxiv-vanity.com/papers/2104.12225/
[4] https://arxiv.org/abs/2009.09109