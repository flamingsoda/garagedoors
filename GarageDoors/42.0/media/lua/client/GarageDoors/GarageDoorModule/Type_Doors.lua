if not getGarageDoorsInstance then
  require('GarageDoors/Main')
end

local GarageDoors = getGarageDoorsInstance()

GarageDoors.garageDoorMenuBuilder3x3 = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  GarageDoors.neededMaterials = {
    {
      Material = 'Plank',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Plank')
    },
    {
      Material = 'Nails',
      Amount = 8,
      Text = getItemNameFromFullType('Base.Nails')
    },
    {
      Material = 'Doorknob',
      Amount = 2,
      Text = getItemNameFromFullType('Base.Doorknob')
    },
    {
      Material = 'Hinge',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Hinge')
    },
    {
      Material = 'Screws',
      Amount = 8,
      Text = getItemNameFromFullType('Base.Screws')
    },
	{
      Material = 'ScrapMetal',
      Amount = 10,
      Text = getItemNameFromFullType('Base.ScrapMetal')
    },
    {
      Material = 'SmallSheetMetal',
      Amount = 4,
      Text = getItemNameFromFullType('Base.SmallSheetMetal')
    }
  }

  GarageDoors.neededTools = {'Hammer', 'Screwdriver', 'Saw'}

  _sprite = {}
  _sprite.sprite = 'walls_garage_02_'

  _name = getText 'ContextMenu_Small_Rolling_Garage_Door'

  _option = subMenu:addOption(_name, nil, GarageDoors.onBuildGarageDoor3x3, _sprite, 0, player)
  _tooltip = GarageDoors.canBuildObject(GarageDoors.skillLevel.garageDoorObject, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Small_Rolling_Garage_Door' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite .. 1)

end

GarageDoors.garageDoorMenuBuilder4x4 = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  GarageDoors.neededMaterials = {
    {
      Material = 'Plank',
      Amount = 8,
      Text = getItemNameFromFullType('Base.Plank')
    },
    {
      Material = 'Nails',
      Amount = 16,
      Text = getItemNameFromFullType('Base.Nails')
    },
    {
      Material = 'Doorknob',
      Amount = 2,
      Text = getItemNameFromFullType('Base.Doorknob')
    },
    {
      Material = 'Hinge',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Hinge')
    },
    {
      Material = 'Screws',
      Amount = 16,
      Text = getItemNameFromFullType('Base.Screws')
    },
    {
      Material = 'ScrapMetal',
      Amount = 20,
      Text = getItemNameFromFullType('Base.ScrapMetal')
    },	
    {
      Material = 'SmallSheetMetal',
      Amount = 8,
      Text = getItemNameFromFullType('Base.SmallSheetMetal')
    }
  }

  GarageDoors.neededTools = {'Hammer', 'Screwdriver', 'Saw'}

  _sprite = {}
  _sprite.sprite = 'walls_garage_02_'

  _name = getText 'ContextMenu_Large_Rolling_Garage_Door'

  _option = subMenu:addOption(_name, nil, GarageDoors.onBuildGarageDoor4x4, _sprite, 0, player)
  _tooltip = GarageDoors.canBuildObject(GarageDoors.skillLevel.garageDoorObject, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Large_Rolling_Garage_Door' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite .. 1)

end

GarageDoors.onBuildGarageDoor3x3 = function(whoActuallyCares, sprite, spriteIndex, player)
  local _garageDoor = ISGarageDoor:new1(sprite.sprite, spriteIndex)

  _garageDoor.player = player

  _garageDoor.modData['need:Base.Plank'] = '4'
  _garageDoor.modData['need:Base.Nails'] = '8'
  _garageDoor.modData['need:Base.Doorknob'] = '2'
  _garageDoor.modData['need:Base.Hinge'] = '4'
  _garageDoor.modData['need:Base.Screws'] = '8'
  _garageDoor.modData['need:Base.ScrapMetal'] = '10'
  _garageDoor.modData['need:Base.SmallSheetMetal'] = '4'
  _garageDoor.modData['xp:MetalWelding'] = '15'

  getCell():setDrag(_garageDoor, player)
end

GarageDoors.onBuildGarageDoor4x4 = function(whoActuallyCares, sprite, spriteIndex, player)
  local _garageDoor = ISBigGarageDoor:new2(sprite.sprite, spriteIndex)

  _garageDoor.player = player

  _garageDoor.modData['need:Base.Plank'] = '8'
  _garageDoor.modData['need:Base.Nails'] = '16'
  _garageDoor.modData['need:Base.Doorknob'] = '2'
  _garageDoor.modData['need:Base.Hinge'] = '4'
  _garageDoor.modData['need:Base.Screws'] = '16'
  _garageDoor.modData['need:Base.ScrapMetal'] = '20'
  _garageDoor.modData['need:Base.SmallSheetMetal'] = '8'
  _garageDoor.modData['xp:MetalWelding'] = '15'

  getCell():setDrag(_garageDoor, player)
end