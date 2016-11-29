//
//  VisualEntityBase.swift
//
//  Created by MARK BROWNSWORD on 13/10/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

class VisualEntityBase : GKEntity, VisualEntity {
    var node: SKSpriteNode!
    var stateMachine: GKStateMachine!
    
    
    // MARK: Initialization
    
    init(imageNamed: String, atStartPosition: CGPoint) {
        super.init()
        
        // Initialise Texture
        let texture = SKTexture(imageNamed: imageNamed)
        
        // Initialise Node
        self.node = SKSpriteNode(texture: texture, size: texture.size())
        self.node.position = atStartPosition

        // Initialise StateMachine
        self.stateMachine = GKStateMachine(states: [
            VisualEntityIdle(),
            VisualEntityPendingMove(),
            VisualEntityMoving()
        ])
        
        self.stateMachine.enter(VisualEntityIdle.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
