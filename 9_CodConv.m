% Parámetros de la señal
fc = 5; % Frecuencia de la portadora en Hz
fs = 100; % Frecuencia de muestreo en Hz
T = 1/fs; % Periodo de muestreo
t = 0:T:1-T; % Vector de tiempo

%Codigos convolucionales parametros
constraintLength = 3; % Longitud de la restricción del código
codeGenerator = [5, 7]; % Polinomio generador en forma octal
% Crear el objeto trellis
trellis = poly2trellis(constraintLength, codeGenerator);

% Datos de entrada (0's y 1's)
data = randi([0,1], 1, length(t));

encodedBits = convenc(data, trellis);
ten = 0:T:(length(encodedBits)-1)*T; % Vector de tiempo
% Modulación BPSK
carrier = cos(2*pi*fc*ten); % Señal portadora
modData = (2*encodedBits-1) .* carrier; % Señal modulada BPSK

% Demodulación BPSK
received_signal = modData .* carrier; % Señal recibida
received_bits = received_signal > 0; % Decisión: 1 si la señal recibida es positiva, 0 si es negativa

decodedBits = vitdec(received_bits, trellis, constraintLength - 1, 'trunc', 'hard');

% Gráficos
subplot(3,2,1);
plot(t, data, 'b', 'LineWidth', 2);
title('Datos de entrada (bits)');
xlabel('Tiempo (s)');
ylabel('Amplitud');
ylim([-0.5 1.5]);
grid on;

subplot(3,2,2);
plot(ten, encodedBits, 'b', 'LineWidth', 2);
title('Señal Codificada Codigos Convolucionales');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;

subplot(3,2,[3,4]);
plot(ten, modData, 'r', 'LineWidth', 2);
hold on;
plot(ten, carrier, 'g', 'LineWidth', 2);
title('Trasmision de la señal mod BPSK');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;

subplot(3,2,5);
plot(ten, received_bits, 'b', 'LineWidth', 2);
title('Señal Demodulada ');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;

subplot(3,2,6);
plot(t, decodedBits, 'b', 'LineWidth', 2);
title('Señal decodificada');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;