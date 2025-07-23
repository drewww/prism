local path = ...
-- Strip the last component of the path
local basePath = path:match("^(.*)%.") or ""

--- @module "extra.inventory.inventorytarget"
prism.InventoryTarget = require(basePath .. ".inventorytarget")