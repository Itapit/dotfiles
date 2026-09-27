-- conf/apps.lua — deprecated alias, use conf/config.lua instead
-- Kept for backward compat while SSOT is conf/config.sh. New code should
-- `local cfg = require("conf.config")` directly.

return require("conf.config")
