Folder `scripts` consists of a several autoloads and a subfolder with separated non-singleton files related to the saving system. Adding new scripts here should only be done with a good reason.

* `constants.gd` – not autoload, holder of constant and static data like transformation or spell cost, as well as enemy type enum.
* `controls.gd` – autoload, therefore no `class_name`; determines current input type (controller or keyboard), handles button icons and paths to the icons. 
* `database.gd` – autoload, therefore no `class_name`; wrapper around third-party SQLite addon.
* `enemy_managed.gd` – autoload, therefore no `class_name`; populates loaded room with enemies when needed, keeps track of killed enemies.
* `game_manager.gd` – autoload, therefore no `class_name`; possibly the most important script that controls the game state, player status, room transition, and provides entry points for saving and some setup like user folder structure, logging setup and screenshot taking.
* `settings.gd` – autoload, therefore no `class_name`; handles settings saving and loading from `settings.ini`, provides API for accessing these values in categorized manner.
* `saves/saves.gd` – resource, that keeps track of its save id, has possible values that a save can handle, can save values from player/apply to player or other related objects.
* `saves/saves_manager.gd` – keeps track of current save index, triggers loading and saving it, keeps track of current save file.