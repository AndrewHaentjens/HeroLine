//
//  GameScene.swift
//  HeroLine
//
//  Created by Andrew Haentjens on 27/04/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit
import GameplayKit

public class GameScene: SKScene {
    
    public var levelData: LevelData!
    public var gridGraph: GKGridGraph = GKGridGraph()
    
    /**
     set the layer zPosition based on this
     */
    public enum layer : CGFloat {
        case background = 0.0, ground = 100.0, solid = 200.0, player = 300.0, foreground = 400.0, debug = 10000.0
    }
    
    init(levelData: LevelData) {
        self.levelData = levelData
        self.gridGraph = GKGridGraph(fromGridStartingAt: int2(0,0), width: Int32(levelData.gridWidth), height: Int32(levelData.gridHeight), diagonalsAllowed: false)

        super.init(size: levelData.size)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        
        fatalError("No coder provided")
        
    }
    
    func processTilesWith(completion: (_ levelData: LevelData, _ tile: MapSquare, _ gridX: Int, _ gridY: Int) -> Void) {
        
        for gridY in 0..<levelData.gridHeight {
            for gridX in 0..<levelData.gridWidth {
                completion(levelData, levelData[gridX,gridY], gridX, gridY)
            }
        }
    }
    
    func levelSprite() -> SKNode{
        let mapNode = SKNode()
        
        processTilesWith { (levelData, tile, gridX, gridY) -> Void in
            //Create a sprite for the square
            if let sprite = tile.spriteForSquare(inLevel: levelData, atGridX: gridX, gridY: gridY) {
                for child in sprite.children{
                    child.removeFromParent()
                    child.position = sprite.position
                    mapNode.addChild(child)
                }
                
                mapNode.addChild(sprite)
            }
            
            switch tile {
                
            case .solid:
                let nodeToRemove = self.gridGraph.node(atGridPosition: int2(Int32(gridX), Int32(gridY)))
                self.gridGraph.remove([nodeToRemove!])
                
            default:
                break
            }
        }
        
        mapNode.name = "Arena"
        //Nudge it by half a square
        mapNode.position = CGPoint(x: levelData.squareSize / 2, y: levelData.squareSize / 2)
        
        return mapNode
    }
    
    func begin() {
        removeAllChildren()
        
        addChild(levelSprite())
    }

    public override func update(_ currentTime: TimeInterval) {
        
        if let arena = childNode(withName: "Arena"){
            for child in arena.children{
                if let updateable = child as? UpdateableLevelEntity{
                    updateable.update(currentTime: currentTime, inLevel: self)
                }
            }
        }
        /*
        childNode(withName: "gridDebug")?.removeFromParent()
        let newDebug = gridGraph.visualise(levelData)
        newDebug.name = "gridDebug"
        newDebug.zPosition = layer.Debug.rawValue
        newDebug.position = CGPoint(x: levelData.squareSize/2, y: levelData.squareSize/2)
        addChild(newDebug)
        */
    }
}
