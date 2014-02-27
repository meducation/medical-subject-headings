gem "minitest"
require "minitest/autorun"
require "minitest/pride"
require "minitest/mock"
require "mocha/setup"

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "MESH"

start = Time.now
MESH::Mesh.configure(filename: File.expand_path('../../data/mesh_data_2014/d2014.bin.gz', __FILE__))
finish = Time.now
configuration_time = finish - start
raise 'MESH::Mesh should configure in less than 10 seconds.' unless configuration_time < 10
