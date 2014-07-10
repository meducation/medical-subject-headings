require_relative 'test_helper'

module MESH
  class HeadingTest < TestBase

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

    def test_have_the_correct_semantic_type
      mh = @mesh_tree.find('D000224')
      assert_equal ['Disease or Syndrome'], mh.semantic_types
      mh = @mesh_tree.find('D005260')
      assert_equal ['Organism Attribute'], mh.semantic_types
      mh = @mesh_tree.find('D014148')
      assert_equal ['Organic Chemical', 'Pharmacologic Substance'], mh.semantic_types

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
      original_summary = 'A condition with damage to the lining of the lower ESOPHAGUS resulting from chronic acid reflux (ESOPHAGITIS, REFLUX). Through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the INTESTINE or the salmon-pink mucosa of the STOMACH. Barrett\'s columnar epithelium is a marker for severe reflux and precursor to ADENOCARCINOMA of the esophagus.'
      assert_equal original_summary, mh.summary

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

      assert_equal original_summary, mh.summary
      assert_equal 'A condition with damage to the lining of the lower <foo>esophagus</foo> resulting from chronic acid reflux (<foo>esophagitis, reflux</foo>). Through the process of metaplasia, the squamous cells are replaced by a columnar epithelium with cells resembling those of the <foo>intestine</foo> or the salmon-pink mucosa of the <foo>stomach</foo>. Barrett\'s columnar epithelium is a marker for severe reflux and precursor to <foo>adenocarcinoma</foo> of the esophagus.', linkified_summary

    end

    def test_linkifies_another_summary
      mh = @mesh_tree.find_by_original_heading('Diabetic Nephropathies')
      linkified_summary = mh.linkify_summary do |text, heading|
        "<linky href=\"#{heading.unique_id}\">#{text.downcase}</linky>"
      end

      expected_summary = 'KIDNEY injuries associated with diabetes mellitus and affecting KIDNEY GLOMERULUS; ARTERIOLES; KIDNEY TUBULES; and the interstitium. Clinical signs include persistent PROTEINURIA, from microalbuminuria progressing to ALBUMINURIA of greater than 300 mg/24 h, leading to reduced GLOMERULAR FILTRATION RATE and END-STAGE RENAL DISEASE.'

      expected_linkified = '<linky href="D007668">kidney</linky> injuries associated with diabetes mellitus and affecting <linky href="D007678">kidney glomerulus</linky>; <linky href="D001160">arterioles</linky>; <linky href="D007684">kidney tubules</linky>; and the interstitium. Clinical signs include persistent <linky href="D011507">proteinuria</linky>, from microalbuminuria progressing to <linky href="D000419">albuminuria</linky> of greater than 300 mg/24 h, leading to reduced <linky href="D005919">glomerular filtration rate</linky> and <linky href="D007676">end-stage renal disease</linky>.'


      assert_equal expected_summary, mh.summary
      assert_equal expected_linkified, linkified_summary
    end

    def test_to_s
      mh = @mesh_tree.find('D001471')
      assert_equal 'D001471, Barrett Esophagus, [C06.198.102,C06.405.117.102]', mh.to_s
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

    def test_has_structured_entries

      mh = @mesh_tree.find_by_original_heading('Acetaminophen')
      assert_equal 19, mh.structured_entries.length

      expected_terms = ['Acetamidophenol', 'Hydroxyacetanilide', 'Paracetamol', 'APAP', 'Acamol', 'Acephen', 'Acetaco', 'Acetominophen', 'Algotropyl', 'Anacin-3', 'Datril', 'N-(4-Hydroxyphenyl)acetanilide', 'N-Acetyl-p-aminophenol', 'Panadol', 'Tylenol', 'p-Acetamidophenol', 'p-Hydroxyacetanilide', 'Anacin 3', 'Anacin3']

      actual_terms = mh.structured_entries.map { |tn| tn.term }

      assert_equal actual_terms, expected_terms


