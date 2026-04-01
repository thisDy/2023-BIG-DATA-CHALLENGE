clear all
data1 = readtable('去异常后的数据.xlsx'); % 请将'您的数据.xlsx'替换为您的文件名
data = data1(:,4:end); % 从第四列开始读取
data = table2array(data); % 转换为多维数组

figure
% 求维度之间的相关系数
rho = corr(data, 'type','Spearman'); % 使用Spearman相关系数

% 绘制热图
string_name = {'学校类型编号（0-5)', '入学技能1考核成绩', '入学技能2考核成绩', ...};
% 由于入学技能3考核成绩到离校考核总分成绩是连续的，我们不需要手动列出所有变量
% 而是直接使用冒号来表示从第三列到最后一列的所有变量
xvalues = string_name(2:end); % x轴标签
yvalues = string_name(2:end); % y轴标签
h = heatmap(xvalues, yvalues, rho, 'FontSize',10, 'FontName','宋体');
h.Title = '皮尔逊相关性';
colormap summer
