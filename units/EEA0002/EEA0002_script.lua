-----------------------------------------------------------------
-- File     :  /cdimage/units/XEA0002/XEA0002_script.lua
-- Author(s):  Drew Staltman, Gordon Duclos
-- Summary  :  UEF Defense Satelite Script
-- Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------
local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone
local EffectTemplate = import('/lua/EffectTemplates.lua')
local BlackOpsEffectTemplate = import('/mods/BlackOpsFAF-ACUs/lua/ACUsEffectTemplates.lua')

---@class EEA0002 : TAirUnit
EEA0002 = Class(TAirUnit) {
    Parent = nil,
    DestroyNoFallRandomChance = 1.1,

    HideBones = {'Shell01', 'Shell02', 'Shell03', 'Shell04',},

    Weapons = {
    },


    ---@param self EEA0002
    ---@param parent Unit
    ---@param podName string
    SetParent = function(self, parent, podName)
        self.Parent = parent
        self.Pod = podName
    end,

    ---@param self EEA0002
    ---@param builder Unit
    ---@param layer Layer
    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
        self.ProjTable = {}
    end,

    ---@param self EEA0002
    ---@param instigator Unit
    ---@param type DamageType
    ---@param overkillRatio number
    OnKilled = function(self, instigator, type, overkillRatio)
        if self.IsDying then return end
        self.IsDying = true
        self.Parent:NotifyOfPodDeath(self.Pod)
        self.Parent = nil
        self:ForkThread(self.DeathEffectsThread)
        TAirUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    ---@param self EEA0002
    Open = function(self)
        ChangeState(self, self.OpenState)
    end,

    ---@param self EEA0002
    ---@param bone Bone
    ---@param army Army
    CreateDamageEffects = function(self, bone, army)
        for _, v in BlackOpsEffectTemplate.SatDeathEffectsPackage do
            CreateAttachedEmitter(self, bone, army, v):ScaleEmitter(6)
        end
    end,

    ---@param self EEA0002
    ---@param bone Bone
    ---@param army Army
    CreateExplosionDebris = function(self, bone, army)
        for _, v in EffectTemplate.ExplosionDebrisLrg01 do
            CreateAttachedEmitter(self, bone, army, v)
        end
    end,

    ---@param self EEA0002
    DeathEffectsThread = function(self)
        local army = self.Army
        -- Create Initial explosion effects
        explosion.CreateFlash(self, 'XEA0002', 1.5, army)
        CreateAttachedEmitter(self,'Turret_Barrel_Muzzle', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp'):OffsetEmitter(0, 0, 0) --Sparks
        CreateAttachedEmitter(self,'Turret_Barrel_Muzzle', army, '/effects/emitters/distortion_ring_01_emit.bp'):ScaleEmitter(0.3)

        self:CreateExplosionDebris('XEA0002', army) --Debris spread
        CreateDeathExplosion(self, 'XEA0002', 1.5) -- Simple Explosion
        self:CreateDamageEffects('XEA0002', army) -- Fireball & trailing smoke
        self:CreateDamageEffects('L_Panel03', army)
        self:CreateDamageEffects('R_Panel03', army)
    end,

    OpenState = State() {
        Main = function(self)
            self.OpenAnim = CreateAnimator(self)
            self.OpenAnim:PlayAnim('/mods/BlackOpsFAF-ACUs/units/EEA0002/eea0002_aopen01.sca')
            self.Trash:Add(self.OpenAnim)
            WaitFor(self.OpenAnim)

            self.OpenAnim:PlayAnim('/mods/BlackOpsFAF-ACUs/units/EEA0002/eea0002_aopen02.sca')

            for _, v in self.HideBones do
                self:HideBone(v, true)
            end
        end,

        ProjSpawn = function(self)
            if not self:IsDead() then
                if self.ProjTable then
                    for _, v in self.ProjTable do
                        v:Destroy()
                    end
                    self.ProjTable = {}
                end
                local loc = self:GetPosition('XEA0002')                               
                proj = self:CreateProjectile('/mods/BlackOpsFAF-ACUs/projectiles/SpysatSMDBait/SpysatSMDBait_proj.bp', loc[1], loc[2], loc[3], nil, nil, nil):SetCollision(false)
                Warp(proj, loc)
                table.insert (self.ProjTable, proj)
                proj:SetParent(self, 'eea0002')
                self.Trash:Add(proj)
            end
        end,
    },
}

TypeClass = EEA0002
