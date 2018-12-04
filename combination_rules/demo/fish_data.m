function [x,y,labels] = fish_data(grid_size,noise)
% --- generates the fish data set
% Input: ----------------------------------------
%    grid_size:  number of points on one side
%    noise:      percent label noise
% Output:  --------------------------------------
%    x,y:        point coordinates
%    labels:     labels = 1 (black) or 2 (gray)

% Create the 2d data as all the points on a square grid
[X,Y] = meshgrid(1:grid_size,1:grid_size);
x = X(:)/grid_size; y = Y(:)/grid_size; % scale in [0,1]

% Generate the class labels
lab1 = x.^3 - 2*x.*y + 1.6*y.^2 < 0.4; % componenet 1
lab2 = -x.^3 + 2*sin(x).*y + y < 0.7; % componenet 2
la = xor(lab1,lab2);

if noise > 0
    N = grid_size^2;
    rp = randperm(N); % shuffle
    to_change = rp(1:round(noise/100 * N));
    la(to_change) = 1 - la(to_change); % flip labels
end

labels = 2 - la;

