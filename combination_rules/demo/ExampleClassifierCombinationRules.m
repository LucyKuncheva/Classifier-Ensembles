function ExampleClassifierCombinationRules
close all
clc

global af af2 noise_value x y lb labtrue hh fnfs u comb L
fnfs = {'FontName','Candara','FontSize',12};
figure('position',get(0,'screensize'))
L = 50;
hh = [];

% Set the noise slider-----------------------------------------------------
noise_slider = uicontrol('style','slider','units','normalized',...
    'position',[0.02,0.2,0.01,0.6],'min',0,'max',50,...
    'callback','noise_slider_callback');
noise_text = uicontrol('style','text','units','normalized',...
    'position',[0.01,0.9,0.03,0.025],'string','Noise',...
    'backgroundcolor',get(gcf,'color'));
noise_value = uicontrol('style','text','units','normalized',...
    'position',[0.01,0.83,0.03,0.025],'string',get(noise_slider,'value'));
[h(1),h(2),h(3)] = deal(noise_slider,noise_text,noise_value);
set(h,fnfs{:})

% Set the axes for the fish data-------------------------------------------
af = axes('units','normalized','position',[0,0.2,0.5,0.7]);
hold on

af2 = axes('units','normalized','position',[0.5,0.2,0.5,0.7]);
hold on

[~,~,labtrue] = fish_data(50,0);

axes(af) %#ok<*MAXES>
[x,y,lb] = fish_data(50,get(noise_slider,'value'));
plot(x(lb == 1),y(lb == 1),'k.','markers',15)
plot(x(lb == 2),y(lb == 2),'k.','markers',15,...
    'color',[1, 1, 1])
axis([0 1 0 1]) % cut the figure to the unit square
axis square off % equalize and remove the axes

axes(af2)
plot(x(lb == 1),y(lb == 1),'k.','markers',15)
plot(x(lb == 2),y(lb == 2),'k.','markers',15,...
    'color',[1, 1, 1])
axis([0 1 0 1]) % cut the figure to the unit square
axis square off % equalize and remove the axes


% Set up the combiners
comb = uibuttongroup('units','normalized',...
    'position',[0.45,0.21,0.105,0.7],'title','Combiners',fnfs{:});
rbs = {'units','normalized','style','radiobutton',fnfs{:},...
    'parent',comb,'selected','off'};

u(1) = uicontrol(rbs{:},'String','Majority vote',...
    'pos',[0.05 0.9 0.9 0.07]);
u(2) = uicontrol(rbs{:},'String','Average',...
    'pos',[0.05 0.8 0.9 0.07]);
u(3) = uicontrol(rbs{:},'String','Product',...
    'pos',[0.05 0.7 0.9 0.07]);
u(4) = uicontrol(rbs{:},'String','Trained Linear',...
    'pos',[0.05 0.6 0.9 0.07]);
u(5) = uicontrol(rbs{:},'String','Weighted Average',...
    'pos',[0.05 0.5 0.9 0.07]);
u(6) = uicontrol(rbs{:},'String','Ridge Regression',...
    'pos',[0.05 0.4 0.9 0.07]);
u(7) = uicontrol(rbs{:},'String','Tree Combiner',...
    'pos',[0.05 0.3 0.9 0.07]);
u(8) = uicontrol(rbs{:},'String','Decision Templates',...
    'pos',[0.05 0.2 0.9 0.07]);
u(9) = uicontrol(rbs{:},'String','Naive Bayes',...
    'pos',[0.05 0.1 0.9 0.07]);
u(10) = uicontrol(rbs{:},'String','BKS',...
    'pos',[0.05 0.0 0.9 0.07]);

set(comb,'SelectedObject',[],'SelectionChangeFcn',@ButtonAction)
set(u,'Enable','off')
end

function ButtonAction(~,ev)
global u
bu = ev.NewValue;
switch bu
    case u(1), fhandle = @median;
    case u(2), fhandle = @mean;
    case u(3)
        fhandle = @(x) prod(x).^(1/size(x,1))./...
            (prod(x).^(1/size(x,1)) + prod(1-x).^(1/size(x,1)));
    case u(4), fhandle = @train_linear_combiner;
    case u(5), fhandle = @wa;
    case u(6), fhandle = @ridge_regression;
    case u(7), fhandle = @tree_combiner;
    case u(8), fhandle = @decision_templates;
    case u(9), fhandle = @naive_bayes;
    case u(10), fhandle = @bks;
end
plot_combiner(fhandle)
end


function w = wa(x)
% weighted average
global ac
t = (1./(1-ac)) ./(sum(1./(1-ac)));
A = repmat(t(:),1,size(x,2));
w = sum(x.*A);
end

function w = train_linear_combiner(x)
global lb
[~,~,P] = classify(x',x',lb);
w = P(:,1)';
end

function w = ridge_regression(x)
global lb
B0 = ridge(2-lb,x',0.5,0);
w = B0' *[ones(1,size(x,2)); x];
end

function w = tree_combiner(x)
global lb
T = fitctree(x',2-lb);
w = predict(T,x')';
end

function w = decision_templates(x)
global lb
y = x';
dt1 = mean(y(lb == 1,:));
dt2 = mean(y(lb == 2,:));
scores = pdist2([dt1;dt2],y);
w = exp(-scores(1,:))./(exp(-scores(1,:))+exp(-scores(2,:)));
end

function w = naive_bayes(x)
global lb
ela = round(x') + 1;
oul = nb_combiner(ela,ela,lb);
w = 2 - oul';
end

function w = bks(x)
global lb
ela = round(x') + 1;
oul = bks_combiner(ela,ela,lb);
w = 2 - oul';
end
