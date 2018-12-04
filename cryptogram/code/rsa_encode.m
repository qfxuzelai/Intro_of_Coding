function result=rsa_encode(key,n,message)
    s=length(message);
    if mod(s,512)~=0
        error('length of message must 512*k');
    end
    result=zeros(1,s);
    weight=sym([0:511]);
    weight=2.^weight;
    for i=[1:512:s]
        ms=message(1,i:i+511);
        ms=ms.*weight;
        ms=sum(ms);
        t=rsa_encode_signal(key,n,ms);
        l=length(t);
        result(1,i:i+l-1)=t;
    end
end

