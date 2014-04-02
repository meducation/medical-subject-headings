require_relative 'test_helper'

module MESH

  class ClassiferTest < Minitest::Test


    def test_it_should_classify_title
      c = MESH::Classifier.new()
      expected = {'A' => MESH::Mesh.find('D005542'), 'H' => MESH::Mesh.find('D000715')}
      assert_equal expected, c.classify(title: 'Posterior forearm muscular anatomy')
    end

    def test_it_should_classify_abstract
      skip
    end

    def test_it_should_classify_content
      skip
    end

    def test_it_should_classify_title_abstract_and_content
      skip
    end

    def test_uses_given_clarifier

    end

  end

end