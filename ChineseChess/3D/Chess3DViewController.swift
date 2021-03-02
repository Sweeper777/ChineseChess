import UIKit
import SceneKit
import ChessModel

class Chess3DViewController : UIViewController, ChessMessageDisplayer {
    var messageLabel: MessageView!
    var menuButton: UIButton!

    @IBOutlet var sceneView: SCNView!

    var scene: ChineseChessScene!

    var isFetching = false
    var doRedAutoMoves = false {
        didSet {
            menuButton.menu = generateMenu()
        }
    }
    var doBlackAutoMoves = false {
        didSet {
            menuButton.menu = generateMenu()
        }
    }

    func newGame() {
        scene = ChineseChessScene()
        scene.setup()
        sceneView.scene = scene
        scene.delegate = self
        scene.game.delegate = self
        sceneView.pointOfView = scene.cameraNode
    }

    override func viewDidLoad() {
        newGame()
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = .black
        sceneView.backgroundColor = .white
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        if let point = touches.first?.location(in: sceneView) {
            let results = sceneView.hitTest(point)
            if let firstResult = results.first(where: { $0.node.name == "piece" }) {
                let scenePos = firstResult.worldCoordinates
                let boardPos = scenePosToBoardPos(scenePos)
                scene.didTapBoardPos(boardPos, nodeTapped: firstResult.node)
            }
        }
    }
}