clc
clear all
close all

[y, Fs] = audioread('audio2seg.wav'); %the audio signal is stored in the array y and sampled at a sampling rate of Fs
max_value = max(y); %maximum value of the audio sample
min_value = min(y); %medium value of the audio sample
l=8;
x = []; %array to store the step values
step_size = (max_value - min_value)/(l); %calculating the step size
disp(step_size);
i = min_value;

while ((i>=min_value) & (i<=max_value)) %calculating the step values
x = [x,i];
i = i + step_size;
end

for i=1:length(y) %quantization
for j=1:(length(x)-1)
if((y(i)>=x(j))&& (y(i)<=x(j+1))) %checking the range in which each data in y lies
y1(i) = x(j+1); %quantized sample
end
end
end


y2 = zeros(1,length(y1)); % contains the encoded signal
for i = 2:length(x)
for j = 1:length(y1)
if(x(i)==y1(j))
y2(j) = i-2;
end
end
end

qam = qammod(y2,l,'PlotConstellation',true);

t = linspace(0, length(y)/Fs, length(y)); % Vector de tiempo en segundos

demodulated = qamdemod(qam,l)

figure(1)
subplot(3,1,1)
plot(t,y)
title('Señal Original QAM');

figure(1)
subplot(3,1,2)
plot(t,qam)
title('Modulacion QAM');
 
figure(1)
subplot(3,1,3)
plot(t,demodulated)
title('Demodulacion QAM');

% Gráfico de la constelación QAM
scatterplot(qam);
title('Constelación QAM');