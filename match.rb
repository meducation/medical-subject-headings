require_relative 'lib/MESH'

MESH::Mesh.configure(filename: 'data/mesh_data_2014/d2014.bin.gz')
nu_file = File.open('not_useful.txt')
nu_file.each_line do |line|
  id, name = line.split(', ')
  MESH::Mesh.find(id).useful = false
end

