//
//  ComponentSystem+Extensions.swift
//
//  Created by MARK BROWNSWORD on 6/11/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

extension ComponentSystem {
    func system<T>(ofType: T.Type, from systems: [GKComponentSystem<GKComponent>]) -> T? {
        var result: T? = nil
        
        for system in systems {
            if let system = system as? T {
                result = system
                break
            }
        }
        
        return result
    }
}
