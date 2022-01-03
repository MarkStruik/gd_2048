extends Node

func save_data(data, file, path = "res"):

	## Create and open your file.
	var SAVE_PATH = path+'://'+file+'.json'
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)

	# Convert your data to a useable string-format.
	save_file.store_line(to_json(data))

	# Close file.
	save_file.close()


func load_data(file, empty = null, path = "res"):

	# Create your file
	var SAVE_PATH = path+"://"+file+".json"
	var save_file = File.new()

	# Return 'empty' if file doesn't exist
	if not save_file.file_exists(SAVE_PATH):
		print("ERROR: file does not exist ("+path+"://"+file+".json)")
		return empty

	# Open your file
	save_file.open(SAVE_PATH, File.READ)

	# Save data from file.
	var data = parse_json(save_file.get_as_text())

	# Close file 
	save_file.close()

	# Return data
	return data
