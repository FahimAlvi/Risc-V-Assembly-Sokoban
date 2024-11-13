.data
gridsize:   .byte 8,8
character:  .byte 0,0
box:        .byte 0,0
target:     .byte 0,0

message: .string "You Won. Press 1 to play again "
msg: .string "   Score = "
msg1: .string "   Game Over "
defa: .word '#','#','#','#','#','#','#','#','#','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#','#','#','#','#','#','#','#','#','#'
mystr: .word '#','#','#','#','#','#','#','#','#','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#',' ',' ',' ',' ',' ',' ',' ',' ','#','#','#','#','#','#','#','#','#','#','#'

.text
.globl _start
#Enhancements: 1)Internal walls on line 69  2)Score board number saved on (248)right: (292)left: (333)up: (376)down:

_start:
   # TODO: Generate locations for the character, box, and target. Static
    # locations in memory have been provided for the (x, y) coordinates 
    # of each of these elements.
    # 
    # There is a notrand function that you can use to start with. It's 
    # really not very good; you will replace it with your own rand function
    # later. Regardless of the source of your "random" locations, make 
    # sure that none of the items are on top of each other and that the 
    # board is solvable.
	
   # TODO: Now, print the gameboard. Select symbols to represent the walls,
    # character, box, and target. Write a function that uses the location of
    # the various elements (in memory) to construct a gameboard and that 
    # prints that board one character at a time.
    # HINT: You may wish to construct the string that represents the board
    # and then print that string with a single syscall. If you do this, 
    # consider whether you want to place this string in static memory or 
    # on the stack. 
	
   # TODO: Enter a loop and wait for user input. Whenever user input is
    # received, update the gameboard state with the new location of the 
    # player (and if applicable, box and target). Print a message if the 
    # input received is invalid or if it results in no change to the game 
    # state. Otherwise, print the updated game state. 
    #
    # You will also need to restart the game if the user requests it and 
    # indicate when the box is located in the same position as the target.
    # For the former, it may be useful for this loop to exist in a function,
    # to make it cleaner to exit the game loop.

   # TODO: That's the base game! Now, pick a pair of enhancements and
    # consider how to implement them.


li t2,0
li t3,100
la s0,mystr 
la s0,mystr 

la t0,defa

refresh:              # Function: Resets the game board to its default state.
                      
beq t2,t3,endref	 
addi t2,t2,1
	
lw t4,0(t0)           
sw t4,0(s0)
addi t0,t0,4	
addi s0,s0,4	
j refresh	

endref:
li a0,3
jal find_random     #This will find random number from 1 to 3 and then we will set random internal walls 
mv s1,a0
addi s1,s1,1

li t4,1            
beq s1,t4,firstr
li t4,2
beq s1,t4,secondr   #these are random walls set on board
li t4,3
beq s1,t4,thirdr 
 
j thirdr


firstr:
la s0, mystr 
li t4,'O'                # Assigning Pseudo-rando positions for box
li a1, 22                       # Load the start value (22) into a1
li a2, 27                       # Load the end value (27) into a2
jal ra, random_inclusive_range  # Call the random number generator Result will be in a0
                                            

mv t3, a0             # Move result from a0 to t3 to use or store it
slli t5, t3, 2        # t5 = t3 * 4, shift t3 left by 2 bits (equivalent to multiplying by 4)
add t5, s0, t5        # t5 = s0 + (t3 * 4), calculate the final address
sw t4, 0(t5)          # Store the word in t4 at the address stored in t5
li a1, 32             # Load the start value (22) into a1
li a2, 36  
jal ra, random_inclusive_range
mv t3, a0           # Move result from a0 to t3 to use or store it
slli t5, t3, 2        # t5 = t3 * 4, shift t3 left by 2 bits (equivalent to multiplying by 4)
add t5, s0, t5        # t5 = s0 + (t3 * 4), calculate the final address
sw t4, 0(t5)

li t4,'#'
sw t4,180(s0)
sw t4,220(s0)
sw t4,260(s0)
sw t4,300(s0)        # Set walls on board
sw t4,304(s0)
sw t4,308(s0)
sw t4,312(s0)

li t4,'T'
sw t4,264(s0)
li t4,'T'            # Predetermined Target positions for solvability 
sw t4,352(s0)
j star

