clc
clear
% 读取Excel文件
wt = xlsread('赛题数据.xlsx');
[n, p] = size(wt); % 获取数据的行数和列数

% 初始化ty_wt为与wt相同大小的零矩阵
ty_wt = zeros(n, p);

% 遍历每一列，从第4列开始
for c = 4:p
    c_wt = wt(:, c); % 选择第c列的所有数据
    c_wtmean = mean(c_wt); % 计算第c列的均值
    j = 1; % 初始化异常值计数器
    
    % 遍历每一行
    for i = 1:n
        vi = c_wt(i,:) - c_wtmean; % 计算当前行与均值之间的差异
        stdcwt = std(c_wt); % 计算第c列的标准差
        if abs(vi) > 3*stdcwt % 如果当前行的差异绝对值大于3倍的标准差
            c_wt(i,:) = 0; % 将当前行的数据设置为0（异常值）
            c_tbj(j, c) = i; % 记录异常值的行号
            j = j + 1; % 增加异常值计数器
        end
    end
    
    % 将处理后的第c列数据存储回ty_wt
    ty_wt(:, c) = c_wt;
end

% 将去异常后的数据保存到Excel文件
xlswrite('去异常后的数据.xlsx', ty_wt);
