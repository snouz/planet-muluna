local lunar_rock = table.deepcopy(data.raw["simple-entity"]["big-rock"])
local tint = {1,1,0.5}
for _,sprite in pairs(lunar_rock.pictures) do
    sprite.tint = tint
end

lunar_rock.icons = {{icon = lunar_rock.icon, icon_size = lunar_rock.icon_size, tint = tint}}

lunar_rock.name = "lunar-rock"

lunar_rock.minable.results = {
    {type = "item", name = "sulfur", amount = 2},
    {type = "item", name = "stone", amount = 20},
}

lunar_rock.map_color = {184, 150, 0}




lunar_rock.autoplace =
{
  control = "lunar_rocks",
  order = "a[doodad]-a[rock]-b[big]",
  probability_expression = "multiplier * control * (region_box + lunar_rock_density - penalty)",
  local_expressions =
  {
    multiplier = 0.17,
    penalty = 1.6,
    region_box = "range_select_base(moisture, 0.35, 1, 0.2, -10, 0)",
    control = "control:lunar_rocks:size"
  }
}
data:extend{lunar_rock}



data:extend{
    {
        type = "noise-expression",
        name = "lunar_rock_noise",
        expression = "multioctave_noise{x = x,\z
                                        y = y,\z
                                        seed0 = map_seed,\z
                                        seed1 = 1371,\z
                                        octaves = 4,\z
                                        persistence = 0.9,\z
                                        input_scale = 0.15 * var('control:rocks:frequency'),\z
                                        output_scale = 1} + 0.25 + 0.75 * (slider_rescale(control:rocks:size, 1.5) - 1)"
      },
      {
        type = "noise-expression",
        name = "lunar_rock_density",
        expression = "lunar_rock_noise - max(0, 1.1 - distance / 32)"
      }


}