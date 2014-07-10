module MESH
  class LexicalTypes

    def self.[](key)
      Types[key]
    end

    Types = {
      'ABB' => :abbreviation,
      'ABX' => :embedded_abbreviation,
      'ACR' => :acronym,
      'ACX' => :embedded_acronym,
      'EPO' => :eponym,
      'LAB' => :lab_number,
      'NAM' => :proper_name,
      'NON' => nil,
      'TRD' => :trade_name
    }

  end
end