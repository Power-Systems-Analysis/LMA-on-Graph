% ��� ��� ������� ����������� �� ����� Iskakov-IET-2 .pdf �� 27.01.21
% ������ ���������� ��������� �� ��������, � ������� ���������� �����
% LMA_on_graph � ����� �����������:
% 1. eigenshuffle_rl.m - ���������� ����������� �������� � ��������
% 2. funEck_trace.m - ���������� L2-����� ����������
% 3. funEcki.m - ���������� ���������� ������ (���������� funEcki_ones(_x0).m)
% 4. funEcki_ones.m
% 5. funEcki_ones_x0.m
% 6. funEckii.m - ������������������ ��������� �������������� ���� i � i
% 7. funEckii_sym.m - ���������������� ��������� �������������� ���� i � i
% 8. funEckij.m - ������������������ ��������� �������������� ���� i � j
% 9. funEckij_sym.m - ���������������� ��������� �������������� ���� i � j
% 10. graphEvki.m - ���������� ����� ��� ���������� ������
% 11. graphEvkij.m - ���������� ����� ��� ���������� ��������������
% 12. norm_eigen.m - ���������� ����������� ��������
%% 1. ��������� ����� ��������������� �������

clear all
load 'linmod'

%% 1a. ��� ����������� (� ������� ����� ������� ���� ����� � PST!)

% 1�.1. ��������� ��������� �������� ���������� �������
clear all
var_par = 0:0;%.01:0.95; % ����� �������� ��������� ������������ ��� 
                       % ���������� ����������� �������������
number_of_models = length(var_par); % ����� ���������� ��������������� �������

InitDataOfSystem = struct;
for k = 1:number_of_models
    field_name = string(['System' num2str(k)]);
    [Data] = fun_data16mA(var_par(k));
    InitDataOfSystem = setfield(InitDataOfSystem,field_name,Data);    
end

% 1a.2. ����������� ������ ������� �� InitDataOfSystem
linmod = fun_linmod(InitDataOfSystem,var_par,number_of_models);
clear k field_name Data var_par number_of_models

%% 2. ��������� ��������������� ���������� ���

% 2.1. ��������� ���� ��� LMA-����
addpath([pwd,'\LMA_on_graph']);

% 2.2. �������� ������ ������� ����������������
c = linmod.C.c_v;   % for voltage magnitude
%c = linmod.C.c_pf1;  % for power flow
%c = linmod.C.c_ang; % for voltage angle

% 2.3. ����� ������ �����, ��� � ������ �������
n_node = 1 : linmod.number_of_node;   % scalar or vector
n_mode = 1 : linmod.number_of_mode;   % scalar or vector
n_mat = 1:linmod.number_of_models;     % scalar or vector

% ��� ����������-������������ ��������� �������
x0 = [];

% ��� ������������ ��������� �������
% x0 = zeros(linmod.number_of_mode,1);
% x0([1 12:13 24:25 36:37 48:49 60:61 72:73 84:85 ...
%     96:97 108:109 120:121 132:133 144:145 150:151 156:157 162:163]) = 1;

% 2.4. ����� ������ ��� ��� ���������� �������������� (������ �������)
n_imode = 26;   % scalar
n_jmode = 26;   % scalar

% 2.5. ��������� �����
[LMA.Ecki] = funEcki(linmod.Aseq,n_node,n_mode,n_mat,c,...
    linmod.Vseq,linmod.Wseq,linmod.Dseq,x0);

% 2.6. ��������� ��������������
[LMA.Eckij] = funEckij(linmod.Vseq,linmod.Wseq,linmod.Dseq,...
    n_imode,n_jmode,n_mat,n_node,c,x0);
[LMA.Eckij_sym] = funEckij_sym(linmod.Vseq,linmod.Wseq,linmod.Dseq,...
    n_imode,n_jmode,n_mat,n_node,c,x0);

LMA.Description.Ecki = ['��������������� � ������������������ ��������� �����'...
    ' [����� ���� ��� �����  �  ����� ������  �  ����� ����]'];
LMA.Description.Eckij = ['��������������� � ������������������ ��������� ��������������'...
    ' [����� ���� ��� �����  �  ����� ������]'];
LMA.Description.Eckij_sym = ['��������������� �� ���������������� �������� Eckij'...
    ' [����� ���� ��� �����  �  ����� ������]'];

