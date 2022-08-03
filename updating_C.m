
%% -------------------- Objective function J1-----------------------

function [ s_BP ] = updating_C(P,A,y,epsilon)

Theta=A*P;
%Basis Pursuit Algorithm (BP)
%   Inputs
%       y     : measured vector
%       Theta : Sensing matrix
%       epsilon : tolerance for approximation between successive solutions.
%   Output
%       s_BP  : Solution found by the algorithm
mode = 2;           %Default Mode ("epsilon" is detremined)
N = size(Theta,2);  %Signal dimension
size(Theta);%%v
if nargin <3,  mode = 1;end
if mode==1    %"epsilon" isn't detremined
    cvx_begin quiet
    variables s(N) epsilon
    s
    minimize(norm(s,1)+10*epsilon)
    subject to
    norm(y-Theta*s,2)<=epsilon;
    epsilon>=0;
    cvx_end
elseif mode==2 %"epsilon" is determined
    cvx_begin quiet
    variables s(N)
    minimize(norm(s,1))
    subject to
    norm(y-Theta*s,1)<=epsilon;
    cvx_end
end
s_BP = s;
epsilon;
end
