function res = kld(x1,x2)
x1 =x1 / sum(x1);

res = zeros(1,size(x2,1));
for i=1:size(x2,1)
    xx2 =x2(i,:) / sum(x2(i,:));
    res(i) =  sum(x1.* log(x1./max(xx2,0.000001)) );
end

end