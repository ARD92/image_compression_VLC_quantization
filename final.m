clc
clear all
close all
format compact
Tx=[];
global r;
global bs;
global c;
global nob;
%%%%%%%%%%%% quantization matrix Given %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Quantization_matrix=[...
    16 11 10 16 24 40 51 61;...
    12 12 14 19 26 58 60 55;...
    14 13 16 24 40 57 69 56;...
    14 17 22 29 51 87 80 62;...
    18 22 37 56 68 109 103 77;...
    24 36 55 64 81 194 113 92;...
    49 64 78 87 103 121 120 101;...
    72 92 95 98 112 100 103 99];

%%%%%%%%%%%%% zig zag order selection of indices %%%%%%%%%%%%%%%%%%%%%%%%
z=[...
    9 2 3 10 17 25 18 11 4 5 12 19 26 ...
    33 41 34 27 20 13 6 7 14 21 28 35 ...
    42 49 57 50 43 36 29 22 15 8 16 23 ...
    30 37 44 51 58 59 52 45 38 31 24 32 ...
    39 46 53 60 61 54 47 40 48 55 62 63 56 64];

%%%%%%%%%%%%%Read the image and get the values of pixels%%%%%%%%%%%%%%%%%%%
In=im2double(imread('lena128.bmp'));
[r, c, d]=size(In);

if (d > 1)
    In_img=zeros(r,c);
    In_img(1:1:r,1:1:c)=In(1:1:r,1:1:c);
    imwrite(In_img,'exact.bmp');
    info1=imfinfo('exact.bmp');
    Nob_original=(info1.FileSize)*8;
else
    In_img=In;
    info1=imfinfo('lena128.bmp');
    Nob_original=(info1.FileSize)*8;
end
%figure
%imshow(In_img);
%title('Original input image');
%%%%%%%%%%% Macro Block division %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bs=8; % Block Size (8x8)
nob=(r/bs)*(c/bs); % Total number of 8x8 Blocks
% Dividing the image into 8x8 Blocks
kk=0;
for i=1:(r/bs)
    for j=1:(c/bs)
        Block(:,:,kk+j)=In_img((bs*(i-1)+1:bs*(i-1)+bs),(bs*(j-1)+1:bs*(j-1)+bs));
    end
    kk=kk+(r/bs);
end

%%%%% Displaying the divided image into macro blocks %%%%%%%%%%%%%%%%%%%%%
figure;
for num=1:nob
    subplot(r/bs,c/bs,num),imshow(Block(:,:,num))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lo=0;
k=0;
for lo = 1:nob
    new=Block(:,:,lo);
    newdct=dct2(new); % applying DCT to the macro blocks individually
%     subplot(r/bs,c/bs,lo),imshow(newdct); %display the dct applied image
    DCTQ=newdct./Quantization_matrix;  % Quantizing the blocks
    k=k+1;
    zig_zag_dc(k,1) = DCTQ(1,1); % choosing the DC component which is the 1st element of DCT
    zig_zag_ac(k,1:63) = DCTQ(z);% choosing AC components by having a zig zag movement
end

%%%%%% Entropy coding- Huffman coding %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dpcm(1,1)=zig_zag_dc(1,1);

Tx=cat(2,Tx,funcblock_huffman_dc(dpcm(1,1)),funcblock_huffman_ac(zig_zag_ac(1,1:63)));
for m=2:k
    dpcm(m,1)=zig_zag_dc(m,1)-zig_zag_dc(m-1,1);
    Tx=cat(2,Tx,funcblock_huffman_dc(dpcm(m,1)),funcblock_huffman_ac(zig_zag_ac(m,1:63)));
end
%%%%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
