-- title:  	Tic-Tac-Toe
-- author:  Guilherme Nakazato
-- desc:    Tic-Tac-Toe. Not much to say about this.
-- site:    website link
-- license: MIT License 
-- version: 0.1
-- script:  lua

-- vai de 1 a 3
x=1
y=1
areas={{8,2}, {13,2}, {18,2},
	     {8,7}, {13,7}, {18,7},
	     {8,12}, {13,12}, {18,12}}
							
progress={0,0,0,
		      0,0,0,
		      0,0,0}								
p1_turn=true
turns=0
winner=0
winner_text=""
exclamation=0
reset_time=0

win={
	[1]={{1,2,3},{1,4,7},{1,5,9}},
	[2]={{1,2,3},{2,5,8}},
	[3]={{1,2,3},{3,5,7},{3,6,9}},
	[4]={{1,4,7},{4,5,6}},
	[5]={{2,5,8},{4,5,6},{1,5,9},{3,5,7}},
	[6]={{3,6,9},{4,5,6}},
	[7]={{1,4,7},{7,8,9}},
	[8]={{2,5,8},{7,8,9}},
	[9]={{3,6,9},{7,8,9},{1,5,9}},
}

function draw_x(x0,y0,x1,y1)
	line(x0,y0,x1,y1,12)
	line(x0+16,y0,x1-16,y1,12)
end

function draw_circle(x_center,y_center)
	circb(x_center,y_center,12,12)
end

function draw_progress()
	for i=1,9 do
		x_start=areas[i][1]*8
		y_start=areas[i][2]*8
		
		if(progress[i]==1)then
			draw_x(x_start+8,y_start+8,x_start+24,y_start+24)
		elseif(progress[i]==-1)then
			draw_circle(x_start+16,y_start+16)
		end
	end
end

function check_winner(last_move)
	if turns<3 then return 0 end
	
	possible_wins=win[last_move]
	for i=1,#possible_wins do
		sum=0
		for j=1,#possible_wins[i] do
			sum=sum+progress[possible_wins[i][j]]
		end
		
		if(sum==3)then 
			winner_text="x vencedor"
			return 1
		elseif(sum==-3)then 
			winner_text="circulo vencedor"
			return -1 
		end
	end
	
	if turns==9 then 
		winner_text="empate"
	end
	return 0
end

function reset()
	cls(0)
	p1_turn=true
	winner_text=""
	turns=0
	winner=0
	x=1
	y=1
	exclamation=0
	reset_time=0
	progress={0,0,0,
			      0,0,0,
			      0,0,0}
end

function mark_progress()
	if btnp(4)and progress[position]==0 then
		if p1_turn then
			progress[position]=1
		else 
			progress[position]=-1
		end
	
		turns=turns+1
		p1_turn=not p1_turn
		winner=check_winner(position)
	end
end 

function TIC()
	if btnp(0) and y>1 then y=y-1 end
	if btnp(1) and y<3 then y=y+1 end
	if btnp(2) and x>1 then x=x-1 end
	if btnp(3) and x<3 then x=x+1 end
	
	position=x+(y-1)*3
	x_start=areas[position][1]*8
	y_start=areas[position][2]*8
	
	if winner==0 then
		mark_progress()
	end
	
	map(0,0,240,128)
	spr(256,x_start,y_start,0,1,0,0,4,4) 
	
	draw_progress()
	print(winner_text,64,0,12) 
	
	if (turns==9 and winner==0)
				or winner==1 
				or winner==-1 then
				if exclamation<3 then
					winner_text=winner_text.."!"
					exclamation=exclamation+1
				end
				
				reset_time=reset_time+1
	end	
	
	if reset_time>60 then
		reset()
	end
end
