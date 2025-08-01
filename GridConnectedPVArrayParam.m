
% System frequency (Hz):
Fnom=50; 

% Sample Time (s):
Ts=5e-06;
% Specialized Power Systems sample time (s):
Ts_Power=1e-04; % 1/(33*Fnom)/100;
% Inverter Control system sample time (s):
Ts_Control=1e-04; % 10*Ts_Power;     
% PV system sample time (s):
Ts_Irradiance=1e-03;


% *****************************************************************
%                         POWER PARAMETERS
% *****************************************************************

Pnom=33.33e3;      % Inverter nominal 3-phase power (VA)
Vnom_prim=22e3;  % Nominal inverter primary line-to-line voltage(Vrms)
Vnom_dc=700;     % Nominal DC link voltage (V)

% Nominal inverter secondary line-to-line voltage (Vrms):
Vnom_sec=0.95*Vnom_dc/2/sqrt(2)*sqrt(3);

% Transformer parameters:
% Nominal voltage in Vrms, Resistance in pu and Leakage inductance in pu

Pnom_xfo=250.00*1e03;       % Transformer nominal power (VA)
TotalLeakage=0.06;   % Transformer total leakage (pu)

W1_xfo=  [Vnom_prim TotalLeakage/25/2  TotalLeakage/2];  % Winding 1 (Grid side)
W2_xfo=  [Vnom_sec  TotalLeakage/25/2  TotalLeakage/2];  % Winding 2 (DC link side)

Rm_xfo=200;  % Magnetization resistance (pu)
Lm_xfo=200;  % Magnetization inductance (pu)

% Inverter choke RL [Rpu Lpu]
RLchoke=[ 0.15/100  0.15 ];  % in pu
Pbase_sec=Vnom_sec^2/Pnom;
RL(1)=RLchoke(1)*Pbase_sec;
RL(2)=RLchoke(2)*Pbase_sec/(2*pi*Fnom);

% Filter C Parameters
Qc=0.1*Pnom;     % Capacitive reactive power (var)
Pc=Qc/50;        % Active power (W)      

% DC link energy for 3/4 cycle of Pnom
Ceq= 3/4 * (Pnom/Fnom*2/Vnom_dc^2);
Clink=Ceq*2;    % Cp & Cn (F)

% IGBT Bridge parameters

Rs=1e6;          % IGBT Snubber (Ohm)
Cs=inf;          % IGBT snubber (F)
Ron=1e-3;        % IGBT conduction resistance
Vf=0;            % IGBT Forward voltage
Vfd=0;           % Diode Forward voltage

% *****************************************************************
%                    CONTROL PARAMETERS
% *****************************************************************

% MPPT Control (Perturb & Observe Algorithm)

Increment_MPPT= 0.01;     % Increment value used to increase/decrease Vdc_ref
Limits_MPPT= [ 850 550 ]; % Upper & Lower limit for Vdc_ref (V)

% VDC regulator (VDCreg)

Kp_VDCreg=2;           % Proportional gain
Ki_VDCreg= 400;        % Integral gain
LimitU_VDCreg= 1.5;    % Output (Idref) Upper limit (pu)
LimitL_VDCreg= -1.5;   % Output (Idref) Lower limit (pu)
%
% Current regulator (Ireg)

RLff(1)= W1_xfo(2) + W2_xfo(2) + RLchoke(1); % Feedforward values
RLff(2)= W1_xfo(3) + W2_xfo(3) + RLchoke(2); % Feedforward values

Kp_Ireg= 0.3;          % Proportional gain
Ki_Ireg= 20;           % Integral gain
LimitU_Ireg= 1.5;      % Output (Vdq_conv) Upper limit (pu)
LimitL_Ireg= -1.5;     % Output (Vdq_conv) Lower limit (pu)

% PWM Modulator Parameters 

Fc= 33 * Fnom ; % Carrier frequency (Hz)

% *****************************************************************
%                    BATTERY PARAMETERS
% *****************************************************************

% Super Capacitor

SuperCapVoltage=[ 725 700 685 675 ];

% Battery Current

BatCurrent=200;