function torusz(R,r)
    x = @(p,t) (R+r.*cos(p)).*cos(t);
    y = @(p,t) (R+r.*cos(p)).*sin(t);
    z = @(p,t) r.*sin(p);
    fsurf(x,y,z, [-pi pi 0 2*pi]);
    axis equal;
    xlabel('x');
    ylabel('y');
    zlabel('z');
end