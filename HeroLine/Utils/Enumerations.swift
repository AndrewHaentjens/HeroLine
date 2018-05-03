//
//  Enumerations.swift
//  HeroLine
//
//  Created by Andrew Haentjens on 27/04/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit
import GameplayKit

public enum MapSquare: Int {
    
    case ground = 0, solid, player
    
    /**
        returns the enum name
    */
    public var name : String {
        return "\(self)".components(separatedBy: ".")[0]
    }
}

/**
 Put everthing for spriteKit in here, can be switched out for sceneKit if needed.
 */
extension MapSquare {
    
    /**
     What color should the square be
     */
    var color : SKColor {
        switch self {
        case .ground:
            return SKColor.green
        case .solid:
            return SKColor.gray
        case .player:
            return SKColor.yellow
        }
    }
    
    /**
     Create an animation for when a tile first appears on screen
     */
    func entryAction(forSprite sprite: SKSpriteNode, inLevel level: LevelData, atGridX gridX: Int, gridY: Int) -> SKAction? {
        
        sprite.alpha = 0
        
        return SKAction.sequence([
            SKAction.wait(forDuration: Double(gridX + gridY * level.gridWidth) * 5 / 4000),
            SKAction.fadeAlpha(to: 1, duration: 0.1)
        ])
        
    }
    
    func spriteForSquare(inLevel level: LevelData, atGridX gridX: Int = 0, gridY: Int = 0) -> SKSpriteNode? {
        
        let sprite: SKSpriteNode
        
        // Set sprite
        switch self {
            
        case .player:
            sprite = PlayerSprite(color: color, size: CGSize(width: level.squareSize, height: level.squareSize))
            
        default:
            sprite = SKSpriteNode(color: color, size: CGSize(width: level.squareSize, height: level.squareSize))
        }
        
        // Set z-postion
        switch self {
        
        case .ground:
            sprite.zPosition = GameScene.layer.ground.rawValue
            
        case .solid:
            sprite.zPosition = GameScene.layer.solid.rawValue
            
        case .player:
            sprite.zPosition = GameScene.layer.player.rawValue
        }
        
        sprite.position = CGPoint(x: gridX * level.squareSize, y:  gridY * level.squareSize)
        sprite.name = name
        
        /**
         Entry animation
         */
        if let initialAction = entryAction(forSprite: sprite, inLevel: level, atGridX: gridX, gridY: gridY){
            sprite.run(initialAction)
        }
        
        switch self {
            
        case .ground, .solid:
            return sprite
            
        default:
            let groundSprite = MapSquare.ground.spriteForSquare(inLevel: level, atGridX: gridX, gridY: gridY)
            
            sprite.position = .zero
            
            groundSprite?.addChild(sprite)
            
            return groundSprite
        }
        
    }
}
