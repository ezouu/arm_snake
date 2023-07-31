
xyCoordinatesToAddress:
    slli a0, a0, 2      # Multiply x by 4 because we want to skip the first instance and move to the second unit of the first row. With each unit from the .word directive giving it a 4 byte value 
    slli a1, a1, 7      # Multiply y by 128 to skip an entire row, since we use a 256 by 256 pixel bitmap it would be 256 * 4 bytes that we would need to skip. 
    add a0, a0, a1     
    add a0, a0, a2     
    ret
	
					
