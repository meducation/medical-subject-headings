module MESH

  class Entry

    attr_accessor :heading, :term, :semantic_types, :semantic_relationship, :lexical_type

    def initialize(heading, entry_text)
      @heading = heading
      @semantic_types = []
      parts = entry_text.split('|')
      if entry_text.include? '|'
        key = parts.pop
        parts.each_with_index do |part, i|
          case key[i]
            when 'a' # the term itself
              @term = part
            when 'b' # semantic type*
              @semantic_types << MESH::SemanticTypes[part]
            when 'c' # lexical type*
              @lexical_type = MESH::LexicalTypes[part]
            when 'd' # semantic relation*
              @semantic_relationship = MESH::SemanticRelationshipTypes[part]
            when 'e' # thesaurus id
            when 'f' # date
            when 's' # sort version
            when 'v' # entry version
          end
        end
      else
        @term = entry_text
      end
    end

  end

end
