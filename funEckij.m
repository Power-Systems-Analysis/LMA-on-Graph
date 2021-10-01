% LMIE of the i-th & j-th mode in k-th node equation #11 (IFAC20_3230_MS.pdf)

function[Eckij] = funEckij(Vseq,Wseq,Dseq,number_ith_mode,number_jth_mode,...
    number_of_matrix, number_of_c,c_v)

%   Eckij - энергия Ляпунова возмущения по параметру "с" на k-ом элементе от
%   пары i-ой и j-ой моды
%   Aseq - набор матриц динамики
%   number_of_c - диапазон номеров узлов (для напряжений), либо номеров 
%   линий (для перетоков)
%   c - матрица наблюдения соответствующего параметра (напряжений в узлах
%   либо перетоков мощности на линиях)

Eckij = zeros(length(number_of_c),length(number_of_matrix));

ons = ones(size(c_v,1),1);
ek = diag(ons);
tr_ek = ek.';
nn = 0; 

conjD = conj(Dseq);
trW = permute(Wseq,[2,1,3]);
tr_cv = permute(c_v,[2,1,3]);


jth = number_jth_mode;
tmp_denom = -1 ./ (conjD + Dseq (jth,:));
ith = number_ith_mode;
for a = number_of_matrix
    Ri = Vseq(:,ith,a) * trW(ith,:,a);
    conjtrRi = Ri';
    Rj = Vseq(:,jth,a) * trW(jth,:,a);
    denom = tmp_denom (ith,a);
    Rjdenom = Rj * denom;
    for kth = number_of_c
        nn = nn + 1;
        Qk = tr_cv(:,:,a) * ek(:,kth) * tr_ek(kth,:) * c_v(:,:,a);
        Pvkij = conjtrRi * Qk * Rjdenom;
        Eckij(nn,a) = real(trace(Pvkij));
    end
nn = 0;

end

end

