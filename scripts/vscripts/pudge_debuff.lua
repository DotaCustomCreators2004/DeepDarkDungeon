pudge_debuff = class({})

function ApplyDebuff(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = 500

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	for _, enemy in pairs(enemies) do
		-- Apply the custom debuff modifier to enemies
		enemy:AddNewModifier(caster, ability, "pudge_debuff", { duration = 5 })
	end
    -- Add radiance particle
    local particle = ParticleManager:CreateParticle("particles/radiance.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
end

-- Custom debuff modifier
LinkLuaModifier("pudge_debuff", "pudge_debuff.lua", LUA_MODIFIER_MOTION_NONE)

function pudge_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET, -- Reduce enemy healing
	}
	return funcs
end

function pudge_debuff:GetModifierHealAmplify_PercentageTarget()
	return -50 -- Reduce healing by 50%
end