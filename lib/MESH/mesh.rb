require_relative 'translator'

module MESH
  class Mesh

    attr_accessor :unique_id, :original_heading, :tree_numbers, :parents, :children, :natural_language_name, :summary, :entries, :useful

    def original_heading(locale = nil)
      return @original_heading if locale.nil?
      @@translator.translate(@original_heading)
    end

    def natural_language_name(locale = nil)
      return @natural_language_name if locale.nil?
      @@translator.translate(@natural_language_name)
    end

    def summary(locale = nil)
      return @summary if locale.nil?
      @@translator.translate(@summary)
    end

    def entries(locale = nil)
      return @entries if locale.nil?
      @entries.map { |entry| @@translator.translate(entry) }.sort
    end

    def self.configure(args)
      return if @@configured
      raise ArgumentError.new('MeshHeadingGraph requires a filename in order to configure itself') unless not args[:filename].nil?
      gzipped_file = File.open(args[:filename])
      file = Zlib::GzipReader.new(gzipped_file)
      current_heading = Mesh.new
      file.each_line do |line|
        if line.match(/^\*NEWRECORD$/) #Then store the previous record before continuing
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
        end

        matches = line.match(/^UI = (.*)/)
        current_heading.unique_id = matches[1] unless matches.nil?

        matches = line.match(/^MN = (.*)/)
        current_heading.tree_numbers << matches[1] unless matches.nil?

        matches = line.match(/^MS = (.*)/)
        current_heading.summary = matches[1] unless matches.nil?

        matches = line.match(/^MH = (.*)/)
        unless matches.nil?
          mh = matches[1]
          current_heading.original_heading = mh
          current_heading.natural_language_name = mh
          current_heading.entries << mh
          librarian_parts = mh.match(/(.*), (.*)/)
          current_heading.natural_language_name = "#{librarian_parts[2]} #{librarian_parts[1]}" unless librarian_parts.nil?
        end

        matches = line.match(/^(?:PRINT )?ENTRY = ([^|]+)/)
        unless matches.nil?
          mh = matches[1].chomp
          current_heading.entries << mh
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
      matches = []
      text = text.downcase
      @@headings.each do |heading|
        heading.entries.each do |entry|
          entry = entry.downcase
          start = /^#{Regexp.quote(entry)}\W+/
          middle = /\W+#{Regexp.quote(entry)}\W+/
          at_end = /\W+#{Regexp.quote(entry)}$/
          if start.match(text) || middle.match(text) || at_end.match(text)
            matches << {heading: heading, matched: entry}
          end
        end
      end
      matches
    end

    def matches(conditions)
      conditions.each do |field, pattern|
        field_content = self.send(field)
        if field_content.kind_of?(Array)
          return false unless field_content.find { |fc| pattern =~ fc }
        elsif field_content.is_a?(TrueClass) || field_content.is_a?(FalseClass)
          return false unless field_content == pattern
        else
          return false unless pattern =~ field_content
        end
      end
      return true
    end

    def inspect
      return "#{@unique_id}, #{@original_heading}"
    end

    private

    @@configured = false
    @@headings = []
    @@by_unique_id = {}
    @@by_tree_number = {}
    @@by_original_heading = {}
    @@default_locale = 'en-US'
    @@translator = Translator.new

    def initialize
      @useful = true
      @tree_numbers = []
      @parents = []
      @children = []
      @entries = []
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
