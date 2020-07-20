function [onehot]=getonehot(index,totalclass)
    onehot=zeros(totalclass,1);
    onehot(index,1)=1;
end