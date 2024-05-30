file_path = ARGV[0]
file = File.new(file_path, 'r')

line_type = ""
until line_type == "END_METABOCARD" do
  line = file.gets
  print line
  if line =~ /^#(\w+)/
    line_type = $1
  end
end
