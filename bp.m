% 清除命令窗口和变量
clc, clear

% 关闭所有打开的图形窗口
close all

% 读取数据
data=xlsread('C:\Users\firefly\Desktop\中国高校大数据挑战赛\去异常后的数据.xls')

% 初始化变量
counter = 0;

% 假设输出数据在第15列
data2020 = data(:, 15); % 输出数据

% 创建输入数据的矩阵
input_data = data(:, 1:6); % 输入数据
output_data = data2020; % 输出数据

% 数据的归一化处理
[min_p, max_p] = minmax(input_data);
[min_t, max_t] = minmax(output_data);
normalized_input = (input_data - min_p) / (max_p - min_p);
normalized_output = (output_data - min_t) / (max_t - min_t);

% 确定训练数据，测试数据， 一般是随机的从样本中选取 70% 的数据作为训练数据
% 15%的数据作为测试数据，一般是使用函数 dividerand，其一般的使用方法如下：
[train_input, val_input, test_input] = randi([0, size(normalized_input, 1)], 1, [round(0.75*size(normalized_input, 1)), round(0.15*size(normalized_input, 1)), round(0.15*size(normalized_input, 1))]);
[train_output, val_output, test_output] = randi([0, size(normalized_output, 1)], 1, [round(0.75*size(normalized_output, 1)), round(0.15*size(normalized_output, 1)), round(0.15*size(normalized_output, 1))]);
% 建立反向传播算法的 BP 神经网络，使用 newff 函数，其一般的使用方法如下
net = newff(min_p, max_p, [7,1], {'tansig', 'purelin'}); % 网络
% 指定训练参数
net.trainParam.epochs = 10000; % 训练次数设置
net.trainParam.goal = 1e-15; % 训练目标设置
net.trainParam.lr = 0.01; % 学习率设置，应设置为较少值，太大虽然会加快收敛速度，但临近最佳点时，会产生动荡，而无法收敛
net.trainParam.mc = 0.9; % 动量因子的设置，默认为 0.9
net.trainParam.show = 25; % 显示的间隔次数
% 训练网络
net = train(net, train_input, train_output);
% 计算仿真，其一般用 sim 函数
[sim_train_output, trainPerf] = sim(net, train_input, train_output);
[sim_val_output, valPerf] = sim(net, val_input, val_output);
[sim_test_output, testPerf] = sim(net, test_input, test_output);
% 将所得的结果进行反归一化，得到其拟合的数据
train_output_unnormalized = min_t + (sim_train_output .* (max_t - min_t));
val_output_unnormalized = min_t + (sim_val_output .* (max_t - min_t));
test_output_unnormalized = min_t + (sim_test_output .* (max_t - min_t));
% 做预测，输入要预测的数据 pnew
pnew = [313, 256, 239];
pnew_normalized = (pnew - min_p) / (max_p - min_p);
anew = sim(net, pnew_normalized);
anew_unnormalized = min_t + (anew .* (max_t - min_t));
% 计算预测数据的绝对误差 
abs_error = test_output_unnormalized - sim_test_output;
% 绘制拟合图
figure, plot(test_output_unnormalized, sim_test_output, 'r');
hold on, plot(test_output_unnormalized, test_output_unnormalized, 'b--');
legend('拟合曲线', '真实值');
title('拟合图');
xlabel('预测输出');
ylabel('实际输出');

% 绘制误差图
figure, plot(abs_error);
title('误差图');
xlabel('样本序号');
ylabel('绝对误差');

% 误差值的正态性检验
[mu, sigma, mu_ci, sigma_ci] = normfit(abs_error, 0.05);
figure, hist(abs_error, 'Normal');
title('误差频数直方图');
xlabel('绝对误差');

% 自相关图
figure, acorr(abs_error);
title('误差自相关图');
xlabel('滞后');
ylabel('相关系数');

% 预测新数据
pnew_normalized = [313, 256, 239];
anew_predicted = sim(net, pnew_normalized);
anew_predicted_unnormalized = min_t + (anew_predicted .* (max_t - min_t));
figure, scatter(1:length(test_output_unnormalized), test_output_unnormalized, 'b.');
hold on, plot(1:length(test_output_unnormalized), anew_predicted_unnormalized, 'r');
title('测试数据与预测数据对比图');
xlabel('样本序号');
ylabel('输出值');
legend('测试数据', '预测数据');