secondr:
la s0, mystr 
li t4,'O'               # Assigning Pseudo-rando positions for box
li a1, 22                       # Load the start value (22) into a1
li a2, 27                       # Load the end value (27) into a2
jal ra, random_inclusive_range  # Call the random number generator. Result will be in a0
                                                               

mv t3, a0           # Move result from a0 to t3 to use or store it
slli t5, t3, 2        # t5 = t3 * 4, shift t3 left by 2 bits (equivalent to multiplying by 4)
add t5, s0, t5        # t5 = s0 + (t3 * 4), calculate the final address
sw t4, 0(t5)          # Store the word in t4 at the address stored in t5
li a1, 32           
li a2, 36  
jal ra, random_inclusive_range
mv t3, a0           # Move result from a0 to t3 to use or store it
slli t5, t3, 2        # t5 = t3 * 4, shift t3 left by 2 bits (equivalent to multiplying by 4)
add t5, s0, t5        # t5 = s0 + (t3 * 4), calculate the final address
sw t4, 0(t5)
li t4,'#'
sw t4,180(s0)
sw t4,184(s0)
sw t4,188(s0)
sw t4,192(s0)
sw t4,196(s0)
sw t4,200(s0)
sw t4,204(s0)
sw t4,208(s0)


li t4,'T'
sw t4,244(s0)
li t4,'T'           # Predetermined Target positions for solvability 
sw t4,232(s0)
j star

thirdr:

la s0, mystr 
li t4,'O'              # Assigning Pseudo-rando positions for box
li a1, 22                       # Load the start value (22) into a1
li a2, 27                       # Load the end value (27) into a2
jal ra, random_inclusive_range  # Call the random number generator
                                            # Result will be in a0

mv t3, a0           # Move result from a0 to t3 to use or store it
slli t5, t3, 2        # t5 = t3 * 4, shift t3 left by 2 bits (equivalent to multiplying by 4)
add t5, s0, t5        # t5 = s0 + (t3 * 4), calculate the final address
sw t4, 0(t5)          # Store the word in t4 at the address stored in t5
li a1, 32           # Load the start value (22) into a1
li a2, 36  
jal ra, random_inclusive_range
mv t3, a0           # Move result from a0 to t3 to use or store it
slli t5, t3, 2        # t5 = t3 * 4, shift t3 left by 2 bits (equivalent to multiplying by 4)
add t5, s0, t5        # t5 = s0 + (t3 * 4), calculate the final address
sw t4, 0(t5)
li t4,'#'
sw t4,180(s0)
sw t4,184(s0)
sw t4,188(s0)
sw t4,220(s0)      # Set walls on Board 
sw t4,260(s0)
sw t4,300(s0)
sw t4,340(s0)


li t4,'T'
sw t4,244(s0)
li t4,'T'           # Predetermined Target positions for solvability 
sw t4,352(s0)



star:                       # Assigning Pseudo-rando positions for Player/Character
li t4,'X'
li a1, 11                       # Load the start value (11) into a1
li a2, 18                       # Load the end value (18) into a2
jal ra, random_inclusive_range  # Call the random number generator
                                            # Result will be in a0
li t5, 4
mul a0, a0, t5
add s0,s0,a0
sb t4, 0(s0)          # Store the word in t4 at the address stored in t5


	
start2:
li a0,10
li a7, 11            
ecall
	
la a0,msg              # Load the address of the 'Score = ' message. 
                       # Print the 'Score = ' message.
li a7,4
ecall

mv a0,s2
li a7,1
ecall                 # Print the current score.

li a0,' '            # Load space character to print a space after the score.
li a7, 11            
ecall                # Print the current score.
	



jal printgame   #this function will print game
li a7, 12            
ecall           #this will get input from user

li t4,'q'	
beq a0,t4,gamee #if user enter q game will end
	
li t4,'d'	
beq a0,t4,right #if user enters W A S D
li t4,'a'	
beq a0,t4,left
li t4,'w'	
beq a0,t4,up
li t4,'s'
beq a0,t4,down

j start2



right:  #if user enter d then this right function will work 
# Check for wall ('#') or door ('D') on the right side of the character.
li t3,'#'
lb t4,4(s0)
beq t4,t3,start2
li t3,'D'
lb t4,4(s0)
beq t4,t3,start2

