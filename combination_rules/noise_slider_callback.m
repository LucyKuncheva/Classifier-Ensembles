function noise_slider_callback

global af af2 noise_value x y hh L

set(noise_value,'string',get(gco,'value'))

[x,y,lb] = fish_data(50,get(gco,'value'));
axes(af) %#ok<*MAXES>
cla
hold on
%set(gca,'FontName','Calibri','FontSize',24)
plot(x(lb == 1),y(lb == 1),'k.','markers',15)
plot(x(lb == 2),y(lb == 2),'k.','markers',15,...
    'color',[1 1 1])
axis([0 1 0 1]) % cut the figure to the unit square
axis square off % equalize and remove the axes
create_ensemble_callback(L)

axes(af2) %#ok<*MAXES>
cla
hold on
%set(gca,'FontName','Calibri','FontSize',24)
plot(x(lb == 1),y(lb == 1),'k.','markers',15)
plot(x(lb == 2),y(lb == 2),'k.','markers',15,...
    'color',[1 1 1])
axis([0 1 0 1]) % cut the figure to the unit square
axis square off % equalize and remove the axes
create_ensemble2_callback(L)

hh = [];