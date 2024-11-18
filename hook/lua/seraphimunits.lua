local SeraLambdaField = import('/mods/BlackOpsFAF-ACUs/lua/ACUsAntiProjectile.lua').SeraLambdaFieldDestroyer

-- Upvalue for performance

local TrashBagAdd = TrashBag.Add

---@class LambdaUnit : SeraLambdaFieldDestroyer
LambdaUnit = Class(SeraLambdaField) {
    ShieldEffects = {
        '/effects/emitters/seraphim_shield_generator_t3_03_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t2_03_emit.bp',
    },

    ---@param self LambdaUnit
    ---@param builder Unit
    ---@param layer Layer
    OnCreate = function(self, builder, layer)
        LambdaUnit.OnCreate(self, builder, layer)

        local army = self.Army
        local bp = self.Blueprint.Defense.LambdaField
        local trash = self.Trash
        self.ShieldEffectsBag = {}

        for _, v in self.ShieldEffects do
            table.insert(self.ShieldEffectsBag, CreateAttachedEmitter(self, 0, army, v):ScaleEmitter(0.0625))
            table.insert(self.ShieldEffectsBag, CreateAttachedEmitter(self, 0, army, v):ScaleEmitter(0.0625):OffsetEmitter(0, -0.5, 0))
            table.insert(self.ShieldEffectsBag, CreateAttachedEmitter(self, 0, army, v):ScaleEmitter(0.0625):OffsetEmitter(0, 0.5, 0))
        end

        local field = SeraLambdaField {
            Owner = self,
            Radius = bp.Radius,
            AttachBone = bp.AttachBone,
            Probability = bp.Probability
        }

        TrashBagAdd(trash, field)
    end,

    ---@param self LambdaUnit
    ---@param parent Unit
    ---@param droneName string
    SetParent = function(self, parent, droneName)
        self.Parent = parent
        self.Drone = droneName
    end,

    -- Make this unit invulnerable
    OnDamage = function()
    end,

    ---@param self LambdaUnit
    ---@param instigator Unit
    ---@param type string
    ---@param overkillRatio number
    OnKilled = function(self, instigator, type, overkillRatio)
        LambdaUnit.OnKilled(self, instigator, type, overkillRatio)

        if self.ShieldEffectsBag then
            for _, v in self.ShieldEffectsBag or {} do
                v:Destroy()
            end
        end
    end,

    ---@param self LambdaUnit
    DeathThread = function(self)
        self:Destroy()
    end,
}
