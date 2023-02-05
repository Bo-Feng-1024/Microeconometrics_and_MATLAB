%% 3.1 Maximum Likelihood Estimation (MLE)
clear
DataIn = dlmread('auto.csv'); % read data
y = DataIn(:,1); % we take data fromevery single row (':') of column 1 in matrix DataIn.
X = DataIn(:, 2:3);
X = [X, ones(74,1)];
% we now estimate 3 beta and sigma, totally 4 parameters
lb = [-1000, -1000, -1000, 0];
ub = [1000, 1000, 1000, 100]; % build lower and upper bound
theta0 = [0, 0, 0, 1]; % initial guess value
opt = optimset('TolFun', 1E-20, 'TolX', 1E-20, ...
    'MaxFunEvals', 1000, 'Algorithm', 'sqp', 'PlotFcns', 'optimplotfval'); %1E-20 means running until the changes in objective function is less than 10^-20
fmincon(@(theta)NormalML(theta,y,X), theta0, ...
    [],[],[],[],lb,ub,[],opt); % @(theta): tell fmincon that the choice variable is theta

% some optimset iuseful function: 
% add ('PlotFcns', 'optimplotfval') pair: graph of the convergence of the
% objective function to its minimum value
% add ('Display', 'iter') pair: seeing a larger range of output including the procedure and the value of the objective function

%% 3.2 Generalized Method of Moments (GMM)
% key idea of GMM:
% \hat{\beta} makes the weighted quadratic distance mWm' to 0 or close to 0
clear
DataIn = dlmread('auto.csv');
X = [ones(74,1) DataIn(:,2:3)];
y = DataIn(:,1);
[Beta, Q] = fminsearch(@(B)GMMObjective(B,y,X), ...
    [10,0,0]', optimset('TolX',1e-9));
% fminsearch: minimize an objective function with no constraints