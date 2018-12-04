function oul = nb_combiner(otl,ree,rel)
% --- Naive Bayes (NB) combiner for label outputs
% Input: ----------------------------------------
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
% Output:  --------------------------------------
%    oul:   output labels
%           = array N(objects)-by-1 
%           assigned labels (integers)

% Training --------------------------------------
c = max(rel); % number of classes, assuming that the 
% class labels are integers 1,2,3,...,c
L = size(ree,2); % number of classifiers

for i = 1:c
    cN(i) = sum(rel == i); % class counts
end

for i = 1:L
    % cross-tabulate the classes to find the 
    % confusion matrices
    for j1 = 1:c
        for j2 = 1:c
            CM(i).cm(j1,j2) = (sum(rel == j1 & ree(:,i) ...
                == j2) + 1/c) / (cN(j1) + 1);
            % correction for zeros included
        end
    end
end
            
% Operation -------------------------------------
N = size(otl,1);
oul = zeros(N,1); % pre-allocate for speed
for i = 1:N
    P = cN/numel(rel);
    for j = 1:c % calculate the score for each class
        for k = 1:L
            P(j) = P(j) * CM(k).cm(j,otl(i,k));
        end
    end
    [~,oul(i)] = max(P); 
end

