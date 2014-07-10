require_relative 'test_helper'

module MESH
  class HeadingTest < TestBase

    def test_semantic_entries
      skip
      # ABB (Abbreviation)
      # ABX (Embedded abbreviation)
      # ACR (Acronym)
      # ACX (Embedded acronym)
      # EPO (Eponym)
      # LAB (Lab number)
      # NAM (Proper name)
      # NON (None)
      # TRD (Trade name)
    end

    def test_related_entries
      skip
      # BRD (Broader)
      # EQV (Equivalent)
      # NRW (Narrower)
      # REL (Related)
    end

    def setup
      @mesh_tree = @@mesh_tree
    end

  end
end
