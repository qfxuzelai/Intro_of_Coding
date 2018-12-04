function [enc_bit] = RS_encode(bit,m,prim_poly,n,k)
%
% Function to perform Reed-Solomon encoding
%
%****************** variables *************************
% bit : the bitstream to encode
% m : the order of Galois field
% prim_poly : the primitive polynomial (D^3+D+1=11)
% n : the bits of information and redundant
% k : the bits of information
% enc_bit : the code encoded from bit
% *****************************************************
    bit_exp = [bit,rand(1,mod(m*k-mod(length(bit),m*k),m*k))>0.5];
    gf_s = 2.^[m-1:-1:0]*reshape(bit_exp,m,length(bit_exp)/m);
    alpha = gf(2,m,prim_poly);
    gf_x = 1;
    gf_p = [reshape(gf_s,k,length(gf_s)/k)',zeros(length(gf_s)/k,n-k)];
    for count = mod(1:n-k,n)
        gf_x = conv(gf_x,[1,alpha.^count]);
    end
    for count = 1:length(gf_s)/k
        encode_msg = gf(gf_p(count,:),m,prim_poly);
        [~,r] = deconv(encode_msg,gf_x);
        encoded = encode_msg-r;
        gf_p(count,:) = encoded.x;
    end
    gf_s1 = reshape(gf_p',1,length(gf_s)/k*n);
    enc_bit = double(reshape(dec2bin(gf_s1)',1,m*length(gf_s1)))-48;
end