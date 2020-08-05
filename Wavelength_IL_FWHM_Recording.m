clear all
fid = fopen('results.csv','a'); % the file to save data
if fid < 0
    errordlg('File creation failed','Error');
end
str = ['Number',"Wavelength(¦Ìm)","Insertion Loss(dB)","FWHM(nm)"]; % data title
fprintf(fid,"%s,%s,%s,%s\n",str(1),str(2),str(3),str(4));


for i = 1:55
    name = strcat(num2str(i),'.txt'); % input files name  (from lumerical FDTD's txt)
    [wavelength dot intensity] = textread(name,' %f %s %f','headerlines',3);
    intensity = intensity;
    wavelength = flipud(wavelength);
    intensity = flipud(intensity);

    [pks,locs] = findpeaks(db(abs(intensity)),wavelength,'MinPeakProminence',4,'Annotate','extents'); % find peaks 
    for item_locs = 1:length(locs)
        item = locs(item_locs);
       if (item > 1.547) & (item < 1.562)  % set your wavelength range
           location = find(wavelength == item);
           wavelength_ouput = wavelength(location)*1000; %resonance wavelength
           IL_ouput = -pks(item_locs); % insertion loss
           w = 0;
           while ~(db(abs(intensity(location-w))) < db(abs(intensity(location))) - 3 & ... % FWHW calcualte
                   db(abs(intensity(location+w))) < db(abs(intensity(location))) - 3)
                   w = w + 1;
           end
           FWHM_output = wavelength(location+w) - wavelength(location-w);
           FWHM_output = FWHM_output*1000; % FWHW 
           fprintf(fid,"%d,%f,%f,%f\n",i,wavelength_ouput,IL_ouput,FWHM_output);
       end
    end
    


end

fclose(fid);
fclose all
