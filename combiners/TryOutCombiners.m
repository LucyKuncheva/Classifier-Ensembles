clear, clc, close all

% Generate the data -------------------------------------------------------

% Training
N1 = 100; N2 = 30; N3 = 50; N = N1 + N2 + N3;
class1 = mvnrnd([0,0],[2 1;1 6],N1);
class2 = mvnrnd([-1,4],[7 -2;-2 2],N2);
class3 = mvnrnd([3,-2],[4 1;1 3],N3);
training_data = [class1;class2;class3];
training_labels = [ones(N1,1);ones(N2,1)*2;ones(N3,1)*3];

% Testing
class1 = mvnrnd([0,0],[2 1;1 6],N1);
class2 = mvnrnd([-1,4],[7 -2;-2 2],N2);
class3 = mvnrnd([3,-2],[4 1;1 3],N3);
testing_data = [class1;class2;class3];
testing_labels = training_labels;

% Train the ensemble ------------------------------------------------------
L = 50; % ensemble size
for i = 1:L
    ri = randi(N,1,N); % bootstrap index
    trd = training_data(ri,:); trl = training_labels(ri); % sample
    T{i} = fitctree(trd,trl); % classifier
    [p,q] = T{i}.predict(training_data);
    tr_individual(:,i) = p; % labels
    tr_individual_posteriors(:,i,:) = q;
    [p,q] = T{i}.predict(testing_data);
    ts_individual(:,i) = p; % labels
    ts_individual_posteriors(:,i,:) = q;
end

% Combination rules -------------------------------------------------------

% >>> CHOOSE THE COMBINER =================================================
% >>> Uncomment the two rows of the combiner you want to use:
%
% === Label outputs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% comb_str = 'MAJORITY VOTE'; lv = true; % label-valued 
% comb = @majority_combiner; param = {};
%
% comb_str = 'BKS'; lv = true;
% comb = @bks_combiner; param = {tr_individual,training_labels};
%
% comb_str = 'NAIVE BAYES'; lv = true;
% comb = @nb_combiner; param = {tr_individual,training_labels};
%
% === Continuous-valued outputs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% comb_str = 'AVERAGE'; lv = false;
% comb = @average_combiner; param = {};
% 
% comb_str = 'MEDIAN'; lv = false;
% comb = @median_combiner; param = {};
%
% comb_str = 'MINIMUM'; lv = false;
% comb = @minimum_combiner; param = {};
% 
% comb_str = 'MAXIMUM'; lv = false;
% comb = @maximum_combiner; param = {};
% 
% comb_str = 'PRODUCT'; lv = false;
% comb = @product_combiner; param = {};
%
% comb_str = 'WEIGHTED AVERAGE (random weights)'; lv = false;
% comb = @weighted_average_combiner; param = {[],rand(1,L)};
% % Note, this is the syntax for random class accuracies, for random 
% % weights w, use param = {rand(1,L)};
%
% comb_str = 'RIDGE REGRESSION'; lv = false;
% comb = @ridge_regression_combiner; param = ...
%     {tr_individual_posteriors,training_labels};
% 
% comb_str = 'DECISION TEMPLATES'; lv = false;
% comb = @decision_templates_combiner; param = ...
%     {tr_individual_posteriors,training_labels};
%
% comb_str = 'LDC COMBINER'; lv = false;
% comb = @ldc_combiner; param = ...
%     {tr_individual_posteriors,training_labels};
%
comb_str = 'TREE COMBINER'; lv = false;
comb = @tree_combiner; param = ...
    {tr_individual_posteriors,training_labels};



%==========================================================================

% Training and testing accuracy
if lv
    tr_ens_labels = comb(tr_individual,param{:});
    ts_ens_labels = comb(ts_individual,param{:});
else
    tr_ens_labels = comb(tr_individual_posteriors,param{:});
    ts_ens_labels = comb(ts_individual_posteriors,param{:});
end

fprintf('\nCombiner: %s\n',comb_str)
fprintf('    Training accuracy %.4f\n',...
    mean(tr_ens_labels == training_labels))
fprintf('    Testing accuracy  %.4f\n',...
    mean(ts_ens_labels == testing_labels))


% [Optional] Plot regions -------------------------------------------------
flag = true; % set to false if you don't want to plot the regions

if flag
    t = linspace(-12,12,150);
    [x,y] = meshgrid(t,t); % generate grid point coordinates
    for i = 1:L
        [p,q] = T{i}.predict([x(:) y(:)]);
        gr_individual(:,i) = p; %#ok<*SAGROW> % labels
        gr_individual_posteriors(:,i,:) = q;
    end
    if lv
        g = comb(gr_individual,param{:});
    else
        g = comb(gr_individual_posteriors,param{:});
    end
    
    figure, hold on, axis equal off
    scatter(x(:),y(:),6,g+max(training_labels),'filled')
    % Overlay the training data
    scatter(training_data(:,1),training_data(:,2),12,...
        training_labels,'filled');
    colormap([0 0 0;0 0 1;0 1 0;[1 1 1]*0.67; 0.86 0.86 1; 0.86 1 0.86])
end

