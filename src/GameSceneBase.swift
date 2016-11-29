//
//  GameSceneBase.swift
//
//  Created by MARK BROWNSWORD on 6/9/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneBase : SKScene, GamePlayScene {
    
    // MARK: Properties
    
    var entities: [GKEntity]!
    var componentSystems: [GKComponentSystem<GKComponent>]!
    var graph: HexGraph<HexGraphNode>!
    
    
    // MARK: Private Properties
    
    private var lastUpdateTime : TimeInterval = 0
    
    
    // MARK: Override Functions
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        self.initGamePlayComponents()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update ComponentSystems
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: dt)
        }
        
        // Set CurrentTime
        self.lastUpdateTime = currentTime
    }
    
    
    // MARK: GameplayScene Functions
    
    func initGamePlayComponents() {
        self.setupEntities()
        self.setupComponentSystems()
        self.setupGraph()
    }
    
    func setupEntities() {
        fatalError("Abstract function must be overridden")
    }
    
    func setupComponentSystems() {
        fatalError("Abstract function must be overridden")
    }
    
    func setupGraph() {
        fatalError("Abstract function must be overridden")
    }
}
