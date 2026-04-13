# FeatherRace

FeatherRace is a text-based Lua game where you raise, train, and manage a bird as it prepares for races. Players can improve stats, manage stamina, and make choices each day that affect race performance.

## Features

* Create and name your bird
* Train and improve bird stats
* Manage stamina through feeding and resting
* View bird stats during gameplay
* Race progression with increasing difficulty
* Shop system for gameplay interaction

## Project Files

* `main.lua` - Main game loop and player command handling
* `stats.lua` - Bird creation, stats, stamina, and actions
* `race.lua` - Race cycle, race display, and race progression
* `shop.lua` - Shop-related mechanics

## Requirements

Before running the game, make sure Lua is installed on your computer.

### Check if Lua is installed

Open a terminal or command prompt and run:

```bash
lua -v
```

If Lua is installed, you should see a version number.

## How to Run the Application

1. Download or clone the project files.
2. Open a terminal in the project folder.
3. Run the game with:

```bash
lua main.lua
```

## Example Run

```bash
lua main.lua
```

The game will then prompt you to enter your bird's name and begin gameplay.

## Available Commands

During the game, you can use the following commands:

* `feed`
* `train`
* `play`
* `rest`
* `stats`
* `shop`
* `quit`

## Notes

* Make sure all Lua files stay in the same folder.
* The game is designed to run in the terminal/command prompt.
* If `lua main.lua` does not work, Lua may not be installed correctly or may not be added to your system PATH.

## GitHub

If using GitHub, you can clone the repository with:

```bash
git clone [(https://github.com/Bnguyen8091/FeatherRace.git)]
cd FeatherRace
lua main.lua
```

## Authors

FeatherRace was developed as a group project.
