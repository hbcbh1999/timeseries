function h = switch_to_composite_unity_gauge(h_in)

% descrip: For zero-gain impulse functions, this function changes the gauge
%          so that the sum of positive values is unity, and therefore, by
%          symmetry, the negative arm has unit gain.

S = sum(h_in(h_in>0));
h = h_in / S;
