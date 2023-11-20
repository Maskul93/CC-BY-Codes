X = readmatrix('./data/Random_Clusters.csv');

% Cluster Number
K = 2; 

% Cluster Names
for i = 1 : K
    C_names(i,1) = {['C', num2str(i)]};
end

% -- Stage 1 -- % 
C = init_centroids(X, K);
CLUSTERS = determine_clusters(X, C, K, C_names);
C = update_centroids(C, CLUSTERS, C_names);

% -- Main Routine -- %
stop = false;
n_iter = 1;

while stop == false
    
    CLUSTERS = determine_clusters(X, C, K, C_names);
    C_old = C;
    C = update_centroids(C, CLUSTERS, C_names);

    if isequal(C_old, C)
        stop = true;
    end

    n_iter = n_iter + 1;
end

%%% -- The other functions are here! -- %%%

function C = update_centroids(C, CLUSTERS, C_names)
% ------------------------------------------------------------------------
% Input:
%   · C = Cluster Centroids Coordinates [K x N]
%   · CLUSTERS = Structure containing Clusters and their relative elements
%   · C_names = Clusters Names (cell array [K x 1])
% Output:
%   · C = Updated Cluster Centroids Coordinates [K x N]
% ------------------------------------------------------------------------

for j = 1 : length(C_names)
    C(j,:) = mean(CLUSTERS.(C_names{j}));
end

end

function C = init_centroids(X, K)
% -----------------------------------------------------------------------
% Input:
%   · X = Sample Coordinates [p x N]
%   · K = Cluster Number [1 x 1]
% Output:
%   · C = Cluster Centroids Coordinates [K x N]
% -----------------------------------------------------------------------

for i = 1 : K
    C(i, :) = X(randi([1, length(X)], 1), :);
end

end

function CLUSTERS = determine_clusters(X, C, K, C_names)
% ------------------------------------------------------------------------
% Input:
%   · X = Sample Coordinates [p x N]
%   · C = Cluster Centroids Coordinates [K x N]
%   · K = Cluster Number [1 x 1]
%   · C_names = Clusters Names (cell array [K x 1])
%
% Output:
%   · CLUSTERS = Structure containing Clusters and their relative elements
% ------------------------------------------------------------------------

cnt = ones(1, K); % Counter array to be updated "Clusterwise"

% Run throughout the samples
for i = 1 : length(X)

    % Compute distances between i-th sample and the j-th Centroid
    for j = 1 : K
        d(i, j) = norm(X(i,:) - C(j,:));
    end
    % Extract Cluster as the index where the minumum distance is
    [~, Cn] = min(d(i,:));
    % Assign the sample to the extracted cluster
    CLUSTERS.(C_names{Cn})(cnt(Cn),:) = X(i,:);
    cnt(Cn) = cnt(Cn) + 1; % Update counter
end

end