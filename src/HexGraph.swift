//
//  HexGraph.swift
//
//  Created by MARK BROWNSWORD on 21/11/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

class HexGraph<NodeType : HexGraphNode> : GKGraph {
    
    // MARK: Functions
    
    // Identify adjacent nodes using offset coordinates
    // http://www.redblobgames.com/grids/hexagons/#neighbors
    //
    //   A B
    //  F X C
    //   E D
    //
    // Note that F doesn't need to be explicity connected because it is either
    // not required or already done in the previous iteration X -> C connection
    //
    func connectAdjacentNodes() {
        let evenParityKey = "Even"
        let oddParityKey = "Odd"
        let A = "A"
        let B = "B"
        let C = "C"
        let D = "D"
        let E = "E"
        
        var neighbourParity = [
            evenParityKey: [
                A: vector_int2(x: -1, y: 1),
                B: vector_int2(x: 0, y: 1),
                C: vector_int2(x: 1, y: 0),
                D: vector_int2(x: -1, y: 0),
                E: vector_int2(x: -1, y: -1)
            ],
            oddParityKey: [
                A: vector_int2(x: 0, y: 1),
                B: vector_int2(x: 1, y: 1),
                C: vector_int2(x: 1, y: 0),
                D: vector_int2(x: 1, y: -1),
                E: vector_int2(x: 0, y: -1)
            ]
        ]

        for node in self.nodes as! [NodeType] {
            let nodePosition = node.gridPosition!
            let parity = nodePosition.y & 1 // Derive parity from Y coordinate e.g. (0,3) (1,3) (2,3) represents an odd row (3) 
            let neighbourOffsets = (parity == 0 ? neighbourParity[evenParityKey] : neighbourParity[oddParityKey])!
            var neighbourNodes = [NodeType]()
            var neighbourPosition: vector_int2

            for offset in neighbourOffsets.values {
                neighbourPosition = vector_int2(x: nodePosition.x + offset.x, y: nodePosition.y + offset.y)
                if exists(atGridPosition: neighbourPosition) {
                    neighbourNodes.append(self.node(atGridPosition: neighbourPosition))
                }
            }

            node.addConnections(to: neighbourNodes, bidirectional: true)
        }
    }
    
    func exists(atGridPosition position: vector_int2) -> Bool {
        for node in self.nodes as! [NodeType] {
            if node.gridPosition.x == position.x && node.gridPosition.y == position.y {
                return true
            }
        }
        
        return false
    }
    
    func node(atGridPosition position: vector_int2) -> NodeType {
        var result: NodeType!
        
        for node in self.nodes as! [NodeType] {
            if node.gridPosition.x == position.x && node.gridPosition.y == position.y {
                result = node
                break
            }
        }
        
        return result
    }
}
