function bearings = calcBearing(V, W)
    %{
    This function calculates the bearings of points W with respect to V.
    %}  

    C = vcross(V, W);
    C_perp = [V(2), -V(1), 0];  % cross(V,[0,0,1])
    Cprod = -vcross(C_perp, C); % C cross C_perp
    sinTheta = sqrt(vnormsq(Cprod)) .* sign(vdot(V, Cprod));
    cosTheta = vdot(C_perp, C);
    bearings = atan2(sinTheta, cosTheta);
end
