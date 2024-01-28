function [Imagen] = PintarCuadrado(Imagen,Cuadrados,pintar,color,columnasGrilla,filasGrilla)
%Funcion que pinta de un color deseado el cuadrado ingresado
%
%Variables de entrada:
%Imagen: Es mi imagen en color
%Cuadrados: struct con los datos de los cuadrados detectados
%           uc: [1—49 double]
%           vc: [1—49 double]
%           umax: [1—49 double]
%           umin: [1—49 double]
%           vmax: [1—49 double]
%           vmin: [1—49 double]
%           x: nro de columna en la grilla
%           y: numero de fila en la grilla
%pintar: vector nx2 [filas,columnas] con posicion del cuadrado que quiero pintar
%color: Vector RGB de 3x1 con el color que se quiere pintar. Los valores
%del vector deben ser entre 0 y 255.
%
%Ej: MiImagen=PintarCuadrado(MiImagen,cuadrados,[3,4]); Pinta el cuadrado
%en la fila 3 y columna 4

%Cuadrados no siempre viene ordenado, por lo que hacemos un sort para que
%me queden en orden de izquierda a derecha y de arriba a abajo

umin = sort(Cuadrados.umin);
umin = reshape(umin,filasGrilla,filasGrilla);
umin = umin(1,:);

umax = sort(Cuadrados.umax);
umax = reshape(umax,filasGrilla,filasGrilla);
umax = umax(1,:);

vmin = sort(Cuadrados.vmin);
vmin = reshape(vmin,filasGrilla,filasGrilla);
vmin = vmin(1,:);

vmax = sort(Cuadrados.vmax);
vmax = reshape(vmax,filasGrilla,filasGrilla);
vmax = vmax(1,:);


%Queremos pintar la parte negra del cuadrado solamente y no la letra.
%Entonces hacemos un barrido de pixeles para detectar si es negro o si es
%blanco y pintar solo si es negro

for i=1:size(pintar,2)                              %Iteramos cuadrados a pintar de la matriz pintar
    for x=umin(pintar(1,i)):umax(pintar(1,i))       %Hacemos un barrido de los pixeles a pintar
        for y=vmin(pintar(2,i)):vmax(pintar(2,i))
            if (Imagen(x,y,1) < 190 || Imagen(x,y,2) < 190 || Imagen(x,y,2) < 190)  %Verdadero si no estoy parado sobre la letra
                Imagen(x,y,1)=color(i,1);                  %R
                Imagen(x,y,2)=color(i,2);                  %G
                Imagen(x,y,3)=color(i,3);                  %B
            end
        end
    end
end

end