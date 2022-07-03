
cmdline = app:info('cmdline')
apppath = app:info('path')
fixscreen_opt = ''
if string.find(cmdline, '-fixscreen') then fixscreen_opt = '-fixscreen' end

RESTORE_TIMER_ID = 1000
AUTO_RESTORE_SEC = 15
display_restore_counter = AUTO_RESTORE_SEC

dpi_list = {["100"] = 0, ["125"] = 1, ["150"] = 2, ["175"] = 3, ["200"] = 4}

-- Timer
SET_BRIGHTNESS_TIMER_ID = 1010

local function set_switch_with_text(elem, val, text_only)
  if text_only ~= true then elem.selected = val end
  if val == 0 then elem.text = "%{Off}" else elem.text = "%{On}" end
end

local function click_tab(name)
  sui:click(name)
end

local function init_display_settings()
  dpi_combo = sui:find('dpi_combo')
  resolution_combo = sui:find('resolution_combo')
  rotate_combo = sui:find('rotate_combo')
  display_applybtn = sui:find('display_applybtn')
  display_restorebtn = sui:find('display_restorebtn')
  org_display_restorebtn_text = display_restorebtn.text -- save origin retore button text for retore timer

  click_tab('Nav_Display') -- be visible for changing combobox index

  last_dpi = 0
  local cdpi = app:call('screen::get', 'dpi')
  local dpi_index = dpi_list['' .. cdpi]
  if dpi_index ~= nil then
    dpi_combo.index = dpi_index
  else
    if cdpi > 100 then
      dpi_index = (cdpi - 100) // 25
    end
  end
  last_dpi = dpi_index
  resolution_combo.list = suilib.call('GetResolutionList')
  resolution_combo.index = suilib.call('GetCurrentResolution')

  rotate_combo.index = suilib.call('GetRotation')

  last_resolution = resolution_combo.text
  last_rotate = rotate_combo.index

  brightness_slider = sui:find('brightness_slider')
  brightness_val = Screen:Get('brightness')
  brightness_slider.value = brightness_val
end

local function init_colors_settings()
  local ct_name = 'dark'
  if System:GetSetting('SysColorTheme') == 1 then ct_name = 'light' end
  local opt = sui:find('syscolortheme_' .. ct_name .. '_opt')
  opt.selected = 1

  ct_name = 'dark'
  if System:GetSetting('AppsColorTheme') == 1 then ct_name = 'light' end
  opt = sui:find('appscolortheme_' .. ct_name .. '_opt')
  opt.selected = 1

  elem_colors_transparency = sui:find('chk_colors_transparency')
  local onoff = System:GetSetting('Colors.Transparency')
  set_switch_with_text(elem_colors_transparency, onoff)

  elem_chk_apply_ac_shell = sui:find('chk_apply_ac_shell')
  if System:GetSetting('ShellColorPrevalence') == 1 then
    elem_chk_apply_ac_shell.selected = 1
  end
  elem_chk_apply_ac_window = sui:find('chk_apply_ac_window')
  if System:GetSetting('WindowColorPrevalence') == 1 then
    elem_chk_apply_ac_window.selected = 1
  end
end

local function init_folderoptions_settings()
  elm_folderopt_showall = sui:find('chk_folderopt_showall')
  elm_folderopt_showext = sui:find('chk_folderopt_showext')
  elm_folderopt_showsuperhidden = sui:find('chk_folderopt_showsuperhidden')

  local onoff = FolderOptions:Get('ShowAll')
  set_switch_with_text(elm_folderopt_showall, onoff)

  onoff = FolderOptions:Get('ShowExt') + 1  -- trick: -1(true), 0(false) => 0(false), 1(true)
  set_switch_with_text(elm_folderopt_showext, onoff)

  onoff = FolderOptions:Get('ShowSuperHidden') + 1
  set_switch_with_text(elm_folderopt_showsuperhidden, onoff)
end

local function init_taskbar_settings()
  elm_taskbar_autohide = sui:find('chk_taskbar_autohide')
  elm_taskbar_smallicons = sui:find('chk_taskbar_smallicons')

  local onoff = Taskbar:GetSetting('AutoHide')
  set_switch_with_text(elm_taskbar_autohide, onoff)

  onoff = (Taskbar:GetSetting('TaskbarSmallIcons') or 0) | 0 -- to integer
  set_switch_with_text(elm_taskbar_smallicons, onoff)

  local glomlevel = (Taskbar:GetSetting('TaskbarGlomLevel') or 2) | 0
  local elm_combline_style_opt = sui:find('combine_style_' .. glomlevel)
  elm_combline_style_opt.selected = 1
