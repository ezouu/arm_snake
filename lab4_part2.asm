
moveleft:
	addi a0, a0, -1 #move left by decreasing each position by 1, we can copy paste this to all the functions that require moving left
	j newPosition
	
movedown:
	addi a1, a1, 1 #changing y instead of x, goign down. 
	j newPosition	

moveright:
	addi a0, a0, 1 # same idea as move left, except increasing instead of decreasing 
	j newPosition

moveup:
	addi a1, a1, -1 #same idea as moving down, except chanigng y insetad of x
	j newPosition	

moveDiagonalLeftUp:
	
	addi a0, a0, -1 #combinging both moving x and y
	addi a1, a1, -1 #move up
	j newPosition	

moveDiagonalLeftDown:
	addi a0, a0, -1
	addi a1, a1, 1
	j newPosition		
		
moveDiagonalRightUp:
	
	addi a0, a0, 1
	addi a1, a1, -1
	j newPosition	

moveDiagonalRightDown:
	addi a0, a0, 1
	addi a1, a1, 1
	j newPosition	


