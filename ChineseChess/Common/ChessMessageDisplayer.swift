import UIKit
import ChessModel

protocol ChessMessageDisplayer: UIViewController {
    var messageLabel: MessageView! { get }
}

extension ChessMessageDisplayer {
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

    func showMoveError(_ moveError: MoveError, player: Player) {
        switch moveError {
        case .blocked:
            showMessage("蹩馬腿或塞象眼！")
        case .checked:
            showMessage("\(player == .red ? "帥" : "將")被將！")
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