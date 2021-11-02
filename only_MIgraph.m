% ������ ��� ���������� ��������� �������������� ������������ ��� ��� �
% ���������� �����.
%
% ��� ������� ���������� ������� � ������� ����� ������:
% linmod.mat
% LMA_results_for_VoltAngle.mat
% LMA_results_for_VoltMag.mat
% ����� LMA_on_graph � ��������� funEckij.m � funEckij_sym.m
%
%% 1. ������ ������ ������������ � ���� � �������� ���
clear all
load 'linmod' linmod % ��� �������� ������� ����������
addpath([pwd,'\LMA_on_graph']);

%% 2. ��������� ��������������� ��������� ��������������

% 2.1. ����� ������ ���, �������������� ������� ����� ��������� (������ �������)
MI.Option.n_imode = 4;
MI.Option.n_jmode = 26;

% 2.2. �������� ��������� �������
% ��� ����������-������������ ��������� �������
MI.Option.x0 = [];

% ��� ������������ ��������� ������� (����� ������ ��������� ������� x0)
% x0 = zeros(linmod.number_of_mode,1);
% x0([1 12:13 24:25 36:37 48:49 60:61 72:73 84:85 ...
%     96:97 108:109 120:121 132:133 144:145 150:151 156:157 162:163]) = 1;

% 2.3. ��������� ������������������ � ���������������� ���������
% �������������� ��� �������� � ���

MI.Option.n_node = 1 : linmod.number_of_node;
MI.Option.n_mat = 1 : linmod.number_of_models;

% ��� ���������
[MI.VoltageMagnitude.Eckij] = funEckij(linmod.Vseq,linmod.Wseq,linmod.Dseq,...
    MI.Option.n_imode,MI.Option.n_jmode,MI.Option.n_mat,MI.Option.n_node,...
    linmod.C.c_v,MI.Option.x0);
[MI.VoltageMagnitude.Eckij_sym] = funEckij_sym(linmod.Vseq,linmod.Wseq,...
    linmod.Dseq,MI.Option.n_imode,MI.Option.n_jmode,MI.Option.n_mat,...
    MI.Option.n_node,linmod.C.c_v,MI.Option.x0);

% ��� ����
[MI.VoltageAngle.Eckij] = funEckij(linmod.Vseq,linmod.Wseq,linmod.Dseq,...
    MI.Option.n_imode,MI.Option.n_jmode,MI.Option.n_mat,MI.Option.n_node,...
    linmod.C.c_ang,MI.Option.x0);
[MI.VoltageAngle.Eckij_sym] = funEckij_sym(linmod.Vseq,linmod.Wseq,...
    linmod.Dseq,MI.Option.n_imode,MI.Option.n_jmode,MI.Option.n_mat,...
    MI.Option.n_node,linmod.C.c_ang,MI.Option.x0);

%% 3. ������ ���� ���������� �������������� ��� ��� n_imode � n_jmode ��� ������ n_model
norm_set = 1; % ������� ������������ �������� ���������� ���������: 
%                   1 - ������������ ���������, ������������� � �������� 
%                       �������� ��� ����� ������������� ������;
%                   0 - ������������ ���������, ������������� � �������� 
%                       �������� ��� ���� �������.
nodelabel_set = 0; % ������� ������� � �����: 
%                   1 - � ����� ������������ ������ �����;
%                   0 - � ����� ������������ �������� ���������� ���������
n_model = 52; % ������ ���������� ����� ��������������� ������ �� ������� n_mat

