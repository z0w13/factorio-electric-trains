data:extend(
{
  {
    type = "technology",
    name = "electric-railway",
    icon_size = 128,
    icon = "__base__/graphics/technology/railway.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "electric-locomotive"
      },
      {
        type = "unlock-recipe",
        recipe = "electric-train-stop"
      },
      {
        type = "unlock-recipe",
        recipe = "battery-charging-station"
      },
      {
        type = "unlock-recipe",
        recipe = "battery-pack"
      },
      {
        type = "unlock-recipe",
        recipe = "battery-pack-recharge"
      }
    },
    prerequisites = {"railway", "electric-energy-distribution-2", "electric-engine"},
    unit =
    {
      count = 150,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1}
      },
      time = 30
    },
    order = "c-g-aa",
  }
})
