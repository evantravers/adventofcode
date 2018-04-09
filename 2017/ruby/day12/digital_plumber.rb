require 'tsort'
class Hash include TSort; alias tsort_each_node each_key; def tsort_each_child(node, &block) fetch(node).each(&block) end;end
t=File.read("./input.txt").split("\n").map{|v|n,v=v.split(" <-> ");[n,v.split(', ')]}.to_h
puts "p1: #{t.strongly_connected_components[0].size}\np2: #{t.strongly_connected_components.size}"
