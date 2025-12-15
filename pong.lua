-- title:   Pong
-- author: 	guillierme
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
normals={
	{x=0,y=1}, --top
	{x=-1,y=0}, --p2
	{x=0,y=-1}, --bot
	{x=1,y=0} --p1
}
score={p1=0,p2=0}
speed=1.5

-- all collision functions will return
-- both the collision flag and 
-- the normal vector
-- looks better me thinks

function player_ball_collision(x,y)
	local collision=false
	local normal=false
	
	if x<=player1.x+8 and y>=player1.y and y<=player1.y+39 then
		collision=true
		normal=normals[4]
	elseif x>=player2.x and y>=player2.y and y<=player2.y+39 then
		collision=true
		normal=normals[2]
	end

	return collision,normal
end

function solid(id)
	local solid=false
	local normal=false
	
	if fget(id,0)then solid=true end
	if fget(id,1)then normal=normals[1]end
	if fget(id,3)then normal=normals[3]end
	
	return solid,normal
end

-- just converting screen coordinates
-- to map coordinates
-- also, the name is better
function tile_id(x,y)
	return mget(x//8,y//8)
end

-- could would should create a vec2
-- dont want to tho
function dot_product(u,v)
	return u.x*v.x+u.y*v.y
end

function subtract_vectors(u,v)
	return{x=u.x-v.x,y=u.y-v.y}
end

function mult_vec_by_scalar(s,u)
	return{x=s*u.x,y=s*u.y}
end

function normalize(u)
	local magnitude=math.sqrt(u.x^2+u.y^2)
	return{x=u.x/magnitude,y=u.y/magnitude}
end

-- r=d-2(d.n)n
function reflection_vector(d,n)
	local dn=dot_product(d,n)
	local mult_n=mult_vec_by_scalar(2 * dn,n)
	local r=subtract_vectors(d,mult_n)
	return normalize(r)
end

function restart()
	ball_pos.x=48
	ball_pos.y=16
	ball_direction.x=0.6
	ball_direction.y=0.8
	speed=1.5
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
	
	local is_solid_top,top_normal=solid(tile_id(new_ball_pos.x,new_ball_pos.y))
	local is_solid_bot,bot_normal=solid(tile_id(new_ball_pos.x,new_ball_pos.y+7))
	local p1_collision,p1_normal=player_ball_collision(new_ball_pos.x,new_ball_pos.y)
	local p2_collision,p2_normal=player_ball_collision(new_ball_pos.x+7,new_ball_pos.y)
	local collision=is_solid_top or is_solid_bot or p1_collision or p2_collision
	local normal=top_normal or bot_normal or p1_normal or p2_normal
	
	if not collision then
		ball_pos.x=new_ball_pos.x
		ball_pos.y=new_ball_pos.y
	else
		ball_direction=reflection_vector(ball_direction,normal)
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
