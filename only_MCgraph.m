% ������ ��� ���������� ������ ���������� ������ �� ������� ��������� 
% ���������� ���
%
% ��� ������� ���������� ������� � ������� ����� ������:
% linmod.mat
% LMA_results_for_VoltAngle.mat
% LMA_results_for_VoltMag.mat
%
%% ������ ���� � ������ �����������:
clear all
MC.Option.n_mode = 4; % ������ ������ ����� ���� (1...168)
MC.Option.n_model = 1; % ������ ���������� ����� ��������������� ������ (1...96)

norm_set = 1; % ������� ������������ �������� ���������� ���������: 
%                   1 - ������������ ���������, ������������� � �������� 
%                       �������� ��� ����� ������������� ������;
%                   0 - ������������ ���������, ������������� � �������� 
%                       �������� ��� ���� �������.
line_set = 0; % ������� ������� �������� ��� ������:
%                   1 - ����� ��� ������ �������������� ��� ������� ������� 
%                       ���������� ����� ������� � ������� ������� ����
%                   0 - �������� ��� ������ ���
nodelabel_set = 0; % ������� ������� � �����: 
%                   1 - � ����� ������������ ������ �����;
%                   0 - � ����� ������������ �������� ���������� ���������

[linmod,MC] = fun_onlyEvkiGraph(MC,norm_set,line_set,nodelabel_set);
clear norm_set line_set nodelabel_set

%% ������ ��������� ���������� ������ � ������� ������������
figure()
plotEcki = plot(linmod.var_par,...
    MC.VoltageMagnitude.Ecki(:,:,MC.Option.n_mode));
grid minor
title(['��������������� ��������� ����� ���� M',...
    num2str(MC.Option.n_mode),' � ��������� ����������'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEcki(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEcki = plot(linmod.var_par,...
    MC.VoltageMagnitude.Ecki_norm(:,:,MC.Option.n_mode));
grid minor
title(['������������� ��������� ����� ���� M',...
    num2str(MC.Option.n_mode),' � ��������� ����������'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEcki(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEcki = plot(linmod.var_par,...
    MC.VoltageMagnitude.Ecki_norm_sym(:,:,MC.Option.n_mode));
grid minor
title(['������������� ���������������� ��������� ����� ���� M',...
    num2str(MC.Option.n_mode),' � ��������� ����������'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEcki(i),'DisplayName',['Node',num2str(i)]);
end



figure()
plotEcki = plot(linmod.var_par,...
    MC.VoltageAngle.Ecki(:,:,MC.Option.n_mode));
grid minor
title(['��������������� ��������� ����� ���� M',...
    num2str(MC.Option.n_mode),' � ���� ����������'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEcki(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEcki = plot(linmod.var_par,...
    MC.VoltageAngle.Ecki_norm(:,:,MC.Option.n_mode));
grid minor
title(['������������� ��������� ����� ���� M',...
    num2str(MC.Option.n_mode),' � ���� ����������'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEcki(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEcki = plot(linmod.var_par,...
    MC.VoltageAngle.Ecki_norm_sym(:,:,MC.Option.n_mode));
grid minor
title(['������������� ���������������� ��������� ����� ���� M',...
    num2str(MC.Option.n_mode),' � ���� ����������'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEcki(i),'DisplayName',['Node',num2str(i)]);
end

%% ������� ���������� �����
function [linmod,MC] = fun_onlyEvkiGraph(MC,norm_set,line_set,nodelabel_set)

na = MC.Option.n_model;
nm = MC.Option.n_mode;

load 'linmod.mat' linmod

for type_sensetive = 1:2
    
    if type_sensetive == 1
        load 'LMA_results_for_VoltMag.mat' LMA
        name_sensetive = 'Voltage Magnitude';
        %MC.VoltageMagnitude = struct;
        MC.VoltageMagnitude.Ecki = LMA.Ecki;
        MC.VoltageMagnitude.Ecki_norm = LMA.Ecki_norm;
        MC.VoltageMagnitude.Ecki_norm_sym = LMA.Ecki_norm_sym;
    else
        load 'LMA_results_for_VoltAngle.mat' LMA
        name_sensetive = 'Voltage Angle';
        %MC.VoltageAngle = struct;
        MC.VoltageAngle.Ecki = LMA.Ecki;
        MC.VoltageAngle.Ecki_norm = LMA.Ecki_norm;
        MC.VoltageAngle.Ecki_norm_sym = LMA.Ecki_norm_sym;
    end
    
    for type_MC = 1:3
        
        if type_MC == 1
            Ecki = LMA.Ecki;
            name_MC = 'Modal contribution';
        elseif type_MC == 2
            Ecki = LMA.Ecki_norm;
            name_MC = 'Normalized Modal contribution';
        elseif type_MC == 3
            Ecki = LMA.Ecki_norm_sym;
            name_MC = 'Normalized Symmetrized Modal contribution';
        end
        
        if norm_set == 1
        %   ������������ ������������ ������ ��������� ��� ������������� k
            tmpEcki = Ecki(:,na,nm);
            maxEcki = max(abs(tmpEcki));
            for i = 1:size(tmpEcki,1)
                tmpEcki(i) = tmpEcki(i) / maxEcki;
            end
        else
        %   ������������ ������������ ������ ��������� ��� ���� k
            tmpEcki = squeeze(Ecki(:,:,nm));
            maxEcki = max(max(abs(tmpEcki)));
            tmpEcki = tmpEcki(:,na) ./ maxEcki;
        end

        if min(tmpEcki) < 0
            CLim = [-1 1]; % ������� ����� ColorBar
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
        % ������� ��� ������� (���� ������� line_set = 1)
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
        title([name_MC, ' in L2-norm of ', name_sensetive, ' of mode M',...
            num2str(nm), ' for model#', num2str(na)])
        colormap(jet)
        set(gca, 'CLim', CLim);
        colorbar;
    end
    
end



end