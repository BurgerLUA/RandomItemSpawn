

if game.GetMap( ) ~= "gm_abstract" then return end




local DropRate = 10




local Locations = {}
Locations[1] = Vector(1024, 0 , 0)
Locations[2] = Vector(-1024, 0 , 0)
Locations[3] = Vector(0, 1024 , 0)
Locations[4] = Vector(0, -1024 , 0)
Locations[5] = Vector(0, 0, 256)

-- don't touch anything below
local nextplacetime = DropRate
local LocationsCount = table.Count(Locations)

local Items = {}

local WeaponTable = weapons.GetList()
local EntityTable = scripted_ents.GetList( )

for k,v in pairs(WeaponTable) do
	if v.Base == "weapon_cs_base" and v.Category == "Counter-Strike" then
		table.Add(Items,{WeaponTable[k].ClassName})
		table.Add(Items,{WeaponTable[k].ClassName})
	end
end

--[[
for a,b in pairs(EntityTable) do

	print( EntityTable[a].Category )

	if b.Category == "CS:S Ammo" then
		
		table.Add(Items,{EntityTable[a].ClassName})
	end
end
--]]

local AmmoEnts = {"ent_cs_ammo_762mm","ent_cs_ammo_556mm","ent_cs_ammo_357sig","ent_cs_ammo_338","ent_cs_ammo_57mm","ent_cs_ammo_50","ent_cs_ammo_46mm","ent_cs_ammo_45","ent_cs_ammo_9mm"}

table.Add(Items,AmmoEnts)

--print("List:")
--PrintTable(Items)

local ItemsCount = table.Count(Items)



function ItemPlacer()

	if nextplacetime <= CurTime() then
	
		
	
		local echoice = Items[math.random(1,ItemsCount)]
		local vchoice = Locations[math.random(1,LocationsCount)]
	
		local sphere = ents.FindInSphere( vchoice, 100 )
		
		local canspawn = true
		
		for k,v in pairs(sphere) do
			if v:GetClass() == "ent_cs_droppedweapon" then
				v:Remove()
			end
		end
		
		if canspawn == true then
			print(echoice)
			if string.sub( echoice, 1,6 ) == "weapon" then
				
				
				local dropped = ents.Create("ent_cs_droppedweapon")
					dropped:SetPos(vchoice)
					dropped:SetAngles(Angle(0,0,0))
					if weapons.GetStored(echoice).WorldModel ~= nil then
						dropped:SetModel(weapons.GetStored(echoice).WorldModel)
					else
						dropped:SetModel("models/hunter/blocks/cube025x025x025.mdl")
					end
					dropped:Spawn()
					dropped:Activate()
					dropped:SetNWString("class",echoice)
					dropped:SetNWInt("clip",weapons.GetStored(echoice).Primary.ClipSize)
					
			else
			
				local dropped = ents.Create(echoice)
					dropped:SetPos(vchoice)
					dropped:SetAngles(Angle(0,0,0))
					dropped:Spawn()
					dropped:Activate()
			
			end
		
			nextplacetime = CurTime() + DropRate
		
		end
			
		
		
		
		
		
	
	
	
	end




end


hook.Add("Think","Item Placer Script", ItemPlacer)