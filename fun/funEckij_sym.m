% Тоже, что и funEckij, только симметризованно

function[Eckij] = funEckij_sym(Vseq,Wseq,Dseq,ith,jth, number_of_matrix,...
    number_of_c,c_v,x0)

%   Eckij - энергия Ляпунова возмущения по параметру "с" на k-ом элементе от
%   пары i-ой и j-ой моды
%   c - матрица наблюдения соответствующего параметра (напряжений в узлах
%   либо перетоков мощности на линиях)
try
    %processing status
    f = waitbar(0,'Starting...','Name','Eсkij_sym calculation...',...
        'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    setappdata(f,'canceling',0);
    
    Eckij = zeros(length(number_of_c),length(number_of_matrix));
    nn = 0;
    na = 0;
    trW = permute(Wseq,[2,1,3]);
    conjtr_cv = conj(permute(c_v,[2,1,3]));
    tmp_denom_conj = -0.5 ./ (conj(Dseq(ith,:)) + Dseq (jth,:));
    tmp_denom = 0.5 ./ (Dseq(ith,:) + Dseq (jth,:));
    x0_tr = x0.';
    if isempty(x0)
        for a = number_of_matrix
            % Check for clicked Cancel button
            if getappdata(f,'canceling')
                break
            end
            na = na + 1;
            Ri = Vseq(:,ith,a) * trW(ith,:,a);
            conjtrRi = Ri';
            trRi = Ri.';
            Rj = Vseq(:,jth,a) * trW(jth,:,a);
            Rjdenom_conj = Rj * tmp_denom_conj (a);
            Rjdenom = Rj * tmp_denom (a);
            for kth = number_of_c
                nn = nn + 1;
                Qk = conjtr_cv(:,kth,a) * c_v(kth,:,a);
                Pvkij = real(conjtrRi * Qk * Rjdenom_conj + trRi * Qk * Rjdenom);
                Eckij(nn,na) = trace(Pvkij);
            end
            nn = 0;
            % Update waitbar and message
            d_step = na/length(number_of_matrix);
            waitbar(d_step,f,sprintf('%d%%',round(d_step*100)))
        end
    else
       for a = number_of_matrix
        % Check for clicked Cancel button
        if getappdata(f,'canceling')
            break
        end
        na = na + 1;
        Ri = Vseq(:,ith,a) * trW(ith,:,a);
        conjtrRi = Ri';
        trRi = Ri.';
        Rj = Vseq(:,jth,a) * trW(jth,:,a);
        Rjdenom_conj = Rj * tmp_denom_conj (a);
        Rjdenom = Rj * tmp_denom (a);
        for kth = number_of_c
            nn = nn + 1;
            Qk = conjtr_cv(:,kth,a) * c_v(kth,:,a);
            Pvkij = real(conjtrRi * Qk * Rjdenom_conj + trRi * Qk * Rjdenom);
            Eckij(nn,na) = x0_tr * (Pvkij) * x0;
        end
        nn = 0;
        % Update waitbar and message
        d_step = na/length(number_of_matrix);
        waitbar(d_step,f,sprintf('%d%%',round(d_step*100)))
       end
    end
    delete(f)
    %Eckij = real(Eckij);
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

