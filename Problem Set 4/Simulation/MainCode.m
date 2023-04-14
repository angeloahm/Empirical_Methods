%%%Main Code
clear 
cd '/Users/johanatch/Desktop/Homework 4/Final/Simulation'

% Get data
run read_wages.m
wagedata = table2array(wagedata);
%wagedata = wagedata';

run read_ages.m
matrix_year_id= table2array(agedata);
%matrix_year_id = dlmread('matrix_year_id.csv', ';');

load age_distribution.txt

%Get Logical matrix with observations (1 if there is an observation, 0
%otherwise)
logic=logical(matrix_year_id>0);

%Get Cov. Matrix
[Targeted_moments,BIG_COV]= get_moments_data(wagedata,logic);

year_data = age_distribution(:,1);
possible_ages = unique(age_distribution(:,2));
N = size(wagedata,2);
matrix_year_id_T = matrix_year_id';

% Initial Shock Parameters 
sigma_eta = 0.2;
sigma_e = 0.26;
sigma_a = 0.37;
rho = 0.85;
Theta=[sigma_eta, sigma_e, sigma_a, rho];
%0.203009150342060	0.263622873601930	0.364313242878106	0.843177330992189

%Simulation_moments = moments_simulation(Theta, matrix_year_id_T, N, possible_ages, logic);


%Weigthing Matrix
W=eye(length(Targeted_moments));

%Define Function to be minimmize. 
resid = MSM(Targeted_moments,W,Theta, matrix_year_id_T, N, possible_ages, logic);
options = optimset('PlotFcns',@optimplotfval);
%Start minimization routine
[x,fval,exitflag,output] = fminsearch(@(f) MSM(Targeted_moments,W,f, matrix_year_id_T, N, possible_ages, logic),Theta,options);

%Get parameter
Theta_bar=[x(1),x(2),x(3),x(4)];

% %Get the implied Var Cov Matrix
Simulation_moments = moments_simulation(Theta_bar, matrix_year_id_T, N, possible_ages, logic);
Big_COV_simul= reshape(Simulation_moments,[19,19]);
BIG_COV2 = reshape(Targeted_moments,[19,19]);

To_save=struct;
To_save.parameter=Theta_bar;
To_save.Data_var_cov=BIG_COV2;
To_save.Estimated_var_cov=Big_COV_simul;

save('Results.mat', '-struct', 'To_save');

var_data =  diag(BIG_COV2);
var_sim = diag(Big_COV_simul);
years = linspace(1973,1991,19);

figure;  
    plot(years, var_data', 'r');
    hold on 
    plot(years, var_sim', 'b');
    title('Cross Sectional Variance by Year', 'FontSize', 16);
    legend({'Data','Simulation'}, 'Fontsize', 14)
    xlabel('Years', 'FontSize', 12);
    fontsize(gca, 12,'points');
    ylim([0 0.5]);

cov_data = BIG_COV2(:,1);
cov_sim = Big_COV_simul(:,1);

figure;  
    plot(years, cov_data', 'r');
    hold on 
    plot(years, cov_sim', 'b');
    title('Cov(y_{1973}, y_t)', 'FontSize', 16);
    legend({'Data','Simulation'}, 'Fontsize', 14)
    xlabel('Years', 'FontSize', 12);
    fontsize(gca, 12,'points');
    ylim([0 0.5]);