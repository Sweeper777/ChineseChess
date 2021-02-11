import UIKit
import ChessModel

class ViewController: UIViewController {

    @IBOutlet var chessBoardView: ChessBoardView!
    var messageLabel: MessageView!
    var autoMoveButton: UIButton!

    let game = Game()

    var isFetching = false

    override func viewDidLoad() {
        super.viewDidLoad()

        chessBoardView.board = game
        chessBoardView.delegate = self

        messageLabel = MessageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        messageLabel.isHidden = true

        autoMoveButton = UIButton(type: .system)
        autoMoveButton.setTitle("查詢着法數據庫", for: .normal)
        view.addSubview(autoMoveButton)
        autoMoveButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).offset(-16)
        }
        autoMoveButton.addTarget(self, action: #selector(waitForChessDBMove), for: .touchUpInside)
    }

    @objc func waitForChessDBMove() {
        isFetching = true

        requestNextMove(game: game) { result in
            DispatchQueue.main.async {
                self.isFetching = false
                switch result {
                case .failure(let error):
                    self.showUnexpectedError(error)
                case .success(.move(let move)):
                    let moveResult = try! self.game.makeMove(move)
                    self.showMoveResult(moveResult, player: self.game.currentPlayer)
                    self.chessBoardView.deselectAll()
                case .success(let anotherResult):
                    self.showAPIResult(apiResult: anotherResult)
                }
            }
        }
    }

    func showMessage(_ message: String) {
        messageLabel.text = message
        messageLabel.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0.5) {
            self.messageLabel.alpha = 0
        } completion: { _ in
            self.messageLabel.isHidden = true
            self.messageLabel.alpha = 1
        }
    }

    func showMoveResult(_ moveResult: MoveResult, player: Player) {
        switch moveResult {
        case .success:
            break
        case .check:
            showMessage("將！")
        case .checkmate:
            showMessage("\(player == .red ? "紅" : "黑")方被將死！")
        case .stalemate:
            showMessage("\(player == .red ? "紅" : "黑")方被困斃！")
        }
    }

    func showAPIResult(apiResult: APIResult) {
        switch apiResult {
        case .move: break
        case .invalidBoard:
            showMessage("當前局面無效！")
        case .noBestMove:
            showMessage("數據庫中無最佳着法！")
        }
    }

    func showMoveError(_ moveError: MoveError) {
        switch moveError {
        case .blocked:
            showMessage("蹩馬腿或塞象眼！")
        case .checked:
            showMessage("不應將！")
        case .invalidPosition:
            showMessage("不符棋規！")
        case .opponentsPiece:
            showMessage("對方棋子！")
        }
    }

    func showUnexpectedError(_ error: Error) {
        let alert = UIAlertController(title: "錯誤！", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好", style: .default))
        present(alert, animated: true)
        print(error)
    }
}

extension ViewController : ChessBoardViewDelegate {
    func didTapPosition(_ position: Position) {
        if isFetching {
            return
        }

        if position == chessBoardView.selectedPosition {
            chessBoardView.deselectAll()
        } else if let tappedPiece = game.piece(at: position), tappedPiece.player == game.currentPlayer {
            chessBoardView.selectedPosition = position
            chessBoardView.selectablePositions =
                    tappedPiece.allMoves(from: position, in: game)
                            .filter { (try? game.validateMove($0)) != nil }
                            .map(\.to)
            chessBoardView.selectablePositionsColor = game.currentPlayer == .red ? .red : .label
        } else if let startPosition = chessBoardView.selectedPosition,
                  let _ = game.piece(at: startPosition) {
            let move = Move(from: startPosition, to: position)
            do {
                let moveResult = try game.makeMove(move)
                chessBoardView.deselectAll()
                showMoveResult(moveResult, player: game.currentPlayer)

//                waitForChessDBMove()
            } catch let moveError as MoveError {
                showMoveError(moveError)
            } catch {
                showUnexpectedError(error)
            }
        }
    }
}
