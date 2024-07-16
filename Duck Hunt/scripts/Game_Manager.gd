extends Node

signal Next_Round
signal Score_Increase
signal Game_Over
signal Double_Spawn
signal Dog

var Save_Path = "user://Duck_Hunt_File"
var Score = 0
var Highscore = 0


func _ready():
	# load highscore
	Load_Highscore()
	
	# connect score increase to count score
	GameManager.connect("Score_Increase", Score_Manager)
	
func Score_Manager():
	
	# increase the score by 100
	Score += 100
	

func Check_Highscore():
	
	# if score is greater than highscore
	if Score > Highscore :
		
		Highscore = Score
		
		Save_Highscore()
		

func Save_Highscore():
	
	#create a file to store the dunk hunt save path
	var File = FileAccess.open(Save_Path, FileAccess.WRITE)
	
	# store the highscore inside the file
	File.store_var(Highscore)
	

func Load_Highscore():
	
	# check first if the file exits
	if FileAccess.file_exists(Save_Path):
		
		# create a file to open and read the path
		var File = FileAccess.open(Save_Path, FileAccess.READ)
		
		# set the highscoer to rhe value inside the file
		Highscore = File.get_var()
		
	else :
		# set the highscore to 0 
		Highscore = 0