# PRINT ENTRY = Acetamidophenol|T109|T121|NON|EQV|UNK (19XX)|771118|abbcdef
# PRINT ENTRY = Hydroxyacetanilide|T109|T121|NON|EQV|UNK (19XX)|740329|abbcdef
# PRINT ENTRY = Paracetamol|T109|T121|NON|EQV|BAN (19XX)|FDA SRS (2014)|INN (19XX)|740329|abbcdeeef
# ENTRY = APAP|T109|T121|NON|EQV|BAN (19XX)|FDA SRS (2014)|020515|abbcdeef
# ENTRY = Acamol|T109|T121|TRD|NRW|NLM (1995)|930902|abbcdef
# ENTRY = Acephen|T109|T121|TRD|NRW|NLM (1991)|900509|abbcdef
# ENTRY = Acetaco|T109|T121|TRD|REL|UNK (19XX)|861022|abbcdef
# ENTRY = Acetominophen|T109|T121|NON|EQV|UNK (19XX)|810625|abbcdef
# ENTRY = Algotropyl|T109|T121|TRD|REL|UNK (19XX)|800825|abbcdef
# ENTRY = Anacin-3|T109|T121|TRD|NRW|UNK (19XX)|861119|abbcdef
# ENTRY = Datril|T109|T121|NON|NRW|UNK (19XX)|861119|abbcdef
# ENTRY = N-(4-Hydroxyphenyl)acetanilide|T109|T121|NON|EQV|NLM (1996)|950330|abbcdef
# ENTRY = N-Acetyl-p-aminophenol|T109|T121|NON|EQV|UNK (19XX)|800813|abbcdef
# ENTRY = Panadol|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef
# ENTRY = Tylenol|T109|T121|TRD|NRW|UNK (19XX)|830223|abbcdef
# ENTRY = p-Acetamidophenol|T109|T121|NON|EQV|UNK (19XX)|800813|abbcdef
# ENTRY = p-Hydroxyacetanilide|T109|T121|NON|EQV|UNK (19XX)|800801|abbcdef
# ENTRY = Anacin 3
# ENTRY = Anacin3

    end

    def test_have_a_single_wikipedia_link

      expected = {
        'D000001' => 'http://en.wikipedia.org/wiki/A23187',
        'D000005' => 'http://en.wikipedia.org/wiki/Abdomen',
        'D000082' => 'http://en.wikipedia.org/wiki/Paracetamol'
      }

      expected.each do |id, expected_link|
        mh = @mesh_tree.find(id)
        assert_equal 1, mh.wikipedia_links.length
        assert_equal expected_link, mh.wikipedia_links[0][:link]
      end

    end

    def test_have_a_single_wikipedia_score
      expected = {
        'D000001' => 0.5,
        'D000005' => 1.0,
        'D000082' => 0.35
      }

      expected.each do |id, expected_score|
        mh = @mesh_tree.find(id)
        assert_equal 1, mh.wikipedia_links.length
        assert_equal expected_score, mh.wikipedia_links[0][:score]
      end

    end

    def test_have_a_single_wikipedia_image
      expected = {
        'D000001' => 'http://upload.wikimedia.org/wikipedia/commons/thumb/1/17/A23187.png/220px-A23187.png',
        'D000005' => 'http://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Abdomen_%28PSF%29.jpg/250px-Abdomen_%28PSF%29.jpg',
        'D000082' => 'http://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Paracetamol-skeletal.svg/150px-Paracetamol-skeletal.svg.png'
      }

      expected.each do |id, expected_image|
        mh = @mesh_tree.find(id)
        assert_equal 1, mh.wikipedia_links.length
        assert_equal expected_image, mh.wikipedia_links[0][:image]
      end
    end

    def test_have_a_single_wikipedia_abstract
      expected = {
        'D000001' => '| CAS_number = 52665-69-7',
        'D000005' => 'The abdomen (less formally called the belly, stomach, or tummy), in vertebrates such as mammals, constitutes the part of the body between the thorax (chest) and pelvis. The region enclosed by the abdomen is termed the abdominal cavity.',
        'D000082' => '| MedlinePlus = a681004'
      }

      expected.each do |id, expected_abstract|
        mh = @mesh_tree.find(id)
        assert_equal 1, mh.wikipedia_links.length
        assert_equal expected_abstract, mh.wikipedia_links[0][:abstract]
      end
    end

    def test_have_more_than_one_wikipedia_link
      mh = @mesh_tree.find('D000100')
      expected = %w(
        http://en.wikipedia.org/wiki/Sodium_acetrizoate
        http://en.wikipedia.org/wiki/Acetrizoic_acid
      )
      assert_equal expected, mh.wikipedia_links.map { |l| l[:link] }
    end

    def test_have_more_than_one_wikipedia_score
      mh = @mesh_tree.find('D000100')
      expected = [0.09, 0.09]
      assert_equal expected, mh.wikipedia_links.map { |l| l[:score] }
    end

    def test_have_more_than_one_wikipedia_image
      mh = @mesh_tree.find('D000100')
      expected = %w(
        http://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Sodium_acetrizoate.svg/150px-Sodium_acetrizoate.svg.png
        http://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Acetrizoic_acid.png/220px-Acetrizoic_acid.png
      )
      assert_equal expected, mh.wikipedia_links.map { |l| l[:image] }
    end

    def test_have_more_than_one_wikipedia_abstract
      mh = @mesh_tree.find('D000100')
      expected = ['| CAS_number = 129-63-5', '| CAS_number = 85-36-9']
      assert_equal expected, mh.wikipedia_links.map { |l| l[:abstract] }
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

    def test_allow_headings_to_be_marked_as_not_useful
      mh = @mesh_tree.find('D055550')
      mh.useful = true
      assert mh.useful
      mh.useful = false
      refute mh.useful
      mh.useful = true
      assert mh.useful
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
      @mesh_tree = @@mesh_tree
    end

  end
end

