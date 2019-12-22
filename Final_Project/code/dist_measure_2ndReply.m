function [metric]=dist_measure_2ndReply(v1,v2,der1,der2)
% % distance metric between two vectors with different length
% % The peak/gap position vector v2 and EDR position vector der2 are of reference,
% %¡¡v1,der1 are of the sample to be measured
positive_scorce =  sum((v1.*v2).*(der1.*der2));
negative_scorce1 =  sum((v1.*(~v2)).*(der1.*der2));
negative_scorce2 = sum(((~v1).*v2).*(der1.*der2));
metric = (positive_scorce)/(positive_scorce + negative_scorce1 + negative_scorce2); 