# Check for box ('O') and handle pushing it if possible.
li t3,'O'
lb t4,4(s0)
bne t3,t4,jumpr
li t3,'T'
lb t4,8(s0)
bne t3,t4,jumprr
li t4,'D'
sb t4,8(s0)
addi s2,s2,1
j jumpr

# Move the character right, update the position.
jumprr:
li t3,'#'
lb t4,8(s0)
beq t4,t3,start2
li t3,'O'
lb t4,8(s0)
beq t4,t3,start2


li t4,'O'
sb t4,8(s0)


jumpr:
li t4,' '
sb t4,0(s0)
li t4,'X'
addi s0,s0,4
sb t4,0(s0)
j start2


left:  #if user enter a then left function will work
# Similar logic to 'right', but checks and moves to the left.
li t3,'#'
lb t4,-4(s0)
beq t4,t3,start2
li t3,'D'
lb t4,-4(s0)
beq t4,t3,start2

li t3,'O'
lb t4,-4(s0)
bne t3,t4,jumpl
li t3,'T'
lb t4,-8(s0)
bne t3,t4,jumpll
li t4,'D'
sb t4,-8(s0)
addi s2,s2,1
j jumpl

jumpll:
li t3,'#'
lb t4,-8(s0)
beq t4,t3,start2
li t3,'O'
lb t4,-8(s0)
beq t4,t3,start2


li t4,'O'
sb t4,-8(s0)


jumpl:
li t4,' '
sb t4,0(s0)
li t4,'X'
addi s0,s0,-4
sb t4,0(s0)
j start2

up:
# Check and handle movement upwards. Similar logic as 'right', but with vertical movement.
li t3,'#'
lb t4,-40(s0)
beq t4,t3,start2
li t3,'D'
lb t4,-40(s0)
beq t4,t3,start2


li t3,'O'
lb t4,-40(s0)
bne t3,t4,jumpu
li t3,'T'
lb t4,-80(s0)
bne t3,t4,jumpuu
li t4,'D'
sb t4,-80(s0)
addi s2,s2,1
j jumpu

jumpuu:
li t3,'#'
lb t4,-80(s0)
beq t4,t3,start2
li t3,'O'
lb t4,-80(s0)
beq t4,t3,start2

li t4,'O'
sb t4,-80(s0)


jumpu:
li t4,' '
sb t4,0(s0)
li t4,'X'
addi s0,s0,-40
sb t4,0(s0)
j start2



down:             # If user enter s then down function will work
li t3,'#'         # Handle moving down on the grid.
lb t4,40(s0)
beq t4,t3,start2
li t3,'D'
lb t4,40(s0)
beq t4,t3,start2

li t3,'O'
lb t4,40(s0)
bne t3,t4,jumpd
li t3,'T'
lb t4,80(s0)
bne t3,t4,jumpdd
li t4,'D'
sb t4,80(s0)
addi s2,s2,1
j jumpd

jumpdd:
li t3,'#'
lb t4,80(s0)
beq t4,t3,start2
li t3,'O'
lb t4,80(s0)
beq t4,t3,start2 


li t4,'O'
sb t4,80(s0)


jumpd:

li t4,' '
sb t4,0(s0)
li t4,'X'
addi s0,s0,40
sb t4,0(s0)
j start2


# Print the character back
li a7, 11            # syscall code for print_char
ecall  



	
exit:
    li a7, 10
    ecall
    
printgame:        # Function: Prints the current state of the game board.
                  # Loops through 'mystr', prints each symbol, and handles new lines to format the output as a grid.
 
li t2,0
la t0, mystr
li t1,100
li t6,0 

start4:
beq t6,t1,end4
addi t6,t6,1
li t4,'D'
lw t5,0(t0)
beq t4,t5,add9
addi t0,t0,4 
j start4

add9:
addi t2,t2,1
addi t0,t0,4 
j start4

end4:

li t4,2 
beq t2,t4,end_of_game 
 
 
 
 
li t2,1
beq t2,s1,firstone 
li t2,2
beq t2,s1,secondone 
li t2,3
beq t2,s1,thirdone 


j thirdone

firstone:
la t0, mystr
li t4,'D'
lw t5,264(t0) 
beq t4,t5,jump1
li t4,'T'
sw t4,264(t0)
jump1:

la t0, mystr
li t4,'D'
lw t5,352(t0) 
beq t4,t5,jump2
li t4,'T'
sw t4,352(t0)
jump2:

