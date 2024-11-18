-----------------------------------------------------------------
-- File     :  /data/projectiles/SDFAireauWeapon01/SDFAireauWeapon01_script.lua
-- Author(s):  Matt Vainio
-- Summary  :  Aire-Au Autocannon, XSL0401
-- Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------
local SeraRapidCannon01Projectile = import('/mods/BlackOpsFAF-ACUs/lua/ACUsProjectiles.lua').SeraRapidCannon01Projectile

---@class SeraRapidCannon01 : SeraRapidCannon01Projectile
SeraRapidCannon01 = Class(SeraRapidCannon01Projectile) {}

TypeClass = SeraRapidCannon01