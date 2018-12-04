function bin=convert_symdec_to_bin(dec)
    length=512;
    bin=zeros(1,length);
    now=dec;
    for i=[1:length]
       weight=2^(length-i);
       res=double(now/weight);
       if res>=1
          now=now-weight;
          bin(1,length-i+1)=1;
       end
    end
end