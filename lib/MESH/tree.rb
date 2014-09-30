module MESH

  class Tree

    @@default_locale = :en_us

    def initialize

      @headings = []
      @by_unique_id = {}
      @by_tree_number = {}
      @by_original_heading = {}
      @by_entry = {}
      @locales = [@@default_locale]

      filename = File.expand_path('../../../data/mesh_data_2014/d2014.bin.gz', __FILE__)
      gzipped_file = File.open(filename)
      file = Zlib::GzipReader.new(gzipped_file)

      lines = []
      file.each_line do |line|
        case
          when line.match(/^\*NEWRECORD$/)
            unless lines.empty?
              mh = MESH::Heading.new(self, @@default_locale, lines)
              add_heading_to_hashes(mh)
              lines = [line]
            end
          else
            lines << line
        end
      end

      @headings.each do |heading|
        heading.connect_to_parents
        heading.connect_to_forward_references
      end

    end

    def add_heading_to_hashes(mh)
      @headings << mh
      @by_unique_id[mh.unique_id] = mh
      @by_original_heading[mh.original_heading] = mh
      mh.tree_numbers.each do |tree_number|
        raise if @by_tree_number[tree_number]
        @by_tree_number[tree_number] = mh
      end
      match_headings = mh.entries.map { |e| entry_match_key(e) }.uniq
      match_headings.each do |entry|
        raise if @by_entry[entry]
        @by_entry[entry] = mh
      end
    end

    def entry_match_key(e)
      e.strip.upcase
    end

    def load_translation(locale)
      return if @locales.include? locale
      filename = File.expand_path("../../../data/mesh_data_2014/d2014.#{locale}.bin.gz", __FILE__)
      gzipped_file = File.open(filename)
      file = Zlib::GzipReader.new(gzipped_file)

      entries = []
      original_heading = nil
      natural_language_name = nil
      summary = nil
      unique_id = nil
      file.each_line do |line|

        case

          when line.match(/^\*NEWRECORD$/)
            unless unique_id.nil?
              entries.sort!
              entries.uniq!
              if heading = find(unique_id)
                heading.set_original_heading(original_heading, locale) unless original_heading.nil?
                heading.set_natural_language_name(natural_language_name, locale) unless natural_language_name.nil?
                heading.set_summary(summary, locale) unless summary.nil?
                entries.each { |entry| heading.entries(locale) << entry }
              end

              entries = []
              original_heading = nil
              summary = nil
              unique_id = nil
            end

          when matches = line.match(/^UI = (.*)/)
            unique_id = matches[1]

          when matches = line.match(/^MS = (.*)/)
            summary = matches[1]

          when matches = line.match(/^MH = (.*)/)
            mh = matches[1]
            original_heading = mh
            entries << mh
            librarian_parts = mh.match(/(.*), (.*)/)
            natural_language_name = librarian_parts.nil? ? mh : "#{librarian_parts[2]} #{librarian_parts[1]}"

          when matches = line.match(/^(?:PRINT )?ENTRY = ([^|]+)/)
            entry = matches[1].chomp
            entries << entry

        end

      end
      @locales << locale
    end

    def load_wikipedia
      return if @wikipedia_loaded
      filename = File.expand_path("../../../data/mesh_data_2014/d2014.wikipedia.bin.gz", __FILE__)
      gzipped_file = File.open(filename)
      file = Zlib::GzipReader.new(gzipped_file)

      unique_id = nil
      wikipedia_links = []
      file.each_line do |line|

        case

          when line.match(/^\*NEWRECORD$/)
            unless unique_id.nil?
              if heading = find(unique_id)
                wikipedia_links.each do |wl|
                  wl[:score] = (wl[:score].to_f / heading.entries.length.to_f).round(2)
                end
                heading.wikipedia_links = wikipedia_links
              end

              wikipedia_links = []
              unique_id = nil
            end

          when matches = line.match(/^UI = (.*)/)
            unique_id = matches[1]

          when matches = line.match(/^WK = (.*)/)
            hash = JSON.parse(matches[1], symbolize_names: true)
            wikipedia_links << hash

        end

      end
      @wikipedia_loaded = true
    end


    def linkify_summaries &block
      @headings.each do |h|
        h.linkify_summary &block
      end
    end

    # NO LONGER COVERED BY TESTS
    # def translate(locale, tr)
    #   return if @locales.include? locale
    #   @headings.each_with_index do |h, i|
    #     h.set_original_heading(tr.translate(h.original_heading), locale)
    #     h.set_natural_language_name(tr.translate(h.natural_language_name), locale)
    #     h.set_summary(tr.translate(h.summary), locale)
    #     h.entries.each { |entry| h.entries(locale) << tr.translate(entry) }
    #     h.entries(locale).sort!
    #   end
    #
    #   @locales << locale
    # end

    def find(unique_id)
      return @by_unique_id[unique_id]
    end

    def find_by_tree_number(tree_number)
      return @by_tree_number[tree_number]
    end

    def find_by_original_heading(heading)
      return @by_original_heading[heading]
    end

    def find_by_entry(entry)
      return @by_entry[entry_match_key(entry)]
    end

    def where(conditions)
      matches = []
      @headings.each do |heading|
        matches << heading if heading.matches(conditions)
      end
      matches
    end

    def each
      for i in 0 ... @headings.size
        yield @headings[i] if @headings[i].useful
      end
    end

    def match_in_text(text)
      return [] if text.nil?
      downcased = text.downcase
      matches = []
      @headings.each do |heading|
        next unless heading.useful
        @locales.each do |locale|
          heading.entries(locale).each do |entry|
            if downcased.include? entry.downcase #This is a looser check than the regex but much, much faster
              if /^[A-Z0-9]+$/ =~ entry
                regex = /(^|\W)#{Regexp.quote(entry)}(\W|$)/
              else
                regex = /(^|\W)#{Regexp.quote(entry)}(\W|$)/i
              end
              text.to_enum(:scan, regex).map do |m,|
                match = Regexp.last_match
                matches << {heading: heading, matched: entry, index: match.offset(0)}
              end
            end
          end
        end
      end
      confirmed_matches = []
      matches.combination(2) do |l, r|
        if (r[:index][0] >= l[:index][0]) && (r[:index][1] <= l[:index][1])
          #r is within l
          r[:delete] = true
        elsif (l[:index][0] >= r[:index][0]) && (l[:index][1] <= r[:index][1])
          #l is within r
          l[:delete] = true
        end
      end
      matches.delete_if { |match| match[:delete] }
    end


  end

end