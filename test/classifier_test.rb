require_relative 'test_helper'

module MESH

  class ClassiferTest < Minitest::Test

    def test_it_should_classify_title
      c = MESH::Classifier.new()
      expected = {'A' => MESH::Mesh.find('D005542'), 'H' => MESH::Mesh.find('D000715')}
      assert_equal expected, c.classify(title: 'Posterior forearm muscular anatomy')
      expected = {'H' => MESH::Mesh.find('D002309')}
      assert_equal expected, c.classify(title: 'Cardiology in a Heartbeat')
    end

    def test_it_should_classify_poor_abstract
      abstract = 'This is a guide to performing a cardiovascular examination in the context of an OSCE exam. It was created by a group of medical students for the free revision website www.geekymedics.com where you can find a written guide to accompany the video. The way in which this examination is carried out varies greatly between individuals & institutions therefore this should be used as a rough framework which you can personalise to suit your own style.'

      c = MESH::Classifier.new()
      expected = {'I' => MESH::Mesh.find('D004493'), 'M' => MESH::Mesh.find('D004493')}
      assert_equal expected, c.classify(abstract: abstract)
    end

    def test_it_should_classify_good_abstract
      abstract = 'The “Arterial Schematic” represents the intricate three-dimensional human arterial system in a highly simplified two-dimensional design reminiscent of the London Underground Map. Each “line” represents an artery within the body; a black circle marks a major vessel, whilst “stubs” stemming from the main lines represent the distal vasculature. The coloured “zones” represent the main divisions of the human body, for example; the yellow zone indicates the neck. The schematic was inspired by Henry Beck’s work on the first diagrammatic London Underground Map. His aim was to represent complex geographical distribution in a simple and accessible form. He achieved this aim by omitting swathes of information that had plagued previous designers’ versions. Beck’s approach was succinct yet produced a design that was immediately successful in clearly portraying to commuters how to traverse London most efficiently. The “Arterial Schematic” hopes to culminate this idea of communicating complex concepts in a concise manner, mirroring what is expected of medical professionals on a daily basis. The schematic is a prototype design intended to be part of a series of images that will diagrammatically represent the various systems of the human body. The prototype was inspired by a desire to teach anatomy via a fresh and engaging visual medium. Recent years have seen significant debate over reduced undergraduate anatomy teaching and its later consequences. The hope is that the “Arterial Schematic” and its sister diagrams will inspire students to learn anatomy and encourage them to further their knowledge via other sources. PLEASE NOTE: This image is available for purchase in print, please contact l.farmery1@gmail.com if interested. Please follow LFarmery on Twitter and considering sharing the Arterial Schematic on Facebook etc. Many Thanks.'

      c = MESH::Classifier.new()
      expected = {
        'A' => MESH::Mesh.find('D001158'),
        'B' => MESH::Mesh.find('D006801'),
        'F' => MESH::Mesh.find('D001525'),
        'H' => MESH::Mesh.find('D000715'),
        'I' => MESH::Mesh.find('D001525'),
        'K' => MESH::Mesh.find('D012942'),
        'L' => MESH::Mesh.find('D019359'),
        'M' => MESH::Mesh.find('D001525'),
        'Z' => MESH::Mesh.find('D004777')
      }
      assert_equal expected, c.classify(abstract: abstract)
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