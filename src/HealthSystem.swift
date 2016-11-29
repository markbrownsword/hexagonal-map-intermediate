//
//  HealthSystem.swift
//
//  Created by MARK BROWNSWORD on 31/10/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

class HealthSystem: GKComponentSystem<GKComponent>, ComponentSystem {

    // MARK: ComponentSystem Properties
    
    weak var delegate: GamePlayScene!
    
    
    // MARK: Initialisation
    
    override init() {
        super.init(componentClass: HealthComponent.self)
    }
    
    
    // MARK: ComponentSystem Functions

    func queue(_ input: Health, for entity: VisualEntity) {
        if let entity = entity as? GKEntity {
            let healthComponent = entity.component(ofType: HealthComponent.self)
            healthComponent?.health -= input.data
        }
    }
}
