function res = BlandAltmanPlot(y, y_hat, t)
% Bland-Altman with Regression Line, LoAs, and 95% CI -- ##
% The procedures are applied following the recommendations presented in [1].
% -----------------------------------------------------------------------------
% Author: Guido Mascia, PhD -- mascia.guido@gmail.com
% Creation date: 04.09.2023
% Last edit: 05.09.2023
% -----------------------------------------------------------------------------
%   [1] Giavarina (2016). "Understanding Bland Altman analysis", Biochemia
% Medica. doi: 10.11613/BM.2015.015
% -----------------------------------------------------------------------------

% Set the template color
my_orange = '#e56d1d';

% Bland-Altman Start
x = .5 * (y + y_hat); % Average
y = (y - y_hat); % Difference

% Scatter Plot of Averages Vs. Differences
figure
plot(x,y, 'o', 'markeredgecolor', 'none', 'markerfacecolor', my_orange)
set(gca, 'FontSize', 12)
xlabel('Average', 'FontSize', 16)
ylabel('Difference', 'FontSize', 16)
box off

% Prepare in advance plot boundaries. They will be needed afterwards
delta_x = abs(0.3 * max(x));
x_min = floor(min(x) - delta_x);
x_max = floor(max(x) + delta_x);

delta_y = abs(0.3 * max(y));
y_min = floor(min(y) - delta_y);
y_max = floor(max(y) + delta_y);
xlim([x_min, x_max])
ylim([y_min, y_max])

hold on

% Compute Bias and UB/LB
b = mean(y);
UB = b + 1.96 * std(y);
LB = b - 1.96 * std(y);

plot([x_min x_max], [b b], '--k')
plot([x_min x_max], [UB UB], '--k')
plot([x_min x_max], [LB LB], '--k')

% Compute The 95% CI for each
N = length(y);

SE_b = sqrt(std(y)^2 / (N-1));
CI_b = SE_b * t;
b_L = b - CI_b;
b_U = b + CI_b;

% Plot the Rectangle for the Bias
plot([x_min, x_max], [b_L b_L], 'r')
plot([x_min, x_max], [b_U b_U], 'r')

r = rectangle('Position', [x_min, b_L, (abs(x_max) + abs(x_min)), ...
 (b_U - b_L)], 'facecolor', 'r', 'edgecolor', 'none');
set( get(r, 'children'), 'facealpha', 0.35 );

% Compute CI for LB and UB (same)
SE_B = sqrt((3 * std(y)^2) / (N-1));
CI_B = SE_B * t;

LB_L = LB - CI_B;
LB_U = LB + CI_B;
UB_L = UB - CI_B;
UB_U = UB + CI_B;

% Plot the rectangle for LB
r = rectangle('Position', [x_min, LB_L, (abs(x_max) + abs(x_min)), ...
 (LB_U - LB_L)], 'facecolor', 'r', 'edgecolor', 'none');
set( get(r, 'children'), 'facealpha', 0.35 );

plot([x_min, x_max], [LB_L LB_L], 'r')
plot([x_min, x_max], [LB_U LB_U], 'r')

% Plot the rectangle for UB
r = rectangle('Position', [x_min, UB_L, (abs(x_max) + abs(x_min)), ...
 (UB_U - UB_L)], 'facecolor', 'r', 'edgecolor', 'none');
set( get(r, 'children'), 'facealpha', 0.35 );

plot([x_min, x_max], [UB_L UB_L], 'r')
plot([x_min, x_max], [UB_U UB_U], 'r')

res(1,:) = {'Bias [95% CI]', 'LB [95% CI]', 'UB [95% CI]'};
res(2,1) = {[num2str(b) ' [' num2str(b_L) ', ' num2str(b_U) ']']};
res(2,2) = {[num2str(LB) ' [' num2str(LB_L) ', ' num2str(LB_U) ']']};
res(2,3) = {[num2str(UB) ' [' num2str(UB_L) ', ' num2str(UB_U) ']']};

% Finally, the regression line
P = polyfit(x, y, 1);
m = P(1); q = P(2);
x1 = 0 : length(y);
x2 = m*x1 + q;
plot(x1,x2, 'k', 'linewidth', 1.2)

title(['Difference = ' num2str(m) ' · Average + ' num2str(q)])
end
