require_relative 'test_helper'

module MESH
  class HeadingTest < TestBase

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

    def test_has_correct_case_insensitive_regex
      entry = Entry.new(@parent_heading, 'Panadol|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef')
      assert_equal /(^|\W)Panadol(\W|$)/i, entry.regex
    end

    def test_has_correct_case_sensitive_regex
      entry = Entry.new(@parent_heading, 'AND|T109|T121|TRD|NRW|UNK (19XX)|830915|abbcdef')
      assert_equal /(^|\W)AND(\W|$)/, entry.regex
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
