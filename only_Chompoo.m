% —крыпит дл€ вычислени€ параметров по "ћетоду Chompoo" и построени€ графов
%
% ƒл€ запуска необходимо наличие в текущей папке файлов:
% linmod.mat
%
%% 1. √рузим данные линеаризации
clear all
load 'linmod' linmod

Chompoo.c_s_v = linmod.C.c_v;   % for voltage magnitude S_V
Chompoo.c_s_teta = linmod.C.c_ang; % for voltage angle S_teta

%% 2. ¬ычисл€ем показатели по формуле (6) статьи CHOMPOOBUTRGOOL
for n = 1:size(linmod.Vseq,3)
    Chompoo.S_V(:,:,n) = Chompoo.c_s_v (:,:,n) * linmod.Vseq(:,:,n);
    Chompoo.S_teta(:,:,n) = Chompoo.c_s_teta (:,:,n) * linmod.Vseq(:,:,n);
end

Chompoo.S_V = permute(Chompoo.S_V,[1 3 2]);
Chompoo.S_teta = permute(Chompoo.S_teta,[1 3 2]);

%% 3. —троим графы
norm_set = 1; % вариант нормировани€ величины выбранного параметра: 
%                   1 - относительно максимума, определенного в пределах 
%                       значений Evki дл€ одной фиксированной матрицы ј;
%                   0 - относительно максимума, определенного в пределах 
%                       значений Evki дл€ всех матриц ј.
nodelabel_set = 0; % вариант надписи в узлах: 
%                   1 - в узлах отображаютс€ номера узлов;
%                   0 - в узлах отображаютс€ величины выбранного параметра
n_mode = 4; % задать нужный номер моды
n_model = 1; % задать пор€дковый номер линеаризованной модели из вектора 

graphChompoo(n_model,n_mode,norm_set,nodelabel_set,Chompoo,linmod);
clear n n_mode n_model norm_set nodelabel_set

%% ‘ункци€ дл€ построени€ графа
function graphChompoo(n_mat,n_mode,norm_set,nodelabel_set,Data,result_static)

nameS = ["Magnitude of Voltage Magnitude Modeshape S_V";
        "Real part of Voltage Magnitude Modeshape S_V";
        "Imaginary part of Voltage Magnitude Modeshape S_V";
        "'Symmetrical' Voltage Magnitude Modeshape S_V";
        "Magnitude of Voltage Angle Modeshape S_{teta}";
        "Real part of Voltage Angle Modeshape S_{teta}";
        "Imaginary part of Voltage Angle Modeshape S_{teta}";
        "'Symmetrical' Voltage Angle Modeshape S_{teta}"];

na = n_mat;
nm = n_mode;
    
for ns = 1:8
    if ns == 1
        S = abs(Data.S_V);
    end
    
    if ns == 2
        S = real(Data.S_V);
    end
    
    if ns == 3
        S = imag(Data.S_V);
    end
    
    if ns == 4
        S = (Data.S_V + conj(Data.S_V)) / 2;
    end
    
    if ns == 5
        S = abs(Data.S_teta);
    end
    
    if ns == 6
        S = real(Data.S_teta);
    end
    
    if ns == 7
        S = imag(Data.S_teta);
    end
    
    if ns == 8
        S = (Data.S_teta + conj(Data.S_teta)) / 2;
    end
    
    if norm_set == 1 
    %   нормирование относительно своего максимума при фиксированном k
        tmpS = S(:,na,nm);
        maxS = max(abs(tmpS));
        for i = 1:size(tmpS,1)
            tmpS(i) = tmpS(i) / maxS;
        end
    else
    %   нормирование относительно своего максимума при всех k
        tmpS = squeeze(S(:,:,nm));
        maxS = max(max(abs(tmpS)));
        tmpS = tmpS(:,na) ./ maxS;
    end

    if min(tmpS) < 0
        CLim = [-1 1]; % пределы шкалы ColorBar
    else
        CLim = [0 1];
    end
    
    edg1 = result_static.line(:,1);
    edg2 = result_static.line(:,2);
    G = graph(edg1, edg2);
    G.Nodes.NodeColors = tmpS;
    figure()
    p = plot(G,'MarkerSize',20,'LineWidth', 3,'EdgeColor', 'black',...
        'NodeFontSize',14, 'Layout','force', 'UseGravity', true);
    p.NodeCData = G.Nodes.NodeColors;
    
    if nodelabel_set == 0
        p.NodeLabel = round(tmpS,2);
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
    title([char(nameS(ns)),' of M',num2str(nm), ' for model#', num2str(na)])
    colormap(jet)
    set(gca, 'CLim', CLim);
    colorbar;
end

end