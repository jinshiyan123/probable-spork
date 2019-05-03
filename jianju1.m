clear
clc
c=xlsread('/Users/zzy/Downloads/3.xlsx','Sheet1','a2:a19881');%number
t=xlsread('/Users/zzy/Downloads/3.xlsx','Sheet1','e2:e19881');%time
x=xlsread('/Users/zzy/Downloads/3.xlsx','Sheet1','f2:f19881');%location
y=xlsread('/Users/zzy/Downloads/3.xlsx','Sheet1','g2:g19881');%location
v=xlsread('/Users/zzy/Downloads/3.xlsx','Sheet1','m2:m19881');%speed
a=xlsread('/Users/zzy/Downloads/3.xlsx','Sheet1','n2:n19881');%acceleration
k2=0;
for i=(1:19880)
    k1=1;
    de(1)=99999999999999;
    for j=(i:19880)
        if (t(j)==t(i)&&c(j)~=c(i))
            k1=k1+1;
            de(k1)=(x(i)-x(j))^2+(y(i)-y(j))^2;
            if(de(k1)<de(k1-1))
                d0(i)=de(k1);%d0:the present distance between two cars
                b1(i)=j;%b1:the number of the second car
            end     
        end
    end
    if(k1~=1)
        for i1=(1:19880)
            if(c(i1)==c(i)&&t(i1)>t(i)&&d0(i)<22500)
                k2=k2+1;
                d1=(x(i1)-x(b1(i)))^2+(y(i1)-y(b1(i)))^2;%i'-j
                d2=(x(i1)-x(i))^2+(y(i1)-y(i))^2;%i'-i
                if(d1>d2&&d1>d0(i))
                    f(k2)=i;%the number of the front car
                    vf(k2)=v(i);%speed
                    b(k2)=b1(i);%the number of the back car
                    vb(k2)=v(b1(i));%speed
                else
                    f(k2)=b1(i);
                    vf(k2)=v(b1(i));
                    b(k2)=i;
                    vb(k2)=v(i);
                end
                dd(k2)=sqrt(d0(i));%selected distance
                tt(k2)=t(i);%present time
                break
            end
        end    
    end
end
if(k2~=0)
    fid = fopen('jianju1.txt','w');
    for i=(1:k2)
       fprintf(fid,'%d %f %d %f %f %d\r\n',[f(i),vf(i),b(i),vb(i),dd(i),tt(i)]);
    end
    fclose(fid);
    tdd=dd';
    tvf=vf';
    tvb=vb';
    X=[tdd,tvb];
    K=3;
    [idx,C,sumD,D]=kmeans(X,K,'Distance','city','Replicates',3);
    plot(X(idx==1),'r.','MarkerSize',12)
    hold on
    plot(X(idx==2),'g.','MarkerSize',12)
    hold on
    plot(X(idx==3),'b.','MarkerSize',12)
    hold on
    plot(C(idx==1),'rp','MarkerSize',18)
end


        
            
            
    
    