local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')

-- UEF Nuke Flavor Plume effect
---@class Cluster01FlavorPlume01 : EmitterProjectile
Cluster01FlavorPlume01 = Class(EmitterProjectile) {
    FxTrails = EffectTemplate.TNukeFlavorPlume01,
    FxTrailScale = 0.03125,
    FxImpactUnit = {},
    FxImpactLand = {},
    FxImpactWater = {},
    FxImpactUnderWater = {},
    FxImpactNone = {},
}

TypeClass = Cluster01FlavorPlume01