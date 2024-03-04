% Parámetros de la modulación ASK
fc = 10;    % Frecuencia de la portadora en Hz
fs = 100;   % Frecuencia de muestreo en Hz
Tb = 1;     % Duración de bit en segundos

% Generación de la señal cuadrada
t1 = 0:1:2*fs; % Vector de tiempo para la señal cuadrada
square_signal = square(2*pi*fc/fs*t1); % Señal cuadrada con frecuencia fc

% Generación de la señal modulada ASK
t = 0:1/fs:length(square_signal)*Tb-1/fs;

portadora = cos(2*pi*fc*t);  % Señal portadora

ask_signal = zeros(1, length(t));
for i = 1:length(square_signal)
    if square_signal(i) == 1
        ask_signal((i-1)*fs*Tb+1:i*fs*Tb) = portadora((i-1)*fs*Tb+1:i*fs*Tb);
    end
end

% Señal Original (Señal Cuadrada)
subplot(3,2,[1,2])
plot(t1, square_signal, 'b', 'LineWidth', 2);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal Cuadrada');

% Visualización de la señal modulada ASK
subplot(3,2,3)
plot(t, ask_signal,'g');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal modulada ASK');

% Calcular la Transformada de Fourier de la señal demodulada
N = length(ask_signal);
Y = fft(ask_signal);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(N/2))/N;

% Gráficos
subplot(3,2,4);
plot(f, P1,'g');
title('Espectro señal modulada en ASK');
xlabel('Frecuencia (Hz)');

%% DEMODULACIÓN

% Demodulación de la señal ASK

% Multiplicar la señal modulada ASK por la señal portadora original
demod_signal = ask_signal .* portadora;

% Aplicar un filtro pasa bajo para eliminar la frecuencia de la portadora
filtro_pasabajo = fir1(50, 0.1); % Filtro FIR pasa bajo de orden 50
demod_signal_filtered = filter(filtro_pasabajo, 1, demod_signal);

% Muestrear la señal filtrada en los momentos en que deberían haber estado los bits originales
demod_samples = demod_signal_filtered((Tb/2*fs):Tb*fs:end);

% Decidir sobre un umbral y decodificar los bits
umbral = 0.5; % Umbral de decisión
bits_recuperados = demod_samples > umbral;

% Señal Demodulada
subplot(3,2,[5,6])
plot(t1, bits_recuperados, 'b', 'LineWidth', 2);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal demodulada ASK');
