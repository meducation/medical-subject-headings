require_relative 'test_helper'

module MESH
  class MeshCoreTest < Minitest::Test

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
      mh = @mesh_tree.find('D000001')
      refute_nil mh
    end

    def test_find_by_tree_number
      mh = @mesh_tree.find_by_tree_number('G14.640.079')
      refute_nil mh
      assert_equal 'D000065', mh.unique_id
    end

    def test_find_by_original_heading
      mh = @mesh_tree.find_by_original_heading('Allergens')
      refute_nil mh
      assert_equal 'D000485', mh.unique_id
    end

    def test_not_find_original_heading_that_doesnt_exist
      mh = @mesh_tree.find_by_original_heading('Lorem')
      assert_nil mh
    end

    def test_have_the_correct_unique_id
      mh = @mesh_tree.find('D000001')
      assert_equal 'D000001', mh.unique_id
    end

    def test_have_the_correct_tree_number
      mh = @mesh_tree.find('D000001')
      assert_equal 1, mh.tree_numbers.length
      assert_includes mh.tree_numbers, 'D03.438.221.173'
    end

    def test_have_the_correct_tree_numbers
      mh = @mesh_tree.find('D000224')
      assert_equal 2, mh.tree_numbers.length
      assert_includes mh.tree_numbers, 'C19.053.500.263'
      assert_includes mh.tree_numbers, 'C20.111.163'
    end

    def test_have_the_correct_root_letters
      mh = @mesh_tree.find('D000224')
      assert_equal ['C'], mh.roots
      mh = @mesh_tree.find('D064946')
      assert_equal ['H', 'N'], mh.roots
    end

    def test_have_the_correct_descriptor_class
      mh = @mesh_tree.find('D000224')
      assert_equal :topical_descriptor, mh.descriptor_class
      mh = @mesh_tree.find('D005260')
      assert_equal :check_tag, mh.descriptor_class
    end

    def test_have_the_correct_original_heading
      mh = @mesh_tree.find('D000224')
      assert_equal 'Addison Disease', mh.original_heading
      mh = @mesh_tree.find('D000014')
      assert_equal 'Abnormalities, Drug-Induced', mh.original_heading
    end

    def test_have_anglicised_original_heading
      mh = @mesh_tree.find('D001471')
      assert_equal 'Barrett Esophagus', mh.original_heading
      assert_equal 'Barrett Oesophagus', mh.original_heading(:en_gb)
    end

    def test_have_natural_language_name
      mh = @mesh_tree.find('D000224')
      assert_equal 'Addison Disease', mh.natural_language_name
      mh = @mesh_tree.find('D000014')
      assert_equal 'Drug-Induced Abnormalities', mh.natural_language_name
    end

    def test_have_anglicised_natural_language_name
      mh = @mesh_tree.find('D001471')
      assert_equal 'Barrett Esophagus', mh.natural_language_name
      assert_equal 'Barrett Oesophagus', mh.natural_language_name(:en_gb)
    end

    def test_have_the_correct_summary
      mh = @mesh_tree.find('D000238')
      assert_equal 'A benign tumor of the anterior pituitary in which the cells do not stain with acidic or basic dyes.', mh.summary
    end

    def test_have_anglicised_summary
      mh = @mesh_tree.find('D001471')
      assert_equal 'A condition with damage to the lining of the lower ESOPHAGUS resulting from chronic acid reflux (ESOPHAGITIS, REFLUX). Through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the INTESTINE or the salmon-pink mucosa of the STOMACH. Barrett\'s columnar epithelium is a marker for severe reflux and precursor to ADENOCARCINOMA of the esophagus.', mh.summary
      assert_equal 'A condition with damage to the lining of the lower OESOPHAGUS resulting from chronic acid reflux (OESOPHAGITIS, REFLUX). Through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the INTESTINE or the salmon-pink mucosa of the STOMACH. Barrett\'s columnar epithelium is a marker for severe reflux and precursor to ADENOCARCINOMA of the oesophagus.', mh.summary(:en_gb)
    end

    def test_linkify_summary
      mh = @mesh_tree.find('D001471')
      assert_equal 'A condition with damage to the lining of the lower ESOPHAGUS resulting from chronic acid reflux (ESOPHAGITIS, REFLUX). Through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the INTESTINE or the salmon-pink mucosa of the STOMACH. Barrett\'s columnar epithelium is a marker for severe reflux and precursor to ADENOCARCINOMA of the esophagus.', mh.summary

      found = {
        'ESOPHAGUS' => false,
        'ESOPHAGITIS, REFLUX' => false,
        'INTESTINE' => false,
        'STOMACH' => false,
        'ADENOCARCINOMA' => false
      }

      linkified_summary = mh.linkify_summary do |text, heading|
        found[text] = true unless heading.nil?
        "<foo>#{text.downcase}</foo>"
      end

      assert_equal 5, found.length
      assert found['ESOPHAGUS']
      assert found['ESOPHAGITIS, REFLUX']
      assert found['INTESTINE']
      assert found['STOMACH']
      assert found['ADENOCARCINOMA']

      assert_equal 'A condition with damage to the lining of the lower <foo>esophagus</foo> resulting from chronic acid reflux (<foo>esophagitis, reflux</foo>). Through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the <foo>intestine</foo> or the salmon-pink mucosa of the <foo>stomach</foo>. Barrett\'s columnar epithelium is a marker for severe reflux and precursor to <foo>adenocarcinoma</foo> of the esophagus.', linkified_summary

    end

    def test_to_s
      mh = @mesh_tree.find('D001471')
      puts mh.inspect
    end

    def test_have_the_correct_entries
      expected_entries = ['Activity Cycles', 'Ultradian Cycles', 'Activity Cycle', 'Cycle, Activity', 'Cycle, Ultradian', 'Cycles, Activity', 'Cycles, Ultradian', 'Ultradian Cycle']
      expected_entries.sort!
      mh = @mesh_tree.find('D000204')
      assert_equal expected_entries, mh.entries
    end

    def test_have_anglicised_entries
      expected_entries = ['Barrett Esophagus', 'Barrett Syndrome', 'Esophagus, Barrett', 'Barrett Epithelium', 'Barrett Metaplasia', 'Barrett\'s Esophagus', 'Barrett\'s Syndrome', 'Barretts Esophagus', 'Barretts Syndrome', 'Epithelium, Barrett', 'Esophagus, Barrett\'s', 'Syndrome, Barrett', 'Syndrome, Barrett\'s']
      expected_entries_en = ['Barrett Oesophagus', 'Barrett Syndrome', 'Oesophagus, Barrett', 'Barrett Epithelium', 'Barrett Metaplasia', 'Barrett\'s Oesophagus', 'Barrett\'s Syndrome', 'Barretts Oesophagus', 'Barretts Syndrome', 'Epithelium, Barrett', 'Oesophagus, Barrett\'s', 'Syndrome, Barrett', 'Syndrome, Barrett\'s']

      expected_entries.sort!
      expected_entries_en.sort!
      mh = @mesh_tree.find('D001471')
      assert_equal expected_entries.sort, mh.entries
      assert_equal expected_entries_en.sort, mh.entries(:en_gb)
    end

    def test_have_the_correct_parent
      mh = @mesh_tree.find('D000001')
      assert_equal 1, mh.parents.length
      assert_equal 'D001583', mh.parents[0].unique_id
    end

    def test_have_the_correct_parents
      mh = @mesh_tree.find('D000224')
      p1 = @mesh_tree.find('D000309')
      p2 = @mesh_tree.find('D001327')
      assert_equal 2, mh.parents.length
      assert_includes mh.parents, p1
      assert_includes mh.parents, p2
    end

    def test_have_the_correct_parents_again
      child = @mesh_tree.find_by_original_heading('Questionnaires')
      assert_equal 1, child.parents.length
      expected_parent = @mesh_tree.find_by_original_heading('Data Collection')
      assert_includes child.parents, expected_parent
    end

    def test_have_the_correct_children
      parent = @mesh_tree.find_by_tree_number('C19.053.500')
      child1 = @mesh_tree.find_by_tree_number('C19.053.500.263')
      child2 = @mesh_tree.find_by_tree_number('C19.053.500.270')
      child3 = @mesh_tree.find_by_tree_number('C19.053.500.480')
      child4 = @mesh_tree.find_by_tree_number('C19.053.500.740')

      assert_equal 4, parent.children.length
      assert_includes parent.children, child1
      assert_includes parent.children, child2
      assert_includes parent.children, child3
      assert_includes parent.children, child4
    end

    def test_have_the_correct_children_again
      parent = @mesh_tree.find_by_original_heading('Data Collection')

      expected_children = [
        'Health Surveys',
        'Interviews as Topic',
        'Questionnaires',
        'Records as Topic',
        'Registries',
        'Vital Statistics',
        'Geriatric Assessment',
        'Nutrition Assessment',
        'Health Care Surveys',
        'Narration',
        'Lot Quality Assurance Sampling',
        'Checklist',
        'Health Impact Assessment',
        'Crowdsourcing'
      ].map { |oh| @mesh_tree.find_by_original_heading(oh) }


      assert_equal expected_children.length, parent.children.length
      expected_children.each do |ec|
        assert_includes parent.children, ec
      end
    end

    def test_have_the_correct_siblings
      skip
    end

    def test_match_on_conditions_for_original_heading
      mh = @mesh_tree.find('D001471')
      assert mh.matches(original_heading: /^Barrett Esophagus$/)
    end

    def test_not_match_on_incorrect_condition_for_original_heading
      mh = @mesh_tree.find('D001471')
      refute mh.matches(original_heading: /^Foo$/)
    end

    def test_match_on_conditions_for_entries
      mh = @mesh_tree.find('D001471')
      assert mh.matches(entries: /Metaplasia/)
    end

    def test_not_match_on_incorrect_conditions_for_entries
      mh = @mesh_tree.find('D001471')
      refute mh.matches(entries: /Foo/)
    end

    def test_match_on_descriptor_class
      mh = @mesh_tree.find('D000224')
      assert mh.matches(descriptor_class: :topical_descriptor)
      refute mh.matches(descriptor_class: :check_tag)
      mh = @mesh_tree.find('D005260')
      assert mh.matches(descriptor_class: :check_tag)
      refute mh.matches(descriptor_class: :topical_descriptor)
    end

    def test_match_on_conditions_for_tree_numbers
      mh = @mesh_tree.find('D001471')
      assert mh.matches(tree_numbers: /C06\.198\.102/)
      assert mh.matches(tree_numbers: /^C06\.198\.102$/)
      assert mh.matches(tree_numbers: /^C06/)
      assert mh.matches(tree_numbers: /\.198\./)
      assert mh.matches(tree_numbers: /^C06\.405\.117\.102$/)
    end

    def test_not_match_on_incorrect_conditions_for_tree_numbers
      mh = @mesh_tree.find('D001471')
      refute mh.matches(tree_numbers: /Foo/)
    end

    def test_match_on_conditions_for_summary
      mh = @mesh_tree.find('D001471')
      assert mh.matches(summary: /the lower ESOPHAGUS resulting from chronic acid reflux \(ESOPHAGITIS, REFLUX\)\./)
    end

    def test_not_match_on_incorrect_conditions_for_summary
      mh = @mesh_tree.find('D001471')
      refute mh.matches(summary: /Foo/)
    end

    def test_match_on_conditions_for_useful
      mh = @mesh_tree.find('D001471')
      begin
        mh.useful = true
        assert mh.matches(useful: true)
        refute mh.matches(useful: false)
        mh.useful = false
        assert mh.matches(useful: false)
        refute mh.matches(useful: true)
      ensure
        mh.useful = true
      end
    end

    def test_match_on_multiple_conditions
      mh = @mesh_tree.find('D001471')
      assert mh.matches(original_heading: /^Barrett Esophagus$/, summary: /the lower ESOPHAGUS/)
    end

    def test_not_match_on_incorrect_multiple_conditions
      mh = @mesh_tree.find('D001471')
      refute mh.matches(original_heading: /^Barrett Esophagus$/, summary: /Foo/)
      refute mh.matches(original_heading: /^Foo/, summary: /the lower ESOPHAGUS/)
    end

    def test_match_headings_that_occur_in_given_text
      expected_ids = %w(D001491 D001769 D001792 D001853 D002470 D002477 D002648 D002965 D002999 D003561 D003593 D003643 D004194 D004314 D004813 D004912 D005091 D005123 D005293 D005333 D005385 D005544 D005796 D006128 D006225 D006309 D006321 D006331 D006405 D007107 D007223 D007231 D007239 D007246 D007938 D007947 D008099 D008168 D008214 D008423 D008533 D008607 D008722 D009035 D009055 D009132 D009154 D009190 D009196 D009369 D009666 D010372 D010641 D011153 D012008 D012106 D012146 D012306 D012307 D012380 D012680 D012867 D013534 D013601 D013812 D013921 D013961 D014034 D014157 D014171 D014960 D015032 D015470 D015994 D015995 D016424 D016433 D017584 D017668 D018387 D018388 D019021 D019070 D019368 D019369 D032882 D036801 D038042 D041905 D052016 D054198 D055016)
      expected = expected_ids.map { |id| @mesh_tree.find(id) }
      matches = @mesh_tree.match_in_text(@example_text)
      actual = matches.map { |match| match[:heading] }.uniq
      assert_equal expected.sort, actual.sort
    end

    def test_sort_based_on_unique_id
      skip
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
        assert_equal expected, actual
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

    def test_allow_headings_to_be_marked_as_not_useful
      mh = @mesh_tree.find('D055550')
      mh.useful = true
      assert mh.useful
      mh.useful = false
      refute mh.useful
      mh.useful = true
      assert mh.useful
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

    def test_know_its_deepest_position_in_the_tree
      #single tree numbers
      assert_equal 1, @mesh_tree.find('D002319').deepest_position
      assert_equal 2, @mesh_tree.find('D001808').deepest_position
      assert_equal 3, @mesh_tree.find('D001158').deepest_position
      assert_equal 4, @mesh_tree.find('D001981').deepest_position
    end

    def test_know_its_shallowest_position_in_the_tree
      #single tree numbers
      assert_equal 1, @mesh_tree.find('D002319').shallowest_position
      assert_equal 2, @mesh_tree.find('D001808').shallowest_position
      assert_equal 3, @mesh_tree.find('D001158').shallowest_position
      assert_equal 4, @mesh_tree.find('D001981').shallowest_position
    end

    def test_know_if_one_heading_is_the_descendant_of_another
      parent = @mesh_tree.find('D002319')
      child = @mesh_tree.find('D001808')
      grandchild = @mesh_tree.find('D001158')
      great_grandchild = @mesh_tree.find('D001981')
      unrelated = @mesh_tree.find('D008091')

      refute parent.has_descendant(parent), 'should not consider itself a desecendant'
      assert parent.has_descendant(child), "should consider child #{child.inspect} a descendant of #{parent.inspect} in #{parent.children}"
      assert parent.has_descendant(grandchild), "should consider grandchild #{grandchild.inspect} a descendant #{parent.inspect}"
      assert parent.has_descendant(great_grandchild), "should consider great grandchild #{great_grandchild.inspect} a descendant #{parent.inspect}"
      refute parent.has_descendant(unrelated), 'should not consider an unrelated heading a descendant'
    end

    def test_know_if_one_heading_is_the_ancestor_of_another
      child = @mesh_tree.find('D001981')
      parent = @mesh_tree.find('D001158')
      grandparent = @mesh_tree.find('D001808')
      great_grandparent = @mesh_tree.find('D002319')
      unrelated = @mesh_tree.find('D008091')

      refute child.has_ancestor(child), 'should not consider itself an ancestor'
      assert child.has_ancestor(parent), "should consider parent #{parent.inspect} an ancestor of #{child.inspect} in #{child.parents}"
      assert child.has_ancestor(grandparent), "should consider grandparent #{grandparent.inspect} an ancestor #{child.inspect}"
      assert child.has_ancestor(great_grandparent), "should consider great grandparent #{great_grandparent.inspect} an ancestor #{child.inspect}"
      refute child.has_ancestor(unrelated), 'should not consider an unrelated heading an ancestor'
    end

    def test_know_if_headings_are_siblings_at_the_same_level_below_a_common_parent
      parent = @mesh_tree.find_by_tree_number('C19.053.500')
      child1 = @mesh_tree.find_by_tree_number('C19.053.500.263')
      child2 = @mesh_tree.find_by_tree_number('C19.053.500.270')
      child3 = @mesh_tree.find_by_tree_number('C19.053.500.480')
      child4 = @mesh_tree.find_by_tree_number('C19.053.500.740')
      unrelated = @mesh_tree.find('D008091')
      children = [child1, child2, child3, child4]

      children.each { |c| refute parent.sibling?(c) }
      children.each { |c| refute c.sibling?(parent) }

      children.each { |c| assert child1.sibling?(c) unless c == child1 }
      children.each { |c| assert c.sibling?(child1) unless c == child1 }

      children.each { |c| refute unrelated.sibling?(c) }
      children.each { |c| refute c.sibling?(unrelated) }
    end

    def test_override_inspect_to_prevent_issues_in_test_diagnostics
      mh = @mesh_tree.find('D001471')
      expected = "#{mh.unique_id}, #{mh.original_heading}, [#{mh.tree_numbers.join(',')}]"
      assert_equal expected, mh.inspect
    end

    def setup
      @@mesh_tree ||= MESH::Tree.new
      @@mesh_tree.load_translation(:en_gb)
      @mesh_tree = @@mesh_tree
      @example_text ||= 'Leukaemia in Downs Syndrome
