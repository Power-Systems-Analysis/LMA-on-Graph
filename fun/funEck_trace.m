% Energy in the k-th node/line, on voltage/current/power flow
% equation #7 (LMA-on-Graph.pdf)

function[Eck] = funEck_trace(Aseq,number_of_c,number_of_matrix,c)

%processing status
f = waitbar(0,'Starting...','Name','Eck calculation...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',0)');

setappdata(f,'canceling',0);

Eck = zeros(length(number_of_c),length(number_of_matrix));
zrs = zeros(size(c,1),size(c,1));
nn = 0;
c_cnjtr = conj(permute(c,[2 1 3]));
A_cnjtr = conj(permute(Aseq,[2 1 3]));
for kth = number_of_c

    % Check for clicked Cancel button
    if getappdata(f,'canceling')
        break
    end
    
%     ek = zrs;
%     nn = nn + 1;
%     ek(kth,kth) = 1;
%     EK = ek*ek.';
    

    EK = zrs;
    nn = nn + 1;
    EK(kth,kth) = 1;
    
    
    
    for a = number_of_matrix
        %Q = c(:,:,a)'*EK*c(:,:,a);
        Q = c_cnjtr(:,:,a)*EK*c(:,:,a);
        %Eck(nn,a) = trace(lyap(Aseq(:,:,a)',Q));
        Eck(nn,a) = trace(lyap(A_cnjtr(:,:,a),Q));
    end
    
    % Update waitbar and message
    waitbar(kth/length(number_of_c),f,sprintf('%d%%',kth))
    
end

delete(f)
end

