function plot_analysis(ecg,Fs,Rdata,cecg)
    % Precompute some parameters to adjust plot
    v0=min(ecg);
    v1=max(ecg);
    yMargin=(v1-v0)*0.1;
    yMin=v0-yMargin;
    yMax=v1+yMargin;
    xMin=0;
    xMax=length(ecg)/Fs;

    % Plot data
    plot((1:length(ecg))/Fs,ecg,'b','LineWidth',2);
    hold on;
    plot(cecg(1,:)/Fs,cecg(2,:),'r');
    hold on;
    plot(Rdata(1,:)/Fs,Rdata(2,:),'k*','MarkerSize',10);

    % Prepare legends, labels, ...
    axis([xMin xMax yMin yMax]);
    legend('ECG','Compressed ECG','R-peaks');
    set(gca,'FontSize',12);
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Move or zoom to navigate through the ECG');
return;
