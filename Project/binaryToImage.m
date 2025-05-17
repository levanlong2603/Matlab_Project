function binaryToImage(binaryString, outputImageFile)
    load('image_meta.mat', 'h', 'w', 'c'); % Đọc lại thông số ảnh
    numPixels = h * w * c;
    if length(binaryString) ~= numPixels * 8
        error('Độ dài chuỗi nhị phân không khớp với kích thước ảnh');
    end
    binChunks = reshape(binaryString, 8, []).';   % Cắt thành từng đoạn 8 bit
    pixelValues = uint8(bin2dec(binChunks));     % Chuyển về số nguyên
    img = reshape(pixelValues, [h, w, c]);       % Reshape thành ảnh
    imwrite(img, outputImageFile);               % Ghi ảnh ra file
end
