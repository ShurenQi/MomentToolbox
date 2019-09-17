%graphs of orthogonal polynomials

%clear all
pb=1000;    %the number of points, where the graph is plotted, 
            %in discrete polynomials (type=8, 9 or 10), pb equals the number of samples
mxr=6;      %maximum degree, it must be at least 2
type=16;    %-1=geometric,0=Legendre,1=Chebyshev of the 1st kind,2=2nd kind,3=Gegenbauer
            %4=Jacobi(\alpha,\beta),5=Jacobi(p,q),6=Zernike,7=Fourier-Mellin,
            %8=Krawtchouk,9=weighted Krawtchouk,10=discrete Chebyshev,
            %11=shifted Chebyshev of the 1st kind, 12=2st kind, 
            %13=generalized Laguerre,14=weighted Laguerre,15=Hermite,16=weighted-Hermite
            %if type=3,4,5,8,9,13,14 there are additional parameters
cbgraph=0;  %cbgraph=0 color graph,cbgraph=1 black and white graph 
caption=1;  %caption=0 no caption, caption=1 graph with a caption
legendflag=1;   %legendflag=0 no legend, legendflag=1 graph with legend
lin1=-1;        %plot from lin1
lin2=1;         %plot to lin2

switch mxr
    case 1
      finstr='st';
    case 2
      finstr='nd';
    case 3
      finstr='rd';
    otherwise
      finstr='th';
end
alpha1=0;
alpha2=0;
alpha3=0;
clf
stry='values of the polynomials';
if type==6
    x=linspace(0,1,pb);
    hold on
    orthocoef=zeros((mxr+1)*(mxr+2)/2,mxr+1);
% Prata method
    orthocoef(1,1)=1;   %R_{0,0}(x)=1
    orthocoef(2,1)=1;   %R_{0,-1}(x)=x
    orthocoef(3,1)=1;   %R_{0,1}(x)=x
    for n=2:mxr;
        orthocoef(n*(n+1)/2+1,1)=1;   %R_{n,-n}(x)=x^n
        orthocoef(n*(n+1)/2+n+1,1)=1; %R_{n,n}(x)=x^n
        for la=-n+2:2:n-2
            %R_{n,la}(x)=2*x*n/(n+la)*R_{n-1,la-1}(x)-(n-la)/(n+la)*R_{n-2,la}(x)
            orthocoef(n*(n+1)/2+(la+n)/2+1,1:n)=orthocoef(n*(n+1)/2+(la+n)/2+1,1:n)+...
                2*n/(n+la)*orthocoef((n-1)*n/2+(la+n-2)/2+1,1:n);
            orthocoef(n*(n+1)/2+(la+n)/2+1,3:n+1)=orthocoef(n*(n+1)/2+(la+n)/2+1,3:n+1)+...
                -(n-la)/(n+la)*orthocoef((n-2)*(n-1)/2+(la+n-2)/2+1,1:n-1);
        end
    end
	disp(orthocoef)
    color='bgrcmyk';
    typelin=['- ';': ';'-.';'--'];
    pp=0;
	for n=0:mxr
        y=zeros(1,n+1);
        for la=mod(n,2):2:n
            pp=pp+1;
            nm=(la-mod(n,2))/2;
            y=polyval(orthocoef(n*(n+1)/2+nm+1,1:n+1),x);
            if cbgraph==0
                plot(x,y,[color(mod(n,7)+1),typelin(mod(nm,4)+1,:)]);
            else
                plot(x,y,['k',typelin(mod(n,4)+1,:)]);
            end
        end
	end
    axis([0,1,-1.1,1.1]);
    strx=['Zernike polynomials up to the ',int2str(mxr),finstr,' degree'];
    if caption
        xlabel(strx,'FontSize',11);
        ylabel(stry,'FontSize',11);
    end
    if legendflag==1
        clear legenditems
        legenditems=cell(1,pp);
        pp=1;
        for n=0:mxr
            for la=mod(n,2):2:n
                legenditems{pp}=['degree ',int2str(n),', repetition ',int2str(la)];
                pp=pp+1;
            end
        end
        legend(legenditems,'Location','Best');
    end
    hold off
    return
