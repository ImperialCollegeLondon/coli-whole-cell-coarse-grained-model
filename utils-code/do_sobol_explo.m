function do_sobol_explo( explo_file_path , n_save_every , n_stop , func , x_min , x_max)

%
if exist(explo_file_path,'file')
    explo = load(explo_file_path);
    explo = explo.explo;
    if length(explo.data) >= n_stop; return; end
else
    explo.x_min = x_min;
    explo.x_max = x_max;
    explo.func = func;
    explo.data = struct('x',{},'fx',{});
    save(explo_file_path,'explo');
end

%
sob = sobolset(length(explo.x_min));
while true
    for i=1:n_save_every
        i_sobol = length(explo.data) + 1
        p = sob(i_sobol,:);
        x = explo.x_min + p .* (explo.x_max - explo.x_min);
        explo.data(end+1) = struct('x',x,'fx',explo.func(x));
        if length(explo.data) >= n_stop
            save(explo_file_path,'explo');
            return;
        end
    end
    save(explo_file_path,'explo');
end

end

