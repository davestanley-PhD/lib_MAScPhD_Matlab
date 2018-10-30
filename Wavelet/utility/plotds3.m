
function plotds3 (varargin)

    ds = varargin{1};
    t = varargin{2};
    x = varargin{3};
    
    t = downsample(t,ds);
    x = downsample(x,ds);
    
    plot(t,x,varargin{4:end});
            

end