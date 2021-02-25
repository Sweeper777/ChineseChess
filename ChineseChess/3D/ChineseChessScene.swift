import SceneKit
import ChessModel

class ChineseChessScene: SCNScene {
    var cameraNode: SCNNode!
    let game = Game()

    func setup() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = boardPosToScenePos(Position(4, 18))
        cameraNode.position.y = 10
        cameraNode.eulerAngles.x = -0.523599
        cameraNode.eulerAngles.y = -.pi / 2
    }
}

func boardPosToScenePos(_ position: Position) -> SCNVector3 {
    SCNVector3(x: 9 - Float(position.y), y: 0, z: Float(position.x))
}

func scenePosToBoardPos(_ position: SCNVector3) -> Position {
    Position(Int(round(position.z)), 9 - Int(round(position.x)))
}