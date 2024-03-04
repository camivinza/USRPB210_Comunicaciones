[moduladora, Fs_moduladora] = audioread('audio2seg.wav');
disp("Length_moduladora: "+length(moduladora));
disp("Fs_moduladora: "+Fs_moduladora);

% Parámetros de la señal portadora
m = 0.5; %Indice de modulacion
fc = 90000000; % Frecuencia de la portadora en Hz
Fs_moduladora = fc*3;
Apor = (max(abs(moduladora)))/m; %Amplitud de la senal portadora
tiempo = length(moduladora) / Fs_moduladora; % Duración en segundos
disp("Tiempo: "+tiempo);
%Fs_moduladora = fc*2+1;


% Set the sample rate
fs = Fs_moduladora; 
%t = (0:2*fs+1)'/fs;
t = linspace(0, tiempo, length(moduladora)); % Vector de tiempo

% Create a sinusoidal input signal
x = moduladora;

% Set the carrier frequency and phase deviation

phasedev = pi/2;

% Modulate the input signal
tx = pmmod(x, fc, fs, phasedev);

% Pass the signal through an AWGN channel
rx = awgn(tx, 100, 'measured');

% Demodulate the noisy signal
y = pmdemod(rx, fc, fs, phasedev);

subplot(3,2,1);
plot((1:length(moduladora))/Fs_moduladora, moduladora);
title('Señal moduladora');
xlabel('Tiempo (s)');

subplot(3,2,3);
plot(t, tx);
title('Señal modulada PM');

subplot(3,2,5);
plot(t, y);
title('Señal demodulada PM');

% Calcular la Transformada de Fourier de la señal moduladora
N = length(moduladora);
Y = fft(moduladora);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs_moduladora*(0:(N/2))/N;

% Gráficos
subplot(3,2,2);
plot(f, P1);
title('Espectro moduladora');
xlabel('Frecuencia (Hz)');


% Calcular la Transformada de Fourier de la señal modulada
N = length(tx);
Y = fft(tx);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs_moduladora*(0:(N/2))/N;

% Gráficos
subplot(3,2,4);
plot(f, P1);
title('Espectro modulada');
xlabel('Frecuencia (Hz)');


% Calcular la Transformada de Fourier de la señal demodulada
N = length(y);
Y = fft(y);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs_moduladora*(0:(N/2))/N;

% Gráficos
subplot(3,2,6);
plot(f, P1);
title('Espectro demodulada');
xlabel('Frecuencia (Hz)');


