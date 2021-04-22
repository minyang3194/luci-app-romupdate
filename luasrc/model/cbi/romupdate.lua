require("luci.sys")

m = Map("romupdate", translate("Romupdate"), translate("Romupdate is a timed run luci-romupdate application"))
--这里section 是对应配置文件romupdate里的第一个类型 ‘longin’，可以有多个section
s = m:section(TypedSection, "login", "")
s.addremove = false
s.anonymous = true --定是否显示Section的名称，建议为true

--enable对应配置文件里字段名，0就是默认不选，也就是进入luci界面之后checkbox不勾选，1就是默认勾选
o = s:option(Flag, "enable", translate("Enable Romupdate"), translate("Tick to enable firmware update"))
o.default = 0
o.optional = false

week = s:option(ListValue, "week", translate("xWeek Day"))
week:value(7, translate("Everyday"))
week:value(1, translate("Monday"))
week:value(2, translate("Tuesday"))
week:value(3, translate("Wednesday"))
week:value(4, translate("Thursday"))
week:value(5, translate("Friday"))
week:value(6,translate("Saturday"))
week:value(0,translate("Sunday"))
week.default=0

hour=s:option(Value,"hour",translate("xHour"))
hour.datatype = "range(0,23)"
hour.rmempty = false

pass=s:option(Value,"minute",translate("xMinute"))
pass.datatype = "range(0,59)"
pass.rmempty = false

local github_url = luci.sys.exec("cat /etc/openwrt_info | awk 'NR==2'")
o=s:option(Value,"github",translate("Github Url"))
o.default=github_url

luci.sys.call("/usr/share/romupdate/Check_Update.sh > /dev/null")
local cloud_version = luci.sys.exec("cat /tmp/cloud_version")
local current_version = luci.sys.exec("cat /etc/openwrt_info | awk 'NR==1'")
local current_model = luci.sys.exec("jsonfilter -e '@.model.id' < /etc/board.json | tr ',' '_'")

local firmware_type = luci.sys.exec("cat /etc/openwrt_info | awk 'NR==4'")

button_upgrade_firmware = s:option (Button, "_button_upgrade_firmware", translate("Upgrade to Latested Version"),
translatef("点击上方 执行更新 后请耐心等待至路由器重启.") .. "<br><br>当前固件版本: " .. current_version .. "<br>云端固件版本: " .. cloud_version.. "<br>固件类型: " .. firmware_type)
button_upgrade_firmware.inputtitle = translate ("Do Upgrade")
button_upgrade_firmware.write = function()
    luci.sys.call("bash /bin/AutoUpdate.sh -u > /dev/null")
end

local e = luci.http.formvalue("cbi.apply")
if e then
    io.popen("/etc/init.d/romupdate restart")
end

m.reset = false
return m

--m:section(类型，“arguments”，“”)
----
----在一个配置文件中可能有很多Section,所以我们需要创建与配置文件中我们想要的Section的联系. “arguments”就是section的uci名字，就是我们在/etc/config/pdnsd中写的那个config arguments
----有两种方式可以选择:NamedSection(name,type,title,description)和TypedSection(type,title,description),前者根据配置文件中的Section名，而后者根据配置文件中的Section类型.我们选用了第二种.
----
----
----
----第4行：设定不允许增加或删除Section，这样能保证页面的清爽，不然会多出一些奇奇怪怪的控件
----第5行：设定是否显示Section的名称，建议为true
----
----这里顺带提一句，lua脚本中使用--来作为注释的标记，而不是常见的//或者#；另外luci可以显示中文，但是你在编辑lua文件的时候必须指定“UTF-8”编码，否则出来的中文是乱码
----
----把这三个文件通过winscp上传到路由器对应的目录上，无需重启路由器，刷新一下路由器后台就可以看到效果