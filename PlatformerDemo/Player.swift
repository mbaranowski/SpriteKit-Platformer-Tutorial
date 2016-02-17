//
//  Player.swift
//  PlatformerDemo
//
//  Created by MattBaranowski on 2/17/16.
//  Copyright © 2016 mattbaranowski. All rights reserved.
//

import Foundation

class Player : SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "p1_stand")
        super.init(texture: texture, color: .whiteColor(), size:texture.size() )
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}