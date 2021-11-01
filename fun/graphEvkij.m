function graphEvkij(na,n_imode,n_jmode,norm_set,Eckij,result_static)
if norm_set ==1
    %   нормирование относительно своего максимума при фиксированном k
    tmpEvkij = abs(Eckij(:,na));
    maxEvkij = max(tmpEvkij);
    for i = 1:size(tmpEvkij,1)
        tmpEvkij(i) = tmpEvkij(i) / maxEvkij;
    end
else
    %   нормирование относительно своего максимума при всех k
    tmpEvkij = abs(Eckij);
    maxEvkij = max(max(tmpEvkij));
    tmpEvkij = tmpEvkij ./ maxEvkij;
end

% [G,bus_int]=PlotGraph(Data.line,Data.bus);
% G.Nodes.NodeColors = tmpEvkij;
% figure()
% p = plot(G);
% p.NodeCData = G.Nodes.NodeColors;
% title('Evkij mode 4/26, k=0.01')
% colorbar



edg1 = result_static.line(:,1);
edg2 = result_static.line(:,2);
G = graph(edg1, edg2);
G.Nodes.NodeColors = tmpEvkij;
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
title(['Modal interaction of modes M', num2str(n_imode), ' / M', num2str(n_jmode),...
    ' for model# ',num2str(na)])
colormap(jet)
set(gca, 'CLim', [0 1]);
colorbar;
end
