Everything in Godot is a scene, however here I want to distinguish what is called "scene" and why they are separated into different folders: `entities` and `scenes`.
### Entities
*Entities* are actors or objects placed existing within a level, while *scenes* are parts of the levels or GUI-only scenes like main menu, that don't co-exist with normal levels at the same time. Entities are categorized as:
* *Player* – controllable character that reacts to the player's input.
* *Enemies* – incontrollable actors that exist in the level and perform different actions, and may or may not react and attack the player, dealing damage. Any enemy poses some sort of danger to the player.
* *Projectiles* – moving entities that can damage player and/or enemies or damageable environment. Currently, there's only one projectile: fireballs bats shoot.
* *Props* – "decorations" that exist in the level; some can be destroyed or interacted, some exist to perform some action etc. They are not logically considered a part of the level, but just exist within it.
* *Tools* – base classes/scripts that other types of entities are built upon or use. **Note**: base enemy is stored with enemies, since it requires more configuration.
#### Player
Player is the most complex entity so far. It has `player.tscn`+`player.gd`+`camera_target.gd`, `player_camera.tscn`+`player_camera.gd` and several folders with more scripts and some scenes.

`PlayerCamera` uses `Player` to obtain required information and connect signals. `CameraTarget` is one of the children of `Player` node, that it used as `PlayerCamera` actual target instead of just `Player`.

`Player` uses *state machine* to handle input, state and possible state transitions. Most of the input is accepted by player's state machine instead of player directly, which simplifies code. `PlayerStateMachine` inherits from `StateMachine` (see below), and configures player's behavior when he* is hurt or dies.

`PlayerCamera` does not have much code, is managed by `GameManager` and follows the existing `Player` object.

`CameraTarget` serves as actual camera's target and handles camera shift (by default, right stick, arrow keys and mouse movements with RMB pressed).

Currently existing player states:
* `idle`
* `run`
* `climbing`
* `jump`
* `double_jump` (isn't attached by default)
* `fall`
* `final_fall`
* `attack1`
* `attack2`
* `death`
* `hurt`
* `bat_form`
* `dash`
* `dash_attack`

*\* — "he" because player character is guy. Doesn't reflect or assume anything about the actual person playing the game.*
##### GUI
In player's folder there's also `inventory` and `hud` subfolders. In the scene, it's represented under `GUI` node (`CanvasLayer`, that allows for rendering of GUI separately). GUI has `HUD` as a locked `Control` child. Every GUI element player can see should be a child of this node.

`inventory`: complex branch that contains a container for the inventory itself and the control pop-up (that's to be removed and replaces with actual configurable controls tab). Inventory container currently has tabs for `Inventory` (currently held items), `Game` (quitting and settings) and `DevTab` (dev-only accessible tools). Unfinished. Has its own `inventory` subfolder.

`fps`: probably a temporary label with built-in script that displays current FPS. Resides in `hud` subfolder.

`player_health`: container with player's health bar, mana bar and money counter. All of them reside in `hud` subfolder.

`selected_form`: debug/dev label that displays current form player can transform to, to be replaced with actual graphics.
#### Enemies
All enemies are derived from `BaseEnemy` scene.
#### Projectiles
.
#### Props
.
#### Tools
.
### Scenes
.