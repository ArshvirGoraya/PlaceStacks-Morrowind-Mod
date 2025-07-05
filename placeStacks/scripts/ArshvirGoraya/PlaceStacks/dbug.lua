local enableLogging = false

return {
	log = function(...)
		if not enableLogging then
			return
		end
		print(...)
	end,
}
