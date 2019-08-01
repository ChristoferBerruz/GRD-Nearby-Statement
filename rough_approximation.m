function err = rough_approximation(circles)
  N = 360;
  bins = -pi:2*pi/N:pi;

  testSize = 30;
  W = zeros(testSize, 3);
  nc = 1;
  while nc <= testSize
    [randomCircle, bearing] = getBestBearing(circles, bins);
    if ~isempty(randomCircle)
        W(nc,:) = getDestPoint(randomCircle(1:3), randomCircle(4), bearing);
        nc = nc + 1;
    end
  end

  % pos is the average of all computed directions -- our actual guess 
  % at the source
  s = sum(W);
  pos = s/norm(s);

  err = rad2deg(acos(-pos(3))); % measure angular err in pos vs [0 0 -1]
end
