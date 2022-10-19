function  sup=reg(N,sig)

% N=length(sig);
for K=1:N
    B(:,K)=circshift(sig,K-1);
end

h=[1;-2;1;zeros(N-3,1)]';
D=circulant(h);
D=D(1:(N-2),:);

diff=D*sig;

sum_diff=sum(abs(diff));
sup=sum_diff;

