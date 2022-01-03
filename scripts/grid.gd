extends Panel

# optional export vars
export var width := 4
export var height := 4
export var time_between_clicks := 0.4
export(Array, Resource) var Colors = []

onready var pieceTemplate := preload("res://Piece.tscn")

signal change_score
signal game_ended
signal game_started

# member vars
var board := []
var x_start := 8
var y_start := 385
var offset := 125
var can_control = true
var game_ended = false

func _ready():
	randomize()
	restart_game()

func clear_board():
	for child in get_children():
		child.remove()
	
	board = make_2d_array()
	generate_background()

func restart_game():
	clear_board()
	
	generate_new_pieces()
	generate_new_pieces()
	game_ended = false
	can_control = true
	emit_signal("game_started")

func make_2d_array():
	var array = [];
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array

func grid_to_pixel(grid_position: Vector2):
	var new_x = x_start + offset * grid_position.x
	var new_y = y_start + -offset * grid_position.y
	return Vector2(new_x, new_y)
	
func pixel_to_grid(pixel_position: Vector2):
	var new_x = round((pixel_position.x - x_start) / offset)
	var new_y = round((pixel_position.y - y_start) / -offset)
	return Vector2(new_x, new_y)

func has_blank_spaces():
	for i in width:
		for j in height:
			if board[i][j] == null:
				return true
	return false

func move_all_pieces(direction: Vector2):
	var movements = []
	if can_control == false or game_ended:
		return
		
	can_control = false
	var piecesMoved = 0
	
	match direction:
		Vector2.UP:
			# for each of the columns
			for i in width:
				# from top to bottom
				for j in range(height - 2, -1, -1):
					if board[i][j] != null:
						piecesMoved += move_piece_in_direction(Vector2(i,j), direction * -1)
		Vector2.RIGHT:
			for j in height:
				for i in range(width -2, -1, -1):
					if board[i][j] != null:
						piecesMoved += move_piece_in_direction(Vector2(i,j), direction )
					
		Vector2.DOWN:
			for i in width:
				for j in range( 1, height, 1):
					if board[i][j] != null:
						piecesMoved += move_piece_in_direction(Vector2(i,j), direction * -1)
		Vector2.LEFT:
			for j in height:
				for i in range(1, width, 1):
					if board[i][j] != null:
						piecesMoved += move_piece_in_direction(Vector2(i,j), direction)
	
	if piecesMoved == 0:
		if has_blank_spaces() == false:
			if has_possible_moves() == false:
				game_over()
				return
	
	generate_new_pieces()
	yield(get_tree().create_timer(time_between_clicks),"timeout")
	can_control = true


func move_piece_in_direction(piece_location, direction):
	# for the current piece go through its direction row/column
	# find the first other piece
	var current_piece = board[piece_location.x][piece_location.y]
	
	current_piece.hideNewStatus()
	
	var next_location = piece_location + direction
	var next_piece = board[next_location.x][next_location.y]
	
	# find the next other piece
	
	while next_piece == null:
		# stop searching when on the end of the column/row
		if ( direction.x == 0 and 
			( next_location.y == 0 
			or next_location.y + 1 >= height)):
			break;
		if ( direction.y == 0 and 
			( next_location.x == 0 
			or next_location.x + 1 >= width)):
			break;
		# move one furter
		next_location = next_location + ( direction )
		next_piece = board[next_location.x][next_location.y]
	
	if ( next_piece == null ):
		# just move to the next location
		board[piece_location.x][piece_location.y] = null
		board[next_location.x][next_location.y] = current_piece;
		current_piece.move(grid_to_pixel(next_location))
		return 1
	elif ( next_piece != current_piece):
		# found another piece in line
		if ( current_piece.Value == next_piece.Value):
			# todo: verify this piece was not just merged
			var value = current_piece.Value * 2
			next_piece.remove()
			current_piece.remove()
			board[piece_location.x][piece_location.y] = null
			board[next_location.x][next_location.y] = null;	
			var temp = pieceTemplate.instance();
			var data = get_color_data(value)
			temp.Value = data.Value
			temp.MainColor = data.MainColor
			
			add_child(temp)
			board[next_location.x][next_location.y] = temp
			temp.position = grid_to_pixel(piece_location)
			temp.move(grid_to_pixel(next_location))
			temp.hideNewStatus()
			
			emit_signal("change_score", value)
			return 1
		else:
			
			#move back on negative direction
			next_location -= direction
			
			if ( next_location == piece_location):
				return 0 # not moved 
			
			board[piece_location.x][piece_location.y] = null
			board[next_location.x][next_location.y] = current_piece;
			current_piece.move(grid_to_pixel(next_location))
			return 1
		

func generate_new_pieces():
	if has_blank_spaces():
		var pieces_made = 0
		while pieces_made < 1:
			var x_pos = int(floor(rand_range(0,4)))
			var y_pos = int(floor(rand_range(0,4)))
			if board[x_pos][y_pos] == null:
				var temp = pieceTemplate.instance();
				var data = get_color_data(is_two_or_four())
				temp.Value = data.Value
				temp.MainColor = data.MainColor
				
				add_child(temp)
				temp.update_data()
				board[x_pos][y_pos] = temp
				temp.position = grid_to_pixel(Vector2(x_pos, y_pos))
				
				pieces_made += 1
				
	else:
		pass

func has_possible_moves():
	var possibleMoves = false
	for i in width:
		for j in height -1:
			# check for upwards moves
			if ( board[i][j] == null or  board[i][j + 1] == null or board[i][j].Value == board[i][j + 1].Value):
				return true
		for j in range(height -1, 1, -1 ):
			# downward moves
			if (board[i][j] == null or board[i][j - 1] == null or board[i][j].Value == board[i][j - 1].Value):
				return true
				
	for j in height:
		for i in width - 1:
			# right moves
			if (board[i][j].Value == null or board[i + 1][j].Value == null or board[i][j].Value == board[i + 1][j].Value):
				return true
		for i in range(width -1, 1, -1):
			# left movement
			if (board[i][j].Value == null or board[i - 1][j].Value == null or board[i][j].Value == board[i - 1][j].Value):
				return true
	
	return possibleMoves

func game_over():
	game_ended = true
	#clear_board()
	emit_signal("game_ended")

func is_two_or_four():
	var temp = rand_range(0,100)
	if temp < 85:
		return 2
	else:
		return 4

func get_color_data(value):
	for i in Colors.size():
		if Colors[i].Value == value:
			return Colors[i]
	return null

func generate_background():
	var t = 2
	for i in width:
		for j in height:
			var temp = pieceTemplate.instance()
			#var data = get_color_data(min(t, 2048))
			#temp.Value = data.Value
			temp.MainColor = Color.gray
			add_child(temp)
			temp.position = grid_to_pixel(Vector2(i,j))
			t*=2
			temp.hideNewStatus()

func _on_TouchControl_move(direction: Vector2):
	move_all_pieces(direction)

func _on_KeyboardControl_move(direction: Vector2):
	move_all_pieces(direction)

func _on_RestartGame():
	restart_game()
	
