class Cannon : Piece {
    
    var player: Player
    
    var description: String {
        "\(player) Cannon"
    }
    
    var localisedDescription: String {
        switch player {
        case .red:
            return "炮"
        case .black:
            return "砲"
        }
    }
    
    func validateMove(_ move: Move, in board: Array2D<Piece?>) -> MoveError? {
        if abs(move.dx) > 0 && abs(move.dy) > 0 {
            return .invalidPosition
        }
        
        let numberOfPiecesInBetween: Int
        if abs(move.dx) > 0 {
            let start = min(move.from.x, move.to.x)
            let end = max(move.from.x, move.to.x)
            numberOfPiecesInBetween = ((start + 1)..<end).filter {
                board[Position($0, move.from.y)] != nil
            }.count
        } else {
            let start = min(move.from.y, move.to.y)
            let end = max(move.from.y, move.to.y)
            numberOfPiecesInBetween = ((start + 1)..<end).filter {
                board[Position(move.from.x, $0)] != nil
            }.count
        }
        if numberOfPiecesInBetween == 0 && board[move.to] == nil {
            return nil
        } else if numberOfPiecesInBetween == 1 && board[move.to]?.player == player.opponent {
            return nil
        } else {
            return .invalidPosition
        }
        
    }
    
    
    init(_ player: Player) {
        self.player = player
    }
}


