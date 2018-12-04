function labels = decision_templates_combiner(x,tro,trl)
% --- Decision template combiner for continuous-valued outputs
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

for i = 1:size(x,3) % for each class
    m = mean(XX(trl == i,:),1);
    d(:,i) = pdist2(X,m);
end

[~,labels] = min(d,[],2); 
end