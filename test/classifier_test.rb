require_relative 'test_helper'

module MESH

  class ClassiferTest < Minitest::Test

    def assert_classification expected, actual
      expected.each do |exp_root, (exp_best_score, exp_headings)|
        refute_nil actual[exp_root], "Expected headings for #{exp_root} but none present in actual"
        act_best_score, act_headings = actual[exp_root]
        assert_equal exp_best_score, act_best_score, "Expected best score of #{exp_best_score} for root #{exp_root} but received #{act_best_score}"
        assert_equal exp_headings.length, act_headings.length, "Expected #{exp_headings.length} headings for root #{exp_root} but received #{act_headings.length}"
        exp_headings.each do |exp_heading, exp_score|
          assert_equal exp_score, act_headings[exp_heading], "Expected score of #{exp_score} for #{exp_heading.unique_id} in root #{exp_root} but received #{act_headings[exp_heading]}"
        end
      end
    end

    #def test_headers
    #  @texts.each do |k, v|
    #    matches = MESH::Mesh.match_in_text(v)
    #    puts k
    #    puts matches
    #  end
    #end
    #classifications = classifier.classify([{matches: title_matches, weight: 5.0}, {matches: abstract_matches, weight: 2.0}, {matches: content_matches, weight: 1.0}])

    def test_it_should_classify_title
      c = MESH::Classifier.new()

      expected = {
        'H' => [1.0, {
          MESH::Mesh.find('D000715') => 1.0,
          MESH::Mesh.find('D001690') => 0.333,
          MESH::Mesh.find('D010811') => 0.111
        }],
        'A' => [1.0, {
          MESH::Mesh.find('D005542') => 1.0,
          MESH::Mesh.find('D034941') => 0.333,
          MESH::Mesh.find('D005121') => 0.111,
          MESH::Mesh.find('D001829') => 0.037
        }]
      }
      assert_classification expected, c.classify([{matches: @headings[:forearm_anatomy_title], weight: 1.0}])

      expected = {
        'H' => [1.0, {
          MESH::Mesh.find('D002309') => 1.0,
          MESH::Mesh.find('D007388') => 0.333,
          MESH::Mesh.find('D008511') => 0.111,
          MESH::Mesh.find('D006281') => 0.037
        }]
      }
      assert_classification expected, c.classify([{matches: @headings[:cardiology_title], weight: 1.0}])
    end

    def test_it_should_classify_poor_abstract
      c = MESH::Classifier.new()
      expected = {
        'I' => [1.0, {
          MESH::Mesh.find('D013337') => 1.0,
          MESH::Mesh.find('D013336') => 0.667,
          MESH::Mesh.find('D013334') => 0.444,
          MESH::Mesh.find('D004505') => 0.148,
          MESH::Mesh.find('D004493') => 0.198
        }],
        'M' => [1.0, {
          MESH::Mesh.find('D013337') => 1.0,
          MESH::Mesh.find('D013336') => 0.667,
          MESH::Mesh.find('D013334') => 0.444,
          MESH::Mesh.find('D009272') => 0.148
        }]
      }
      assert_classification expected, c.classify([{matches: @headings[:poor_abstract], weight: 1.0}])
    end

    def test_it_should_classify_good_abstract

      c = MESH::Classifier.new()
      expected = {
        'A' => [1.0, {
          MESH::Mesh.find('D001158') => 1.0,
          MESH::Mesh.find('D001808') => 0.333,
          MESH::Mesh.find('D002319') => 0.111,
          MESH::Mesh.find('D009333') => 1.0,
          MESH::Mesh.find('D001829') => 0.333
        }],

        'B' => [1.0, {
          MESH::Mesh.find('D006801') => 1.0,
          MESH::Mesh.find('D015186') => 0.333,
          MESH::Mesh.find('D051079') => 0.111,
          MESH::Mesh.find('D000882') => 0.037,
          MESH::Mesh.find('D011323') => 0.012,
          MESH::Mesh.find('D008322') => 0.004,
          MESH::Mesh.find('D014714') => 0.001,
        }],
        'F' => [2.0, {
          MESH::Mesh.find('D014836') => 2.0,
          MESH::Mesh.find('D008606') => 0.667,
          MESH::Mesh.find('D011579') => 0.222,
          MESH::Mesh.find('D035781') => 1.0,
          MESH::Mesh.find('D009679') => 0.667,
          MESH::Mesh.find('D005190') => 0.444,
          MESH::Mesh.find('D011593') => 0.148,
          MESH::Mesh.find('D001520') => 0.049,
          MESH::Mesh.find('D011584') => 0.049,
          MESH::Mesh.find('D001525') => 0.049,
          MESH::Mesh.find('D004191') => 0.016,
          MESH::Mesh.find('D012961') => 0.148,
          MESH::Mesh.find('D012942') => 0.099
        }],
        'H' => [3.0, {
          MESH::Mesh.find('D000715') => 3.0,
          MESH::Mesh.find('D001690') => 1.0,
          MESH::Mesh.find('D010811') => 0.333
        }],
        'I' => [2.0, {
          MESH::Mesh.find('D013334') => 1.0,
          MESH::Mesh.find('D004505') => 0.333,
          MESH::Mesh.find('D004493') => 0.778,
          MESH::Mesh.find('D013663') => 1.0,
          MESH::Mesh.find('D014937') => 1.0,
          MESH::Mesh.find('D006802') => 0.333,
          MESH::Mesh.find('D018594') => 2.0,
          MESH::Mesh.find('D003469') => 0.667,
          MESH::Mesh.find('D000884') => 0.222,
          MESH::Mesh.find('D000883') => 0.074,
          MESH::Mesh.find('D012942') => 0.296,
          MESH::Mesh.find('D012961') => 0.370,
          MESH::Mesh.find('D035781') => 1.0,
          MESH::Mesh.find('D009679') => 0.667,
          MESH::Mesh.find('D005190') => 0.444
        }],
        'K' => [2.0, {
          MESH::Mesh.find('D018594') => 2.0,
          MESH::Mesh.find('D001154') => 0.667,
          MESH::Mesh.find('D006809') => 0.556,
          MESH::Mesh.find('D019359') => 1.0
        }],
        'L' => [1.0, {
          MESH::Mesh.find('D019359') => 1.0,
          MESH::Mesh.find('D007254') => 0.333
        }],
        'M' => [1.0, {
          MESH::Mesh.find('D013334') => 1.0,
          MESH::Mesh.find('D009272') => 0.667,
          MESH::Mesh.find('D035781') => 1.0
        }],
        'Z' => [3.0, {
          MESH::Mesh.find('D008131') => 3.0,
          MESH::Mesh.find('D002947') => 1.0,
          MESH::Mesh.find('D005842') => 0.481,
          MESH::Mesh.find('D004739') => 1.0,
          MESH::Mesh.find('D006113') => 0.667,
          MESH::Mesh.find('D005060') => 0.222,
          MESH::Mesh.find('D062312') => 0.222
        }]

      }
      assert_classification expected, c.classify([{matches: @headings[:good_abstract], weight: 1.0}])
    end

    def test_it_should_classify_content
      c = MESH::Classifier.new()
      expected = {
        'A' => [10.0, {
          MESH::Mesh.find('D001132') => 1.0, MESH::Mesh.find('D034941') => 1.0, MESH::Mesh.find('D005121') => 2.556, MESH::Mesh.find('D001829') => 1.370, MESH::Mesh.find('D001415') => 1.0, MESH::Mesh.find('D060726') => 1.333, MESH::Mesh.find('D005123') => 2.0, MESH::Mesh.find('D005145') => 0.667, MESH::Mesh.find('D006257') => 0.222, MESH::Mesh.find('D012679') => 0.667, MESH::Mesh.find('D006225') => 2.0, MESH::Mesh.find('D006321') => 10.0, MESH::Mesh.find('D002319') => 3.333, MESH::Mesh.find('D007866') => 2.0, MESH::Mesh.find('D035002') => 0.667, MESH::Mesh.find('D013909') => 3.0, MESH::Mesh.find('D001842') => 1.0, MESH::Mesh.find('D012863') => 0.333, MESH::Mesh.find('D009141') => 0.111, MESH::Mesh.find('D003238') => 0.333, MESH::Mesh.find('D014024') => 0.111
        }],
        'B' => [1.0, {
          MESH::Mesh.find('D027861') => 1.0, MESH::Mesh.find('D027824') => 0.333, MESH::Mesh.find('D019685') => 0.111, MESH::Mesh.find('D019684') => 0.037, MESH::Mesh.find('D019669') => 0.012, MESH::Mesh.find('D057949') => 0.004, MESH::Mesh.find('D057948') => 0.001
        }],
        'C' => [1.0, {
          MESH::Mesh.find('D003221') => 1.0, MESH::Mesh.find('D019954') => 1.0, MESH::Mesh.find('D009461') => 0.667, MESH::Mesh.find('D009422') => 0.222, MESH::Mesh.find('D012816') => 0.222, MESH::Mesh.find('D013568') => 0.074
        }],
        'D' => [13.0, {
          MESH::Mesh.find('D007854') => 13.0, MESH::Mesh.find('D019216') => 8.667, MESH::Mesh.find('D004602') => 2.889, MESH::Mesh.find('D007287') => 1.926, MESH::Mesh.find('D008670') => 2.889
        }],
        'E' => [2.0, {
          MESH::Mesh.find('D004562') => 2.0, MESH::Mesh.find('D006334') => 0.667, MESH::Mesh.find('D003935') => 0.222, MESH::Mesh.find('D019937') => 0.296, MESH::Mesh.find('D003933') => 0.099, MESH::Mesh.find('D004568') => 0.667
        }],
        'F' => [4.0, {
          MESH::Mesh.find('D003221') => 1.0, MESH::Mesh.find('D019954') => 1.0, MESH::Mesh.find('D001520') => 0.333, MESH::Mesh.find('D007858') => 1.0, MESH::Mesh.find('D008606') => 2.0, MESH::Mesh.find('D011579') => 0.704, MESH::Mesh.find('D011588') => 0.333, MESH::Mesh.find('D011585') => 0.111, MESH::Mesh.find('D011584') => 0.111, MESH::Mesh.find('D001525') => 0.037, MESH::Mesh.find('D004191') => 0.012, MESH::Mesh.find('D013850') => 1.0, MESH::Mesh.find('D014836') => 4.0
        }],
        'G' => [2.0, {
          MESH::Mesh.find('D000200') => 2.0, MESH::Mesh.find('D008564') => 2.0, MESH::Mesh.find('D055592') => 0.667, MESH::Mesh.find('D055585') => 0.691, MESH::Mesh.find('D002468') => 0.667, MESH::Mesh.find('D055724') => 0.667, MESH::Mesh.find('D010829') => 0.222, MESH::Mesh.find('D009424') => 0.667, MESH::Mesh.find('D055687') => 0.222, MESH::Mesh.find('D013995') => 1.0, MESH::Mesh.find('D014919') => 1.0, MESH::Mesh.find('D000392') => 1.0, MESH::Mesh.find('D055907') => 0.333, MESH::Mesh.find('D055691') => 0.111, MESH::Mesh.find('D055669') => 0.416, MESH::Mesh.find('D001686') => 0.139, MESH::Mesh.find('D014887') => 1.0, MESH::Mesh.find('D001272') => 0.889, MESH::Mesh.find('D004777') => 0.506, MESH::Mesh.find('D008685') => 0.630, MESH::Mesh.find('D000388') => 0.333, MESH::Mesh.find('D014965') => 1.0, MESH::Mesh.find('D060733') => 0.667, MESH::Mesh.find('D055590') => 0.222, MESH::Mesh.find('D060328') => 0.074, MESH::Mesh.find('D011827') => 0.333, MESH::Mesh.find('D011839') => 0.333
        }],
        'I' => [1.0, {
          MESH::Mesh.find('D014937') => 1.0, MESH::Mesh.find('D006802') => 0.333
        }],
        'K' => [1.0, {
          MESH::Mesh.find('D019368') => 1.0, MESH::Mesh.find('D006809') => 0.333
        }],
        'L' => [1.0, {
          MESH::Mesh.find('D009275') => 1.0, MESH::Mesh.find('D009626') => 0.333, MESH::Mesh.find('D008037') => 0.111, MESH::Mesh.find('D007802') => 0.037, MESH::Mesh.find('D003142') => 0.025, MESH::Mesh.find('D007254') => 0.008
        }],
        'M' => [6.0, {
          MESH::Mesh.find('D010361') => 6.0, MESH::Mesh.find('D009272') => 2.0
        }],
        'N' => [1.0, {
          MESH::Mesh.find('D009938') => 1.0, MESH::Mesh.find('D004472') => 0.333, MESH::Mesh.find('D014919') => 1.0, MESH::Mesh.find('D000392') => 1.0, MESH::Mesh.find('D014887') => 1.0, MESH::Mesh.find('D001272') => 0.889, MESH::Mesh.find('D004777') => 0.543, MESH::Mesh.find('D004778') => 0.181, MESH::Mesh.find('D008685') => 0.630, MESH::Mesh.find('D000388') => 0.333, MESH::Mesh.find('D059205') => 0.333, MESH::Mesh.find('D004736') => 0.111
        }],
        'V' => [1.0, {
          MESH::Mesh.find('D017203') => 1.0, MESH::Mesh.find('D019215') => 0.333, MESH::Mesh.find('D052181') => 0.111, MESH::Mesh.find('D052180') => 0.148, MESH::Mesh.find('D016456') => 0.111
        }],
        'Z' => [1.0, {
          MESH::Mesh.find('D014481') => 1.0, MESH::Mesh.find('D009656') => 0.333, MESH::Mesh.find('D000569') => 0.111, MESH::Mesh.find('D005842') => 0.037
        }]
      }

      assert_classification expected, c.classify([{matches: @headings[:medium_content], weight: 1.0}])
    end

    def test_it_should_classify_other_content_as_well
      c = MESH::Classifier.new()
      expected = {
        'A' => [2.0, {
          MESH::Mesh.find('D001769') => 1.0, MESH::Mesh.find('D001826') => 0.333, MESH::Mesh.find('D005441') => 0.111, MESH::Mesh.find('D006424') => 0.333, MESH::Mesh.find('D006624') => 1.0, MESH::Mesh.find('D008032') => 0.333, MESH::Mesh.find('D001921') => 0.115, MESH::Mesh.find('D002490') => 0.038, MESH::Mesh.find('D009420') => 0.013, MESH::Mesh.find('D002540') => 0.333, MESH::Mesh.find('D054022') => 0.111, MESH::Mesh.find('D013687') => 0.037, MESH::Mesh.find('D016548') => 0.012, MESH::Mesh.find('D008099') => 2.0, MESH::Mesh.find('D004064') => 1.0, MESH::Mesh.find('D010179') => 1.0
        }],
        'D' => [4.136, {
          MESH::Mesh.find('D000269') => 1.0, MESH::Mesh.find('D020313') => 0.383, MESH::Mesh.find('D020164') => 0.171, MESH::Mesh.find('D000900') => 1.0, MESH::Mesh.find('D000890') => 0.333, MESH::Mesh.find('D045506') => 0.111, MESH::Mesh.find('D020228') => 0.131, MESH::Mesh.find('D001786') => 2.0, MESH::Mesh.find('D005947') => 1.667, MESH::Mesh.find('D006601') => 0.556, MESH::Mesh.find('D009005') => 0.185, MESH::Mesh.find('D002241') => 4.136, MESH::Mesh.find('D004247') => 2.0, MESH::Mesh.find('D009696') => 0.667, MESH::Mesh.find('D009706') => 0.222, MESH::Mesh.find('D006728') => 1.263, MESH::Mesh.find('D006730') => 0.842, MESH::Mesh.find('D045505') => 0.281, MESH::Mesh.find('D007328') => 4.0, MESH::Mesh.find('D011384') => 2.667, MESH::Mesh.find('D061385') => 1.778, MESH::Mesh.find('D010187') => 1.185, MESH::Mesh.find('D036361') => 0.790, MESH::Mesh.find('D010455') => 0.263, MESH::Mesh.find('D000602') => 0.187, MESH::Mesh.find('D011498') => 0.889, MESH::Mesh.find('D011506') => 0.296, MESH::Mesh.find('D013213') => 1.0, MESH::Mesh.find('D005936') => 0.667, MESH::Mesh.find('D001704') => 0.222, MESH::Mesh.find('D011108') => 0.222, MESH::Mesh.find('D046911') => 0.074, MESH::Mesh.find('D001697') => 0.148, MESH::Mesh.find('D011134') => 0.222
        }],
        'F' => [1.0, {
          MESH::Mesh.find('D005190') => 1.0, MESH::Mesh.find('D011593') => 0.333, MESH::Mesh.find('D001520') => 0.111, MESH::Mesh.find('D011584') => 0.111, MESH::Mesh.find('D001525') => 0.111, MESH::Mesh.find('D004191') => 0.037, MESH::Mesh.find('D012961') => 0.333, MESH::Mesh.find('D012942') => 0.222
        }],
        'G' => [1.0, {
          MESH::Mesh.find('D012621') => 1.0, MESH::Mesh.find('D010507') => 0.333, MESH::Mesh.find('D013995') => 0.111, MESH::Mesh.find('D055585') => 0.037, MESH::Mesh.find('D002909') => 0.111, MESH::Mesh.find('D010829') => 0.037, MESH::Mesh.find('D002980') => 0.667, MESH::Mesh.find('D004777') => 0.321, MESH::Mesh.find('D055669') => 0.132, MESH::Mesh.find('D001686') => 0.044, MESH::Mesh.find('D001272') => 0.222, MESH::Mesh.find('D008685') => 0.074
        }],
        'I' => [1.0, {
          MESH::Mesh.find('D005190') => 1.0, MESH::Mesh.find('D012961') => 0.333, MESH::Mesh.find('D012942') => 0.222
        }],
        'J' => [1.0, {
          MESH::Mesh.find('D000269') => 1.0, MESH::Mesh.find('D008420') => 0.444, MESH::Mesh.find('D013676') => 0.148, MESH::Mesh.find('D005389') => 1.0, MESH::Mesh.find('D054041') => 0.333, MESH::Mesh.find('D005502') => 1.0, MESH::Mesh.find('D019602') => 0.333
        }],
        'L' => [1.0, {
          MESH::Mesh.find('D005246') => 1.0, MESH::Mesh.find('D003491') => 0.333, MESH::Mesh.find('D003142') => 0.111, MESH::Mesh.find('D007254') => 0.037
        }],
        'N' => [1.0, {
          MESH::Mesh.find('D012621') => 1.0, MESH::Mesh.find('D002980') => 0.667, MESH::Mesh.find('D004777') => 0.321, MESH::Mesh.find('D004778') => 0.107, MESH::Mesh.find('D001272') => 0.222, MESH::Mesh.find('D008685') => 0.074
        }]
      }
      assert_classification expected, c.classify([{matches: @headings[:short_content], weight: 1.0}])
    end

    def test_it_should_classify_title_abstract_and_content
      c = MESH::Classifier.new()

      doc = {
        title: 'Rotation',
        abstract: 'Oxygen',
        content: 'Nose'
      }

      expected = {
        'A' => [2.0, {
          MESH::Mesh.find('D001769') => 1.0, MESH::Mesh.find('D001826') => 0.333, MESH::Mesh.find('D005441') => 0.111, MESH::Mesh.find('D006424') => 0.333, MESH::Mesh.find('D006624') => 1.0, MESH::Mesh.find('D008032') => 0.333, MESH::Mesh.find('D001921') => 0.115, MESH::Mesh.find('D002490') => 0.038, MESH::Mesh.find('D009420') => 0.013, MESH::Mesh.find('D002540') => 0.333, MESH::Mesh.find('D054022') => 0.111, MESH::Mesh.find('D013687') => 0.037, MESH::Mesh.find('D016548') => 0.012, MESH::Mesh.find('D008099') => 2.0, MESH::Mesh.find('D004064') => 1.0, MESH::Mesh.find('D010179') => 1.0
        }],
        'D' => [4.136, {
          MESH::Mesh.find('D000269') => 1.0, MESH::Mesh.find('D020313') => 0.383, MESH::Mesh.find('D020164') => 0.171, MESH::Mesh.find('D000900') => 1.0, MESH::Mesh.find('D000890') => 0.333, MESH::Mesh.find('D045506') => 0.111, MESH::Mesh.find('D020228') => 0.131, MESH::Mesh.find('D001786') => 2.0, MESH::Mesh.find('D005947') => 1.667, MESH::Mesh.find('D006601') => 0.556, MESH::Mesh.find('D009005') => 0.185, MESH::Mesh.find('D002241') => 4.136, MESH::Mesh.find('D004247') => 2.0, MESH::Mesh.find('D009696') => 0.667, MESH::Mesh.find('D009706') => 0.222, MESH::Mesh.find('D006728') => 1.263, MESH::Mesh.find('D006730') => 0.842, MESH::Mesh.find('D045505') => 0.281, MESH::Mesh.find('D007328') => 4.0, MESH::Mesh.find('D011384') => 2.667, MESH::Mesh.find('D061385') => 1.778, MESH::Mesh.find('D010187') => 1.185, MESH::Mesh.find('D036361') => 0.790, MESH::Mesh.find('D010455') => 0.263, MESH::Mesh.find('D000602') => 0.187, MESH::Mesh.find('D011498') => 0.889, MESH::Mesh.find('D011506') => 0.296, MESH::Mesh.find('D013213') => 1.0, MESH::Mesh.find('D005936') => 0.667, MESH::Mesh.find('D001704') => 0.222, MESH::Mesh.find('D011108') => 0.222, MESH::Mesh.find('D046911') => 0.074, MESH::Mesh.find('D001697') => 0.148, MESH::Mesh.find('D011134') => 0.222
        }],
        'F' => [1.0, {
          MESH::Mesh.find('D005190') => 1.0, MESH::Mesh.find('D011593') => 0.333, MESH::Mesh.find('D001520') => 0.111, MESH::Mesh.find('D011584') => 0.111, MESH::Mesh.find('D001525') => 0.111, MESH::Mesh.find('D004191') => 0.037, MESH::Mesh.find('D012961') => 0.333, MESH::Mesh.find('D012942') => 0.222
        }],
        'G' => [1.0, {
          MESH::Mesh.find('D012621') => 1.0, MESH::Mesh.find('D010507') => 0.333, MESH::Mesh.find('D013995') => 0.111, MESH::Mesh.find('D055585') => 0.037, MESH::Mesh.find('D002909') => 0.111, MESH::Mesh.find('D010829') => 0.037, MESH::Mesh.find('D002980') => 0.667, MESH::Mesh.find('D004777') => 0.321, MESH::Mesh.find('D055669') => 0.132, MESH::Mesh.find('D001686') => 0.044, MESH::Mesh.find('D001272') => 0.222, MESH::Mesh.find('D008685') => 0.074
        }],
        'H' => [7.0, {
          MESH::Mesh.find('D002309') => 7.0, MESH::Mesh.find('D007388') => 2.333, MESH::Mesh.find('D008511') => 0.778, MESH::Mesh.find('D006281') => 0.259
        }],
        'I' => [3.0, {
          MESH::Mesh.find('D013337') => 3.0, MESH::Mesh.find('D013336') => 2.0, MESH::Mesh.find('D013334') => 1.333, MESH::Mesh.find('D004505') => 0.444, MESH::Mesh.find('D004493') => 0.593, MESH::Mesh.find('D005190') => 1.0, MESH::Mesh.find('D012961') => 0.333, MESH::Mesh.find('D012942') => 0.222
        }],
        'J' => [1.0, {
          MESH::Mesh.find('D000269') => 1.0, MESH::Mesh.find('D008420') => 0.444, MESH::Mesh.find('D013676') => 0.148, MESH::Mesh.find('D005389') => 1.0, MESH::Mesh.find('D054041') => 0.333, MESH::Mesh.find('D005502') => 1.0, MESH::Mesh.find('D019602') => 0.333
        }],
        'L' => [1.0, {
          MESH::Mesh.find('D005246') => 1.0, MESH::Mesh.find('D003491') => 0.333, MESH::Mesh.find('D003142') => 0.111, MESH::Mesh.find('D007254') => 0.037
        }],
        'M' => [3.0, {
          MESH::Mesh.find('D013337') => 3.0, MESH::Mesh.find('D013336') => 2.0, MESH::Mesh.find('D013334') => 1.333, MESH::Mesh.find('D009272') => 0.444
        }],
        'N' => [1.0, {
          MESH::Mesh.find('D012621') => 1.0, MESH::Mesh.find('D002980') => 0.667, MESH::Mesh.find('D004777') => 0.321, MESH::Mesh.find('D004778') => 0.107, MESH::Mesh.find('D001272') => 0.222, MESH::Mesh.find('D008685') => 0.074
        }]
      }

      assert_classification expected, c.classify([{matches: @headings[:cardiology_title], weight: 7.0}, {matches: @headings[:poor_abstract], weight: 3.0}, {matches: @headings[:short_content], weight: 1.0}])

    end

    def setup
      #@texts = {
      #  forearm_anatomy_title: 'Posterior forearm muscular anatomy',
      #
      #  cardiology_title: 'Cardiology in a Heartbeat',
      #
      #  medium_content: 'hi in this tutorial I\'m you talk about electrocardiography so we\'ll be looking at the first principles open electrocardiogram more commonly known as an the CD or an ekgs in the United States there\'s a fairly the information in this tutorial but I\'ll try make it as simple as possible the first people were gonna look at where you attached leave them a CG machine to a patient crucible there are four leaves which are attached to the limbs the patient these are abbreviated LA left arm are a a ride home L the left leg and are I\'ll right leg there are also six leaves which we attach to the chest the patient these called chest leads missed the point of confusion for many people went first learning the PCG their these 10 leads which we\'ve attached to the patient but this is not what we mean when we talk about EC jail aids and EC Jade lead is an mathematically determined recording which is made up from a combination of these physically that are attached to the patient so from here on in when I talk about and a CG laid I\'m going to be talking about these mathematically determined recordings you don\'t need to know how these lead the calculated just know they\'re not the same thing as the lead attached to the patient so in a 12 lead the CJ which is the standard PCG they are 12 they\'d leave and each lead shows the heart from a different view so if I drop a heart like this and we\'re looking at it from me anterior aspect we can thinking these leads as little lies the h3 the heart from a different angle so there are 60 these eyes look at the heart in a corona plane and they look at the heart in the directions are shown here each of these leaves has a name this is laid one this is lead to this is lead gray and the other thing called abe et al I V on and a bf this stands for augmented Victor left right and Fort the chest leads look at the heart in a transverse plane so again these work like little eyes that each look at the heart from a different angle these are labeled much more simply they called v1 v2 b3 be full be polite and basics and that\'s the front and the back the two author now let\'s have a think about the limb leads again if I drop a diagram a the lead directions without the hard we get an image that looks like this if we extend these lines that in the opposite direction to which they point we will see that we have every direction coveted in 30 degree increments now would be a good time to talk about what I mean by looking at the heart the EC G carb see the heart in the wind x-ray came it sees it electrically that is to say it sees whether there is electrical deep polarization all repolarization occurring in the direction of peach laid if you don\'t know what I mean by D polarized nation and repolarization I\'m talking about the flow of cardiac action potentials through the heart you can check out the action potential series at WWW dot hand written tutorials dot com for more information so let me explain this a little further I\'m you draw up a hot here and we\'re gonna look at recordings the taken from lead to lead 3 and aber and we\'re going to look at the polarized nation which is occurring in this direction so any deep polarization that occurs in the direction of the lead cause away from the graph which is positive in nature that is and up with deflection so because lead to is roughly the same direction as the deep polarization the wave on the graph will look like this because lead 3 is perpendicular to the direction the polarization there will be no change in the graph and finally because aber is in the direction opposite to the direction people organization there\'s an inverted way or damn would deflection and that\'s an interview the first principles been a CG in the next tutorial will be looking at the normal patton Albany CG during the cardiac cycle for more free tutorials and the PDF this tutorial visit WWW dot hand written tutorials dot com',
      #
      #  short_content: 'diabetes drug families suck my big NO inhibited gray Taurus suck my big a new inhibiting Glee Taurus so finally arias tells the pancreas you need to release more insulin so fun mines are antibiotics medics mimic natural hormones like interest in Emelin that have similar functions to insulin big one-eyed decreases the liver from making more glucose the liver is a big organ analogues have gone make peptide-1 hookah gone a comedian the increases blood sugar by releasing starch sugar in be eventually lowers blood sugar the feedback stimulate insulin release a great drug would be like glue guns eventual function be but not do function hey that drug is a GOP won analog inhibitors about the glucoside ace glucoside a season enzyme that cuts big sugars into small sugars that food in your blood it\'s the small sugars that cause problems if you give it a glucoside et sans I\'m you have less to be small problem causing sugars good his own perfect DNA use see less insulin resistant magical glitter changes your DNA per superpowers help it go help hippocampus in',
      #
      #  poor_abstract: 'This is a guide to performing a cardiovascular examination in the context of an OSCE exam. It was created by a group of medical students for the free revision website www.geekymedics.com where you can find a written guide to accompany the video. The way in which this examination is carried out varies greatly between individuals & institutions therefore this should be used as a rough framework which you can personalise to suit your own style.',
      #
      #  good_abstract: 'The “Arterial Schematic” represents the intricate three-dimensional human arterial system in a highly simplified two-dimensional design reminiscent of the London Underground Map. Each “line” represents an artery within the body; a black circle marks a major vessel, whilst “stubs” stemming from the main lines represent the distal vasculature. The coloured “zones” represent the main divisions of the human body, for example; the yellow zone indicates the neck. The schematic was inspired by Henry Beck’s work on the first diagrammatic London Underground Map. His aim was to represent complex geographical distribution in a simple and accessible form. He achieved this aim by omitting swathes of information that had plagued previous designers’ versions. Beck’s approach was succinct yet produced a design that was immediately successful in clearly portraying to commuters how to traverse London most efficiently. The “Arterial Schematic” hopes to culminate this idea of communicating complex concepts in a concise manner, mirroring what is expected of medical professionals on a daily basis. The schematic is a prototype design intended to be part of a series of images that will diagrammatically represent the various systems of the human body. The prototype was inspired by a desire to teach anatomy via a fresh and engaging visual medium. Recent years have seen significant debate over reduced undergraduate anatomy teaching and its later consequences. The hope is that the “Arterial Schematic” and its sister diagrams will inspire students to learn anatomy and encourage them to further their knowledge via other sources. PLEASE NOTE: This image is available for purchase in print, please contact l.farmery1@gmail.com if interested. Please follow LFarmery on Twitter and considering sharing the Arterial Schematic on Facebook etc. Many Thanks.'
      #}

      @headings = {

        forearm_anatomy_title:
          [
            {heading: MESH::Mesh.find('D000715'), matched: 'Anatomy', index: 26},
            {heading: MESH::Mesh.find('D005542'), matched: 'Forearm', index: 9}
          ],
        cardiology_title:
          [
            {heading: MESH::Mesh.find('D002309'), matched: 'Cardiology', index: 0}
          ],
        medium_content:
          [
            {heading: MESH::Mesh.find('D000200'), matched: 'Action Potential', index: 2841},
            {heading: MESH::Mesh.find('D000200'), matched: 'Action Potentials', index: 2783},
            {heading: MESH::Mesh.find('D001132'), matched: 'Arm', index: 480},
            {heading: MESH::Mesh.find('D001415'), matched: 'Back', index: 2080},
            {heading: MESH::Mesh.find('D003221'), matched: 'Confusion', index: 652},
            {heading: MESH::Mesh.find('D004562'), matched: 'Electrocardiogram', index: 107},
            {heading: MESH::Mesh.find('D004562'), matched: 'Electrocardiography', index: 38},
            {heading: MESH::Mesh.find('D005121'), matched: 'Limb', index: 2133},
            {heading: MESH::Mesh.find('D005121'), matched: 'Limbs', index: 432},
            {heading: MESH::Mesh.find('D005123'), matched: 'Eyes', index: 1532},
            {heading: MESH::Mesh.find('D005123'), matched: 'Eyes', index: 1910},
            {heading: MESH::Mesh.find('D006225'), matched: 'Hand', index: 2876},
            {heading: MESH::Mesh.find('D006225'), matched: 'Hand', index: 3876},
            {heading: MESH::Mesh.find('D006321'), matched: 'Heart', index: 1320},
            {heading: MESH::Mesh.find('D006321'), matched: 'Heart', index: 1363},
            {heading: MESH::Mesh.find('D006321'), matched: 'Heart', index: 1481},
            {heading: MESH::Mesh.find('D006321'), matched: 'Heart', index: 1549},
            {heading: MESH::Mesh.find('D006321'), matched: 'Heart', index: 1594},
            {heading: MESH::Mesh.find('D006321'), matched: 'Heart', index: 1850},
            {heading: MESH::Mesh.find('D006321'), matched: 'Heart', index: 1937},
            {heading: MESH::Mesh.find('D006321'), matched: 'Heart', index: 2464},
            {heading: MESH::Mesh.find('D006321'), matched: 'Heart', index: 2492},
            {heading: MESH::Mesh.find('D006321'), matched: 'Heart', index: 2813},
            {heading: MESH::Mesh.find('D007854'), matched: 'Lead', index: 836},
            {heading: MESH::Mesh.find('D007854'), matched: 'Lead', index: 1129},
            {heading: MESH::Mesh.find('D007854'), matched: 'Lead', index: 1193},
            {heading: MESH::Mesh.find('D007854'), matched: 'Lead', index: 1233},
            {heading: MESH::Mesh.find('D007854'), matched: 'Lead', index: 1305},
            {heading: MESH::Mesh.find('D007854'), matched: 'Lead', index: 1690},
            {heading: MESH::Mesh.find('D007854'), matched: 'Lead', index: 1706},
            {heading: MESH::Mesh.find('D007854'), matched: 'Lead', index: 2176},
            {heading: MESH::Mesh.find('D007854'), matched: 'Lead', index: 3045},
            {heading: MESH::Mesh.find('D007854'), matched: 'Lead', index: 3053},
            {heading: MESH::Mesh.find('D007854'), matched: 'Lead', index: 3215},
            {heading: MESH::Mesh.find('D007854'), matched: 'Lead', index: 3316},
            {heading: MESH::Mesh.find('D007854'), matched: 'Lead', index: 3429},
            {heading: MESH::Mesh.find('D007858'), matched: 'Learning', index: 689},
            {heading: MESH::Mesh.find('D007866'), matched: 'Leg', index: 513},
            {heading: MESH::Mesh.find('D007866'), matched: 'Leg', index: 536},
            {heading: MESH::Mesh.find('D009275'), matched: 'Name', index: 1660},
            {heading: MESH::Mesh.find('D009938'), matched: 'Organization', index: 3602},
            {heading: MESH::Mesh.find('D010361'), matched: 'Patient', index: 367},
            {heading: MESH::Mesh.find('D010361'), matched: 'Patient', index: 442},
            {heading: MESH::Mesh.find('D010361'), matched: 'Patient', index: 599},
            {heading: MESH::Mesh.find('D010361'), matched: 'Patient', index: 755},
            {heading: MESH::Mesh.find('D010361'), matched: 'Patient', index: 964},
            {heading: MESH::Mesh.find('D010361'), matched: 'Patient', index: 1214},
            {heading: MESH::Mesh.find('D013850'), matched: 'Thinking', index: 1434},
            {heading: MESH::Mesh.find('D013909'), matched: 'Chest', index: 589},
            {heading: MESH::Mesh.find('D013909'), matched: 'Chest', index: 620},
            {heading: MESH::Mesh.find('D013909'), matched: 'Chest', index: 1826},
            {heading: MESH::Mesh.find('D013995'), matched: 'Time', index: 2415},
            {heading: MESH::Mesh.find('D014481'), matched: 'United States', index: 176},
            {heading: MESH::Mesh.find('D014836'), matched: 'Will', index: 2325},
            {heading: MESH::Mesh.find('D014836'), matched: 'Will', index: 3401},
            {heading: MESH::Mesh.find('D014836'), matched: 'Will', index: 3493},
            {heading: MESH::Mesh.find('D014836'), matched: 'Will', index: 3740},
            {heading: MESH::Mesh.find('D014919'), matched: 'Wind', index: 2505},
            {heading: MESH::Mesh.find('D014937'), matched: 'Work', index: 1893},
            {heading: MESH::Mesh.find('D014965'), matched: 'X-Ray', index: 2510},
            {heading: MESH::Mesh.find('D017203'), matched: 'Interview', index: 3678},
            {heading: MESH::Mesh.find('D019368'), matched: 'Nature', index: 3267},
            {heading: MESH::Mesh.find('D027861'), matched: 'Peach', index: 2663}
          ],
        short_content:
          [
            {heading: MESH::Mesh.find('D000269'), matched: 'Glue', index: 586},
            {heading: MESH::Mesh.find('D000900'), matched: 'Antibiotics', index: 186},
            {heading: MESH::Mesh.find('D001769'), matched: 'Blood', index: 789},
            {heading: MESH::Mesh.find('D001786'), matched: 'Blood Sugar', index: 446},
            {heading: MESH::Mesh.find('D001786'), matched: 'Blood Sugar', index: 508},
            {heading: MESH::Mesh.find('D002241'), matched: 'Sugars', index: 746},
            {heading: MESH::Mesh.find('D002241'), matched: 'Sugars', index: 764},
            {heading: MESH::Mesh.find('D002241'), matched: 'Sugars', index: 810},
            {heading: MESH::Mesh.find('D002241'), matched: 'Sugars', index: 918},
            {heading: MESH::Mesh.find('D004247'), matched: 'DNA', index: 946},
            {heading: MESH::Mesh.find('D004247'), matched: 'DNA', index: 1010},
            {heading: MESH::Mesh.find('D005190'), matched: 'Families', index: 13},
            {heading: MESH::Mesh.find('D005246'), matched: 'Feedback', index: 524},
            {heading: MESH::Mesh.find('D005389'), matched: 'Guns', index: 591},
            {heading: MESH::Mesh.find('D005502'), matched: 'Food', index: 776},
            {heading: MESH::Mesh.find('D005947'), matched: 'Glucose', index: 341},
            {heading: MESH::Mesh.find('D006624'), matched: 'Hippocampus', index: 1046},
            {heading: MESH::Mesh.find('D006728'), matched: 'Hormones', index: 219},
            {heading: MESH::Mesh.find('D007328'), matched: 'Insulin', index: 161},
            {heading: MESH::Mesh.find('D007328'), matched: 'Insulin', index: 283},
            {heading: MESH::Mesh.find('D007328'), matched: 'Insulin', index: 543},
            {heading: MESH::Mesh.find('D007328'), matched: 'Insulin', index: 963},
            {heading: MESH::Mesh.find('D008099'), matched: 'Liver', index: 318},
            {heading: MESH::Mesh.find('D008099'), matched: 'Liver', index: 353},
            {heading: MESH::Mesh.find('D010179'), matched: 'Pancreas', index: 127},
            {heading: MESH::Mesh.find('D012621'), matched: 'Season', index: 718},
            {heading: MESH::Mesh.find('D013213'), matched: 'Starch', index: 471}
          ],
        poor_abstract:
          [
            {heading: MESH::Mesh.find('D013337'), matched: 'Medical Students', index: 119}
          ],
        good_abstract:
          [
            {heading: MESH::Mesh.find('D000715'), matched: 'Anatomy', index: 1294},
            {heading: MESH::Mesh.find('D000715'), matched: 'Anatomy', index: 1411},
            {heading: MESH::Mesh.find('D000715'), matched: 'Anatomy', index: 1553},
            {heading: MESH::Mesh.find('D001158'), matched: 'Artery', index: 204},
            {heading: MESH::Mesh.find('D006801'), matched: 'Human', index: 67},
            {heading: MESH::Mesh.find('D008131'), matched: 'London', index: 154},
            {heading: MESH::Mesh.find('D008131'), matched: 'London', index: 535},
            {heading: MESH::Mesh.find('D008131'), matched: 'London', index: 888},
            {heading: MESH::Mesh.find('D009333'), matched: 'Neck', index: 455},
            {heading: MESH::Mesh.find('D013334'), matched: 'Students', index: 1535},
            {heading: MESH::Mesh.find('D013663'), matched: 'Teaching', index: 1419},
            {heading: MESH::Mesh.find('D014836'), matched: 'Will', index: 1175},
            {heading: MESH::Mesh.find('D014836'), matched: 'Will', index: 1522},
            {heading: MESH::Mesh.find('D014937'), matched: 'Work', index: 504},
            {heading: MESH::Mesh.find('D018594'), matched: 'Human Body', index: 400},
            {heading: MESH::Mesh.find('D018594'), matched: 'Human Body', index: 1234},
            {heading: MESH::Mesh.find('D019359'), matched: 'Knowledge', index: 1597},
            {heading: MESH::Mesh.find('D035781'), matched: 'Sister', index: 1506}
          ]
      }
    end

  end

end