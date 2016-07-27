
blockdata = NaN(300,10);
z = 1;
for compno = 0:2
    for resno = 0:4
        for bandno = 0:3
            for precno = 0:3
                for cblkno = 0:100
                    try
                       %rawdataE = importdata(['E' num2str(compno) '_' num2str(resno) '_' num2str(bandno) '_' num2str(precno) '_' num2str(cblkno) '.data']);
                       
                       p1 = fopen(['DecoderData\D' num2str(compno) '_' num2str(resno) '_' num2str(bandno) '_' num2str(precno) '_' num2str(cblkno) '.data']);
                       
                        n0 = 1;
                        dat = NaN(5000,1);
                        ln = fgetl(p1);
                        while ischar(ln)
                            dat(n0) = str2double(ln);
                            ln = fgetl(p1);
                            n0 = n0 + 1;
                        end
                        fclose(p1);
                        dat(isnan(dat)) = [];
                       
                       %disp('test');
                       blockdata(z,1) = z;
                       blockdata(z,2) = compno;
                       blockdata(z,3) = resno;
                       blockdata(z,4) = bandno;
                       blockdata(z,5) = dat(1); %x
                       blockdata(z,6) = dat(2); %y
                       blockdata(z,7) = dat(4); %resolution width
                       blockdata(z,8) = dat(5); %resolution height
                       blockdata(z,9) = dat(3); %codeblock stepsize
                       blockdata(z,10) = var(dat(6:end)); %codeblock variance
                       
                       
                       %Convert opj res level to format in VT function
                       res = 0;
                       if resno == 0
                           res = 4;
                       elseif resno == 1
                           res = 3;
                       elseif resno==2
                           res = 2;
                       elseif resno==3
                           res = 1;
                       else
                           res = 0;
                       end

                       disp(['read ' num2str(z) ' success!']);
                       z = z + 1;
                    catch
 
                    end
                end
            end
        end
    end
end
blockdata(isnan(blockdata(:,1)),:) = [];
save('blockdata.mat','blockdata');

%Testing
% rawdataE = importdata('E0_0_0_0_0.data');
% rawdataD = importdata('D0_0_0_0_0.data');
% cvarE = var(rawdataE.data);
% cvarD = var(rawdataD.data);
% D1 = hist(rawdataE.data,100);
% D2 = hist(rawdataD.data,100);
% plot(D1);
% hold on
% plot(D2);
% legend('Encoded','Decoded');



