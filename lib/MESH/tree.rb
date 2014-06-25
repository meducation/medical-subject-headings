module MESH

  class Tree

    @@descriptor_classes = [:make_array_start_at_1, :topical_descriptor, :publication_type, :check_tag, :geographic_descriptor]
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

      current_heading = MESH::Heading.new(self)
      current_heading.default_locale = @@default_locale
      file.each_line do |line|

        case

          when matches = line.match(/^\*NEWRECORD$/)
            unless current_heading.unique_id.nil?
              current_heading.entries.sort!
              @headings << current_heading
              @by_unique_id[current_heading.unique_id] = current_heading
              @by_original_heading[current_heading.original_heading] = current_heading
              current_heading.tree_numbers.each do |tree_number|
                raise if @by_tree_number[tree_number]
                @by_tree_number[tree_number] = current_heading
              end
              match_headings = current_heading.entries.map { |e| entry_match_key(e) }.uniq
              match_headings.each do |entry|
                raise "#{@by_entry[entry]} vs #{current_heading} on #{entry}\n\n#{@by_entry[entry].entries}\n\n#{current_heading.entries}" if @by_entry[entry]
                @by_entry[entry] = current_heading
              end
            end
            current_heading = MESH::Heading.new(self)
            current_heading.default_locale = @@default_locale

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
            current_heading.entries << mh unless current_heading.entries.include? mh
            librarian_parts = mh.match(/(.*), (.*)/)
            nln = librarian_parts.nil? ? mh : "#{librarian_parts[2]} #{librarian_parts[1]}"
            current_heading.set_natural_language_name(nln)

          when matches = line.match(/^(?:PRINT )?ENTRY = ([^|]+)/)
            entry = matches[1].chomp
            current_heading.entries << entry unless current_heading.entries.include? entry

        end

      end

      @by_unique_id.each do |id, heading|
        heading.tree_numbers.each do |tree_number|
          #D03.438.221.173
          parts = tree_number.split('.')
          if parts.size > 1
            parts.pop
            parent_tree_number = parts.join '.'
            parent = @by_tree_number[parent_tree_number]
            heading.parents << parent unless parent.nil? || heading.parents.include?(parent)
            parent.children << heading unless parent.nil? || parent.children.include?(heading)
          end
        end
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

          when matches = line.match(/^\*NEWRECORD$/)
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


  end

end