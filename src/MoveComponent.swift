//
//  MoveComponent.swift
//
//  Created by MARK BROWNSWORD on 20/11/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

class MoveComponent: GKComponent, Component {
    
    // MARK: Private Properties
    
    private var updateRequired: Bool = false
    private var node: SKSpriteNode!
    
    
    // MARK: Public Properties
    
    var sequence: [SKAction]? {
        didSet {
            self.updateRequired = true
        }
    }
    
    
    // MARK: Initialization Functions
    
    required init(node: SKSpriteNode) {
        super.init()

        self.node = node
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Override Functions
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if !updateRequired {
            return
        }

        self.node.run(SKAction.sequence(self.sequence!))
        self.updateRequired = false
    }
}
