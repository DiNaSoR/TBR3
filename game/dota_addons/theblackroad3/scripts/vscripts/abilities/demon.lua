--models/heroes/terrorblade/horns.vmdl
--models/heroes/terrorblade/armor.vmdl
--models/heroes/terrorblade/wings.vmdl
--models/heroes/terrorblade/weapon.vmdl
--models/heroes/terrorblade/terrorblade_weapon_planes.vmdl
--models/heroes/terrorblade/horns_arcana.vmdl
--models/heroes/terrorblade/demon.vmdl

function Warglaives_on( event )
    local hero = event.caster
	print("No Draw")
	--event.caster:AddNoDraw()
	--event.caster:RemoveNoDraw()
	--local weapon1 = Entities:FindByModel(nil, "models/heroes/terrorblade/horns.vmdl")
    --local weapon2 = EntitiesFindByModelWithin(event.caster, string modelName, Vector origin, float maxRadius) --[[Returns:handle
    --Find entities by model name within a radius. Pass ''nil'' to start an iteration, or reference to a previously found entity to continue a search
    --]]

	--DeepPrintTable(weapon)
    --weapon:SetModelScale(0) --doesn't seem to work

    --weapon:SetModel("models/development/invisiblebox.vmdl")

    local wearables = {}
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model ~= nil and model:GetClassname() ~= "" and model:GetClassname() == "dota_item_wearable" then
            print(model:GetModelName())
            if string.find(model:GetModelName(), "weapon") ~= nil then
                model:SetModel("models/development/invisiblebox.vmdl")  
            end
        end
        model = model:NextMovePeer()
    end
    
    --[[Timers:CreateTimer({
        endTime = 5,
        callback = function()
            print(#wearables)
            for i = 1, #wearables do
                print(wearables[i]:GetModelName())
                wearables[i]:SetModel("models/heroes/terrorblade/weapon.vmdl")
            end
        end
    })]]
                           
end

function Warglaives_off( event )
    local hero = event.caster
    print("No Draw")

    local wearables = {}
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model ~= nil and model:GetClassname() ~= "" and model:GetClassname() == "dota_item_wearable" then
            print(model:GetModelName())
            if string.find(model:GetModelName(), "invisiblebox") ~= nil then
                model:SetModel("models/heroes/terrorblade/weapon.vmdl")
            end
        end
        model = model:NextMovePeer()
    end
                           
end

function demon_form_on( event )
    event.caster:SetOriginalModel("models/heroes/terrorblade/demon.vmdl")
    event.caster:SetModel("models/heroes/terrorblade/demon.vmdl")
    event.caster:SetRangedProjectileName("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf")
    RemoveWearables(event.caster)
end

function demon_form_off( event )
    event.caster:SetModel("models/heroes/terrorblade/terrorblade.vmdl")
    event.caster:SetOriginalModel("models/heroes/terrorblade/terrorblade.vmdl")
    AttachWearables(event.caster)
end

function AttachWearables( hero )
    weaponModel = "models/heroes/terrorblade/weapon.vmdl" --"models/items/abaddon/alliance_abba_weapon/alliance_abba_weapon.vmdl" 
    local weapon = Entities:CreateByClassname("prop_dynamic")
    weapon:SetModel(weaponModel)
      
    weapon:SetParent(hero, "attach_weapon_r")
    weapon:SetAbsOrigin(hero:GetAbsOrigin())
    weapon:SetAngles(-30,30,-45)
    ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, weapon)

    --local weapon = Entities:CreateByClassname("dota_item_wearable")
    --weapon:SetModel(weaponModel)
    --weapon:SetParent(hero:GetRootMoveParent(), "attach_weapon_l")
    --GetRootMoveParent()
    --ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, weapon)

    --weapon:SetAngles(90,0,0)
end
    
function RemoveWearables( hero )
    local wearables = {}
    local model = hero:FirstMoveChild() --the new prop_dynamics aren't getting included in the hero childs, we need a new method
    while model ~= nil do
        if model ~= nil and model:GetClassname() ~= "" then --and model:GetClassname() == "dota_item_wearable" then
            print(model:GetModelName())
            if string.find(model:GetModelName(), "weapon") ~= nil then --or string.find(model:GetModelName(), "horns") ~= nil then
                table.insert(wearables, model)
            end
        end
        model = model:NextMovePeer()
    end

    for i = 1, #wearables do
        print("removed 1 wearable")
        wearables[i]:RemoveSelf()
    end
end