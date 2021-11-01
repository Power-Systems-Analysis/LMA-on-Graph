%   Energy of i-th mode in k-th node(or line) on voltage(or power flow),
%   equation #10 (LMA-on-Graph.pdf)

function[Ecki] = funEcki_ones(Aseq,number_of_c,number_of_mode,...
    c,Vseq,Wseq,Dseq)


Ecki = zeros(length(number_of_c),length(number_of_mode));
nn = 0;
nm = 0;
c_cnjtr = -conj(permute(c,[2 1 3]));
conj_Dseq = conj(Dseq);
szD = size(Dseq,1);
Wseq_trp = permute(Wseq,[2 1 3]);


for ith = number_of_mode
    nm = nm + 1;
    Ri = (Vseq(:,ith) * Wseq_trp(ith,:))' * c_cnjtr;
    denom = c / (diag(repmat(conj_Dseq(ith),szD,1))+ Aseq);
    for kth = number_of_c
        nn = nn + 1;
        Ecki(nn,nm) = (sum(diag(denom(kth,:) * Ri(:,kth))));
    end
    nn = 0;
end

end

