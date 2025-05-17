function binaryString = imageToBinary(imageFile)
    img = imread(imageFile);        % Đọc ảnh
    [h, w, c] = size(img);          % Lấy thông số
    imgVector = img(:);             % Chuyển ma trận ảnh thành vector
    binMatrix = dec2bin(imgVector, 8);   % Chuyển từng giá trị pixel thành chuỗi 8 bit
    binaryString = reshape(binMatrix.', 1, []); % Ghép lại thành một chuỗi dài
    save('image_meta.mat', 'h', 'w', 'c'); % Lưu thông tin ảnh
end
