function [x,y]=ellipse_p_add(a,b,p,Qx,Qy,Px,Py)
% Define O=(p,p)
if Qx==p & Qy==p
    x=Px;
    y=Py;
elseif Px==p & Py==p
    x=Qx;
    y=Qy;
else
   flagx=mod(Qx+Px,p);
   flagy=mod(Qy+Py,p);
   if flagx==0 & flagy==0
       x=p;
       y=p;
   else
       [x,y]=ellipse_p_add_noequal(a,b,p,Qx,Qy,Px,Py);
   end
end
end