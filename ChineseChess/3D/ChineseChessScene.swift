import SceneKit

class ChineseChessScene: SCNScene {
    var cameraNode: SCNNode!

    func setup() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 0)
        cameraNode.eulerAngles.y = -.pi / 2
    }
}

func boardPosToScenePos(_ position: Position) -> SCNVector3 {
    SCNVector3(x: 9 - Float(position.y), y: 0, z: Float(position.x))
}

func scenePosToBoardPos(_ position: SCNVector3) -> Position {
    Position(Int(round(position.z)), 9 - Int(round(position.x)))
}