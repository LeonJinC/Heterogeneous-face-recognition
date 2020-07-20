
DataSet='CASIANEW128v2';%withoutGLASS %Cropped %CASIANEW128
N=128;
cell_size=8;
m=5;
difference='FeatureDiff';%FeatureDiff %ImDiff
kernel='None';%None %Gauss
sigma2=100000;
random='random';%random %sort


if strcmp(DataSet,'withoutGLASS')
    K=173;
end

if strcmp(DataSet,'CASIANEW128v2')||strcmp(DataSet,'Croppedv4')
    K=357;
    TEST_K=358;
end

% loadTrainData(DataSet,N,cell_size,m,difference);
loadTestData(DataSet,N,cell_size,TEST_K,random);

loadPhi=['phiSet@' DataSet '---N' num2str(N) '-cellsize' num2str(cell_size) '-m' num2str(m) '-K' num2str(K) '-' difference];
load(loadPhi);
loadTest=['test@' DataSet '---N' num2str(N) '-cellsize' num2str(cell_size) '-K' num2str(TEST_K) '-' random];
load(loadTest);

X=[test_G phiSet];
Y=[test_L zeros(size(test_L,1),size(phiSet,2))];


if strcmp(kernel,'Gauss')
    alpha=Y*pinv(My_Rbf_kernel(X,X,sigma2));
end

if strcmp(kernel,'None')
    alpha=Y*pinv(X'*X);
end

save(['alpha@' DataSet '---N' num2str(N) '-cellsize' num2str(cell_size) '-m' num2str(m) '-K' num2str(TEST_K) '-' difference '-' kernel '-' random],'alpha');
fprintf('hello\n');


tic
loadTest=['test@' DataSet '---N' num2str(N) '-cellsize' num2str(cell_size) '-K' num2str(TEST_K) '-' random];
load(loadTest);
loadalpha=['alpha@' DataSet '---N' num2str(N) '-cellsize' num2str(cell_size) '-m' num2str(m) '-K' num2str(TEST_K) '-' difference '-' kernel '-' random];
load(loadalpha);

correct=0;
DISTANCE=[];

%     if strcmp(kernel,'Gauss')
%         x=alpha*My_Rbf_kernel(X,test_P(:,i),sigma2);
%     end
    
for i=1:size(test_P,2)

    if strcmp(kernel,'None')
        x=alpha*X'*test_P(:,i);
    end
    x=normalize(x-mean(x));
    
    dis=[];
    for j=1:size(test_L,2)
        y=test_L(:,j);
        
        d=norm(x-y);
        
        dis=[dis d];
    end
    DISTANCE=[DISTANCE;dis];
    [~,best]=min(dis);
    if i==best
        correct=correct+1;
    end
end
timespan = toc;
correct=correct/size(test_P,2)*100;

max_rank=size(test_P,2);
[B,index]=sort(DISTANCE,2);
resulty=zeros(size(test_P,2),1);
resulty(:)=1:size(test_P,2);%358*1

rank_value=zeros(max_rank,1);
cmc_correct=0;
for r=1:max_rank
    cmc_correct=cmc_correct+sum(index(:,r)==resulty(:));
    accuracy=cmc_correct/size(test_P,2)*100;
    rank_value(r,1)=accuracy;
end
temprlist=[];
tempr=rank_value(1,1);
for r=1:max_rank
    if rank_value(r,1)-tempr>10
        tempr=rank_value(r,1);
        temprlist=[temprlist r];
    end
end
figure
plot([1:10:max_rank],rank_value(1:10:end));
hold on;
plot([1:10:max_rank],rank_value(1:10:end),'bd');
hold on;
axis([1 max_rank 0 100])

title({loadalpha ['rank1 accuracy = ',num2str(correct),'%']});
saveas(gcf, ['CMC@' DataSet '---N' num2str(N) '-cellsize' num2str(cell_size) '-m' num2str(m) '-K' num2str(TEST_K) '-' difference '-' kernel '-' random], 'jpg')
fprintf('correct: %.2f%% , time: %.2fmin\n',correct,timespan/60);

save(['Result@' DataSet '---N' num2str(N) '-cellsize' num2str(cell_size) '-m' num2str(m) '-K' num2str(TEST_K) '-' difference '-' kernel '-' random] ,'correct','DISTANCE','temprlist');
%     





