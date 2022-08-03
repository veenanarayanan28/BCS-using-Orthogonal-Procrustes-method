clc;
clear all;
close all;
%% --------------generating measurement vector--------------
load('speech_A_Y.mat')%% input
%% ----------------Initialize------------
epsilon=0.0001;%% error tolerance for J1
psi=eye(n);P=psi; %% initial arbitrary basis
L=size(x_m,2);%% no: of segments of speech
X1_1=ones(n,L);%% initial arbitrary signal vector
X1(:,:,1)=X1_1;
itmax=500;%% Maximum no: of iterations
tol=0.001;%% error tolerance (Stoping criterion)
avg_error_tv(1)=(1/(n*L))*norm(x_m-X1(:,:,1),'fro')^2; %% initial average error
for j=2:itmax
    j
    %% -------------Updating C------------------------ 
    for i=1:L
        S_cap(:,i) = updating_C(P,A,Y(:,i),epsilon);
        S_cap(:,i)=normc(S_cap(:,i)); %% normalizing C
    end
    rank_S1(j)=rank(S_cap);
    S1(:,:,j)=S_cap;%% Saving C^ obtained in each iteration.
    
    %% -------------Updating X------------------------ 
    for i=1:L
        i;
        X_tv(:,i) = updating_X(P,S1(:,i,j),A,Y(:,i),n,X1(:,i,j-1));
    end
    X1(:,:,j)=X_tv;%% Saving X^ obtained in each iteration.
    rank_X_tv(:,j)=rank(X_tv);
   %% -------------------Average error and Stopping criterion--------------------   
    avg_error_tv(j)=(1/(n*L))*norm(x_m-X_tv,'fro')^2;
    e(:,j-1)=(1/(n*L))*norm(X1(:,:,j-1)-X1(:,:,j),'fro')^2;
    %%-------stopping criterion-----------
    if (1/(n*L))*norm(X1(:,:,j-1)-X1(:,:,j),'fro')^2<tol
        break
    end 
    %% -------------------Updating \Psi using Procrustes method--------------
    E=X1(:,:,j)*S1(:,:,j)';% E=X^C^
    [U,Sigma,V] = svd(E);% E=U \Sigma V'
    R=rank(Sigma);  rank_sigma(:,j)=rank(Sigma);    rank_P(:,j)=rank(P);
    Sig(:,:,j)=Sigma;
    P=U*V'; %\Psi^=UV';
    P2(:,:,j)=P;%% Saving \Psi^ obtained in each iteration

    %save speech_bcs2_BP_Proc_loop_program_128_0.09tv.mat
end

%%-------Plotting the updated basis---------------
% basis_learned1= figure ;
% for j=1:6
% subplot(3,2,j)
% plot(P(:,j),'linewidth',1)
% xlabel('time')
% ylabel('Amplitude');title(sprintf('Column %d',j))
% end

%%-------Plotting the updated signal estimate (for one segment)---------------
L=size(x_m,2);
% sign=figure;
% plot(x_m(:,L),'b')
% hold on
% plot(X_tv(:,L),'r');
% legend('X','Xcap')
% xlabel('time index')
% ylabel('Amplitude');
%saveas(sign,'speech_signal_m64_eye.png')
 
%%-------Plotting the average reconstruction error---------------
% recerr=figure;
% plot(avg_error_tv(2:end))
% xlabel('Number of Iterations')
% ylabel('Er')
%saveas(recerr,'speech_reco_error_m64_eye.png')

%%---------reconstruction error in dB-----
error1=mag2db(avg_error_tv);
error=error1(2:end);
recedb=figure;
semilogy(error,'LineWidth',2);
xlabel('Number of Iterations')
ylabel('E_r (dB)')
ax = gca; 
ax.XTick = unique( round(ax.XTick) );
ax.FontSize = 14; 
ax.FontWeight = 'bold'; 
grid on

%%-------------Iteration error-----------------
% recerr11=figure;
% plot(e(2:end))
% xlabel('Number of Iterations')
% ylabel('e')
%saveas(recerr11,'speech_iter_error_m64_eye.png')

%%-------------Iteration error in semi-log-y style-----------------
figure;
error2=e(2:end);
semilogy(error2,'LineWidth',2);
xlabel('Number of Iterations')
ylabel('Iteration error')
grid on
ax = gca;
ax.XTick = unique( round(ax.XTick) );
ax.FontSize = 14;
ax.FontWeight = 'bold';

%% ---------------Coefficients corresponding to the updated Basis and signal estimate----
P_new=P2(:,:,end-1);
for j=1:L
    Sest_bp(:,j)=updating_C1(P_new,X_tv(:,j),epsilon);
end
xrec_bp=P_new*Sest_bp;
Sest_bp(abs(Sest_bp)<0.09)=0;
% rec1=figure;plot(x_m(:,166)); hold on; plot(xrec_bp(:,166));legend('Original','Reconstructed')
% xlabel('time index')
% ylabel('Amplitude')
% rec2=figure;stem(C(:,166)); hold on; stem(Sest_bp(:,166));legend('Original','Reconstructed')

%% ------------Combining reconstructed speech segments to form complete speech------

xm2=x_m(:,1:27);%% original speech segments of signal 1 for comparison
xtv_13=X_tv(:,1:27); %% reconstructed speech segments
fs = 8000;%5 sampling frequency
Tw = 8;
Ts = Tw/2;
% w = hamming(n,'periodic').';% analysis frame shift (ms)
Nw = round( 0.001*Tw*fs );              % analysis frame duration (samples)
Ns = round( 0.001*Ts*fs );              % analysis frame shift (samples)
direction = 'rows';                     % frames as rows
padding = true;                         % pad with zeros
w = hamming(n,'periodic').';% analysis frame shift (ms)
%%--------------Original test set-----------
load('input_speech_test_train_sig.mat')
%% -----------------Speech signal 1---------------
frame13_orig= frames2vec(xm2', ind13, direction, w );
frame13_rec = frames2vec(xtv_13', ind13, direction, w );
%%-----Plot of original and recontructed signal 1---------
figure;
plot(frame13_orig(33:256),'b','LineWidth',1)
hold on
plot(frame13_rec(33:256),'--r','LineWidth',1);
legend('X','Xcap')
xlabel('time index')
ylabel('Amplitude');
ax = gca;
ax.XTick = unique( round(ax.XTick) );
ax.FontSize = 14;
ax.FontWeight = 'bold';

%% -----------------Speech signal 2---------------

xm3=x_m(:,27:36);%% original speech segments of signal 2 for comparison
xtv_9=X_tv(:,27:36); %% reconstructed speech segments
frame9_orig= frames2vec(xm3', ind9, direction, w );
frame9_rec = frames2vec(xtv_9', ind9, direction, w );

%%-----Plot of original and recontructed signal 2--------- 
sign=figure;
plot(frame9_orig(33:256),'b','LineWidth',1)
hold on
plot(frame9_rec(33:256),'--r','LineWidth',1);
legend('X','Xcap')
xlabel('time index')
ylabel('Amplitude');
ax = gca;
ax.XTick = unique( round(ax.XTick) );
ax.FontSize = 14;
ax.FontWeight = 'bold';

%% --------------Plotting coefficients-----------------------------
%rec2=figure;stem(C(:,166)); hold on; stem(Sest_bp(:,166));legend('Original','Reconstructed')