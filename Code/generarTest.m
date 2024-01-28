function generarTest(nImg)
% Genera nImg de prueba aleatorias para el programa
% Solo extrae la imagen base y no las posiciones de las letras/cuadrados

    for iImg = 1:nImg

        [imBase,~,~] = generar_imagen();

        fileName = ['testImages/testImage' num2str(iImg) '.jpg'];

        imwrite(imBase, fileName);

    end
    
end