function [r,o] = ro(n,m)
r = zeros(n,m);
o = zeros(n,m);
R = max((n-1)/2,(m-1)/2);
for x = 1:n
    for y = 1:m
        xx = x-1;
        yy = y-1;
        if (xx<=(n-1)/2) && (yy>=(m-1)/2)
            p = yy-(m-1)/2;
            q = (n-1)/2-xx;
            r(x,y) = sqrt(p^2+q^2)/R;
            o(x,y) = asin(q/sqrt(p^2+q^2));
        elseif (xx<=(n-1)/2) && (yy<(m-1)/2)  
            p = (m-1)/2-yy;
            q = (n-1)/2-xx;
            r(x,y) = sqrt(p^2+q^2)/R;
            o(x,y) = pi-asin(q/sqrt(p^2+q^2));
        elseif (xx>(n-1)/2) && (yy<=(m-1)/2)
            p = (m-1)/2-yy;
            q = xx-(n-1)/2;
            r(x,y) = sqrt(p^2+q^2)/R;
            o(x,y) = pi+asin(q/sqrt(p^2+q^2));
        elseif (xx>(n-1)/2) && (yy>(m-1)/2)
            p = yy-(m-1)/2;
            q = xx-(n-1)/2;
            r(x,y) = sqrt(p^2+q^2)/R;
            o(x,y) = 2*pi-asin(q/sqrt(p^2+q^2));
        end
        if r(x,y)==0
            o(x,y) = 0;
        elseif r(x,y)>1
            r(x,y) = 10000;            
        end
    end
end
