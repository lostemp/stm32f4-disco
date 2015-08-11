define init_ocd
	target remote localhost:3333
	mon reset
	mon halt
	load
    disconnect

    target remote localhost:3333
	mon reset halt
	b main
	
	# Take a peek at first lines of code
	mon reg pc
	c
end
