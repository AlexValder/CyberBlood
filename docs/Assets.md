## Summary

Assets folder was originally a submodule, but it proved it didn't work as intended on every machine, so it was merged to the main repository. This folder utilizes Git LFS and stores both binary and text resources of any kind that are not Godot scenes or scripts (except shaders).
## Folder Structure

```
|
├─ animations
|   └─ *.res
├─ gui
|  ├─ fonts
|  |  ├─ *.ttf
|  |  └─ *.ttf.import
|  ├─ icons
|  |  ├─ inputs
|  |  |  ├─ keyboard
|  |  |  |  ├─ *.png
|  |  |  |  └─ *.png.import
|  |  |  ├─ playstation
|  |  |  |  ├─ *.png
|  |  |  |  └─ *.png.import
|  |  |  ├─ switch
|  |  |  |  ├─ *.png
|  |  |  |  └─ *.png.import
|  |  |  └─ xbox
|  |  |  |  ├─ *.png
|  |  |  |  └─ *.png.import
|  |  ├─ *.svg
|  |  └─ *.svg.import
|  └─ themes
|     └─ default.tres
├─ parallax
├─ shaders
|  └─ was_hit.gdshader
├─ sprites
|  ├─ items
|  |  ├─ *.png
|  |  └─ *.png.import
|  ├─ player
|  |  ├─ *.png
|  |  └─ *.png.import
|  ├─ bat
|  |  ├─ *.png
|  |  └─ *.png.import
|  ├─ skeleton
|  |  ├─ *.png
|  |  └─ *.png.import
|  └─ ... // to be added
├─ textures
|  ├─ *.png
|  ├─ *.png.import
|  └─ *.tres
├─ tileset
|  └─ *.tres
└─ .gitignore
```

## Animations

Folder: [here](../assets/animations/).

Currently, animations are saved as separate resources used by `AnimationPlayer` node. These resource files are a collection of all (or nearly all) animations associated with an entity. Name of the file reflects the name of an entity (for most of the cases).

Due to how state machine is implemented, actors that use it need to have a `play_anim(anim: String)` function. Example:

```gdscript
func play_anim(anim_name: String) -> void:
    player_anim.play("player/" + anim_name)
```

In this case, `anim_name` is usually a name of the state, that corresponds to the animation name. There are exceptions to this rule.

**Note**, When you create a new animation and agree to the pop-up of adding tracks to RESET, you'll need to manually append them to the library's RESET animation.

**Don't forget** to re-save animations once you change them.

## GUI

### Fonts

Currently, these are fonts used in the project:

* m3x6 (will probably be replaced, requires attribution, [link](https://managore.itch.io/m3x6))
* m5x7 (will probably be replaced, attribution appreciated, [link](https://managore.itch.io/m5x7))
* Blazma (SIL Open Font License, Version 1.1, [link](https://ggbot.itch.io/blazma-font), license in the files)
* Beholden (SIL Open Font License, Version 1.1, [link](https://amorphous.itch.io/beholden), license in the files)

Beholden-Regular.ttf is the default font for the default theme.

### Icons

Simply a collection of icons. In the top, there are icons used for currently unused end-of-the-demo screen, and in `input` subfolder – there are icons for keys and different inputs separated by input type (3 different controllers and mouse+keyboard). In case of controllers, files are named after Xbox controller layout, to simplify fetching an icon in code.

SVG icons are converted to PNG by Godot, the exact settings are configured via Import menu. PNG icons are used as they are.
### Themes

Currently, there is only one theme – `default.tres`, with no variations and minimum customization. Local changes are usually done by theme override properties or `LabelSettings` objects.

### Parallax

Currently, this folder is empty, but in the future parallax used for backgrounds in each biome will be stored here, in the form of PNG images or similar format. Images will be separated by subfolders with biome names.

### Shaders

Godot shaders, be it visual shaders or regular shaders, are stored here. Currently, since there is only one shader, no hierarchy or structure is established.

### Sprites

Sprite resources come in form of single sprites and spritesheets (all PNGs). All sprite resources are separated in a subfolders with names of the entity they're representing. Subfolder `items` is used by everything that's not an enemy or the player, however. Currently, there's one temporary exception: Giant Bat enemy uses same spritesheet as the player's bat form.

### Textures

In general, if a picture represents something that's not alive and a part of environment, it goes here. Same goes for tilesheet PNGs for level layouts. 

### Tilesets

Here go tileset *resources* created by Godot Editor. They contain not only reference to an image from [Textures](#Textures), but information about collisions, alternative tiles etc. They're named by the biome they're associated with, but `test_level.tres` is used by some props like elevator.