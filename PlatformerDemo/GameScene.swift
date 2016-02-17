//
//  GameScene.swift
//  PlatformerDemo
//
//  Created by MattBaranowski on 2/17/16.
//  Copyright (c) 2016 mattbaranowski. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var map : JSTileMap = JSTileMap(named: "map.tmx")
    var player = Player()
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = .skyBlueColor()
        self.addChild(map)
        
        self.player.position = CGPoint(x: 100, y: 175)
        self.map.addChild(self.player)
    }
    
    override func update(currentTime: CFTimeInterval) {
    }
    
    override func keyDown(theEvent:NSEvent) {
    }
    
    override func keyUp(theEvent:NSEvent) {
    }
}
