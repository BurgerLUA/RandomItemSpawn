
local Items = {}
local Weapons = {}

local AlreadyLoaded = false

function LoadWeapons()

	if not AlreadyLoaded then

		local WeaponTable = weapons.GetList()
		local EntityTable = scripted_ents.GetList( )


		for k,v in pairs(WeaponTable) do

			if v.Base == "weapon_cs_base" and v.Category == "Counter-Strike" then
	
				
				if v.WeaponType	~= "Free" then
					table.Add(Weapons,{WeaponTable[k].ClassName})
				end
				
			end
			
		end
		
		AlreadyLoaded = true
		
		WeaponsCount = table.Count(Weapons)
		
	end
	
end

hook.Add("Think", "Load Weapons", LoadWeapons)

if game.GetMap( ) ~= "gm_bestbuy" then return end

local DropRate = 1


local Locations = {}
Locations[1] = Vector(460 , -197 , 82)
Locations[2] = Vector(-582, 1080, 82)
Locations[3] = Vector(-531, -117, 82)
Locations[4] = Vector(1485, -625, 118)
Locations[5] = Vector(756, 217, 82)
Locations[6] = Vector(1048, -740, 82)
Locations[7] = Vector(-196 , 137 , 152)
Locations[8] = Vector(1328, 920 , 82)

-- don't touch anything below
local nextplacetime = DropRate
local LocationsCount = table.Count(Locations)

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
	
		local echoice
		
		if math.random(1,100) > 70 then
			echoice = Items[math.random(1,ItemsCount)]
		else
			echoice = Weapons[math.random(1,WeaponsCount)]
		end
		
		
		
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