Overview
Downs Syndrome Leukaemia The link between Downs Syndrome and Leukaemia
Epidemiology
Aetiology
Future research Implications for other leukaemias Treatment
Downs Syndrome
Originally described in 1866
Associated with Trisomy 21 in 1959
Prevalence 1/1000 births
95% due to chromosomal non-disjunction; 5% due to translocations Risk factors:
increased maternal age
1/1000 maternal age 30 years
9/1000 maternal age 40 years
infertility treatment
Clinical Features
physical appearance
intellectual disability
developmental delay
sensory abnormalities congenital heart disease
Alzheimers Disease
GI malformations
thyroid disorders
poor immune system
LEUKAEMIA
Downs Syndrome
Leukaemia
cancer
WBC proliferation in the bone marrow
Classification:
acute/chronic
type of WBC
Current leukaemia model:
2 co-operating mutations
1 leading to impaired differentiation
1 leading to increased proliferation/cell survival
Picture: Hitzler & Zipursky, 2005
Leukaemia
Acute lymphoblastic leukaemia (ALL)
derived from B lymphocyte or T lymphocyte precursors
80% childhood leukaemia
Acute myeloid leukaemia (AML)
e.g. myeloid, monocytic, megakaryocytic, erythroid
20% childhood leukaemia
Acute megakaryoblastic leukaemia (AMKL)
AML subtype: leukaemic cells have platelet precursor phenotype
6% childhood AML cases
Leukaemia in Downs Syndrome
10-20 fold increased risk of leukaemia
ALL
80% childhood leukaemia; 60% Downs Syndrome leukaemia
20 times higher incidence children with Downs Syndrome compared to children without Downs Syndrome AML
20% childhood leukaemia; 40% Downs Syndrome leukaemia AMKL
6% childhood AML; 62% Downs Syndrome AML
500 times higher incidence children with Downs Syndrome compared to children without Downs Syndrome
Leukaemia in Downs Syndrome
AML in Downs Syndrome
AMKL in most cases
younger median age of onset
2 in Downs Syndrome
8 in non-Downs Syndrome
myelodysplastic syndrome more common prior to leukaemia
Transient Leukaemia
Transient Leukaemia
Also termed: Transient Abnormal Myelopoiesis and Transient Myeloproliferative Disorder
10% newborn infants with Downs Syndrome
peripheral blood contains clonal population of megakaryoblasts
cannot be distinguished from AMKL blasts by routine methods
usually clinically silent
usually disappear within 3 months
majority of cases totally resolve
However
can be fatal
20% develop MDS and AMKL by the age of 4 yearsTransient Leukaemia
Leukaemic cells in Transient Leukaemia and AMKL can:
show variable megakaryocytic differentiation
show features of multiple haematopoietic lineages Evidence that Transient Leukaemia is a precursor for AMKL
near identical morphology, immunophenotype, ultrastructure
clone-specific GATA1 mutations
GATA1: X chromosome, zinc-finger transcription factor, essential for differentiation of megakaryocytic, erythroid and basophillic lineages
therefore have common cell of originLeukaemic cells in Transient Leukaemia and AMKL in Downs Syndrome can form megakaryocytic, erythroid or basophillic lineages
GATA1
all Transient Leukaemia and AMKL cases have GATA1 mutations
most abrogate splicing of exon 2 or produce stop codon prior to alternative start codon at position 84
lack N-terminal domain
mutations disappear upon remission
disease specific mutations
leukemogenisis model: transcription factor mutation blocks differentiation
GATA1 mutation determines haematopoietic lineage
GATA1 mutations present in Transient Leukaemia at birth
mutations in utero
proportion of Downs Syndrome fetuses acquire GATA1 mutation
large clone = Transient Leukaemia
small clone = no clinical signs
Aetiology
Three distinct steps:
fetal heamatopoietic cell with trisomy 21
rare Transient Leukaemia cases in people without Downs syndrome
acquired trisomy 21 only in haematopoietic cells
mutation of GATA1
expression of shortened
GATA1 (GATA1s) extra, as of yet unknown event
not all cases of Transient
Leukaemia progress to AMKL
Picture: Hitzler & Zipursky, 2005
Aetiology
Transient Leukaemia with clinical signs of disease
Transient Leukaemia with no clinical signs of diseasePicture: Ahmed et al, 2004
Future Research
Loss of GATA1 function in people without Downs Syndrome results in:
accumulation of abnormally differentiated megakaryocytes
thrombocytopenia
NO LEUKAEMIC TRANSFORMATION
discovered by Shivdasani et al, 1997
What is the effect of Trisomy 21
What advantage does GATA1 mutation provide to people with Downs SyndromeWhat is the second-hitImplications for other leukaemias
current acute leukaemia model:
2 co-operating mutations
1 leading to impaired differentiation
1 leading to increased proliferation/cell survival
This means that that the sequence of Transient Leukaemia to AMKL as seen in Downs Syndrome is a chance to investigate this model of leukaemia and discover the timing and nature of the 2 necessary events.
Treatment of Leukaemia in Downs Syndrome
AML (AMKL)
increased sensitivity to cytarabine
80% 5 year survival
failure usually due to toxicity (mucositis and infection)ALL
similar treatment as in AML
60-70% cure rate (75-85% in population without Downs Syndrome)
no increased sensitivity, but increased toxicity
dose reduction would increase risk of relapse
supportive care
References
Ahmed, M., Sternberg, A., Hall, G., Thomas, A., Smith, O., OMarcaigh, A., Wynn, R., Stevens, R., Addison, M., King, D., Stewart, B., Gibson, B., Roberts, I., Vyas, P. (2004). Natural History of GATA1 mutations in Down syndrome, Blood, 103(7):2480-2489.
Hitzler, J.K., Cheung, J., Li, Y., Scherer, S.W., Zipursky, A. (2003). GATA1 mutations in transient leukaemia and acute megakaryoblastic leukaemia of Down syndrome, Blood, 101(11):4301-4304.
Hitzler, J.K., Zipursky, A. (2005). Origins of leukaemia in children with down syndrome, Cancer, 5:11-20.
Puumala, S.E., Ross, J.A., Olshan, A.F., Robison, L.L., Smith, F.O., Spector, L.G. (2007). Reproductive history, infertility treatment, and the risk of acute leukaemia in children with down syndrome, Cancer, [Epub ahead of print].
Shivdasani, R.A., Fujiwara, Y., McDevitt, M.A., Orkin, S.H. (1997). A loneage-selective knockout establishes the critical role of transcription factor GATA-1 in megakaryocyte growth and platelet development, Embo J., 16:3965-3973.
Slordahl, S.H. et al. (1993). Leukaemic blasts with markers of four cell lineages in Down\'s syndrome (megakaryoblastic leukaemia), Med. Pediatr. Oncol., 21:254-258.
Vyas, P., Crispino, J.D. (2007). Molecular insights into Down syndrome-associated leukemia, Current Opinion in Pediatrics, 19:9-14.
Webb, D., Roberts, I., Vyas, P. (2007). Haematology of Down syndrome, Arch. Dis. Child. Fetal Neonatal Ed., [published online 5 Sep 2007].
http://www.intellectualdisability.info/home.htm
http://news.bbc.co.uk/nol/shared/spl/hi/pop_ups/05/health_shifting_perspectives/img/1.jpg
Originally described by John Langdon Down
Associated with Trisomy 21 by Professor Jerome Lejeune
Overall incidence is 1/1000, so 600 babies with Downs syndrome are born in the UK each year
It is estimated that there are 60,000 people living with Downs syndrome in the UK
80% of children with Downs Syndrome are born to mothers under 35 years of age
Research suggests that infertility treatment increases risk of chromosomal abnormalitiesFacial appearance: flat profile, flat nasal bridge, small nose, eyes that slant upwards and outwards often with an epicanthic fold a fold of skin that runs vertically between the lids at the inner corner of the eye), small mouth.
Body appearance: reduced muscle tone, big space between first and second toe, broad hands with short fingers and a little finger that curves inwards, often a single palmar crease.
Sensory abnormalities: visual and hearing
Congenital Heart Disease is present in 50% of people with Downs SyndromeThere are two methods of classifying leukaemias: acute/chronic or according to the type of WBC that is proliferating abnormally ALL describes leukaemia where the cancerous cell is derived from precursors of B or less commonly T lymphocytes.  ALL makes up 80% of all childhood leukaemias.
AML describes leukaemia where the cancerous cell is not B or T cell derived and the subtype is determined by the phenotype of the leukaemic cells.  AML makes up 20% of childhood leukaemias.
AMKL is a subtype of AML where the leukaemic cell looks like platelet precursors.  AMKL makes up 6% of childhood AML cases.ALL makes up 80% of childhood leukaemia, but 60% of leukaemia in children with DS.  Children with DS have a 20 fold increased risk of developing ALL when compared to children without DS.
AML makes up 20% of childhood leukaemia, but 40% of leukaemia in children with DS.
AMKL makes up 6% of childhood AML, but in children with Downs Syndrome makes up 62% of AML cases.  Children with DS have a 500 fold increased risk of developing AMKL when compared to children without DS.The rest of this talk is going to focus on AMKL in DS.  The majority of AML cases in DS are AMKL and have a younger age of onset than in the population without DS.  AMKL in DS much more commonly begins as a MDS.  This is a process of abnormal megakaryocytic differentiation.  Furthermore, children with DS are at risk of Transient Leukaemia  a condition that is almost exclusive to children with DS.Tranisent leukaemia is only found in infants with DS and is found in about 10% of newborns with DS.  These children are born with a clonal population of megakaryoblasts in their blood.  These megakaryoblasts cannot be distinguished from the blasts of AMKL by routine methods and usually spontaneously disappear within the first 3 months of life.
TL begins in utero and usually does not cause any symptoms.  The majority of cases resolve and the children do not have any lasting haematological problems.  There is no evidence as to how TL spontaneously resolves.  However, it can also be fatal due liver damage or complications in the lungs or heart and 20% of children with TL proceed to develop MDS and AMKL by the age of 4 years.mutations of GATA1 are present in the cells of TL and AMKL in Downs Syndrome and these cells can become megakaryocytes, erythroid cells or basophils!  The megakaryoctic lineage is particularly dependant on the level of expression of GATA1.
MULTIPLE HAEMATOPOIETIC LINEAGES: for example precursor cells of erythrocytes and basophils.  Ferritin is found in the cytoplasm of DS-AMKL cells.
This slide equates the aeitology to the model of leukaemia I mentioned earlier, with points 2 and 3 being the 2 mutations.
2) It is currently not known if it is the absence of normal GATA1 or the presence of GATA1s that causes leukaemic proliferation of megakaryocytes.  It could be both, because GATA1s fails to suppress some pro-proliferative genes such as GATA2 and MYC)  although these are pro-proliferative for erythrocytes.The previous slide shows us how a child with DS can progress to developing AMKL.  Of course we know that not all children with DS or indeed all children with DS and Transient Leukaemia proceed to develop AMKL.  This slide shows us all the possible routes children with DS can take.
Normal
GATA1s  small clone or large clone
clonal extinction  normal
clonal expansion plus additional genetic event  AMKL
AMKL  death or remission (normal)Although our understanding of leukaemia in DS have progressed a long way over recent years, there still remain unknowns in the aetiology.
Loss of GATA1 function has different effect on people without DS and people with DS  therefore what is the effect of Trisomy 21
why are GATA1 mutations so relatively common in children with DS  It has been postulated that there may be some selective advantage, but it is only a hypothesis.
thirdly, what is the second-hit  We know that there must be a second genetic event, with GATA1 mutation being the first, but we do not know what this is yet.NB: GATA1 mutation is the first mutation for DS-AMKL.AML  failure of treatment usually due to toxicity due to mucositis and infection.  Resistant disease and relapse are rare.
ALL  there is no increased sensitivity to treatment, but there is increased risk of toxicity.  Cannot reduce the dose because of the high risk of relapse and so the emphasis is now on improving supportive care.
'
    end
  end
end