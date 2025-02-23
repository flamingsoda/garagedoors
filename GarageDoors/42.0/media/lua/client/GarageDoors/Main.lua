local CacheObjectContext = {}
local GarageDoors = {}

GarageDoors.availableMaterialsList = {}
GarageDoors.neededMaterials = {}
GarageDoors.neededTools = {}
GarageDoors.toolsList = {}
GarageDoors.toolsText = {}
GarageDoors.playerMetalWorkingSkill = 0
GarageDoors.playerCanPlaster = false
GarageDoors.textTooltipHeader = ' <RGB:2,2,2> <LINE> <LINE>' .. getText('Tooltip_craft_Needs') .. ' : <LINE> '
GarageDoors.textMetalWorkingRed = ''
GarageDoors.textMetalWorkingGreen = ''
GarageDoors.textCanRotate = '<LINE> <RGB:1,1,1>' .. getText('Tooltip_craft_pressToRotate', Keyboard.getKeyName(getCore():getKey('Rotate building')))
GarageDoors.textDoorFrameDescription = getText('Tooltip_DoorFrame_Description')

GarageDoors.skillLevel = {
  simpleObject = 1,
  doorObject = 3,
  garageDoorObject = 6,
  none = 0
}

GarageDoors.getMoveableDisplayName = function(sprite)
  local props = getSprite(sprite):getProperties()
  local getMoveableDisplayName = Translator.getMoveableDisplayName
  if props:Is('CustomName') then
    local name = props:Val('CustomName')
    if props:Is('GroupName') then
      name = props:Val('GroupName') .. ' ' .. name
    end
    return getMoveableDisplayName(name)
  end
  return false
end

GarageDoors.doBuildMenu = function(player, context, worldobjects, test)
  if getCore():getGameMode() == 'LastStand' then
    return
  end

  if test and ISWorldObjectContextMenu.Test then
    return true
  end

  local playerObj = getSpecificPlayer(player)
  print(playerObj)
  if playerObj:getVehicle() then
    return
  end

  if GarageDoors.haveAToolToBuildWithWith(player) then
    GarageDoors.playerMetalWorkingSkill = getSpecificPlayer(player):getPerkLevel(Perks.MetalWelding)

    if GarageDoors.playerMetalWorkingSkill > 7 or ISBuildMenu.cheat then
      GarageDoors.playerCanPlaster = true
    else
      GarageDoors.playerCanPlaster = false
    end

    GarageDoors.textMetalWorkingRed = ' <RGB:1,0,0>' .. getText('MetalWorking') .. ' ' .. GarageDoors.playerMetalWorkingSkill .. '/'
    GarageDoors.textMetalWorkingGreen = ' <RGB:1,1,1>' .. getText('MetalWorking') .. ' '
    GarageDoors.buildMaterialsList(player)

    local _firstTierMenu = context:addOption(getText('ContextMenu_GarageDoors'), worldobjects, nil)
    local _secondTierMenu = ISContextMenu:getNew(context)
    context:addSubMenu(_firstTierMenu, _secondTierMenu)
	GarageDoors.garageDoorMenuBuilder3x3(_secondTierMenu, player, context, worldobjects)
	GarageDoors.garageDoorMenuBuilder4x4(_secondTierMenu, player, context, worldobjects)
  end
end

GarageDoors.haveAToolToBuildWithWith = function(player)
  local _inventory = getSpecificPlayer(player):getInventory()
  GarageDoors.toolsList = {}
	GarageDoors.toolsList['Hammer'] = _inventory:contains('Hammer')
  GarageDoors.toolsList['Screwdriver'] = _inventory:contains('Screwdriver')
  GarageDoors.toolsList['HandShovel'] = _inventory:contains('HandShovel')
  GarageDoors.toolsList['Saw'] = _inventory:contains('Saw')
  GarageDoors.toolsList['Spade'] = _inventory:contains('Shovel')

  GarageDoors.toolsText['Hammer'] = getItemNameFromFullType('Base.Hammer')
  GarageDoors.toolsText['Screwdriver'] = getItemNameFromFullType('Base.Screwdriver')
  GarageDoors.toolsText['HandShovel'] = getItemNameFromFullType('farming.HandShovel')
  GarageDoors.toolsText['Saw'] = getItemNameFromFullType('base.Saw')
  GarageDoors.toolsText['Spade'] = getItemNameFromFullType('Base.Shovel')

  return GarageDoors.toolsList['Hammer']
end

local function predicateNotBroken(item)
	return not item:isBroken()
end

