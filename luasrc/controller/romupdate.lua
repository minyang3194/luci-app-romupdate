module("luci.controller.romupdate", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/romupdate") then
		return
	end
	entry({ "admin", "system", "autoupdate" }, cbi("romupdate"), _("ROM升级"), 99)
end