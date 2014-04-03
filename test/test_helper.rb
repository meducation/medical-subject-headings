gem "minitest"
require "minitest/autorun"
require "minitest/pride"
require "minitest/mock"
require "mocha/setup"

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "MESH"

puts 'Configuring MESH::Mesh — this may take up to 10 seconds.'
start = Time.now
MESH::Mesh.configure(filename: File.expand_path('../../data/mesh_data_2014/d2014.bin.gz', __FILE__))
finish = Time.now
configuration_time = finish - start
raise 'MESH::Mesh should configure in less than 10 seconds.' unless configuration_time < 10

puts 'Translating MESH::Mesh into English ;) — this may take up to 60 seconds.'
start = Time.now
MESH::Mesh.translate('en-GB', MESH::Translator.new(MESH::Translator.enus_to_engb))
finish = Time.now
configuration_time = finish - start
puts "took #{configuration_time}"
#raise 'MESH::Mesh should translate in less than 30 seconds.' unless configuration_time < 60
