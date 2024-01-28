function letrasBlancas=extraer_letras(imGrey)
%letrasBlancas es una matriz de 25x25x27 con 27 imagenes de letras blancas
%(grises claras) sobre fondo negro (grises oscuros), de tamaño 25x25 cada
%una. En (:,:,1) esta la A, en (:,:,2) la B, y asi hasta la Z en (:,:,27).

%extraemos parte de la imagen con las letras
imLetras=imGrey(80:720,900:970);

%las pasamos a blanco-negro con un threshold a ojo
imLetrasThres=imLetras>204;

%hay 27 letras. Queremos extraer cada letra como un cuadradito de 20x20 o 
%25x25 aprox. Para eso, necesitamos la posicion de su centro de masa: el de 
%las 27 regiones negras (con valor 0) de mayor masa:
nletras=27;
blobs=iblobs(imLetrasThres); %armamos la struct con los blobs
blobs=blobs(blobs.class==0); %eliminamos regiones blancas
[~,ord]=sort(blobs.area,'descend');
blobs=blobs(ord);
blobs=blobs(1:nletras); %me quedo con las 27 areas mas grandes (quedaban
                        %28, la restante era el moño de la ñ)

[~,ord]=sort(blobs.vc,'ascend'); %ordeno las letras de la A a la Z, segun 
blobs=blobs(ord);                %su posicion vertical
                        
h=12; h2=h*2+1; %preparo los recuadros de 25x25. Mejor no usar los umax,
                %umin porque son de distintos tamaños y sobre todo por la ñ
letras=zeros(h2,h2,nletras);
for i=1:nletras
    u0=round(blobs(i).uc);
    v0=round(blobs(i).vc);
    letras(:,:,i)=imLetras(v0-h:v0+h,u0-h:u0+h);
    %figure,idisp(letras(:,:,i)); %por si se quiere ver, es divertido
end

%sacamos el negativo de las imagenes de las letras
letrasBlancas = 255-letras; %son 'claras' mas que 'blancas'