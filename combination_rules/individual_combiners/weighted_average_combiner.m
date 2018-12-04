function [labels,y] = weighted_average_combiner(x, w, ac)
% --- Weighter average combiner for continuous-valued outputs
% Input: ------------------------------------------------------------------
%       x:  classifier outputs to label
%           = array N(objects)-by-L(classifiers)-by-c(classes)
%           entry (i,j,k) is the probability for class k given to 
%           object i by classifier j ("probability" could be "support")
%       w:  weights for the combination
%           = array 1-by-L (classifiers)
%      ac:  accuracy of the individual classifiers
%           = array 1-by-L (classifiers)
%           If ac is given, this argument is used to calculate the weights
%           instead of directly using w 
% Output:  ----------------------------------------------------------------
%  labels:  output labels for the rows of x           
%           = array N(objects)-by-1 of assigned labels (integers)
%       y:  ensemble probabilities           
%           = array N(objects)-by-c of assigned proabilities for the
%           c classes

if nargin == 3
    w = (1./(1-ac+eps)) ./(sum(1./(1-ac+eps)));
end
A = repmat(w(:)',size(x,1),1,size(x,3));
y = squeeze(sum(x.*A,2));
[~,labels] = max(y,[],2); 
end