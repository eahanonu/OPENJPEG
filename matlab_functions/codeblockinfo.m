function [cblkdata, coeffmats, cbstep] = codeblockinfo( cblkfile )
%codeblockinfo reads the codeblock info data files and puts into an array
%
% Columns are as follows:
% 1 - compno
% 2 - resno
% 3 - bandno
% 4 - cblk_band_x
% 5 - cblk_band_y
% 6 - clbk_x
% 7 - cblk_y
% 8 - cblk_w
% 9 - cblk_h
% 10 - quantizer expansion factor (total_bitplanes - encoded_bitplanes)
% 11 - base stepsize
% 12 - codeblock unquantized variance
% 13 - codeblock quantized variance

p1 = fopen(cblkfile);
F1 = textscan(p1,'%s','delimiter','\n');
F1 = F1{1};
fclose(p1);

if length(F1{1}) > 10
    disto = strsplit(F1{1}(1:end-1), ' ');
    disto = cellfun(@(x) str2double(x), disto);
    F1(1) = [];
end
    
cblkdata = NaN(50000,13);
%ln = fgetl(p1);
temp = cell(1,7);
n0 = 1;
n1 = 1;
n2 = 1;
ln = ' ';
coeffmats = {};
cbstep = {};
coeffs = [];
while n0 < length(F1)
    ln = F1{n0};
    temp{n1} = [ln ' '];
    if n1==7
        %Check if coefficients are present, if so grab them
        if ln(1)=='C'
            temp1 = strsplit(temp{4},' ');
            cblkdims = [sscanf(temp1{2},'%d'),sscanf(temp1{1},'%d')];
            %coeffs = nan(sscanf(t1{2},'%d'),sscanf(t1{1},'%d'));
            %coeffs = nan(cblkdims);
            %coeffs(1) = sscanf(ln(2:end),'%f');
            %temp2 = cellfun(@(x) sscanf(x(2:end),'%f'),F1(n0:n0+prod(cblkdims)-1));
            
            temp2 = repmat(char(0),1,numel(char(F1(n0:n0+prod(cblkdims)-1))));
            temp3 = char(F1(n0:n0+prod(cblkdims)-1));
            temp3(:,1) = ' ';
            temp3 = temp3.';
            for n4 = 1:numel(temp3)
                temp2(n4) = temp3(n4);
            end
            temp2 = sscanf(temp2,'%f');
            
            uqc = temp2(1:3:end); %unquantized coefficients
            qc = temp2(2:3:end);  %quantized coefficients
            bps = str2double(temp(5));
            bss = str2double(temp(6));
            cbsteps = temp2(3:3:end);
            
            cbsteps = bss * (2 .^ (bps - cbsteps));
            cbstep{n2} = reshape(cbsteps,cblkdims).';
            
            %cbstep{n2} = reshape((bps-cbsteps)/bps,cblkdims).';
            
            coeffmats{n2,1} = reshape(uqc,cblkdims).'; %C is row major MATLAB is column major
            coeffmats{n2,2} = reshape(qc,cblkdims).';
            %coeffmats{n2} = temp2.';
            n0 = n0 + prod(cblkdims);
            temp{n1} = [F1{n0} ' '];
        end
        temp2 = strsplit(cell2mat(temp),' ');
        cblkdata(n2,:) = cellfun(@(x) str2double(x),temp2(1:13));
        cblkdata(n2,12) = var(coeffmats{n2,1}(:)); % unquantized variance
        cblkdata(n2,13) = var(coeffmats{n2,2}(:)); % quantized variance
        n2 = n2 + 1;
        n1 = 0;
        n0 = n0 + 1;
    end
    n0 = n0 + 1;
    n1 = n1 + 1;
end

cblkdata = cblkdata(~isnan(cblkdata(:,1)),:);
end