end
orthocoef=zeros(mxr+1);
for n=2:mxr
	if type==-1
		orthocoef(1,1)=1;
		orthocoef(2,1)=1;
		alpha1=1;
		alpha2=0;
        strx=['x^n up to the n=',int2str(mxr)];
        lin1=-1.5;
        lin2=1.5;
	elseif type==0
		orthocoef(1,1)=1;
		orthocoef(2,1)=1;
		alpha1=(2*n-1)/n;
		alpha2=(n-1)/n;
        strx=['Legendre polynomials up to the ',int2str(mxr),finstr,' degree'];
	elseif type==1
		orthocoef(1,1)=1;
		orthocoef(2,1)=1;
		alpha1=2;
		alpha2=1;
        strx=['Chebyshev polynomials of the first kind up to the ',int2str(mxr),finstr,' degree'];
	elseif type==2
		orthocoef(1,1)=1;
		orthocoef(2,1)=2;
		alpha1=2;
		alpha2=1;
        strx=['Chebyshev polynomials of the second kind up to the ',int2str(mxr),finstr,' degree'];
	elseif type==3
        lambda=0.75;
		orthocoef(1,1)=1;
		orthocoef(2,1)=2*lambda;
		alpha1=2*(n-1+lambda)/n;
		alpha2=(n-2+2*lambda)/n;
        if lambda==0
			orthocoef(2,1)=2;
            if n==2
        		alpha2=1;
            end
        end
        strx=['Gegenbauer polynomials for \lambda=',num2str(lambda),' up to the ',int2str(mxr),finstr,' degree'];
	elseif type==4
        alpha=1.75;
        beta=1.25;
		orthocoef(1,1)=1;
		orthocoef(2,1)=(alpha+beta+2)/2;
		orthocoef(2,2)=(alpha-beta)/2;
        nomin=2*n*(n+alpha+beta)*(2*n-2+alpha+beta);
		alpha1=(2*n+alpha+beta-2)*(2*n+alpha+beta-1)*(2*n+alpha+beta)/nomin;
		alpha2=2*(n-1+alpha)*(n-1+beta)*(2*n+alpha+beta)/nomin;
		alpha3=(2*n+alpha+beta-1)*(alpha^2-beta^2)/nomin;
        strx=['Jacobi polynomials for \alpha=',num2str(alpha),', \beta=',num2str(beta),' up to the ',int2str(mxr),finstr,' degree'];
	elseif type==5
        p=3;
        q=2;
		orthocoef(1,1)=1;
		orthocoef(2,1)=1;
		orthocoef(2,2)=(-q)/(p+1);
        nomin=(2*n+p-4)*(2*n+p-3)*(2*n+p-2)*(2*n+p-1)*(2*n+p-3);
		alpha1=1;
		alpha2=(n-1)*(n+q-2)*(n+p-2)*(n+p-q-1)*(2*n+p-1)/nomin;
		alpha3=-((2*n-2)*(n+p-1)+q*(p-1))*(2*n+p-4)*(2*n+p-3)*(2*n+p-2)/nomin;
        strx=['Jacobi polynomials for p=',num2str(p),', q=',num2str(q),' up to the ',int2str(mxr),finstr,' degree'];
        lin1=0;
	elseif type==7
		orthocoef(1,1)=1;
		orthocoef(2,1)=3;
		orthocoef(2,2)=-2;
        for k=0:n
			orthocoef(n+1,n+1-k)=(-1)^(n+k)*factorial(n+k+1)/(factorial(n-k)*factorial(k)*factorial(k+1));
        end
        strx=['orthogonal Fourier-Mellin polynomials up to the ',int2str(mxr),finstr,' degree'];
	elseif type==8 || type==9
        p=0.5;
        vn=pb-1;
		orthocoef(1,1)=1;
		orthocoef(2,1)=-1/(vn*p);
		orthocoef(2,2)=1;
        nomin=(vn-n+1)*p;
		alpha1=-1/nomin;
		alpha2=(n-1)*(1-p)/nomin;
		alpha3=(vn*p-2*(n-1)*p+n-1)/nomin;
        if type==8
            strx=['Krawtchouk polynomials for p=',num2str(p),' up to the ',int2str(mxr),finstr,' degree'];
        else            
            strx=['weighted Krawtchouk polynomials for p=',num2str(p),' up to the ',int2str(mxr),finstr,' degree'];
        end
        lin1=0;
        lin2=vn;
	elseif type==10
        vn=pb;
		orthocoef(1,1)=1/sqrt(vn);
		orthocoef(2,1)=2*sqrt(3/vn/(vn^2-1));
		orthocoef(2,2)=(1-vn)*sqrt(3/vn/(vn^2-1));
		alpha1=2/n*sqrt((4*n^2-1)/(vn^2-n^2));
		alpha2=(n-1)/n*sqrt((2*n+1)*(vn^2-(n-1)^2)/(2*n-3)/(vn^2-n^2));
		alpha3=(1-vn)/n*sqrt((4*n^2-1)/(vn^2-n^2));
        strx=['discrete Chebyshev polynomials up to the ',int2str(mxr),finstr,' degree'];
        lin1=0;
        lin2=vn-1;
    elseif type==11
		orthocoef(1,1)=1;
		orthocoef(2,1)=2;
        orthocoef(2,2)=-1;
        alpha1=4;
		alpha2=1;
		alpha3=-2;
        strx=['shifted Chebyshev polynomials of the first kind up to the ',int2str(mxr),finstr,' degree'];
        lin1=0;
    elseif type==12
		orthocoef(1,1)=1;
		orthocoef(2,1)=4;
        orthocoef(2,2)=-2;
        alpha1=4;
		alpha2=1;
		alpha3=-2;
        strx=['shifted Chebyshev polynomials of the second kind up to the ',int2str(mxr),finstr,' degree'];
        lin1=0;
	elseif type==13 || type==14
        alpha=0;  % non-generalized Laguerre polynomials have alpha=0 else alpha>=-1;
		orthocoef(1,1)=1;
		orthocoef(2,1)=-1;
		orthocoef(2,2)=alpha+1;
		alpha1=-1/n;
		alpha2=(n-1+alpha)/n;
		alpha3=(2*n-1+alpha)/n;
	    lin1=0;
	    lin2=mxr+2;
        if alpha==0
            strx=['Laguerre polynomials up to the ',int2str(mxr),finstr,' degree'];
        else
            strx=['Generalized Laguerre polynomials for \alpha=',num2str(alpha),...
                  ' up to the ',int2str(mxr),finstr,' degree'];
        end
        if type==14
            strx=['weighted ',strx];