clear c n_node n_mat n_mode
%% 3. ��������� ������������� ���������� ���

% 3.1. ��������� ���� ��� LMA-����
addpath([pwd,'\LMA_on_graph']);

% 3.2. �������� ������ ������� ����������������
c = linmod.C.c_v;   % for voltage magnitude
%c = linmod.C.c_pf1;  % for power flow
%c = linmod.C.c_ang; % for voltage angle

% 3.3. ����� ������ �����, ������ ������� � ������ ��������� ������� x0
n_node = 1 : linmod.number_of_node;   % scalar or vector
n_mat = 1:linmod.number_of_models;     % scalar (quick) or vector (slow)

% ��� ����������-������������ ��������� �������
x0 = [];

% ��� ������������ ��������� �������
%x0 = zeros(linmod.number_of_mode,1);
%x0([1 12:13 24:25 36:37 48:49 60:61 72:73 84:85 ...
%    96:97 108:109 120:121 132:133 144:145 150:151 156:157 162:163]) = 1;

% 3.4. ����� ������ ��� ��� ���������� �������������� (������ �������)
n_imode = 4;   % scalar
n_jmode = 26;   % scalar

% 3.5. ���������� L2-����� ���������� � ���� n_node ��� ������ n_mat
[LMA.Eck] = funEck_trace(linmod.Aseq,n_node,n_mat,c,x0);

% 3.6. ������������ �������������� ������ ���� � ����� � ���� n_node ��� ������ n_mat
LMA.Eckii = funEckii(linmod,n_mat,n_node,c);% [nodes, modes, matrix]
LMA.Eckii_sym = funEckii_sym(linmod,n_mat,n_node,c);% [nodes, modes, matrix]

LMA.sumEckii = sum(LMA.Eckii,2);
LMA.sumEckii_sym = sum(LMA.Eckii_sym,2);

% 3.7. ������������ ��������� ����� i-� ���� � k-� ���� / �����
LMA.pki_L2 = zeros (length(n_node),length(n_mat),linmod.number_of_mode);
LMA.Ecki_norm = zeros (length(n_node),length(n_mat),linmod.number_of_mode);
LMA.pki_L2_sym = zeros (length(n_node),length(n_mat),linmod.number_of_mode);
LMA.Ecki_norm_sym = zeros (length(n_node),length(n_mat),linmod.number_of_mode);
for num_i = 1:linmod.number_of_mode
    
    tmp_pki_L2 = squeeze(LMA.Eckii(:,num_i,:) ./ LMA.sumEckii); % ������ ������� ��� ���� num_i (L2 modal contribution factor)[node, matrix A]
    LMA.pki_L2 (:,:,num_i) = tmp_pki_L2;% ������ ������� (L2 modal contribution factor)[node, matrix A, mode]
    LMA.Ecki_norm (:,:,num_i) = LMA.Eck .* tmp_pki_L2;
    
    tmp_pki_L2_sym = squeeze(LMA.Eckii_sym(:,num_i,:) ./ LMA.sumEckii_sym); % ������ ������� ��� ���� num_i (L2 modal contribution factor)[node, matrix A]
    LMA.pki_L2_sym (:,:,num_i) = tmp_pki_L2_sym;% ������ ������� (L2 modal contribution factor)[node, matrix A, mode]
    LMA.Ecki_norm_sym (:,:,num_i) = LMA.Eck .* tmp_pki_L2_sym;
        
end

LMA.Description.Eck = ['L2-����� ���������� ������������ ��������� � �����'...
    ' ��� ������ [����� ���� ��� �����  �  ����� ������]'];
LMA.Description.Eckii = ['������������������ ���������'...
    ' �������������� ������ ���� � ����� �����'...
    ' [����� ���� ��� �����  �  ����� ����  �  ����� ������]'];
LMA.Description.Eckii_sym = ['���������������� �������� Eckii'...
    ' [����� ���� ��� �����  �  ����� ����  �  ����� ������]'];
LMA.Description.sumEckii = ['����� �������� Eckii �� �����'...
    ' [����� ���� ��� �����  �  ����� ������]'];
LMA.Description.sumEckii_sym = ['����� �������� Eckii_sym �� �����'...
    ' [����� ���� ��� �����  �  ����� ������]'];
