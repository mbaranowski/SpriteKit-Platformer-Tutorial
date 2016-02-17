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
    var previousUpdate : CFTimeInterval = 0
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = .skyBlueColor()
        self.addChild(map)
        
        self.player.position = CGPoint(x: 100, y: 600)
        self.map.addChild(self.player)
    }
    
    override func update(currentTime: CFTimeInterval) {
        let delta = clamp(lower:0.0, upper:0.2, currentTime - self.previousUpdate)
        self.previousUpdate = currentTime
        
        self.player.update(delta)
        self.handleCollisions(player, layer: self.map.layerNamed("walls"))
        self.setViewpointCenter(self.player.position)
    }
    
    enum Direction : Int {
        case Above
        case Below
        case Left
        case Right
        case UpperLeft
        case UpperRight
        case LowerLeft
        case LowerRight
        
        func offset() -> CGPoint {
            switch self {
            case Above:         return CGPoint(x: 0,y:-1)
            case Below:         return CGPoint(x: 0,y: 1)
            case Left:          return CGPoint(x:-1,y: 0)
            case Right:         return CGPoint(x: 1,y: 0)
            case UpperLeft:     return CGPoint(x:-1,y: 1)
            case UpperRight:    return CGPoint(x: 1,y: 1)
            case LowerLeft:     return CGPoint(x:-1,y:-1)
            case LowerRight:    return CGPoint(x: 1,y:-1)
            }
        }
        
        static let All : [Direction] = [.Above,.Below,.Left,.Right,.UpperLeft,.UpperRight,.LowerLeft,.LowerRight]
    }
    
    func handleCollisions(player : Player, layer : TMXLayer) {
        self.player.onGround = false
        
        var adjustment = CGPoint.zero
        var velocityFactor = CGPoint(x:1,y:1)
        
        for direction in Direction.All {
            let playerCoord = layer.coordForPoint(player.desiredPosition)
            
            if playerCoord.y > self.map.mapSize.height {
                print("fell out of the world! Game Over")
                return
            }
            
            let offset = direction.offset()
            let tileCoord = playerCoord + offset;
            
            if self.tileGID(tileCoord, forLayer:layer) != 0 {
                let tileRect = self.tileRect(tileCoord)
                
                if CGRectIntersectsRect(player.frame, tileRect) {
                    
                    let intersection = CGRectIntersection(player.frame, tileRect)
                    
                    switch direction {
                    case .Below:
                        adjustment += CGPoint(x:0, y:intersection.size.height)
                        velocityFactor *= CGPoint(x:1,y:0)
                        player.onGround = true
                        
                    case .Above:
                        adjustment += CGPoint(x:0, y:-intersection.size.height)
                        velocityFactor *= CGPoint(x:1,y:0)
                        break;
                        
                    case .Left:
                        adjustment += CGPoint(x:intersection.size.width, y:0)
                        
                    case .Right:
                        adjustment += CGPoint(x:-intersection.size.width, y:0)
                        
                    default:
                        
                        if intersection.size.width > intersection.size.height { //tile is diagonal, but resolving collision vertically
                            
                            velocityFactor *= CGPoint(x:1,y:0)
                            if direction.offset().y == 1 {
                                player.onGround = true
                            }
                            
                            adjustment += CGPoint(x:0, y: offset.y * intersection.size.height)
                        } else  {
                            adjustment += CGPoint(x: -offset.x * intersection.size.width, y:0)
                        }
                    }
                }
            }
        }
        
        player.velocity *= velocityFactor
        player.position = player.desiredPosition + adjustment
    }
    
    func tileGID(tileCoords:CGPoint, forLayer layer:TMXLayer) -> Int32 {
        let size = layer.layerInfo.layerGridSize
        
        if tileCoords.x >= size.width || tileCoords.y >= size.height || tileCoords.x < 0 || tileCoords.y < 0 {
            return 0
        }
        return layer.layerInfo.tileGidAtCoord(tileCoords)
    }
    
    func tileRect(tileCoords : CGPoint) -> CGRect {
        let levelHeightInPixels = self.mapPixelSize.height
        let origin = CGPoint(x:tileCoords.x * self.map.tileSize.width,
            y:levelHeightInPixels - ((tileCoords.y + 1) * self.map.tileSize.height));
        return CGRectMake(origin.x, origin.y, self.map.tileSize.width, self.map.tileSize.height);
    }

    // full size of the map in pixels
    var mapPixelSize : CGSize {
        get { return CGSize(width: self.map.mapSize.width  * self.map.tileSize.width,
            height: self.map.mapSize.height * self.map.tileSize.height )
        }
    }
    
    enum KeyCode : Int {
        case Jump = 32
        case Forward = 100
        case Backward = 97
    }
    
    func playerAction(keyCode : KeyCode, activate : Bool) {
        switch keyCode {
        case .Jump:      self.player.shouldJump = activate
        case .Forward:   self.player.forward = activate
        case .Backward:  self.player.backward = activate
        }
    }
    
    override func keyDown(theEvent:NSEvent) {
        for codeUnit in theEvent.characters!.utf16 {
            if let keyCode = KeyCode(rawValue:Int(codeUnit)) {
                playerAction(keyCode, activate: true)
            }
        }
    }
    
    override func keyUp(theEvent:NSEvent) {
        for codeUnit in theEvent.characters!.utf16 {
            if let keyCode = KeyCode(rawValue:Int(codeUnit)) {
                playerAction(keyCode, activate: false)
            }
        }
    }
    
    // half of the scene view size
    var halfViewPoint : CGPoint {
        get { return CGPoint(x:self.size.width * 0.5, y:self.size.height * 0.5) }
    }
    
    // full size of the map in pixels
    var mapMaxPoint : CGPoint {
        get { return CGPoint(x: self.map.mapSize.width  * self.map.tileSize.width,
            y: self.map.mapSize.height * self.map.tileSize.height )
        }
    }
    
    func setViewpointCenter(pos : CGPoint) {
        let actualPosition = clamp(lower: self.halfViewPoint, upper: self.mapMaxPoint - self.halfViewPoint, pos)
        let offset = CGPoint(x:0, y: (self.size.height - self.mapPixelSize.height))
        self.map.position = (self.halfViewPoint - actualPosition) - offset
    }
}