%    	    lin2=4.3*mxr+10;
    	    lin2=1*mxr;
        end
    elseif type==15 || type==16
		orthocoef(1,1)=1;
		orthocoef(2,1)=2;
		alpha1=2;
		alpha2=2*n-2;
        if type==15
            strx=['Hermite polynomials up to the ',int2str(mxr),finstr,' degree'];
            lin1=-round(mxr*0.5);
            lin2=round(mxr*0.5);
        else
            strx=['Gaussian-Hermite polynomials up to the ',int2str(mxr),finstr,' degree'];
            lin1=-round(4+mxr*0.25);
            lin2= round(4+mxr*0.25);
        end
	end
% P_{0}=orthocoef(1,1);
% P_{1}=orthocoef(2,1)*x+orthocoef(2,2);
% P_{n}=(alpha3+alpha1*x)*P_{n-1}-alpha2*P_{n-2};
    orthocoef(n+1,1:n)=orthocoef(n+1,1:n)+alpha1*orthocoef(n,1:n);
    orthocoef(n+1,3:n+1)=orthocoef(n+1,3:n+1)-alpha2*orthocoef(n-1,1:n-1);
    orthocoef(n+1,2:n+1)=orthocoef(n+1,2:n+1)+alpha3*orthocoef(n,1:n);
end
disp(orthocoef)
x=linspace(lin1,lin2,pb);
clear y
for n=0:mxr
    y(n+1,:)=polyval(orthocoef(n+1,1:n+1),x);
    if type==9
        for xi=0:vn
            warning off MATLAB:nchoosek:LargeCoefficient
            y(n+1,xi+1)=y(n+1,xi+1)*(nchoosek(pb,n)*nchoosek(pb,xi)*p^(n+xi)*(1-p)^(pb-xi-n))^(0.5);
        end
    elseif type==14
%        y(n+1,1)=1;
        for xi=1:pb
            y(n+1,xi)=y(n+1,xi)*(factorial(n)/gamma(n+1+alpha))^(0.5)*exp(-x(xi)/2)*x(xi)^(alpha/2);
        end
    elseif type==16
        for xi=1:pb
            y(n+1,xi)=y(n+1,xi)*(2^n*factorial(n)*pi^0.5)^(-0.5)*exp(-x(xi)^2/2);
        end
    end
end
%close
%hold on
if cbgraph==0 
%    plot(x,y);
    plot(x,y(1,:),'g',x,y(2,:),'r',x,y(3,:),'b',x,y(4,:),'k',x,y(5,:),'m',x,y(6,:),'c',x,y(7,:),'y');
else
    plot(x,y,'k');
end
if type==1 || type==11
    axis([lin1,lin2,-1.1,1.1]);
elseif type==7
    axis([0,1,-2.1,2.1]);
elseif type==8
    axis([0,pb,-1,1.1]);
elseif type==14
    axis([lin1,lin2,-1,1]);
elseif type==15
    axis([lin1,lin2,-10^(mxr*0.5),10^(mxr*0.5)]);
end
if caption
    xlabel(strx,'FontSize',11);
    ylabel(stry,'FontSize',11);
end
if legendflag==1
    clear legenditems
    legenditems=cell(1,mxr+1);
    for n=0:mxr
        legenditems{n+1}=['degree ',int2str(n)];
    end
    legend(legenditems,'Location','Best');
end
