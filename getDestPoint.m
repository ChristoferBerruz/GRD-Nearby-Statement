function W = getDestPoint(S, dist, bearing)
    %{
       Calculate the coordinates of the point W reached
       by starting from S and going an (arclength) distance
       dist on a given initial bearing.
    %}
    de = cross([0 0 1], S); 
    de = de ./ norm(de);
    dn = cross(S, de);
    d = dn .* cos(bearing) + de .* sin(bearing);
    W = S .* cos(dist) + d .* sin(dist);
end