%   Normalize eigenvectors
%   Vseq - right eigenvector (colum)
%   Wseq - left eigenvector (colum)

function [Vseq, Wseq] = norm_eigen( Vseq,Wseq,apw )
%EPS = [];
for n = 1 : length(apw)
    
    EVR = Vseq(:,:,n);
    EVL = Wseq(:,:,n);
    eps = 0;
    
for i = 1 : size(Vseq,1)
    tmpc = sum(EVR(:,i) .* conj(EVL(:,i)));
    tmpc = sqrt(tmpc);
    EVR(:,i) = EVR(:,i) ./ tmpc;
    EVL(:,i) = EVL(:,i) ./ conj(tmpc);
    eps = eps + abs(1.0 - real(sum( EVR(:,i).*conj(EVL(:,i)) )));
    eps = eps + abs(imag(sum(EVR(:,i).*conj((EVL(:,i)) ))));
end
    %EPS(n,1) = eps;
    Vseq(:,:,n) = EVR;
    Wseq(:,:,n) = EVL;
end
end