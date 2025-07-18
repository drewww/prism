<div align="center">
 <picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/75c12e71-974f-4f43-ad67-8b8438a9744e">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/user-attachments/assets/5d8a003b-e646-4e9c-a5cf-5d3799163f3f">
  <img alt="prism" src="https://github.com/user-attachments/assets/5d8a003b-e646-4e9c-a5cf-5d3799163f3f">
 </picture>
</div>

> [!WARNING]
> **prism's** API is frozen, but there might be small changes as we finalize a proper release! We're currently evaluating this as a release candidate!

## prism

**prism** is a roguelike game engine written in [Lua](https://www.lua.org/) for use with [LÖVE](https://love2d.org/), inspired by Bob Nystrom's [talk](https://www.youtube.com/watch?v=JxI3Eu5DPwE) on roguelike architecture. It utilizes the **command pattern** and **composition** to provide a modular, extensible foundation for creating turn-based games.

While its core is opinionated, prism is largely unopinionated in specific game mechanics, allowing for diverse implementations like 4-way or 8-way gridded movement, classic roguelike turns, time-based schedulers, or action points, without dictating elements such as inventories or spells. We provide some common sense implementations of things like message logs and inventories in the prism/extra folder.

Released under the **MIT License**, prism is free to use for both personal and commercial projects.

## Features

- **Command Pattern**: Encapsulates changes in state as objects, enabling clean and decoupled turn-based mechanics.
- **Composition-Based Design**: Promotes flexibility and reusability using composition to build entities.
- **Event Listener System**: React to in-game events dynamically for things like status effects, traps, and environmental interactions.
- **Lightweight and Modular**: Built in Lua, prism is designed to be lean and easy to use.
- **In-Game Editor**: Geometer is a powerful in-game editor designed for rapid prototyping and debugging. Inspired by classic roguelike Wizard Modes, it lets you instantly spawn actors, modify terrain, and interact with the level like a paint program—making iteration fast and intuitive.
- **Multitile Actors**: Prism supports having players and monsters be NxN! No longer does a dragon need to inhabit just one tile!
  
## Documentation

Find our docs here:  
[Documentation](https://prismrl.github.io/prism/)  
[Tutorial](https://prismrl.github.io/prism/making-a-roguelike/part1.html#)

## Community

Join our community on Discord to discuss, collaborate, and get support:  
[Discord Server](https://discord.gg/9YpsH4hYVF)

## Gallery

<https://github.com/user-attachments/assets/6c7042d2-bfa3-4a13-b77c-d0b3b875e89e>

## Credits

#### Example game

- [Wanderlust CP437 tileset](http://bay12forums.com/smf/index.php?topic=145362.0) by Kynsmer

#### Geometer

- [FROGBLOCK](https://polyducks.itch.io/frogblock) by Polyducks
- Parts of [MRMOTEXT](https://mrmotarius.itch.io/mrmotext), buy the asset for full use!

### Gallery

- Also [MRMOTEXT](https://mrmotarius.itch.io/mrmotext)!
