function cuadrados=extraer_posiciones_cuadrados(imGrey,columnasGrilla,filasGrilla)
%queremos obtener: posicion central y posiciones extremas de los N
%cuadrados grandes negros que hay en el tablero (filasGrilla x columnasGrilla). Y queremos tambien su
%posicion en el tablero de columnasGrilla x filasGrilla.

%cuadrados es una struct que tiene: umin, umax, vmin, vmax (extremos del
%cuadrado). uc, vc (centroide). fil, col (posicion del 1 al 7 en el tablero).

%de la imagen completa, extraemos la zona del tablero
imCuadrados=imGrey(:,1:800);
imCuadradosThres=imCuadrados>125; %elegimos threshold a ojo
blobs=iblobs(imCuadradosThres);

%Con iblobs(), tomamos los dominios que nos interesan y los valores que nos
%interesan
nCuadrados=columnasGrilla*filasGrilla;
blobs=blobs(blobs.class==0); %eliminamos regiones blancas
[~,ord]=sort(blobs.area,'descend');
blobs=blobs(ord);
blobs=blobs(1:nCuadrados); %nos quedamos con las areas mas grandes (dejo de lado los rectangulos de los costados)

cuadrados.uc=round(blobs.uc); %guardamos sus centroides
cuadrados.vc=round(blobs.vc);
cuadrados.umax=blobs.umax; %guardamos sus limites.
cuadrados.umin=blobs.umin;
cuadrados.vmax=blobs.vmax;
cuadrados.vmin=blobs.vmin;

%calculamos su posicion en el tablero (dejamos cierta tolerancia por si los
%centroides no estuvieran perfectamente alineados)
u=unique(round(cuadrados.uc/20)*20);
v=unique(round(cuadrados.vc/20)*20);
for i=1:nCuadrados
    cuadrados.fil(i)=find(round(cuadrados.uc(i)/20)*20==u);
    cuadrados.col(i)=find(round(cuadrados.vc(i)/20)*20==v);
end
