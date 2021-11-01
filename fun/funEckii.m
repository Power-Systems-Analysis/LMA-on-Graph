% То же, что и funEckij, но вычисления проводятся только для i = j

function[Eckii] = funEckii(linmod,n_mat,n_node,c)

%   Eckii - энергия Ляпунова возмущения по параметру "с" на k-ом элементе от
%   пары i-ой и i-ой моды
%   c - матрица наблюдения соответствующего параметра (напряжений в узлах
%   либо перетоков мощности на линиях)
try
    %processing status
    f = waitbar(0,'Starting...','Name','Eсkii calculation...',...
        'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    setappdata(f,'canceling',0);

    % Сортировка мод по типу
    [~, id_oscillatory,~,id_aperiodic] = fun_ModeType(linmod.Dseq);
    
    n_mode = linmod.number_of_mode;
    Eckii = zeros(length(n_node),n_mode,length(n_mat));
    Vseq = linmod.Vseq;
    nn = 0; 
    trW = permute(linmod.Wseq,[2,1,3]);
    conjtr_cv = conj(permute(c,[2,1,3]));
    tmp_denom = -1 ./ real(linmod.Dseq);
    na = 0;
    for a = n_mat
        % Check for clicked Cancel button
        if getappdata(f,'canceling')
            break
        end
        
        na = na + 1;
        n_i = 0;
        id_a = nonzeros(id_aperiodic(:,a)).';
        id_o = nonzeros(id_oscillatory(:,a)).';
        n_mode_calc = length(id_a) + 0.5 * length(id_o);
        
        % Апериодические моды
        for i = id_a
            % Check for clicked Cancel button
            if getappdata(f,'canceling')
                break
            end
            
            n_i = n_i + 1;
            Ri = Vseq(:,i,a) * trW(i,:,a);
            conjtrRi = Ri';
            denom = tmp_denom (i,a);
            Rjdenom = Ri * denom;
            for kth = n_node
                nn = nn + 1;
                Eckii(nn,i,na) = sum(diag(conjtrRi * conjtr_cv(:,kth,a) * c(kth,:,a) * Rjdenom));
            end
            nn = 0;
            % Update waitbar and message
            d_step = n_i/n_mode_calc;
            waitbar(d_step,f,sprintf('Model# %d/%d:  %d%%',na,length(n_mat),...
                round(d_step*100)))
        end
        
        % Колебательные моды
        for tmp_i = 1:2:length(id_o)
            % Check for clicked Cancel button
            if getappdata(f,'canceling')
                break
            end
            
            i = id_o(tmp_i);
            n_i = n_i + 1;
            Ri = Vseq(:,i,a) * trW(i,:,a);
            conjtrRi = Ri';
            denom = tmp_denom (i,a);
            Rjdenom = Ri * denom;
            for kth = n_node
                nn = nn + 1;
                Eckii(nn,i,na) = sum(diag(conjtrRi * conjtr_cv(:,kth,a) * c(kth,:,a) * Rjdenom));
                Eckii(nn,i+1,na) = Eckii(nn,i,na);
            end
            nn = 0;
            % Update waitbar and message
            d_step = n_i/n_mode_calc;
            waitbar(d_step,f,sprintf('Model# %d/%d:  %d%%',na,length(n_mat),...
                round(d_step*100)))
        end
    end
    
    Eckii = real(Eckii);
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

function [oscillatory, id_oscillatory, aperiodic,id_aperiodic] =...
    fun_ModeType(Dseq)
    oscillatory = [];
    id_oscillatory = [];
    aperiodic = [];
    id_aperiodic = [];
    for j = 1:size(Dseq,2)
        ka = 0;
        ko = 0;
        for ni = 1:size(Dseq,1)
            if imag(Dseq(ni,j)) == 0
                ka = ka + 1;
                aperiodic(ka,j) = Dseq(ni,j);
                id_aperiodic(ka,j) = ni;
            else
                ko = ko + 1;
                oscillatory(ko,j) = Dseq(ni,j);
                id_oscillatory(ko,j) = ni;
            end
        end
    end
end
end

