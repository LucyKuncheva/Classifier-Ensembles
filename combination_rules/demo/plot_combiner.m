function plot_combiner(aggregation_function)
global af af2 P1 P2 x y labtrue hh fnfs

zz = aggregation_function(P1');
output = 2 - round(zz)';

delete(hh)

hh(1) = plot(af,x(output==1),y(output==1),'bo',...
    'markersize',6,'linewidth',2.5);
accuracy_ens = mean(output == labtrue);
hh(3) = uicontrol('style','text','units','normalized',...
    'position',[0.21,0.13,0.07,0.04],'string',...
    sprintf('%.2f %%',accuracy_ens*100),...
    'backgroundcolor',get(gcf,'color'),fnfs{:},'fontsize',22);


zz = aggregation_function(P2');
output = 2 - round(zz)';
hh(2) = plot(af2,x(output==1),y(output==1),'bo',...
    'markersize',6,'linewidth',2.5);
accuracy_ens = mean(output == labtrue);
hh(4) = uicontrol('style','text','units','normalized',...
    'position',[0.75,0.13,0.07,0.04],'string',...
    sprintf('%.2f %%',accuracy_ens*100),...
    'backgroundcolor',get(gcf,'color'),fnfs{:},'fontsize',22);

