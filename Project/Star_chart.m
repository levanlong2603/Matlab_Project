% analyze_constellation.m
function Star_chart()
    clear all; close all; clc;
    load('signal_data.mat');
    
    figure('Name','Constellation Diagrams');
    subplot(1,3,1); plot(txSig, 'o'); axis square;
    title('1. Sau điều chế');
    
    subplot(1,3,2); plot(rxSig(1:50:end), '.'); axis square;
    title('2. Sau kênh AWGN');
    
    subplot(1,3,3); plot(samples, '.'); axis square;
    title('3. Sau bộ thu');
end
