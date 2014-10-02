require_relative 'test_helper'

module MESH
  class EntryTest < TestBase

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

    def test_has_heading
      entry = Entry.new(@parent_heading, 'Anacin3')
      assert_equal @parent_heading, entry.heading
    end

    def test_construct_from_plain_string
      entry = Entry.new(@parent_heading, 'Anacin3')
      assert_equal 'Anacin3', entry.term
      assert_nil entry.semantic_relationship
    end

    def test_has_lexical_type
      entry = Entry.new(@parent_heading, 'Panadol|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef')
      assert_equal 'Panadol', entry.term
      assert_equal :trade_name, entry.lexical_type
    end

    def test_has_semantic_relationship
      entry = Entry.new(@parent_heading, 'Panadol|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef')
      assert_equal 'Panadol', entry.term
      assert_equal :narrower, entry.semantic_relationship
    end

    def test_has_semantic_types
      entry = Entry.new(@parent_heading, 'Panadol|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef')
      assert_equal 'Panadol', entry.term
      assert_equal ['Organic Chemical', 'Pharmacologic Substance'], entry.semantic_types
    end

    def test_knows_own_case_sensitivity
      entry = Entry.new(@parent_heading, 'Panadol|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef')
      refute entry.case_sensitive
      entry = Entry.new(@parent_heading, 'AND|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef')
      assert entry.case_sensitive
      entry = Entry.new(@parent_heading, 'A122|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef')
      assert entry.case_sensitive
      entry = Entry.new(@parent_heading, 'Panadol978|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef')
      refute entry.case_sensitive
    end

    def test_has_correct_case_insensitive_regex
      entry = Entry.new(@parent_heading, 'Panadol|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef')
      assert_equal /(^|\W)Panadol(\W|$)/i, entry.regex
    end

    def test_has_correct_case_sensitive_regex
      entry = Entry.new(@parent_heading, 'AND|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef')
      assert_equal /(^|\W)AND(\W|$)/, entry.regex
    end

    def test_matches_nil_or_empty_with_nil
      entry = Entry.new(@parent_heading, 'WBC|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef')
      assert_nil entry.match_in_text(nil)
      assert_nil entry.match_in_text('')
      assert_nil entry.match_in_text("")
    end

    def test_matches_nil_when_no_matches
      entry = Entry.new(@parent_heading, 'WBC|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef')
      assert_nil entry.match_in_text('text that does not include the term')
    end

    def test_matches_itself_in_text_when_all_caps
      entry = Entry.new(@parent_heading, 'WBC|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef')

      expected_matches = [
          {heading: entry.heading, matched: entry, index: [720, 725]},
          {heading: entry.heading, matched: entry, index: [795, 800]},
          {heading: entry.heading, matched: entry, index: [7854, 7859]}
      ]

      actual_matches = entry.match_in_text(@example_text)

      refute_nil actual_matches
      assert_equal expected_matches, actual_matches
    end

    def test_matches_itself_in_text
      entry = Entry.new(@parent_heading, 'Leukaemia')

      expected_matches = [
          {heading: @parent_heading, matched: entry, index: [0, 10]},
          {heading: @parent_heading, matched: entry, index: [51, 62]},
          {heading: @parent_heading, matched: entry, index: [97, 108]},
          {heading: @parent_heading, matched: entry, index: [678, 689]},
          {heading: @parent_heading, matched: entry, index: [703, 714]},
          {heading: @parent_heading, matched: entry, index: [807, 818]},
          {heading: @parent_heading, matched: entry, index: [972, 983]},
          {heading: @parent_heading, matched: entry, index: [1002, 1013]},
          {heading: @parent_heading, matched: entry, index: [1085, 1096]},
          {heading: @parent_heading, matched: entry, index: [1109, 1120]},
          {heading: @parent_heading, matched: entry, index: [1190, 1201]},
          {heading: @parent_heading, matched: entry, index: [1223, 1234]},
          {heading: @parent_heading, matched: entry, index: [1326, 1337]},
          {heading: @parent_heading, matched: entry, index: [1383, 1394]},
          {heading: @parent_heading, matched: entry, index: [1411, 1422]},
          {heading: @parent_heading, matched: entry, index: [1441, 1452]},
          {heading: @parent_heading, matched: entry, index: [1568, 1579]},
          {heading: @parent_heading, matched: entry, index: [1598, 1609]},
          {heading: @parent_heading, matched: entry, index: [1754, 1765]},
          {heading: @parent_heading, matched: entry, index: [1941, 1952]},
          {heading: @parent_heading, matched: entry, index: [1961, 1972]},
          {heading: @parent_heading, matched: entry, index: [1981, 1992]},
          {heading: @parent_heading, matched: entry, index: [2412, 2423]},
          {heading: @parent_heading, matched: entry, index: [2451, 2462]},
          {heading: @parent_heading, matched: entry, index: [2594, 2605]},
          {heading: @parent_heading, matched: entry, index: [2922, 2933]},
          {heading: @parent_heading, matched: entry, index: [3038, 3049]},
          {heading: @parent_heading, matched: entry, index: [3433, 3444]},
          {heading: @parent_heading, matched: entry, index: [3555, 3566]},
          {heading: @parent_heading, matched: entry, index: [3686, 3697]},
          {heading: @parent_heading, matched: entry, index: [3899, 3910]},
          {heading: @parent_heading, matched: entry, index: [3980, 3991]},
          {heading: @parent_heading, matched: entry, index: [4031, 4042]},
          {heading: @parent_heading, matched: entry, index: [4499, 4510]},
          {heading: @parent_heading, matched: entry, index: [4677, 4688]},
          {heading: @parent_heading, matched: entry, index: [4762, 4773]},
          {heading: @parent_heading, matched: entry, index: [4847, 4858]},
          {heading: @parent_heading, matched: entry, index: [5569, 5580]},
          {heading: @parent_heading, matched: entry, index: [5606, 5617]},
          {heading: @parent_heading, matched: entry, index: [5707, 5718]},
          {heading: @parent_heading, matched: entry, index: [5924, 5935]},
          {heading: @parent_heading, matched: entry, index: [6347, 6358]},
          {heading: @parent_heading, matched: entry, index: [7905, 7916]},
          {heading: @parent_heading, matched: entry, index: [8065, 8076]},
          {heading: @parent_heading, matched: entry, index: [8394, 8405]},
          {heading: @parent_heading, matched: entry, index: [8416, 8427]},
          {heading: @parent_heading, matched: entry, index: [8581, 8592]},
          {heading: @parent_heading, matched: entry, index: [8603, 8614]},
          {heading: @parent_heading, matched: entry, index: [9168, 9179]},
          {heading: @parent_heading, matched: entry, index: [9246, 9257]},
          {heading: @parent_heading, matched: entry, index: [10403, 10414]},
          {heading: @parent_heading, matched: entry, index: [10958, 10969]},
          {heading: @parent_heading, matched: entry, index: [11249, 11260]}
      ]

      actual_matches = entry.match_in_text(@example_text)

      refute_nil actual_matches
      assert_equal expected_matches, actual_matches
    end

    def test_datril
      # ENTRY = 
      entry = Entry.new(@parent_heading, 'Datril|T109|T121|NON|NRW|UNK (19XX)|861119|abbcdef')
      assert_equal 'Datril', entry.term
      assert_equal ['Organic Chemical', 'Pharmacologic Substance'], entry.semantic_types
      assert_nil entry.lexical_type
      assert_equal :narrower, entry.semantic_relationship
    end

    def test_acetamidophenol
      entry = Entry.new(@parent_heading, 'p-Acetamidophenol|T109|T121|NON|EQV|UNK (19XX)|800813|abbcdef')
      assert_equal 'p-Acetamidophenol', entry.term
      assert_equal ['Organic Chemical', 'Pharmacologic Substance'], entry.semantic_types
      assert_nil entry.lexical_type
      assert_equal :equivalent, entry.semantic_relationship
    end

    # def test_semantic_relationship
    #   skip
    #   # ABB (Abbreviation)
    #   # ABX (Embedded abbreviation)
    #   # ACR (Acronym)
    #   # ACX (Embedded acronym)
    #   # EPO (Eponym)
    #   # LAB (Lab number)
    #   # NAM (Proper name)
    #   # NON (None)
    #   # TRD (Trade name)
    # end
    #
    # def test_related_entries
    #   skip
    #   # BRD (Broader)
    #   # EQV (Equivalent)
    #   # NRW (Narrower)
    #   # REL (Related)
    # end

    def setup
      @mesh_tree = @@mesh_tree
      @parent_heading = @mesh_tree.find('D000234')
    end

  end
end
