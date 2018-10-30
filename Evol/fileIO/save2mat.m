
function save2mat (out_path, out_name, arg1, arg2, arg3, arg4, arg5)

currdir = pwd;
[s,mess,messid] = mkdir(out_path);
cd(out_path)

if nargin == 3; save(out_name,'arg1');
elseif nargin == 4; save(out_name,'arg1','arg2');
elseif nargin == 5; save(out_name,'arg1','arg2','arg3');
elseif nargin == 6; save(out_name,'arg1','arg2','arg3','arg4');
elseif nargin == 7; save(out_name,'arg1','arg2','arg3','arg4','arg5');
else
    fprintf ('Too many input variables!');
end
cd (currdir)

end