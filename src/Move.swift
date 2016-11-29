//
//  Move.swift
//
//  Created by MARK BROWNSWORD on 20/11/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

class Move {
    var path: [HexGraphNode]
    
    init(path: [HexGraphNode]) {
        self.path = path
    }
}
