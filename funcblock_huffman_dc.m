function value = funcblock_huffman_dc(dc)
%funcblock_huffman_dc applies entropy coding to the DC component
%   value = funcblock_huffman_dc(dc) returns the entropy coded value
%
%   Inputs:
%       dc: The first element of the quantized DCT matrix
%
%   Outputs:
%       value: entropy coded DC component

dc_huffman = {'00', '010', '011', '100', '101', '110', '1110', ...
              '11110', '111110', '1111110', '11111110', '111111110'};
if dc>=0
    if dc==0
        temp = dec2bin(dc,2);
    else
        temp = [dc_huffman{size(dec2bin(dc),2)+1} dec2bin(dc)];
    end
else
    C1=dec2bin(abs(dc));
    for j=1:size(C1,2)
        if C1(:,j)=='0'
            C1(:,j)='1';
        else
            C1(:,j)='0';
        end
    end
    temp = [dc_huffman{size(dec2bin(abs(dc)),2)+1} C1];
end
value=temp;
end
