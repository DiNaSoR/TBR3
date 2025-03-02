function black_arrow_fx(event)
	local caster = event.caster
	if event.ability:IsCooldownReady() == true then
		event.ability:StartCooldown(event.ability:GetCooldown(1))
		EmitSoundOn("Hero_VengefulSpirit.MagicMissile", event.caster)
	end
end

function black_arrow( event )
	if event.ability:IsCooldownReady() == true and event.caster:GetMana() >= event.ability:GetManaCost((event.ability:GetLevel() - 1)) and (event.caster.black_arrow_flag == true or event.ability:GetAutoCastState() == true) then
		EmitSoundOn("Hero_VengefulSpirit.MagicMissileImpact", event.target)
		event.ability:StartCooldown(event.ability:GetCooldown(1))
		event.ability:PayManaCost()
		ApplyDamage({ victim = event.target, attacker = event.caster, damage = event.ability:GetAbilityDamage(), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability	})
		if event.target:IsAlive() == false then

			EmitSoundOn("Hero_VengefulSpirit.WaveOfTerror", event.caster)
			-- attach explosion particle
			local dummy = CreateUnitByName("dummy_unit", event.target:GetOrigin(), false, event.caster, event.caster, event.caster:GetTeam())
			print("Creating explosion particle")
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
			local radius = event.ability:GetSpecialValueFor("explosion_radius")
			ParticleManager:SetParticleControl(particle, 1, dummy:GetAbsOrigin()) --location
			ParticleManager:SetParticleControl(particle, 2, Vector(radius,radius,1)) --radius
			ParticleManager:SetParticleControl(particle, 3, Vector(radius,radius,1)) --other radius

			local particle = ParticleManager:CreateParticle("particles/econ/items/vengeful/vengeful_weapon_talon/vengeful_wave_of_terror_glow_c_talon.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)

			local group = FindUnitsInRadius( event.caster:GetTeamNumber(), event.target:GetAbsOrigin(), nil, event.ability:GetSpecialValueFor("explosion_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			local black_aroow_aoe_damage = event.ability:GetAbilityDamage()
			local black_arrow_damage_type = event.ability:GetAbilityDamageType()
			for key, unit in pairs(group) do
				ApplyDamage({ victim = unit, attacker = event.caster, damage = black_aroow_aoe_damage, damage_type = black_arrow_damage_type, ability = event.ability	})
			end
		else
			event.ability:ApplyDataDrivenModifier( event.caster, event.target, "ranger_black_arrow_post_damage", nil)
		end
		event.caster.black_arrow_flag = false
	end
end

function black_arrow_post_damage( event )
		if event.target:IsAlive() == false then
				local group = FindUnitsInRadius( event.caster:GetTeamNumber(), event.target:GetAbsOrigin(), nil, event.ability:GetSpecialValueFor("explosion_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				local black_aroow_aoe_damage = event.ability:GetAbilityDamage()
				local black_arrow_damage_type = event.ability:GetAbilityDamageType()
				for key, unit in pairs(group) do
					ApplyDamage({ victim = unit, attacker = event.caster, damage = black_aroow_aoe_damage, damage_type = black_arrow_damage_type, ability = event.ability	})
				end
		end
		event.target:RemoveModifierByName("ranger_black_arrow_post_damage")

end

function black_arrow_rework( event )
	local hero = event.caster
	local projSpeed = hero:GetProjectileSpeed()
	local heroSpeed = hero:GetBaseAttackTime() / (100 + hero:GetAttackSpeed()) / 100

	local info = {
			EffectName = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf",
			Ability = event.ability,
			vSpawnOrigin = hero:GetAbsOrigin(),
			--fDistance = 800,
			fStartRadius = 125,
			fEndRadius = 125,
			Target = event.target,
			Source = hero,
			iMoveSpeed = 800,
			bReplaceExisting = false,
			bHasFrontalCone = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = 0,
			iUnitTargetType = DOTA_UNIT_TARGET_CREEP,
			--fExpireTime = GameRules:GetGameTime() + 10
		}
		ProjectileManager:CreateTrackingProjectile(info)

	event.caster:MoveToTargetToAttack(event.target) 
	event.ability:RefundManaCost() 
	event.ability:EndCooldown()
	event.caster.black_arrow_flag = true
	--event.ability:ApplyDataDrivenModifier(event.caster, event.caster, "black_arrow_rework_modifier", nil)

end

function black_arrow_interrupt( event )
	event.caster.black_arrow_flag = false
end

function black_arrow_start( event )
	print(event.unit)
end

function black_arrow_explosion( event )
	
end

function stun_shot( event )
	
end

function puncture( event )
	ApplyDamage({ victim = event.target, attacker = event.caster, damage = (event.ability:GetAbilityDamage() + event.caster.spellPower), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability	})
	event.ability:ApplyDataDrivenModifier( event.caster, event.target, "ranger_puncture_bleed_modifier", nil)
end


function puncture_bleed( event )
	ApplyDamage({ victim = event.target, attacker = event.caster, damage = (event.caster:GetAgility() + event.ability:GetAbilityDamage() * 0.75 ), damage_type = DAMAGE_TYPE_MAGICAL, ability = event.ability	})
end

function star_dust( event )
	local target = event.target
	local hero = event.caster
	local radius = event.ability:GetSpecialValueFor("heal_radius")
	local damage = event.ability:GetAbilityDamage() + hero.spellPower

	--Deal damage and apply star dust on nearby friendly units to 
	ApplyDamage({ victim = target, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = event.ability	})

	-- TODO: Check if this damage should be AoE. Sounds like it should.

	local group = FindUnitsInRadius( hero:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	-- Apply the healing modifier on every ally around
	for _,unit in pairs(group) do
		event.ability:ApplyDataDrivenModifier( hero, unit, "ranger_star_dust_modifier", nil)
	end		
end

function star_dust_heal( event )
	-- Heal them for that much health over 3 seconds for xxxx mana.
	-- TODO: Check if this should use healing Power, I'm assuming it does.
	Timers:CreateTimer({
	    endTime = 0.5,
	    callback = function()
	    	local healingPower = event.caster.healingPower
			local healing_amount = (event.ability:GetAbilityDamage() + healingPower) / 3 
			event.target:Heal(healing_amount, event.caster)
			PopupHealing(event.target, healing_amount)
	    end
	})

end

function soul_piercing_shot( event )
	local manaburn = event.ability:GetLevelSpecialValueFor("manaburn", (event.ability:GetLevel() - 1))

	event.target:ReduceMana(manaburn)
	event.caster:GiveMana(manaburn) 
	ApplyDamage({ victim = event.target, attacker = event.caster, damage = manaburn, damage_type = DAMAGE_TYPE_MAGICAL, ability = event.ability	})
	local particle = ParticleManager:CreateParticle("particles/neutral_fx/black_dragon_attack_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	ParticleManager:SetParticleControl(particle, 3, event.target:GetAbsOrigin())
	--[[if math.random(0,4) < 1 then 
		event.caster:PerformAttack(event.target, true, false, true, true)  
	end]]
end





