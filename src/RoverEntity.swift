//
//  RoverEntity.swift
//
//  Created by MARK BROWNSWORD on 13/10/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

class RoverEntity : VisualEntityBase {
    
    
    // MARK: Initialization
    
    init(startPosition: CGPoint) {
        super.init(imageNamed: "Rover", atStartPosition: startPosition)
        
        // Create Components
        addComponent(HealthComponent(node: self.node))
        addComponent(MoveComponent(node: self.node))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
