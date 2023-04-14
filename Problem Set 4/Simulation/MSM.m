function resid = MSM(Targeted_moments,W,Theta, matrix_year_id_T, N, possible_ages, logic)
%This function calculate the objective function to be minimize for the GMM
%estimation
%Inputs: Targeted_moments =  Cov matrix from PSID data
%        W Weithening matrix
%        Theta = parameter to evaluate the simulation
%        data = Demography matrix
%        M = Number of simulations for avering moments
%        logic_b = Logical matrix of data to have the same structure

% Output: Resid= Obsejtive function evaluated at Theta

%Get the simulated momments
h= moments_simulation(Theta, matrix_year_id_T, N, possible_ages, logic);

%Calcualte the obsejctive function
resid = (Targeted_moments-h)'*W*(Targeted_moments-h);

end
