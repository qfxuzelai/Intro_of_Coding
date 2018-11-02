
function [hat_phi,E_error]=process_phi(x,y,sigma_2)
abs_x=abs(x);
abs_y=abs(y);
angle_y=angle(y);
cos_angle_y=cos(angle_y);
sin_angle_y=sin(angle_y);
K_1=sum((abs_x.*abs_y).*cos_angle_y);
K_2=sum((abs_x.*abs_y).*sin_angle_y);
r=K_1+j*K_2;
hat_phi=angle(r);
cos_delta=cos(angle_y-hat_phi);
sin_delta=sin(angle_y-hat_phi);
K_3=sum((abs_x.*abs_y).*cos_delta)/sigma_2;
K_4=sum((abs_x.*abs_y).*sin_delta)/sigma_2;

epsilon=[-pi:0.01:pi];
cos_ep=cos(epsilon);
sin_ep=sin(epsilon);
f=K_3*cos_ep+K_4*sin_ep;
f=exp(f);
f=f./(10);
b=trapz(epsilon,f);
g=abs(epsilon).*f;
a=trapz(epsilon,g);
E_error=a/b;
end