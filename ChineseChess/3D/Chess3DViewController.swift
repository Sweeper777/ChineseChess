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

    func generateMenu() -> UIMenu {
        UIMenu(children: [
            UIAction(title: "新局") { _ in
                self.newGame()
            },
            UIAction(title: "自動走紅", state: doRedAutoMoves ? .on : .off) { _ in
                self.doRedAutoMoves.toggle()
                self.tryAutoMove()
            },
            UIAction(title: "自動走黑", state: doBlackAutoMoves ? .on : .off) { _ in
                self.doBlackAutoMoves.toggle()
                self.tryAutoMove()
            },
            UIAction(title: "查詢着法數據庫", state: doBlackAutoMoves ? .on : .off) { _ in
                self.waitForChessDBMove()
            },
        ])
    }

    override func viewDidLoad() {
        newGame()
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = .black
        sceneView.backgroundColor = .white

        messageLabel = MessageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        messageLabel.isHidden = true

        menuButton = UIButton(type: .system)
        menuButton.setTitle("菜單", for: .normal)
        menuButton.showsMenuAsPrimaryAction = true
        view.addSubview(menuButton)
        menuButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).offset(-16)
        }
        menuButton.menu = generateMenu()
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