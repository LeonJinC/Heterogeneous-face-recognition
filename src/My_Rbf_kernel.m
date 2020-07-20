function [ K ] = My_Rbf_kernel( a, b, sigma2 )
    K = [];
    iLen = size(a,2);
    jLen = size(b,2);
    for iCount=1:iLen
        for jCount=1:jLen
            K(iCount,jCount) = exp ( -( norm(a(:,iCount)-b(:,jCount)).^2./sigma2 ));   
%             K(iCount,jCount) = exp ( -( norm(a(:,iCount)-b(:,jCount))./sigma2 ));  
%             K(iCount,jCount) = sqrt(  norm(a(:,iCount)-b(:,jCount))+sigma2 );  
        end
    end
end