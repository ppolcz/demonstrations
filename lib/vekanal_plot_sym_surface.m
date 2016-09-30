function [s1,s2,s3] = vekanal_plot_sym_surface(s, u, v, urange, vrange, varargin)
%% 
%  
%  file:   pcz_plot_sym_surface.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.29. Thursday, 21:30:48
%

ip.visualize = true;
ip.resolution = 20;
ip.plotter = @surf;
ip.args = {};
ip.norms = false;
ip = parsepropval(ip, varargin{:});

dummy = sym('dummy', 'real');

s = s + dummy;

s1_fh = matlabFunction(s(1), 'vars', {u , v , dummy});
s2_fh = matlabFunction(s(2), 'vars', {u , v , dummy});
s3_fh = matlabFunction(s(3), 'vars', {u , v , dummy});

[uu,vv] = meshgrid(...
    linspace(urange(1),urange(end),ip.resolution(1)), ...
    linspace(vrange(1),vrange(end),ip.resolution(end)));

dummy_num = uu * 0;

s1_ = s1_fh(uu,vv,dummy_num);
s2_ = s2_fh(uu,vv,dummy_num);
s3_ = s3_fh(uu,vv,dummy_num);

if ip.visualize
    ip.plotter(s1_,s2_,s3_, ip.args{:});    
end

if nargout > 0
    s1 = s1_;
end

if nargout > 1
    s2 = s2_;
end

if nargout > 2
    s3 = s3_;
end

end