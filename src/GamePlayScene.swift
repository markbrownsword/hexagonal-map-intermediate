//
//  GamePlayScene.swift
//
//  Created by MARK BROWNSWORD on 5/11/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol GamePlayScene: class {
    var entities: [GKEntity]! { get set }
    var componentSystems: [GKComponentSystem<GKComponent>]! { get set }
    var graph: HexGraph<HexGraphNode>! { get set }
    
    func initGamePlayComponents()
    func setupEntities()
    func setupComponentSystems()
    func setupGraph()
}
