require_relative 'test_helper'

module MESH
  class TestBase < Minitest::Test

    def initialize arg
      super
      @@mesh_tree ||= MESH::Tree.new
      @@mesh_tree.load_translation(:en_gb)
      @@mesh_tree.load_wikipedia
    end

  end
end
