% Mô phỏng hệ thống truyền dẫn 16-PSK với dữ liệu ảnh
clear all; close all; clc;

% 1. Tải dữ liệu ảnh đã chuyển đổi từ phần 1
load('image_meta.mat'); % Tải thông số h, w, c
fid = fopen('image_data.bin', 'r');
binaryStr = fscanf(fid, '%c');
fclose(fid);
dataBits = double(binaryStr) - '0';

% 2. Tham số hệ thống
bitRate = 16e6;          % Tốc độ bit 16 Mbps
M = 16;                  % 16-PSK
k = log2(M);             % Số bit/symbol
symbolRate = bitRate/k;  % Tốc độ symbol
fs = 4*symbolRate;       % Tần số lấy mẫu
samplesPerSymbol = fs/symbolRate;

% 3. Thiết lập bộ lọc
rolloff = 0.35;          % Hệ số roll-off
span = 10;               % Độ dài bộ lọc
rrcFilter = rcosdesign(rolloff, span, samplesPerSymbol);

% 4. SNR mô phỏng
SNR_dB = input("Nhập giá trị SNR: ");
SNR_linear = 10^(SNR_dB/10);

% 5. Chuẩn bị dữ liệu
bitsPerFrame = 1e5; % Số bit mỗi khung
numFrames = ceil(length(dataBits)/bitsPerFrame);
rxBits = zeros(size(dataBits));

% 6. Xử lý từng khung
for frameIdx = 1:numFrames
    startBit = (frameIdx-1)*bitsPerFrame + 1;
    endBit = min(frameIdx*bitsPerFrame, length(dataBits));
    txBits = dataBits(startBit:endBit);

    % Đảm bảo số bit chia hết cho k
    paddingBits = 0;
    if mod(length(txBits), k) ~= 0
        paddingBits = k - mod(length(txBits), k);
        txBits = [txBits, zeros(1, paddingBits)];
    end

    % Điều chế
    symbols = bi2de(reshape(txBits, k, []).', 'left-msb');
    txSig = pskmod(symbols, M, pi/16);

    % Lọc phát
    upSig = upsample(txSig, samplesPerSymbol);
    filteredTx = filter(rrcFilter, 1, upSig);

    % Kênh AWGN
    noiseVar = var(filteredTx)/SNR_linear;
    noise = sqrt(noiseVar/2)*(randn(size(filteredTx)) + 1i*randn(size(filteredTx)));
    rxSig = filteredTx + noise;

    % Lọc thu
    filteredRx = filter(rrcFilter, 1, rxSig);

    % Lấy mẫu
    samples = filteredRx(span*samplesPerSymbol+1:samplesPerSymbol:end);

    % Giải điều chế
    demodSymbols = pskdemod(samples, M, pi/16);
    rxFrameBits = de2bi(demodSymbols, k, 'left-msb').';
    rxFrameBits = rxFrameBits(:)'; % Chuyển về vector hàng

    % Cắt bỏ phần padding nếu có
    validBits = length(txBits) - paddingBits;

    % Đảm bảo không truy cập vượt giới hạn mảng
    numRxFrameBits = length(rxFrameBits);
    numBitsToAssign = min(validBits, numRxFrameBits);
    endAssignIdx = min(startBit + numBitsToAssign - 1, length(rxBits));

    rxBits(startBit:endAssignIdx) = rxFrameBits(1:(endAssignIdx - startBit + 1));
    if frameIdx == 1
        % Lưu tín hiệu cho xử lý hiển thị (chỉ lấy 1 khung)
        save('signal_data.mat', ...
            'txSig', ...           % Tín hiệu sau điều chế
            'filteredTx', ...      % Tín hiệu sau lọc phát
            'rxSig', ...           % Tín hiệu sau kênh AWGN
            'filteredRx', ...      % Tín hiệu sau lọc thu
            'samples', ...         % Tín hiệu sau lấy mẫu tại bộ thu
            'samplesPerSymbol', ...
            'fs', ...
            'rrcFilter', ...
            'M');
    end

end

% 7. Khôi phục ảnh và tính BER
rxBits = rxBits(1:length(dataBits)); % Cắt đúng độ dài gốc

bitErrors = sum(dataBits ~= rxBits);
BER = bitErrors/length(dataBits);
fprintf('SNR = %d dB, BER = %.4f\n', SNR_dB, BER);

% Khôi phục ảnh
rxBinaryStr = reshape(char(rxBits+'0'), 8, []).';
rxPixels = uint8(bin2dec(rxBinaryStr));
rxImg = reshape(rxPixels, h, w, c);

% Hiển thị ảnh
figure;
subplot(1,2,1); imshow(imread('y2025VinhHaLong.jpg')); title('Ảnh gốc');
subplot(1,2,2); imshow(rxImg); title(sprintf('SNR=%ddB, BER=%.4f', SNR_dB, BER));

% Lưu ảnh
imwrite(rxImg, sprintf('recovered_SNR_%ddB.jpg', SNR_dB));
