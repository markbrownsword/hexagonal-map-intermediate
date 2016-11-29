//
//  HexGraphNode.swift
//
//  Created by MARK BROWNSWORD on 21/11/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

class HexGraphNode : GKGraphNode {
    var gridPosition: vector_int2!
    var costToEnter: Float!
    
    required init(gridPosition: vector_int2, costToEnter: Float) {
        super.init()
        
        self.gridPosition = gridPosition
        self.costToEnter = costToEnter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func cost(to node: GKGraphNode) -> Float {
        let result = super.cost(to: node) + self.costToEnter
        return result
    }
}
