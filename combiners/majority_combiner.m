function labels = majority_combiner(x,~)
% --- Majority combiner for label outputs
% Input: ------------------------------------------------------------------
%       x:  classifier outputs to label
%           = array N(objects)-by-L(classifiers)
%           entry (i,j) is the label given to object i by classifier j
% Output:  ----------------------------------------------------------------
%  labels:  output labels for the rows of x           
%           = array N(objects)-by-1 of assigned labels (integers)

labels = mode(x,2); 
end