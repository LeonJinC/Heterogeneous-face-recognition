function x = normalize(C)
    leg=sqrt(sum(C.^2));
    x=bsxfun(@rdivide,C,leg);
end