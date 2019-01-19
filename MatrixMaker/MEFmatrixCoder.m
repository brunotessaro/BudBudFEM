
nDim = 3;
nNoel = 8;

nSke = nNoel*nDim;
ske = strings(nSke,nSke);

%
%
%  DIFUSION
%   MU PART
!difusConvecCode(nDim,nNoel,nSke,ske)
!difusLambdaCode(nDim,nNoel,nSke,ske)
difusMuCode(nDim,nNoel,nSke,ske)
!difusMassCode(nDim,nNoel,nSke,ske)

function difusMassCode(nDim,nNoel,nSke,ske)

    coords = ['x','y','z'];
    for a = 1: nSke
        for b = 1: nSke
            i = mod(a-1,nDim) + 1;
            j = mod(b-1,nDim) + 1;
            if i == j
                aN = floor((a+(nDim-1))/nDim)
                bN = floor((b+(nDim-1))/nDim)
                    ske(a,b) = strcat(ske(a,b),' N');
                    ske(a,b) = strcat(ske(a,b),num2str(aN));
                    ske(a,b) = strcat(ske(a,b),' * N');
                    ske(a,b) = strcat(ske(a,b),num2str(bN));
            else
                ske(a,b) = '0d0'
            end
        end
    end
    
    fileID = fopen('mass.txt','w');
    cont = 0;
    for b = 1: nSke
        for a = 1: nSke
            cont = cont+1;
            if ske(a,b) == '0d0'
                continue
            end
            if b >= a
                ske0 = strcat('\nske_Mass (',num2str(cont));
                ske0 = strcat(ske0,') =  ske_Mass (');
                ske0 = strcat(ske0,num2str(cont));
                ske0 = strcat(ske0,') + ');
                display(char(strcat(ske0,ske(a,b))));
                fprintf(fileID,char(strcat(ske0,ske(a,b))));
            end
        end
    end
    fclose(fileID);
end

function difusConvecCode(nDim,nNoel,nSke,ske)

    coords = ['x','y','z'];
    for a = 1: nSke
        for b = 1: nSke
            i = mod(a-1,nDim) + 1;
            j = mod(b-1,nDim) + 1;
            if i == j
                aN = floor((a+(nDim-1))/nDim)
                bN = floor((b+(nDim-1))/nDim)
                for k = 1: nDim
                if k > 1
                    ske(a,b) = strcat(ske(a,b),' + ');
                end
                    coordi = coords(i);
                    coordk = coords(k);
                    ske(a,b) = strcat(ske(a,b),' N');
                    ske(a,b) = strcat(ske(a,b),num2str(aN));
                    ske(a,b) = strcat(ske(a,b),' * u');
                    ske(a,b) = strcat(ske(a,b),num2str(k));
                    ske(a,b) = strcat(ske(a,b),' * dN');
                    ske(a,b) = strcat(ske(a,b),num2str(bN));
                    ske(a,b) = strcat(ske(a,b),'d');
                    ske(a,b) = strcat(ske(a,b),coordk);
                end
            else
                ske(a,b) = '0d0'
            end
        end
    end
    
    fileID = fopen('convec.txt','w');
    cont = 0;
    for b = 1: nSke
        for a = 1: nSke
            cont = cont+1;
            if ske(a,b) == '0d0'
                continue
            end
                ske0 = strcat('\nske_Convec (',num2str(cont));
                ske0 = strcat(ske0,') =  ske_Convec (');
                ske0 = strcat(ske0,num2str(cont));
                ske0 = strcat(ske0,') + ');
                display(char(strcat(ske0,ske(a,b))));
                fprintf(fileID,char(strcat(ske0,ske(a,b))));
        end
    end
    fclose(fileID);
end

