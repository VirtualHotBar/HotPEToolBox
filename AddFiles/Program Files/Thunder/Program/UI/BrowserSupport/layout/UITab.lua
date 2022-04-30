AttachListener=function(a,b,c)
if a.eventList==nil then
a.eventList={}
end
if a.eventList[b]==nil then
a.eventList[b]={}
end
table.insert(a.eventList[b],c)
return #a.eventList[b]
end
CreateTab=function(id,headerObj,pageObj,tabType,bAttr)
local tab={
ID=id,
headerObj=headerObj,
pageObj=pageObj,
type=tabType,
eventList={},
IsUITab=IsUITab,
ShowPage=ShowPage,
GetTabID=GetTabID,
GetUrl=GetUrl,
SetUrl=SetUrl,
GetPageUrl=GetPageUrl,
SetTitle=SetTitle,
GetTitle=GetTitle,
GetType=GetType,
SetUIObject=SetUIObject,
GetUIObject=GetUIObject,
IsMainTab=IsMainTab,
SetContext=SetContext,
AttachListener=AttachListener,
SetShowCloseBtn=SetShowCloseBtn,
SetState=SetState,
GetState=GetState,
CanGoBack=CanGoBack,
CanGoForward=CanGoForward,
GetHeaderObj=GetHeaderObj,
GetPageObj=GetPageObj,
SetHeaderZOrder=SetHeaderZOrder,
TabBusinessAttr=bAttr
}
tab.headerObj:SetTabID(id)
tab.pageObj:SetTabID(id)
return tab
end
SetShowCloseBtn=function(a,b)a.headerObj:ShowCloseBtn(b) end
IsUITab=function()return true end
ShowPage=function(a,b)
a.pageObj:ShowPage(b)
a.pageObj:SetVisible(b)
a.pageObj:SetChildrenVisible(b)
end
GetTabID=function(a)return a.ID end
GetUrl=function(a)return a.url end
SetUrl=function(a,b)a.url=b end
GetHeaderObj=function(a)return a.headerObj end
GetPageObj=function(a)return a.pageObj end
SetState=function(a,b)a.headerObj:SetState(b) end
GetState=function(a)return a.headerObj:GetState() end
SetTitle=function(a,b)a.headerObj:SetTitle(b) end
GetTitle=function(a)return a.headerObj:GetTitle() end
SetHeaderZOrder=function(a,b)a.headerObj:SetZorder(b) end
CanGoBack=function(a)return a.pageObj:CanGoBack() end
CanGoForward=function(a)return a.pageObj:CanGoForward() end
GetType=function(a)return a.type end
SetUIObject=function(a,b,c,d,e,f)
a.uiObject=b
a.pageObj:SetUIObject(b,c,d,e,f)
end
GetUIObject=function(a)return a.uiObject end
IsMainTab=function(a)
if a.TabBusinessAttr ~= nil and a.TabBusinessAttr.bMainTab then
return true
end
return false
end
GetPageUrl=function()return "" end
SetContext=function(a,b)a.context=b end