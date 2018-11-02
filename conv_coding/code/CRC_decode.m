function data=CRC_decode(code,g)
    %Make sure the Error Table is designed for g and dim(code)
    %g: generate poly
    %code: wait_to_be decode
    m=size(code);
    m=m(2);
    weight=flip([0:m-1]);
    weight=2.^weight;
    t=open('CRC_error_Table.mat');
    Table=t.Table;
    [q,r]=deconv(code,g);
    s=mod(r,2);
    s=s.*weight;
    s=sum(s);
    if s==0
        data=code;
    else
        e=Table(1,s);
        e=dec2bin(e);
        e=int32(e)-int32('0');
        me=size(e);
        me=me(2);
        e=[zeros(1,m-me),e];
        e=double(e);
        data=code+e;
        data=mod(data,2);
    end
    mg=size(g);
    mg=mg(2);
    data=data(1,1:m-mg+1);
end