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

    def test_it_should_classify_title
      expected = {
        'H' => [1.0, {
          @mesh_tree.find('D000715') => 1.0,
          @mesh_tree.find('D001690') => 0.333,
          @mesh_tree.find('D010811') => 0.111
        }],
        'A' => [1.0, {
          @mesh_tree.find('D005542') => 1.0,
          @mesh_tree.find('D034941') => 0.333,
          @mesh_tree.find('D005121') => 0.111,
          @mesh_tree.find('D001829') => 0.037
        }]
      }
      assert_classification expected, @classifier.classify([{matches: @headings[:forearm_anatomy_title], weight: 1.0}])

      expected = {
        'H' => [1.0, {
          @mesh_tree.find('D002309') => 1.0,
          @mesh_tree.find('D007388') => 0.333,
          @mesh_tree.find('D008511') => 0.111,
          @mesh_tree.find('D006281') => 0.037
        }]
      }
      assert_classification expected, @classifier.classify([{matches: @headings[:cardiology_title], weight: 1.0}])
    end

    def test_it_should_classify_poor_abstract
      
      expected = {
        'I' => [1.0, {
          @mesh_tree.find('D013337') => 1.0,
          @mesh_tree.find('D013334') => 0.111,
          @mesh_tree.find('D013336') => 0.333,
          @mesh_tree.find('D004505') => 0.037,
          @mesh_tree.find('D004493') => 0.049
        }],
        'M' => [1.0, {
          @mesh_tree.find('D013337') => 1.0,
          @mesh_tree.find('D013336') => 0.333,
          @mesh_tree.find('D013334') => 0.111,
          @mesh_tree.find('D009272') => 0.037
        }]
      }
      assert_classification expected, @classifier.classify([{matches: @headings[:poor_abstract], weight: 1.0}])
    end

    def test_it_should_classify_good_abstract

      
      expected = {
        'A' => [1.0, {
          @mesh_tree.find('D001158') => 1.0,
          @mesh_tree.find('D001808') => 0.333,
          @mesh_tree.find('D002319') => 0.111,
          @mesh_tree.find('D009333') => 1.0,
          @mesh_tree.find('D001829') => 0.333
        }],

        'B' => [1.0, {
          @mesh_tree.find('D006801') => 1.0,
          @mesh_tree.find('D015186') => 0.333,
          @mesh_tree.find('D051079') => 0.111,
          @mesh_tree.find('D000882') => 0.037,
          @mesh_tree.find('D011323') => 0.012,
          @mesh_tree.find('D008322') => 0.004,
          @mesh_tree.find('D014714') => 0.001,
        }],
        'F' => [2.0, {
          @mesh_tree.find('D014836') => 2.0,
          @mesh_tree.find('D008606') => 0.667,
          @mesh_tree.find('D011579') => 0.222,
          @mesh_tree.find('D035781') => 1.0,
          @mesh_tree.find('D009679') => 0.333,
          @mesh_tree.find('D005190') => 0.111,
          @mesh_tree.find('D011593') => 0.037,
          @mesh_tree.find('D001520') => 0.012,
          @mesh_tree.find('D011584') => 0.012,
          @mesh_tree.find('D001525') => 0.008,
          @mesh_tree.find('D004191') => 0.003,
          @mesh_tree.find('D012961') => 0.037,
          @mesh_tree.find('D012942') => 0.012
        }],
        'H' => [3.0, {
          @mesh_tree.find('D000715') => 3.0,
          @mesh_tree.find('D001690') => 1.0,
          @mesh_tree.find('D010811') => 0.333
        }],
        'I' => [2.0, {
          @mesh_tree.find('D013334') => 1.0,
          @mesh_tree.find('D004505') => 0.333,
          @mesh_tree.find('D004493') => 0.778,
          @mesh_tree.find('D013663') => 1.0,
          @mesh_tree.find('D014937') => 1.0,
          @mesh_tree.find('D006802') => 0.333,
          @mesh_tree.find('D018594') => 2.0,
          @mesh_tree.find('D003469') => 0.667,
          @mesh_tree.find('D000884') => 0.222,
          @mesh_tree.find('D000883') => 0.074,
          @mesh_tree.find('D012942') => 0.111,
          @mesh_tree.find('D012961') => 0.259,
          @mesh_tree.find('D035781') => 1.0,
          @mesh_tree.find('D009679') => 0.333,
          @mesh_tree.find('D005190') => 0.111
        }],
        'K' => [2.0, {
          @mesh_tree.find('D018594') => 2.0,
          @mesh_tree.find('D001154') => 0.667,
          @mesh_tree.find('D006809') => 0.556,
          @mesh_tree.find('D019359') => 1.0
        }],
        'L' => [1.0, {
          @mesh_tree.find('D019359') => 1.0,
          @mesh_tree.find('D007254') => 0.333
        }],
        'M' => [1.0, {
          @mesh_tree.find('D013334') => 1.0,
          @mesh_tree.find('D009272') => 0.667,
          @mesh_tree.find('D035781') => 1.0
        }],
        'Z' => [3.0, {
          @mesh_tree.find('D008131') => 3.0,
          @mesh_tree.find('D002947') => 1.0,
          @mesh_tree.find('D005842') => 0.407,
          @mesh_tree.find('D004739') => 1.0,
          @mesh_tree.find('D006113') => 0.333,
          @mesh_tree.find('D005060') => 0.111,
          @mesh_tree.find('D062312') => 0.111
        }]

      }
      assert_classification expected, @classifier.classify([{matches: @headings[:good_abstract], weight: 1.0}])
    end

    def test_it_should_classify_content
      
      expected = {
        'A' => [10.0, {
          @mesh_tree.find('D001132') => 1.0, @mesh_tree.find('D034941') => 1.0, @mesh_tree.find('D005121') => 2.556, @mesh_tree.find('D001829') => 1.370, @mesh_tree.find('D001415') => 1.0, @mesh_tree.find('D060726') => 1.333, @mesh_tree.find('D005123') => 2.0, @mesh_tree.find('D005145') => 0.667, @mesh_tree.find('D006257') => 0.222, @mesh_tree.find('D012679') => 0.667, @mesh_tree.find('D006225') => 2.0, @mesh_tree.find('D006321') => 10.0, @mesh_tree.find('D002319') => 3.333, @mesh_tree.find('D007866') => 2.0, @mesh_tree.find('D035002') => 0.667, @mesh_tree.find('D013909') => 3.0, @mesh_tree.find('D001842') => 1.0, @mesh_tree.find('D012863') => 0.333, @mesh_tree.find('D009141') => 0.111, @mesh_tree.find('D003238') => 0.333, @mesh_tree.find('D014024') => 0.111
        }],
        'B' => [1.0, {
          @mesh_tree.find('D027861') => 1.0, @mesh_tree.find('D027824') => 0.333, @mesh_tree.find('D019685') => 0.111, @mesh_tree.find('D019684') => 0.037, @mesh_tree.find('D019669') => 0.012, @mesh_tree.find('D057949') => 0.004, @mesh_tree.find('D057948') => 0.001
        }],
        'C' => [1.0, {
          @mesh_tree.find('D003221') => 1.0, @mesh_tree.find('D019954') => 0.333, @mesh_tree.find('D009461') => 0.111, @mesh_tree.find('D009422') => 0.037, @mesh_tree.find('D012816') => 0.037, @mesh_tree.find('D013568') => 0.012
        }],
        'D' => [13.0, {
          @mesh_tree.find('D007854') => 13.0, @mesh_tree.find('D019216') => 4.333, @mesh_tree.find('D004602') => 1.444, @mesh_tree.find('D007287') => 0.963, @mesh_tree.find('D008670') => 1.444
        }],
        'E' => [2.0, {
          @mesh_tree.find('D004562') => 2.0, @mesh_tree.find('D006334') => 0.667, @mesh_tree.find('D003935') => 0.222, @mesh_tree.find('D019937') => 0.296, @mesh_tree.find('D003933') => 0.099, @mesh_tree.find('D004568') => 0.667
        }],
        'F' => [4.0, {
          @mesh_tree.find('D003221') => 1.0, @mesh_tree.find('D019954') => 0.333, @mesh_tree.find('D001520') => 0.111, @mesh_tree.find('D007858') => 1.0, @mesh_tree.find('D008606') => 2.0, @mesh_tree.find('D011579') => 0.704, @mesh_tree.find('D011588') => 0.333, @mesh_tree.find('D011585') => 0.111, @mesh_tree.find('D011584') => 0.111, @mesh_tree.find('D001525') => 0.037, @mesh_tree.find('D004191') => 0.012, @mesh_tree.find('D013850') => 1.0, @mesh_tree.find('D014836') => 4.0
        }],
        'G' => [2.0, {
          @mesh_tree.find('D000200') => 2.0, @mesh_tree.find('D008564') => 0.667, @mesh_tree.find('D055592') => 0.222, @mesh_tree.find('D055585') => 0.494, @mesh_tree.find('D002468') => 0.222, @mesh_tree.find('D055724') => 0.222, @mesh_tree.find('D010829') => 0.074, @mesh_tree.find('D009424') => 0.222, @mesh_tree.find('D055687') => 0.074, @mesh_tree.find('D013995') => 1.0, @mesh_tree.find('D014919') => 1.0, @mesh_tree.find('D000392') => 0.333, @mesh_tree.find('D055907') => 0.111, @mesh_tree.find('D055691') => 0.037, @mesh_tree.find('D055669') => 0.126, @mesh_tree.find('D001686') => 0.042, @mesh_tree.find('D014887') => 0.444, @mesh_tree.find('D001272') => 0.185, @mesh_tree.find('D004777') => 0.132, @mesh_tree.find('D008685') => 0.210, @mesh_tree.find('D000388') => 0.111, @mesh_tree.find('D014965') => 1.0, @mesh_tree.find('D060733') => 0.333, @mesh_tree.find('D055590') => 0.111, @mesh_tree.find('D060328') => 0.037, @mesh_tree.find('D011827') => 0.222, @mesh_tree.find('D011839') => 0.333
        }],
        'I' => [1.0, {
          @mesh_tree.find('D014937') => 1.0, @mesh_tree.find('D006802') => 0.333
        }],
        'K' => [1.0, {
          @mesh_tree.find('D019368') => 1.0, @mesh_tree.find('D006809') => 0.333
        }],
        'L' => [1.0, {
          @mesh_tree.find('D009275') => 1.0, @mesh_tree.find('D009626') => 0.333, @mesh_tree.find('D008037') => 0.111, @mesh_tree.find('D007802') => 0.037, @mesh_tree.find('D003142') => 0.012, @mesh_tree.find('D007254') => 0.004
        }],
        'M' => [6.0, {
          @mesh_tree.find('D010361') => 6.0, @mesh_tree.find('D009272') => 2.0
        }],
        'N' => [1.0, {
          @mesh_tree.find('D009938') => 1.0, @mesh_tree.find('D004472') => 0.333, @mesh_tree.find('D014919') => 1.0, @mesh_tree.find('D000392') => 0.333, @mesh_tree.find('D014887') => 0.444, @mesh_tree.find('D001272') => 0.185, @mesh_tree.find('D004777') => 0.169, @mesh_tree.find('D004778') => 0.056, @mesh_tree.find('D008685') => 0.210, @mesh_tree.find('D000388') => 0.111, @mesh_tree.find('D059205') => 0.333, @mesh_tree.find('D004736') => 0.111
        }],
        'V' => [1.0, {
          @mesh_tree.find('D017203') => 1.0, @mesh_tree.find('D019215') => 0.333, @mesh_tree.find('D052181') => 0.111, @mesh_tree.find('D052180') => 0.148, @mesh_tree.find('D016456') => 0.111
        }],
        'Z' => [1.0, {
          @mesh_tree.find('D014481') => 1.0, @mesh_tree.find('D009656') => 0.333, @mesh_tree.find('D000569') => 0.111, @mesh_tree.find('D005842') => 0.037
        }]
      }

      assert_classification expected, @classifier.classify([{matches: @headings[:medium_content], weight: 1.0}])
    end

    def test_it_should_classify_other_content_as_well
      
      expected = {
        'A' => [2.0, {
          @mesh_tree.find('D001769') => 1.0, @mesh_tree.find('D001826') => 0.333, @mesh_tree.find('D005441') => 0.111, @mesh_tree.find('D006424') => 0.333, @mesh_tree.find('D006624') => 1.0, @mesh_tree.find('D008032') => 0.333, @mesh_tree.find('D001921') => 0.115, @mesh_tree.find('D002490') => 0.038, @mesh_tree.find('D009420') => 0.013, @mesh_tree.find('D002540') => 0.333, @mesh_tree.find('D054022') => 0.111, @mesh_tree.find('D013687') => 0.037, @mesh_tree.find('D016548') => 0.012, @mesh_tree.find('D008099') => 2.0, @mesh_tree.find('D004064') => 1.0, @mesh_tree.find('D010179') => 1.0
        }],
        'D' => [4.099, {
          @mesh_tree.find('D000269') => 1.0, @mesh_tree.find('D020313') => 0.337, @mesh_tree.find('D020164') => 0.137, @mesh_tree.find('D000900') => 1.0, @mesh_tree.find('D000890') => 0.333, @mesh_tree.find('D045506') => 0.111, @mesh_tree.find('D020228') => 0.075, @mesh_tree.find('D001786') => 2.0, @mesh_tree.find('D005947') => 1.667, @mesh_tree.find('D006601') => 0.556, @mesh_tree.find('D009005') => 0.185, @mesh_tree.find('D002241') => 4.099, @mesh_tree.find('D004247') => 2.0, @mesh_tree.find('D009696') => 0.667, @mesh_tree.find('D009706') => 0.222, @mesh_tree.find('D006728') => 1.016, @mesh_tree.find('D006730') => 0.339, @mesh_tree.find('D045505') => 0.113, @mesh_tree.find('D007328') => 4.0, @mesh_tree.find('D011384') => 1.333, @mesh_tree.find('D061385') => 0.444, @mesh_tree.find('D010187') => 0.148, @mesh_tree.find('D036361') => 0.049, @mesh_tree.find('D010455') => 0.016, @mesh_tree.find('D000602') => 0.055, @mesh_tree.find('D011498') => 0.444, @mesh_tree.find('D011506') => 0.148, @mesh_tree.find('D013213') => 1.0, @mesh_tree.find('D005936') => 0.333, @mesh_tree.find('D001704') => 0.111, @mesh_tree.find('D011108') => 0.037, @mesh_tree.find('D046911') => 0.012, @mesh_tree.find('D001697') => 0.012, @mesh_tree.find('D011134') => 0.111
        }],
        'F' => [1.0, {
          @mesh_tree.find('D005190') => 1.0, @mesh_tree.find('D011593') => 0.333, @mesh_tree.find('D001520') => 0.111, @mesh_tree.find('D011584') => 0.111, @mesh_tree.find('D001525') => 0.074, @mesh_tree.find('D004191') => 0.025, @mesh_tree.find('D012961') => 0.333, @mesh_tree.find('D012942') => 0.111
        }],
        'G' => [1.0, {
          @mesh_tree.find('D012621') => 1.0, @mesh_tree.find('D010507') => 0.333, @mesh_tree.find('D013995') => 0.111, @mesh_tree.find('D055585') => 0.037, @mesh_tree.find('D002909') => 0.111, @mesh_tree.find('D010829') => 0.037, @mesh_tree.find('D002980') => 0.333, @mesh_tree.find('D004777') => 0.16, @mesh_tree.find('D055669') => 0.066, @mesh_tree.find('D001686') => 0.022, @mesh_tree.find('D001272') => 0.111, @mesh_tree.find('D008685') => 0.037
        }],
        'I' => [1.0, {
          @mesh_tree.find('D005190') => 1.0, @mesh_tree.find('D012961') => 0.333, @mesh_tree.find('D012942') => 0.111
        }],
        'J' => [1.0, {
          @mesh_tree.find('D000269') => 1.0, @mesh_tree.find('D008420') => 0.444, @mesh_tree.find('D013676') => 0.148, @mesh_tree.find('D005389') => 1.0, @mesh_tree.find('D054041') => 0.333, @mesh_tree.find('D005502') => 1.0, @mesh_tree.find('D019602') => 0.333
        }],
        'L' => [1.0, {
          @mesh_tree.find('D005246') => 1.0, @mesh_tree.find('D003491') => 0.333, @mesh_tree.find('D003142') => 0.111, @mesh_tree.find('D007254') => 0.037
        }],
        'N' => [1.0, {
          @mesh_tree.find('D012621') => 1.0, @mesh_tree.find('D002980') => 0.333, @mesh_tree.find('D004777') => 0.16, @mesh_tree.find('D004778') => 0.053, @mesh_tree.find('D001272') => 0.111, @mesh_tree.find('D008685') => 0.037
        }]
      }
      assert_classification expected, @classifier.classify([{matches: @headings[:short_content], weight: 1.0}])
    end

    def test_it_should_classify_title_abstract_and_content
      

      doc = {
        title: 'Rotation',
        abstract: 'Oxygen',
        content: 'Nose'
      }

      expected = {
        'A' => [2.0, {
          @mesh_tree.find('D001769') => 1.0, @mesh_tree.find('D001826') => 0.333, @mesh_tree.find('D005441') => 0.111, @mesh_tree.find('D006424') => 0.333, @mesh_tree.find('D006624') => 1.0, @mesh_tree.find('D008032') => 0.333, @mesh_tree.find('D001921') => 0.115, @mesh_tree.find('D002490') => 0.038, @mesh_tree.find('D009420') => 0.013, @mesh_tree.find('D002540') => 0.333, @mesh_tree.find('D054022') => 0.111, @mesh_tree.find('D013687') => 0.037, @mesh_tree.find('D016548') => 0.012, @mesh_tree.find('D008099') => 2.0, @mesh_tree.find('D004064') => 1.0, @mesh_tree.find('D010179') => 1.0
        }],
        'D' => [4.099, {
          @mesh_tree.find('D000269') => 1.0, @mesh_tree.find('D020313') => 0.337, @mesh_tree.find('D020164') => 0.137, @mesh_tree.find('D000900') => 1.0, @mesh_tree.find('D000890') => 0.333, @mesh_tree.find('D045506') => 0.111, @mesh_tree.find('D020228') => 0.075, @mesh_tree.find('D001786') => 2.0, @mesh_tree.find('D005947') => 1.667, @mesh_tree.find('D006601') => 0.556, @mesh_tree.find('D009005') => 0.185, @mesh_tree.find('D002241') => 4.099, @mesh_tree.find('D004247') => 2.0, @mesh_tree.find('D009696') => 0.667, @mesh_tree.find('D009706') => 0.222, @mesh_tree.find('D006728') => 1.016, @mesh_tree.find('D006730') => 0.339, @mesh_tree.find('D045505') => 0.113, @mesh_tree.find('D007328') => 4.0, @mesh_tree.find('D011384') => 1.333, @mesh_tree.find('D061385') => 0.444, @mesh_tree.find('D010187') => 0.148, @mesh_tree.find('D036361') => 0.049, @mesh_tree.find('D010455') => 0.016, @mesh_tree.find('D000602') => 0.055, @mesh_tree.find('D011498') => 0.444, @mesh_tree.find('D011506') => 0.148, @mesh_tree.find('D013213') => 1.0, @mesh_tree.find('D005936') => 0.333, @mesh_tree.find('D001704') => 0.111, @mesh_tree.find('D011108') => 0.037, @mesh_tree.find('D046911') => 0.012, @mesh_tree.find('D001697') => 0.012, @mesh_tree.find('D011134') => 0.111
        }],
        'F' => [1.0, {
          @mesh_tree.find('D005190') => 1.0, @mesh_tree.find('D011593') => 0.333, @mesh_tree.find('D001520') => 0.111, @mesh_tree.find('D011584') => 0.111, @mesh_tree.find('D001525') => 0.074, @mesh_tree.find('D004191') => 0.025, @mesh_tree.find('D012961') => 0.333, @mesh_tree.find('D012942') => 0.111
        }],
        'G' => [1.0, {
          @mesh_tree.find('D012621') => 1.0, @mesh_tree.find('D010507') => 0.333, @mesh_tree.find('D013995') => 0.111, @mesh_tree.find('D055585') => 0.037, @mesh_tree.find('D002909') => 0.111, @mesh_tree.find('D010829') => 0.037, @mesh_tree.find('D002980') => 0.333, @mesh_tree.find('D004777') => 0.160, @mesh_tree.find('D055669') => 0.066, @mesh_tree.find('D001686') => 0.022, @mesh_tree.find('D001272') => 0.111, @mesh_tree.find('D008685') => 0.037
        }],
        'H' => [7.0, {
          @mesh_tree.find('D002309') => 7.0, @mesh_tree.find('D007388') => 2.333, @mesh_tree.find('D008511') => 0.778, @mesh_tree.find('D006281') => 0.259
        }],
        'I' => [3.0, {
          @mesh_tree.find('D013337') => 3.0, @mesh_tree.find('D013336') => 1.0, @mesh_tree.find('D013334') => 0.333, @mesh_tree.find('D004505') => 0.111, @mesh_tree.find('D004493') => 0.148, @mesh_tree.find('D005190') => 1.0, @mesh_tree.find('D012961') => 0.333, @mesh_tree.find('D012942') => 0.111
        }],
        'J' => [1.0, {
          @mesh_tree.find('D000269') => 1.0, @mesh_tree.find('D008420') => 0.444, @mesh_tree.find('D013676') => 0.148, @mesh_tree.find('D005389') => 1.0, @mesh_tree.find('D054041') => 0.333, @mesh_tree.find('D005502') => 1.0, @mesh_tree.find('D019602') => 0.333
        }],
        'L' => [1.0, {
          @mesh_tree.find('D005246') => 1.0, @mesh_tree.find('D003491') => 0.333, @mesh_tree.find('D003142') => 0.111, @mesh_tree.find('D007254') => 0.037
        }],
        'M' => [3.0, {
          @mesh_tree.find('D013337') => 3.0, @mesh_tree.find('D013336') => 1.0, @mesh_tree.find('D013334') => 0.333, @mesh_tree.find('D009272') => 0.111
        }],
        'N' => [1.0, {
          @mesh_tree.find('D012621') => 1.0, @mesh_tree.find('D002980') => 0.333, @mesh_tree.find('D004777') => 0.16, @mesh_tree.find('D004778') => 0.053, @mesh_tree.find('D001272') => 0.111, @mesh_tree.find('D008685') => 0.037
        }]
      }

      assert_classification expected, @classifier.classify([{matches: @headings[:cardiology_title], weight: 7.0}, {matches: @headings[:poor_abstract], weight: 3.0}, {matches: @headings[:short_content], weight: 1.0}])

    end

    def setup

      @@mesh_tree ||= MESH::Tree.new
      @mesh_tree = @@mesh_tree
      @classifier ||= MESH::Classifier.new()

      @headings = {

        forearm_anatomy_title:
          [
            {heading: @mesh_tree.find('D000715'), matched: 'Anatomy', index: 26},
            {heading: @mesh_tree.find('D005542'), matched: 'Forearm', index: 9}
          ],
        cardiology_title:
          [
            {heading: @mesh_tree.find('D002309'), matched: 'Cardiology', index: 0}
          ],
        medium_content:
          [
            {heading: @mesh_tree.find('D000200'), matched: 'Action Potential', index: 2841},
            {heading: @mesh_tree.find('D000200'), matched: 'Action Potentials', index: 2783},
            {heading: @mesh_tree.find('D001132'), matched: 'Arm', index: 480},
            {heading: @mesh_tree.find('D001415'), matched: 'Back', index: 2080},
            {heading: @mesh_tree.find('D003221'), matched: 'Confusion', index: 652},
            {heading: @mesh_tree.find('D004562'), matched: 'Electrocardiogram', index: 107},
            {heading: @mesh_tree.find('D004562'), matched: 'Electrocardiography', index: 38},
            {heading: @mesh_tree.find('D005121'), matched: 'Limb', index: 2133},
            {heading: @mesh_tree.find('D005121'), matched: 'Limbs', index: 432},
            {heading: @mesh_tree.find('D005123'), matched: 'Eyes', index: 1532},
            {heading: @mesh_tree.find('D005123'), matched: 'Eyes', index: 1910},
            {heading: @mesh_tree.find('D006225'), matched: 'Hand', index: 2876},
            {heading: @mesh_tree.find('D006225'), matched: 'Hand', index: 3876},
            {heading: @mesh_tree.find('D006321'), matched: 'Heart', index: 1320},
            {heading: @mesh_tree.find('D006321'), matched: 'Heart', index: 1363},
            {heading: @mesh_tree.find('D006321'), matched: 'Heart', index: 1481},
            {heading: @mesh_tree.find('D006321'), matched: 'Heart', index: 1549},
            {heading: @mesh_tree.find('D006321'), matched: 'Heart', index: 1594},
            {heading: @mesh_tree.find('D006321'), matched: 'Heart', index: 1850},
            {heading: @mesh_tree.find('D006321'), matched: 'Heart', index: 1937},
            {heading: @mesh_tree.find('D006321'), matched: 'Heart', index: 2464},
            {heading: @mesh_tree.find('D006321'), matched: 'Heart', index: 2492},
            {heading: @mesh_tree.find('D006321'), matched: 'Heart', index: 2813},
            {heading: @mesh_tree.find('D007854'), matched: 'Lead', index: 836},
            {heading: @mesh_tree.find('D007854'), matched: 'Lead', index: 1129},
            {heading: @mesh_tree.find('D007854'), matched: 'Lead', index: 1193},
            {heading: @mesh_tree.find('D007854'), matched: 'Lead', index: 1233},
            {heading: @mesh_tree.find('D007854'), matched: 'Lead', index: 1305},
            {heading: @mesh_tree.find('D007854'), matched: 'Lead', index: 1690},
            {heading: @mesh_tree.find('D007854'), matched: 'Lead', index: 1706},
            {heading: @mesh_tree.find('D007854'), matched: 'Lead', index: 2176},
            {heading: @mesh_tree.find('D007854'), matched: 'Lead', index: 3045},
            {heading: @mesh_tree.find('D007854'), matched: 'Lead', index: 3053},
            {heading: @mesh_tree.find('D007854'), matched: 'Lead', index: 3215},
            {heading: @mesh_tree.find('D007854'), matched: 'Lead', index: 3316},
            {heading: @mesh_tree.find('D007854'), matched: 'Lead', index: 3429},
            {heading: @mesh_tree.find('D007858'), matched: 'Learning', index: 689},
            {heading: @mesh_tree.find('D007866'), matched: 'Leg', index: 513},
            {heading: @mesh_tree.find('D007866'), matched: 'Leg', index: 536},
            {heading: @mesh_tree.find('D009275'), matched: 'Name', index: 1660},
            {heading: @mesh_tree.find('D009938'), matched: 'Organization', index: 3602},
            {heading: @mesh_tree.find('D010361'), matched: 'Patient', index: 367},
            {heading: @mesh_tree.find('D010361'), matched: 'Patient', index: 442},
            {heading: @mesh_tree.find('D010361'), matched: 'Patient', index: 599},
            {heading: @mesh_tree.find('D010361'), matched: 'Patient', index: 755},
            {heading: @mesh_tree.find('D010361'), matched: 'Patient', index: 964},
            {heading: @mesh_tree.find('D010361'), matched: 'Patient', index: 1214},
            {heading: @mesh_tree.find('D013850'), matched: 'Thinking', index: 1434},
            {heading: @mesh_tree.find('D013909'), matched: 'Chest', index: 589},
            {heading: @mesh_tree.find('D013909'), matched: 'Chest', index: 620},
            {heading: @mesh_tree.find('D013909'), matched: 'Chest', index: 1826},
            {heading: @mesh_tree.find('D013995'), matched: 'Time', index: 2415},
            {heading: @mesh_tree.find('D014481'), matched: 'United States', index: 176},
            {heading: @mesh_tree.find('D014836'), matched: 'Will', index: 2325},
            {heading: @mesh_tree.find('D014836'), matched: 'Will', index: 3401},
            {heading: @mesh_tree.find('D014836'), matched: 'Will', index: 3493},
            {heading: @mesh_tree.find('D014836'), matched: 'Will', index: 3740},
            {heading: @mesh_tree.find('D014919'), matched: 'Wind', index: 2505},
            {heading: @mesh_tree.find('D014937'), matched: 'Work', index: 1893},
            {heading: @mesh_tree.find('D014965'), matched: 'X-Ray', index: 2510},
            {heading: @mesh_tree.find('D017203'), matched: 'Interview', index: 3678},
            {heading: @mesh_tree.find('D019368'), matched: 'Nature', index: 3267},
            {heading: @mesh_tree.find('D027861'), matched: 'Peach', index: 2663}
          ],
        short_content:
          [
            {heading: @mesh_tree.find('D000269'), matched: 'Glue', index: 586},
            {heading: @mesh_tree.find('D000900'), matched: 'Antibiotics', index: 186},
            {heading: @mesh_tree.find('D001769'), matched: 'Blood', index: 789},
            {heading: @mesh_tree.find('D001786'), matched: 'Blood Sugar', index: 446},
            {heading: @mesh_tree.find('D001786'), matched: 'Blood Sugar', index: 508},
            {heading: @mesh_tree.find('D002241'), matched: 'Sugars', index: 746},
            {heading: @mesh_tree.find('D002241'), matched: 'Sugars', index: 764},
            {heading: @mesh_tree.find('D002241'), matched: 'Sugars', index: 810},
            {heading: @mesh_tree.find('D002241'), matched: 'Sugars', index: 918},
            {heading: @mesh_tree.find('D004247'), matched: 'DNA', index: 946},
            {heading: @mesh_tree.find('D004247'), matched: 'DNA', index: 1010},
            {heading: @mesh_tree.find('D005190'), matched: 'Families', index: 13},
            {heading: @mesh_tree.find('D005246'), matched: 'Feedback', index: 524},
            {heading: @mesh_tree.find('D005389'), matched: 'Guns', index: 591},
            {heading: @mesh_tree.find('D005502'), matched: 'Food', index: 776},
            {heading: @mesh_tree.find('D005947'), matched: 'Glucose', index: 341},
            {heading: @mesh_tree.find('D006624'), matched: 'Hippocampus', index: 1046},
            {heading: @mesh_tree.find('D006728'), matched: 'Hormones', index: 219},
            {heading: @mesh_tree.find('D007328'), matched: 'Insulin', index: 161},
            {heading: @mesh_tree.find('D007328'), matched: 'Insulin', index: 283},
            {heading: @mesh_tree.find('D007328'), matched: 'Insulin', index: 543},
            {heading: @mesh_tree.find('D007328'), matched: 'Insulin', index: 963},
            {heading: @mesh_tree.find('D008099'), matched: 'Liver', index: 318},
            {heading: @mesh_tree.find('D008099'), matched: 'Liver', index: 353},
            {heading: @mesh_tree.find('D010179'), matched: 'Pancreas', index: 127},
            {heading: @mesh_tree.find('D012621'), matched: 'Season', index: 718},
            {heading: @mesh_tree.find('D013213'), matched: 'Starch', index: 471}
          ],
        poor_abstract:
          [
            {heading: @mesh_tree.find('D013337'), matched: 'Medical Students', index: 119}
          ],
        good_abstract:
          [
            {heading: @mesh_tree.find('D000715'), matched: 'Anatomy', index: 1294},
            {heading: @mesh_tree.find('D000715'), matched: 'Anatomy', index: 1411},
            {heading: @mesh_tree.find('D000715'), matched: 'Anatomy', index: 1553},
            {heading: @mesh_tree.find('D001158'), matched: 'Artery', index: 204},
            {heading: @mesh_tree.find('D006801'), matched: 'Human', index: 67},
            {heading: @mesh_tree.find('D008131'), matched: 'London', index: 154},
            {heading: @mesh_tree.find('D008131'), matched: 'London', index: 535},
            {heading: @mesh_tree.find('D008131'), matched: 'London', index: 888},
            {heading: @mesh_tree.find('D009333'), matched: 'Neck', index: 455},
            {heading: @mesh_tree.find('D013334'), matched: 'Students', index: 1535},
            {heading: @mesh_tree.find('D013663'), matched: 'Teaching', index: 1419},
            {heading: @mesh_tree.find('D014836'), matched: 'Will', index: 1175},
            {heading: @mesh_tree.find('D014836'), matched: 'Will', index: 1522},
            {heading: @mesh_tree.find('D014937'), matched: 'Work', index: 504},
            {heading: @mesh_tree.find('D018594'), matched: 'Human Body', index: 400},
            {heading: @mesh_tree.find('D018594'), matched: 'Human Body', index: 1234},
            {heading: @mesh_tree.find('D019359'), matched: 'Knowledge', index: 1597},
            {heading: @mesh_tree.find('D035781'), matched: 'Sister', index: 1506}
          ]
      }
    end

  end

end