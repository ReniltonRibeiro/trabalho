%{
O c�digo a seguir efetua a leitura dos arquivos com os dados da simula��o, e atribui tens�o e corrente a vetores diferentes, para facilidade de manipula��o.
A simula��o foi feita a partir de N = 26, e portanto para a faixa 1mA < Id < 4,4A, com 4400 pontos.
%}

d1 = dlmread('RFN5BGE2S.txt', '', 1, 0);
vd1 = d1(:, 2);
id1 = d1(:, 1);

d2 = dlmread('RR601BGE4S.txt', '', 1, 0);
vd2 = d2(:, 2);
id2 = d2(:, 1);

%{
Como sugerido pelo enunciado, reescreve-se a equa��o do modelo exponencial de modo a relacionar ln(Id) a Vd ( Id = Is*e^(Vd/nVt) -> ln(Id) = ln(Is)+(Vd/nVt) ).
A partir dessa premissa, a primeira linha aplica ln aos elementos do vetor de correntes, a segunda aplica m�nimos quadrados � rela��o ln(Id) x Vd e armazena os coeficientes resultantes.
%} 

ln_id1 = log(id1);
coeficients_least_squares_ln_id1 = polyfit(vd1, ln_id1, 1);

ln_id2 = log(id2);
coeficients_least_squares_ln_id2 = polyfit(vd2, ln_id2, 1);

%{
O c�digo a seguir usa os coeficientes para calcular ordenadas normalizadas para cada tens�o, e plota a rela��o ln(Id) x Vd em justaposi��o a sua equivalente normalizada, com as devidas legendas; de modo a ilustrar a manipula��o.
%}

least_squares_ln_id1 = polyval(coeficients_least_squares_ln_id1, vd1);
subplot(2, 1, 1);
plot(vd1, ln_id1, 'r', vd1, least_squares_ln_id1, 'b');
legend('Antes do MMQ', 'Depois do MMQ', 'location', 'southeast');
title('D1');
xlabel('Tens�o (V)');
ylabel('Corrente (ln(A))');

least_squares_ln_id2 = polyval(coeficients_least_squares_ln_id2, vd2);
subplot(2, 1, 2);
plot(vd2, ln_id2, 'r', vd2, least_squares_ln_id2, 'b');
legend('Antes do MMQ', 'Depois do MMQ', 'location', 'southeast');
title('D2');
xlabel('Tens�o (V)');
ylabel('Corrente (ln(A))');

%{
Comparando a equa��o do modelo exponencial modificada � equa��o de polin�mio de 1o grau (y = ax + b), observa-se que h� uma rela��o entre os coeficientes e os valores requisitados, Is e n (a = 1/nVt, b = ln(Is)).
O c�digo a seguir obt�m tais valores, utilizando o Vt sugerido no enunciado (Vt = 26mV), os coeficientes coletados com polyfit e aplicando fun��o inversa �s rela��es. Is � multiplicado por 10^9 para que seu valor seja expressado em nA.
%}

isd1 = exp(coeficients_least_squares_ln_id1(2)) * 10^9;
nd1 = 1 / (coeficients_least_squares_ln_id1(1) * 0.026);

isd2 = exp(coeficients_least_squares_ln_id2(2)) * 10^9;
nd2 = 1 / (coeficients_least_squares_ln_id2(1) * 0.026);

%{
Por fim, os valores de Is e n s�o impressos no console.
%}

printf('D1:\n');
printf('Is = %.2fnA\n', isd1);
printf('n = %.2f\n', nd1);
printf('\n');
printf('D2:\n');
printf('Is = %.2fnA\n', isd2);
printf('n = %.2f\n', nd2);