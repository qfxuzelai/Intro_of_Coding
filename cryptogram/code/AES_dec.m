function plaintext = AES_dec(cyphertext,key)
%AES_DEC   AES decipher

% check input
if mod(length(cyphertext),128) ~= 0
    warning('the length of cyphertext is not divisible by 128.');
    warning('added 0s at the end of cyphertext automatically.');
    warning('the last block (128bit) of plaintext is probably wrong.');
    cyphertext = [cyphertext,zeros(1,128-mod(length(cyphertext),128))];

end
if (length(key)~=128)&&(length(key)~=192)&&(length(key)~=256)
    error('the length of the 2nd parameter ''key'' must be 128, 192 or 256.');
end

global S_box iS_box MULT_box
load('AES_BOX.mat','S_box','iS_box','MULT_box');

W = keyExpansion(key);
Nb = length(cyphertext)/128;
plaintext = zeros(1,length(cyphertext));
for block = 1:Nb
    plaintext(128*(block-1)+1:128*block) = decrypt(cyphertext(128*(block-1)+1:128*block),W);
end
end

function W = keyExpansion(key)
Rc = hex2dec(["01","02","04","08","10","20","40","80","1B","36"]);
Rcon = [Rc;zeros(3,10)];
Nk = length(key)/32;
Nr = Nk+6;
W = zeros(4,4*(Nr+1));
W(:,1:Nk) = reshape(bin2dec(char(reshape(key,8,4*Nk)'+48)),4,Nk);
for cnt = Nk+1:4*(Nr+1)
    temp = W(:,cnt-1);
    if mod(cnt,Nk) == 1
        temp = bitxor(subBytes([temp(2:4);temp(1)]),Rcon(:,ceil(cnt/Nk)-1));
    elseif (Nk>6)&&(mod(cnt,Nk)==5)
        temp = subBytes(temp);
    end
    W(:,cnt) = bitxor(W(:,cnt-Nk),temp);
end
end

function plaintext = decrypt(cyphertext,W)
Nr = length(W)/4-1;
state = reshape(bin2dec(char(reshape(cyphertext,8,16)'+48)),4,4);
state = addRoundKey(state,W(:,4*Nr+1:4*(Nr+1)));
for round = Nr-1:-1:1
    state = iShiftRows(state);
    state = iSubBytes(state);
    state = addRoundKey(state,W(:,4*round+1:4*(round+1)));
    state = iMixColumns(state);
end
state = iShiftRows(state);
state = iSubBytes(state);
state = addRoundKey(state,W(:,1:4));
plaintext = logical(reshape(dec2bin(state,8)',1,128)-48);
end

function state = subBytes(state)
global S_box
state = S_box(state+1);
end

function state = iSubBytes(state)
global iS_box
state = iS_box(state+1);
end

function state = iShiftRows(state)
state(2,:) = [state(2,4),state(2,1:3)];
state(3,:) = [state(3,3:4),state(3,1:2)];
state(4,:) = [state(4,2:4),state(4,1)];
end

function state = iMixColumns(state)
for c = 1:4
    v = state(:,c);
    state(1,c) = bitxor(bitxor(gfmult(14,v(1)),gfmult(11,v(2))),bitxor(gfmult(13,v(3)),gfmult(9,v(4))));
    state(2,c) = bitxor(bitxor(gfmult(9,v(1)),gfmult(14,v(2))),bitxor(gfmult(11,v(3)),gfmult(13,v(4))));
    state(3,c) = bitxor(bitxor(gfmult(13,v(1)),gfmult(9,v(2))),bitxor(gfmult(14,v(3)),gfmult(11,v(4))));
    state(4,c) = bitxor(bitxor(gfmult(11,v(1)),gfmult(13,v(2))),bitxor(gfmult(9,v(3)),gfmult(14,v(4))));
end
end

function state = addRoundKey(state,round_key)
state = bitxor(state,round_key);
end

function p = gfmult(a,b)
global MULT_box
if (a==2)||(a==3)
    index = a-1;
elseif (a==9)||(a==11)||(a==13)
    index = (a-3)/2;
elseif a==14
    index = 6;
else
    error('the first parameter ''a'' must be 2, 3, 9, 11, 13 or 14.');
end
p = MULT_box(index,b+1);
end
