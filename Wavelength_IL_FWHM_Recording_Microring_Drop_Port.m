clear all
fid = fopen('results.csv','a'); % the file to save data
if fid < 0
    errordlg('File creation failed','Error');
end
str = ['Number',"Wavelength(nm)","Insertion Loss(dB)","FWHM(nm)","FSR(nm)"]; % data title
fprintf(fid,"%s,%s,%s,%s,%s\n",str(1),str(2),str(3),str(4),str(5));


for i = 1:41
    name = strcat(num2str(i),'.txt'); % input files name  (from lumerical FDTD's txt)
    [wavelength dot intensity] = textread(name,' %f %s %f','headerlines',3);
    wavelength = flipud(wavelength);
    intensity = flipud(intensity);

    [pks,locs] = findpeaks(db(abs(intensity),'power'),wavelength,'MinPeakProminence',4,'Annotate','extents'); % find peaks 
    FSR = 0;
    if (length(locs)>=2)
        FSR = locs(2) - locs(1);
    end
    for item_locs = 1:length(locs)
        item = locs(item_locs);
       if (item > 1565) & (item < 1570)  % set your wavelength range
           location = find(wavelength == item);
           wavelength_ouput = wavelength(location); %resonance wavelength
           IL_ouput = -pks(item_locs); % insertion loss
           w = 0;
           while ~(db(abs(intensity(location-w)),'power') < db(abs(intensity(location)),'power') - 3 & ... % FWHW calcualte
                   db(abs(intensity(location+w)),'power') < db(abs(intensity(location)),'power') - 3)
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