% 加载Excel文件
xlsxPath = '去异常后的数据.xls'; % Excel文件的路径
sheetName = 'Sheet1'; % Excel中的工作表名称
data = readtable(xlsxPath, 'Sheet', sheetName, 'VariableNamingRule', 'preserve'); % 加载数据

% 定义平滑窗口大小
n = 9;

% 初始化一个空的数组来存储平滑后的数据
y_smooth = zeros(size(data.Column1));

% 对第四列到第15列的数据进行9点平滑处理
for i = 4:15
    % 选择当前列的数据
    y = data.Column(i);
    
    % 应用9点平滑处理
    y_smooth(:,i-3) = smooth_data(y, n); % 确保调用函数时使用正确的列索引
end

% 绘制平滑处理前后的数据对比图
figure;
for i = 4:15
    subplot(4, 4, i-3);
    
    % 绘制原始数据
    plot(data.Time, data.Column(i), 'o', 'MarkerSize', 6);
    hold on;
    
    % 绘制平滑后的数据
    plot(data.Time, y_smooth(:,i-3), 's', 'MarkerSize', 6);
    
    % 设置标题和轴标签
    title(['平滑处理前 第', num2str(i), '列']);
    xlabel('时间');
    ylabel('数据值');
    
    hold off;
end

% 调整子图之间的间距
subplot_adjustments = struct('left', 0.1, 'right', 0.9, 'top', 0.9, 'bottom', 0.1, ...
                              'row', 0.05, 'col', 0.1);
subplot_space(subplot_adjustments);

% 函数定义：smooth_data
function Y = smooth_data(y, n)
    m = length(y);
    Y = zeros(1, m);
    for i = 1:n:m
        p = i - n;
        q = i + n;
        Y(end-i+1) = sum(y(p:q)) / n;
    end
end
