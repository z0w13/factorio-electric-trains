data:extend(
{
  {
    type = "recipe",
    name = "electric-locomotive",
    energy_required = 5,
    enabled = false,
    ingredients =
    {
      {"electric-engine-unit", 20},
      {"advanced-circuit", 10},
      {"steel-plate", 30},
      {"battery", 50}
    },
    result = "electric-locomotive"
  },
  
  {
    type = "recipe",
    name = "electric-train-stop",
    energy_required = 5,
    enabled = false,
    ingredients =
    {
      {"steel-plate", 30},
      {"battery", 10},
      {"copper-cable", 20}
    },
    result = "electric-train-stop"
  },
  {
    type = "recipe",
    name = "battery-charging-station",
    energy_required = 5,
    enabled = false,
    ingredients =
    {
      {"iron-plate", 15},
      {"advanced-circuit", 5},
      {"copper-cable", 20}
    },
    result = "battery-charging-station"
  },
  
  {
    type = "recipe",
    name = "battery-pack",
    energy_required = 10,
    enabled = false,
    ingredients =
    {
      {"steel-plate", 2},
      {"battery", 20}
    },
    result = "battery-pack"
  },
  
  {
    type = "recipe",
    name = "battery-pack-recharge",
    category = "electrical",
    energy_required = 10,
    enabled = false,
    ingredients =
    {
      {"discharged-battery-pack", 1}
    },
    result = "battery-pack"
  }
})

if data.raw["train-stop"]["logistic-train-stop"] ~= nil then
  data:extend({
    {
      type = "recipe",
      name = "electric-logistic-train-stop",
      energy_required = 5,
      enabled = false,
      ingredients =
      {
        {"electric-train-stop", 1},
        {"constant-combinator", 1},
        {"small-lamp", 1},
        {"green-wire", 2},
        {"red-wire", 2},
      },
      result = "electric-logistic-train-stop"
    }
  })
end