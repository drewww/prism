# Prism's Architecture: A Primer
This is an overview of how a game made with Prism fits together.

## Actors

Actors are the who and whats of a game: the player, monsters, items,
chests, and whatever other kinds of entities your game might have are actors. Actors
have components, blobs of data that contain an actor's state and drive the logic.

## Components

Components are the data that make up actors. The health of a monster, a poison effect,
and the player's sight range are all held in components attached to the actor. Components
allow actors to take actions.

## Actions

Actions are taken by actors to perform state changes in the level. Attacking, moving, or casting a fireball are examples of actions. They require actors to have combinations of
components before being performed. Actions might cause systems to 

## Systems

Systems perform logic based on events. You might have a system that ticks down an actor's
poison component when their turn ends, or checks if a monster is floating over a pit after they've been moved. Systems operate on an entire level.

## The Level

The level holds and maintains the state of all actors. It also keeps track of turns.
You would use the level to perform actions, move actors, or check what cell is at a specific location.

## Cells

Cells are your walls, floors, water, lava: what your actors stand on.
