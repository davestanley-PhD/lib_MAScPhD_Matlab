

function y = cosfun (coefs, t)
    global per
    period = per;
    A=coefs(1);
    phi=coefs(2);
    y = A*cos(2*pi/period*(t-phi));
end