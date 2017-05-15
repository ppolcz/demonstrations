function [g1,g2,g3] = vekanal_plot_sym_curve(gamma, t, trange, varargin)
%%
%
%  file:   vecanal_plot_sym_curve.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2016.09.29. Thursday, 22:46:50
%

dim = numel(gamma);

if dim == 2
    ip.plotter = @plot;
elseif dim == 3
    ip.plotter = @plot3;
end

ip.visualize = true;
ip.resolution = 100;
ip.args = {};
ip.norms = false;
ip.tangs = false;
ip.divizor = 3;
ip = parsepropval(ip, varargin{:});

dummy = sym('dummy', 'real');

if numel(gamma) == 2
    gamma = [gamma ; 0];
end
gamma = gamma + dummy;

g1_fh = matlabFunction(gamma(1), 'vars', {t , dummy});
g2_fh = matlabFunction(gamma(2), 'vars', {t , dummy});
g3_fh = matlabFunction(gamma(3), 'vars', {t , dummy});

tt = linspace(trange(1),trange(end),ip.resolution(1));
dummy_num = tt * 0;

tt_small = tt(1:ip.divizor:end);
dummy_num_small = dummy_num(1:ip.divizor:end);

g1_ = g1_fh(tt,dummy_num);
g2_ = g2_fh(tt,dummy_num);
g3_ = g3_fh(tt,dummy_num);

g1_small = g1_fh(tt_small,dummy_num_small);
g2_small = g2_fh(tt_small,dummy_num_small);
% g3_small = g3_fh(tt_small,dummy_num_small);

if ip.visualize
    if dim == 2
        ip.plotter(g1_,g2_, ip.args{:});

        if ip.norms
            dG = diff(gamma, t);
            n1 = matlabFunction(-dG(2) + dummy, 'vars', {t , dummy});
            n2 = matlabFunction(dG(1) + dummy, 'vars', {t , dummy});

            nn1 = n1(tt_small,dummy_num_small);
            nn2 = n2(tt_small,dummy_num_small);
%             r = sqrt(nn1.^2 + nn2.^2);
%             nn1 = nn1./r;
%             nn2 = nn2./r;
            quiver(g1_small, g2_small, nn1, nn2);
        end

    elseif dim == 3
        ip.plotter(g1_,g2_,g3_, ip.args{:});
    end
end

if nargout > 0
    g1 = g1_;
end

if nargout > 1
    g2 = g2_;
end

if nargout > 2
    g3 = g3_;
end

end