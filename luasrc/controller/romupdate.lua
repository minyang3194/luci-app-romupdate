module("luci.controller.romupdate", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/romupdate") then
		return
	end
	entry({ "admin", "system", "autoupdate" }, cbi("romupdate"), _("AutoUpdate"), 99)
end
--这个文件的含义是：首先检查有没有/etc/config/pdnsd文件，如果有就继续向下执行，没有就当什么都没有发生过
--第一行中，固定格式是“luci.controller.我的项目名”，因为我们所有的lua文件和/etc/config下面的配置文件都是以pdnsd来进行命名的，所以应该填“luci.controller.pdnsd”
--倒数第二行是一个固定格式
--entry(路径, 调用目标, _("显示名称"), 显示顺序)

