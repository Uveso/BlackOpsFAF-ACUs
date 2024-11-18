-----------------------------------------------------------------
--    File     :  /data/Projectiles/ADFReactonCannnon01/ADFReactonCannnon01_script.lua
--    Author(s): Jessica St.Croix, Gordon Duclos
--    Summary  : Aeon Reacton Cannon Area of Effect Projectile
--    Copyright � 2006 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------
local DummyArtemisCannonProjectile = import('/lua/sim/defaultprojectiles.lua').NullShell
local EffectUtil = import('/lua/EffectUtilities.lua') 

---@class SpysatSMDBait : DummyArtemisCannonProjectile
SpysatSMDBait = Class(DummyArtemisCannonProjectile) {

    ---@param self SpysatSMDBait
    ---@param TargetType string
    ---@param TargetEntity Entity
    OnImpact = function(self, TargetType, TargetEntity)
        DummyArtemisCannonProjectile.OnImpact(self, TargetType, TargetEntity)
    end,

    ---@param self SpysatSMDBait
    ---@param instigator Unit
    ---@param amount number
    ---@param vector Vector
    ---@param damageType DamageType
    DoTakeDamage = function(self, instigator, amount, vector, damageType)
        DummyArtemisCannonProjectile.DoTakeDamage(self, instigator, amount, vector, damageType)
        if not self.Parent:IsDead() then
            self.Parent:Kill()
        end
    end,

    ---@param self SpysatSMDBait
    OnCreate = function(self)
        DummyArtemisCannonProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2.0)
        self.KillThread = self:ForkThread(self.Verification)
        self.KillThread = self:ForkThread(self.KillSelfThread)
    end,

    ---@param self SpysatSMDBait
    KillSelfThread = function(self)
        WaitSeconds(20)
        if not self.Parent:IsDead() then
            self.Parent:ProjSpawn()
        end
        self:Destroy()
    end,

    Parent = nil,

    ---@param self SpysatSMDBait
    ---@param parent any
    ---@param projName string
    SetParent = function(self, parent, projName)
        self.Parent = parent
        self.Proj = projName
    end,

    ---@param self SpysatSMDBait
    Verification = function(self)
        while not self:BeenDestroyed() and not self.Parent:IsDead() do
            local unitLoc = self.Parent:GetPosition('Turret_Barrel_Muzzle')
            local projmod = unitLoc[2] - 1
            local destination = {unitLoc[1], projmod, unitLoc[3]} 
            Warp(self, destination)
            WaitSeconds(1)
        end
    end,

    ---@param self SpysatSMDBait
    OnDestroyed = function(self)
        DummyArtemisCannonProjectile.OnDestroyed(self, instigator, type, overkillRatio)
    end,
}
TypeClass = SpysatSMDBait