MI = fun_onlyEvkijGraph(n_model,norm_set,MI,linmod,nodelabel_set);
%% 4. ������ ��������� ���������� �������������� � ������� ������������ (��������� ����� �.3)
figure()
plotEckij = plot(linmod.var_par,MI.VoltageMagnitude.Eckij);
grid minor
title(['��������� �������������� ��� M', num2str(MI.Option.n_imode),...
    ' � M', num2str(MI.Option.n_jmode), ' � ��������� ����������'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEckij = plot(linmod.var_par,MI.VoltageMagnitude.Eckij_sym);
grid minor
title(['���������������� ��������� �������������� ��� M', num2str(MI.Option.n_imode),...
    ' � M', num2str(MI.Option.n_jmode), ' � ��������� ����������'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEckij = plot(linmod.var_par,MI.VoltageMagnitude.Eckij_norm);
grid minor
title(['������������� ��������� �������������� ��� M', num2str(MI.Option.n_imode),...
    ' � M', num2str(MI.Option.n_jmode), ' � ��������� ����������'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEckij = plot(linmod.var_par,MI.VoltageMagnitude.Eckij_norm_sym);
grid minor
title(['������������� ���������������� ��������� �������������� ��� M',...
    num2str(MI.Option.n_imode),' � M', num2str(MI.Option.n_jmode),...
    ' � ��������� ����������'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end


figure()
plotEckij = plot(linmod.var_par,MI.VoltageAngle.Eckij);
grid minor
title(['��������� �������������� ��� M', num2str(MI.Option.n_imode),...
    ' � M', num2str(MI.Option.n_jmode), ' � ���� ����������'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEckij = plot(linmod.var_par,MI.VoltageAngle.Eckij_sym);
grid minor
title(['���������������� ��������� �������������� ��� M', num2str(MI.Option.n_imode),...
    ' � M', num2str(MI.Option.n_jmode), ' � ���� ����������'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEckij = plot(linmod.var_par,MI.VoltageAngle.Eckij_norm);
grid minor
title(['������������� ��������� �������������� ��� M', num2str(MI.Option.n_imode),...
    ' � M', num2str(MI.Option.n_jmode), ' � ���� ����������'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEckij = plot(linmod.var_par,MI.VoltageAngle.Eckij_norm_sym);
grid minor
title(['������������� ���������������� ��������� �������������� ��� M',...
    num2str(MI.Option.n_imode),' � M', num2str(MI.Option.n_jmode),...
    ' � ���� ����������'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end
%% ������� ��� ���������� ������
function MI = fun_onlyEvkijGraph(na,norm_set,MI,linmod,nodelabel_set)
n_imode = MI.Option.n_imode;
n_jmode = MI.Option.n_jmode;

load 'LMA_results_for_VoltMag' LMA
MI.VoltageMagnitude.Eckij_norm = LMA.Eck .* MI.VoltageMagnitude.Eckij ./...
    squeeze(LMA.sumEckii);
MI.VoltageMagnitude.Eckij_norm_sym = LMA.Eck .* MI.VoltageMagnitude.Eckij_sym...
    ./squeeze(LMA.sumEckii_sym);

load 'LMA_results_for_VoltAngle' LMA
MI.VoltageAngle.Eckij_norm = LMA.Eck .* MI.VoltageAngle.Eckij ./...
    squeeze(LMA.sumEckii);
MI.VoltageAngle.Eckij_norm_sym = LMA.Eck .* MI.VoltageAngle.Eckij_sym...
    ./squeeze(LMA.sumEckii_sym);

for type_sensetive = 1:2
    
    if type_sensetive == 1
        Temp = MI.VoltageMagnitude;
        name_sensetive = 'Voltage Magnitude';
    else
        Temp = MI.VoltageAngle;
        name_sensetive = 'Voltage Angle';
    end
    
    for type_MI = 1:4
        
        if type_MI == 1
            Eckij = Temp.Eckij;
            name_MI = 'Modal interaction';
        elseif type_MI == 2
            Eckij = Temp.Eckij_sym;
            name_MI = 'Symmetrized Modal interaction';
        elseif type_MI == 3
            Eckij = Temp.Eckij_norm;
            name_MI = 'Normalized Modal interaction';
        elseif type_MI == 4
            Eckij = Temp.Eckij_norm_sym;
            name_MI = 'Normalized Symmetrized Modal interaction';
        end
        
        if norm_set ==1
        %   ������������ ������������ ������ ��������� ��� ������������� k
            tmpEckij = Eckij(:,na);
            maxEckij = max(abs(tmpEckij));
            for i = 1:size(tmpEckij,1)
                tmpEckij(i) = tmpEckij(i) / maxEckij;
            end
        else
        %   ������������ ������������ ������ ��������� ��� ���� k
            tmpEckij = Eckij;
            maxEckij = max(max(abs(tmpEckij)));
            tmpEckij = tmpEckij ./ maxEckij;
        end
        
        if min(tmpEckij) < 0
            CLim = [-1 1]; % ������� ����� ColorBar
        else
            CLim = [0 1];
        end
        
        edg1 = linmod.line(:,1);
        edg2 = linmod.line(:,2);
        G = graph(edg1, edg2);
        G.Nodes.NodeColors = tmpEckij;
        figure()
        p = plot(G,'MarkerSize',22,'LineWidth', 3,'EdgeColor', 'black',...
        'NodeFontSize',14, 'Layout','force', 'UseGravity', true);
        p.NodeCData = G.Nodes.NodeColors;
        
        if nodelabel_set == 0
            p.NodeLabel = round(tmpEckij,2);
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
        title([name_MI, ' of modes M', num2str(n_imode), ' / M',...
            num2str(n_jmode),' in ',name_sensetive,' for model# ',num2str(na)])
        colormap(jet)
        set(gca, 'CLim', CLim);
        colorbar;
        
    end    
end


end