LMA.Description.pki_L2 = ['������ �������������� ������������������� ���������� ������'...
    ' [����� ���� ��� �����  �  ����� ������  �  ����� ����]'];
LMA.Description.Ecki_norm = ['������������� ������������������ ��������� �����'...
    ' [����� ���� ��� �����  �  ����� ������  �  ����� ����]'];
LMA.Description.pki_L2_sym = ['������ �������������� ����������������� ���������� ������'...
    ' [����� ���� ��� �����  �  ����� ������  �  ����� ����]'];
LMA.Description.Ecki_norm_sym = ['������������� ���������������� ��������� �����'...
    ' [����� ���� ��� �����  �  ����� ������  �  ����� ����]'];

% 3.8. ������������ ��������� ��������������
tmp_eck_ij = funEckij(linmod.Vseq,linmod.Wseq,linmod.Dseq,n_imode,n_jmode,...
    n_mat, n_node,c);

tmp_eck_ij_sym = funEckij_sym(linmod.Vseq,linmod.Wseq,linmod.Dseq,n_imode,...
    n_jmode,n_mat,n_node,c);

LMA.fkij_L2 = squeeze(tmp_eck_ij ./ (squeeze (LMA.sumEckii)));
LMA.Eckij_norm = LMA.Eck .* LMA.fkij_L2;

LMA.fkij_L2_sym = squeeze(tmp_eck_ij_sym ./ (squeeze (LMA.sumEckii_sym)));
LMA.Eckij_norm_sym = LMA.Eck .* LMA.fkij_L2_sym;

LMA.Description.Eckij_norm = ['������������� ������������������ ���������'...
    ' �������������� [����� ���� ��� �����  �  ����� ������]'];
LMA.Description.fkij_L2 = ['������ �������������� ������������������� ����������'...
    ' �������������� [����� ���� ��� �����  �  ����� ������]'];
LMA.Description.Eckij_norm_sym = ['���������������� �������� Eckij_norm'...
    ' [����� ���� ��� �����  �  ����� ������]'];
LMA.Description.fkij_L2_sym = ['������ �������������� ����������������� ����������'...
    ' �������������� [����� ���� ��� �����  �  ����� ������]'];

clear c n_node n_mat num_i tmp_pki_L2 tmp_pki_L2_sym tmp_eck_ij tmp_eck_ij_sym
%% 4. ������ �����
% 4.1. ������ ���� ���������� ������ ��� ��� n_mode ��� ������ n_model
norm_set = 1; % ������� ������������ �������� ���������� ���������: 
%                   1 - ������������ ���������, ������������� � �������� 
%                       �������� Evki ��� ����� ������������� ������� �;
%                   0 - ������������ ���������, ������������� � �������� 
%                       �������� Evki ��� ���� ������ �.
line_set = 0; % ������� ������� �������� ��� ������:
%                   1 - ����� ��� ������ �������������� ��� ������� ������� 
%                       ���������� ����� ������� � ������� ������� ����
%                   0 - �������� ��� ������ ���
nodelabel_set = 0; % ������� ������� � �����: 
%                   1 - � ����� ������������ ������ �����;
%                   0 - � ����� ������������ �������� ���������� ���������
n_mode = 26; % ������ ������ ����� ����
n_model = 1; % ������ ���������� ����� ��������������� ������ �� ������� n_mat

% ������� ������ ������� ���������� � �������������
Ecki = LMA.Ecki;
%Ecki = LMA.Ecki_norm;
%Ecki = LMA.Ecki_norm_sym;

graphEvki(n_model,n_mode,norm_set,line_set,nodelabel_set,Ecki,linmod);
clear Ecki norm_set line_set n_model n_mode nodelabel_set
%% 4.2. ������ ���� ���������� �������������� ��� ��� n_imode � n_jmode ��� ������ n_model
% �� ��������� �������� ���������� �������� �������� Eckij. ���� � ������
% ����� ����� ��������� ��������� ������ only_MIgraph.m

norm_set = 1; % ������� ������������ �������� ���������� ���������: 
%                   1 - ������������ ���������, ������������� � �������� 
%                       �������� Evki ��� ����� ������������� ������� �;
%                   0 - ������������ ���������, ������������� � �������� 
%                       �������� Evki ��� ���� ������ �.
n_model = 52; % ������ ���������� ����� ��������������� ������ �� ������� n_mat

