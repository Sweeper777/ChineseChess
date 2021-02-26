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
        for y in 0...9 {
            for x in 0...8 {
                if let piece = game.piece(at: Position(x, y)) {
                    let geometry = SCNCylinder(radius: 0.4, height: 0.2)
                    geometry.materials = ChessPieceTextureGenerator.materials(for: piece)
                    let node = SCNNode(geometry: geometry)
                    node.position = boardPosToScenePos(Position(x, y))
                    node.name = "piece"
                    rootNode.addChildNode(node)
                }
            }
        }

        let boardGeometry = SCNBox(width: 9, height: 0.1, length: 10, chamferRadius: 0)
        boardGeometry.materials = ChessPieceTextureGenerator.chessBoardMaterial
        let boardNode = SCNNode(geometry: boardGeometry)
        boardNode.eulerAngles.y = -.pi / 2
        boardNode.position = SCNVector3(4.5, 0, 4)
        boardNode.position.y = -0.15
        rootNode.addChildNode(boardNode)

    }
}

func boardPosToScenePos(_ position: Position) -> SCNVector3 {
    SCNVector3(x: 9 - Float(position.y), y: 0, z: Float(position.x))
}

func scenePosToBoardPos(_ position: SCNVector3) -> Position {
    Position(Int(round(position.z)), 9 - Int(round(position.x)))
}