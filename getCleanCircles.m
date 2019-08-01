%
% GETCLEANCIRCLES.M
% Read circles from a file, clean out any with impossible
% angles, and convert to the form expected by downstream
% analysis.
%
% INPUT: name of file with list of circles, each of form
%          x y z eta dEtaSq
% where [x y z] is center vector, eta is cosine of opening angle, and 
% dEtaSq is variance in eta.
%
% RETURNS: cell array of {[x y z], alpha, sigmasq}
% where [x y z] is center vector, alpha is opening angle, and
% sigmasq is variance in alpha.
%
function circles = getCleanCircles(filename)
  fileID = fopen(filename, 'r');

  formatSpec = '%f %f %f %f %f';
  C = textscan(fileID, formatSpec);

  fclose(fileID);

  C =  C';

  % eliminate circles with invalid or nearly 0 angles
  mask = find(abs(C{4}) < 0.99999);

  x = C{1}(mask);
  y = C{2}(mask);
  z = C{3}(mask);  
  eta = C{4}(mask);
  dEtaSq = C{5}(mask);

  % make sure all circle centers are unit vectors,
  % to correct any errors caused by limited-precision
  % in text-based input
  center_c = [x y z];
  center_c = center_c ./ sqrt(sum(center_c.^2,2));

  % get actual opening angle and its variance
  alpha   = acos(eta);
  sigmasq = dEtaSq./(1 - eta.^2);

  circles = {center_c, alpha, sigmasq};
end  