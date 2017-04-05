%% Script gyak8_matlabgyak1_kimaradhat
%  
%  file:   gyak8_matlabgyak1_kimaradhat.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.04.05. Wednesday, 15:24:58
%
%% Linearized model around the unstable equilibrium point

% model parameters
M = 0.5;
m = 0.2;
l = 1;
g = 9.8;
b = 0;

A = [
    0                     1                             0  0
    0      -(4*b)/(4*M + m)            -(3*g*m)/(4*M + m)  0
    0                     0                             0  1
    0   (3*b)/(l*(4*M + m))   (3*g*(M + m))/(l*(4*M + m))  0
    ];

B = [
    0
    4/(m+4*M)
    0
    -3/(m+4*M)/l
    ];

C = [
    1 0 0 0
    0 0 1 0
    ];

D = [ 
    0 
    0 
    ];

% C = sum(C,1);
% D = sum(D,1);

%% 12. PID - determine the transfer function of the system

s = tf('s');
sys = ss(A,B,C,D,'InputName','force (F)',...
        'OutputName',{'r' 'phi'},...
        'StateName',{'x1 = r' 'x2 = v' 'x3 = phi' 'x4 = omega'});
H = tf(sys);

H_r = H(1);
H_phi = H(2);

pidopts = pidtuneOptions('PhaseMargin',0)
PID1 = pidtune(H(2),'pidf',pidopts);
pidTuner(H(2), PID1)

He1 = minreal(feedback(series(PID1,H),1,1,2))
impulse(He1,50)

PID2 = pidtune(He1(1), 'pid');
pidTuner(He1(1), PID2)

He2 = minreal(feedback(series(PID2,He1),1,1,1))

t = 0:0.1:40;
u = 2*randn(size(t));
[y,t] = lsim(He2,u,t);
figure(1), plot(t,y)
gyak8_simulate_pendulum_0(t,y)

%%

[y,t] = impulse(He1,10);
figure(1), plot(t,y)
gyak8_simulate_pendulum_0(t,y)

%% 12. PID - determine the transfer function of the system

s = tf('s');
sys = ss(A,B,C,D,'InputName','force (F)',...
        'OutputName',{'r' 'phi'},...
        'StateName',{'x1 = r' 'x2 = v' 'x3 = phi' 'x4 = omega'});
H = tf(sys);
PID = 10 + 1/s + s;

He = minreal(feedback(H,PID,1,2,+1));
p = pzmap(He);
[y,t] = impulse(He,10);
figure(1), plot(t,y)
gyak8_simulate_pendulum_0(t,y)

%% 13. PID - NOT minimum phase

H = tf([1 -1],conv([1 3 2],[1 -1]));

PID = pidtune(H,'pid');
He = feedback(PID*H,1);
impulse(He)

%% 13. PID - minimum phase

H = tf([1 3 2],conv([1 3 2],[1 -10]));

PID = pidtune(H,'pid');
He = feedback(PID*H,1);
impulse(He)

%% 13. PID - minimum phase

H = tf([1 3 2],conv([1 4],poly([1+1j,1-1j])));

PID = pidtune(H,'pid');
He = feedback(PID*H,1);
impulse(He)

%%
pidTuner(H,PID);
pidTuner(H,PID);




