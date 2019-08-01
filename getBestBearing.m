function [randomCircle, bearing] = getBestBearing(A, bins)
    nCircles = size(A,1);

    % Pick one random circle
    randomIndex = randi(nCircles);
    randomCircle = A(randomIndex,:);

    c1     = randomCircle(1:3);
    alpha1 = randomCircle(4);
    sigmasq1 = randomCircle(5);

    c2     = A(:,1:3);
    alpha2 = A(:,4);
    sigmasq2 = A(:,5);

    % Check the distances between centers of circles
    q = vdot(c1, c2);
    
    % Select circles that are intersecting or close but are
    % neither identical nor antipodal.
    dist = acos(q);
    err = 3*sqrt(min(sigmasq1, sigmasq2));
    mask = ((dist <= alpha1 + alpha2 + err) & ...
            (dist >= abs(alpha1 - alpha2) - err) & ...
            (abs(abs(q) - 1) > 1e-6));

    % If circle has too few neighbors, it is probably bad    
    if sum(mask) < 0.7 * (nCircles - 1)
          randomCircle = [];
          bearing = 0;
          return;
    end

    c2     = c2(mask,:);
    alpha2 = alpha2(mask);
    q      = q(mask);

    % determine if circles (c1, alpha) and (c2, alpha2) intersect
    a = cos(alpha1) - cos(alpha2) .* q;
    b = cos(alpha2) - cos(alpha1) .* q;
    x0 = (a .* c1 + b .* c2) ./ (1 - q.^2);
    disc = 1 - vnormsq(x0);
    isect = (disc > 0);

    % Calculate bearings for intersecting circles
    n = vcross(c1, c2);
    t = sqrt(disc(isect) ./ vnormsq(n(isect,:)));
    del = t .* n(isect,:);
    w1 = x0(isect,:) + del;
    w2 = x0(isect,:) - del;
    theta_1 = calcBearing(c1, w1);
    theta_2 = calcBearing(c1, w2);

    % Calculate bearings for non-intersecting but nearby circles
    theta_nearby = calcBearing(c1, c2(~isect,:));

    % Append everything in one matrix
    Data = [theta_1; theta_2; theta_nearby]; 

    % return a bearing in the middle of the maximum bin
    Y = discretize(Data, bins);
    maxBin = mode(Y); % bin with maximum hits
    bearing = 2*pi*(maxBin-0.5)/length(bins) - pi;
end
