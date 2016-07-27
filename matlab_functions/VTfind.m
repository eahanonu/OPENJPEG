function iVT = VTfind(resno,comp,sig2,band,cstep)

%OPENJPEG:
%For resolution 0 (5 in cal_VT) band -> LL5
%band 0 otherwise is LH
%band 1 is HL
%band 2 is HH


%Convert from openjpeg to liu resolution order
res = 0;
if resno==1
    res = 5;
elseif resno==2
    res = 4;
elseif resno==3
    res = 3;
elseif resno==4
    res = 2;
else
    res = 1;
end

vt = 0;
%jnd = 1;
jnd = 0.1;
while true
    [a_lum,b_lum,b_c1,b_c2] = cal_VT(jnd);

    a_LL = a_lum(1);
    a_lum = fliplr(a_lum(2:end));
    b_LL = b_lum(1);
    b_lum = fliplr(b_lum(2:end));
    rind = [1,4,7,10,13];

    if comp==0
       if res==5
           a = a_LL;
           b = b_LL;
       else
           a = a_lum(rind(res)+band);
           b = b_lum(rind(res)+band);
       end
    elseif comp==1
        a = 0;
        b = b_c1;
    else
        a = 0;
        b = b_c2;
    end

    if sig2==0
        
    end
    
    vt = a*sig2+b;
    
    if vt>=cstep
        iVT = jnd;
        break;
    else
        %jnd = jnd + 1;
        jnd = jnd + 0.1;
    end
    
    if jnd>=255
        iVT = jnd;
       break; 
    end
end
end

