function [pPosit_vect,der] = peakBin_detect(hist_in)
figure;bar(hist_in,0.9),title('origin');
threPeak = 0.005;% 0.01 seems more perfect?
% smooth the gray level histogram, remove the peak and gap artifacts
winHalf = 2;
y = zeros(1,256);
hist_in([1:3,254:256]) = 0;  % have not considered the ending 3 bins
% preprocessing: fill the gap bins
tp = hist_in;
for n = 4:length(hist_in)-3 % have not considered the ending 3 bins
    if  tp(n) == 0
        hist_in(n) = mean(tp([n-1,n+1]));
    end        
end
figure;bar(hist_in,0.9),title('filled');
%% statistcal order filtering
for n = 4:length(hist_in)-3 % have not considered the ending 3 bins
    seg = [hist_in(max(n-winHalf,1):min(n+winHalf,255))];
    seg = sort(seg);
    y(n) = seg(3); % the 2nd smallest element of the 5 ones
end
%% followed by average filtering 
hist_out = y;
w = 1;
for n = 5:length(hist_in)-5
    hist_out(n) = mean(y(n-w:n+w));
end
figure,bar([0:255],hist_out,0.9),xlim([-1,256]),title('median filter');
%figure,bar([0:255],hist_out,1),xlim([-1,256]),ylim([0 0.07]) 
%% DER extraction
der = ones(1,256);
wder = 5;
for n = 1:256
    if max(hist_out(max([1,n-wder]):min([256,n+wder])))<1*10^(-3) % %%%%%%%%%%%%%%%%
       der(n) = 0; % denote the DER
    end
end
der(1:3)=0; der(254:256)=0;
%% difference of the histograms before and after being smoothed
hist_dif = hist_in - hist_out;
figure;bar(hist_dif/sum(hist_dif),0.9),title('difference1');
hist_dif = hist_dif .* (hist_dif>0);
figure;bar(hist_dif/sum(hist_dif),0.9),title('difference2');

%% identify peak bins
pPosit_vect = hist_dif > threPeak;
pPosit_vect = pPosit_vect.*der;
