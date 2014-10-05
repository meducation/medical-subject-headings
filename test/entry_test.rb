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
      entry = Entry.new(@parent_heading, 'Anacin3', :en_gb)
      assert_equal @parent_heading, entry.heading
    end

    def test_has_locale
      entry = Entry.new(@parent_heading, 'Anacin3', :en_gb)
      assert_equal 1, entry.locales.length
      assert_includes entry.locales, :en_gb
    end

    def test_construct_from_plain_string
      entry = Entry.new(@parent_heading, 'Anacin3', :en_gb)
      assert_equal 'Anacin3', entry.term
      assert_nil entry.semantic_relationship
    end

    def test_has_match_key
      entry = Entry.new(@parent_heading, 'Anacin3', :en_gb)
      assert_equal 'ANACIN3', entry.loose_match_term
      entry = Entry.new(@parent_heading, 'Anacin  - 3', :en_gb)
      assert_equal 'ANACIN 3', entry.loose_match_term
    end

    def test_has_lexical_type
      entry = Entry.new(@parent_heading, 'Panadol|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef', :en_gb)
      assert_equal 'Panadol', entry.term
      assert_equal :trade_name, entry.lexical_type
    end

    def test_has_semantic_relationship
      entry = Entry.new(@parent_heading, 'Panadol|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef', :en_gb)
      assert_equal 'Panadol', entry.term
      assert_equal :narrower, entry.semantic_relationship
    end

    def test_has_semantic_types
      entry = Entry.new(@parent_heading, 'Panadol|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef', :en_gb)
      assert_equal 'Panadol', entry.term
      assert_equal ['Organic Chemical', 'Pharmacologic Substance'], entry.semantic_types
    end

    def test_knows_own_case_sensitivity
      entry = Entry.new(@parent_heading, 'Panadol|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef', :en_gb)
      refute entry.case_sensitive
      entry = Entry.new(@parent_heading, 'AND|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef', :en_gb)
      assert entry.case_sensitive
      entry = Entry.new(@parent_heading, 'A122|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef', :en_gb)
      assert entry.case_sensitive
      entry = Entry.new(@parent_heading, 'Panadol978|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef', :en_gb)
      refute entry.case_sensitive
    end

    def test_has_correct_case_insensitive_regex
      entry = Entry.new(@parent_heading, 'Panadol|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef', :en_gb)
      assert_equal /(^|\W)Panadol(\W|$)/i, entry.regex
    end

    def test_has_correct_case_sensitive_regex
      entry = Entry.new(@parent_heading, 'AND|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef', :en_gb)
      assert_equal /(^|\W)AND(\W|$)/, entry.regex
    end

    def test_matches_nil_or_empty_with_nil
      entry = Entry.new(@parent_heading, 'WBC|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef', :en_gb)
      assert_nil entry.match_in_text(nil, nil)
      assert_nil entry.match_in_text('', '')
      assert_nil entry.match_in_text("", "")
    end

    def test_matches_nil_when_no_matches
      entry = Entry.new(@parent_heading, 'WBC|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef', :en_gb)
      text = 'text that does not include the term'
      assert_nil entry.match_in_text(text, text.downcase)
    end

    def test_matches_itself_in_text_when_all_caps
      entry = Entry.new(@parent_heading, 'WBC|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef', :en_gb)

      expected_matches = [
          {heading: entry.heading, matched: entry, index: [721, 723]},
          {heading: entry.heading, matched: entry, index: [796, 798]},
          {heading: entry.heading, matched: entry, index: [7855, 7857]}
      ]

      actual_matches = entry.match_in_text(@example_text, @example_text.downcase)

      refute_nil actual_matches
      assert_equal expected_matches, actual_matches
    end

    def test_matches_itself_in_text
      entry = Entry.new(@parent_heading, 'Leukaemia', :en_gb)

      expected_matches = [
          {heading: @parent_heading, matched: entry, index: [0, 8]},
          {heading: @parent_heading, matched: entry, index: [52, 60]},
          {heading: @parent_heading, matched: entry, index: [98, 106]},
          {heading: @parent_heading, matched: entry, index: [679, 687]},
          {heading: @parent_heading, matched: entry, index: [704, 712]},
          {heading: @parent_heading, matched: entry, index: [808, 816]},
          {heading: @parent_heading, matched: entry, index: [973, 981]},
          {heading: @parent_heading, matched: entry, index: [1003, 1011]},
          {heading: @parent_heading, matched: entry, index: [1086, 1094]},
          {heading: @parent_heading, matched: entry, index: [1110, 1118]},
          {heading: @parent_heading, matched: entry, index: [1191, 1199]},
          {heading: @parent_heading, matched: entry, index: [1224, 1232]},
          {heading: @parent_heading, matched: entry, index: [1327, 1335]},
          {heading: @parent_heading, matched: entry, index: [1384, 1392]},
          {heading: @parent_heading, matched: entry, index: [1412, 1420]},
          {heading: @parent_heading, matched: entry, index: [1442, 1450]},
          {heading: @parent_heading, matched: entry, index: [1569, 1577]},
          {heading: @parent_heading, matched: entry, index: [1599, 1607]},
          {heading: @parent_heading, matched: entry, index: [1755, 1763]},
          {heading: @parent_heading, matched: entry, index: [1942, 1950]},
          {heading: @parent_heading, matched: entry, index: [1962, 1970]},
          {heading: @parent_heading, matched: entry, index: [1982, 1990]},
          {heading: @parent_heading, matched: entry, index: [2413, 2421]},
          {heading: @parent_heading, matched: entry, index: [2452, 2460]},
          {heading: @parent_heading, matched: entry, index: [2595, 2603]},
          {heading: @parent_heading, matched: entry, index: [2923, 2931]},
          {heading: @parent_heading, matched: entry, index: [3039, 3047]},
          {heading: @parent_heading, matched: entry, index: [3434, 3442]},
          {heading: @parent_heading, matched: entry, index: [3556, 3564]},
          {heading: @parent_heading, matched: entry, index: [3687, 3695]},
          {heading: @parent_heading, matched: entry, index: [3900, 3908]},
          {heading: @parent_heading, matched: entry, index: [3981, 3989]},
          {heading: @parent_heading, matched: entry, index: [4032, 4040]},
          {heading: @parent_heading, matched: entry, index: [4500, 4508]},
          {heading: @parent_heading, matched: entry, index: [4678, 4686]},
          {heading: @parent_heading, matched: entry, index: [4763, 4771]},
          {heading: @parent_heading, matched: entry, index: [4848, 4856]},
          {heading: @parent_heading, matched: entry, index: [5570, 5578]},
          {heading: @parent_heading, matched: entry, index: [5607, 5615]},
          {heading: @parent_heading, matched: entry, index: [5708, 5716]},
          {heading: @parent_heading, matched: entry, index: [5925, 5933]},
          {heading: @parent_heading, matched: entry, index: [6348, 6356]},
          {heading: @parent_heading, matched: entry, index: [7906, 7914]},
          {heading: @parent_heading, matched: entry, index: [8066, 8074]},
          {heading: @parent_heading, matched: entry, index: [8395, 8403]},
          {heading: @parent_heading, matched: entry, index: [8417, 8425]},
          {heading: @parent_heading, matched: entry, index: [8582, 8590]},
          {heading: @parent_heading, matched: entry, index: [8604, 8612]},
          {heading: @parent_heading, matched: entry, index: [9169, 9177]},
          {heading: @parent_heading, matched: entry, index: [9247, 9255]},
          {heading: @parent_heading, matched: entry, index: [10404, 10412]},
          {heading: @parent_heading, matched: entry, index: [10959, 10967]},
          {heading: @parent_heading, matched: entry, index: [11250, 11258]}
      ]

      actual_matches = entry.match_in_text(@example_text, @example_text.downcase)

      refute_nil actual_matches
      expected_indexes = expected_matches.map { |match| match[:index] }
      actual_indexes = actual_matches.map { |match| match[:index] }
      assert_equal expected_indexes, actual_indexes #to show index diffs more easily
      assert_equal expected_matches, actual_matches
    end

    def test_datril
      # ENTRY = 
      entry = Entry.new(@parent_heading, 'Datril|T109|T121|NON|NRW|UNK (19XX)|861119|abbcdef', :en_gb)
      assert_equal 'Datril', entry.term
      assert_equal ['Organic Chemical', 'Pharmacologic Substance'], entry.semantic_types
      assert_nil entry.lexical_type
      assert_equal :narrower, entry.semantic_relationship
    end

    def test_acetamidophenol
      entry = Entry.new(@parent_heading, 'p-Acetamidophenol|T109|T121|NON|EQV|UNK (19XX)|800813|abbcdef', :en_gb)
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
      @parent_heading = @mesh_tree.find_heading_by_unique_id('D000234')
    end

  end
end
