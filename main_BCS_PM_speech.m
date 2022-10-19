clc;
clear all;
close all;
%% --------------generating measurement vector--------------
load('speech_A_Y_m32_rev4.mat')
%% ----------------Initialize------------
epsilon=0.0001;%% error tolerance for J1
psi=eye(n);
P=psi; %% initial arbitrary basis
L=size(x_m,2);%% no: of segments of speech
X1_1=ones(n,L);%% initial arbitrary signal vector
X1(:,:,1)=X1_1;
itmax=500;%% Maximum no: of iterations
tol=0.0001;%% error tolerance (Stoping criterion)
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
%%save speech_BCSPM_Proc_loop_program.mat.mat
end
x_rec=X_tv;

[n,L]=size(x_m);
for i1=1:L
    snr_val(:,i1)=10*log(norm(x_m(:,i1))^2/norm(x_rec(:,i1)-x_m(:,i1))^2);
    %snr_val1(i,:)=10*log((norm(x_m(:,i))/norm(x_rec(:,i)-x_m(:,i)))^2);
end
SNR=1/L*sum(snr_val);
% save SNR.mat
%%-------Plotting the updated basis---------------
% basis_learned1= figure ;
% for j=1:6
% subplot(3,2,j)
% plot(P(:,j),'linewidth',1)
% xlabel('time')
% ylabel('Amplitude');title(sprintf('Column %d',j))
% end

%%-------Plotting the updated signal estimate (for one segment)---------------
% L=size(x_m,2);%% Here, L=12
% sign=figure;
% plot(x_m(:,L),'b')
% hold on
% plot(X_tv(:,L),'r');
% legend('X','Xcap')
% xlabel('time index')
% ylabel('Amplitude');
%%%saveas(sign,'speech_signal_m64_eye.png')
 
%%-------Plotting the average reconstruction error---------------
% recerr=figure;
% plot(avg_error_tv(2:end))
% xlabel('Number of Iterations')
% ylabel('Er')
%%%saveas(recerr,'speech_reco_error_m64_eye.png')

%%---------average reconstruction error in dB-----
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
%%%saveas(recerr11,'speech_iter_error_m64_eye.png')

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
L=12;
P_new=P2(:,:,end-1);
for j=1:L
    Sest_bp(:,j)=updating_C1(P_new,X_tv(:,j),epsilon);
end
xrec_bp=P_new*Sest_bp;
Sest_bp(abs(Sest_bp)<0.12)=0;
xrec_bp1=P_new*Sest_bp;
% rec1=figure;plot(x_m(:,L)); hold on; plot(xrec_bp(:,L));legend('Original','Recovered')
% % rec2=figure;plot(x_m(:,L)); hold on; plot(xrec_bp1(:,L));legend('Original','Recovered')
% xlabel('time index')
% ylabel('Amplitude')
% figure;stem(C(:,L)); hold on; stem(Sest_bp(:,L));xlabel('index')
% ylabel('Amplitude');legend('Original','Recovered')

%% ------------Combining reconstructed speech segments to form complete speech------

xm2=x_m(:,1:73);%% original speech segments of signal 1 for comparison
xtv_13=X_tv(:,1:73); %% reconstructed speech segments
fr_sh=61;
fr_len=64;
w = rectwin(fr_len).';  
fr_type='cols';
syn_w= 'A&R';

%% -----------------Speech signal 1---------------
frame13_orig= frames2vec(xm2,fr_sh,fr_type,w,syn_w);
frame13_rec = frames2vec(xtv_13,fr_sh,fr_type,w,syn_w);
%%-----Plot of original and recontructed signal 1---------
sign7=figure;
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
% %%saveas(sign7,'speech_signal_frame13_m10_proposed.png')
% %%saveas(sign7,'f_speech_signal_frame13_m10_proposed.fig')

sign8=figure;
plot(frame13_orig(33:end-32),'b','LineWidth',1)
hold on
plot(frame13_rec(33:end-32),'--r','LineWidth',1);
legend('X','Xcap')
xlabel('time index')
ylabel('Amplitude');
ax = gca;
ax.XTick = unique( round(ax.XTick) );
ax.FontSize = 14;
ax.FontWeight = 'bold';
% %%saveas(sign8,'speech_signal_frame13full_m10_proposed.png')
% %%saveas(sign8,'f_speech_signal_frame13full_m10_proposed.fig')

%% -----------------Speech signal 2---------------

% % xm3=x_m(:,74:169);%% original speech segments of signal 2 for comparison
% % xtv_9=X_tv(:,74:169); %% reconstructed speech segments
% % frame9_orig= frames2vec(xm3,fr_sh,fr_type,w,syn_w);
% % frame9_rec = frames2vec(xtv_9,fr_sh,fr_type,w,syn_w);
% % 
% % %-----Plot of original and recontructed signal 2--------- 
% % sign2=figure;
% % plot(frame9_orig(33:256),'b','LineWidth',1)
% % hold on
% % plot(frame9_rec(33:256),'--r','LineWidth',1);
% % legend('X','Xcap')
% % xlabel('time index')
% % ylabel('Amplitude');
% % ax = gca;
% % ax.XTick = unique( round(ax.XTick) );
% % ax.FontSize = 14;
% % ax.FontWeight = 'bold';
% % %saveas(sign2,'speech_signal_frame9_m10_proposed.png')
% % %saveas(sign2,'f_speech_signal_frame9_m10_proposed.fig')
% % % -------------------------------
% % sign3=figure;
% % plot(frame9_orig(33:end-32),'b','LineWidth',1)
% % hold on
% % plot(frame9_rec(33:end-32),'--r','LineWidth',1);
% % legend('X','Xcap')
% % xlabel('time index')
% % ylabel('Amplitude');
% % ax = gca;
% % ax.XTick = unique( round(ax.XTick) );
% % ax.FontSize = 14;
% % ax.FontWeight = 'bold';
% % %saveas(sign3,'speech_signal_frame9full_m10_proposed.png')
% % %saveas(sign3,'f_speech_signal_frame9full_m10_proposed.fig')

%% --------------Plotting coefficients-----------------------------
%%% rec2=figure;stem(C(:,L)); hold on; stem(Sest_bp(:,L));legend('Original','Reconstructed')
%%save full_speech_bcs2_BP_Proc_loop_program_m10_proposed_tv_0.18_r4.mat