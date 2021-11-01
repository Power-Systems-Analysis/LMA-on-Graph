function graphEvki(n_mat,n_mode,norm_set,line_set,nodelabel_set,Ecki,linmod)

if norm_set == 1 
%   нормирование относительно своего максимума при фиксированном k
    na = n_mat;
    nm = n_mode;
    tmpEcki = Ecki(:,na,nm);
    maxEcki = max(abs(tmpEcki));
    for i = 1:size(tmpEcki,1)
        tmpEcki(i) = tmpEcki(i) / maxEcki;
    end
else
%   нормирование относительно своего максимума при всех k
    na = n_mat;
    nm = n_mode;
    tmpEcki = squeeze(Ecki(:,:,nm));
    maxEcki = max(max(abs(tmpEcki)));
    tmpEcki = tmpEcki(:,na) ./ maxEcki;
end

if min(tmpEcki) < 0
    CLim = [-1 1]; % пределы шкалы ColorBar
else
    CLim = [0 1];
end

edg1 = linmod.line(:,1);
edg2 = linmod.line(:,2);
G = graph(edg1, edg2);
G.Nodes.NodeColors = tmpEcki;
figure()
p = plot(G,'MarkerSize',20,'LineWidth', 3,'EdgeColor', 'black',...
    'NodeFontSize',14, 'Layout','force', 'UseGravity', true);
% надписи над ребрами (если выбрано line_set = 1)
if line_set == 1
   deltaVline = table2array(G.Edges);
   for k = 1 : length(edg1)
        lar_id = max(deltaVline(k,1),deltaVline(k,2));
        les_id = min(deltaVline(k,1),deltaVline(k,2));
        larE = abs(Ecki(lar_id,na,nm));
        lesE = abs(Ecki(les_id,na,nm));
        deltaVline(k,3) = larE - lesE;
    end    
        p.EdgeLabel = deltaVline(:,3);
end
p.NodeCData = G.Nodes.NodeColors;

    if nodelabel_set == 0
        p.NodeLabel = round(tmpEcki,2);
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
title(['Modal contribution of mode M', num2str(nm), ' for model#', num2str(na)])
colormap(jet)
set(gca, 'CLim', CLim);
colorbar;

end