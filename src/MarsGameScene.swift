//
//  MarsGameScene.swift
//
//  Created by MARK BROWNSWORD on 24/7/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

class MarsGameScene: GameSceneBase, TileMapScene {
    
    // MARK: TileMapScene Public Properties
    
    var backgroundLayer: SKTileMapNode!
    var gridLayer: SKTileMapNode!
    var selectionLayer: SKTileMapNode!
    var buildingsLayer: SKTileMapNode!
    var startTilePosition: CGPoint?
    
    var gameScene: SKScene! {
        return self
    }
    
    // MARK: Private Properties
    
    private var selectionlocation: CGPoint?
    private var healthSystem: HealthSystem!
    private var moveSystem: MoveSystem!
    private var roverEntity: VisualEntity!
    
    
    // MARK: Override Functions
    
    override func didMove(to view: SKView) {
        guard let backgroundLayer = childNode(withName: "background") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        
        guard let gridLayer = childNode(withName: "grid") as? SKTileMapNode else {
            fatalError("Grid node not loaded")
        }
        
        guard let selectionLayer = childNode(withName: "selection") as? SKTileMapNode else {
            fatalError("Selection node not loaded")
        }
        
        guard let buildingsLayer = childNode(withName: "buildings") as? SKTileMapNode else {
            fatalError("Buildings node not loaded")
        }
        
        guard let camera = self.childNode(withName: "gameCamera") as? SKCameraNode else {
            fatalError("Camera node not loaded")
        }
        
        self.backgroundLayer = backgroundLayer
        self.gridLayer = gridLayer
        self.selectionLayer = selectionLayer
        self.buildingsLayer = buildingsLayer
        self.camera = camera
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanFrom(recognizer:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressFrom(recognizer:)))
        longPressRecognizer.minimumPressDuration = 1
        view.addGestureRecognizer(longPressRecognizer)
        
        // Setup GridLayer
        self.floodFillGrid()
        
        // Initialise Base
        super.didMove(to: view)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    
    // MARK: GamePlayScene Members
    
    override func setupEntities() {
        self.entities = [GKEntity]()
        
        // Initialise Rover
        let roverStartPosition = self.startTilePosition != nil ? self.startTilePosition : self.defaultPlayerStartTilePosition()
        self.roverEntity = RoverEntity(startPosition: roverStartPosition!)
        self.entities.append(self.roverEntity as! GKEntity)
        
        // Add entites to scene
        for entity in self.entities {
            if let visualEntity = entity as? VisualEntity {
                self.addChild(visualEntity.node)
            }
        }
    }
    
    override func setupComponentSystems() {
        self.healthSystem = HealthSystem()
        self.healthSystem.addComponents(from: self.entities)
        self.healthSystem.delegate = self

        self.moveSystem = MoveSystem(map: self.backgroundLayer)
        self.moveSystem.addComponents(from: self.entities)
        self.moveSystem.delegate = self

        self.componentSystems = [
            self.healthSystem,
            self.moveSystem
        ]
    }
    
    override func setupGraph() {
        var nodes = [HexGraphNode]()

        for column in 0 ..< self.backgroundLayer.numberOfColumns {
            for row in 0 ..< self.backgroundLayer.numberOfRows {
                let position = vector_int2(x: Int32(column), y: Int32(row))
                if self.isObstacle(at: column, row: row) {
                    continue
                }

                let costToEnter = self.costToEnter(tile: column, row: row)
                let hexGraphNode = HexGraphNode(gridPosition: position, costToEnter: costToEnter)
                nodes.append(hexGraphNode)
            }
        }
        
        self.graph = HexGraph(nodes)
        self.graph.connectAdjacentNodes()
    }
    
    
    // MARK: GestureRecognizer functions
    
    func handlePanFrom(recognizer: UIPanGestureRecognizer) {
        if recognizer.state != .changed {
            return
        }
        
        // Get touch delta
        let translation = recognizer.translation(in: recognizer.view!)
        
        // Move camera
        self.camera?.position.x -= translation.x
        self.camera?.position.y += translation.y
        
        // Reset
        recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
    }
    
    func handleTapFrom(recognizer: UITapGestureRecognizer) {
        if recognizer.state != .ended {
            return
        }

        if !self.roverEntity.stateMachine.canEnterState(VisualEntityPendingMove.self) {
            return
        }
        
        let location = recognizer.location(in: recognizer.view!)
        let targetLocation = self.convertPoint(fromView: location)

        if !self.isMapTile(at: targetLocation) {
            return
        }

        if self.isObstacle(at: targetLocation) {
            return
        }

        if self.isEntity(visualEntity: self.roverEntity, at: targetLocation) {
            // Toggle selection on / off
            self.selectionlocation = self.setSelection(at: targetLocation, currentSelection: self.selectionlocation)
        } else if self.isEntity(visualEntity: self.roverEntity, at: self.selectionlocation) {
            // Toggle selection off
            self.selectionlocation = self.setSelection(at: self.selectionlocation!, currentSelection: self.selectionlocation)

            // Invoke move system
            let startCoordinate = self.mapCoordinate(from: self.roverEntity.node.position)
            let endCoordinate = self.mapCoordinate(from: targetLocation)
            let path = self.findPath(from: startCoordinate, to: endCoordinate)
            self.moveSystem.queue(Move(path: Array(path.dropFirst())), for: self.roverEntity)
        }
    }
    
    func handleLongPressFrom(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state != .began {
            return
        }
        
        // Toggle visibility of gridLayer
        self.gridLayer.isHidden = !self.gridLayer.isHidden
    }
    
    
    // MARK: Private Functions
    
    private func isObstacle(at targetLocation: CGPoint) -> Bool {
        let isObstacle = self.backgroundLayer.getUserData(forKey: "isObstacle", location: targetLocation) as! Bool
        
        return isObstacle
    }
    
    private func isObstacle(at column: Int, row: Int) -> Bool {
        let isObstacle = self.backgroundLayer.getUserData(forKey: "isObstacle", column: column, row: row) as! Bool

        return isObstacle
    }
    
    private func costToEnter(tile column: Int, row: Int) -> Float {
        let costToEnter = self.backgroundLayer.getUserData(forKey: "costToEnter", column: column, row: row) as! Float
        
        return costToEnter
    }
    
    private func isEntity(visualEntity: VisualEntity, at targetLocation: CGPoint?) -> Bool {
        if targetLocation == nil {
            return false
        }
        
        return self.backgroundLayer.atSameMapTile(visualEntity.node.position, and: targetLocation!)
    }

    private func isMapTile(at targetLocation: CGPoint) -> Bool {
        return self.backgroundLayer.exists(at: targetLocation)
    }
    
    private func defaultPlayerStartTilePosition() -> CGPoint {
        var result = CGPoint.zero
        
        for column in 0 ..< self.buildingsLayer.numberOfColumns {
            for row in 0 ..< self.buildingsLayer.numberOfRows {
                guard let tile = self.buildingsLayer.tileDefinition(atColumn: column, row: row) else {
                    continue
                }
                
                guard let isStartTile = tile.userData?.value(forKey: "isStartTile") else {
                    continue
                }
                
                if !(isStartTile as! Bool) {
                    continue
                }
                
                result = self.buildingsLayer.centerOfTile(atColumn: column, row: row)
                break
            }
        }
        
        return result
    }
}
