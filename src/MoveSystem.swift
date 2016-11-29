//
//  MoveSystem.swift
//
//  Created by MARK BROWNSWORD on 20/11/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

class MoveSystem: GKComponentSystem<GKComponent>, ComponentSystem {
    
    // MARK: ComponentSystem Properties
    
    weak var delegate: GamePlayScene!
    
    
    // MARK: Private Properties
    
    private var map: SKTileMapNode!
    
    
    // MARK: Initialisation
    
    init(map: SKTileMapNode) {
        super.init(componentClass: MoveComponent.self)
        
        self.map = map
    }
    
    
    // MARK: ComponentSystem Functions

    func queue(_ input: Move, for entity: VisualEntity) {
        var sequence = [SKAction]()
        let healthSystem = self.system(ofType: HealthSystem.self, from: self.delegate.componentSystems!)!

        for node in input.path {
            let location = self.map.centerOfTile(atColumn: Int(node.gridPosition.x), row: Int(node.gridPosition.y))
            let action = SKAction.move(to: location, duration: 1)
            let completionHandler = SKAction.run({
                healthSystem.queue(Health(data: Int(node.costToEnter)), for: entity)
            })
            
            sequence += [action, completionHandler]
        }

        entity.stateMachine.enter(VisualEntityPendingMove.self)
        sequence.insert(SKAction.run({ entity.stateMachine.enter(VisualEntityMoving.self) }), at: 0) // Add at beginning
        sequence.append(SKAction.run({ entity.stateMachine.enter(VisualEntityIdle.self) })) // Add at end

        if let entity = entity as? GKEntity {
            let moveComponent = entity.component(ofType: MoveComponent.self)
            moveComponent?.sequence = sequence
        }
    }
}
