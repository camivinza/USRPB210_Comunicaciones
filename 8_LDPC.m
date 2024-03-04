clear
clc
%==DECODIFICACION LDPC===========
vinf=repmat([0 1 1 0 1 1],1,56);
R=80770; % velocidad de transferencia
Tsob=200;% Tasa de sobremuestreo necesario para graficar

%sobremuestreo del vector de informacion para la grafica
inf=repmat(vinf,Tsob,1);
inf=inf(:)';
%=======================================================
t=0:1/(Tsob*R):length(vinf)*(1/R)-1/(Tsob*R);%Vector de tiempo para la informacion
%==============Parametros Matriz de paridad==========
n=100*8; % # bits de codificacion
k=length(vinf);% # bits de informacion
bp=n-k;% # bits de paridad
%======================================
I=eye(bp);% creando la matriz identidad
vt=repmat(I(:,randperm(size(I,2))),1,ceil(n/size(I,1))-1);
H=[I vt(:,1:n-(size(I,1)))];% creando la matriz de paridad
%=====OBTENCION DE LA MATRIZ GENERADORA G=[Ik AT]
G=[eye(k) H(:,(bp+1):n)'];
%==========Codificacion==============
vLDPC=vinf*G;% codificacion c(codificacion)=u(informacion)*G(Matriz generadora)
vLDPC(find(vLDPC==2))=0;%Si el resultado de la multiplion de las matrices es=2 se le asigna un 0
vLDPC(find(vLDPC==0))=-1;
%========================================
%========================================

%Sobremuestreo del vector de la codificacion para la grafica
LDPC=repmat(vLDPC,Tsob,1);
LDPC=LDPC(:)';
%===========================================================

t1=0:k/(Tsob*R*n):length(vLDPC)*(k/(R*n))-k/(Tsob*R*n);%Vector de tiempo para la codificacion

%==============================================================================
%==============================================================================
%               DECODIFICACION LDPC

vdLDPC=vLDPC*G'/2;
vdLDPC(find(vdLDPC==-1))=0;

dLDPC=repmat(vdLDPC,Tsob,1);
dLDPC=dLDPC(:)';

figure(1)
subplot(2,1,1)
plot(t,inf);
% subplot(2,1,2)
hold on
plot(t1,LDPC);
axis([-(1/R) (length(vinf)+1)*(1/R) -1.1 1.1]);
grid on
xlabel("Tiempo")
title("CODIFICACION LDPC")
grid minor

figure(1)
subplot(2,1,2)
plot(t,inf);
hold on
plot(t,dLDPC);
title("DECODIFICACION LDPC")
axis([-(1/R) (length(vinf)+1)*(1/R) -0.1 1.1]);
grid on
grid minor
