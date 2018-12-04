function [x,y]=ellipse_p_add_noequal(a,b,p,Qx,Qy,Px,Py)
    flagx=mod(Qx-Px,p);
    flagy=mod(Qy-Py,p);

    if flagx==0 & flagy==0
        lambda1=mod(3*Px*Px+a,p);
        lambda2=mod(2*Py,p);
        lambda2=inverse_gfp(lambda2,p);
        lambda=mod(lambda1*lambda2,p);        
    else
        lambda1=flagy;
        lambda2=inverse_gfp(flagx,p);
        lambda=mod(lambda1*lambda2,p);
    end
    x=mod(lambda^2-Px-Qx,p);
    y=mod(lambda*(Px-x)-Py,p);
end