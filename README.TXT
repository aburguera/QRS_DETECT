==============
=== CREDIT ===
==============

QRS detection and ECG data compression.

Author : Antoni Burguera
e-mail : antoni.burguera@uib.es

A paper describing the theory behind this software has been submitted to a peer-reviewer journal. The proper reference will be added to this file after acceptance.

If you use this software, please cite that reference. If the reference is not available in this README, please contact us.

=========================
=== BUILD THE PACKAGE ===
=========================

Download and unpack the package, if necessary, wherever you want. Open Matlab and navigate to the package source directory. Type "ls" or "dir" and check that several .m files and two .c files are there. One of the .m files is "install.m".

The package is pure Matlab code except for two C files with MEX interface to Matlab. To build them, just execute the file "install.m":

>> install

Some warnings related to GCC version may appear, but no errors should occur. You should see "MEX completed successfully" appear twice.

In case of errors, check your Matlab MEX configuration by typing "help mex" and following the instructions.

====================
=== RUN THE CODE ===
====================

Within the source directory there is a "main.m" file. Execute it to see an example:

>> main

This example loads a synthetic ECG generated with ECGSYN (https://www.physionet.org/physiotools/ecgsyn/Matlab/). By typing "dataSet.name" after the execution, some data about ECGSYN is provided.

Even though "main" loads synthetic data, it shows the main usage of the software. In particular, the main function is:

[Rdata,cecg]=process_ecg(ecg,Fs)

whose input parameters are a row vector of ECG samples (ecg) and a scalar stating the sampling frequency in Hz (Fs). The output Rdata is a 2xN vector holding the sample numbers of the R-peaks (first row) and the corresponding values (second row). The output cecg is the compressed ECG and is a set of features with the same format as Rdata.

Note that:
* Rdata(2,:) is equivalent to ecg(Rdata(1,:))
* cecg(2,:) is equivalent to ecg(cecg(1,:))

Navigate through the source code and read the comments and file headers to understand how the software works.

==========================
=== FULL USAGE EXAMPLE ===
==========================

To use the software with a Physionet ECG from Matlab, proceed as follows:

1) Install WFDB Matlab toolbox in case you don't have it (https://physionet.org/physiotools/matlab/wfdb-app-matlab/) and load the ECG

>> [tm,ecg,Fs]=rdsamp('mitdb/100',1);

In this example, the first parameter is the record path within WFDB search path. Type "help rdsamp" if it doesn't work or want to know which records are available.

The second parameter is the signal number. Some databases are multiparameter. Thus, make sure that the signal number corresponds to an ECG. A simple way to check it is to download all the record files and open the corresponding ".hea" file with a text editor.

2) Check Fs. In most cases, rdsamp does not place any value within Fs. If this happens, you will have to assign it manually. Again, check the ".hea" file (well documented in Physionet) to know the sampling frequency. Another option is to guess Fs from "tm", which is usually properly read, as follows:

>> Fs=round(length(tm)/(tm(end)-tm(1)));

4) Execute the code

>> [Rdata,cecg]=process_ecg(ecg,Fs);

5) Plot the R-peak results:

>> figure;plot(ecg,'b');hold on;plot(Rdata(1,:),Rdata(2,:),'r*');legend('ECG','R-peaks');

>> figure;plot(ecg,'b');hold on;plot(cecg(1,:),cecg(2,:),'r');legend('ECG','Compressed ECG');

Note that this description is Physionet and WFDB related. Actually, you just need a vector with the ECG samples (ecg) and the sampling frequency (Fs).

=======================
=== TROUBLESHOOTING ===
=======================

This software package has been tested using Matlab 8.5.0.197613 (R2015a) running on Ubuntu 16.04LTS with GCC 5.4.0. Other configurations are untested.