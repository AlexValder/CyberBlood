This project uses Godot 4.1.2 game engine.
### Project Structure

Root directory of the project consists of next files and folders:
* `.git` – version control folder (may be invisible due to OS settings)
* `.godot` – Godot 4 specific files (managed by the engine, no need to go into)
* `addons` – plugins and addons used in the project; see [Plugins](#Plugins) for details.
* `assets` – assets like textures, audio, themes, other resources go into; see [[Assets]] for details.
* `build` – output folder for result binaries, may be absent; see [[Export]] for details.
* `data` – folder for databases and other read-only data files; see [[Database]] for details.
* `docs` – you are here!
* `entities` – scenes and scripts regarding moving actors, items, interactable objects etc., everything that is not a static level or GUI elements; see [[Scenes and scripts]] for details.
* `scenes` – scenes and scripts regarding static levels and GUI-only scenes that don't relate to any entities; see [[Scenes and scripts]] for details.
* `scripts` – scripts-only folder for autoload and scripts that don't have an associated scene with them; see [[Scripts]] for details.
* `.gitattributes`, `.gitignore` – files configuring VCS behavior.
* `CODEOWNERS`, `README.md` – files for GitHub to display.
* `icon.svg`, `icon.svg.import` – project icon and associated import file.
* `export_presets.cfg` – export templates configuration; see [[Export]] for details.
### Plugins

All plugins are under `addons` folder, and are not usually backed up in version control.

| Name | Path | Version | GitHub | Notes |
|----|----|----|----|----|
| Animated Sprite to Player | AS2P | - | [link](https://github.com/poohcom1/godot-animated-sprite-2-player) | Seems to be broken, so optional |
| Todo Manager | Todo_Manager | 2.2.2 | [link](https://github.com/OrigamiDev-Pete/TODO_Manager) | |
| Bloody Logger | bloody_logger | 1.0.1 | [link](https://github.com/AlexValder/BloodyLogger/) | self-written |
| Godot SQLite | godot-sqlite | 4.2 | [link](https://github.com/2shady4u/godot-sqlite) | |