function graphEvki(number_of_matrix,number_of_mode,norm_set,line_set, Evki,...
    result_static)

if norm_set == 1 
%   нормирование относительно своего максимума при фиксированном k
    na = number_of_matrix;
    nm = number_of_mode;
    tmpEvki = abs(Evki(:,na,nm));
    maxEvki = max(tmpEvki);
    for i = 1:size(tmpEvki,1)
        tmpEvki(i) = tmpEvki(i) / maxEvki;
    end
else
%   нормирование относительно своего максимума при всех k
    na = number_of_matrix;
    nm = number_of_mode;
    tmpEvki = abs(squeeze(Evki(:,:,nm)));
    maxEvki = max(max(tmpEvki));
    tmpEvki = tmpEvki(:,na) ./ maxEvki;
end

edg1 = result_static.line(:,1);
edg2 = result_static.line(:,2);
G = graph(edg1, edg2);
G.Nodes.NodeColors = tmpEvki;
figure()
p = plot(G,'MarkerSize',20,'LineWidth', 3,'EdgeColor', 'black',...
    'NodeFontSize',14, 'Layout','force', 'UseGravity', true);
% надписи над ребрами (если выбрано line_set = 1)
if line_set == 1
   deltaVline = table2array(G.Edges);
   for k = 1 : length(edg1)
        lar_id = max(deltaVline(k,1),deltaVline(k,2));
        les_id = min(deltaVline(k,1),deltaVline(k,2));
        larE = abs(Evki(lar_id,na,nm));
        lesE = abs(Evki(les_id,na,nm));
        deltaVline(k,3) = larE - lesE;
    end    
        p.EdgeLabel = deltaVline(:,3);
end


p.NodeCData = G.Nodes.NodeColors;
% Add new labels that are to the upper, right of the nodes
text(p.XData+.01, p.YData+.01 ,p.NodeLabel, ...
    'VerticalAlignment','middle',...
    'HorizontalAlignment', 'center',...
    'FontSize', 14, 'FontWeight','bold', 'Color', 'w')
% Remove old labels
p.NodeLabel = {}; 
title(['Evki mode M', num2str(nm), '  k = ', num2str((na-1)/100)])
colormap(jet)
set(gca, 'CLim', [0 1]);
colorbar;

end