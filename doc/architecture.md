# Gobi Architecture

### Purpose of this document
This document describes the objectives and structure of Gobi, as well as a
future vision for the game. This is so that I can revisit this project at a
later date if I so choose and get up to speed quickly. If you are not me,
hopefully this document will explain in detail why things are structured the way
they are, and how I am hoping to restructure things in the future.

### Gameplay
Gobi is designed to be a turn-based strategy game in the likeness of
Civilization V. While as of the time of writing I have never actually played
Civilization V, I have been told by people who have that Gobi has all the basic
elements of this type of game. You must grow your civilization so that it's
better than all the other ones. The game is *not* real-time (like AOE), it's
turn-based, so you can only do stuff when it's your turn.

#### Gameplay concepts
Civilizations are composed of a few key components:
- **Hubs**: A hub is a building. It can 
- **Entities**: An entity is a unit (we would have called them units, but that's
  a reserved keywork in ocaml).
- **Clusters**: A cluster is a city, or a group of hubs.
Not core components of the civilizations, but related to them, are:
- **Resources**: 
- **Research**:
- **Combat**:

#### Game map
Gobi, just like Civ, is played on a hexagonal map. The map is composed of
**tiles**. The map is procedurally generated when the game starts. All that
means is that the terrain type of the tile is random, and the placement
of the clusters is random.

#### AI
We were required to build an AI for the final project, so Gobi has an AI that
will try to execute random commands each turn. I think there's a lot of work to
be done with the core game engine before the AI is revisited, so I plan to leave
it alone for the forseeable future.

#### Win conditions
In general you win Gobi by having a civilization
superior to all other players. There are a couple of ways to do this:
- Destroy all the other civilizations
- Acquire a final tech-tree unlockable (see the description of the tech tree
  below for more details)
- Have the most "valuable" civilization when the turn limit is reached
The last one is pretty arbitrary, I have no idea if this exists in civ.
Basically every facet of your civilization has a point value, and those are
summed to get the "value" of your civilization. Highest number wins. I did not
write this scoring system, so I cannot provide more details.

### Module Architecture
