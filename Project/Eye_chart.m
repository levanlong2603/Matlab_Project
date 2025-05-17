function Eye_chart()
    clear all; close all; clc;
    load('signal_data.mat');
    
    eyediagram(filteredRx, 2*samplesPerSymbol);
    title('Mẫu mắt sau lọc thu');
end
