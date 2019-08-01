function r = vcross(v, w);
   i = v(2) * w(:,3) - v(3) * w(:,2);
   j = v(3) * w(:,1) - v(1) * w(:,3);
   k = v(1) * w(:,2) - v(2) * w(:,1);
   r = [i, j, k];
end

