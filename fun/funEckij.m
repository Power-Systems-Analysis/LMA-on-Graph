% LMIE of the i-th & j-th mode in k-th node equation #11 (IFAC20_3230_MS.pdf)

function[Eckij] = funEckij(Vseq,Wseq,Dseq,number_ith_mode,number_jth_mode,...
    number_of_matrix, number_of_c,c_v)

%   Eckij - ýíåðãèÿ Ëÿïóíîâà âîçìóùåíèÿ ïî ïàðàìåòðó "ñ" íà k-îì ýëåìåíòå îò
%   ïàðû i-îé è j-îé ìîäû
%   c - ìàòðèöà íàáëþäåíèÿ ñîîòâåòñòâóþùåãî ïàðàìåòðà (íàïðÿæåíèé â óçëàõ
%   ëèáî ïåðåòîêîâ ìîùíîñòè íà ëèíèÿõ)
try
    %processing status
    f = waitbar(0,'Starting...','Name','Eñkij calculation...',...
        'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    setappdata(f,'canceling',0);

    Eckij = zeros(length(number_of_c),length(number_of_matrix));
    ons = ones(size(c_v,1),1);
    ek = diag(ons);
    tr_ek = ek.';
    nn = 0; 
    conjD = conj(Dseq);
    trW = permute(Wseq,[2,1,3]);
    conjtr_cv = conj(permute(c_v,[2,1,3]));
    jth = number_jth_mode;
    tmp_denom = -1 ./ (conjD + Dseq (jth,:));
    ith = number_ith_mode;
    na = 0;
    for a = number_of_matrix
        % Check for clicked Cancel button
        if getappdata(f,'canceling')
            break
        end
        na = na + 1;
        Ri = Vseq(:,ith,a) * trW(ith,:,a);
        conjtrRi = Ri';
        Rj = Vseq(:,jth,a) * trW(jth,:,a);
        denom = tmp_denom (ith,a);
        Rjdenom = Rj * denom;
        for kth = number_of_c
            nn = nn + 1;
            Qk = conjtr_cv(:,:,a) * ek(:,kth) * tr_ek(kth,:) * c_v(:,:,a);
            Pvkij = conjtrRi * Qk * Rjdenom;
            Eckij(nn,na) = real(trace(Pvkij));
        end
        nn = 0;
        % Update waitbar and message
        d_step = na/length(number_of_matrix);
        waitbar(d_step,f,sprintf('%d%%',round(d_step*100)))
    end
    delete(f)

% Ïðè âîçíèêíîâåíèè ëþáîé îøèáêè óáèðàåì ProgressBar è âîçâðàùàåì
% ñîîáùåíèå îá îøèáêå è íîìåð ñòðîêè ñ îøèáêîé
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

