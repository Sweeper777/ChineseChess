import UIKit
import ChessModel

class ViewController: UIViewController {

    @IBOutlet var chessBoardView: ChessBoardView!

    let game = Game()

    override func viewDidLoad() {
        super.viewDidLoad()

        chessBoardView.board = game
        chessBoardView.delegate = self

    }
}

extension ViewController : ChessBoardViewDelegate {
    func didTapPosition(_ position: Position) {
        if let tappedPiece = game.piece(at: position), tappedPiece.player == game.currentPlayer {
            chessBoardView.selectedPosition = position
            chessBoardView.selectablePositions =
                    tappedPiece.allMoves(from: position, in: game)
                            .filter { (try? game.validateMove($0)) != nil }
                            .map(\.to)
        } else if let startPosition = chessBoardView.selectedPosition,
        }
    }
}

