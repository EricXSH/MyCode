function [normalizedTrain,normalizedTest] = normalize_data(trainData, testData)
%normalize_data: x_ = (x - mean) / std
%   using the mean and standard deviation to normalize both training and
%   testing data
m = mean(trainData);
d = std(trainData, 1);
normalizedTrain = (trainData - m) ./ d;
normalizedTest = (testData - m) ./ d;
end

