function cpp_call_command = call_cpp_program ( path2bin , params )

% assemble command
cpp_call_command = [ './' path2bin ] ;
fields = fieldnames ( params ) ;
for i = 1:numel(fields)
    cpp_call_command = strcat ( cpp_call_command , [ ' -' fields{i} ' ' num2str(params.(fields{i})) ] ) ;
end

% run command
system ( cpp_call_command ) ;

end

