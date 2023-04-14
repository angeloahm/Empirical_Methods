function [moments,BIG_COV]= get_moments_data(DATA,logic_b)

Y_panel_final=DATA;
T=size(DATA,1);
%Calculate the statistics/moments
for i=1:T
    for j=1:T
        get_logical= logic_b(i,:)==1 & logic_b(j,:)==1; %Get observations that satisfy conditions
        x_1=Y_panel_final(i,get_logical);
        x_2=Y_panel_final(j,get_logical);
        a=cov(x_1,x_2);
        BIG_COV(i,j)=a(1,2) ; %Fill big matrix
    end
end

moments= vec(tril(BIG_COV));
end