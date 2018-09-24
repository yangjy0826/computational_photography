% Rescales a homogeneous quantity such that its largest element is 1.
% This is useful for comparing two homogeneous matrices.

function scaled_quantity = fix_homogeneous_scale( quantity )

[~,index] = max( abs( quantity(:) ) );
scaled_quantity = quantity / quantity(index);
