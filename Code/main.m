%% TP Automación Industrial - Visión
% Integrantes: Capparelli, Nicolás
%              Lynch, Matthew
%              Mujica Buj, Juan Martín
%              Olivera, Marcos
%              Torres, Jorge Pedro

% Consigna:
% Deben programar un algoritmo que permita identificar la posición de una
% cadena de letras, y pintar de verde todos los cuadros que contengan las
% letras para formar esa cadena (si hay más de una posición donde se de la
% cadena, solo deberán identificar 1).
% 
% En este ejemplo, la cadena sería: ADYZXSWO
% 
% Tengan en cuenta que para evaluar el programa, la posición de las letras,
% la cadena pedida y las letras en sí, cambian.

clear,clc,close all
tic
%Hipotesis: no cambian (salvo por unos pocos pixeles) las dimensiones del
%template. Esto implica que las letras negras template estan en cuadrados
%de aprox 25x25 que no se tocan, y que estan aprox dentro de
%(v,u)=(75:750,850:1050). Se aprovecha tambien que los cuadrados negros de
%la izquierda terminan en u=800. Y se asume que la claridad de la imagen es
%fija y sale del template (o que varia pero muy poco, de forma que se
%pueden fijar algunos threshold a ojo).

%% Secuencia a buscar

secuencia = 'ADYZXSWO'     %Secuencia Original
%secuencia = 'QWSXZYLAÑ'    %Secuencia 1
%secuencia = 'DAER'         %Secuencia 2
%secuencia = 'QXYA'         %Secuencia 3

fprintf('Por favor esperar mientras el programa se ejecuta... \n')
fprintf('\nSe analiza la imagen BASE 2.jpg\n');
%% Imágenes de prueba
% En la carpeta '/testImages' ademas de la imagen base, se generan la
% cantidad de pruebas que se indiquen 

cantidadImagenesDePrueba = 2;
fprintf('Se generaron %d Imágenes de prueba aleatorias adicionales\n\n',cantidadImagenesDePrueba);

generarTest(cantidadImagenesDePrueba);

%% Carga de imágenes
% Inicializa variables
imgFileNames = {}; kImg = 0;

% Levanta las imagenes de '/testImages'
directorio = dir('testImages');

for kFile = 1:length(directorio)
    fileName = [directorio(kFile).name];
    
    try
        if (fileName(end-3:end) == '.jpg') | (fileName(end-3:end) == '.png')
           kImg = kImg +1;
           imgFileNames{kImg} = ['testImages/' fileName];
        end
    catch
        
    end
end

%% Resolución de ejercicios
% En cada imagen busca la misma secuencia definida previamente

for iEj = 1:kImg
   
    % Recupera la ubicación del archivo
    path = imgFileNames{iEj};
    
    % Carga la imagen
    imColor = iread(path);
    
    % Convierte a escala de grises para simplificar búsqueda
    imGrey=imono(imColor);
    
    % Genera templates a buscar
    letrasBlancas = extraer_letras(imGrey);
    
    %Obtiene los extremos de los cuadrados negros grandes, su posición
    %central y su posicion en el tablero de 7x7
    cuadrados = extraer_posiciones_cuadrados(imGrey,7,7);
    
    %Se arma una matriz de 7x7: sus valores son las letras que hay en cada
    %cuadrado, desde A (1) hasta Z (27).

    %Por ejemplo, si tuvieramos:
    % A  B  A
    % C  C  C
    % E  A  A

    % la matrizLetras seria:
    % 1 2 1
    % 3 3 3
    % 5 1 1
   
    
    mLetras = get_matriz_letras(letrasBlancas,cuadrados,imGrey,7,7);
    
    % Traduce mLetras de 1-27 a 'A'-'Z'
    mLetrasNew = [];
    
    for i = 1:(size(mLetras,1)*size(mLetras,2))

        if(mLetras(i)<15)
                mLetrasNew(i) = mLetras(i)-1+'A';
        elseif (mLetras(i)==15)
                mLetrasNew(i) = 'Ñ';
        else
               mLetrasNew(i) = mLetras(i)-2+'A';
        end

    end
    
    mLetras=reshape(char(mLetrasNew),7,7);
    
    % Identifica la secuencia
    [mSecuencia, error] = PathMatrixGenerator(secuencia,mLetras);
    
    %Color en degrade ---> Descomentar si se quiere usar
    %verde =   [zeros(max(max(mSecuencia)),1),(linspace(120,220,max(max(mSecuencia))))',zeros(max(max(mSecuencia)),1)];
    %amarillo =[(linspace(120,220,max(max(mSecuencia))))',(linspace(120,220,max(max(mSecuencia))))',zeros(max(max(mSecuencia)),1)];
    
    %Color Fijo --> Comentar si se usa degrade
    verde =    [zeros(max(max(mSecuencia)),1),ones(max(max(mSecuencia)),1)*220,zeros(max(max(mSecuencia)),1)];
    amarillo = [ones(max(max(mSecuencia)),1)*200,ones(max(max(mSecuencia)),1)*200,zeros(max(max(mSecuencia)),1)];
    
    
    aPintar=[];
    % Distingue los cuadrados a pintar
    for i=1:max(max(mSecuencia))
    [fil,col] = find(mSecuencia == i);
    aPintar = [aPintar; fil, col];
    end
    aPintar = aPintar';
    
    if (error == 0)
        res_imColor = PintarCuadrado(imColor,cuadrados,aPintar,verde,7,7);
        fprintf('%d - Secuencia COMPLETA encontrada satisfactoriamente \n',iEj);
    else
        %Si la secuencia esta incompleta, pinta de amarillo hasta donde
        %llego
        res_imColor = PintarCuadrado(imColor,cuadrados,aPintar,amarillo,7,7);
        fprintf('%d - Secuencia INCOMPLETA encontrada \n',iEj);
    end
    
    %Si no detecta nada, no pinto nada
    if (aPintar == 0)
        res_imColor=imColor;
        fprintf('%d - Secuencia NO ENCONTRADA \n',iEj);
    end
            
    % ---------------------------- Resultados ---------------------------
    % Se generan imagenes con la comparación input - output en la carpeta
    % '/outputImages'
    
    % Redefino las imágenes de entra y salida para claridad
    input = imColor;
    output = res_imColor;
    
    % Formato y proceso de path
    n = length('testImages/') + 1;
    imgName = imgFileNames{iEj}(n:end-4);
    outputPath = ['outputImages/RES_' imgName];
    
    % Genero la figura con el tamaño adecuado y títulos
    figure;
    Position =  [121.8000 96.2000 1.3672e+03 649.6000];
    set(gcf,'position',Position);
    
    txtTitle = ['Imagen: ' imgName ' --- Secuencia: ' secuencia];
    suptitle([txtTitle ' '])

    subplot(1,2,1); image(input); axis auto; xlim([0,800]);  ylim([0,800]); title('Input');
    subplot(1,2,2); image(output); axis auto; xlim([0,800]); ylim([0,800]); title('Output');
    
    % Guarda la figura como un png (corre en Matlab 2019 en adelante)
    print(gcf, '-dpng', outputPath);
    
    pause(1); % Pausa de 1s para visualizar y guardar correctamente
    
    close all;
    
end

fprintf('\nEjecución de programa completado \n');
toc