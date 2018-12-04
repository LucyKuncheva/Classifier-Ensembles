function C = train_linear(TrainingData,TrainingLabels,PARAM)
%
% Trains a linear discriminant classifier assuming normal distributions  
% and equal covariance matrices for the classes. 
%
% PARAM = array with the prior probabilities for the classes (optional)
%
% Constructs a structure C with the following fields
% C.name = classifier name
% C.valid labels = the labels of the classes which have at least
%    one element, arranged in ascending order (all numerical)
% C.term = free terms of the discriminant functions* 
%    (* for the valid classes only)
% C.coefficients = the coefficients of the discriminant functions,
%    to be multiplied by the feature values*
% C.mu = class means*
% C.inv_cov = inverted common covariance matrix
% C.Counts = number of elements in each valid class*
%
% ---- example ----
%
%     PARAM = ones(1,Classes)/Classes; % uniform priors
%     C = train_linear(TrainingData,TrainingLabels,PARAM)
%
%========================================================================
% (c) Fox's Classification Toolbox                                  ^--^
% v.1.0 2010 -----------------------------------------------------  \oo/


C.name = 'linear';
C.valid_labels = unique(TrainingLabels);

Classes = max(TrainingLabels);
VClasses = numel(C.valid_labels);
Features = size(TrainingData,2);

if (nargin == 2) || isempty(PARAM) 
    % Evaluate the prior probabilities from data
    for i = 1:Classes
        priors(i) = sum(TrainingLabels == i);
    end
    priors = priors/size(TrainingData,1);
else
    priors = PARAM;
end

% Train the classifier and put the result in C
% Find means
mu = []; % means
cv = zeros(Features); % the common covariance matrix
for i = 1:VClasses
    index = TrainingLabels == C.valid_labels(i);
        mu = [mu;mean(TrainingData(find(index),:),1)];
        if sum(index) > 1
            cv = cv + priors(i)*cov(TrainingData(find(index),:));
        end
    % Note that for empty classes no mean is added.
    % The covariance matrix is not updated if the number of elements
    % in the class is less than 2.
end

if isempty(cv) || rank(cv)< Features
    cv_inverted = eye(Features); % identity matrix if cv does not exist 
        % or is singular
else
    cv_inverted = inv(cv);
end

% Calculate the linear classifier
C.term = []; % the free term of the discriminant function
C.coefficients = [];  % the coefficients to be multiplied by 
                      % the feature values
for i = 1:VClasses;
    t = mu(i,:) * cv_inverted; 
    C.term = [C.term;...
        log(priors(C.valid_labels(i))) - 1/2 * t * mu(i,:)'];
    C.coefficients = [C.coefficients; t];
end

C.mu = mu;
C.inv_cov = cv_inverted;
for i = 1:VClasses;
    C.Counts(i) = sum(TrainingLabels == C.valid_labels(i));
end
