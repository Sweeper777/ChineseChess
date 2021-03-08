import UIKit
import ChessModel

class ChessViewController: UIViewController, ChessMessageDisplayer  {

    @IBOutlet var chessBoardView: ChessBoardView!
    var messageLabel: MessageView!
    var menuButton: UIButton!

    var game = Game()

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
        game = Game()
        game.delegate = self
        chessBoardView.board = game
        chessBoardView.deselectAll()
        chessBoardView.previousLocation = nil
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
            UIAction(title: "翻轉棋盤", image: UIImage(systemName: "arrow.clockwise")) { _ in
                self.chessBoardView.isFlipped.toggle()
            },
            UIAction(title: "返回主菜單", image: UIImage(systemName: "xmark")) { _ in
                self.dismiss(animated: true)
            },
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        newGame()
        chessBoardView.delegate = self

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

    func tryAutoMove() {
        guard (doBlackAutoMoves && game.currentPlayer == .black) ||
                      (doRedAutoMoves && game.currentPlayer == .red) else {
            return
        }

        waitForChessDBMove()
    }

    func waitForChessDBMove() {
        if isFetching {
            return
        }

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
                    self.chessBoardView.previousLocation = move.from
                    self.chessBoardView.previousLocationColor = self.game.currentPlayer.opponent == .red ?
                            UIColor(named: "redPieceBackground") : UIColor(named: "blackPieceBackground")
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

extension ChessViewController : ChessBoardViewDelegate {
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
                chessBoardView.previousLocation = startPosition
                chessBoardView.previousLocationColor = game.currentPlayer.opponent == .red ?
                        UIColor(named: "redPieceBackground") : UIColor(named: "blackPieceBackground")
                showMoveResult(moveResult, player: game.currentPlayer)
            } catch let moveError as MoveError {
                showMoveError(moveError, player: game.currentPlayer)
            } catch {
                showUnexpectedError(error)
            }
        }
    }
}

extension ChessViewController: GameDelegate {
    public func turnDidChange() {
        tryAutoMove()
    }
}
