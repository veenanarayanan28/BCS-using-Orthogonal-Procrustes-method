%% -------------------- Objective function J2-----------------------


function  X=updating_X(P,S,A,B,n1,wstart)

[~,N]=size(B);
% fun1=@(x) 0.6*norm((B-A*x))^2+0.22*norm(x-P*S)^2+0.18*gt_tvv_sqrt(n1,x);
 fun1=@(x) 0.6*norm((B-A*x))^2+0.22*norm(x-P*S)^2+0.18*reg(n1,x);%%J2
options = optimoptions(@fminunc,'Algorithm','quasi-newton','MaxIter',500,'MaxFunEvals', 2000,'TolFun',1e-12,'TolX',1e-12,'display','off');
[X,~,~,~] = fminunc(fun1,wstart,options);

for tr=1:N
    Xnorm(tr)=1./norm(X(:,tr));
end
X=X*diag(Xnorm);
save xupdate_sp_tv_m32.mat




