function [Ecki] = funEcki(Aseq,number_of_c,number_of_mode,number_of_matrix,...
    c,Vseq,Wseq,Dseq)

%   Ecki - ýíåðãèÿ Ëÿïóíîâà âîçìóùåíèÿ ïî ïàðàìåòðó "ñ" íà k-îì ýëåìåíòå îò
%   i-îé ìîäû
%   Aseq - íàáîð ìàòðèö äèíàìèêè
%   number_of_c - äèàïàçîí íîìåðîâ óçëîâ (äëÿ íàïðÿæåíèé), ëèáî íîìåðîâ 
%   ëèíèé (äëÿ ïåðåòîêîâ)
%   c - ìàòðèöà íàáëþäåíèÿ ñîîòâåòñòâóþùåãî ïàðàìåòðà (íàïðÿæåíèé â óçëàõ
%   ëèáî ïåðåòîêîâ ìîùíîñòè íà ëèíèÿõ)

 %processing status
f = waitbar(0,'Starting...','Name','Eñki calculation...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',0)');

setappdata(f,'canceling',0);

Ecki = zeros(length(number_of_c),length(number_of_mode),...
    length(number_of_matrix));
for a = number_of_matrix
    % Check for clicked Cancel button
    if getappdata(f,'canceling')
        break
    end
    
    [Ecki(:,:,a)] = funEcki_ones(Aseq(:,:,a),number_of_c,number_of_mode,...
    c(:,:,a),Vseq(:,:,a),Wseq(:,:,a),Dseq(:,a));

    % Update waitbar and message
    waitbar(a/length(number_of_matrix),f,sprintf('%d%%',a))
end

Ecki = permute(Ecki,[1 3 2]);

delete(f)
end
