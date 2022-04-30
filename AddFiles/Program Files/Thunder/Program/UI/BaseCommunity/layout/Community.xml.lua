XLSetGlobal("Xunlei.BaseCommunity.ListenerFactory",{
CreateListener=function(a)
local l={}
local AttachEvent=function(a,b,c)
if b==nil or c==nil then
return 
end
local cookie=a.EventList.CookieNum + 1
a.EventList.CookieNum=cookie
if a.EventList[b]==nil then
a.EventList[b]={}
end
a.EventList[b][cookie]=c
return cookie
end
local DetachEvent=function(d,e,f)
if e==nil or f==nil then
return 
end
if d.EventList[e]==nil then
return 
end
d.EventList[e][f]=nil
end
local FireEvent=function(g,h,...)
if g.EventList[h]==nil then
return 
end
for cookie,cb in pairs(g.EventList[h]) do
cb(...)
end
end
l.AttachEvent=AttachEvent
l.DetachEvent=DetachEvent
l.FireEvent=FireEvent
l.EventList={}
l.EventList.CookieNum=0
return l
end
})
local b=function()end
local f=XLGetGlobal("Xunlei.BaseCommunity.ListenerFactory")
local l=f:CreateListener()
l.GetCurrentStatus=function()return "unlogin" end
l.StartListenLoginEvent=b
l.loginStatus="unlogin"
XLSetGlobal("Xunlei.BaseCommunity.LoginStatus",l)
local u=f:CreateListener()
u.IsVip=b
u.GetVipType=b
u.GetVipLevel=b
XLSetGlobal("Xunlei.BaseCommunity.UserInfo",u)
XLSetGlobal("XLBrowserHotKey.Helper",{AttachListener=b})
XLSetGlobal("xunlei.TaskDetailHelper",{EndTaskDetailWnd=b})
XLSetGlobal("Xunlei.PrivateSpaceHelper",{CurrentViewIsPrivate=b,GetViewId=b})
XLSetGlobal("Thunder.SmartWebMode.Helper",{})