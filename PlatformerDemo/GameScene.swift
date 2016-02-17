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

    override func didMoveToView(view: SKView) {
        self.backgroundColor = .skyBlueColor()
        self.addChild(map)
    }
    
    override func update(currentTime: CFTimeInterval) {
    }
    
    override func keyDown(theEvent:NSEvent) {
    }
    
    override func keyUp(theEvent:NSEvent) {
    }
}
