pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
data = {
	{5,4,8,3,1,4,3,2,2,3},
 {2,7,4,5,8,5,4,7,1,1},
 {5,2,6,4,5,5,6,1,7,3},
 {6,1,4,1,3,3,6,1,4,6},
 {6,3,5,7,3,8,5,4,7,8},
 {4,1,6,7,5,2,4,6,4,5},
 {2,1,7,6,8,4,1,7,2,1},
 {6,8,8,2,8,8,1,1,3,4},
 {4,8,4,6,8,4,8,5,5,4},
 {5,2,8,3,7,5,1,5,2,6}
}

data_2= 
{
	{5,4,8,3,1,4,3,2,2,3},
 {2,7,4,5,8,5,4,7,1,1},
 {5,2,8,8,8,8,8,1,7,3},
 {6,1,8,8,8,8,8,1,4,6},
 {6,3,8,8,9,8,8,4,7,8},
 {4,1,8,8,8,8,8,6,4,5},
 {2,1,8,8,8,8,8,7,2,1},
 {6,8,8,2,8,8,1,1,3,4},
 {4,8,4,6,8,4,8,5,5,4},
 {5,2,8,3,7,5,1,5,2,6}
}

data = {
 {4,3,4,1,3,4,7,6,4,3},
 {5,4,7,7,7,2,8,4,5,1},
 {2,3,2,2,7,3,3,8,7,8},
 {5,4,5,3,7,6,2,5,5,6},
 {2,7,1,8,1,2,3,4,2,1},
 {4,2,3,7,8,8,6,1,1,5},
 {5,6,3,1,6,1,7,1,1,4},
 {2,2,1,7,6,6,7,2,2,7},
 {4,2,3,6,5,8,1,2,5,5},
 {4,4,8,2,6,2,7,6,4,1}
}

b_max=4


debug=""

function dbg(str)
	debug=debug.."\n"..str
	printh(debug,"@clip", true)
end

function _init()
 flashes=0
 steps=0
 frame=1
	octs = {}
	for y=1,10 do
		for x=1,10 do
			add(octs,{
				energy=data[y][x],
				x=x*10,
				y=y*10,
				px=x,
				py=y,
				f=rnd(3),
				blink=0
			})
			dbg("p"..x.."n"..y.."[pos=\""..x..","..y.."!\"]")
		end
	end
end

function index(x,y)
 if x<1 or x>10 or y<1 or y>10 then
  return -1
 end 
 return (y-1)*10+x
end

function get(x,y)
 local i = index(x,y)
 if i < 1 or i > #octs then
  return nil
 end
 return octs[i]
end

mark={x=2,y=5}


function enque(x,y,que)
 
 --dbg(x.."-"..y)
	for xr = x-1,x+1 do
	 for yr = y-1,y+1 do
	  if xr!=0 or yr!=0 then
	  	local oct = get(xr,yr)
	  	if oct != nil 
	  	  and oct.energy < 10 then
	  	 oct.energy+=1
	  	 dbg(
	  	 	"p"..x.."n"..y.." -> p"..oct.px.."n"..oct.py..";" 
	  	 )
	  	 if oct.px==mark.x 
	  	 	and oct.py==mark.y then
	  	   --dbg("😐 mark -- by "..x.."-"..y)
	  	 end
	  	 if(oct.energy > 9) then 
	  	  --dbg("enq"..oct.px.."-"..oct.py..":"..oct.energy)
	  	  --dbg("by "..x.."-"..y.."\n")
	  	  add(que,oct)
	  	  n_b+=1
	  	 end
	  	end
   end
	 end
	end
end

