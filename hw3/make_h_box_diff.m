function h = make_h_box_diff(Nbox, Nwindow)

% descrip:  returns a differencer impulse response where the positive
%           and negative arms are equal-length boxes.

h = zeros(Nwindow, 1);
h(1:Nbox)        = 1 / Nbox;
h(Nbox+1:2*Nbox) = - 1 / Nbox;
h = h(:);



