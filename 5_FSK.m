%%FSK MODULATION

clear all;
close all;
clc;

warning('off','all');
warning;

%% Generacion de la señal de mensaje.

Noit=1e4;
x = randi([0 1],Noit,1);   % Señal binaria 

figure(1);
subplot(3,2,1); 
stairs(x(1:8),'Linewidth',2);      %Message signal plot 
title('Señal original'); 
ylabel('Amplitude'); 
%% Generacion de portadoras

Tb = 0.002;      % symbol duration in sec
br = 1/Tb;       % Bit rate

fs = 1000;       % Sampling Frequency

fc0 = 1000;      % Carrier frequency for binary input '0'
fc1 = 2000;  % Carrier frequency for binary input '1'

%time window, the duration between two samples is 1/(100*fs)
t1=0:1/(100*fs):Tb;

%Signal Generation Carrier Waveform
s1 = cos(2*pi*fc0*t1);
s2 = cos(2*pi*fc1*t1);

% Signal Generation for Quadrature Implementation
s3 = sin(2*pi*fc0*t1);
s4 = sin(2*pi*fc1*t1);

%% Signal Modulation
% 

mod_Signal = [];
for (i = 1:1:Noit)
    if (x(i) == 1)
        y = cos(2*pi*fc0*t1);   % Modulation signal with carrier signal 1
    else
        y = cos(2*pi*fc1*t1);   % Modulation signal with carrier signal 2
    end
    mod_Signal = [mod_Signal y];
end

% Total Signal Duration
t2 = 0:1/(100*fs):Tb*Noit;

%% Plot señal modulada
figure(1)
subplot(3,2,2); 
plot(t2(1:8*length(t1)),mod_Signal(1:8*length(t1)));
title('Señal modulada (Primeros 8 Bits)'); 
xlabel('Tiempo'); 
ylabel('Amplitud');

% Calcular la Transformada de Fourier de la señal demodulada
N = length(mod_Signal);
Y = fft(mod_Signal);
P2 = abs(Y/N);
P1 = P2(1:N/16+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(N/16))/N;

% Gráficos
subplot(3,2,[3,4]);
plot(f, P1,'g');
title('Espectro de la señal modulada FSK');
xlabel('Frecuencia (x10^2)');

%% Recepción de la señal
rx_Signal = [];

%% 
% AWGN Ruidio Guusina
%% Modulated Signals vs Signal with AWGN (8 Bits) 

step1 = length(mod_Signal)/11;
snrdB = -10;
for n1 = step1:step1:length(mod_Signal) %define SNR in terms of dB
    rx_Signal = [rx_Signal awgn(mod_Signal(n1-(step1-1):n1),snrdB)];
    snrdB = snrdB + 2;
end

%% FSK Demodulation
s = length(t1);

step = rx_Signal / s;

demod = [];
demod2 = [];
%% Correlación
for n = s:s:length(rx_Signal)
% 
  cor1 = corrcoef(sqrt(2/Tb).*s1,rx_Signal(n-(s-1):n));    
  cor2 = corrcoef(sqrt(2/Tb).*s2,rx_Signal(n-(s-1):n));
  cor3 = corrcoef(sqrt(2/Tb).*s3,rx_Signal(n-(s-1):n));
  cor4 = corrcoef(sqrt(2/Tb).*s4,rx_Signal(n-(s-1):n));
  
% Squaring and IQ EnergySummation
 
  IQ1 = cor1.^2 + cor3.^2;
  IQ2 = cor2.^2 + cor4.^2;
  
  IQ = IQ1-IQ2;
   
% Test Statistics and Decision

  if(IQ(2) > 0);
      a = 1;
  else;
     a = 0;
  end   
  
  demod2 = [demod2 a];
end

demod2 = transpose(demod2);

%% Recovered Signal Plot

figure(1);
subplot(3,2,5); 
stairs(x(1:100),'Linewidth',2);      %Message signal plot 
title('Señal Original Completa'); 
ylabel('Amplitude'); 

subplot(3,2,6); 
stairs(demod2(1:100),'Linewidth',2);      %Message signal plot 
title('Señal demodulada Completa'); 
ylabel('Amplitude'); 