n_b=0
function step()
 dbg("step")
 n_b=0
 local que={}
	for o in all(octs) do
	 o.energy+=1
	 if o.energy>9 then
	  add(que,o)
	  n_b+=1
	 end
	end
	
	while #que>0 do
		local o = que[#que]
		del(que,o)
		o.blink=b_max
		flashes+=1
		enque(o.px,o.py,que)
		if n_b ==100 then
			x=br.eak
		end
	end
	
	for o in all(octs) do
	 if o.energy>9 then
	  o.energy=0
	 end
	end
end





function _draw()
	-- background
	cls(12)

	
	for i = 0,15 do
		spr(17,i*8,104)
		spr(33,i*8,112)
		spr(49,i*8,120)
	end
	-- octs ˇ
	for oct in all(octs) do
	 
	  --if rnd(1000)<1 then 
	  -- oct.blink=b_max
	  -- sfx(2)
	  --end
	  oct.blink = max(0,oct.blink-1)
	  if oct.blink > 0 then 
	   pal(3,11)
	  end
	  if oct.px==mark.x and
	   oct.py==mark.y then
	  -- pal(3,8)
	  end
			s = 1 + flr((oct.f*10+frame)/10)%4
			spr(s,oct.x+4,oct.y+4)
			--print(oct.energy, oct.x,oct.y,3)
			pal()
	end
	
	for oct in all(octs) do
	 if oct.blink > 0  and false then 
	   circ(
	   	oct.x+4,
	   	oct.y+4,
	   	b_max-oct.blink,
	   	11)
	   circ(
	   	oct.x+4,
	   	oct.y+4,
	   	(b_max-oct.blink)/2,
	   	11)
	   pal(3,11)
	  end
	end
	print(steps,0,0,8)
	print(flashes,0,9,8)
	--cls()
	--spr(1,60,60,10,2)
end

function _update()
 frame=frame+1
 if 
 	--btnp(1)	 
  frame%2==0 
 then
  --if steps then
 	 step()
 	 steps+=1
 	--end
 end
end

__gfx__
0000000000333000033300000033300003330000000000000000000000d00000bbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000
00000000033333003333300003333300333330000000000e000000000dd00000bbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000
0070070003737300373730000373730037373000000000eeee0000000dd00000bbbbbbb8bbbbe3bb000000000000000000000000000000000000000000000000
000770000753570075357000075357007535700000000e666ee00000dd000000bbbbbb8b8bbebeab000000000000000000000000000000000000000000000000
0007700003003000030030000300300003003000000ee666666ee000d0000000bbbb3bb8bbbbebbb000000000000000000000000000000000000000000000000
0070070000300300030030003003000003003000000e6576666ee00000000000bbbbbbbbb3bbbbbb000000000000000000000000000000000000000000000000
0000000003003000030030000300300003003000000e6556576e000000000000bbbbbbbbbbbbabbb000000000000000000000000000000000000000000000000
0000000030030000030030000030030003003000000e6666556ee00000000000bb3bbbbbbbbbbbbb000000000000000000000000000000000000000000000000
00000000cccccccc000000000000000000000000000ee66666666ee000000000bbbbbbbbbbb3bbbb000000000000000000000000000000000000000000000000
00000000cccccccc000000000000000000000000000ee65666666e0000000000bbbbbb8bbbbbbbbb000000000000000000000000000000000000000000000000
00000000cccccccc00000000000000000000000000ee665566666e0000000000bb3bb8b8bbbcbbbb000000000000000000000000000000000000000000000000
00000000cdcdcdcd00000000000000000000000000e6666556666ee000000000bbbbbb8bbbcbcbbb000000000000000000000000000000000000000000000000
00000000dcdcdcdc00000000000000000000000000ee66666666ee0000000000bbbbbbbbbbbcbbbb000000000000000000000000000000000000000000000000
00000000cddcddcd000000000000000000000000000ee6666666e00000000000bbbbb3bbbbbbbbbb000000000000000000000000000000000000000000000000
00000000cdcdcdcd0000000000000000000000000000eeeeeeeee00000000000bbbbbb3bbbbbbb3b000000000000000000000000000000000000000000000000
00000000dddddddd00000000000000000000000000000000000000000000000033bbbbbbbbb3bbbb000000000000000000000000000000000000000000000000
00000000dddddddd00000000000000000000000000000000000000000000000033bbbb3bbbb3bbbb444444444444444400000000000000000000000000000000
000000001d1d1d1d0000000000000000000000000000000000000000000000003bb3bbbbb3bbbbbb444444444444444400000000000000000000000000000000
00000000dddddddd000000000000000000000000000000000000000000000000b4b4b4b4b4b4b4b4444444444444444400000000000000000000000000000000
00000000d1d1d1d10000000000000000000000000000000000000000000000004444344434444334444444444444444400000000000000000000000000000000
00000000dddddddd0000000000000000000000000000000000000000000000004444444444444444444444444444444400000000000000000000000000000000
000000001d1d1d1d0000000000000000000000000000000000000000000000004444444444444444444444444444444400000000000000000000000000000000
00000000d1d1d1d10000000000000000000000000000000000000000000000004444444444444454444444444444444400000000000000000000000000000000
000000001d1d1d1d0000000000000000000000000000000000000000000000004544444444444444444444444444444400000000000000000000000000000000
00000000d1d1d1d10000000000000000000000000000000000000000000000004444444444444444444444444444444400000000000000000000000000000000
00000000111d111d0000000000000000000000000000000000000000000000004444445444444444444444444444444400000000000000000000000000000000
000000001d1111110000000000000000000000000000000000000000000000004444444644444544444444444444444400000000000000000000000000000000
000000001111111d0000000000000000000000000000000000000000000000004444444444444644444444444444444400000000000000000000000000000000
0000000011d11d110000000000000000000000000000000000000000000000004444444444444444444444444444444400000000000000000000000000000000
00000000111111110000000000000000000000000000000000000000000000004445444444444444444444444444444400000000000000000000000000000000
00000000111111110000000000000000000000000000000000000000000000004444444444444444444444444444444400000000000000000000000000000000
00000000111111110000000000000000000000000000000000000000000000004444444444444444444444444444444400000000000000000000000000000000
__label__
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__map__
0404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000e00003305234052350553700039000390003a0003b0003b0003c0003c0003c0003e0003e0003e000070003d000060003b00000000000000000039000000003800000000370003600000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000475200052000520000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 00024344

