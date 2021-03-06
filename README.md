# Engineering Little Tools
 Some programs that can do help to my projects.

## Wavelength_IL_FWHM_Recording.m

It can analyze *transmission parameter* results from Lumerical FDTD，and save *resonance wavelength*, *insertion loss*, *FWHM* into a ".csv" file.

#### Attention

Make sure the FDTD output values are positive and save as *Text*. e.g. 

![example](pictures/example.png)

## Plot_Spectrum_with_IL_FWHM.m

A coarse program that can analyze *transmission parameter* results from Lumerical FDTD and re-plot the results in *dB* unit. Besides, it can calculate *resonance wavelength*, *insertion loss*, *FWHM* and print in *Matlab Command window*. 

Make sure the FDTD output values are positive and save as *Text*.



## EightCannel_Isolation_Cal.m

It can help analyze 8 resonance results from Lumerical FDTD and calculate *Channel Isolation* between each two of them, and save *Channel Isolation* into a ".csv" file.

Make sure the FDTD output values are positive and save as *Text*.



## Wavelength_IL_FWHM_Recording_Drop_Port.m

Based on *Wavelength_IL_FWHM_Recording.m*, analyze FSR in Microring Drop port.



## Wavelength_IL_FWHM_Recording_Through_Port.m

Based on *Wavelength_IL_FWHM_Recording.m*, analyze FSR in Microring Through port.



## checkandshutdown.py

Check CPU usage and shutdown the machine (with Win10) when CPU usage is low.

* If there is no remote connecting when the app needs to be run, it requests that the app runs on the system service:

  ```
  ## add the app to the system service
  sc create cands  binpath= C:\Users\Administrator\Desktop\checkandshutdown.exe type= own start= demand displayname= cands
  
  ## run
  net start cands
  ```

  
