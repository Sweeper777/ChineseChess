import SceneKit
import ChessModel

class ChineseChessScene: SCNScene {
    var cameraNode: SCNNode!
    let game = Game()
    var selectedPosition: Position?
    private var selectablePositionNodes: [SCNNode] = []
    weak var delegate: ChessSceneDelegate?
    var isAnimating = false

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

    func addLight(position: SCNVector3) {
        let lightNode = SCNNode()
        lightNode.position = position
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        rootNode.addChildNode(lightNode)
    }

    func didTapBoardPos(_ position: Position) {
        if position == selectedPosition {
            selectPosition(nil, animated: true)
        } else if let tappedPiece = game.piece(at: position),
                  tappedPiece.player == game.currentPlayer {
            selectPosition(position, animated: true)
        } else if let startPosition = selectedPosition,
                  let _ = game.piece(at: startPosition),
                  let nodeMoved = nodeAtBoardPosition(startPosition) {
            let move = Move(from: startPosition, to: position)
            do {
                let result = try game.makeMove(move)
                selectPosition(nil, animated: false)
                let animation = ChessAnimations.animation(from: move, isAlreadySelected: true) { endPos in
                    self.isAnimating = false
                    nodeMoved.position = endPos
                    DispatchQueue.main.async {
                        self.delegate?.didMakeMove(moveResult: result, player: self.game.currentPlayer)
                    }
                }
                isAnimating = true
                nodeMoved.addAnimation(animation, forKey: nil)
                if let _ = game.piece(at: move.to) {
                    let takenNode = nodeAtBoardPosition(move.to)
                    takenNode?.addAnimation(ChessAnimations.fadeAnimation {
                        takenNode?.removeFromParentNode()
                    }, forKey: nil)
                }
            } catch let error as MoveError {
                delegate?.moveDidError(error, player: game.currentPlayer)
            } catch {
                delegate?.didUnexpectedError(error)
            }
        }
    }

    func animateMove(_ move: Move, completion: @escaping () -> Void) {
        isAnimating = true
        let movingNode = nodeAtBoardPosition(move.from)
        movingNode?.addAnimation(ChessAnimations.animation(from: move, isAlreadySelected: false) { endPos in
            self.isAnimating = false
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

    func rotateBlackPieces() {
        isAnimating = true
        for pos in game.allPositions(of: .black) {
            guard let pieceNode = nodeAtBoardPosition(pos) else {
                continue
            }
            pieceNode.addAnimation(ChessAnimations.rotationAnimation(forPiece: pieceNode) { endY in
                self.isAnimating = false
                pieceNode.eulerAngles.y = endY
            }, forKey: nil)
        }
    }

    func selectPosition(_ position: Position?, animated: Bool) {
        if animated {
            if let old = selectedPosition,
               let selectedNode = nodeAtBoardPosition(old) {
                isAnimating = true
                selectedNode.addAnimation(ChessAnimations.deselectAnimation { endY in
                    self.isAnimating = false
                    selectedNode.position.y = endY
                }, forKey: "select")
            }
            if let new = position,
               let selectedNode = nodeAtBoardPosition(new) {
                isAnimating = true
                selectedNode.addAnimation(ChessAnimations.selectAnimation { endY in
                    self.isAnimating = false
                    selectedNode.position.y = endY
                }, forKey: "deselect")
            }
        }
        if let new = position, let piece = game.piece(at: new) {
            let allMoves = piece.allMoves(from: new, in: game)
            setSelectablePositions(allMoves
                    .filter { (try? game.validateMove($0)) != nil }
                    .map(\.to))
        } else {
            setSelectablePositions([])
        }
        selectedPosition = position
    }

    private func nodeAtBoardPosition(_ position: Position) -> SCNNode? {
        let scenePos = boardPosToScenePos(position)
        return rootNode.childNodes { node, pointer in
            abs(node.position.x - scenePos.x) < 0.0001 &&
                    abs(node.position.z - scenePos.z) < 0.0001
        }.first
    }

    private func setSelectablePositions(_ selectablePositions: [Position]) {
        for node in selectablePositionNodes {
            node.removeFromParentNode()
        }
        selectablePositionNodes = []
        for position in selectablePositions {
            let scenePosition = boardPosToScenePos(position)
            let geometry = SCNSphere(radius: selectablePositionIndicatorRadius)
            geometry.segmentCount = 20
            geometry.firstMaterial?.diffuse.contents = UIColor.green
            let node = SCNNode(geometry: geometry)
            node.position = scenePosition
            selectablePositionNodes.append(node)
            rootNode.addChildNode(node)
        }
    }
}

func boardPosToScenePos(_ position: Position) -> SCNVector3 {
    SCNVector3(x: 9 - Float(position.y), y: 0, z: Float(position.x))
}

func scenePosToBoardPos(_ position: SCNVector3) -> Position {
    Position(Int(round(position.z)), 9 - Int(round(position.x)))
}
