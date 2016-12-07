require 'set'
require 'pry'

tls = 0
ssl = 0

def find_abba(net)
  abba = false

  net.split('').each_with_index do |char, index|
    fragment = net[index..index+3]

    abba = true if is_abba(fragment)
  end

  return abba
end

def is_abba(fragment)
  return false if fragment.length != 4
  return false if fragment.match(/\[|\]/)
  return false unless fragment[0] == fragment[3]
  return false unless fragment[1] == fragment[2]
  return false unless fragment[0] != fragment[1]
  return true
end

def find_aba(net)
  aba = []

  net.split('').each_with_index do |char, index|
    fragment = net[index..index+2]

    aba << fragment if is_aba(fragment)
  end

  return aba
end

def is_aba(fragment)
  return false if fragment.length != 3
  return false if fragment.match(/\[|\]/)
  return false unless fragment[0] == fragment[2]
  return false unless fragment[0] != fragment[1]
  return true
end

File.foreach('input.txt') do |line|
  supernets = line.split(/\[\w+\]/).flatten
  hypernets = line.scan(/(?!\[)(\w*)(?=\])/).flatten

  is_tls    = false
  super_aba = Set.new
  hyper_aba = Set.new

  supernets.each do |supernet|
    if find_abba(supernet)
      is_tls = true
    end

    if find_aba(supernet) != []
      find_aba(supernet).map {|x| super_aba << x}
    end
  end

  hypernets.each do |hypernet|
    if find_abba(hypernet)
      is_tls = false
    end

    if find_aba(hypernet) != []
      find_aba(hypernet).map {|x| hyper_aba << x}
    end
  end

  if is_tls
    tls += 1
  end

  if (hyper_aba & super_aba).length > 0
    ssl += 1
  end
end

puts "IPs that support TLS:"
puts tls

puts "IPs that support SSL:"
puts ssl
