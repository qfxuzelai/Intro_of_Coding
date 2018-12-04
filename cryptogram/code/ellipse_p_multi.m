function [Y_x,Y_y]=ellipse_p_multi(a,b,p,gx,gy,key_private)
    weight_x=[gx];
    weight_y=[gy];
    now_x=gx;
    now_y=gy;
    len=length(key_private);
    for i=[2:len]
        [now_x,now_y]=ellipse_p_add(a,b,p,now_x,now_y,now_x,now_y);
        weight_x=[weight_x,now_x];
        weight_y=[weight_y,now_y];
    end
    now_x=p;
    now_y=p;
    for i=[1:len]
       if key_private(1,i)==1
          [now_x,now_y]=ellipse_p_add(a,b,p,now_x,now_y,weight_x(1,i),weight_y(1,i)); 
       end
    end
    Y_x=now_x;
    Y_y=now_y;
end