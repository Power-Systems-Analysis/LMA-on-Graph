% Код для расчёта показателей из файла Iskakov-IET-2 .pdf от 27.01.21
% Скрипт необходимо запускать из каталога, в котором содержится папка
% LMA_on_graph с таким содержанием:
% 1. eigenshuffle_rl.m - сортировка собственных значений и векторов
% 2. funEck_trace.m - вычисление L2-нормы возмущения
% 3. funEcki.m - вычисление модального вклада (использует funEcki_ones(_x0).m)
% 4. funEcki_ones.m
% 5. funEcki_ones_x0.m
% 6. funEckii.m - несимметризованные модальные взаимодействия моды i с i
% 7. funEckii_sym.m - симметризованные модальные взаимодействия моды i с i
% 8. funEckij.m - несимметризованное модальное взаимодействие моды i с j
% 9. funEckij_sym.m - симметризованное модальное взаимодействие моды i с j
% 10. graphEvki.m - построение графа для модального вклада
% 11. graphEvkij.m - построение графа для модального взаимодействия
% 12. norm_eigen.m - нормировка собственных векторов
%% 1. Загружаем набор линеаризованных моделей

clear all
load 'linmod'

%% 1a. Или линеаризуем (в текущей папке должена быть папка с PST!)

% 1а.1. Формируем структуру исходных параметров системы
clear all
var_par = 0:0;%.01:0.95; % задаём диапазон изменения коэффициента для 
                       % вычисления реактивного сопротивления
number_of_models = length(var_par); % общее количество линеаризованных моделей

InitDataOfSystem = struct;
for k = 1:number_of_models
    field_name = string(['System' num2str(k)]);
    [Data] = fun_data16mA(var_par(k));
    InitDataOfSystem = setfield(InitDataOfSystem,field_name,Data);    
end

% 1a.2. Линеаризуем каждую систему из InitDataOfSystem
linmod = fun_linmod(InitDataOfSystem,var_par,number_of_models);
clear k field_name Data var_par number_of_models

%% 2. Вычисляем ненормированные показатели ЛМА

% 2.1. Загружаем путь для LMA-кода
addpath([pwd,'\LMA_on_graph']);

% 2.2. Выбираем нужную матрицу чувствительности
c = linmod.C.c_v;   % for voltage magnitude
%c = linmod.C.c_pf1;  % for power flow
%c = linmod.C.c_ang; % for voltage angle

% 2.3. Задаём номера узлов, мод и номера моделей
n_node = 1 : linmod.number_of_node;   % scalar or vector
n_mode = 1 : linmod.number_of_mode;   % scalar or vector
n_mat = 1:linmod.number_of_models;     % scalar or vector

% для сферически-симметричных начальных условий
x0 = [];

% для произвольных начальных условий
% x0 = zeros(linmod.number_of_mode,1);
% x0([1 12:13 24:25 36:37 48:49 60:61 72:73 84:85 ...
%     96:97 108:109 120:121 132:133 144:145 150:151 156:157 162:163]) = 1;

% 2.4. Задаём номера мод для модального взаимодействия (только скаляры)
n_imode = 26;   % scalar
n_jmode = 26;   % scalar

% 2.5. Модальный вклад
[LMA.Ecki] = funEcki(linmod.Aseq,n_node,n_mode,n_mat,c,...
    linmod.Vseq,linmod.Wseq,linmod.Dseq,x0);

% 2.6. Модальное взаимодействие
[LMA.Eckij] = funEckij(linmod.Vseq,linmod.Wseq,linmod.Dseq,...
    n_imode,n_jmode,n_mat,n_node,c,x0);
[LMA.Eckij_sym] = funEckij_sym(linmod.Vseq,linmod.Wseq,linmod.Dseq,...
    n_imode,n_jmode,n_mat,n_node,c,x0);

LMA.Description.Ecki = ['Ненормированный и несимметризованный модальный вклад'...
    ' [номер узла или линии  х  номер модели  х  номер моды]'];
LMA.Description.Eckij = ['Ненормированное и несимметризованное модальное взаимодействие'...
    ' [номер узла или линии  х  номер модели]'];
LMA.Description.Eckij_sym = ['Ненормированное но симметризованное значение Eckij'...
    ' [номер узла или линии  х  номер модели]'];

