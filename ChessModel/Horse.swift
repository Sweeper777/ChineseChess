class Horse : Piece {
    
    var player: Player
    
    var description: String {
        "\(player) Horse"
    }
    
    var localisedDescription: String {
        switch player {
        case .red:
            return "傌"
        case .black:
            return "馬"
        }
    }
    
    func validateMove(_ move: Move, in board: Array2D<Piece?>) -> MoveError? {
        if abs(move.dx) == 2 {
            guard abs(move.dy) == 1 else {
                return .invalidPosition
            }
            if move.dx < 0 {
                guard board[move.from.left()] == nil else {
                    return .blocked
                }
            } else {
                guard board[move.from.right()] == nil else {
                    return .blocked
                }
            }
            return nil
        } else if abs(move.dy) == 2 {
            guard abs(move.dx) == 1 else {
                return .invalidPosition
            }
            if move.dy < 0 {
                guard board[move.from.above()] == nil else {
                    return .blocked
                }
            } else {
                guard board[move.from.below()] == nil else {
                    return .blocked
                }
            }
            return nil
        } else {
            return .invalidPosition
        }
    }
    
    init(_ player: Player) {
        self.player = player
    }
}