% ������� ������ ������� ���������� � �������������
Eckij = LMA.Eckij;
%Eckij = LMA.Eckij_sym;
%Eckij = LMA.Eckij_norm;
%Eckij = LMA.Eckij_norm_sym;

graphEvkij(n_model,n_imode,n_jmode,norm_set,Eckij,linmod);
clear Eckij norm_set n_model
%% 5. ��������� ��������� �� "������ Chompoo"
% 5.1. ��������� ��������� �� "������ Chompoo"
clear Chompoo
Chompoo.c_s_v = linmod.C.c_v;   % for voltage magnitude S_V
Chompoo.c_s_teta = linmod.C.c_ang; % for voltage angle S_teta

% ������� (6) ������ CHOMPOOBUTRGOOL
for n = 1:size(linmod.Vseq,3)
    Chompoo.S_V(:,:,n) = Chompoo.c_s_v (:,:,n) * linmod.Vseq(:,:,n);
    Chompoo.S_teta(:,:,n) = Chompoo.c_s_teta (:,:,n) * linmod.Vseq(:,:,n);
end

Chompoo.S_V = permute(Chompoo.S_V,[1 3 2]);
Chompoo.S_teta = permute(Chompoo.S_teta,[1 3 2]);

% 5.2. ������ ����� ��� "������ Chompoo":
norm_set = 1; % ������� ������������ �������� ���������� ���������: 
%                   1 - ������������ ���������, ������������� � �������� 
%                       �������� Evki ��� ����� ������������� ������� �;
%                   0 - ������������ ���������, ������������� � �������� 
%                       �������� Evki ��� ���� ������ �.
nodelabel_set = 0; % ������� ������� � �����: 
%                   1 - � ����� ������������ ������ �����;
%                   0 - � ����� ������������ �������� ���������� ���������
n_mode = 4; % ������ ������ ����� ����
n_model = 1; % ������ ���������� ����� ��������������� ������ 

graphChompoo(n_model,n_mode,norm_set,nodelabel_set,Chompoo,linmod);
clear n n_mode n_model norm_set nodelabel_set
%% 6. ����� ��� ����������� ������������� ����������


%% 7. �������
%% Eck [nodes, models]
figure()
plotEck = plot (linmod.var_par,LMA.Eck(:,:));
grid minor
title('L2-����� ���� ���������� �� �����')
for i = 1 : size(linmod.C.c_v,1,1)
    set(plotEck(i),'DisplayName',['Node',num2str(i)]);
end

%% Ecki [nodes, models, modes]
figure()
plotEcki = plot (linmod.var_par,squeeze(LMA.Ecki(40,:,:)));
grid minor
title('��������� ������ � ���� 40')
for i = 1 : linmod.number_of_mode%size(linmod.C.c_v,1,1)
    set(plotEcki(i),'DisplayName',['Mode',num2str(i)]);
end
%% Eci [nodes, models, modes]
figure()
plotEcki = plot (linmod.var_par,squeeze(sum(LMA.Ecki,1)));
grid minor
title('��������� ��������� ����� ������ ���� �� ��� ����')
for i = 1 : linmod.number_of_mode
    set(plotEcki(i),'DisplayName',['Mode',num2str(i)]);
end

%% Eckij [nodes, models]
figure()
plotEckij = plot (linmod.var_par,LMA.Eckij_sym);
grid minor
title('���������������� ��������������� ��������� �������������� ���� �4 � ���������� � ���� 50')
for i = 1 : 167%size(linmod.C.c_v,1,1)
    set(plotEckij(i),'DisplayName',['Node',num2str(i)]);
end
%%                             �������

