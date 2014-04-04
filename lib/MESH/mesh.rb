module MESH
  class Mesh

    include Comparable
    attr_accessor :unique_id, :tree_numbers, :roots, :parents, :children, :useful, :descriptor_class

    def <=> other
      self.unique_id <=> other.unique_id
    end

    def original_heading(locale = @@default_locale)
      return @original_heading[locale]
    end

    def natural_language_name(locale = @@default_locale)
      return @natural_language_name[locale]
    end

    def summary(locale = @@default_locale)
      return @summary[locale]
    end

    def entries(locale = @@default_locale)
      @entries[locale] ||= []
      return @entries[locale]
    end

    def self.configure(args)
      return if @@configured
      raise ArgumentError.new('MeshHeadingGraph requires a filename in order to configure itself') unless not args[:filename].nil?

      gzipped_file = File.open(args[:filename])
      file = Zlib::GzipReader.new(gzipped_file)

      current_heading = Mesh.new
      file.each_line do |line|

        case

          when matches = line.match(/^\*NEWRECORD$/)
            unless current_heading.unique_id.nil?
              current_heading.entries.sort!
              @@headings << current_heading
              @@by_unique_id[current_heading.unique_id] = current_heading
              @@by_original_heading[current_heading.original_heading] = current_heading
              current_heading.tree_numbers.each do |tree_number|
                @@by_tree_number[tree_number] = current_heading
              end
            end
            current_heading = Mesh.new

          when matches = line.match(/^UI = (.*)/)
            current_heading.unique_id = matches[1]

          when matches = line.match(/^MN = (.*)/)
            current_heading.tree_numbers << matches[1]
            current_heading.roots << matches[1][0] unless current_heading.roots.include?(matches[1][0])

          when matches = line.match(/^MS = (.*)/)
            current_heading.set_summary(matches[1])

          when matches = line.match(/^DC = (.*)/)
            current_heading.descriptor_class = @@descriptor_classes[matches[1].to_i]

          when matches = line.match(/^MH = (.*)/)
            mh = matches[1]
            current_heading.set_original_heading(mh)
            current_heading.entries << mh
            librarian_parts = mh.match(/(.*), (.*)/)
            nln = librarian_parts.nil? ? mh : "#{librarian_parts[2]} #{librarian_parts[1]}"
            current_heading.set_natural_language_name(nln)

          when matches = line.match(/^(?:PRINT )?ENTRY = ([^|]+)/)
            entry = matches[1].chomp
            current_heading.entries << entry

        end

      end

      @@by_unique_id.each do |id, heading|
        heading.tree_numbers.each do |tree_number|
          #D03.438.221.173
          parts = tree_number.split('.')
          if parts.size > 1
            parts.pop
            parent_tree_number = parts.join '.'
            parent = @@by_tree_number[parent_tree_number]
            heading.parents << parent unless parent.nil?
            parent.children << heading unless parent.nil?
          end
        end
      end
      @@configured = true
    end

    def self.translate(locale, tr)
      return if @@locales.include? locale
      @@headings.each_with_index do |h, i|
        h.set_original_heading(tr.translate(h.original_heading), locale)
        h.set_natural_language_name(tr.translate(h.natural_language_name), locale)
        h.set_summary(tr.translate(h.summary), locale)
        h.entries.each { |entry| h.entries(locale) << tr.translate(entry) }
        h.entries(locale).sort!
      end

      @@locales << locale
    end

    def self.find(unique_id)
      raise 'MeshHeadingGraph.configure must be called before use' unless @@configured
      return @@by_unique_id[unique_id]
    end

    def self.find_by_tree_number(tree_number)
      raise 'MeshHeadingGraph.configure must be called before use' unless @@configured
      return @@by_tree_number[tree_number]
    end

    def self.find_by_original_heading(heading)
      raise 'MeshHeadingGraph.configure must be called before use' unless @@configured
      return @@by_original_heading[heading]
    end

    def self.where(conditions)
      matches = []
      @@headings.each do |heading|
        matches << heading if heading.matches(conditions)
      end
      matches
    end

    def self.each
      for i in 0 ... @@headings.size
        yield @@headings[i] if @@headings[i].useful
      end
    end

    def self.match_in_text(text)
      return [] if text.nil?
      downcased = text.downcase
      matches = []
      @@headings.each do |heading|
        next unless heading.useful
        @@locales.each do |locale|
          heading.entries(locale).each do |entry|
            if downcased.include? entry.downcase #This is a looser check than the regex but much, much faster
              if /^[A-Z0-9]+$/ =~ entry
                regex = /(^|\W)#{Regexp.quote(entry)}(\W|$)/
              else
                regex = /(^|\W)#{Regexp.quote(entry)}(\W|$)/i
              end
              text.to_enum(:scan, regex).map do |m,|
                matches << {heading: heading, matched: entry, index: $`.size}
              end
            end
          end
        end
      end
      confirmed_matches = []
      matches.combination(2) do |l, r|
        if (r[:index] >= l[:index]) && (r[:index] + r[:matched].length <= l[:index] + l[:matched].length)
          #r is within l
          r[:delete] = true
        elsif (l[:index] >= r[:index]) && (l[:index] + l[:matched].length <= r[:index] + r[:matched].length)
          #l is within r
          l[:delete] = true
        end
      end
      matches.delete_if { |match| match[:delete] }
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

    def deepest_position
      return nil if tree_numbers.empty?
      deepest_tree_number = tree_numbers.max_by { |tn| tn.length }
      deepest_tree_number.split('.').length
    end

    def shallowest_position
      return nil if tree_numbers.empty?
      shallowest_tree_number = tree_numbers.min_by { |tn| tn.length }
      shallowest_tree_number.split('.').length
    end

    def self.cluster(headings)
      return headings
    end

    def matches(conditions)
      conditions.each do |field, pattern|
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

    def inspect
      return "#{unique_id}, #{original_heading}, [#{tree_numbers.join(',')}]"
    end

    def set_original_heading(heading, locale = @@default_locale)
      @original_heading[locale] = heading
    end

    def set_natural_language_name(name, locale = @@default_locale)
      @natural_language_name[locale] = name
    end

    def set_summary(summary, locale = @@default_locale)
      @summary[locale] = summary
    end

    private

    @@configured = false
    @@headings = []
    @@by_unique_id = {}
    @@by_tree_number = {}
    @@by_original_heading = {}
    @@default_locale = 'en-US'
    @@locales = [@@default_locale]
    @@us_to_gb = Translator.new(Translator.enus_to_engb)
    @@descriptor_classes = [:make_array_start_at_1, :topical_descriptor, :publication_type, :check_tag, :geographic_descriptor]

    def initialize
      @useful = true
      @tree_numbers = []
      @roots = []
      @parents = []
      @children = []
      @entries = {}
      @entries[@@default_locale] = []
      @original_heading = {}
      @natural_language_name = {}
      @summary = {}
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
