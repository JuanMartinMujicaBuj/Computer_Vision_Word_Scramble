function [imBase,letrasBlancas,cuadrados]=generar_imagen()
%imBase es la imagen tipo BASE 2. Es una imagen a color

%letrasBlancas es una matriz de 25x25x27, son 27 recuadros cada uno con una
%letra en blanco (grises claros) sobre fondo negro (grises oscuros). Son 27
%imagenes en escala de grises. En (:,:,1) esta la A, en (:,:,2) la B, y asi
%hasta la Z en (:,:,27).

%cuadrados es una struct que tiene 49 valores de umin, umax, vmin, vmax:
%son los extremos de cada cuadrado negro que contiene letras y que es
%candidato a ser pintado.

%La funcion generar_imagen toma el 'template fondo', extrae las letras
%Templates, las hace blancas y las pega en posiciones random de los
%cuadrados negros.

%Cuestion muy secundaria pero a mejorar: la posicion de las letras en el
%cuadrado es mas o menos aleatoria, pero sigue cierta tendencia. Los
%cuadrados de abajo tienen las letras mas tiradas para abajo, los de arriba
%para arriba, los de los costados, para los costados.

%Abrimos la imagen template
imColor=iread('sources\template fondo.jpg');

%La pasamos a greyscale
imGrey=imono(imColor);

%extraemos las letras template
letrasBlancas = extraer_letras(imGrey);

nletras=27; %cantidad de letras
h=12; %semi longitud de la imagen de las letras
h2=2*h+1; %longitud de la imagen de las letras

%ahora queremos pegarlas en la cuadricula negra, en una posicion random,
%una letra blanca random por cuadrado (sin contar los de los bordes).

%operamos de forma similar a la anterior para extraer los cuadrados negros
%con: sus extremos, su centroide, y de paso su posicion en el tablero
cuadrados=extraer_posiciones_cuadrados(imGrey,7,7);

nCuadrados=49; %cantidad de cuadrados (7x7)

%finalmente, ubicamos las letras en los cuadrados de forma aleatoria: letra
%aleatoria, en posicion aleatoria, dentro de un cuadrado aleatorio.
%como las letras son de 25x25=h2xh2, quiero ubicar su extremo inferior
%izquierdo entre (umin,vmin) y (umax-h2,vmax-h2)
imBase=imColor;
for iCuadrado=1:nCuadrados
    iLetra=randi([1 nletras]);
    letra=icolor(letrasBlancas(:,:,iLetra));
    umin=cuadrados.umin(iCuadrado);
    umax=cuadrados.umax(iCuadrado);
    vmin=cuadrados.vmin(iCuadrado);
    vmax=cuadrados.vmax(iCuadrado);
    ran=normrnd(0.5,0.1,1,2); ran(ran<0)=0; ran(ran>1)=1;
    uv=[umin,vmin]+ran.*[(umax-h2)-umin, (vmax-h2)-vmin];
    u0=round(uv(1)); v0=round(uv(2));
    
    imBase(v0:v0+h2-1,u0:u0+h2-1,:) = letra;
end
% idisp(imBase);
