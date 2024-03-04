% Parámetros de la señal OFDM
numCarriers = 64;           % Número de subportadoras OFDM
cpLength = 16;              % Longitud del prefijo cíclico
numSymbols = 10;            % Número de símbolos OFDM a transmitir

B = 1000;
T = 1/B;
fs = numCarriers / T;

% Generación de datos aleatorios
data = randi([0, 1], numCarriers, numSymbols);  % Datos binarios
%data = [1; 0; 1; 0; 1; 0; 1]; % Señal binaria deseada

disp(data);
% Modulación OFDM
[ofdmSignal, ifftSignal] = ofdm_modulation(data, numCarriers, cpLength);

% Canal de comunicación (aquí se simula el efecto del canal)
channelSignal = awgn(ofdmSignal, 100);  % Agregar ruido blanco gaussiano 

% Demodulación OFDM
receivedData = ofdm_demodulation(channelSignal, numCarriers, cpLength);

% Cálculo del BER (Bit Error Rate)
ber = biterr(data(:), receivedData(:)) / (numCarriers * numSymbols);

disp(['Bit Error Rate (BER): ', num2str(ber)]);

% Gráficos
figure;

% Señal original OFDM
subplot(3, 2, [1,2]);
plot(data(1:100), 'linewidth', 2);  % Graficamos la magnitud de la señal OFDM con una línea continua
title('Señal original');
xlabel('Muestras');
ylabel('Amplitud');
grid on;

% Cálculo del espectro de la señal modulada
N = length(ofdmSignal);
Y = fft(ofdmSignal);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(N/2))/N;

% Espectro modulada
subplot(3, 2, 4);
stem(f,P1,'b');
hold on;  % Mantener el gráfico actual
% Graficar el espectro discreto
plot(f, P1, 'r');
title('Espectro modulada');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');
grid on;


% Señal modulada OFDM
subplot(3, 2, 3);
plot(abs(ofdmSignal));
title('Señal Modulada OFDM');
xlabel('Muestras');
ylabel('Amplitud');
grid on;

% Rudio Gaussiano OFDM
%subplot(4, 1, 3);
%plot(abs(channelSignal));
%title('Ruidio Gaussiano');
%xlabel('Muestras');
%ylabel('Amplitud');
%grid on;


% Señal demodulada OFDM
subplot(3, 2, [5,6]);
plot(receivedData(1:100), 'linewidth',2);
title('Señal Demodulada');
xlabel('Muestras');
ylabel('Datos Recibidos');
grid on;

% Función para la modulación OFDM
function [ofdmSignal, ifftSignal] = ofdm_modulation(data, numCarriers, cpLength)
    % IFFT
    ifftSignal = ifft(data, numCarriers);
    
    % Agregar prefijo cíclico
    cp = ifftSignal(end - cpLength + 1:end, :);
    ofdmSignal = [cp; ifftSignal];
end

% Función para la demodulación OFDM
function receivedData = ofdm_demodulation(ofdmSignal, numCarriers, cpLength)
    % Eliminar prefijo cíclico
    signalWithoutCP = ofdmSignal(cpLength + 1:end, :);
    
    % FFT
    fftSignal = fft(signalWithoutCP, numCarriers);
    
    % Decisión (demodulación)
    receivedData = real(fftSignal) > 0.5;  % Umbral de decisión
end
