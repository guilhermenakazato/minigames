-- title:   Pong
-- author: 	Guilherme Nakazato
-- desc:    A simple pong game.
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

-- SCREEN coordinates!
player1={x=8,y=48}
player2={x=224,y=48}
ball_pos={x=48,y=16}
ball_direction={x=0.6,y=0.8} -- tis a vector
score={p1=0,p2=0}
speed=1.5

function player_ball_collision(x,y)
	return (x<=player1.x+8 and y>=player1.y and y<=player1.y+39)
						or(x>=player2.x and y>= player2.y and y<=player2.y+39)
end

function solid(id)
	return fget(id,0)
end

-- just converting screen coordinates
-- to map coordinates
-- also, the name is better
function tile_id(x,y)
	return mget(x//8,y//8)
end

function restart()
	ball_pos.x=48
	ball_pos.y=16
	ball_direction.x=0.6
	ball_direction.y=0.8
	speed=1.5
end

function wall_ball_collision(new_ball_pos)
	local collision_top=solid(tile_id(ball_pos.x,new_ball_pos.y))
	local collision_bot=solid(tile_id(ball_pos.x+7,new_ball_pos.y+7))
	
	if collision_top or collision_bot then
		ball_direction.y=-ball_direction.y
		return true
	end

	return false
end

function hit_player(x,y)
	local hit_p1=x>=player1.x and x<=player1.x+8 and y>=player1.y and y<=player1.y+39
	local hit_p2=x>=player2.x and x<=player2.x+8 and y>=player2.y and y<=player2.y+39
	
	return hit_p1 or hit_p2
end

function player_ball_collision(new_ball_pos)
	local collision_left=hit_player(new_ball_pos.x,ball_pos.y)
		or hit_player(new_ball_pos.x,ball_pos.y+7)
	local collision_right=hit_player(new_ball_pos.x+7,ball_pos.y)
		or hit_player(new_ball_pos.x+7,ball_pos.y+7)
	local collision_bot=hit_player(ball_pos.x,new_ball_pos.y+7)
		or hit_player(ball_pos.x+7,new_ball_pos.y+7)
	local collision_top=hit_player(ball_pos.x,new_ball_pos.y)
		or hit_player(ball_pos.x+7,new_ball_pos.y)

	if collision_left or collision_right then
		ball_direction.x=-ball_direction.x
		return true
	elseif collision_bot or collision_top then
		ball_direction.y=-ball_direction.y	
		return true
	end
	
	return false
end

-- lots of magic numbers
-- who cares tho :))
function TIC()
	if btn(0)and 
	not solid(tile_id(player2.x,player2.y-1))then 
		player2.y=player2.y-1
	end
	
	if btn(1)and 
	not solid(tile_id(player2.x,player2.y+40))then	
		player2.y=player2.y+1 
	end
	
	if btn(8)and
	not solid(tile_id(player1.x,player1.y-1))then
		player1.y=player1.y-1
	end
	
	if btn(9)and
	not solid(tile_id(player1.x,player1.y+40))then
		player1.y=player1.y+1
	end
	
	map(0,0,240,136)
	print(score.p1,98,16,4)
	print(score.p2,128,16,4)
	spr(257,player1.x,player1.y,-1,1,0,0,1,5)
	spr(257,player2.x,player2.y,-1,1,0,0,1,5)
	spr(256,ball_pos.x,ball_pos.y,0)
	
	local new_ball_pos={
		x=ball_pos.x+speed*ball_direction.x,
		y=ball_pos.y+speed*ball_direction.y,
	}
	
	local collision=wall_ball_collision(new_ball_pos)
		or player_ball_collision(new_ball_pos)
		
	if not collision then
		ball_pos.x=new_ball_pos.x
		ball_pos.y=new_ball_pos.y
	else
		speed=speed+0.1
	end
	
	if ball_pos.x<=3 then
		score.p2=score.p2+1
		restart()
	elseif ball_pos.x>=235then
		score.p1=score.p1+1
		restart() 
	end
end
