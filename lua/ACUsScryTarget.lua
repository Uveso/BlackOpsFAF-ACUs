-----------------------------------------------------------------
-- File: lua/TargetLocation.lua
-- Copyright � 2008 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local ScriptTask = import('/lua/sim/ScriptTask.lua').ScriptTask
local TASKSTATUS = import('/lua/sim/ScriptTask.lua').TASKSTATUS
local AIRESULT = import('/lua/sim/ScriptTask.lua').AIRESULT

---@class ACUsScryTarget : ScriptTask
ACUsScryTarget = Class(ScriptTask) {

    ---@param self ACUsScryTarget
    ---@param commandData table
    OnCreate = function(self,commandData)
        ScriptTask.OnCreate(self,commandData)
    end,

    ---@param self ACUsScryTarget
    ---@return number
    TaskTick = function(self)
        self:SetAIResult(AIRESULT.Success)
        return TASKSTATUS.Done
    end,

    ---@param self ACUsScryTarget unused
    ---@return boolean
    IsInRange = function(self)
        return true
    end,
}
