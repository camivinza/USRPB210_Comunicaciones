
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
t = linspace(0, tiempo, length(moduladora)); % Vector de tiempo
%Fs_moduladora = fc*2+1;

% Señal portadora
portadora = Apor * sin(2 * pi * fc * t);

% Modulación AM
disp("Multiplicando moduladora * portadora...")
senal_modulada = ammod(moduladora, fc, Fs_moduladora, 0, Apor);  % Specify fm for DSB-SC


% Demodulación de la señal
% Demodulación de la señal utilizando amdemod
%Fs_moduladora = fc;
%senal_demodulada = (senal_modulada - portadora) / Apor;

senal_demodulada = amdemod(senal_modulada,fc,Fs_moduladora,0,Apor);


% Definir las características del filtro pasabajos
Fcorte = 5000; % Frecuencia de corte del filtro en Hz
orden = 6; % Orden del filtro (puedes ajustar este valor según sea necesario)

% Diseñar el filtro pasabajos
filtro_pasabajos = designfilt('lowpassfir', 'FilterOrder', orden, 'CutoffFrequency', Fcorte, 'SampleRate', Fs_moduladora);

% Aplicar el filtro a la señal demodulada
senal_demodulada_filtro = filtfilt(filtro_pasabajos, senal_demodulada);


%senal_demodulada = amdemod(senal_modulada, fc, Fs_moduladora, 0, Apor);
% Gráficos
subplot(3,2,1);
plot((1:length(moduladora))/Fs_moduladora, moduladora);
title('Señal moduladora');
xlabel('Tiempo (s)');

subplot(3,2,3);
plot(t, senal_modulada);
title('Señal modulada AM');

subplot(3,2,5);
plot(t, senal_demodulada_filtro);
title('Señal demodulada AM');

xlabel('Tiempo (s)');


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
N = length(senal_modulada);
Y = fft(senal_modulada);
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
N = length(senal_demodulada_filtro);
Y = fft(senal_demodulada_filtro);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs_moduladora*(0:(N/2))/N;

% Gráficos
subplot(3,2,6);
plot(f, P1);
title('Espectro demodulada');
xlabel('Frecuencia (Hz)');


