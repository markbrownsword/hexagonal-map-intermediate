//
//  ComponentSystem.swift
//
//  Created by MARK BROWNSWORD on 31/10/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol ComponentSystem {
    associatedtype Input
    var delegate: GamePlayScene! { get set }
    func queue(_ input: Input, for entity: VisualEntity)
}
