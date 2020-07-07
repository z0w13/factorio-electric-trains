local locomotive = util.table.deepcopy(data.raw.locomotive["locomotive"])
locomotive.name = "electric-locomotive"
locomotive.minable.result = "electric-locomotive"
locomotive.weight = 1200
locomotive.max_speed = 1.5
locomotive.max_power = "1MW"
locomotive.reversing_power_modifier = 1.0
locomotive.burner.fuel_category = "electrical"
locomotive.burner.fuel_inventory_size = 1
locomotive.burner.burnt_inventory_size = 1
locomotive.burner.smoke = nil
locomotive.color = {r = 0, g = 0.33, b = 0.92, a = 0.5}
locomotive.stop_trigger = 
{
  {
    type = "play-sound",
    sound =
    {
      {
        filename = "__base__/sound/train-breaks.ogg",
        volume = 0.3
      }
    }
  }
}

local batteryChargingStation = util.table.deepcopy(data.raw["accumulator"]["accumulator"])
batteryChargingStation.type = "assembling-machine"
batteryChargingStation.name = "battery-charging-station"
batteryChargingStation.minable.result = "battery-charging-station"
batteryChargingStation.energy_source = {
  type = "electric",
  buffer_capacity = "20MJ",
  usage_priority = "primary-input",
  input_flow_limit = "10MW",
  output_flow_limit = "0kW",
  drain = "500W"
}
batteryChargingStation.animation = accumulator_picture()
batteryChargingStation.working_visualisations = accumulator_charge()
batteryChargingStation.working_visualisations.light = batteryChargingStation.charge_light
batteryChargingStation.crafting_categories = {"electrical"}
batteryChargingStation.crafting_speed = 1
batteryChargingStation.energy_source = {
  type = "electric",
  usage_priority = "secondary-input",
  drain = "3kW"
}
batteryChargingStation.next_upgrade = nil
batteryChargingStation.energy_usage = "10MW"
batteryChargingStation.fixed_recipe = "battery-pack-recharge"
batteryChargingStation.show_recipe_icon = false

function setup_electric_stop(entity)
  data:extend(
  {
    locomotive,
    entity,
    
    {
      type = "electric-energy-interface",
      name = "charging-station",
      icons = {
        {icon = "__ElectricTrains__/graphics/icons/train-stop.png"},
        {icon = "__ElectricTrains__/graphics/icons/lightning-bolt.png", icon_size = 32, scale = 0.5, shift = {-12, 12}}
      },
      icon_size = 64, icon_mipmaps = 4,
      flags = {"placeable-neutral", "player-creation", "not-blueprintable"},
      corpse = "small-remnants",
      -- selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      energy_source =
      {
        type = "electric",
        buffer_capacity = "25MJ",
        usage_priority = "primary-input",
        input_flow_limit = "25MW",
        output_flow_limit = "0kW",
        drain = "500W"
      },
      charge_cooldown = 45,
      discharge_cooldown = 30,
    },
    
    batteryChargingStation
  })
end


local electricTrainStop = util.table.deepcopy(data.raw["train-stop"]["train-stop"])
electricTrainStop.name = "electric-train-stop"
electricTrainStop.color = {r = 0, g = 0.33, b = 0.92, a = 0.5}
electricTrainStop.minable.result = "electric-train-stop"
setup_electric_stop(electricTrainStop)

if data.raw["train-stop"]["logistic-train-stop"] ~= nil then
  local electricLogisticTrainStop = util.table.deepcopy(data.raw["train-stop"]["logistic-train-stop"])
  electricLogisticTrainStop.name = "electric-logistic-train-stop"
  electricLogisticTrainStop.color = {r = 0, g = 0.33, b = 0.92, a = 0.5}
  electricLogisticTrainStop.minable.result = "electric-logistic-train-stop"
  setup_electric_stop(electricLogisticTrainStop)
end