clear c n_node n_mat n_mode
%% 3. Вычисляем нормированные показатели ЛМА

% 3.1. Загружаем путь для LMA-кода
addpath([pwd,'\LMA_on_graph']);

% 3.2. Выбираем нужную матрицу чувствительности
c = linmod.C.c_v;   % for voltage magnitude
%c = linmod.C.c_pf1;  % for power flow
%c = linmod.C.c_ang; % for voltage angle

% 3.3. Задаём номера узлов, номера моделей и вектор начальных условий x0
n_node = 1 : linmod.number_of_node;   % scalar or vector
n_mat = 1:linmod.number_of_models;     % scalar (quick) or vector (slow)

% для сферически-симметричных начальных условий
x0 = [];

% для произвольных начальных условий
%x0 = zeros(linmod.number_of_mode,1);
%x0([1 12:13 24:25 36:37 48:49 60:61 72:73 84:85 ...
%    96:97 108:109 120:121 132:133 144:145 150:151 156:157 162:163]) = 1;

% 3.4. Задаём номера мод для модального взаимодействия (только скаляры)
n_imode = 4;   % scalar
n_jmode = 26;   % scalar

% 3.5. Вычисление L2-нормы напряжения в узле n_node для модели n_mat
[LMA.Eck] = funEck_trace(linmod.Aseq,n_node,n_mat,c,x0);

% 3.6. Рассчитываем взаимодействие каждой моды с собой в узле n_node для модели n_mat
LMA.Eckii = funEckii(linmod,n_mat,n_node,c);% [nodes, modes, matrix]
LMA.Eckii_sym = funEckii_sym(linmod,n_mat,n_node,c);% [nodes, modes, matrix]

LMA.sumEckii = sum(LMA.Eckii,2);
LMA.sumEckii_sym = sum(LMA.Eckii_sym,2);

% 3.7. Рассчитываем модальный вклад i-й моды в k-й узел / линию
LMA.pki_L2 = zeros (length(n_node),length(n_mat),linmod.number_of_mode);
LMA.Ecki_norm = zeros (length(n_node),length(n_mat),linmod.number_of_mode);
LMA.pki_L2_sym = zeros (length(n_node),length(n_mat),linmod.number_of_mode);
LMA.Ecki_norm_sym = zeros (length(n_node),length(n_mat),linmod.number_of_mode);
for num_i = 1:linmod.number_of_mode
    
    tmp_pki_L2 = squeeze(LMA.Eckii(:,num_i,:) ./ LMA.sumEckii); % фактор участия для моды num_i (L2 modal contribution factor)[node, matrix A]
    LMA.pki_L2 (:,:,num_i) = tmp_pki_L2;% фактор участия (L2 modal contribution factor)[node, matrix A, mode]
    LMA.Ecki_norm (:,:,num_i) = LMA.Eck .* tmp_pki_L2;
    
    tmp_pki_L2_sym = squeeze(LMA.Eckii_sym(:,num_i,:) ./ LMA.sumEckii_sym); % фактор участия для моды num_i (L2 modal contribution factor)[node, matrix A]
    LMA.pki_L2_sym (:,:,num_i) = tmp_pki_L2_sym;% фактор участия (L2 modal contribution factor)[node, matrix A, mode]
    LMA.Ecki_norm_sym (:,:,num_i) = LMA.Eck .* tmp_pki_L2_sym;
        
end

LMA.Description.Eck = ['L2-норма возмущения наблюдаемого параметра в узлах'...
    ' или линиях [номер узла или линии  х  номер модели]'];
LMA.Description.Eckii = ['Несимметризованное модальное'...
    ' взаимодействие каждой моды с самой собой'...
    ' [номер узла или линии  х  номер моды  х  номер модели]'];
LMA.Description.Eckii_sym = ['Симметризованное значение Eckii'...
    ' [номер узла или линии  х  номер моды  х  номер модели]'];
LMA.Description.sumEckii = ['Сумма значение Eckii по модам'...
    ' [номер узла или линии  х  номер модели]'];
LMA.Description.sumEckii_sym = ['Сумма значение Eckii_sym по модам'...
    ' [номер узла или линии  х  номер модели]'];
LMA.Description.pki_L2 = ['Фактор нормированного несимметризованного модального вклада'...
    ' [номер узла или линии  х  номер модели  х  номер моды]'];
