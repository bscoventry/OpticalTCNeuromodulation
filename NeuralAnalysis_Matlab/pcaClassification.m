data = readtable('PSTHdata.csv');
data = table2array(data);
[coeff,score,latent,tsquared,explained,mu] = pca(data);
%Plot the two top PCs
dataRed = score(:,1:3);
labels = readtable('ClassLabels.csv');
labels = table2cell(labels);
labelsWords = cell(1);
labelsWords{1} = 'Onset+Inhib';
labelsWords{2} = 'OnSus+Inhib';
labelsWords{3} = 'OnSus';
labelsWords{4} = 'Sus+Inhib';
labelsWords{5} = 'Onset';
labelsWords{6} = 'Offset';
labelsWords{7} = 'Sus';
plotpoints = ['o','+','*','X','|','^','.'];
plotcolors = ['b','r','g','k','y','m','o'];
[rows,~]=size(data);
trueLabels = cell(1);
for ck = 1:rows
    trueLabels{ck} = labelsWords{labels{ck}+1};
end

% [rows,~]=size(data);
figure(1)

gscatter3(dataRed(:,1),dataRed(:,2),dataRed(:,3),trueLabels)%scatter(dataRed(ck,1),dataRed(ck,2),[],plotcolors(labels{ck}+1))%,[],plotpoints(labels{ck}+1));
xlabel('VarExplained - 55.14%')
ylabel('VarExplained - 7.41%')
zlabel('VarExplained - 4.13%')
legend(labelsWords)