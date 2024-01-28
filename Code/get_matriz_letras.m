function matrizLetras = get_matriz_letras(letrasBlancas,cuadrados,imGrey,columnasGrilla,filasGrilla)
%(tarda aprox 105seg en correr. Dependera de la maquina de cada uno).
%armamos una matriz de filasGrilla x columnasGrilla: sus valores son las letras que hay en cada
%cuadrado, desde A (1) hasta Z (27).

%Por ejemplo, si tuvieramos:
% A  B  A
% C  C  C
% E  A  A

% la matrizLetras seria:
% 1 2 1
% 3 3 3
% 5 1 1

%iteramos en los cuadrados y en las letras. Para cada cuadrado, vemos si 
%coincide con algun template, y guardamos el valor de esa letra en la
%posicion que corresponda.

%Para acelerar el proceso, elegimos un threshold por prueba y error que
%solo cumpla la letra correcta. Asi, cuando encontramos la letra indicada,
%nos ahorramos el comparar el template de las demas letras.

%Resulta muy importante elegir el threshold correcto para el isimilarity(),
%para que detecte la letra pero no mezcle N con Ñ, O con Q, etc.

%Otra alternativa mas lenta pero mas robusta/confiable es comparar cada
%cuadrado con el template de todas las letras y quedarnos con el que tiene
%mayor similitud. Pero confiando en la calidad de los match, se elige la
%primera opcion.


nCuadrados=columnasGrilla*filasGrilla;
nLetras=27;
matrizLetras=zeros(filasGrilla,columnasGrilla);
sthres = 0.97; %threshold que indica si hay una coincidencia. fijado a ojo.

for i=1:nCuadrados
    cuad=imGrey(cuadrados.umin(i):cuadrados.umax(i),cuadrados.vmin(i):cuadrados.vmax(i)); %tomamos un cuadrado
    fil=cuadrados.fil(i); col=cuadrados.col(i); %tomamos su posicion en la matriz/el tablero
    for iletra=1:nLetras
        if matrizLetras(fil,col)==0 %iteramos en las letras hasta hallar la adecuada
            letra=letrasBlancas(:,:,iletra); %tomamos el template de una letra

            %vemos si algun conjunto de pixeles de mi cuadrado coincide con
            %el template de la letra. Por defecto parece que usa zncc, que
            %va de -1 (sin coincidencia) a 1 (coincidencia perfecta). La
            %funcion @zncc parece que se queja si entiende que mezclamos
            %ints con doubles, asi que pasamos todo a doubles (pero doubles
            %de 0 a 255, NO de 0 a 1).
            S=isimilarity(double(letra),double(cuad));
            [mx,~]=peak2(S,1,'npeaks',1); %extraemos el valor mas alto de S (quiza tambien anduviera con un max(max(S)) )
            if mx(1)>sthres
                %si supera el threshold, guardamos el valor de la letra en
                %matrizLetras, en la posicion de ese cuadrado
                matrizLetras(fil,col)=iletra;
            end
        end
    end
end