GarageDoors.equipToolPrimary = function(object, player, tool)
  local tool = nil
  if GarageDoors.toolsList[tool] then
    tool = getSpecificPlayer(player):getInventory():getFirstTagEvalRecurse(tool, predicateNotBroken)
    if not tool then error("invalid tool!") return end
    ISInventoryPaneContextMenu.equipWeapon(tool, true, false, player)

    object.noNeedHammer = true
  end
end

GarageDoors.equipToolSecondary = function(object, player, tool)
  local tool = nil
  if GarageDoors.toolsList[tool] then
    tool = getSpecificPlayer(player):getInventory():getFirstTagEvalRecurse(tool, predicateNotBroken)
    if not tool then error("invalid tool!") return end
    ISInventoryPaneContextMenu.equipWeapon(tool, false, false, player)
  end
end

GarageDoors.buildMaterialsList = function(player)
  GarageDoors.availableMaterialsList = buildUtil.checkMaterialOnGround(getSpecificPlayer(player):getCurrentSquare())

  local _inventoryList = getSpecificPlayer(player):getInventory():getItems()
  local _size = _inventoryList:size()
  local _currentItemType = ''

  for i = 0, _size - 1 do
    _currentItemType = _inventoryList:get(i):getType()

    if GarageDoors.availableMaterialsList[_currentItemType] then
      GarageDoors.availableMaterialsList[_currentItemType] = GarageDoors.availableMaterialsList[_currentItemType] + 1
    else
      GarageDoors.availableMaterialsList[_currentItemType] = 1
    end
  end
end

GarageDoors.tooltipCheckForMaterial = function(material, amount, text, tooltip)
  if amount > 0 then
    local _thisItemCount = 0

    if GarageDoors.availableMaterialsList[material] then
      _thisItemCount = GarageDoors.availableMaterialsList[material]
    else
      _thisItemCount = 0
    end

    if _thisItemCount < amount then
      tooltip.description = tooltip.description .. ' <RGB:1,0,0>' .. text .. ' ' .. _thisItemCount .. '/' .. amount .. ' <LINE>'
      return false
    else
      tooltip.description = tooltip.description .. ' <RGB:1,1,1>' .. text .. ' ' .. amount .. ' <LINE>'
      return true
    end
  end
  return true
end

GarageDoors.tooltipCheckForTool = function(tool, tooltip)
  if GarageDoors.toolsList and GarageDoors.toolsList[tool] then
    tooltip.description = tooltip.description .. ' <RGB:1,1,1>' .. GarageDoors.toolsText[tool] .. ' <LINE>'
    return true
  else
    tooltip.description = tooltip.description .. ' <RGB:1,0,0>' .. GarageDoors.toolsText[tool] .. ' <LINE>'
    return false
  end
end

GarageDoors.canBuildObject = function(metalworking, option, player)
  local _tooltip = ISToolTip:new()
  _tooltip:initialise()
  _tooltip:setVisible(false)
  option.toolTip = _tooltip

  local _canBuildResult = true

  _tooltip.description = GarageDoors.textTooltipHeader

  local _currentResult = true

  for _, _currentMaterial in pairs(GarageDoors.neededMaterials) do
    if _currentMaterial['Material'] and _currentMaterial['Amount'] and _currentMaterial['Text'] then
      _currentResult = GarageDoors.tooltipCheckForMaterial(_currentMaterial['Material'], _currentMaterial['Amount'], _currentMaterial['Text'], _tooltip)
    else
      _tooltip.description = _tooltip.description .. ' <RGB:1,0,0> Error in required material definition. <LINE>'
      _canBuildResult = false
    end

    if not _currentResult then
      _canBuildResult = false
    end
  end

  for _, _currentTool in pairs(GarageDoors.neededTools) do
    _currentResult = GarageDoors.tooltipCheckForTool(_currentTool, _tooltip)

    if not _currentResult then
      _canBuildResult = false
    end
  end

  if metalworking > 0 then
    if GarageDoors.playerMetalWorkingSkill < metalworking then
      _tooltip.description = _tooltip.description .. GarageDoors.textMetalWorkingRed
      _canBuildResult = false
    else
      _tooltip.description = _tooltip.description .. GarageDoors.textMetalWorkingGreen
    end

    _tooltip.description = _tooltip.description .. metalworking .. ' <LINE>'
  end

  if not _canBuildResult and not ISBuildMenu.cheat then
    option.onSelect = nil
    option.notAvailable = true
  end
  return _tooltip
end

function getGarageDoorsInstance()
  return GarageDoors
end

Events.OnFillWorldObjectContextMenu.Add(GarageDoors.doBuildMenu)