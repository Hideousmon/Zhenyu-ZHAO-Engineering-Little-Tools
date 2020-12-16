clear all
fid = fopen('results.csv','a'); % the file to save data
if fid < 0
    errordlg('File creation failed','Error');
end
str = ['Number',"Wavelength(nm)","Insertion Loss(dB)","FWHM(nm)","FSR(nm)"]; % data title
fprintf(fid,"%s,%s,%s,%s,%s\n",str(1),str(2),str(3),str(4),str(5));


for i = 1:50
    name = strcat(num2str(i),'.txt'); % input files name  (from lumerical FDTD's txt)
    [wavelength dot intensity] = textread(name,' %f %s %f','headerlines',3);
    wavelength = flipud(wavelength);
    intensity = flipud(intensity);

    [valleys,locs] = findpeaks(db(abs((1-intensity)),'power'),wavelength,'MinPeakProminence',4,'Annotate','extents'); % find valleys 
    [pks,locs_peaks] = findpeaks(db(abs(intensity),'power'),wavelength,'MinPeakProminence',1,'Annotate','extents'); % find peaks 
    FSR = 0;
    if (length(locs)>=2)
        FSR = locs(2) - locs(1);
    end
    IL_ouput = 0;
    if (length(locs_peaks) > 1)
        IL_ouput = -pks(1); % insertion loss
    end
    for item_locs = 1:length(locs)
        item = locs(item_locs);
       if (item > 1566) & (item < 1569)  % set your wavelength range
           location = find(wavelength == item);
           wavelength_ouput = wavelength(location); %resonance wavelength
           w = 0;
           while ~(db(abs(1-intensity(location-w)),'power') < db(abs(1-intensity(location)),'power') - 3 & ... % FWHW calcualte
                   db(abs(1-intensity(location+w)),'power') < db(abs(1-intensity(location)),'power') - 3)
                   w = w + 1;
           end
           FWHM_output = wavelength(location+w) - wavelength(location-w);
           FWHM_output = FWHM_output; % FWHW 
           
           fprintf(fid,"%d,%f,%f,%f,%f\n",i,wavelength_ouput,IL_ouput,FWHM_output,FSR);
       end
    end
end

fclose(fid);
fclose all