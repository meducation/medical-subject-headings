module MESH
  class Classifier
    def classify(document)
      text = "#{document[:title]}\n#{document[:abstract]}\n#{document[:content]}"
      matches = MESH::Mesh.match_in_text(text)
      headings = matches.map { |m| m[:heading] }
      root_groups = headings.reduce({}) do |rg, heading|
        heading.roots.each { |root| (rg[root] ||= []) << heading }
        rg
      end
      root_groups.reduce({}) do |chosen, (root, candidates)|
        connections = calculate_connections(root, candidates)
        best_score, best_connected = connections.reduce({}) { |h, (k, v)| (h[v] ||= []) << k; h }.max
        most_specific = best_connected.max_by { |h| h.deepest_position }
        chosen[root] = most_specific
        chosen
      end
    end

    private

    def calculate_connections(root, headings)
      connections = {}
      headings.each do |h|
        add_connection(connections, root, h, 1.0)
      end
      connections
    end

    def add_connection(connections, root, heading, weight)
      return unless heading.roots.include? root
      connections[heading] ||= 0
      connections[heading] += weight
      heading.parents.each do |p|
        add_connection(connections, root, p, weight / heading.parents.length.to_f)
      end
      #heading.siblings.each do |p|
      #  add_connection(connections, p)
      #end
    end

  end

end

