function Wave_chart()
    clear all; close all; clc;
    load('signal_data.mat');

    % Số lượng mẫu cần hiển thị để dễ quan sát
    Nm = 1000;

    % Tính trục thời gian tương ứng
    t = (0:Nm-1)/fs;

    % Vẽ
    figure('Name','Waveform (Zoomed-In)', 'NumberTitle', 'off');
    
    subplot(2,1,1);
    plot(t, real(filteredTx(1:Nm)));
    title('Dạng sóng - Sau lọc phát (Zoom-in)', 'FontWeight', 'bold');
    xlabel('Thời gian (s)'); ylabel('Biên độ');
    grid on;

    subplot(2,1,2);
    plot(t, real(filteredRx(1:Nm)));
    title('Dạng sóng - Sau lọc thu (Zoom-in)', 'FontWeight', 'bold');
    xlabel('Thời gian (s)'); ylabel('Biên độ');
    grid on;
end
