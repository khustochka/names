require "open-uri"
require "nokogiri"
require "json"

io = open("http://avibase.bsc-eoc.org/checklist.jsp?region=ABA&list=clements")

doc = Nokogiri::HTML(io, nil, 'utf-8')

rows = doc.css("tr.highlight1")

result = {}

rows.each do |row|
  sp = row.css("td:first").text
  mt = sp.match /^([\w\s]+)'s/
  if mt && mt[1]
    result[mt[1]] ||= []
    result[mt[1]] << sp
  end
end

puts result.size

sorted = result.sort_by { |key, value|
  [100 - value.size, key]
}

# sorted.each do |key, value|
#   puts "#{key}'s - #{value.size}"
# end

puts Hash[sorted].to_json
