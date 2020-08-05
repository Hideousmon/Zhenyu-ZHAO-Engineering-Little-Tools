[wavelength dot intensity] = textread('1.txt',' %f %s %f','headerlines',3) ; % input files name  (from lumerical FDTD's txt)
intensity = intensity;
wavelength = flipud(wavelength);
intensity = flipud(intensity);
%% plot
figure(1)
hold on
plot (wavelength, db(intensity));
title(" Spectrum")
set(gca,'FontSize', 16)
set(gca,'FontName', 'Times New Roman')
%set(gca,'XLim', [1.5,1.6])
%set(gca,'YLim', [-30,0])
ylabel('Relative power (dB)'), xlabel('Wavelength (¦Ìm)')
%% calculate results

[pks,locs] = findpeaks(db(abs(intensity)),wavelength,'MinPeakProminence',4,'Annotate','extents');
locs % print all resonance wavelength
locs = find(wavelength == locs(1)) % select the number of your wanted resonance wavelength
wavelength(locs) % print your selected resonance wavelength
pks(1) % print insertion loss (inverse value)

while ~(db(abs(intensity(locs-w))) < db(abs(intensity(locs))) - 3 & ...
     db(abs(intensity(locs+w))) < db(abs(intensity(locs))) - 3)
     w = w + 1;
end
FWHM = wavelength(locs-w) - wavelength(locs+w) % print FWHM
