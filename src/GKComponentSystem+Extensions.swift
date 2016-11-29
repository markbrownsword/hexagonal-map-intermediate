//
//  GKComponentSystem+Extensions.swift
//
//  Created by MARK BROWNSWORD on 26/11/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GKComponentSystem {
    func addComponents(from entities: [GKEntity]) {
        for entity in entities {
            self.addComponent(foundIn: entity)
        }
    }
}
