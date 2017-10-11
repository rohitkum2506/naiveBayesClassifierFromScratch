
require "rubygems"

def test
	a = [1,2,3,4,5]
	b = {}
	a.each do |item|
		
		b[1][1][item] = b[1][1][item]  || 0
		b[1][1][item] = item*10
	end
	puts b

end

test()