% Load the ECG. This ECG is synthetic, generated with ECGSYN. After
% loading, print the dataSet.name field for more information.
load syntheticData;

% Process the data.
[Rdata,cecg]=process_ecg(dataSet.ecg,dataSet.Fs);

% Plot analysis
plot_analysis(dataSet.ecg,dataSet.Fs,Rdata,cecg);

% Plot ground truth (annotation)
hold on;
plot(dataSet.annotation(1,:)/dataSet.Fs,dataSet.ecg(dataSet.annotation(1,:)),'go','MarkerSize',10);

% Re-write the whole legend (the first three items are already written by
% plot_analysis). Yes, this is dirty but it's easier... who will notice?
% ;-)
legend('ECG','Compressed ECG','Detected R-peaks','Ground truth');