//
//  LevelDataModel.swift
//  HeroLine
//
//  Created by Andrew Haentjens on 27/04/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

public struct LevelData {
    
    let name: String
    let squareSize: Int = 16
    let gridWidth: Int
    let gridHeight: Int
    
    var squareTypes: [MapSquare] = []
    
    public init(name: String, gridWidth: Int, gridHeight: Int, map:[Int]) {
        
        self.name = name
        
        self.gridWidth = gridWidth
        self.gridHeight = gridHeight
        
        for gridY in 0..<gridHeight{
            for gridX in 0..<gridWidth{
                guard let squareType = MapSquare(rawValue: map[mapDataOffset(x: gridX, y: gridY)]) else {
                    fatalError("Invalid map data: \(map[mapDataOffset(x: gridX, y: gridY)]) found at \(gridX),\(gridY)")
                }
                
                self.squareTypes.append(squareType)
            }
        }
        
    }
    
    var size: CGSize {
        return CGSize(width: squareSize * gridWidth, height: squareSize * gridHeight)
    }
    
    public subscript (x: Int,y: Int) -> MapSquare {
        get {
            return squareTypes[mapDataOffset(x: x,y: y)]
        }
        set {
            squareTypes[mapDataOffset(x: x, y: y)] = newValue
        }
    }
    
    private func mapDataOffset(x: Int, y: Int) -> Int {
        return x + y * gridWidth
    }
}
