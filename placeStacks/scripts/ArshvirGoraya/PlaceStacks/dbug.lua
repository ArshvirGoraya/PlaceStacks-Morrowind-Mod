local enableLogging = false
enableLogging = true -- comment this out in production builds!

return {
	logging = enableLogging,
	log = function(...)
		if not enableLogging then
			return
		end
		print(...)
	end,
}
