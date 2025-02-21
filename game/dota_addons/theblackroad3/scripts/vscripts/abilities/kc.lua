-- Reflects a small amount of the physical damage that is inflicted upon the caster to enemies nearby, 250 AoE.
-- 0.02 initially, then +0.01 up to 0.09 at last rank.
function shroud(event)
	event.target.shroud_attacker = event.attacker:GetEntityIndex()
	event.target.shroud_ini_hp = event.target:GetHealth()
	event.ability:ApplyDataDrivenModifier(event.caster, event.target, "shroud_helper", nil) 
end

function shroud_damage( event )
	local damage_taken = event.unit.shroud_ini_hp - event.unit:GetHealth()
	local attacker = EntIndexToHScript(event.unit.shroud_attacker)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_slow_debuff.vpcf", PATTACH_ABSORIGIN, attacker)
	local return_damage = damage_taken * 0.01 * event.ability:GetLevelSpecialValueFor("damage_return_percentage", (event.ability:GetLevel() - 1))
	local radius = event.ability:GetLevelSpecialValueFor("reflect_aoe", (event.ability:GetLevel() - 1))
				
	-- Find enemies
    local enemies = FindUnitsInRadius( event.caster:GetTeam(), event.caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
 
    for _,enemy in pairs(enemies) do
				ApplyDamage({
							victim = attacker,
							attacker = event.unit,
							damage = return_damage,
							damage_type = DAMAGE_TYPE_MAGICAL
							}) 
	end

	print("Shroud did " .. return_damage .. " damage to ".. #enemies .. " enemies from an attack of " .. event.unit.shroud_attacker)
	event.unit:RemoveModifierByName("shroud_helper")
	event.unit.shroud_ini_hp = nil
	--
  Timers:CreateTimer({ useGameTime = false, endTime = 0.3, 
    callback = function() ParticleManager:DestroyParticle(particle, true)
    end })
end