end

local function init_settings()
  init_display_settings()
  init_colors_settings()
  init_folderoptions_settings()
  init_taskbar_settings()
end

local function display_applybtn_click()
    suilib.call('KillTimer', RESTORE_TIMER_ID)

    last_resolution = resolution_combo.text
    last_rotate = rotate_combo.index

    resolution_combo.mouse = 'true'
    rotate_combo.mouse =  'true'
    display_applybtn.visible = 0
    display_restorebtn.visible = 0
end

local function switch_tab(name)
  local map = {
    'display',
    'background',
    'colors',
    'folderoptions',
    'taskbar'
  }
  local tab = #map
  for i = 1, #map do
    if map[i] == name then tab = i; break end
  end

  if UI_Inited == 1 then
    if display_applybtn.visible == 1 then
      display_applybtn_click()
    end
  end
  tab_layout.selectedid = tab
end

function onload()
  UI_Inited = 0

  -- TODO: more simple way for resource string
  for i = 1, 6 do
    sui:find('#res_' .. i).text = sui:find('#res_' .. i).text  -- expand resource string
  end

  sui:find('compmgmt_button').text = sui:find('compmgmt_button').text
  sui:find('syscolortheme_light_opt').text = sui:find('syscolortheme_light_opt').text
  sui:find('syscolortheme_dark_opt').text = sui:find('syscolortheme_dark_opt').text
  tab_layout = sui:find('TabLayoutMain')
  init_settings()
  if string.find(cmdline, '-display') then
    click_tab('Nav_Display')
  elseif string.find(cmdline, '-colors') then
    click_tab('Nav_Colors')
  else
    click_tab('Nav_Taskbar')
  end
  UI_Inited = 1
end

local function fixscreen()
    if fixscreen_opt ~= '' then
        app:call('Desktop::UpdateWallpaper')
        app:call('sleep', 200)
        app:call('Taskbar::ChangeNotify')
    end
end

local function display_restorebtn_click()
    suilib.call('KillTimer', RESTORE_TIMER_ID)
    suilib.call('SetResolution', last_resolution)
    suilib.call('SetRotation', last_rotate)
    fixscreen()
    resolution_combo.index = last_resolution
    rotate_combo.index = last_rotate

    resolution_combo.mouse = 'true'
    rotate_combo.mouse =  'true'
    display_applybtn.visible = 0
    display_restorebtn.visible = 0
end

local function nav_click(ctrl)
  local handled = true
  if ctrl == 'Nav_Display' then
    switch_tab('display')
  elseif ctrl == 'Nav_Background' then
    switch_tab('background')
  elseif ctrl == 'Nav_Colors' then
    switch_tab('colors')
  elseif ctrl == 'Nav_FolderOptions' then
    switch_tab('folderoptions')
  elseif ctrl == 'Nav_Taskbar' then
    switch_tab('taskbar')
  else
    handled = false
  end
  return handled
end

local function combine_style_click(ctrl)
  local handled = true
  if ctrl == 'combine_style_0' then
    Taskbar:CombineButtons('always')
  elseif ctrl == 'combine_style_1' then
    Taskbar:CombineButtons('auto')
  elseif ctrl == 'combine_style_2' then
    Taskbar:CombineButtons('never')
  else
    handled = false
  end
  return handled
end

local function nav_button_click(ctrl)
  local handled = true
  if ctrl == 'home_button' then
    wxs_open('controlpanel')
  elseif ctrl == 'compmgmt_button' then
    app:run('compmgmt.msc')
  else
    handled = false
  end
  return handled
end

local function restart()
  --app:run(apppath .. '\\WinXShell.exe', '-luacode \"wxsUI(\'UI_Settings\', nil, \'-colors ' .. fixscreen_opt .. '\')\"')
  --app:run(apppath .. '\\WinXShell.exe', [[-console -luacode "wxsUI('UI_Settings','main.jcfg','-colors ]] .. fixscreen_opt .. [[')"]], 0) -- SW_HIDE
  wxsUI('UI_Settings','main.jcfg','-colors ' .. fixscreen_opt)
  suilib.close()
end

