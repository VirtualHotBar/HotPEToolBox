local localeid = nil
function onload()
  localeid = reg_read([[HKEY_USERS\.DEFAULT\Control Panel\International]], 'Locale')
  if localeid == nil then return end
  app:print('LCID' .. localeid)
  localeid = string.sub(localeid, -4, -1)
  --:: Update registry keyboard layouts in HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinPE\KeyboardLayouts
  suilib.call('run', 'Wpeutil.exe', 'ListKeyboardLayouts 0x' .. localeid)
end

function onclick(ctrl)
  suilib.call('run', 'Wpeutil.exe', string.format('SetKeyboardLayout 0x%s:%s', localeid, ctrl))
  sui:hide()
  suilib.call('sleep', 3000) -- ?
  sui:close()
end
