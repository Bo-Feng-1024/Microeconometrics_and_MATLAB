x = [1, 2; 3, 4; 5, 6];
who % check which matrices are stored in memory
help ones

%% 1.1 OLS in MATLAB: 'Hello, world!'
pwd % print working directory
cd /Users/mac/Downloads/Microeconometrics_and_MATLAB % change directory
ls % list the contents of the current directory
DataIn = dlmread('auto.csv'); % read data
whos('DataIn')
y = DataIn(:,1); % we take data fromevery single row (':') of column 1 in matrix DataIn.
X = DataIn(:, 2:3);
size(X)
X = [X, ones(74,1)];

% run regression
XX = X'*X;
Xy = X'*y;
BetaHat = inv(XX)'*Xy;

format long % changing Matlab s output format to the long format
format % change it back

%% 1.2 The Beauty of Functions
% the comments which immediately followthe first line can be shown in the
% help command: e.g, help OLS
help OLS
OLS(y, X)
barack = y;
hilary = X;
[OLS_Beta, OLS_se] = OLS(barack, hilary);
[OLS_Beta, OLS_se] % report horizontal concatenation

%% 1.3 A Simple Utility Function
UtilitySimple(1, 4)
x1 = [1: 10]';
x2 = 5;
UtilitySimple(x1, x2) % error! Incorrect dimensions for raising a matrix to a power. Check that the matrix is square and the power is a scalar. 
[x1, x2] = meshgrid([0:3], [0:3]);
u = Utility(x1, x2);
surfc(x1, x2, u) %  surfc: Combination surf/contour plot
