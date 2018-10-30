


function [varargout] = plot_matrix3D(varargin)
%       
%     [varargout] = plot_matrix3D(varargin)
%     Alias for plott_matrix3D for backwards compatibility

    varargout = cell(1,nargout);
    [varargout{1:nargout}] = plott_matrix3D(varargin{:});

end