LMA.Description.Ecki_norm = ['Нормированный несимметризованный модальный вклад'...
    ' [номер узла или линии  х  номер модели  х  номер моды]'];
LMA.Description.pki_L2_sym = ['Фактор нормированного симметризованного модального вклада'...
    ' [номер узла или линии  х  номер модели  х  номер моды]'];
LMA.Description.Ecki_norm_sym = ['Нормированный симметризованный модальный вклад'...
    ' [номер узла или линии  х  номер модели  х  номер моды]'];

% 3.8. Рассчитываем модальное взаимодействие
tmp_eck_ij = funEckij(linmod.Vseq,linmod.Wseq,linmod.Dseq,n_imode,n_jmode,...
    n_mat, n_node,c);

tmp_eck_ij_sym = funEckij_sym(linmod.Vseq,linmod.Wseq,linmod.Dseq,n_imode,...
    n_jmode,n_mat,n_node,c);

LMA.fkij_L2 = squeeze(tmp_eck_ij ./ (squeeze (LMA.sumEckii)));
LMA.Eckij_norm = LMA.Eck .* LMA.fkij_L2;

LMA.fkij_L2_sym = squeeze(tmp_eck_ij_sym ./ (squeeze (LMA.sumEckii_sym)));
LMA.Eckij_norm_sym = LMA.Eck .* LMA.fkij_L2_sym;

LMA.Description.Eckij_norm = ['Нормированное несимметризованное модальное'...
    ' взаимодействие [номер узла или линии  х  номер модели]'];
LMA.Description.fkij_L2 = ['Фактор нормированного несимметризованного модального'...
    ' взаимодействия [номер узла или линии  х  номер модели]'];
LMA.Description.Eckij_norm_sym = ['Симметризованное значение Eckij_norm'...
    ' [номер узла или линии  х  номер модели]'];
LMA.Description.fkij_L2_sym = ['Фактор нормированного симметризованного модального'...
    ' взаимодействия [номер узла или линии  х  номер модели]'];

clear c n_node n_mat num_i tmp_pki_L2 tmp_pki_L2_sym tmp_eck_ij tmp_eck_ij_sym
%% 4. Строим графы
% 4.1. Строим граф модального вклада для мод n_mode для модели n_model
norm_set = 1; % вариант нормирования величины выбранного параметра: 
%                   1 - относительно максимума, определенного в пределах 
%                       значений Evki для одной фиксированной матрицы А;
%                   0 - относительно максимума, определенного в пределах 
%                       значений Evki для всех матриц А.
line_set = 0; % вариант расчета надписей над рёбрами:
%                   1 - число над ребром рассчитывается как разница узловых 
%                       напряжений между большим и меньшим номером узла
%                   0 - надписей над рёбрами нет
nodelabel_set = 0; % вариант надписи в узлах: 
%                   1 - в узлах отображаются номера узлов;
%                   0 - в узлах отображаются величины выбранного параметра
n_mode = 26; % задать нужный номер моды
n_model = 1; % задать порядковый номер линеаризованной модели из вектора n_mat

% выбрать нужный вариант нормировки и симметризации
Ecki = LMA.Ecki;
%Ecki = LMA.Ecki_norm;
%Ecki = LMA.Ecki_norm_sym;

graphEvki(n_model,n_mode,norm_set,line_set,nodelabel_set,Ecki,linmod);
clear Ecki norm_set line_set n_model n_mode nodelabel_set
%% 4.2. Строим граф модального взаимодействия для мод n_imode и n_jmode для модели n_model
% По умолчанию строится абсолютное значение величины Eckij. Граф с учётом
% знака можно построить используя скрипт only_MIgraph.m

norm_set = 1; % вариант нормирования величины выбранного параметра: 
%                   1 - относительно максимума, определенного в пределах 
%                       значений Evki для одной фиксированной матрицы А;
%                   0 - относительно максимума, определенного в пределах 
%                       значений Evki для всех матриц А.
n_model = 52; % задать порядковый номер линеаризованной модели из вектора n_mat

% выбрать нужный вариант нормировки и симметризации
Eckij = LMA.Eckij;
%Eckij = LMA.Eckij_sym;
%Eckij = LMA.Eckij_norm;
%Eckij = LMA.Eckij_norm_sym;

