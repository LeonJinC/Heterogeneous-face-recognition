close all;
clc;
nirImRoot = 'E:/CASIA/NIRnVIS/Cropped/training/nir/';
nir_name='00001';
nirImpath=[nirImRoot nir_name '_a.jpg'];


N=100;
cell_size=20;
radii=3;
nirIm = imread(nirImpath);
[nir_lbp_image,lbp_nirfeature]=testlbp(nirIm,N,cell_size,radii);

function [ulbpImage,descriptors] = testlbp(image,N,cell_size,radii)
    image=imresize(image,[N N]);
    if size(image,3)~=1
        image=rgb2gray(image);
    end
    srcIm=image;
    figure('position',[1000,1000,100,100]),imshow(srcIm);title('srcImage');
    
    image=mat2gray(image);
   
    p=floor(N/cell_size)^2*59;
    descriptors= extractLBPFeatures(image, 'CellSize',[cell_size cell_size],'Radius', radii);
    
    table=lbp59();
    Im=double(image);
    m=zeros(1,8);
    [row,col]=size(Im);
    for i=1+radii:row-radii
       for j=1+radii:col-radii
           temp=0;
           m(1,1)=Im(i-radii,j-radii)>Im(i,j);
           m(1,2)=Im(i-radii,radii)>Im(i,j);
           m(1,3)=Im(i-radii,j+radii)>Im(i,j);
           m(1,4)=Im(i,j+radii)>Im(i,j);
           m(1,5)=Im(i+radii,j+radii)>Im(i,j);
           m(1,6)=Im(i+radii,j)>Im(i,j);
           m(1,7)=Im(i+radii,j-radii)>Im(i,j);
           m(1,8)=Im(i,j-radii)>Im(i,j); 
           for n=1:8
               temp=temp+m(1,n).*2^(n-1);
           end
           ulbpImage(i,j)=table(temp+1);
       end
    end
    
    figure('position',[1500,1000,100,100]),imshow(uint8(ulbpImage));title('UniformLBP');
end

function [ out] = lbp59( )
table=zeros(1,256);
temp=1;
for i=1:256
    if gapcount(i-1)<=2
        table(i)=temp;
         temp=temp+1;
    end
end
out=table;
end

function [ out ] = gapcount( in )%计算跳变次数
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
a=zeros(1,8);
flag=0;
k=8;
while in>0&&k>0         %将10进制转换为2进制
    a(1,k)= bitand(in,1);%位与运算,相当于C++里面的&运算
    in=floor(in/2);      %matlab默认为是double，因此需要强制转换
    k=k-1;   
end
for i=1:7
    if a(i)~=a(i+1)
        flag=flag+1;
    end
end
out=flag;
end
