DataSet='CASIANEW128';%withoutGLASS %Cropped %CASIANEW128
% max_rank=358;

K_set=[200,358];
random_set={'random','sort'};
line_types=['b' 'g' 'r' 'y'];


count=0;
for i=1:2
    for j=1:2
        count=count+1;
        K=K_set(i);
        random=random_set{j};
        resultname=['Result@' DataSet '---N256-cellsize16-m5' '-K' num2str(K) '-FeatureDiff-None-' random ];
        fprintf(resultname);
        fprintf('\n');
        load(resultname);
        plotcmc(K,DISTANCE,line_types(count));
       
    end
end

function plotcmc(max_rank,DISTANCE,lt)
    [~,index]=sort(DISTANCE,2);
    resulty=zeros(max_rank,1);
    resulty(:)=1:max_rank;
    
    rank_value=zeros(max_rank,1);
    cmc_correct=0;
    for r=1:max_rank
        cmc_correct=cmc_correct+sum(index(:,r)==resulty(:));
        accuracy=cmc_correct/max_rank*100;
        rank_value(r,1)=accuracy;
    end
    
    
%     plot([1:10:max_rank],rank_value(1:10:end));
%     hold on;
    plot([1:10:max_rank],rank_value(1:10:end),lt,'LineWidth',2);
    hold on;
%     legend(['N' numstr(N) '+' 'cellsize' numstr(cellsize)])
    axis([1 max_rank 0 100])
    
end