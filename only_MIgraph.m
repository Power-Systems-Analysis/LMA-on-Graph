% Скрипт для вычисления модальных взаимодействий произвольных пар мод и
% построения графа.
%
% Для запуска необходимо наличие в текущей папке файлов:
% linmod.mat
% LMA_results_for_VoltAngle.mat
% LMA_results_for_VoltMag.mat
% папки LMA_on_graph с функциями funEckij.m и funEckij_sym.m
%
%% 1. Грузим данные линеаризации и путь к функциям ЛМА
clear all
load 'linmod' linmod % для амплитуд узловых напряжений
addpath([pwd,'\LMA_on_graph']);

%% 2. Вычисляем ненормированное модальное взаимодействие

% 2.1. Задаём номера мод, взаимодействие которых нужно вычислить (только скаляры)
MI.Option.n_imode = 4;
MI.Option.n_jmode = 26;

% 2.2. Выбираем начальные условия
% для сферически-симметричных начальных условий
MI.Option.x0 = [];

% для произвольных начальных условий (задаём нужную структуру вектора x0)
% x0 = zeros(linmod.number_of_mode,1);
% x0([1 12:13 24:25 36:37 48:49 60:61 72:73 84:85 ...
%     96:97 108:109 120:121 132:133 144:145 150:151 156:157 162:163]) = 1;

% 2.3. Вычисляем несимметризованное и симметризованное модальное
% взаимодействие для амплитуд и фаз

MI.Option.n_node = 1 : linmod.number_of_node;
MI.Option.n_mat = 1 : linmod.number_of_models;

% для амплитуды
[MI.VoltageMagnitude.Eckij] = funEckij(linmod.Vseq,linmod.Wseq,linmod.Dseq,...
    MI.Option.n_imode,MI.Option.n_jmode,MI.Option.n_mat,MI.Option.n_node,...
    linmod.C.c_v,MI.Option.x0);
[MI.VoltageMagnitude.Eckij_sym] = funEckij_sym(linmod.Vseq,linmod.Wseq,...
    linmod.Dseq,MI.Option.n_imode,MI.Option.n_jmode,MI.Option.n_mat,...
    MI.Option.n_node,linmod.C.c_v,MI.Option.x0);

% для фазы
[MI.VoltageAngle.Eckij] = funEckij(linmod.Vseq,linmod.Wseq,linmod.Dseq,...
    MI.Option.n_imode,MI.Option.n_jmode,MI.Option.n_mat,MI.Option.n_node,...
    linmod.C.c_ang,MI.Option.x0);
[MI.VoltageAngle.Eckij_sym] = funEckij_sym(linmod.Vseq,linmod.Wseq,...
    linmod.Dseq,MI.Option.n_imode,MI.Option.n_jmode,MI.Option.n_mat,...
    MI.Option.n_node,linmod.C.c_ang,MI.Option.x0);

%% 3. Строим граф модального взаимодействия для мод n_imode и n_jmode для модели n_model
norm_set = 1; % вариант нормирования величины выбранного параметра: 
%                   1 - относительно максимума, определенного в пределах 
%                       значений для одной фиксированной модели;
%                   0 - относительно максимума, определенного в пределах 
%                       значений для всех моделей.
nodelabel_set = 0; % вариант надписи в узлах: 
%                   1 - в узлах отображаются номера узлов;
%                   0 - в узлах отображаются величины выбранного параметра
n_model = 52; % задать порядковый номер линеаризованной модели из вектора n_mat

MI = fun_onlyEvkijGraph(n_model,norm_set,MI,linmod,nodelabel_set);
%% 4. График изменения модального взаимодействия в течение эксперимента (запускать после п.3)
figure()
plotEckij = plot(linmod.var_par,MI.VoltageMagnitude.Eckij);
grid minor
title(['Модальное взаимодействие мод M', num2str(MI.Option.n_imode),...
    ' и M', num2str(MI.Option.n_jmode), ' в амплитуде напряжения'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEckij = plot(linmod.var_par,MI.VoltageMagnitude.Eckij_sym);
grid minor
title(['Симметризованное модальное взаимодействие мод M', num2str(MI.Option.n_imode),...
    ' и M', num2str(MI.Option.n_jmode), ' в амплитуде напряжения'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEckij = plot(linmod.var_par,MI.VoltageMagnitude.Eckij_norm);
grid minor
title(['Нормированное модальное взаимодействие мод M', num2str(MI.Option.n_imode),...
    ' и M', num2str(MI.Option.n_jmode), ' в амплитуде напряжения'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEckij = plot(linmod.var_par,MI.VoltageMagnitude.Eckij_norm_sym);
grid minor
title(['Нормированное симметризованное модальное взаимодействие мод M',...
    num2str(MI.Option.n_imode),' и M', num2str(MI.Option.n_jmode),...
    ' в амплитуде напряжения'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end


figure()
plotEckij = plot(linmod.var_par,MI.VoltageAngle.Eckij);
grid minor
title(['Модальное взаимодействие мод M', num2str(MI.Option.n_imode),...
    ' и M', num2str(MI.Option.n_jmode), ' в фазе напряжения'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEckij = plot(linmod.var_par,MI.VoltageAngle.Eckij_sym);
grid minor
title(['Симметризованное модальное взаимодействие мод M', num2str(MI.Option.n_imode),...
    ' и M', num2str(MI.Option.n_jmode), ' в фазе напряжения'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEckij = plot(linmod.var_par,MI.VoltageAngle.Eckij_norm);
grid minor
title(['Нормированное модальное взаимодействие мод M', num2str(MI.Option.n_imode),...
    ' и M', num2str(MI.Option.n_jmode), ' в фазе напряжения'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end

figure()
plotEckij = plot(linmod.var_par,MI.VoltageAngle.Eckij_norm_sym);
grid minor
title(['Нормированное симметризованное модальное взаимодействие мод M',...
    num2str(MI.Option.n_imode),' и M', num2str(MI.Option.n_jmode),...
    ' в фазе напряжения'])
for i = 1 : size(linmod.C.c_v,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end
%% Функция для построения графов
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
        %   нормирование относительно своего максимума при фиксированном k
            tmpEckij = Eckij(:,na);
            maxEckij = max(abs(tmpEckij));
            for i = 1:size(tmpEckij,1)
                tmpEckij(i) = tmpEckij(i) / maxEckij;
            end
        else
        %   нормирование относительно своего максимума при всех k
            tmpEckij = Eckij;
            maxEckij = max(max(abs(tmpEckij)));
            tmpEckij = tmpEckij ./ maxEckij;
        end
        
        if min(tmpEckij) < 0
            CLim = [-1 1]; % пределы шкалы ColorBar
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