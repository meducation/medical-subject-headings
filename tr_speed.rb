require_relative 'lib/MESH'

puts DateTime.now
MESH::Heading.configure(filename: 'data/mesh_data_2014/d2014.bin.gz')
puts DateTime.now
MESH::Heading.translate('en-GB', MESH::Translator.new(MESH::Translator.enus_to_engb))
puts DateTime.now

