%%   Evki graph
norm_set = 1; % ������� ������������ �������� ������� ����������: 
%                   1 - ������������ ���������, ������������� � �������� 
%                       �������� Evki ��� ����� ������������� ������� �;
%                   0 - ������������ ���������, ������������� � �������� 
%                       �������� Evki ��� ���� ������ �.
line_set = 0; % ������� ������� �������� ��� ������:
%                   1 - ����� ��� ������ �������������� ��� ������� ������� 
%                       ���������� ����� ������� � ������� ������� ����
%                   0 - �������� ��� ������ ���
number_of_mode = 26;
number_of_matrix = 2;
graphEvki(number_of_matrix,number_of_mode,norm_set,line_set,Ecki_new,...
    result_static);

%=========================================================================
%=========================================================================

% %%   Epf1ki graph
% norm_set = 1; % ������� ������������ �������� �������� �� �����: 
% %                   1 - ������������ ���������, ������������� � �������� 
% %                       �������� Ecki ��� ����� ������������� ������� �;
% %                   0 - ������������ ���������, ������������� � �������� 
% %                       �������� Ecki ��� ���� ������ �.
% %                   2 - ��� ����������
% line_set = 2; % ������� ���������� ����:
% %                   0 - ���� ���� ����������, ������� ������� �� Ecki 
% %                   1 - ������� ���� ����������, ���� ������� �� Ecki
% %                   2 - �� Ecki ������� � ������� � ���� ����
% highlight_set = 1; % ��������� ��������� ���� �� ��������� ������ �����:
% %                   0 - ��������� ���������
% %                   1 - ��������� ��������
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
% norm_set = 1; % ������� ������������ �������� �������� �� �����: 
% %                   1 - ������������ ���������, ������������� � �������� 
% %                       �������� Eckij ��� ����� ������������� ������� �;
% %                   0 - ������������ ���������, ������������� � �������� 
% %                       �������� Eckij ��� ���� ������ � (�� ���������).
% line_set = 2; % ������� ���������� ����:
% %                   0 - ���� ���� ����������, ������� ������� �� Eckij 
% %                   1 - ������� ���� ����������, ���� ������� �� Eckij
% %                   2 - �� Eckij ������� � ������� � ���� ����
% highlight_set = 0; % ��������� ��������� ���� �� ��������� ������ �����:
% %                   0 - ��������� ���������
% %                   1 - ��������� ��������
% pathNode = [65 37 36 34 35 45 51 50 52 68];
% number_of_matrix = 1;
% number_of_modes = [4 19];% ����� ��� ������������ �������� �����
% [G] = graphEpfkij(number_of_matrix,number_of_modes,norm_set,line_set,Eckij,...
%     result_static,pathNode,highlight_set);


%=========================================================================
%=========================================================================

%%   Evkij
%   ������������ ������������ ������ ��������� ��� ������������� k
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

%%   ������������ ������������ ������ ��������� ��� ���� k
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

