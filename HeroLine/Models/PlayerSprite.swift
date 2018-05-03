//
//  PlayerSprite.swift
//  HeroLine
//
//  Created by Andrew Haentjens on 01/05/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayerSprite: SKSpriteNode, UpdateableLevelEntity {
    
    var route = [GKGridGraphNode]()
    
    func update(currentTime: TimeInterval, inLevel: GameScene) {
        
        if route.count == 0 && !hasActions() {
            let currentNode = inLevel.gridGraph.node(atGridPosition: position.gridPoint(squareSize: inLevel.levelData.squareSize.int32))
            
            if let destinationNode = inLevel.gridGraph.node(atGridPosition: int2(18, 5)) {
                if let path = inLevel.gridGraph.findPath(from: currentNode!, to: destinationNode) as? [GKGridGraphNode] {
                    route = path
                } else {
                    fatalError("Got a very unexpected output from findpath")
                }
            }
        }

        if !hasActions(){
            let currentPosition = position.gridPoint(squareSize: inLevel.levelData.squareSize.int32)
            
            let nextNode = route.remove(at: 0)
            
            let dx = nextNode.gridPosition.x - currentPosition.x
            let dy = nextNode.gridPosition.y - currentPosition.y
            
            run(SKAction.moveBy(x: CGFloat(dx.int * inLevel.levelData.squareSize),
                                y: CGFloat(dy.int * inLevel.levelData.squareSize),
                                duration: 0.2))
            
        }
    }
    
}
