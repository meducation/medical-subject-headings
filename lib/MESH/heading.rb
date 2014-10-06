module MESH
  class Heading

    @@descriptor_classes = [:make_array_start_at_1, :topical_descriptor, :publication_type, :check_tag, :geographic_descriptor]

    include Comparable
    attr_accessor :unique_id, :tree_numbers, :roots, :parents, :children, :useful, :descriptor_class, :default_locale,
                  :semantic_types, :wikipedia_links, :structured_entries, :forward_references
    attr_reader :linkified_summary

    def <=> other
      self.unique_id <=> other.unique_id
    end

    def original_heading(locale = default_locale)
      @original_heading[locale]
    end

    def natural_language_name(locale = default_locale)
      @natural_language_name[locale]
    end

    def summary(locale = default_locale)
      @summary[locale]
    end

    def entries
      @structured_entries
    end

    def linkify_summary
      return if summary.nil?
      @linkified_summary = summary.gsub(/[A-Z]+[A-Z,\s-]+[A-Z]+/).each do |text|
        entry = @tree.find_entry_by_loose_match(text)
        entry ? yield(text, entry) : text
      end
    end

    def has_ancestor(heading)
      return false if parents.empty?
      return true if parents.include? heading
      in_grandparents = parents.map { |p| p.has_ancestor(heading) }
      return in_grandparents.include? true
    end

    def has_descendant(heading)
      return false if children.empty?
      return true if children.include? heading
      in_grandchildren = children.map { |p| p.has_descendant(heading) }
      return in_grandchildren.include? true
    end

    def sibling?(heading)
      common_parents = parents & heading.parents
      !common_parents.empty?
    end

    def deepest_position(root = '')
      return nil if tree_numbers.empty?
      deepest_tree_number = tree_numbers.max_by { |tn| tn.start_with?(root) ? tn.length : 0 }
      deepest_tree_number.split('.').length
    end

    def shallowest_position
      return nil if tree_numbers.empty?
      shallowest_tree_number = tree_numbers.min_by { |tn| tn.length }
      shallowest_tree_number.split('.').length
    end

    def matches(conditions)
      conditions.each do |field, pattern|
        if field == :entries
          entries = @structured_entries.select { |entry| pattern =~ entry.term }
          return !entries.nil? && !entries.empty?
        end

        field_content = self.send(field)
        if field_content.kind_of?(Array)
          return false unless field_content.find { |fc| pattern =~ fc }
        elsif field_content.is_a?(TrueClass) || field_content.is_a?(FalseClass)
          return false unless field_content == pattern
        elsif field_content.is_a? Symbol
          return field_content == pattern
        else
          return false unless pattern =~ field_content
        end
      end
      return true
    end

    def to_s
      "#{unique_id}, #{original_heading}, [#{tree_numbers.join(',')}]"
    end

    def inspect
      to_s
    end

    def set_original_heading(heading, locale = default_locale)
      @original_heading[locale] = heading
    end

    def set_natural_language_name(name, locale = default_locale)
      @natural_language_name[locale] = name
    end

    def set_summary(summary, locale = default_locale)
      @summary[locale] = summary
    end

    def connect_to_parents
      if !@connected_to_parents
        @tree_numbers.each do |tree_number|
          #D03.438.221.173
          parts = tree_number.split('.')
          if parts.size > 1
            parts.pop
            parent_tree_number = parts.join '.'
            parent = @tree.find_heading_by_tree_number(parent_tree_number)
            @parents << parent unless parent.nil? || @parents.include?(parent)
            parent.children << self unless parent.nil? || parent.children.include?(self)
          end
        end
        @connected_to_parents = true
      end
    end

    def connect_to_forward_references
      if !@connected_to_forward_references
        @forward_references = @forward_reference_terms.map do |term|
          @tree.find_heading_by_main_heading(term)
        end
        @connected_to_forward_references = true
      end
    end

    def entries_by_term
      Hash[@structured_entries.map { |entry| [entry.term, entry] }]
    end

    def initialize(tree, default_locale, lines)
      @tree = tree
      @default_locale = default_locale
      @useful = true
      @tree_numbers = []
      @semantic_types = []
      @roots = []
      @parents = []
      @children = []
      @forward_references = []
      @forward_reference_terms = []
      @structured_entries = []
      @original_heading = {}
      @natural_language_name = {}
      @summary = {}
      @wikipedia_links = []

      lines.each do |line|
        case

          when matches = line.match(/^UI = (.*)/)
            @unique_id = matches[1]

          when matches = line.match(/^MN = (.*)/)
            @tree_numbers << matches[1]
            @roots << matches[1][0] unless @roots.include?(matches[1][0])

          when matches = line.match(/^MS = (.*)/)
            set_summary(matches[1])

          when matches = line.match(/^DC = (.*)/)
            @descriptor_class = @@descriptor_classes[matches[1].to_i]

          when matches = line.match(/^ST = (.*)/)
            @semantic_types << MESH::SemanticTypes[matches[1]]

          when matches = line.match(/^MH = (.*)/)
            mh = matches[1]
            set_original_heading(mh)
            @structured_entries << MESH::Entry.new(self, mh, default_locale)
            librarian_parts = mh.match(/(.*), (.*)/)
            nln = librarian_parts.nil? ? mh : "#{librarian_parts[2]} #{librarian_parts[1]}"
            set_natural_language_name(nln)

          when matches = line.match(/^(?:PRINT )?ENTRY = (.*)/)
            entry = matches[1]
            @structured_entries << MESH::Entry.new(self, entry, default_locale)

          when matches = line.match(/^FX = (.*)/)
            @forward_reference_terms << matches[1]

        end

      end

    end


    def load_translation(lines, locale)
      new_entries = []
      lines.each do |line|
        case

          when matches = line.match(/^MS = (.*)/)
            set_summary(matches[1], locale)

          when matches = line.match(/^MH = (.*)/)
            set_original_heading(matches[1], locale)
            librarian_parts = matches[1].match(/(.*), (.*)/)
            natural_language_name = librarian_parts.nil? ? matches[1] : "#{librarian_parts[2]} #{librarian_parts[1]}"
            set_natural_language_name(natural_language_name, locale)
            entry = new_or_existing_entry(matches[1], locale)
            new_entries << entry

          when matches = line.match(/^(?:PRINT )?ENTRY = (.*)/)
            entry = new_or_existing_entry(matches[1], locale)
            new_entries << entry

        end
      end
      new_entries
    end

    def new_or_existing_entry(term, locale)
      existing_entries = @structured_entries.select { |entry| entry.term == term }
      if existing_entries.empty?
        new_entry = MESH::Entry.new(self, term, locale)
        @structured_entries << new_entry
      else
        new_entry = existing_entries[0]
        new_entry.locales << locale
      end
      new_entry
    end
  end
