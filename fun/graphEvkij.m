function graphEvkij(na,n_imode,n_jmode,norm_set,nodelabel_set,Eckij,result_static)
if isempty(norm_set)
    tmpEvkij = Eckij(:,na);
    CLim = [min(tmpEvkij) max(tmpEvkij)];
elseif norm_set ==1
    %   нормирование относительно своего максимума при фиксированном k
    tmpEvkij = Eckij(:,na);
    maxEvkij = max(abs(tmpEvkij));
    for i = 1:size(tmpEvkij,1)
        tmpEvkij(i) = tmpEvkij(i) / maxEvkij;
    end
    if min(tmpEvkij) < 0
        CLim = [-1 1];
    else
        CLim = [0 1];
    end
elseif norm_set == 0
    %   нормирование относительно своего максимума при всех k
    tmpEvkij = Eckij(:,na);
    maxEvkij = max(max(abs(Eckij)));
    tmpEvkij = tmpEvkij ./ maxEvkij;
    if min(tmpEvkij) < 0
        CLim = [-1 1];
    else
        CLim = [0 1];
    end
end

edg1 = result_static.line(:,1);
edg2 = result_static.line(:,2);
G = graph(edg1, edg2);
G.Nodes.NodeColors = tmpEvkij;
figure()
p = plot(G,'MarkerSize',22,'LineWidth', 3,'EdgeColor', 'black',...
    'NodeFontSize',14, 'Layout','force', 'UseGravity', true);
p.NodeCData = G.Nodes.NodeColors;

    if nodelabel_set == 0
        p.NodeLabel = round(tmpEvkij,2);
        text_size = 10;
        text_color = 'black';
    else
        text_size = 14;
        text_color = 'w';
    end

% Add new labels that are to the upper, right of the nodes
text(p.XData+.01, p.YData+.01 ,p.NodeLabel, ...
    'VerticalAlignment','middle',...
    'HorizontalAlignment', 'center',...
    'FontSize', text_size, 'FontWeight','bold', 'Color', text_color)
% Remove old labels
p.NodeLabel = {}; 
title(['Modal interaction of modes M', num2str(n_imode), ' / M', num2str(n_jmode),...
    ' for model# ',num2str(na)])
colormap(jet)
set(gca, 'CLim', CLim);
colorbar;
end
