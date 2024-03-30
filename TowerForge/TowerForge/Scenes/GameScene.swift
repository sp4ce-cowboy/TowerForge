//
//  GameScene.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var isVerticallyPannable = true
    var isHorizontallyPannable = true

    private var lastUpdatedTimeInterval = TimeInterval(0)
    unowned var updateDelegate: SceneUpdateDelegate?
    unowned var sceneManagerDelegate: SceneManagerDelegate?
    private var cameraNode: TFCameraNode?

    override func sceneDidLoad() {
        super.sceneDidLoad()
        setupCamera()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        updateDelegate?.touch(at: location)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
          return
        }

        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        let translation = location - previousLocation

        if isHorizontallyPannable {
            cameraNode?.move(by: CGVector(dx: translation.x, dy: 0))
        }
        if isVerticallyPannable {
            cameraNode?.move(by: CGVector(dx: 0, dy: translation.y))
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdatedTimeInterval == TimeInterval(0) {
            lastUpdatedTimeInterval = currentTime
        }

        let changeInTime = currentTime - lastUpdatedTimeInterval
        lastUpdatedTimeInterval = currentTime
        updateDelegate?.update(deltaTime: changeInTime)
    }

    private func setupCamera() {
        let cameraNode = TFCameraNode()
        self.cameraNode = cameraNode
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        camera = cameraNode.cameraNode
    }
}

extension GameScene: TFScene {
    func add(node: TFNode, staticOnScreen: Bool = false) {
        if staticOnScreen {
            cameraNode?.add(child: node)
        } else {
            addChild(node.node)
        }
    }

    func remove(node: TFNode) {
        node.node.removeFromParent()
    }

    func contains(node: TFNode) -> Bool {
        contains(node.node) || cameraNode?.contains(node) ?? false
    }

    func panCamera(by displacement: CGVector) {
        cameraNode?.move(by: displacement)
    }
}
