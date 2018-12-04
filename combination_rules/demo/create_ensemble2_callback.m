function create_ensemble2_callback(L)

global af2 x y lb P2 u ac

% Generate and plot the ensemble of linear classifiers
% L = ensemble size

sc = 2; % scaling constant 
N = numel(x); % number of data points
ensemble = zeros(N,L); % pre-allocate for speed
P2 = zeros(N,L); % pre-allocate for speed
ac = zeros(1,L); % pre-allocate for speed
for i = 1:L
    bs = randi(N,1,N); % bootsrtap sample
    tr = [x(bs),y(bs)]; trl = lb(bs);
    C = train_linear(tr,trl);
    t = C.coefficients;
    w = t(1,:) - t(2,:);
    t = C.term;
    w0 = t(2) - t(1);
    plot(af2,[0 1],[w0, (w0-w(1))]/w(2),'r-',...
        'linewidth',0.5) % plot the linear boundary
    drawnow
    % Posteriors
    ou = [x y] * w' - w0;
    
    t = 2  - (ou > 0);
    ac(i) = mean(t == lb);
    ensemble(:,i) = t; % store output of classifier i
    P2(:,i) = 1./(1 + exp(-ou * sc));
end
set(u,'Enable','on')
end
