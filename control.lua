-- For debugging purposes
--
function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

function debugLog(message)
  game.print(message)
end
--]]

--[[ global table data structure
global.
  stations
  ... -- unit # as key
    {station entity, charging station entity}
  
  chargingTrains
  ... trainID as key
    {train entity, charging station entity, {list of locomotive entities}, currently charging locomotive}
--]]

remote.add_interface("electrictrains", {
  status = function()
    debugLog("Global station list: " .. table.tostring(global.stations))
    debugLog("Charging trains: " .. table.tostring(global.chargingTrains))
  end
})

local waitStation = defines.train_state.wait_station
local maxFuelValue = 250000000 -- Maximum fuel value of the electric locomotive when not consuming battery power.
local maxChargingRate = 25000000 * 23 / 60 -- Power transferred per second (energy is transferred every 23 ticks) by the control script.

script.on_init(function()
  global.stations = {}
  global.chargingTrains = {}
end)

script.on_load(function()
  if next(global.chargingTrains) ~= nil then
    script.on_nth_tick(23, tick)
  end
end)

function entity_built(event)
  if event.created_entity.name == "electric-train-stop" then
    local position = event.created_entity.position
    local force = event.created_entity.force
    local surface = event.created_entity.surface.index
    
    local charger = game.surfaces[surface].create_entity{name = "charging-station", position = position, force = force}
    global.stations[event.created_entity.unit_number] = {event.created_entity, charger}
  elseif event.created_entity.name == "electric-locomotive" then
    event.created_entity.burner.currently_burning = "electric-locomotive-fuel-dummy"
    event.created_entity.burner.remaining_burning_fuel = 100000
  end
end

script.on_event(defines.events.on_built_entity, entity_built)
script.on_event(defines.events.on_robot_built_entity, entity_built)

function entity_removed(event)
  if event.entity.name == "electric-train-stop" then
    global.stations[event.entity.unit_number][2].destroy()
    global.stations[event.entity.unit_number] = nil
    
    for i,v in pairs(global.chargingTrains) do
      if not v[2].valid then
        global.chargingTrains[i] = nil
      end
    end
  end
end

script.on_event(defines.events.on_player_mined_entity, entity_removed)
script.on_event(defines.events.on_robot_mined_entity, entity_removed)
script.on_event(defines.events.on_entity_died, entity_removed)

function train_changed_state(event)
  if event.train.state == waitStation and event.train.station.name == "electric-train-stop" then
    local locomotives = find_electric_locomotives(event.train)
    
    if #locomotives ~= nil then
      set_train_charging(event.train, event.train.station.unit_number, locomotives)
    end
  end
end

script.on_event(defines.events.on_train_changed_state, train_changed_state)

function find_electric_locomotives(luaTrain)
  local electricLocomotives = {}
  
  for i,v in pairs(luaTrain.locomotives) do
    for j,u in pairs(v) do
      if u.name == "electric-locomotive" then
        table.insert(electricLocomotives, u)
      end
    end
  end
  
  return electricLocomotives
end

function set_train_charging(trainEntity, stationIndex, locomotives)
  global.chargingTrains[trainEntity.id] = {trainEntity, global.stations[stationIndex][2], locomotives}
  activateTicker()
end

function activateTicker()
  if next(global.chargingTrains) ~= nil then
    script.on_nth_tick(23, tick)
  end
end

function tick()
  local currentFuelValue
  local chargeTransferValue
  
  for i,v in pairs(global.chargingTrains) do
    if not v[1].valid or v[1].state ~= waitStation or next(v[3]) == nil then
      global.chargingTrains[i] = nil
    else
      if v[4] == nil then
        v[4] = v[3][1]
        if v[4].burner.currently_burning ~= nil and v[4].burner.currently_burning.name ~= "electric-locomotive-fuel-dummy" then
          local burnt_result = game.item_prototypes[v[4].burner.currently_burning.name].burnt_result
          if burnt_result ~= nil then
            v[4].burner.burnt_result_inventory.insert({name = burnt_result.name})
          end
        end
        v[4].burner.currently_burning = "electric-locomotive-fuel-dummy" -- Set the 'currently burning' item to scale the locomotive's remaining fuel bar properly.
      end
      
      currentFuelValue = v[4].burner.remaining_burning_fuel
      
      if v[2] ~= nil and v[2].valid and currentFuelValue < maxFuelValue then
        chargeTransferValue = math.min(maxFuelValue - currentFuelValue, v[2].energy, maxChargingRate)
        v[2].energy = v[2].energy - chargeTransferValue
        v[4].burner.remaining_burning_fuel = currentFuelValue + chargeTransferValue
      else
        v[4] = nil
        table.remove(v[3],1)
      end
    end
  end
  
  if next(global.chargingTrains) == nil then
    script.on_nth_tick(nil)
  end
end
