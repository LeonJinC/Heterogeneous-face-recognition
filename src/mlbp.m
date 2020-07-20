function descriptors = mlbp(image,N,cell_size)
%     image=imresize(image,[N N]);
%     if size(image,3)~=1
%         image=rgb2gray(image);
%     end
%     image=mat2gray(image);
    
    if cell_size==16
        radii = [1,3,5,7];
    end
    
    if cell_size==8
        radii = [1,2,3];
    end
    
    if cell_size==3
        radii = [1];
    end
    
    p=floor(N/cell_size)^2*59;
    descriptors = zeros(length(radii),p);
    
    for r = 1:length(radii)
        descriptors(r,:) = extractLBPFeatures(image, 'CellSize',[cell_size cell_size],'Radius', radii(r));
    end
    
    descriptors = reshape(descriptors,[],1);
end