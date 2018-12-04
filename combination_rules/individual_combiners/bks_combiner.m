function oul = bks_combiner(otl,ree,rel)
% --- BKS combiner for label outputs
% Input: ------------------------------------------------------------------
%     otl:  outputs to label
%           = array N(objects)-by-L(classifiers)
%           entry (i,j) is the label of object i
%           by classifier j (integer labels)
%     ree:  reference ensemble
%           = array M(objects)-by-L(classifiers)
%           entry (i,j) is the label of object i
%           by classifier j (integer labels)
%     rel:  reference labels
%           = array M(objects)-by-1 
%           true labels (integers)
% Output:  ----------------------------------------------------------------
%    oul:   output labels
%           = array N(objects)-by-1 
%           assigned labels (integers)

N = size(otl,1);
M = size(ree,1);
largest_class = mode(rel);
oul = zeros(N,1); % pre-allocate for speed
for i = 1:N
    matches = sum(ree ~= repmat(otl(i,:),M,1),2) == 0;
    if sum(matches)
        oul(i) = mode(rel(matches));
    else % there is no match in the reference 
        % ensemble output; use the largest prior
        oul(i) = largest_class;
    end 
end