end

#
#*NEWRECORD
#RECTYPE = D
#MH = Calcimycin
#AQ = AA AD AE AG AI AN BI BL CF CH CL CS CT DU EC HI IM IP ME PD PK PO RE SD ST TO TU UR
#ENTRY = A-23187|T109|T195|LAB|NRW|NLM (1991)|900308|abbcdef
#ENTRY = A23187|T109|T195|LAB|NRW|UNK (19XX)|741111|abbcdef
#ENTRY = Antibiotic A23187|T109|T195|NON|NRW|NLM (1991)|900308|abbcdef
#ENTRY = A 23187
#ENTRY = A23187, Antibiotic
#MN = D03.438.221.173
#PA = Anti-Bacterial Agents
#PA = Calcium Ionophores
#MH_TH = FDA SRS (2014)
#MH_TH = NLM (1975)
#ST = T109
#ST = T195
#N1 = 4-Benzoxazolecarboxylic acid, 5-(methylamino)-2-((3,9,11-trimethyl-8-(1-methyl-2-oxo-2-(1H-pyrrol-2-yl)ethyl)-1,7-dioxaspiro(5.5)undec-2-yl)methyl)-, (6S-(6alpha(2S*,3S*),8beta(R*),9beta,11alpha))-
#    RN = 37H9VM9WZL
#RR = 52665-69-7 (Calcimycin)
#PI = Antibiotics (1973-1974)
#PI = Carboxylic Acids (1973-1974)
#MS = An ionophorous, polyether antibiotic from Streptomyces chartreusensis. It binds and transports CALCIUM and other divalent cations across membranes and uncouples oxidative phosphorylation while inhibiting ATPase of rat liver mitochondria. The substance is used mostly as a biochemical tool to study the role of divalent cations in various biological systems.
#                                                                                                                                                                                                                                                                                                                                                                      OL = use CALCIMYCIN to search A 23187 1975-90
#PM = 91; was A 23187 1975-90 (see under ANTIBIOTICS 1975-83)
#HN = 91(75); was A 23187 1975-90 (see under ANTIBIOTICS 1975-83)
#MED = *62
#MED = 847
#M90 = *299
#M90 = 2405
#M85 = *454
#M85 = 2878
#M80 = *316
#M80 = 1601
#M75 = *300
#M75 = 823
#M66 = *1
#M66 = 3
#M94 = *153
#M94 = 1606
#MR = 20130708
#DA = 19741119
#DC = 1
#DX = 19840101
#UI = D000001
#
