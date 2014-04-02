module MESH
  class Classifier
    def classify(document)
      text = document[:title] || document[:abstract] || document[:content]
      headings = find_connected_headings(text)
      root_groups = headings.reduce({}) do |rg, heading|
        heading.roots.each { |root| (rg[root] ||= []) << heading }
        rg
      end
      root_groups.reduce({}) do |chosen, (root,candidates)|
        connections = calculate_connections(root,candidates)
        best_score, best_connected = connections.reduce({}) { |h, (k, v)| (h[v] ||= []) << k; h }.max
        most_specific = best_connected.max_by { |h| h.deepest_position }
        chosen[root] = most_specific
        chosen
      end
    end

  private

  def calculate_connections(root,headings)
    connections = {}
    headings.each do |h|
      add_connection(connections, root, h)
    end
    connections
  end

  def add_connection(connections, root, heading)
    return unless heading.roots.include? root
    connections[heading] ||= 0
    connections[heading] += 1
    heading.parents.each do |p|
      add_connection(connections, root, p)
    end
    #heading.siblings.each do |p|
    #  add_connection(connections, p)
    #end
  end


  def find_connected_headings(text)
    matches = MESH::Mesh.match_in_text(text)
    #puts matches
    headings = matches.map { |m| m[:heading] }
    headings.uniq!
    #puts "Found #{matches.length} matches"
    #
    #connected_headings = []
    #headings.each do |current|
    #  headings.each do |connected|
    #    is_connected = current.has_ancestor(connected) || current.has_descendant(connected) || current.sibling?(connected)
    #    connected_headings << current if is_connected
    #  end
    #end
    #connected_headings.uniq!
    #puts "Found #{connected_headings.length} distinct, connected matches"
    headings
  end

end

end

