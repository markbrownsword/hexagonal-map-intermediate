//
//  VisualEntity.swift
//
//  Created by MARK BROWNSWORD on 15/10/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol VisualEntity {
    var node: SKSpriteNode! { get }
    var stateMachine: GKStateMachine! { get }
}
