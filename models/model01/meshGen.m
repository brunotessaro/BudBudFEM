clear all
close all

Lx = 1;
Ly = 1;
Lz = 1;

nxEl = 10;
nyEl = 10;
nzEl = 10;
nNoel = 8;

nx = (nxEl+1);
ny = (nyEl+1);
nz = (nzEl+1);

nEl = nxEl*nyEl*nzEl;
nNo = nx*ny*nz

incid=zeros(nEl,nNoel);
x=zeros(nNo);
y=zeros(nNo);
z=zeros(nNo);

cont = 0;
for i = 1:nx
    for j = 1:ny
        for k = 1:nz
            cont = cont + 1;
            x(cont) = Lx*(i-1)/(nx-1);
            y(cont) = Ly*(j-1)/(ny-1);
            z(cont) = Lz*(k-1)/(nz-1);
        end
    end
end

N(1, 1, 1) = 1
N(2, 1, 1) = 2
N(2, 2, 1) = 3
N(1, 2, 1) = 4
N(1, 1, 2) = 5
N(2, 1, 2) = 6
N(2, 2, 2) = 7
N(1, 2, 2) = 8

dx = Lx*(1)/(nx-1);
dy = Ly*(1)/(ny-1);
dz = Lz*(1)/(nz-1);
cont = 0;
for i = 1:nxEl
    for j = 1:nyEl
        for k = 1:nzEl
            x0 = Lx*(i-0.5)/(nxEl);
            y0 = Ly*(j-0.5)/(nyEl);
            z0 = Lz*(k-0.5)/(nzEl);
            cont = cont + 1;
            for iNo = 1:nNo
               if x(iNo) <= x0 + 1.1*dx/2 & x(iNo) >= x0 - 1.1*dx/2 
                    if y(iNo) <= y0 + 1.1*dy/2 & y(iNo) >= y0 - 1.1*dy/2 
                      	if z(iNo) <= z0 + 1.1*dz/2 & z(iNo) >= z0 - 1.1*dz/2 
                            I = round((-x0 + x(iNo))/abs(-x0 + x(iNo)) / 2 + 1.5);
                            J = round((-y0 + y(iNo))/abs(-y0 + y(iNo)) / 2 + 1.5);
                            K = round((-z0 + z(iNo))/abs(-z0 + z(iNo)) / 2 + 1.5);
                            if incid(cont,N(I,J,K)) > 0
                                display('incid exists already')
                                pause
                            end
                            incid(cont,N(I,J,K)) = iNo;
                        end
                    end
               end
            end
        end
    end
end

fID = fopen('model01.GEO','w')
fprintf(fID,'DADOS PARA FORMATO ENSIGHT\n')
fprintf(fID,'Ensight Geometry COPPE/UFRJ\n')
fprintf(fID,'node id given\n')
fprintf(fID,'element id given\n')
fprintf(fID,'coordinates\n')
fprintf(fID,'%8i\n',nNo)
for iNo = 1:nNo
    fprintf(fID,'%8i%12.5e%12.5e%12.5e\n',[iNo, x(iNo), y(iNo), z(iNo)])
end
fprintf(fID,'part        1\n')
fprintf(fID,'material        1\n')
fprintf(fID,'octa8\n')
fprintf(fID,'%8i\n',nEl)
for iEl = 1:nEl
    fprintf(fID,'%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',[iEl, incid(iEl,1), incid(iEl,2), incid(iEl,3), incid(iEl,4), incid(iEl,5), incid(iEl,6), incid(iEl,7), incid(iEl,8),])
end
fclose(fID)

fID = fopen('model01.RHSV','w')
fprintf(fID,'*BC1\n')
for iNo = 1:nNo
    if abs(z(iNo)-Lz)<dz/10
        fprintf(fID,'%8i%8i%12.5e\n',[iNo, 1, 1.0])
        fprintf(fID,'%8i%8i%12.5e\n',[iNo, 2, 0.0])
        fprintf(fID,'%8i%8i%12.5e\n',[iNo, 3, 0.0])
    else
        if abs(x(iNo)) < dx/10 | abs(y(iNo)) < dy/10 | abs(z(iNo)) < dz/10 | abs(x(iNo)-Lx) < dx/10 | abs(y(iNo)-Ly) < dy/10 
            fprintf(fID,'%8i%8i%12.5e\n',[iNo, 1, 0.0])
            fprintf(fID,'%8i%8i%12.5e\n',[iNo, 2, 0.0])
            fprintf(fID,'%8i%8i%12.5e\n',[iNo, 3, 0.0])    
        end
    end
end
fclose(fID)


display('oi')
