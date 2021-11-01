function [Ecki] = funEcki(Aseq,number_of_c,number_of_mode,number_of_matrix,...
    c,Vseq,Wseq,Dseq,x0)

%   Ecki - энергия Ляпунова возмущения по параметру "с" на k-ом элементе от
%   i-ой моды
%   Aseq - набор матриц динамики
%   number_of_c - диапазон номеров узлов (для напряжений), либо номеров 
%   линий (для перетоков)
%   c - матрица наблюдения соответствующего параметра (напряжений в узлах
%   либо перетоков мощности на линиях)
%   x0 - вектор начальных условий
try
     %processing status
    f = waitbar(0,'Starting...','Name','Eсki calculation...',...
        'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    setappdata(f,'canceling',0);
    
    Ecki = zeros(length(number_of_c),length(number_of_mode),...
        length(number_of_matrix));
    x0_tr = x0.';
    if isempty (x0)
        for a = number_of_matrix
            % Check for clicked Cancel button
            if getappdata(f,'canceling')
                break
            end
            [Ecki(:,:,a)] = funEcki_ones(Aseq(:,:,a),number_of_c,number_of_mode,...
            c(:,:,a),Vseq(:,:,a),Wseq(:,:,a),Dseq(:,a));
            % Update waitbar and message
            d_step = a/length(number_of_matrix);
            waitbar(d_step,f,sprintf('%d%%',round(d_step*100)))
        end
    else
        for a = number_of_matrix
            % Check for clicked Cancel button
            if getappdata(f,'canceling')
                break
            end
            [Ecki(:,:,a)] = funEcki_ones_x0(Aseq(:,:,a),number_of_c,number_of_mode,...
            c(:,:,a),Vseq(:,:,a),Wseq(:,:,a),Dseq(:,a),x0,x0_tr);
            % Update waitbar and message
            d_step = a/length(number_of_matrix);
            waitbar(d_step,f,sprintf('%d%%',round(d_step*100)))
        end
    end
    Ecki = permute(real(Ecki),[1 3 2]);
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