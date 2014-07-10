module MESH
  class SemanticRelationshipTypes

    def self.[](key)
      Types[key]
    end

    Types = {
      'BRD' => :broader,
      'EQV' => :equivalent,
      'NRW' => :narrower,
      'REL' => :related
    }

  end
end