j donea
secondone:
la t0, mystr
li t4,'D'
lw t5,244(t0) 
beq t4,t5,jump1a
li t4,'T'
sw t4,244(t0)
jump1a:

la t0, mystr
li t4,'D'
lw t5,232(t0) 
beq t4,t5,jump2a
li t4,'T'
sw t4,232(t0)
jump2a:

j donea

thirdone:
la t0, mystr
li t4,'D'
lw t5,244(t0) 
beq t4,t5,jump1b
li t4,'T'
sw t4,244(t0)
jump1b:

la t0, mystr
li t4,'D'
lw t5,352(t0) 
beq t4,t5,jump2b
li t4,'T'
sw t4,352(t0)
jump2b:

donea:              # Spam spaces for formatting
                   
li a0,10
li a7,11
ecall

li a0,10
li a7,11
ecall
li a0,10
li a7,11
ecall


li a0,10
li a7,11
ecall

li a0,10
li a7,11
ecall
li a0,10
li a7,11
ecall


li a0,10
li a7,11
ecall

li a0,10
li a7,11
ecall
li a0,10
li a7,11
ecall
 li a0,10
li a7,11
ecall
 
li t2,0
li t3,100
la t0, mystr 
li t4,0
li t5,10
start1:
beq t2,t3,end1	
	
	
beq t4,t5,jump
addi t4,t4,1
	
lw a0,0(t0)
li a7,11
ecall
addi t2,t2,1
addi t0,t0,4	
j start1	
jump:
li t4,0
li a0,10
li a7,11
ecall

j start1
end1:





jr ra	

end_of_game:
la a0,message
li a7,4
ecall

li a7, 12            #Check if game conditions are met to display the winning message and prompt for a restart.
ecall

li t4,'1'
beq a0,t4,_start


gamee:              # Clean up and exit the game if the player chooses to quit.
la a0,msg1          # Function to handle game exit. Displays a game over message and exits the system call.       
li a7,4
ecall             

li a7, 10   
ecall	
	
jr ra

# --- HELPER FUNCTIONS ---
# Feel free to use, modify, or add to them however you see fit.
random_inclusive_range: # Used Modulus Operation and System Time as a Seed
    mv t0, a1           # Store start in t0 (start is in x11, alias a1)
    mv t1, a2           # Store end in t1 (end is in x12, alias a2)
    
    li a7, 30          # a7 (x17) is used for syscall number, here for getting the time
    ecall              # Time syscall (returns milliseconds in a0 (x10))

    addi t2, t1, 1     # t2 = end + 1 to include the end in the range
    sub t2, t2, t0     # t2 = end - start + 1
    remu a0, a0, t2    # a0 = a0 % (end - start + 1), result is between 0 and (end-start)
    
    add a0, a0, t0     # Shift the range: result is now between start and end
    jr ra              # Return from subroutine
	

     
# Arguments: an integer MAX in a0
# Return: A number from 0 (inclusive) to MAX (exclusive)
# Random Number Generator using Linear Congruential Generator (LCG)
# Algorithm devised by Derrick Lehmer in 1948.
# Reference: "Numerical Recipes: The Art of Scientific Computing" by William H. Press, Saul A. Teukolsky,
# William T. Vetterling, and Brian P. Flannery, 3rd Edition, Cambridge University Press, 2007.
# More info at: http://numerical.recipes
find_random:   
    mv t0, a0          # Move MAX to t0 for later use

    # Initialize constants for LCG: a = 1664525, c = 1013904223 (Common values used in numerical recipes)
    li t1, 1664525     # Multiplier a
    li t2, 1013904223  # Increment c

    # Load or initialize a seed, here using the time syscall
    li a7, 30
    ecall              # Get system time in milliseconds
    mv t3, a0          # Store the current time as the initial seed

    # LCG Algorithm: Xn+1 = (a * Xn + c) % m
    # Using large m = 2^31 (common choice for LCG), implicit by word size
    mul t3, t3, t1     # t3 = seed * a
    add t3, t3, t2     # t3 = (seed * a + c)

    # Since we want a number from 0 to MAX-1, and m is large, we apply modulus by MAX
    remu a0, t3, t0    # a0 = t3 % MAX, where t3 is the new pseudo-random number, t0 is MAX

    jr ra              # Return from subroutine