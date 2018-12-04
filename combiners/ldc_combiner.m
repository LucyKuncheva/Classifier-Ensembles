function [labels,y] = ldc_combiner(x,tro,trl)
% --- LDC combiner for continuous-valued outputs
% Input: ------------------------------------------------------------------
%       x:  classifier outputs to label
%           = array N(objects)-by-L(classifiers)-by-c(classes)
%           entry (i,j,k) is the probability for class k given to 
%           object i by classifier j ("probability" could be "support")
%     tro:  training outputs 
%           = array M(objects)-by-L(classifiers)-by-c(classes)
%     trl:  training labels 
%           = array M(objects)-by-1 (integer labels)
%           
% Output:  ----------------------------------------------------------------
%  labels:  output labels for the rows of x           
%           = array N(objects)-by-1 of assigned labels (integers)
%       y:  ensemble probabilities           
%           = array N(objects)-by-c of assigned proabilities for the
%           c classes

X = reshape(x(:),size(x,1),[]); % The decision profile is in a row for each 
% object
XX = reshape(tro(:),size(tro,1),[]); 

C = fitcdiscr(XX,trl);

[labels,y] = predict(C,X); 
