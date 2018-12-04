function [key_private,key_public_x,key_public_y]=ellipse_p_generate_key(a,b,p,gx,gy,length)
    key_private=rand(1,length)>0.5;
    key_private(1,length)=1;
    [key_public_x,key_public_y]=ellipse_p_multi(a,b,p,gx,gy,key_private);

end