%=========================������������ �������=============================
function linmod = fun_linmod(IDSys,var_par,number_of_models)
    try
        % ��������� ���� ��� LMA-���� � PST
        addpath([pwd,'\PST']);
        addpath([pwd,'\LMA_on_graph']);
        
        % �������� ��������� �������
        number_of_node = size(IDSys.System1.bus,1); % ���������� �����
        number_of_line = size(IDSys.System1.line,1); % ���������� �����
        number_of_gen = size(IDSys.System1.mac_con,1);% ���������� �����������    
        
        % �������� ���� ProgressBar
            f = waitbar(0,'Starting...','Name','������������...',...
                'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
            setappdata(f,'canceling',0);
            
        for i = 1:number_of_models
            
            % �������� ������� ������ Cancel
            if getappdata(f,'canceling')
                break
            end
            
            field_name = string(['System' num2str(i)]);
            Data = getfield(IDSys,field_name);% ��������� �������
            settings = struct();
            settings.Display = 0;
            Data.lmon_con = 1:size(Data.line,1);
            result_static = svm_mgen(Data, settings);% ������������
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
            Aseq(:,:,i) = result_static.a_mat; % ������� ��������
            c_v(:,:,i) = result_static.C.c_v; % ���������������� ��� ��������
            c_ang(:,:,i) = result_static.C.c_ang; % ���������������� ��� ���
            c_vbus(:,:,i) = result_static.C.c_vbus; % ����������� ����������������
            c_pf1(:,:,i) = result_static.C.c_pf1; % ���������������� ��� ��������
            p (:,:,i) = result_static.p; % ������� �������
            p_norm (:,:,i) = result_static.p_norm; % ������� ������� �������������
            b_vr(:,:,i) = result_static.B.b_vr; % ������� ����� (����������)
            V0 (:,i) = result_static.loadflow(:,2); % ��������� ������� ���������� � �������������� ������            
            delta0 (:,i) = result_static.loadflow(:,3); % ���� ������� ���������� � �������������� ������
            
            % ���������� ProgressBar
            d_step = i/number_of_models;
            waitbar(d_step,f,sprintf('%d%%',round(d_step*100)))
            
        end
        % ������� ����������� �������� Dseq � ������� Vseq, Wseq
        [Vseq,Dseq,Wseq] = eigenshuffle_rl(Aseq);
        % ������������ ����������� ��������
        [Vseq, Wseq] = norm_eigen(Vseq,Wseq,var_par);
        Wseq = conj(Wseq);
        % ��������� �������� ���������
        linmod.var_par = var_par; % ����������� ��������� ����������� �������������
        linmod.number_of_models = number_of_models; % ����� ���������� ��������������� �������
        linmod.number_of_gen = number_of_gen; % ���������� �����������
        linmod.number_of_node = number_of_node; % ���������� �����
        linmod.number_of_line = number_of_line; % ���������� �����
        linmod.number_of_mode = size(Dseq,1); % ���������� ���
        linmod.Aseq = Aseq; % ����� ������ ��������
        linmod.Dseq = Dseq; % ����� �������� ����������� ��������
        linmod.Vseq = Vseq; % ����� ������ ������������� ������ ����������� ��������
        linmod.Wseq = Wseq; % ����� ������ ������������� ����� ����������� ��������
        linmod.C.c_v = c_v; % ����� ������ ����������������� �������� ������� ����������
        linmod.C.c_vbus = c_vbus; % ����� ����������������� ������ ���������������� ����������
        linmod.C.c_ang = c_ang; % ����� ������ ����������������� ��� ������� ����������
        linmod.C.c_pf1 = c_pf1; % ����� ������ ����������������� ��������� ��������
        linmod.b_vr = b_vr; % ����� ������ ������ (��� ��������� ���������� �������)
        linmod.magV0 = V0; % ����� �������� ������� ���������� � �������������� ������
        linmod.angV0 = delta0; % ����� ��� ������� ���������� � �������������� ������
        linmod.p = p; % ������� �������
        linmod.p_norm = p_norm; % ������� ������� �������������
        linmod.line = result_static.line;
        linmod.RS = result_static;
        % ������� ProgressBar
        delete(f)
    
    % ��� ������������� ����� ������ ������� ProgressBar � ����������
    % ��������� �� ������ � ����� ������ � �������
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

%======================����� ��� "������ Chompoo"==========================
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
    %   ������������ ������������ ������ ��������� ��� ������������� k
        tmpS = S(:,na,nm);
        maxS = max(abs(tmpS));
        for i = 1:size(tmpS,1)
            tmpS(i) = tmpS(i) / maxS;
        end
    else
    %   ������������ ������������ ������ ��������� ��� ���� k
        tmpS = squeeze(S(:,:,nm));
        maxS = max(max(abs(tmpS)));
        tmpS = tmpS(:,na) ./ maxS;
    end

    if min(tmpS) < 0
        CLim = [-1 1]; % ������� ����� ColorBar
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