function onclick(ctrl)
  local val = 0
  -- app:print('onclick:' .. ctrl)
  if nav_click(ctrl) then return end
  if combine_style_click(ctrl) then return end
  if nav_button_click(ctrl) then return end

  if ctrl == 'syscolortheme_light_opt' then
    System:SysColorTheme('light')
  elseif ctrl == 'syscolortheme_dark_opt' then
    System:SysColorTheme('dark')
  elseif ctrl == 'appscolortheme_light_opt' then
    System:AppsColorTheme('light')
    restart()
  elseif ctrl == 'appscolortheme_dark_opt' then
    System:AppsColorTheme('dark')
    restart()
  elseif ctrl == 'chk_apply_ac_shell' then
    val = elem_chk_apply_ac_shell.selected
    System:SetSetting('ShellColorPrevalence' ,val - 1)
  elseif ctrl == 'chk_apply_ac_window' then
    val = elem_chk_apply_ac_window.selected
    System:SetSetting('WindowColorPrevalence' ,val - 1)
  elseif ctrl == 'display_applybtn' then
      display_applybtn_click()
  elseif ctrl == 'display_restorebtn' then
    display_restorebtn_click()
  end
end

function onchanged(ctrl, ctrl_val)
  local val = 0
  if UI_Inited == 0 then return end -- do nothing for init changing

  if ctrl == "resolution_combo" or ctrl == "rotate_combo" then
    if last_resolution ~= resolution_combo.text then val = 1 end
    if last_rotate ~= rotate_combo.index then val = 1 end
    if val == 0 then return end -- no change or restore

    suilib.call('SetResolution', resolution_combo.text)
    suilib.call('SetRotation', rotate_combo.index)
    fixscreen()
    -- set auto restore timer
    display_restore_counter = AUTO_RESTORE_SEC

    resolution_combo.mouse = 'false'
    rotate_combo.mouse =  'false'
    display_applybtn.visible = 1
    display_restorebtn.visible = 1

    display_restorebtn.text = string.format('[%d]%s', display_restore_counter, org_display_restorebtn_text)
    suilib.call('SetTimer', RESTORE_TIMER_ID, 1000)
    return
  elseif ctrl == "dpi_combo" then
    local dpi_combo_index = dpi_combo.index
    app:call('screen::set', 'dpi', (dpi_combo_index * 25) + 100) -- TODO: custom dpi
    return
  elseif ctrl == "brightness_slider" then
    app:print(ctrl .. ':' .. ctrl_val)
    brightness_val = ctrl_val
    suilib.call('KillTimer', SET_BRIGHTNESS_TIMER_ID)
    suilib.call('SetTimer', SET_BRIGHTNESS_TIMER_ID, 200)
    return
  end

  if ctrl == 'chk_colors_transparency' then
    val = elem_colors_transparency.selected
    set_switch_with_text(elem_colors_transparency, val, true)
    System:SetSetting('Colors.Transparency', val)
  elseif ctrl == 'chk_folderopt_showall' then
    val = elm_folderopt_showall.selected
    set_switch_with_text(elm_folderopt_showall, val, true)
    FolderOptions:Set('ShowAll', val)
  elseif ctrl == 'chk_folderopt_showext' then
    val = elm_folderopt_showext.selected
    set_switch_with_text(elm_folderopt_showext, val, true)
    FolderOptions:Set('ShowExt', val - 1)
  elseif ctrl == 'chk_folderopt_showsuperhidden' then
    val = elm_folderopt_showsuperhidden.selected
    set_switch_with_text(elm_folderopt_showsuperhidden, val, true)
    FolderOptions:Set('ShowSuperHidden', val - 1)
  elseif ctrl == 'chk_taskbar_autohide' then
    val = elm_taskbar_autohide.selected
    set_switch_with_text(elm_taskbar_autohide, val, true)
    Taskbar:AutoHide(val)
  elseif ctrl == 'chk_taskbar_smallicons' then
    val = elm_taskbar_smallicons.selected
    set_switch_with_text(elm_taskbar_smallicons, val, true)
    Taskbar:UseSmallIcons(val)
  end
end

function ontimer(id)
    suilib.print('ontimer:' .. id)
    if (id == RESTORE_TIMER_ID) then
      display_restore_counter = display_restore_counter - 1
      display_restorebtn.text = string.format('[%d]%s', display_restore_counter, org_display_restorebtn_text)
      -- auto restore
      if (display_restore_counter <= 0) then
          display_restorebtn_click()
      end
    elseif (id == SET_BRIGHTNESS_TIMER_ID) then
      suilib.call('KillTimer', SET_BRIGHTNESS_TIMER_ID)
      local val = math.floor(brightness_val / 10 + 0.5) * 10;
      Screen:Set('brightness', val)
    end
end
