function CRC_Init_error_table(g,n)

    %Init the error table of CRC_code
    %g: generate poly
    %n: the dim of CRC_codee
    max=2^n-1;
    weight=flip([0:n-1]);
    weight=2.^weight;
    m=size(g);
    m=m(2)-1;
    m=2^m-1;
    Table=zeros(1,m);
    Cost=zeros(1,m)+n+10;
    for i=[1:max]
        bin=int32(dec2bin(i))-int32('0');
        tcost=sum(bin);
        m=size(bin);
        m=m(2);
        bin=[zeros(1,n-m),bin];
        bin=double(bin);
        [q,r]=deconv(bin,g);
        r=mod(r,2);
        s=r.*weight;
        s=sum(s);
        s=int32(s);
        if s==0
            continue
        end
        if tcost<Cost(1,s)
           Cost(1,s)=tcost;
           Table(1,s)=i;
        end
    end
    Table
    save('CRC_error_Table','Table');
end