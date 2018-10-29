function metadata = parse_metadata(metadata_file)

fid = fopen(metadata_file, 'r');

while ~feof(fid)
    line = fgets(fid);
    line_data = strsplit(line, '\t');
    eval([ 'metadata.' line_data{1} ' = strtrim(line_data{2});' ]);
end

metadata.status = 'OK';

fclose(fid);

end

