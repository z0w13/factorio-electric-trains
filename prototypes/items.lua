data:extend(
{
  {
    type = "item-with-entity-data",
    name = "electric-locomotive",
    icon = "__ElectricTrains__/graphics/icons/electric-locomotive.png",
    icon_size = 32,
    subgroup = "transport",
    order = "a[train-system]-g[electric-locomotive]",
    place_result = "electric-locomotive",
    stack_size = 5
  },
  
  {
    type = "item",
    name = "electric-train-stop",
    icon = "__ElectricTrains__/graphics/icons/train-stop.png",
    icon_size = 64, icon_mipmaps = 4,
    subgroup = "transport",
    order = "a[train-system]-c[train-stop]-a",
    place_result = "electric-train-stop",
    stack_size = 10
  },
  {
    type = "item",
    name = "battery-charging-station",
    icon = "__base__/graphics/icons/accumulator.png",
    icon_size = 64, icon_mipmaps = 4,
    subgroup = "production-machine",
    order = "h[train-system]",
    place_result = "battery-charging-station",
    stack_size = 10
  },
  
  {
    type = "item",
    name = "battery-pack",
    icon = "__base__/graphics/technology/battery.png",
    icon_size = 128,
    fuel_category = "electrical",
    fuel_value = "100MJ",
    burnt_result = "discharged-battery-pack",
    subgroup = "intermediate-product",
    order = "s-a[battery-pack]",
    stack_size = 10
  },
  
  {
    type = "item",
    name = "discharged-battery-pack",
    icon = "__ElectricTrains__/graphics/icons/discharged-battery.png",
    icon_size = 128,
    subgroup = "intermediate-product",
    order = "s-b[discharged-battery-pack]",
    stack_size = 10
  },
  
  {
    type = "item",
    name = "electric-locomotive-fuel-dummy",
    icon = "__base__/graphics/icons/accumulator.png",
    icons = {
      {icon = "__ElectricTrains__/graphics/icons/electric-locomotive.png", icon_size = 32},
      {icon = "__ElectricTrains__/graphics/icons/lightning-bolt.png", icon_size = 32, scale = 0.5, shift = {12, 12}}
    },
    fuel_category = "electrical",
    fuel_value = "250MJ",
    subgroup = "raw-material",
    order = "h[battery]",
    stack_size = 1
  },
  
  { -- defined to stop Factorio complaining about not having an item to place for the proper charging station
    type = "item",
    name = "charging-station",
    icon = "__base__/graphics/icons/train-stop.png",
    icon_size = 32,
    subgroup = "transport",
    order = "a[train-system]-c[train-stop]-a",
    place_result = "charging-station",
    stack_size = 10
  }
})

if data.raw["train-stop"]["logistic-train-stop"] ~= nil then
  data:extend({
    {
      type = "item",
      name = "electric-logistic-train-stop",
      icon = "__ElectricTrains__/graphics/icons/train-stop.png",
      icon_size = 64, icon_mipmaps = 4,
      subgroup = "transport",
      order = "a[train-system]-c[logistic-train-stop]-a",
      place_result = "electric-logistic-train-stop",
      stack_size = 10
    }
  })
end