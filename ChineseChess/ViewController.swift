import UIKit
import ChessModel

class ViewController: UIViewController {

    @IBOutlet var chessBoardView: ChessBoardView!
    @IBOutlet var messageLabel: UILabel!

    let game = Game()

    override func viewDidLoad() {
        super.viewDidLoad()

        chessBoardView.board = game
        chessBoardView.delegate = self
        messageLabel.layer.borderWidth = 3
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

    func showMoveResult(_ moveResult: MoveResult) {
        switch moveResult {
        case .success:
            break
        case .check:
            showMessage("將！")
        case .checkmate:
            showMessage("將死！")
        case .stalemate:
            showMessage("困斃！")
        }
    }
}

extension ViewController : ChessBoardViewDelegate {
    func didTapPosition(_ position: Position) {
        if position == chessBoardView.selectedPosition {
            chessBoardView.selectedPosition = nil
            chessBoardView.selectablePositions = []
        } else if let tappedPiece = game.piece(at: position), tappedPiece.player == game.currentPlayer {
            chessBoardView.selectedPosition = position
            chessBoardView.selectablePositions =
                    tappedPiece.allMoves(from: position, in: game)
                            .filter { (try? game.validateMove($0)) != nil }
                            .map(\.to)
        } else if let startPosition = chessBoardView.selectedPosition,
                  let _ = game.piece(at: startPosition) {
            let move = Move(from: startPosition, to: position)
            do {
                let moveResult = try game.makeMove(move)
                chessBoardView.selectedPosition = nil
                chessBoardView.selectablePositions = []
                // TODO: visualise moveResult
            } catch {
                // TODO: show error message on screen
                print(error)
            }
        }
    }
}

