function [key_public,key_private,n]=rsa_generate_key()
length=512;
start=int32(length/2)-50;
en=int32(length/2)-2;
one_len=randi([start,en]);
another_len=length-one_len;
p=nextprime(2^sym(one_len));
q=nextprime(2^sym(another_len));
n=p*q;
phi=(p-1)*(q-1);
key_public=sym(randseed(randseed(),1,1,2^14,2^16));
[d,a,b]=gcd(key_public,phi);
key_private=mod(a,phi);
key_private=convert_symdec_to_bin(key_private);
key_public=convert_symdec_to_bin(key_public);
end