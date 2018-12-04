function create_ensemble_callback(L)

global af x y lb P1 comb u ac

set(comb,'SelectedObject',[])
set(u,'Enable','off')

% Generate and plot the ensemble of linear classifiers
% L = ensemble size

sc = 2; % scaling constant 
N = numel(x); % number of data points
ensemble = zeros(N,L); % pre-allocate for speed
P1 = zeros(N,L); % pre-allocate for speed
ac = zeros(1,L); % pre-allocate for speed
for i = 1:L
    p = rand(1,2); % random point in the unit square
    w = randn(1,2); % random normal vector to the line
    w0 = p * w'; % the free term (neg)
    plot(af,[0 1],[w0, (w0-w(1))]/w(2),'r-',...
        'linewidth',0.5) % plot the linear boundary
    drawnow
    % Posteriors
    ou = [x y] * w' - w0;    
    t = 2  - (ou > 0);
    ac(i) = mean(t == lb);
    if  ac(i) < 0.5
        t = 3-t;
        ou = -ou;
        ac(i) = 1-ac(i);
    end % revert labels
    ensemble(:,i) = t; % store output of classifier i
    P1(:,i) = 1./(1 + exp(-ou * sc));
end
end
