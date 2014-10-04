require_relative 'test_helper'

module MESH
  class TreeTest < TestBase

    attr_accessor :example_text

    def test_yield_to_a_block_for_each
      block_called = false
      @mesh_tree.each do |h|
        block_called = true
        break
      end
      assert block_called
    end

    def test_not_have_nil_headings
      @mesh_tree.each do |h|
        refute_nil h
      end
    end

    def test_find_by_unique_id
      mh = @mesh_tree.find_heading_by_unique_id('D000001')
      refute_nil mh
      assert_equal '', mh.original_heading
    end

    def test_find_by_tree_number
      mh = @mesh_tree.find_heading_by_tree_number('G14.640.079')
      refute_nil mh
      assert_equal 'D000065', mh.unique_id
    end

    def test_find_heading_by_main_heading
      mh = @mesh_tree.find_heading_by_main_heading('Allergens')
      refute_nil mh
      assert_equal 'D000485', mh.unique_id
    end

    def test_not_find_original_heading_that_doesnt_exist
      mh = @mesh_tree.find_heading_by_main_heading('Lorem')
      assert_nil mh
    end

    def test_entry_by_term

      expected_terms = [
          'Adult Reye Syndrome',
          'Adult Reye\'s Syndrome',
          'Fatty Liver with Encephalopathy',
          'Reye Johnson Syndrome',
          'Reye Like Syndrome',
          'Reye Syndrome',
          'Reye Syndrome, Adult',
          'Reye\'s Like Syndrome',
          'Reye\'s Syndrome',
          'Reye\'s Syndrome, Adult',
          'Reye\'s-Like Syndrome',
          'Reye-Johnson Syndrome',
          'Reye-Like Syndrome'
      ]

      expected_heading = @mesh_tree.find_heading_by_unique_id('D012202')

      # entries_to_test = expected_entries.flat_map do |e|
      #   [e, e.upcase, e.downcase, " #{e.downcase} ", "\n\n\t #{e.downcase}\t "]
      # end

      expected_terms.each do |term|
        entry = @mesh_tree.find_entry_by_term(term)
        refute_nil entry, "Failed to find entry by term '#{term}'"
        assert_equal expected_heading, entry.heading, "Found wrong heading by entry '#{entry}'"
      end

    end

    def test_find_by_translated_entry
      assert_equal @mesh_tree.find('D000011'), @mesh_tree.find_by_entry('Leukaemia Virus, Abelson')
      assert_equal @mesh_tree.find('D000250'), @mesh_tree.find_by_entry('Adenylyl Sulphate')
    end

    def test_find_by_entry_doesnt_match
      assert_nil @mesh_tree.find_by_entry('foo')
    end

    def test_find_by_entry_word
      expected_ids = %w(D000003)
      actual = @mesh_tree.find_by_entry_word('abattoir')
      actual_ids = actual.map { |mh| mh.unique_id }
      assert_equal expected_ids, actual_ids, 'Should return all headings with this word in any entry'
    end

    def test_find_by_entry_word_case_insensitive
      skip 'find by word does not support case insensitive searches'
      # expected_ids = %w(D000003)
      # actual = @mesh_tree.find_by_entry_word('AbaTToir')
      # actual_ids = actual.map { |mh| mh.unique_id }
      # assert_equal expected_ids, actual_ids, 'Should return all headings with this word in any entry'
    end

    def test_find_by_translated_entry_word
      expected_ids = %w(D001471 D004938 D004947 D015154)
      actual = @mesh_tree.find_by_entry_word('oesophagus')
      actual_ids = actual.map { |mh| mh.unique_id }
      assert_equal expected_ids, actual_ids, 'Should return all headings with this word in any entry'
    end

    def find_entries_by_word
      expected_terms = %w()
      actual_entries = @mesh_tree.find_entries_by_word('abattoir')
      actual_terms = actual_entries.map { |entry| entry.term }
      assert_equal expected_terms, actual_terms
    end

    def test_linkifies_all_summaries
      mesh = MESH::Tree.new
      mesh.linkify_summaries do |text, heading|
        "<bar>#{text.downcase}</bar>"
      end
      mh = mesh.find('D001471')
      assert_equal 'A condition with damage to the lining of the lower <bar>esophagus</bar> resulting from chronic acid reflux (<bar>esophagitis, reflux</bar>). Through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the <bar>intestine</bar> or the salmon-pink mucosa of the <bar>stomach</bar>. Barrett\'s columnar epithelium is a marker for severe reflux and precursor to <bar>adenocarcinoma</bar> of the esophagus.', mh.linkified_summary
    end

    def test_match_headings_that_occur_in_given_text
      expected_ids = %w(D001491 D001769 D001792 D001853 D002470 D002477 D002648 D002965 D002999 D003561 D003593 D003643 D004194 D004314 D004813 D004912 D005091 D005123 D005293 D005333 D005385 D005544 D005796 D006128 D006225 D006309 D006321 D006331 D006405 D007107 D007223 D007231 D007239 D007246 D007938 D007947 D008099 D008168 D008214 D008423 D008533 D008607 D008722 D009035 D009055 D009132 D009154 D009190 D009196 D009369 D009666 D010372 D010641 D011153 D012008 D012106 D012146 D012306 D012307 D012380 D012680 D012867 D013534 D013601 D013812 D013921 D013961 D014034 D014157 D014171 D014960 D015032 D015470 D015994 D015995 D016424 D016433 D017584 D017668 D018387 D018388 D019021 D019070 D019368 D019369 D032882 D036801 D038042 D041905 D052016 D054198 D055016)
      expected = expected_ids.map { |id| @mesh_tree.find(id) }
      matches = @mesh_tree.match_in_text(@example_text)
      actual = matches.map { |match| match[:heading] }.uniq
      assert_equal expected.sort, actual.sort
    end

    def test_only_match_the_most_specific_matches_in_given_text
      expected = @mesh_tree.find('D054144')
      actual = @mesh_tree.match_in_text('Diastolic Heart Failure')
      assert_equal 1, actual.length
      assert_equal expected, actual.first[:heading]
    end

    def test_only_match_useful_headings_that_occur_in_given_text
      expected_ids = %w(D001491 D001769 D001792 D001853 D002470 D002648 D002875 D002965 D003561 D003593 D003643 D004194 D004314 D004813 D004912 D005091 D005123 D005293 D005333 D005385 D005544 D005796 D006128 D006225 D006309 D006321 D006331 D006405 D007107 D007231 D007239 D007938 D007947 D008099 D008168 D008214 D008423 D008607 D008722 D009035 D009055 D009132 D009154 D009190 D009196 D009369 D009666 D010372 D010641 D011153 D012008 D012106 D012146 D012306 D012307 D012380 D012680 D012867 D013534 D013601 D013812 D013921 D013961 D014034 D014157 D014171 D015032 D015470 D015994 D015995 D016424 D017584 D017668 D018387 D018388 D019021 D019070 D019368 D019369 D032882 D036801 D038042 D041905 D052016 D054198)

      not_useful_ids = %w(D007246 D002477 D014960 D008533 D016433 D006664 D055016 D002999 D007223)
      begin
        not_useful_ids.each { |id| @mesh_tree.find(id).useful = false }

        expected = expected_ids.map { |id| @mesh_tree.find(id) }
        matches = @mesh_tree.match_in_text(@example_text)
        actual = matches.map { |match| match[:heading] }.uniq
        assert_equal expected.sort, actual.sort
      ensure
        not_useful_ids.each { |id| @mesh_tree.find(id).useful = true }
      end
    end

    def test_match_headings_at_start_of_text
      text = 'Leukemia, lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec pretium leo diam, quis adipiscing purus bibendum eu.'
      matches = @mesh_tree.match_in_text(text)
      assert_equal 1, matches.length
      assert_equal @mesh_tree.find('D007938'), matches[0][:heading]
    end

    def test_match_headings_at_end_of_text
      text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec pretium leo diam, quis adipiscing purus bibendum eu leukemia'
      matches = @mesh_tree.match_in_text(text)
      assert_equal 1, matches.length
      assert_equal @mesh_tree.find('D007938'), matches[0][:heading]
    end

    def test_return_no_matches_when_given_nil_text
      assert_equal [], @mesh_tree.match_in_text(nil)
    end

    def test_only_match_uppercase_entries_with_uppercase_text
      text = 'Lorem amet, consectetur adipiscing elit. Donec pretium ATP leo diam, quis adipiscing purus bibendum.'
      matches = @mesh_tree.match_in_text(text)
      assert_equal 1, matches.length
      assert_equal @mesh_tree.find('D000255'), matches[0][:heading]
      text = 'Lorem ipsum consectetur adipiscing elit. Donec pretium atp leo diam, quis adipiscing purus bibendum.'
      assert_equal [], @mesh_tree.match_in_text(text)
    end

    def test_match_anglicised_terms_in_text
      text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec pretium leo diam, quis adipiscing purus bibendum eu leukaemia'
      matches = @mesh_tree.match_in_text(text)
      assert_equal 1, matches.length
      assert_equal @mesh_tree.find('D007938'), matches[0][:heading]
    end

    def test_allow_headings_to_be_found_with_a_where_match_on_original_heading
      expected = [@mesh_tree.find('D003561'), @mesh_tree.find('D016238')]
      actual = @mesh_tree.where(original_heading: /^Cyta/)
      assert_equal expected, actual
    end

    def test_match_on_entries_in_where
      expected_ids = %w( D002397 D003064 D003400 D003532 D004284 D004289 D004555 D005412 D006054 D006196 D007059 D007497 D007695 D009990 D010473 D012091 D012487 D012758 D013215 D015027 D020410 D023721 D023761 D023781 D024541 D029961 D037401 D037462 D048251 D049832 D052656 D057096 )
      expected = expected_ids.map { |id| @mesh_tree.find(id) }
      actual = @mesh_tree.where(entries: /fish/)
      assert_equal expected, actual
    end

    def test_match_on_tree_numbers_in_where
      expected_ids = %w( D000005 D001415 D010388 D013909 )
      expected = expected_ids.map { |id| @mesh_tree.find(id) }
      actual = @mesh_tree.where(tree_numbers: /^A01\.923\.[0-9]{3}$/)
      assert_equal expected, actual
    end

    def test_match_on_useful_in_where
      expected = [@mesh_tree.find('D012000'), @mesh_tree.find('D064906'), @mesh_tree.find('D064966')]
      begin
        expected.each { |mh| mh.useful = false }
        actual = @mesh_tree.where(useful: false)
        assert_equal expected, actual
      ensure
        expected.each { |mh| mh.useful = true }
      end
    end

    def test_match_on_descriptor_class_in_where
      expected = [@mesh_tree.find('D012000'), @mesh_tree.find('D064906'), @mesh_tree.find('D064966')]
      begin
        expected.each { |mh| mh.descriptor_class = :foo }
        actual = @mesh_tree.where(descriptor_class: :foo)
        assert_equal expected, actual
      ensure
        expected.each { |mh| mh.descriptor_class = :topical_descriptor }
      end
    end

    def test_only_include_useful_headings_in_each
      begin
        @mesh_tree.each do |mh|
          mh.useful = false
        end
        @mesh_tree.where(unique_id: /^D0000/).each do |mh|
          mh.useful = true
        end
        count = 0
        @mesh_tree.each do |mh|
          assert mh.useful
          count += 1
        end
        assert_equal 95, count
      ensure
        @mesh_tree.where(useful: false).each do |mh|
          mh.useful = true
        end
      end
    end

  end
end