graphEvkij(n_model,n_imode,n_jmode,norm_set,Eckij,linmod);
clear Eckij norm_set n_model
%% 5. Вычисляем параметры по "Методу Chompoo"
% 5.1. Вычисляем параметры по "Методу Chompoo"
clear Chompoo
Chompoo.c_s_v = linmod.C.c_v;   % for voltage magnitude S_V
Chompoo.c_s_teta = linmod.C.c_ang; % for voltage angle S_teta

% Формула (6) статьи CHOMPOOBUTRGOOL
for n = 1:size(linmod.Vseq,3)
    Chompoo.S_V(:,:,n) = Chompoo.c_s_v (:,:,n) * linmod.Vseq(:,:,n);
    Chompoo.S_teta(:,:,n) = Chompoo.c_s_teta (:,:,n) * linmod.Vseq(:,:,n);
end

Chompoo.S_V = permute(Chompoo.S_V,[1 3 2]);
Chompoo.S_teta = permute(Chompoo.S_teta,[1 3 2]);

% 5.2. Строим графы для "Метода Chompoo":
norm_set = 1; % вариант нормирования величины выбранного параметра: 
%                   1 - относительно максимума, определенного в пределах 
%                       значений Evki для одной фиксированной матрицы А;
%                   0 - относительно максимума, определенного в пределах 
%                       значений Evki для всех матриц А.
nodelabel_set = 0; % вариант надписи в узлах: 
%                   1 - в узлах отображаются номера узлов;
%                   0 - в узлах отображаются величины выбранного параметра
n_mode = 4; % задать нужный номер моды
n_model = 1; % задать порядковый номер линеаризованной модели 

graphChompoo(n_model,n_mode,norm_set,nodelabel_set,Chompoo,linmod);
clear n n_mode n_model norm_set nodelabel_set
%% 6. Графы при вынужденном периодическом возмущении


%% 7. Графики
%% Eck [nodes, models]
figure()
plotEck = plot (linmod.var_par,LMA.Eck(:,:));
grid minor
title('L2-норма фазы напряжения по узлам')
for i = 1 : size(linmod.C.c_v,1,1)
    set(plotEck(i),'DisplayName',['Node',num2str(i)]);
end

%% Ecki [nodes, models, modes]
figure()
plotEcki = plot (linmod.var_par,squeeze(LMA.Ecki(40,:,:)));
grid minor
title('Модальные вклады в узел 40')
for i = 1 : linmod.number_of_mode%size(linmod.C.c_v,1,1)
    set(plotEcki(i),'DisplayName',['Mode',num2str(i)]);
end
%% Eci [nodes, models, modes]
figure()
plotEcki = plot (linmod.var_par,squeeze(sum(LMA.Ecki,1)));
grid minor
title('Суммарный модальный вклад каждой моды во все узлы')
for i = 1 : linmod.number_of_mode
    set(plotEcki(i),'DisplayName',['Mode',num2str(i)]);
end

