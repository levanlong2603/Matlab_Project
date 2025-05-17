% Mô phỏng hệ thống truyền dẫn 16-PSK với dữ liệu ảnh
clear all; close all; clc;
% Chuyển ảnh sang chuỗi nhị phân
binaryStr = imageToBinary('y2025VinhHaLong.jpg');

% Lưu chuỗi nhị phân vào file (tuỳ chọn)
fid = fopen('image_data.bin', 'w');
fwrite(fid, binaryStr);
fclose(fid);

% Đọc lại chuỗi nhị phân từ file và phục hồi ảnh
fid = fopen('image_data.bin', 'r');
binaryStr2 = fscanf(fid, '%c');
fclose(fid);
binaryToImage(binaryStr2, 'output.jpg');

% Hiển thị ảnh
subplot(1,2,1); imshow(imread('y2025VinhHaLong.jpg')); title('Ảnh gốc');
    subplot(1,2,2); imshow('output.jpg');
    title('Ảnh khôi phục');

% Xác định các thông số ảnh
originalInfo = imfinfo('y2025VinhHaLong.jpg');
outputInfo = imfinfo('output.jpg');

disp('Thông tin ảnh gốc:');
disp(['- Kích thước ảnh: ', num2str(originalInfo.Width), ' x ', num2str(originalInfo.Height)]);
disp(['- Định dạng: ', originalInfo.Format]);
disp(['- Số bit: ', num2str(originalInfo.Width * originalInfo.Height * 3 * 8)]);

disp('Thông tin ảnh phục hồi:');
disp(['- Kích thước ảnh: ', num2str(outputInfo.Width), ' x ', num2str(outputInfo.Height)]);
disp(['- Định dạng: ', outputInfo.Format]);
disp(['- Số bit: ', num2str(outputInfo.Width * outputInfo.Height * 3 * 8)]);