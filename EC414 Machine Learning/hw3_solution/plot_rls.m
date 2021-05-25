clear all
close all

load prostateStnd;

[n, d] = size(Xtrain);
W = zeros(d, 16);    % store coefficient vectors
mseTrain = zeros(1, 16);    % store mean squared errors
mseTest = zeros(1, 16);
lambda = 10^-5;

[Xtrain, Xtest] = normalize_data(Xtrain, Xtest);
[ytrain, ytest] = normalize_data(ytrain, ytest);
for i=1:16
    % calculate coefficients and bias
    [w b] = train_rls(Xtrain, ytrain, lambda);
    W(:, i) = w;
    % calculate mse
    pred = Xtrain*w + b;
    mseTrain(i) = mean((pred - ytrain).^2);
    pred = Xtest*w + b;
    mseTest(i) = mean((pred - ytest).^2);
    lambda = lambda * 10;
end

figure(1)
for i=1:d
    plot([-5:10], W(i, :),'LineWidth',2.5);
    hold on
end
title("coefficient curves")
xlabel("lg(lambda)")
ylabel("w_i for")
legend({'lcavol','lweight','age','lbph','svi','lcp','gleason','pgg45'})
figure(2)
plot([-5:10], mseTrain, 'LineWidth', 2.5);
hold on
plot([-5:10], mseTest, 'LineWidth', 2.5);
title("MSE curves")
xlabel("lg(lambda)")
ylabel("MSE on")
legend({'training set','testing set'})
