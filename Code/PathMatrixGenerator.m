function [FinalPath,secuenciaNoEncontrada] = PathMatrixGenerator(secuencia,M)
%%% Genera un camino dentro de una matriz M de letras determinado por la secuencia
%%% input. el camino se genera a partir de letras adyacentes (4 direcciones)
%%% secuencia: array de letras a buscar
%%% M: Matriz de las letras en la grilla
%%%FinalPath: Matriz con numeros de 1 al largo de la secuencia en la
%%%posicion en la que se encuentra la secuencia.
%%%secuenciaNoEncontrada: indicador de que la secuencia pedida no esta en
%%%la matriz proveida.


%%% Funcionamiento: Ubica todas las posiciones de la primera letra de la secuencia y las guarda en distintas matrices. 
%%% Para la segunda letra, toma todas estas matrices y se fija, en cada una, si cada
%%% posicion cumple las siguientes condiciones: 
%%% 1) En la matriz original está la segunda letra.
%%% 2) Esta posición esta desocupada
%%% 3) en una posicion adyacente esta la primera letra.
%%% Si se cumplen estas tres condiciones, guardo una nueva matriz con la
%%% posición de la primera letra y la posicion de la segunda letra.
%%% Se repite para todas las letras en la secuencia.
%%% De esta forma se genera una matriz con cada opcion posible, para cada letra en la secuencia.
%%% Ej: la secuencia "ABC" guarda todas las posiciones de A (con un 1 en cada matriz), todas las
%%% posiciones de la secuencia valida "AB" (con un 1 en la matriz en las 
%%% posiciones donde esta la A y un 2 en la posicion donde esta la B) y todas las posiciones de la
%%% secuencia valida "ABC" (con un 1, 2 y 3 en las respectivas posiciones).
%%% Si no se encuentra la secuencia pedida, lo detecta y manda un aviso de secuencia no encontrada.


secuencia = convertStringsToChars(secuencia); %Convierto a array de chars para manipulación


Path = zeros(size(M,1),size(M,2),1); %Serie de matrices donde guardo todas las matrices de todos los pasos.

l=1;
for k=1:length(secuencia) % Para cada letra en la secuencia
    lTot=size(Path,3); % Tomo todas las matrices de secuencia hasta la letra anterior
    
    for i=1:size(M,1)
        for j=1:size(M,2)
            if(k == 1) % Primera letras, solo chequeo si está la letra
                if(M(i,j) == secuencia(k))
                    Path(i,j,l)=k;
                    l = l+1;
                end
            else
                
                for l=1:lTot
                    
                    layer = size(Path,3)+1; %para generar una nueva matriz. (layer = en que matriz estoy)
                    
                    % Chequeos: 9 casos(4 esquinas, 4 bordes, interior)

                    if(i == 1) %borde arriba
                        if(j == 1) %esquina arriba izq
                            if((M(i,j) == secuencia(k)) && (Path(i,j,l)==0) && ((Path(i+1,j,l)== k-1) || (Path(i,j+1,l)== k-1)))
                                Path(:,:,layer) = Path(:,:,l);
                                Path(i,j,layer) = k;
                            end


                        elseif(j == size(Path,2))%esquina arriba der
                            if((M(i,j) == secuencia(k)) && (Path(i,j,l)==0) && ((Path(i,j-1,l)== k-1) || (Path(i+1,j,l)== k-1)))
                                Path(:,:,layer) = Path(:,:,l);
                                Path(i,j,layer) = k;
                            end


                        else %borde arriba sin esquina
                            if((M(i,j) == secuencia(k)) && (Path(i,j,l)==0) && ((Path(i,j-1,l)== k-1) || (Path(i+1,j,l)== k-1) || (Path(i,j+1,l)== k-1))) 
                                Path(:,:,layer) = Path(:,:,l);
                                Path(i,j,layer) = k;
                            end
                        end

                     elseif(i == size(Path,1))%borde abajo
                         if(j == 1) %esquina abajo izq
                            if((M(i,j) == secuencia(k)) && (Path(i,j,l)==0) && ((Path(i-1,j,l)== k-1) || (Path(i,j+1,l)== k-1)))
                                Path(:,:,layer) = Path(:,:,l);
                                Path(i,j,layer) = k;
                            end
                        elseif(j == size(Path,2))%esquina abajo der
                            if((M(i,j) == secuencia(k)) && (Path(i,j,l)==0) && ((Path(i-1,j,l)== k-1) || (Path(i,j-1,l)== k-1)))
                                Path(:,:,layer) = Path(:,:,l);
                                Path(i,j,layer) = k;
                            end
                        else %borde abajo sin esquina
                        if((M(i,j) == secuencia(k)) && (Path(i,j,l)==0) && ((Path(i-1,j,l)== k-1) ||(Path(i,j-1,l)== k-1) || (Path(i,j+1,l)== k-1)))
                            Path(:,:,layer) = Path(:,:,l);
                            Path(i,j,layer) = k;
                         end


                         end
                    elseif(j == 1) %borde der
                        if((M(i,j) == secuencia(k)) && (Path(i,j,l)==0) && ((Path(i-1,j,l)== k-1) || (Path(i+1,j,l)== k-1) || (Path(i,j+1,l)== k-1)))
                            Path(:,:,layer) = Path(:,:,l);
                            Path(i,j,layer) = k;
                         end


                    elseif(j == size(Path,2)) %borde izq
                        if((M(i,j) == secuencia(k)) && (Path(i,j,l)==0) && ((Path(i-1,j,l)== k-1) || (Path(i,j-1,l)== k-1) || (Path(i+1,j,l)== k-1)))
                            Path(:,:,layer) = Path(:,:,l);
                            Path(i,j,layer) = k;
                         end



                    else %interior
                         if((M(i,j) == secuencia(k)) && (Path(i,j,l)==0) && ((Path(i-1,j,l)== k-1) || (Path(i,j-1,l)== k-1) || (Path(i+1,j,l)== k-1) || (Path(i,j+1,l)== k-1)))
                            Path(:,:,layer) = Path(:,:,l);
                            Path(i,j,layer) = k;
                         end
                    end
                    
                end
            end
        end
    end
    l=1;
end

%Chequeo de si encontró la secuencia completa -> si el numero de letras que
%encontró es igual al tamaño de la secuencia

secuenciaNoEncontrada = 0;
if(max(max(Path(:,:,end)))<length(secuencia))
   secuenciaNoEncontrada = 1; 
end
    
    
%Devuelvo la última matriz, que si encontró la secuencia completa es una solucion valida a la secuencia entera    
FinalPath = Path(:,:,end);
end