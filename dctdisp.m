function [imag] = dctdisp( newdct )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global r;
global c;
global bs;
global nob;
kk=0;
j=0;
for i=1:(r/bs)
    for j=1:(c/bs)
        imag(:,:,kk+j)=newdct(:,:);
    end
    kk=kk+(r/bs);
end
for count = 1:nob
    subplot(r/bs,c/bs,count),imshow(imag(:,:,count))
end
end



