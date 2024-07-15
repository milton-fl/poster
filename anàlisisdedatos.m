% Importaci�n de Datos
data = readtable('climate_data.csv');

% Preprocesamiento de Datos
% Eliminar filas con datos faltantes
data = data(~any(ismissing(data), 2), :);

% Normalizar los datos (sin incluir la columna de fechas y patrones)
for i = 2:width(data)-1
    column = data{:, i};
    data{:, i} = (column - min(column)) / (max(column) - min(column));
end

% An�lisis Estad�stico
mean_temp = mean(data.Temperature);
std_temp = std(data.Temperature);

figure;
histogram(data.Temperature);
title('Distribuci�n de Temperatura');
xlabel('Temperatura');
ylabel('Frecuencia');

% Machine Learning
% Usando un modelo de regresi�n lineal simple
lm = fitlm(data, 'Temperature ~ Humidity + WindSpeed');

% Si fitcensemble no est� disponible, usamos un m�todo alternativo.
% Por ejemplo, k-means clustering para clasificar patrones clim�ticos
% Suponiendo que "Pattern" es una variable categ�rica con 2 clases
numClusters = 2;
idx = kmeans(data{:, {'Humidity', 'WindSpeed'}}, numClusters);
data.Pattern = categorical(idx);

% Visualizaci�n de Datos
% Crear una secuencia de fechas si no existe la columna de fechas
if ~ismember('Time', data.Properties.VariableNames)
    data.Time = (1:height(data))';
end

figure;
plot(data.Time, data.Temperature);
title('Temperatura a lo largo del tiempo');
xlabel('Tiempo');
ylabel('Temperatura');

figure;
scatter(data.Humidity, data.Temperature);
title('Temperatura vs Humedad');
xlabel('Humedad');
ylabel('Temperatura');

% Crear un mapa de calor usando imagesc
figure;
imagesc(data.Time, [], data.Humidity'); % Invertir el eje Y (opcional)
colormap(parula); % Colormap opcional
colorbar; % Mostrar barra de color
title('Mapa de calor de los datos');
xlabel('Tiempo');
ylabel('�ndice de D�as');
