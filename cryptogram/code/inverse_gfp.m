function y=inverse_gfp(x,p)   
    [d,a,b]=gcd(x,p);
    y=mod(a,p);
end