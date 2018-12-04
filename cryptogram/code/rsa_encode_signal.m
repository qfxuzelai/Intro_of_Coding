function res=rsa_encode_signal(key,n,ms)
    len=length(key);
    weight=[];
    now=ms;
    for i=[1:len]
        now=mod(now,n);
        weight=[weight,now];
        now=now^2;
    end
    now=sym(1);
    for i=[1:length(key)]
        if key(1,i)==1
            now=now*weight(1,i);
            now=mod(now,n);
        end
    end
    res=convert_symdec_to_bin(now);
end