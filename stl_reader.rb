beginning = Time.now

solid_count = 0
count = 0
vertices = Hash.new(false)
sides = Hash.new(0)
curr_vertices = []
curr_solid = ""

File.open(ARGV[0]).each_line do |line|
	line.strip!
	if line.start_with?("solid")
		count = 0
		vertices = Hash.new(false)
		sides = Hash.new(0)
		curr_vertices = []

		if line.length > 6
			curr_solid = line[6..-1]
		else
			curr_solid = "solid #{solid_count}"
			solid_count += 1
		end

		puts "\n#{curr_solid}"
	elsif line.start_with?("endsolid")
		if count % 3 != 0
			puts "    warning!! number of vertices not divisible by 3"
		end

		# warns when solid sides have oddities
		sides.each do |side, num|
			if num == 1
				puts "    warning!! side: #{side} is an open side"
			elsif num > 2
				puts "    warning!! side: #{side} has #{num} triangles connected to it"
			end
		end

		faces = count/3
		vert_num = vertices.count
		side_num = sides.count

		puts "    faces: #{faces}, sides: #{side_num}, vertices: #{vert_num}"
		puts "    Time elapsed #{Time.now - beginning} seconds\n\n"
	elsif line.start_with?("vertex")
		count += 1
		line = line.split(" ")
		line_vertex = line[1..3]
		
		# vertex-counting logic
		unless vertices[line_vertex]
			vertices[line_vertex] = true
		end
		
		# side-counting logic
		curr_vertices << line_vertex
		if curr_vertices.count == 3
			curr_sides = curr_vertices.combination(2).to_a
			
			curr_sides.each do |side|
				side.sort!
				sides[side] += 1
			end
			
			curr_vertices = []
		end
	end
end