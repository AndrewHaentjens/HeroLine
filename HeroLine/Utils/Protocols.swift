//
//  Protocols.swift
//  HeroLine
//
//  Created by Andrew Haentjens on 01/05/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit
import GameplayKit

public protocol UpdateableLevelEntity {
    
    func update(currentTime: TimeInterval, inLevel: GameScene)
    
}
