function F= vec(X)
%This Function vectorize an axb matrix into an (axb)x1 vector
%Input:nxm matrix
%Output:(axb)x1 vector

[a,b]=size(X);
F=reshape(X,[a*b,1]);
end