clear

cd '/Users/johanatch/Desktop/Homework 4/Angelos'


% Parameters
begin = 1973;           %Begining of the sample
final = 1991;           %End of sample
T = final-begin+1;      %Number of periods
A = 24:65;              %Set of possible ages

% Load vector of IDs
load id.txt
N = length(id);         %Number of individuals in the dataset 

% Load data
load age_distribution.txt

year_data = age_distribution(:,1);
possible_ages = unique(age_distribution(:,2));

% Shock Parameters 
% sigma_eta = 1;
% sigma_e = 1;
% sigma_a = 1;
% rho = 0.85;


% Allocate arrays to the simulated paths for each ID
y_sim = zeros(N, length(A));
z_sim = zeros(N, length(A));

for i=1:N
    alpha = normrnd(0,sigma_a);         %Create fixed effects 
    for m=2:length(A)+1                 % Start from age 25 (zi_24 = 0) 
            
        %Generate random shocks for each obs
        eta = normrnd(0,sigma_eta);
        eps = normrnd(0,sigma_eta);
          
        % Fill the vector of simulated data
        z_sim(i,m) = rho*z_sim(i,m-1) + eta;
        y_sim(i,m) = alpha + z_sim(i,m) + eps;   
            
   end
end

y_sim=y_sim(:,2:length(A));
z_sim=z_sim(:,2:length(A));

%Import data matrices 
matrix_year_id = dlmread('matrix_year_id.csv', ';');
matrix_year_id = matrix_year_id';

data_sim = zeros(N, T);

for t=1:T
    
    % Who are the IDs that show up at time t? 
    find_id = find(matrix_year_id(:, t)>0);
    
    for i = 1:length(find_id)
    
    %At year t, how old are those individuas i? 
    age = matrix_year_id(find_id(i),t);
    
    %What is the corresponding index of age?
    index_age = find(age==possible_ages);
    
    %compute variance among all those:
    data_sim(find_id(i), t) = y_sim(find_id(i), index_age);
    
    end
end





