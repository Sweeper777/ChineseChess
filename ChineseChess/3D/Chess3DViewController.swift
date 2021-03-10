import UIKit
import SceneKit
import ChessModel

class Chess3DViewController : UIViewController, ChessMessageDisplayer {
    var messageLabel: MessageView!
    var menuButton: UIButton!

    @IBOutlet var sceneView: SCNView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

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
            UIAction(title: "旋轉黑子", image: UIImage(systemName: "arrow.clockwise")) { _ in
                guard !self.scene.isAnimating else {
                    return
                }
                self.scene.rotateBlackPieces()
            },
            UIAction(title: "返回主菜單", image: UIImage(systemName: "xmark")) { _ in
                self.dismiss(animated: true)
            },
        ])
    }

    override func viewDidLoad() {
        activityIndicator.startAnimating()
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

        if scene.isAnimating {
            return
        }

        if let touch = touches.first {
            let previousPoint = touch.previousLocation(in: sceneView)
            let point = touch.location(in: sceneView)
            guard previousPoint == point else {
                return
            }
            let results = sceneView.hitTest(point)
            if let firstResult = results.first {
                let scenePos = firstResult.worldCoordinates
                let boardPos = scenePosToBoardPos(scenePos)
                scene.didTapBoardPos(boardPos)
            }
        }
    }

    func tryAutoMove() {
        guard (doBlackAutoMoves && scene.game.currentPlayer == .black) ||
                      (doRedAutoMoves && scene.game.currentPlayer == .red) else {
            return
        }

        waitForChessDBMove()
    }

    func waitForChessDBMove() {
        if isFetching || scene.isAnimating {
            return
        }

        isFetching = true

        requestNextMove(game: scene.game) { result in
            DispatchQueue.main.async {
                self.isFetching = false
                switch result {
                case .failure(let error):
                    self.showUnexpectedError(error)
                case .success(.move(let move)):
                    self.scene.animateMove(move) {
                        let moveResult = try! self.scene.game.makeMove(move)
                        self.showMoveResult(moveResult, player: self.scene.game.currentPlayer)
                    }
                case .success(.noBestMove):
                    self.doRedAutoMoves = false
                    self.doBlackAutoMoves = false
                    self.showAPIResult(apiResult: .noBestMove)
                case .success(let anotherResult):
                    self.showAPIResult(apiResult: anotherResult)
                }
            }
        }
    }
}

extension Chess3DViewController : ChessSceneDelegate {
    func didMakeMove(moveResult: MoveResult, player: Player) {
        showMoveResult(moveResult, player: player)
    }

    func moveDidError(_ error: MoveError, player: Player) {
        showMoveError(error, player: player)
    }

    func didUnexpectedError(_ error: Error) {
        showUnexpectedError(error)
    }


}

extension Chess3DViewController: GameDelegate {
    public func turnDidChange() {
        tryAutoMove()
    }
}