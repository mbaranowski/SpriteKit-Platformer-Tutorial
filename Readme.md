# Swift SpriteKit Platformer Tutorial

A simple 2d platformer game tutorial written in Swift 2.1, running as an OSX app, using SpriteKit. Heavily Based on the excellent [RayWenderlich.com SpriteKit platform tutorial](http://www.raywenderlich.com/62049/sprite-kit-tutorial-make-platform-game-like-super-mario-brothers-part-1) but rewritten in idiomatic Swift. Uses excellent art resources from [kenney.nl](http://kenney.nl). Uses a slightly modified JSTileMap to load maps created in [TileEd](<http://www.mapeditor.org>)

To Play:

* A - move Left
* D - move Right
* Space - Jump!

or rewrite GameScene's keyDown & keyUp method.

Each commit is a snapshot of game progress that illustrates various mechanims and for a live tutorial can be replayed by checking out each commit in order.

1. Initial Commit - XCode project setup based on the default SpriteKit with all art assets included, utility code and JSTileMap
2. Load tile map - GameScene now loads and displays the included map.tmx file.
3. Add Player Class - Added a Player class and adds it to the GameScene as a static sprite
4. Add skeleton update - Add update method on Player and GameScene classes
5. Player Update - implement a very simple physics simulation for the player sprite
6. Handle Collision - adds collision resolution to make sure player doesn't fall through walls
7. Keyboard Controls - you can now contorl the player using the keyboard
8. SetViewPointCenter - the view now moves with the player
9. onPlayerDied - when player falls off the world, go back to start

[To Be Continued...]
