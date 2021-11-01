% Energy in the k-th node/line, on voltage/current/power flow
% equation #7 (LMA-on-Graph.pdf)

function[Eck] = funEck_trace(Aseq,number_of_c,number_of_matrix,c)
try
    %processing status
    f = waitbar(0,'Starting...','Name','Eck calculation...',...
        'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    setappdata(f,'canceling',0);

    Eck = zeros(length(number_of_c),length(number_of_matrix));
    zrs = zeros(size(c,1),size(c,1));
    nn = 0;
    na = 0;
    c_cnjtr = conj(permute(c,[2 1 3]));
    A_cnjtr = conj(permute(Aseq,[2 1 3]));
    for kth = number_of_c
        % Check for clicked Cancel button
        if getappdata(f,'canceling')
            break
        end
        EK = zrs;
        nn = nn + 1;
        EK(kth,kth) = 1;    
        for a = number_of_matrix
            na = na + 1;
            Q = c_cnjtr(:,:,a)*EK*c(:,:,a);
            Eck(nn,na) = trace(lyap(A_cnjtr(:,:,a),Q));
        end
        na = 0;
        % Update waitbar and message
        d_step = kth/length(number_of_c);
        waitbar(d_step,f,sprintf('%d%%',round(d_step*100)))
    end
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

