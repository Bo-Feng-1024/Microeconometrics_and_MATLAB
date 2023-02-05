%% 2.1 Profit Maximization: linear programming problems
% 
% command syntax: 
% [x, fval, exitflag] = linprog(f, A, b, Aeq, beq, ...
%     lb, ub, x0) % solve linear programming problem
% 
% optimization problem:
% min_{x}f'x s.t. A*x <= b; Aeq*x = beq; lb <= x <= ub;
% 
% output: 
% x: the optimal solution to the linear programming problem
% fval: the value of the objective function at the optimal x
% exitflag: variable that returns information about the optimization procedure, i.e. whether a minimum was reached, or whether the problem is 
% infeasible or was not solved adequately.

% case 1: argmax R(a,b)=143a+60b s.t. 110a+30b <= 4000; 120a+210b <= 15000
f = [-143; -60]; % why minus: linprog is to minimize the object function, but we want to maximize
A = [1, 1; 110, 30; 120, 210];
b = [75; 4000; 15000];
lb = zeros(2,1); % farmer cannot plant a negative acrn of crops
[crops, obj, ~] = linprog(f, A, b, [],[], lb);

%% 2.2 Utility Maximization: solve non-linear
% 
% command syntax: 
% [x, fval, exitflag] = fmincon(fun, x0, A, b, Aeq, ...
%     beq, lb, ub, nonlcon, options)
% nonlcon: function to return the value oc c(x) and ceq(x) 
% 
% optimization problem: 
% min_{x}f(x) s.t. A*x <= b; Aeq*x = beq; c(x) <= 0; ceq(x) = 0; lb <= x<= ub
% 
% note: unlike linprog, fmincon need an first guess x0 
I = 100; % budget constraint
P = [4, 7]; % price
G = [15, 5]; % initial guess
lb = [0, 0]; % lower bound
[consumption, u, exitflag] =...
    fmincon(@CobbDouglas, ...
    G, P, I, [], [], lb)

% optimset: ask MATLAB to use a particular algorithm, to set the value
% that the gradient must take at the "optimum", and to control the step
% size of the search path.
% e.g.: use sequential quadratic programming (SQP) algorithm
opts = optimset('algorithm', 'sqp');
[consumption, u, exitflag] = ...
    fmincon(@CobbDouglas,...
    G, P, I, [], [], lb, [], [], opts) % @ shows that it's a function

% exitflag =1 or 2 is a reasonable sign of success

%% 2.3 Simulating Economic Models
% generate random distribution
% uniform: rand()
% normal: randn()
% lognormal: lognrnd()
% multivariate normal: mvnrnd()
% and many others: random(distbn, )

%----(1) Setup, simulation of random variation --
clear

% random variation in prices
P =[50, 200];
reps = 100; % 100 individuals
pshock = [rand(reps, 1) * 50, zeros(reps, 1)]; % price shock by drawing errors from the random uniform dist and *50
I =10000; % income

%---(2) Determine optimal consumption in each case ----
x0 = [1, 1];
lb = [0, 0];
opts = optimset('algorithm', 'sqp',...
    'display', 'off');

c = NaN(reps, 2); % 
for i = 1:reps
    TempP = P + pshock(i, :);
    ub = I./TempP;
    c(i, :) = fmincon(@CobbDouglas,[1, 1],TempP,...
    I,[],[],lb,ub, [], opts);
end

%---(3) Visualize results -----------------------
subplot(1, 2, 1)
scatter(c(:,1), c(:,2))
xlabel('Good 1 Consumption')
ylabel('Good 2 Consumption')

subplot(1,2,2)
cdfplot(c(:, 1))
xlabel('Good 1 Consumption')
ylabel('F(p_1)')