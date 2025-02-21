-- Stat RPG Save
function RPGSave()
	print("Performing rpg_save for every player")
	if not GameRules.LOADING then
		for pID = 0, DOTA_MAX_PLAYERS-1 do
	    	if PlayerResource:IsValidPlayer(pID) then
				local hero = PlayerResource:GetSelectedHeroEntity( pID )
				if hero then
					local hID = PlayerResource:GetSelectedHeroID( pID )		
					local XP = PlayerResource:GetTotalEarnedXP( pID )
					
					-- Resources Gold and Materials
					local gold = PlayerResource:GetGold( pID )
					local materials = hero.materials

					-- Stats - Custom Values granted by AllocateStats str/agi/int
					local STR = hero.STR
					local AGI = hero.AGI
					local INT = hero.INT

					-- Skill Points unspent
					local unspent_points = hero:GetAbilityPoints()

					-- Go through the inventory
					local items = ""
					for i=0,5 do
						local item_i = hero:GetItemInSlot(i)
						local item_name = "empty"
						if item_i then
							item_name = item_i:GetAbilityName()
						end
						items = items..item_name
						if i<5 then
							items = items..","
						end
					end

					-- Go through the skill slots
					local ability_levels = ""
					for j=0,15 do
						local ability = hero:GetAbilityByIndex(j)
						local level = 0
						if ability then
							level = ability:GetLevel()
						end
						ability_levels = ability_levels..level
						if j<15 then
							ability_levels = ability_levels..","
						end
					end

					print("FireGameEvent rpg_save")
					print("pID: "..pID)
					print("save_ID: "..hID)
					print("hero_XP: "..XP)
					print("Resources-> Gold: "..gold.."  Materials: "..materials)
					print("Allocated Stats-> STR: "..STR.."  AGI: "..AGI.."  INT: "..INT)
					print("Unspent Skill Points: "..unspent_points)
					print("Hero Items: "..items)
					print("Ability Levels: "..ability_levels)
					FireGameEvent( 'rpg_save', { player_ID = pID, save_ID = hID, hero_XP = XP, gold = gold, materials = materials, 
												 STR_points = STR, AGI_points = AGI, INT_points = INT, unspent_points = unspent_points, 
												 hero_items = items, ability_levels = ability_levels})


					-- Custom Stash - Another SaveID 0 with items shared across heroID-Saves.
				end
			end
		end
	end
end

-- Stat RPG Load
function RPGLoad( hero )
	local pID = hero:GetPlayerID()
	local hID = PlayerResource:GetSelectedHeroID( pID )
	print("FireGameEvent('rpg_load', {"..pID,hID.."})")
	FireGameEvent( 'rpg_load', { player_ID = pID , save_ID = hID})
end