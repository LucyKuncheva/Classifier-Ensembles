function [labels,y] = median_combiner(x)
% --- Average combiner for continuous-valued outputs
% Input: ------------------------------------------------------------------
%       x:  classifier outputs to label
%           = array N(objects)-by-L(classifiers)-by-c(classes)
%           entry (i,j,k) is the probability for class k given to 
%           object i by classifier j ("probability" could be "support")
%
% Output:  ----------------------------------------------------------------
%  labels:  output labels for the rows of x           
%           = array N(objects)-by-1 of assigned labels (integers)
%       y:  ensemble probabilities           
%           = array N(objects)-by-c of assigned proabilities for the
%           c classes

y = squeeze(median(x,2));
[~,labels] = max(y,[],2); 
end