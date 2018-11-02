function code=CRC_encode(d,g)
    %d: data k=25 fixed
    %g: generate poly
    %m: shift
    m=size(g);
    m=m(2)-1;
    d=[d,zeros(1,m)];
    [q,r]=deconv(d,g);
    r=mod(r,2);
    code=r+d;
    
end