%% Eckij [nodes, models]
figure()
plotEckij = plot (linmod.var_par,LMA.Eckij_sym);
grid minor
title('Симмитризованное ненормированное модальное взаимодействие моды М4 с остальными в узле 50')
for i = 1 : 167%size(linmod.C.c_v,1,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end
%%                             ФУНКЦИИ

%=========================Линеаризация моделей=============================
function linmod = fun_linmod(IDSys,var_par,number_of_models)
    try
        % Загружаем путь для LMA-кода и PST
        addpath([pwd,'\PST']);
        addpath([pwd,'\LMA_on_graph']);
        
        % Основные параметры системы
        number_of_node = size(IDSys.System1.bus,1); % количество узлов
        number_of_line = size(IDSys.System1.line,1); % количество линий
        number_of_gen = size(IDSys.System1.mac_con,1);% количество генераторов    
        
        % Создание окна ProgressBar
            f = waitbar(0,'Starting...','Name','Линеаризация...',...
                'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
            setappdata(f,'canceling',0);
            
        for i = 1:number_of_models
            
            % Проверка нажатия кнопки Cancel
            if getappdata(f,'canceling')
                break
            end
            
            field_name = string(['System' num2str(i)]);
            Data = getfield(IDSys,field_name);% Параметры системы
            settings = struct();
            settings.Display = 0;
            Data.lmon_con = 1:size(Data.line,1);
            result_static = svm_mgen(Data, settings);% Линеаризация
            if i == 1
                number_of_mode = size(result_static.a_mat, 1);
                Aseq = zeros(number_of_mode, number_of_mode, number_of_models);
                c_v = zeros(number_of_node, number_of_mode, number_of_models);
                c_ang = zeros(size(c_v));
                c_vbus = zeros(size(c_v));
                p = zeros(size(Aseq));
                p_norm = zeros(size(Aseq));
                c_pf1 = zeros(number_of_line, number_of_mode, number_of_models);
                b_vr = zeros(size(result_static.B.b_vr,1),...
                    size(result_static.B.b_vr,2),number_of_models);
                V0 = zeros(number_of_node,number_of_models);
                delta0 = zeros(size(V0));
            end
            Aseq(:,:,i) = result_static.a_mat; % Матрица динамики
            c_v(:,:,i) = result_static.C.c_v; % Чувствительность для амплитуд
            c_ang(:,:,i) = result_static.C.c_ang; % Чувствительность для фаз
            c_vbus(:,:,i) = result_static.C.c_vbus; % Комплексная чувствительность
            c_pf1(:,:,i) = result_static.C.c_pf1; % Чувствительность для мощности
            p (:,:,i) = result_static.p; % Факторы участия
            p_norm (:,:,i) = result_static.p_norm; % Факторы участия нормированные
            b_vr(:,:,i) = result_static.B.b_vr; % Матрица входа (управления)
            V0 (:,i) = result_static.loadflow(:,2); % Амплитуда узловых напряжений в установившемся режиме            
            delta0 (:,i) = result_static.loadflow(:,3); % Фаза узловых напряжений в установившемся режиме
            
            % Обновление ProgressBar
            d_step = i/number_of_models;
            waitbar(d_step,f,sprintf('%d%%',round(d_step*100)))
            
        end
        % Считаем собственные значения Dseq и векторы Vseq, Wseq
        [Vseq,Dseq,Wseq] = eigenshuffle_rl(Aseq);
        % Нормирование собственных векторов
        [Vseq, Wseq] = norm_eigen(Vseq,Wseq,var_par);
        Wseq = conj(Wseq);
        % Формируем выходную структуру
        linmod.var_par = var_par; % коэффициент изменения реактивного сопротивления
        linmod.number_of_models = number_of_models; % общее количество линеаризованных моделей
        linmod.number_of_gen = number_of_gen; % количество генераторов
        linmod.number_of_node = number_of_node; % количество узлов
        linmod.number_of_line = number_of_line; % количество линий
        linmod.number_of_mode = size(Dseq,1); % количество мод
        linmod.Aseq = Aseq; % набор матриц динамики
        linmod.Dseq = Dseq; % набор векторов собсвтенных значений
        linmod.Vseq = Vseq; % набор матриц нормированных правых собственных векторов
        linmod.Wseq = Wseq; % набор матриц нормированных левых собственных векторов
        linmod.C.c_v = c_v; % набор матриц чувствительностей амплитуд узловых напряжений
        linmod.C.c_vbus = c_vbus; % набор комплекснозначных матриц чувствительности напряжений
        linmod.C.c_ang = c_ang; % набор матриц чувствительностей фаз узловых напряжений
        linmod.C.c_pf1 = c_pf1; % набор матриц чувствительностей перетоков мощности
        linmod.b_vr = b_vr; % набор матриц входов (для симуляции временного отклика)
        linmod.magV0 = V0; % набор амплитуд узловых напряжений в установившемся режиме
        linmod.angV0 = delta0; % набор фаз узловых напряжений в установившемся режиме
        linmod.p = p; % факторы участия
        linmod.p_norm = p_norm; % факторы участия нормированные
        linmod.line = result_static.line;
        linmod.RS = result_static;
        % Удаляем ProgressBar
        delete(f)
    
    % При возникновении любой ошибки убираем ProgressBar и возвращаем
    % сообщение об ошибке и номер строки с ошибкой
    catch MExc
        delete(f)
        err = MExc.stack;
        number_of_names = size(err,1);
        for k = 1:number_of_names
            name_of_error_function (k,1) = string(err(k).name);
            number_of_error_line (k,1) = string(err(k).line);
        end
        table(name_of_error_function,number_of_error_line)
        throw(MExc)
    end
end
%==========================================================================

%======================Графы для "Метода Chompoo"==========================
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
%==========================================================================