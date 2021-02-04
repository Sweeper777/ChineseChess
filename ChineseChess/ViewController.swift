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
    }
}

