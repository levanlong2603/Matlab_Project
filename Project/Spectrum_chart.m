% analyze_spectrum.m
function Spectrum_chart()
    clear all; close all; clc;
    load('signal_data.mat');
    
    nfft = 2048;
    f = linspace(-fs/2, fs/2, nfft);
    
    figure('Name','Spectrums');
    subplot(2,1,1);
    specTx = abs(fftshift(fft(filteredTx, nfft)));
    plot(f/1e6, 20*log10(specTx / max(specTx)));
    title('Phổ sau lọc phát'); xlabel('Tần số (MHz)'); ylabel('Biên độ (dB)');
    
    subplot(2,1,2);
    specRx = abs(fftshift(fft(filteredRx, nfft)));
    plot(f/1e6, 20*log10(specRx / max(specRx)));
    title('Phổ sau lọc thu'); xlabel('Tần số (MHz)'); ylabel('Biên độ (dB)');
end
