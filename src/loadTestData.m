function [test_P,test_G,test_L ]=loadTestData(DataSet,N,cell_size,TEST_K,random)

%     DataSet='Cropped';%withoutGLASS %Cropped %CASIANEW128
%     N=100;
%     cell_size=16;
    
    
    test_visImRoot = ['E:/CASIA/NIRnVIS/' DataSet '/testing/vis/'];
    test_nirImRoot = ['E:/CASIA/NIRnVIS/' DataSet '/testing/nir/'];
    test_visImFiles = dir(test_visImRoot);
    
    randIndex=[];
    if strcmp(random,'random')
        randIndex = randperm(size(test_visImFiles,1));
        test_visImFiles=test_visImFiles(randIndex,:);
    end


    test_P= [];
    test_G = [];
    test_L=[];

    if strcmp(DataSet,'withoutGLASS')
        K=160;
    end

    if strcmp(DataSet,'CASIANEW128v2')||strcmp(DataSet,'Croppedv4')
        K=TEST_K;
    end
    k=0;
    fprintf('开始读取->测试图片数据\n');
    


    for i = 1:size(test_visImFiles,1)
        if not(strcmp(test_visImFiles(i).name,'.')|strcmp(test_visImFiles(i).name,'..'))
            if k==K
                break;
            end
            k=k+1;
            fprintf('now step: %d / %d\n',k,K);
            mainname=test_visImFiles(i).name;
            nirImpath=[test_nirImRoot mainname];
            nirIm = imread(nirImpath);
            nirIm=imresize(nirIm,[N N]);
            if size(nirIm,3)~=1
                nirIm=rgb2gray(nirIm);
            end
            nirIm=mat2gray(nirIm);
            pfeature=mlbp(nirIm,N,cell_size);
            test_P = [test_P pfeature];
            visImpath = [test_visImRoot mainname];
            visIm = imread(visImpath);
            visIm=imresize(visIm,[N N]);
            if size(visIm,3)~=1
                visIm=rgb2gray(visIm);
            end
            visIm=mat2gray(visIm);
            gfeature=mlbp(visIm,N,cell_size);
            test_G = [test_G gfeature];
            test_L=[test_L getonehot(k,K)];

        end
    end
    fprintf('读取结束\n');
    save(['test@' DataSet '---N' num2str(N) '-cellsize' num2str(cell_size) '-K' num2str(K) '-' random],'test_P','test_G','test_L','randIndex');

end