function difusLambdaCode(nDim,nNoel,nSke,ske)

    coords = ['x','y','z'];
    for a = 1: nSke
        for b = 1: nSke
            i = mod(a-1,nDim) + 1;
            j = mod(b-1,nDim) + 1;
            aN = floor((a+(nDim-1))/nDim)
            bN = floor((b+(nDim-1))/nDim)
                coordi = coords(i);
                coordj = coords(j);
                ske(a,b) = strcat(ske(a,b),' dN');
                ske(a,b) = strcat(ske(a,b),num2str(aN));
                ske(a,b) = strcat(ske(a,b),'d');
                ske(a,b) = strcat(ske(a,b),coordi);
                ske(a,b) = strcat(ske(a,b),' * dN');
                ske(a,b) = strcat(ske(a,b),num2str(bN));
                ske(a,b) = strcat(ske(a,b),'d');
                ske(a,b) = strcat(ske(a,b),coordj);
        end
    end
    
    fileID = fopen('difusLambda.txt','w');
    cont = 0;
    for a = 1: nSke
        for b = 1: nSke
            cont = cont+1;
            if ske(a,b) == '0d0'
                continue
            end
            if a >= b
                ske0 = strcat('\nske_difus_Lambda (',num2str(cont));
                ske0 = strcat(ske0,') =  ske_difus_Lambda (');
                ske0 = strcat(ske0,num2str(cont));
                ske0 = strcat(ske0,') + ');
                display(char(strcat(ske0,ske(a,b))));
                fprintf(fileID,char(strcat(ske0,ske(a,b))));
            end
        end
    end
    fclose(fileID);
end

function difusMuCode(nDim,nNoel,nSke,ske)

    coords = ['x','y','z'];
    for a = 1: nSke
        for b = 1: nSke
            i = mod(a-1,nDim) + 1;
            aN = floor((a+(nDim-1))/nDim)
            bN = floor((b+(nDim-1))/nDim)
            if i == mod(b-1,nDim) + 1 % Same components for a and b
            for j = 1: nDim
                if j > 1 & length(char(ske(a,b))) > 1
                    ske(a,b) = strcat(ske(a,b),' + ');
                end
                if j == i
                    ske(a,b) = strcat(ske(a,b),' 2* ');
                end
                coordi = coords(i);
                coordj = coords(j);
                ske(a,b) = strcat(ske(a,b),' dN');
                ske(a,b) = strcat(ske(a,b),num2str(aN));
                ske(a,b) = strcat(ske(a,b),'d');
                ske(a,b) = strcat(ske(a,b),coordj);
                ske(a,b) = strcat(ske(a,b),' * dN');
                ske(a,b) = strcat(ske(a,b),num2str(bN));
                ske(a,b) = strcat(ske(a,b),'d');
                ske(a,b) = strcat(ske(a,b),coordj);
            end
            else
                cont = 0;
                for j = 1: nDim
                    cont = cont + 1;
                    if i == j
                        continue
                    end
                    if cont > 1 & length(char(ske(a,b))) > 1
                        ske(a,b) = strcat(ske(a,b),' + '); 
                    end
                    coordi = coords(i);
                    coordj = coords(j);
                    ske(a,b) = strcat(ske(a,b),' dN');
                    ske(a,b) = strcat(ske(a,b),num2str(aN));
                    ske(a,b) = strcat(ske(a,b),'d');
                    ske(a,b) = strcat(ske(a,b),coordj);
                    ske(a,b) = strcat(ske(a,b),' * dN');
                    ske(a,b) = strcat(ske(a,b),num2str(bN));
                    ske(a,b) = strcat(ske(a,b),'d');
                    ske(a,b) = strcat(ske(a,b),coordi);
                end
            end
        end
    end
    
    fileID = fopen('difusMu.txt','w');
    cont = 0;
    for a = 1: nSke
        for b = 1: nSke
            cont = cont+1;
            if ske(a,b) == '0d0'
                continue
            end
            if a >= b
                ske0 = strcat('\nske_difus_xMu (',num2str(cont));
                ske0 = strcat(ske0,') =  ske_difus_xMu (');
                ske0 = strcat(ske0,num2str(cont));
                ske0 = strcat(ske0,') + ');
                display(char(strcat(ske0,ske(a,b))));
                fprintf(fileID,char(strcat(ske0,ske(a,b))));
            end
        end
    end
    fclose(fileID);
end