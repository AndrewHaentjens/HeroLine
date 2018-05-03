//
//  Extensions.swift
//  HeroLine
//
//  Created by Andrew Haentjens on 01/05/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit
import GameplayKit

public extension Int {
    
    public var int32 : Int32 {
        return Int32(self)
    }
    
}

public extension Int32 {
    
    public var int : Int {
        return Int(self)
    }
    
}

public extension CGFloat {
    
    public var double : Double {
        return Double(self)
    }
    
}

public extension CGPoint {
    
    public func gridPoint(squareSize:Int32) -> int2 {
        let gx = Int32(round(x))/squareSize
        let gy = Int32(round(y))/squareSize
        return int2(gx,gy)
    }
    
    func halfWayPointTo(destination:CGPoint) -> CGPoint {
        return CGPoint(x: (x+destination.x) / 2.0, y: (y+destination.y) / 2.0)
    }
    
    func lengthOfLineTo(destination:CGPoint) -> CGFloat {
        let dx = x-destination.x
        let dy = y-destination.y
        
        return sqrt(dx*dx+dy*dy)
    }
    
    func angleOfLineTo(destination end:CGPoint)->CGFloat {
        
        let hypotenuse = self.lengthOfLineTo(destination: end)
        
        if end.x > self.x {
            let opposite = self.y - end.y
            
            return asin(opposite/hypotenuse)
        } else {
            
            if end.y > self.y {
                let opposite = end.x - self.x
                
                return asin(opposite/hypotenuse) - CGFloat(Double.pi / 2.0)
            } else {
                let adjactent = end.x - self.x
                return acos(adjactent/hypotenuse)
            }
        }
    }
    
    func pathForArrowTo(destination end:CGPoint) -> CGPath{
        let tailLength = Double(lengthOfLineTo(destination: end) / 3.0)
        let flareOut =  Double.pi / 4.0
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: self.x, y: self.y))
        path.addLine(to: CGPoint(x: end.x, y: end.y))
        
        let theta = Double(angleOfLineTo(destination: end))
        
        var arrowHead = CGPoint(x: end.x.double - cos(theta - flareOut) * tailLength, y: end.y.double + sin(theta - flareOut) * tailLength)
        path.addLine(to: CGPoint(x: arrowHead.x, y: arrowHead.y))
        path.move(to: CGPoint(x: end.x, y: end.y))
        
        arrowHead = CGPoint(x: end.x.double - cos(theta + flareOut) * tailLength, y: end.y.double + sin(theta + flareOut) * tailLength)
        path.addLine(to: CGPoint(x: arrowHead.x, y: arrowHead.y))
        
        return path
    }
    
    func projectPoint(towardsPoint end: CGPoint, toDistance: CGFloat) -> CGPoint{
        let theta = Double(angleOfLineTo(destination: end))
        
        return CGPoint(x: x.double - cos(theta + Double.pi) * toDistance.double, y: y.double + sin(theta + Double.pi) * toDistance.double)
    }
}

public extension GKGridGraph {
    /*
    public func visualise(forLevel: LevelData) -> SKNode {
        let debugNode = SKNode()
        
        for y in 0..<forLevel.gridHeight{
            
            for x in 0..<forLevel.gridWidth{
                
                if let graphNode = node(atGridPosition: int2(Int32(x),Int32(y))) {
                    let debugGraphNode = SKShapeNode(circleOfRadius: CGFloat(forLevel.squareSize/8))
                    
                    let nodePosition = CGPoint(x: x*forLevel.squareSize, y: y*forLevel.squareSize)
                    
                    debugGraphNode.position = nodePosition
                    debugGraphNode.strokeColor = SKColor.black
                    debugGraphNode.fillColor = SKColor.white
                    debugGraphNode.zPosition = 10000
                    debugNode.addChild(debugGraphNode)
                    
                    for connectedNode in graphNode.connectedNodes{
                        if let connectedNode = connectedNode as? GKGridGraphNode{
                            let destination = CGPoint(x: connectedNode.gridPosition.x.int*forLevel.squareSize, y: connectedNode.gridPosition.y.int*forLevel.squareSize)
                            
                            let length = CGFloat(forLevel.squareSize/2) - (CGFloat(forLevel.squareSize)/16.0)
                            
                            let linkSprite = SKShapeNode(path: nodePosition.pathForArrowTo(destination: nodePosition.projectPoint(towardsPoint: destination, toDistance: length)))
                            linkSprite.strokeColor = SKColor.black
                            
                            linkSprite.zPosition = 9999
                            debugNode.addChild(linkSprite)
                        }
                    }
                }
                
            }
            
        }
        
        return debugNode
    }
 */
}
