class Object
	def const_defined_recursively?(str)
		if str.is_a(String)
			parts = str.split('::')
			parts_count = parts.count
			result = 0
			const = nil
			parts_count.times do |index|
				const_str = parts[index]
				if index == 0
					if Object.const_defined?(const_str)
						const = Object.const_get(const_str)
					else
						return false
					end
				else
					if const.const_defined?(const_str)
						const = const.const_get(const_str)
					else
						return false
					end
				end	

			end
			true
		else
			false
		end
	end
end