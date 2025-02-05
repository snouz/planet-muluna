local rro = require("lib.remove-replace-object")
local planet_lib = require("__PlanetsLib__.lib.planet")
local nauvis = data.raw["planet"]["nauvis"]
local nauvis_gen = nauvis.map_gen_settings
local asteroid_util = require "__space-age__.prototypes.planet.asteroid-spawn-definitions"
local tau = 2*math.pi
local map_gen = {
    cliff_settings = 
    {
        name = "cliff",
        control = "nauvis_cliff",
        cliff_smoothing = 0.5,
        cliff_elevation_0 = -0,
        cliff_elevation_interval = 5,
        richness = 1
      },
    autoplace_controls = 
    {
        ["stone"] = {},
        ["rocks"] = {},
        ["nauvis_cliff"] = {},
        ["oxide-asteroid-chunk"] = {},
        ["metallic-asteroid-chunk"] = {},
        ["carbonic-asteroid-chunk"] = {},
        ["anorthite-chunk"] = {},
        ["helium"] = {},
      },
    autoplace_settings = {
        ["tile"] =
      {
        settings =
        {
            ["muluna-dirt-1"] = {},
            ["muluna-dirt-2"] = {},
            ["muluna-dirt-3"] = {},
            ["muluna-dirt-4"] = {},
            ["muluna-dirt-5"] = {},
            ["muluna-dirt-6"] = {},
        }
      },
      ["decorative"] =
      {
        settings =
        {
          ["medium-rock"] = {},
          ["small-rock"] = {},
          ["tiny-rock"] = {},
          ["medium-sand-rock"] = {},
          ["small-sand-rock"] = {}
        }
      },
        ["entity"] =
      {
        settings =
        {
          ["stone"] = {},
          ["big-sand-rock"] = {},
          ["huge-rock"] = {},
          ["big-rock"] = {},
          ["oxide-asteroid-chunk"] = {},
            ["metallic-asteroid-chunk"] = {},
            ["carbonic-asteroid-chunk"] = {},
        }
      }
    }


}
if mods["alien-biomes"] then
  map_gen.autoplace_settings["decorative"] = nil
  map_gen.autoplace_settings["entity"].settings["big-sand-rock"] = nil
  map_gen.autoplace_settings["entity"].settings["huge-rock"] = nil
  map_gen.autoplace_settings["entity"].settings["big-rock"] = nil
end

local parent_planet = "nauvis"


if mods["any-planet-start"] then
  parent_planet = settings.startup["aps-planet"].value
  if parent_planet == "none" or parent_planet =="muluna" then
    parent_planet = "nauvis"
  end
end


local o_parent_planet = data.raw["planet"][parent_planet]

local muluna= 
{
    type = "planet",
    name = "muluna",
    
    draw_orbit = false,
    solar_power_in_space = nauvis.solar_power_in_space,
    auto_save_on_first_trip = true,
    gravity_pull = 10,
    order = nauvis.order .. "a",
    
    -- icons = {
    --   {
    --     icon = "__planet-muluna__/graphics/moon-icon.png",
    --   }
    -- },
    icon = "__planet-muluna__/graphics/moon-icon.png",
    icon_size = 1482,
    
    --orientation = nauvis.orientation-0.02,
    --distance = nauvis.distance*1.0,
    
    
    label_orientation = 0.55,
    starmap_icon = "__planet-muluna__/graphics/moon-icon.png",
    starmap_icon_size = 1482,
    subgroup = "satellites",
    magnitude = o_parent_planet.magnitude*3/5,
    pollutant_type = "radiation",
    persistent_ambient_sounds=data.raw["space-platform-hub"]["space-platform-hub"].persistent_ambient_sounds,
    localised_description={"planetslib-templates.moon-description",{"space-location-description.muluna"},"[planet=nauvis]"},
    surface_properties = {
        ["solar-power"] = 150,
        ["pressure"] = 50,
        ["magnetic-field"] = 0.01,
        ["day-night-cycle"] = nauvis.surface_properties["day-night-cycle"]*2,
    },
    map_gen_settings = map_gen,
    parked_platforms_orientation=0.70,
    orbit = { --Added in preparation for PlanetsLib to display orbits, hopefully in a less invasive way than MTLib.
      --polar = {2,0.005*tau},
      orientation = 0.75, --When planetsLib orbit is added, orientation and distance are set relative to parent body.
      distance = 1.6*o_parent_planet.magnitude/(nauvis.magnitude),
      parent = {
        type = "planet",
        name = parent_planet,
        },
      
        sprite = {
          type = "sprite",
          filename = "__planet-muluna__/graphics/orbits/orbit-muluna.png",
          size = 412,
          scale = 0.25*o_parent_planet.magnitude/(nauvis.magnitude),
        }
    },
    --asteroid_spawn_definitions = data.raw["planet"][parent_planet].asteroid_spawn_definitions,
}


local bot_power = 0.2

muluna.surface_properties["gravity"] = muluna.surface_properties["pressure"]/100*bot_power

if settings.startup["PlanetsLib-enable-temperature"].value == true then
  muluna.surface_properties["temperature"] = 264
end

if settings.startup["PlanetsLib-enable-oxygen"].value == true then
  muluna.surface_properties["oxygen"] = 0
end

local asteroid_spawn_definitions_connection = asteroid_util.spawn_definitions(asteroid_util.nauvis_vulcanus)
table.remove(asteroid_spawn_definitions_connection,6) --Removes medium asteroids from path
table.remove(asteroid_spawn_definitions_connection,5)
table.remove(asteroid_spawn_definitions_connection,4)
--table.remove(asteroid_spawn_definitions_connection,2)

local muluna_connection = {
  type = "space-connection",
  name = "nauvis-muluna",
  from = parent_planet,
  to = "muluna",
  subgroup = data.raw["space-connection"]["nauvis-vulcanus"].subgroup,
  length = 1000,
  asteroid_spawn_definitions = asteroid_spawn_definitions_connection
}

if settings.startup["override-space-connection"] == true then
  data.raw["space-connection"]["nauvis-vulcanus"].from = "muluna"
  data.raw["space-connection"]["nauvis-gleba"].from = "muluna"
  data.raw["space-connection"]["nauvis-fulgora"].from = "muluna"
end


PlanetsLib:extend({muluna})

data:extend{muluna_connection}