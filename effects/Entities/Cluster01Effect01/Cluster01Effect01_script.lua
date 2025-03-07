-----------------------------------------------------------------------------------
-- File     :  /effects/Entities/Cluster01Effect011/Cluster01Effect01_script.lua
-- Author(s):  Gordon Duclos
-- Summary  :  Nuclear explosion script
-- Copyright � 2005, 2006 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------------------------

local NullShell = import('/lua/sim/defaultprojectiles.lua').NullShell

local TrashBagAdd = TrashBag.Add

---@class Cluster01Effect01 : NullShell
Cluster01Effect01 = Class(NullShell) {

    ---@param self Cluster01Effect01
    OnCreate = function(self)
        NullShell.OnCreate(self)
        local trash = self.Trash
        TrashBagAdd(trash, ForkThread(self.EffectThread, self))
    end,

    ---@param self Cluster01Effect01
    EffectThread = function(self)
        local scale = self.Blueprint.Display.UniformScale
        local scaleChange = 0.30 * scale

        self:SetScaleVelocity(scaleChange, scaleChange, scaleChange)
        self:SetVelocity(0, 0.0078125, 0)

        WaitSeconds(4)
        scaleChange = -0.01 * scale
        self:SetScaleVelocity(scaleChange, 12 * scaleChange, scaleChange)
        self:SetVelocity(0, 0.09375, 0)
        self:SetBallisticAcceleration(-0.015625)

        WaitSeconds(5)
        scaleChange = -0.1 * scale
        self:SetScaleVelocity(scaleChange, scaleChange, scaleChange)
    end,
}

TypeClass = Cluster01Effect01
