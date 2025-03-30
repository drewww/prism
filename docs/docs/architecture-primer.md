# Prism's Architecture: A Primer
This is an overview of how a game made with Prism fits together.

## Actors

Actors are the entities that populate the game world. They include the player, monsters, items, chests, and any other interactive elements. Each actor consists of components—data structures that define their state and behavior.

## Components

Components store the data that define an actor’s properties and abilities. A monster’s health, a poison effect, or a player’s sight range are all represented as components. Components determine what actions an actor can perform.

## Actions

Actions are how actors interact with the game world. Moving, attacking, and casting spells are all actions. Actions require actors to have specific components and trigger state changes within the level.

## Systems

Systems handle game logic based on events. They process changes, such as reducing an actor’s health due to poison at the end of their turn or checking if a floating creature should fall into a pit. Systems operate at the level-wide scale being fed all events from that level.

## Level

The level manages all actors and maintains the game state. It tracks turns, processes actions, moves actors, and holds the map and various caches for the game world.

## Cells

Cells define the physical structure of the level. They represent terrain elements such as walls, floors, water, and lava—determining where actors can move and interact.
