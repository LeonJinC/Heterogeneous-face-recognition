function [phiSet]=loadTrainData(DataSet,N,cell_size,m,difference)

% DataSet='Cropped';%withoutGLASS %Cropped %CASIANEW128
% N=100;
% cell_size=16;
% m=30;
% difference='ImDiff';%FeatureDiff %ImDiff


train_visImRoot = ['E:/CASIA/NIRnVIS/' DataSet '/training/vis/'];
train_nirImRoot = ['E:/CASIA/NIRnVIS/' DataSet '/training/nir/'];
train_visImFiles = dir(train_visImRoot);

phiSet=[];
if strcmp(DataSet,'withoutGLASS')
    K=173;
end

if strcmp(DataSet,'CASIANEW128v2')||strcmp(DataSet,'Croppedv4')
    K=357;
end


k=0;
fprintf('开始读取->训练图片数据\n');
for i = 1:size(train_visImFiles,1)
    if not(strcmp(train_visImFiles(i).name,'.')|strcmp(train_visImFiles(i).name,'..'))
        if k==K
            break;
        end
        k=k+1;
        fprintf('now step: %d / %d\n',k,K);
        mainname=train_visImFiles(i).name(1:end-4);
        
        visImpath = [train_visImRoot mainname '.jpg'];
        visIm = imread(visImpath);
        X={};
        count=1;
        X{1,count}=visIm;
        for j=0:4
            count=count+1;
            nirImpath=[train_nirImRoot mainname '_' char(j+97) '.jpg'];
            nirIm = imread(nirImpath);
            X{1,count}=nirIm;
        end
        
        for kk=1:6
            x_kk=X{1,kk};
            x_kk=imresize(x_kk,[N N]);
            if size(x_kk,3)~=1
                x_kk=rgb2gray(x_kk);
            end
            X{1,kk}=mat2gray(x_kk);
        end
            
        if m==5
            for kk=2:6
                kk_x=X{1,kk};
                ll_x=X{1,1};
                if strcmp(difference,'ImDiff')
                    phiIm=mat2gray(kk_x-ll_x);
                    phifeature=mlbp(phiIm,N,cell_size);
                    
                end
                if strcmp(difference,'FeatureDiff')
                    kk_feature=mlbp(kk_x,N,cell_size);
                    ll_feature=mlbp(ll_x,N,cell_size);
                    phifeature=kk_feature-ll_feature;
                    
                end
                
                phiSet=[phiSet phifeature];

            end 
        end
        
        if m==30
            if strcmp(difference,'FeatureDiff')
                for kk=1:6
                    kk_x=X{1,kk};
                    kk_feature=mlbp(kk_x,N,cell_size);
                    for ll=1:6
                        if(kk==ll)
                            continue;
                        end
                        ll_x=X{1,ll};
                        ll_feature=mlbp(ll_x,N,cell_size);
                        phifeature=kk_feature-ll_feature;
                        phiSet=[phiSet phifeature];
                    end
                end
            end
            if strcmp(difference,'ImDiff')
                for kk=1:6
                    kk_x=X{1,kk};
                    for ll=1:6
                        if(kk==ll)
                            continue;
                        end
                        ll_x=X{1,ll};
                        phiIm=mat2gray(kk_x-ll_x);
                        phifeature=mlbp(phiIm,N,cell_size);
                        phiSet=[phiSet phifeature];
                    end
                end
            end
            
            
        end
        
       

    end
end
fprintf('读取结束\n');
save(['phiSet@' DataSet '---N' num2str(N) '-cellsize' num2str(cell_size) '-m' num2str(m) '-K' num2str(K) '-' difference],'phiSet');

end