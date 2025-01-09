function  [error,model_closestP] = find_closest_points(data_regression,model)
% compare the new set of data with the model by computing the closest points
% model_closestP(i,:) are the coordinates of the closest point in the model set
% corresponding to the i-th point in the data_regression set
% error is the average minimum distance between closest points

% size of model_closestP equals to size(data_regression)
model_closestP = ones(size(data_regression));
% set the initial min distance to inf
min_dist = inf*ones(size(data_regression,1),1);

for i = 1:size(data_regression,1) % loop through each point in data_regression
    for j = 1:size(model,1) % loop through each point model  
        d = norm(model(j,:) - data_regression(i,:)); % compute the distance
        % update the min distance if the current distance is smaller than
        % the previous min distance
        if d < min_dist(i) 
            min_dist(i)=d;
            % update the founded closest point from the model to model_closestP
            model_closestP(i,:) =  model(j,:);
        end
    end
end
% error is the average minimum distance between closest points
error = mean(min_dist);
