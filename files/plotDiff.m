% Plots 2 times series, their 95% CI and significance bars at the bottom
% from h vector (FDR-corrected p-values). If method is not precised,
% 10% trimmed mean is used. 
% 
% Usage:
%   - plotDiff(xAxis, data1, data2, method1, method2, h, data1Name, data2Name);
%   - plotDiff(freqs, power1, power2, 'mean', 'CI', [], 'condition 1','condition 2');
% 
% Data must be 2-D. Values in column 1 and subjects in column 2 (e.g.,freqs x subjects)
% 
% Cedric Cannard, 2021

function plotDiff(xAxis, data1, data2, method1, method2, h, data1Name, data2Name)

if size(xAxis,1) > size(xAxis,2)
    xAxis = xAxis';
end

if exist('h', 'var') && ~isempty(h)
    sigBars = true;
else
    sigBars = false;
end

color1 = [0, 0.4470, 0.7410];
color2 = [0.8500, 0.3250, 0.0980];

% Variable 2
n = size(data1,2);
if strcmpi(method2, 'mean')
    data1_mean = mean(data1,2,'omitnan');
else
    data1_mean = trimmean(data1,20,2);
end
if strcmpi(method2,'SD')
    SD = std(data1,[],2,'omitnan');  % standard deviation
    data1_CI(1,:) = data1_mean + SD;
    data1_CI(2,:) = data1_mean - SD;
elseif strcmpi(method2,'SE')
    SE = std(data1,[],2,'omitnan') ./ sqrt(n)';  % standard error
    data1_CI(1,:) = data1_mean + SE;
    data1_CI(2,:) = data1_mean - SE;
elseif strcmpi(method2,'CI')
    SE = std(data1,[],2,'omitnan') ./ sqrt(n)';  % standard error
    tscore = tinv([.025 .975],n-1);  % t-score
    data1_CI = data1_mean' + (-tscore.*SE)'; % 95% confidence interval
end

% Variable 2
n = size(data2,2);
if strcmpi(method2, 'mean')
    data2_mean = mean(data2,2,'omitnan');
else
    data2_mean = trimmean(data2,20,2);
end
if strcmpi(method2,'SD')
    SD = std(data2,[],2,'omitnan');  % standard deviation
    data2_CI(1,:) = data2_mean + SD;
    data2_CI(2,:) = data2_mean - SD;
elseif strcmpi(method2,'SE')
    SE = std(data2,[],2,'omitnan') ./ sqrt(n)';  % standard error
    data2_CI(1,:) = data2_mean + SE;
    data2_CI(2,:) = data2_mean - SE;
elseif strcmpi(method2,'CI')
    SE = std(data2,[],2,'omitnan') ./ sqrt(n)';  % standard error
    tscore = tinv([.025 .975],n-1);  % t-score
    data2_CI = data2_mean' + (-tscore.*SE)'; % 95% confidence interval
end

% figure; set(gcf,'Color','w');

% Plot variable 1 (mean + CI)
p1 = plot(xAxis,data1_mean,'LineWidth',2,'Color', color1);
patch([xAxis fliplr(xAxis)], [data1_CI(1,:) fliplr(data1_CI(2,:))], ...
    color1,'FaceAlpha',.4,'EdgeColor',color1,'EdgeAlpha',.7);
set(gca,'FontSize',12,'layer','top'); 
hold on;

% Data2 (mean + CI)
p2 = plot(xAxis,data2_mean,'LineWidth',2,'Color', color2);
patch([xAxis fliplr(xAxis)], [data2_CI(1,:) fliplr(data2_CI(2,:))], ...
    color2,'FaceAlpha',.4,'EdgeColor',color2,'EdgeAlpha',.7);
set(gca,'FontSize',12,'layer','top'); 
% hold off;

% Plot significance bar at the bottom
if sigBars
    plotSigBar(h, xAxis);
end

legend([p1, p2], {data1Name,data2Name}, 'Orientation','vertical'); 

% grid on; 
axis tight;  
box on
