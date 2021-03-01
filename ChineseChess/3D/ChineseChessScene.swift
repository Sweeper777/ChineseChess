import SceneKit
import ChessModel

class ChineseChessScene: SCNScene {
    var cameraNode: SCNNode!
    let game = Game()
    var selectedPosition: Position?
    private var selectablePositionNodes: [SCNNode] = []
    weak var delegate: ChessSceneDelegate?

    let pieceRadius: CGFloat = 0.4
    let pieceHeight: CGFloat = 0.2
    let selectablePositionIndicatorRadius: CGFloat = 0.16

    func setup() {
        setupCamera()
        setupPieceNodes()
        setupBoard()

        addLight(position: SCNVector3(-10, 10, -10))
        addLight(position: SCNVector3(-10, 10, 20))
        addLight(position: SCNVector3(20, 10, 20))
        addLight(position: SCNVector3(20, 10, -10))
        addLight(position: SCNVector3(5, 10, 5), castsShadows: true)
    }

    private func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = boardPosToScenePos(Position(4, 18))
        cameraNode.position.y = 10
        cameraNode.eulerAngles.x = -0.523599
        cameraNode.eulerAngles.y = -.pi / 2
    }

    private func setupPieceNodes() {
        for y in 0...9 {
            for x in 0...8 {
                if let piece = game.piece(at: Position(x, y)) {
                    let geometry = SCNCylinder(radius: pieceRadius, height: pieceHeight)
                    geometry.radialSegmentCount = 20
                    geometry.materials = ChessPieceTextureGenerator.materials(for: piece)
                    let node = SCNNode(geometry: geometry)
                    node.position = boardPosToScenePos(Position(x, y))
                    node.name = "piece"
                    rootNode.addChildNode(node)
                }
            }
        }
    }

    private func setupBoard() {
        let boardGeometry = SCNBox(width: 9, height: 0.1, length: 10, chamferRadius: 0)
        boardGeometry.materials = ChessPieceTextureGenerator.chessBoardMaterial
        let boardNode = SCNNode(geometry: boardGeometry)
        boardNode.eulerAngles.y = -.pi / 2
        boardNode.position = SCNVector3(4.5, 0, 4)
        boardNode.position.y = -0.15
        rootNode.addChildNode(boardNode)
    }

    func addLight(position: SCNVector3, castsShadows: Bool = false) {
        let lightNode = SCNNode()
        lightNode.position = position
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.light?.castsShadow = castsShadows
        rootNode.addChildNode(lightNode)
    }

    func didTapBoardPos(_ position: Position, nodeTapped: SCNNode?) {
        if let tappedPiece = game.piece(at: position) {
            let allMoves = tappedPiece.allMoves(from: position, in: game)
                    .filter { (try? game.validateMove($0)) != nil }
            if let move = allMoves.first {
                let animation = ChessAnimations.animation(from: move) {
                    nodeTapped?.position = boardPosToScenePos(move.to)
                }
                nodeTapped?.addAnimation(animation, forKey: nil)
                if let taken = game.piece(at: move.to) {
                    let takenPosition = boardPosToScenePos(move.to)
                    let takenNode = rootNode.childNodes { node, pointer in
                        abs(node.position.x - takenPosition.x) < 0.0001 &&
                                abs(node.position.z - takenPosition.z) < 0.0001
                    }.first
                    takenNode?.addAnimation(ChessAnimations.fadeAnimation {
                        takenNode?.removeFromParentNode()
                    }, forKey: nil)
                }
                try! game.makeMove(move)
    func animateMove(_ move: Move, completion: @escaping () -> Void) {
        let movingNode = nodeAtBoardPosition(move.from)
        movingNode?.addAnimation(ChessAnimations.animation(from: move, isAlreadySelected: false) { endPos in
            movingNode?.position = endPos
            DispatchQueue.main.async(execute: completion)
        }, forKey: nil)
        if let _ = game.piece(at: move.to) {
            let takenNode = nodeAtBoardPosition(move.to)
            takenNode?.addAnimation(ChessAnimations.fadeAnimation {
                takenNode?.removeFromParentNode()
            }, forKey: nil)
        }
    }

            }
        }

    private func nodeAtBoardPosition(_ position: Position) -> SCNNode? {
        let scenePos = boardPosToScenePos(position)
        return rootNode.childNodes { node, pointer in
            abs(node.position.x - scenePos.x) < 0.0001 &&
                    abs(node.position.z - scenePos.z) < 0.0001
        }.first
    }

    }
}

func boardPosToScenePos(_ position: Position) -> SCNVector3 {
    SCNVector3(x: 9 - Float(position.y), y: 0, z: Float(position.x))
}

func scenePosToBoardPos(_ position: SCNVector3) -> Position {
    Position(Int(round(position.z)), 9 - Int(round(position.x)))
}