clear all
fid = fopen('Channel_Isolation.csv','a'); % the file to save data
if fid < 0
    errordlg('File creation failed','Error');
end
fprintf(fid,"%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n","1 to 2","2 to 1","2 to 3","3 to 2", "3 to 4", "4 to 3","4 to 5", ...
        "5 to 4", "5 to 6","6 to 5","6 to 7","7 to 6","7 to 8", "8 to 7"); %titles for eight channels

resonate_center = zeros(1,8);
intensity_all = [];
name = ["9.txt","14.txt","21.txt","27.txt","33.txt","39.txt","45.txt","51.txt"]; % input files name  (from lumerical FDTD's txt)
for i = 1:8
    [wavelength dot intensity] = textread(name(i),' %f %s %f','headerlines',3);
    intensity = intensity;
    wavelength = flipud(wavelength);
    intensity = flipud(intensity);
    intensity_all(i,:) = db(abs(intensity));
    [pks,locs] = findpeaks(db(abs(intensity)),wavelength,'MinPeakProminence',4,'Annotate','extents'); % find peaks 
    for item_locs = 1:length(locs)
        item = locs(item_locs);
       if (item > 1.547) & (item < 1.562) % set your wavelength range
           resonate_center(i) = find(wavelength == item);
       end
    end
end
isolation_1_2 = intensity_all(1,resonate_center(1)) - intensity_all(2,resonate_center(1));
isolation_2_1 = intensity_all(2,resonate_center(2)) - intensity_all(1,resonate_center(2));
isolation_2_3 = intensity_all(2,resonate_center(2)) - intensity_all(3,resonate_center(2));
isolation_3_2 = intensity_all(3,resonate_center(3)) - intensity_all(2,resonate_center(3));
isolation_3_4 = intensity_all(3,resonate_center(3)) - intensity_all(4,resonate_center(3));
isolation_4_3 = intensity_all(4,resonate_center(4)) - intensity_all(3,resonate_center(4));
isolation_4_5 = intensity_all(4,resonate_center(4)) - intensity_all(5,resonate_center(4));
isolation_5_4 = intensity_all(5,resonate_center(5)) - intensity_all(4,resonate_center(5));
isolation_5_6 = intensity_all(5,resonate_center(5)) - intensity_all(6,resonate_center(5));
isolation_6_5 = intensity_all(6,resonate_center(6)) - intensity_all(5,resonate_center(6));
isolation_6_7 = intensity_all(6,resonate_center(6)) - intensity_all(7,resonate_center(6));
isolation_7_6 = intensity_all(7,resonate_center(7)) - intensity_all(6,resonate_center(7));
isolation_7_8 = intensity_all(7,resonate_center(7)) - intensity_all(8,resonate_center(7));
isolation_8_7 = intensity_all(8,resonate_center(8)) - intensity_all(7,resonate_center(8));
fprintf(fid,"%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n",isolation_1_2,isolation_2_1,isolation_2_3,isolation_3_2,isolation_3_4,isolation_4_3,isolation_4_5, ...
       isolation_5_4,isolation_5_6,isolation_6_5,isolation_6_7,isolation_7_6,isolation_7_8,isolation_8_7);

fclose(fid);
fclose all
