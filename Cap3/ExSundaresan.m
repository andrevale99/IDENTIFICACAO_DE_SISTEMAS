% Script de apoio aa aplicacao do metodo de Sundaresan et al (1978)
% aos dados bfg3.dat
%
% LAA 07/04/2020

clear
close all

% carrega dados
load bfg3.dat
t=bfg3(:,1);
U=bfg3(:,2);
Y=bfg3(:,3);
clear bfg3

figure(1)
subplot(211)
plot(t,U,'k');
set(gca,'FontSize',16)
axis([0 t(end) 3.0 3.8])
ylabel('entrada (volts)')

subplot(212)
plot(t,Y,'k');
set(gca,'FontSize',16)
axis([0 t(end) 1.6 2.6])
xlabel('t (s)')
ylabel('saida (volts)')


% print -djpeg bfg3.jpg

% ajustar os dados, consideraremos que a entrada inicia em 2,5 s
% que eh o 6o elemento de t. Alem disso, o metodo supoe que o valor
% da saida em estado estacionario eh um. Devemos encontrar o fator de 
% ajuste para corrigir isso, que serah o inverso da excursao da saida.

% variacao de saida
Delta_Y=mean(Y(end-15:end))-mean(Y(1:6));
% variacao da entrada
Delta_U=mean(U(end-15:end))-mean(U(1:6));
tt=t(6:end)-t(6);
% ganho
K=Delta_Y/Delta_U;


% fazendo todos os ajuste, lembrando de retirar o offset tem-se
u=(U(6:end)-mean(U(1:6)))/Delta_Y;
y=(Y(6:end)-mean(Y(1:6)))/Delta_Y;


figure(2)
subplot(211)
plot(tt,u,'k');
set(gca,'FontSize',16)
axis([0 tt(end) 0 1.2])
ylabel('entrada (volts)')

subplot(212)
plot(tt,y,'k');
set(gca,'FontSize',16)
axis([0 tt(end) 0 1.5])
xlabel('t (s)')
ylabel('saida (volts)')


% print -djpeg bfg3a.jpg


% para fins de calculos graficos, faremos uma nova figura da resposta ao
% degrau

figure(3)
plot(tt(1:61),y(1:61),'k');
set(gca,'FontSize',16)
axis([0 tt(61) 0 1.5])
xlabel('t (s)')
ylabel('saida (volts)')
grid

% print -djpeg bfg3a_zoom.jpg


%%
% area m1
m1=2.5+(11.5-2.5)/2
% inclinacao Mi
Mi=1/8.5
tm=10;
lambda=(tm-m1)*Mi


% 
Eta=0.02:0.001:0.95;
Chi=log(Eta)./(Eta-1); % Eq. 3.17 do livro
Lambda=Chi.*exp(-Chi); % Eq. 3.16 do livro

figure(4)
plot(Lambda,Eta,'k',[lambda lambda],[0 1],'b')
set(gca,'FontSize',16)
xlabel('\lambda')
ylabel('\eta')


% print -djpeg eta_lambda.jpg

% valor de eta obtido graficamente
eta=0.56;

% Calculando os parametros usando Eqs. 3.18
tau1=(eta^(eta/(1-eta)))/Mi
tau2=(eta^(1/(1-eta)))/Mi
taud=m1-tau1-tau2

sys=tf(K,conv([tau1 1],[tau2 1]));
ym=lsim(sys,ones(length(tt),1)*Delta_U,tt)/Delta_Y;

figure(5)
plot(tt,y,'k',tt+taud,ym);
set(gca,'FontSize',16)
axis([0 tt(end) 0 1.2])
xlabel('t (s)')
ylabel('saida (volts)')
grid
%%

% print -djpeg modelo.jpg

% Ajuste
taud=3*taud
tau2=m1-tau1-taud

sys=tf(K,conv([tau1 1],[tau2 1]));
ym=lsim(sys,ones(length(tt),1)*Delta_U,tt)/Delta_Y;

figure(6)
plot(tt,y,'k',tt+taud,ym);
set(gca,'FontSize',16)
axis([0 tt(end) 0 1.2])
xlabel('t (s)')
ylabel('saida (volts)')
grid

% print -djpeg modelo_ajustado.jpg
