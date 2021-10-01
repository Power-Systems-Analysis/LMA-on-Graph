%%  од дл€ расчЄта показателей из файла Iskakov-IET-2 .pdf от 27.01.21

% Ётот код сделан на основе кода 2019 года, но модальный вклад и модальное
% взаимодействие теперь нормированы (новые формулы со строчки 111)

%% загружае данные линеаризованной модели
load('linearize_models')
%%   Evk Ќапр€жение в узлах от всех мод
tic
%c = c_pf1;  % for power flow
c = c_v;   % for voltage
%c = c_vbus;% for voltage
number_of_c = 1:size(c,1);   % scalar or vector
number_of_matrix = 1 : length(apw);     % scalar or vector
[Eck_trace] = funEck_trace(Aseq,number_of_c,number_of_matrix,c);
toc

%%
figure()    %Evk plot line
plotEck_trace = plot (apw,(Eck_trace(:,:))); %Evk[number_of_node, number matrix a]
grid minor
title('Eck in nodes/lines (all modes participation)')
for i = 1 : size(c,1)
    set(plotEck_trace(i),'DisplayName',['Line',num2str(i)]);
end

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%%   Ecki, Eci, Eck, Ec

tic
%c = c_pf1;  % for power flow
c = c_v;   % for voltage
%c = c_vbus;% for voltage
number_of_mode = 1:size(Dseq,1);   % scalar or vector
number_of_c = 1:size(c,1);   % scalar or vector
number_of_matrix = 1 : length(apw);     % scalar or vector
[Ecki] = funEcki(Aseq,number_of_c,number_of_mode,number_of_matrix,...
    c,Vseq,Wseq,Dseq);
toc

%%
figure()    %   Ecki plot (all modes/nodes/lines)
plotEcki = plot (apw, (squeeze(Ecki(:,:,4)))); %Ecki[number_of_c, number matrix a, number_of_mode]
grid minor
title('Evki for Mode 4')
%%   Legend for Nodes
for i = 1 : size(c,1)
    set(plotEcki(i),'DisplayName',['Node',num2str(i)]);
end
%%   Legend for Lines
for i = 1 : size(c,1)
    set(plotEcki(i),'DisplayName',['Line',num2str(i)]);
end
%%   Legend for Modes
for i = 1 : size(Dseq,1)
    set(plotEcki(i),'DisplayName',['Mode',num2str(i)]);
end


%%
Eci = squeeze(sum((Ecki),1));
figure()    %Eci graph line
plotEci = plot (apw,(Eci(:,:))); %Eci[number matrix a, number_of_mode]
grid minor
for i = 1 : size(Dseq,1)
    set(plotEci(i),'DisplayName',['Mode',num2str(i)]);
end
%%
Eck = squeeze(sum((Ecki),3));
figure()    %Eck graph line
plotEck = plot (apw,(Eck(:,:))); %Eck[number_of_c, number matrix a]
grid minor
for i = 1 : size(c,1)
    set(plotEck(i),'DisplayName',['Line',num2str(i)]);
end
%%
Ec = sum(squeeze(sum((Ecki),1)),2);
figure()    %Ec graph line
plotEc = plot (apw,(Ec));
grid minor

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%%   Eckij
tic
%c = c_pf1;  % for power flow
c = c_v;   % for voltage
%c = c_vbus;% for voltage
number_ith_mode = 4;   % scalar
number_jth_mode = 26;   % scalar
number_of_c = 1:size(c,1);   % scalar or vector
number_of_matrix = 1 : length(apw);     % scalar or vector
[Eckij] = funEckij(Vseq,Wseq,Dseq,number_ith_mode,number_jth_mode,...
    number_of_matrix, number_of_c,c);
toc
%%
figure()    %   Ecki graph line
plotEckij = plot (apw,(Eckij(:,:))); %  Ecki[number_of_c, number matrix a]
grid minor
%%   Legend for Nodes
for i = 1 : size(c,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end
%   Legend for Lines
for i = 1 : size(c,1)
    set(plotEckij(i),'DisplayName',['Line',num2str(i)]);
end


%% Ќовое определение модального вклада и модального взаимодействи€

%1) Evk Ќапр€жение в узлах от всех мод

tic
%c = c_pf1;  % for power flow
c = c_v;   % for voltage
%c = c_vbus;% for voltage
number_of_c = 1:size(c,1);   % scalar or vector
number_of_matrix = 1 : length(apw);     % scalar or vector
[Eck_trace] = funEck_trace(Aseq,number_of_c,number_of_matrix,c);
toc

%2) –ассчитываем взаимодействие моды с собой (Evkii) во всех узлах
number_of_c = 1:size(c,1);   % scalar or vector
number_of_matrix = 1 : length(apw);     % scalar or vector
Eckii = zeros(size(c,1),size(Aseq,1),length(apw)); % [number_of_nodes, number_of_modes, number_of_matrix]
tic
for i = 1:size(Aseq,1)
    fprintf('%d%%\n', round(i * 100 / size(Aseq,1)));
    %c = c_pf1;  % for power flow
    c = c_v;   % for voltage
    %c = c_vbus;% for voltage
    number_ith_mode = i;   % scalar
    number_jth_mode = i;   % scalar
    Eckii(:,i,:) = funEckij(Vseq,Wseq,Dseq,number_ith_mode,number_jth_mode,...
        number_of_matrix, number_of_c,c);
end
toc

sumEckii = sum(Eckii,2);

%3) –ассчитываем модальный вклад i-й моды в k-й узел / линию
Ecki_new = zeros (size(c,1),length(apw),size(Aseq,1));
tic
for num_i = 1:size(Aseq,1)

    pki_L2 = squeeze(Eckii(:,num_i,:) ./ sumEckii); % фактор участи€ (L2 modal contribution factor)[node, matrix A]
    Ecki_new (:,:,num_i) = Eck_trace .* pki_L2;
    
end
toc

%
figure()    %   Ecki_new plot (all modes/nodes/lines)
plotEcki_new = plot (apw, (squeeze(Ecki_new(:,:,26)))); %Ecki_new[number_of_c, number matrix a, number_of_mode]
grid minor
title('Evki for Mode 26')


% 4) –ассчитываем модальное взаимодействие

%c = c_pf1;  % for power flow
c = c_v;   % for voltage
%c = c_vbus;% for voltage
number_ith_mode = 4;   % scalar
number_jth_mode = 26;   % scalar
number_of_c = 1:size(c,1);   % scalar or vector
number_of_matrix = 1 : length(apw);     % scalar or vector

tmp_eck_ij = funEckij(Vseq,Wseq,Dseq,number_ith_mode,number_jth_mode,...
    number_of_matrix, number_of_c,c);

tmp_eck_ji = funEckij(Vseq,Wseq,Dseq,number_jth_mode,number_ith_mode,...
    number_of_matrix, number_of_c,c);

fkij_L2 = squeeze((tmp_eck_ij + tmp_eck_ij) ./ (2 * squeeze (sumEckii)));
Eckij_new = Eck_trace .* fkij_L2;

figure()    %   Eckij_new graph line
plotEckij_new = plot (apw,(Eckij_new(:,:))); %  Ecki[number_of_c, number matrix a]
grid minor
%   Legend for Nodes
for i = 1 : size(c,1)
    set(plotEckij_new(i),'DisplayName',['Node',num2str(i)]);
end
%   Legend for Lines
for i = 1 : size(c,1)
    set(plotEckij_new(i),'DisplayName',['Line',num2str(i)]);
end
