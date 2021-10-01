%%   Evki graph
norm_set = 1; % вариант нормирования величины узловых напряжений: 
%                   1 - относительно максимума, определенного в пределах 
%                       значений Evki для одной фиксированной матрицы А;
%                   0 - относительно максимума, определенного в пределах 
%                       значений Evki для всех матриц А.
line_set = 0; % вариант расчета надписей над рёбрами:
%                   1 - число над ребром рассчитывается как разница узловых 
%                       напряжений между большим и меньшим номером узла
%                   0 - надписей над рёбрами нет
number_of_mode = 26;
number_of_matrix = 2;
graphEvki(number_of_matrix,number_of_mode,norm_set,line_set,Ecki_new,...
    result_static);

%=========================================================================
%=========================================================================

% %%   Epf1ki graph
% norm_set = 1; % вариант нормирования величины мощности на линии: 
% %                   1 - относительно максимума, определенного в пределах 
% %                       значений Ecki для одной фиксированной матрицы А;
% %                   0 - относительно максимума, определенного в пределах 
% %                       значений Ecki для всех матриц А.
% %                   2 - без нормировки
% line_set = 2; % вариант оформления рёбер:
% %                   0 - цвет рёбер одинаковый, толщина зависит от Ecki 
% %                   1 - толщина рёбер одинаковая, цвет зависит от Ecki
% %                   2 - от Ecki зависит и толщина и цвет рёбер
% highlight_set = 1; % настройка выделения пути по заданному набору узлов:
% %                   0 - выделение отключено
% %                   1 - выделение включено
% %pathNode = [65 37 36 9 30 1 2 25 26 29 61 8 5 4 14 15 16 22 58 3 18 17 ...
%     %24 23 59 19 20 57 56];
% pathNode = [65 37 36 34 35 45 51 50 52 68];
% number_of_mode = 4;
% number_of_matrix = 1;
% [G] = graphEpfki(number_of_matrix,number_of_mode,norm_set,line_set,Ecki,...
%     result_static,pathNode,highlight_set);
% 
% %=========================================================================
% %=========================================================================
% 
% %%   Epf1kij graph
% norm_set = 1; % вариант нормирования величины мощности на линии: 
% %                   1 - относительно максимума, определенного в пределах 
% %                       значений Eckij для одной фиксированной матрицы А;
% %                   0 - относительно максимума, определенного в пределах 
% %                       значений Eckij для всех матриц А (не проверено).
% line_set = 2; % вариант оформления рёбер:
% %                   0 - цвет рёбер одинаковый, толщина зависит от Eckij 
% %                   1 - толщина рёбер одинаковая, цвет зависит от Eckij
% %                   2 - от Eckij зависит и толщина и цвет рёбер
% highlight_set = 0; % настройка выделения пути по заданному набору узлов:
% %                   0 - выделение отключено
% %                   1 - выделение включено
% pathNode = [65 37 36 34 35 45 51 50 52 68];
% number_of_matrix = 1;
% number_of_modes = [4 19];% нужно для формирования названия графа
% [G] = graphEpfkij(number_of_matrix,number_of_modes,norm_set,line_set,Eckij,...
%     result_static,pathNode,highlight_set);


%=========================================================================
%=========================================================================

%%   Evkij
%   нормирование относительно своего максимума при фиксированном k
number_of_matrix = 1;
na = number_of_matrix;
tmpEvkij = abs(Eckij(:,na));
maxEvkij = max(tmpEvkij);
for i = 1:size(tmpEvkij,1)
    tmpEvkij(i) = tmpEvkij(i) / maxEvkij;
end

[G,bus_int]=PlotGraph(Data.line,Data.bus);
G.Nodes.NodeColors = tmpEvkij;
figure()
p = plot(G);
p.NodeCData = G.Nodes.NodeColors;
title('Evkij mode 31/29, k=0.75')
colorbar

%%   нормирование относительно своего максимума при всех k
number_of_matrix = 52;
na = number_of_matrix;
tmpEvkij = abs(Eckij_new);
maxEvkij = max(max(tmpEvkij));
tmpEvkij = tmpEvkij ./ maxEvkij;

%[G,bus_int]=PlotGraph(Data.line,Data.bus);
edg1 = result_static.line(:,1);
edg2 = result_static.line(:,2);
G = graph(edg1, edg2);
G.Nodes.NodeColors = tmpEvkij(:,na);
figure()
p = plot(G,'MarkerSize',22,'LineWidth', 3,'EdgeColor', 'black',...
    'NodeFontSize',14, 'Layout','force', 'UseGravity', true);
p.NodeCData = G.Nodes.NodeColors;
% Add new labels that are to the upper, right of the nodes
text(p.XData+.01, p.YData+.01 ,p.NodeLabel, ...
    'VerticalAlignment','middle',...
    'HorizontalAlignment', 'center',...
    'FontSize', 14, 'FontWeight','bold', 'Color', 'w')
% Remove old labels
p.NodeLabel = {}; 
title('Evkij modes 4/26, k=0.95 (new)')
colormap(jet)
set(gca, 'CLim', [0 1]);
colorbar;

