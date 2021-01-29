class Soldier : Piece {
    
    var player: Player
    
    var description: String {
        "\(player) Soldier"
    }
    
    var localisedDescription: String {
        switch player {
        case .red:
            return "兵"
        case .black:
            return "卒"
        }
    }
    
    func validateMove(_ move: Move, in board: Array2D<Piece?>) -> MoveError? {
        let yBeforeRiver: ClosedRange<Int>
        switch player {
        case .red:
            yBeforeRiver = 5...9
        case .black:
            yBeforeRiver = 0...4
        }
        if move.dy == -1 && move.dx == 0 && player == .red {
            return nil
        }
        if move.dy == 1 && move.dx == 0 && player == .black {
            return nil
        }
        if abs(move.dx) == 1 && move.dy == 0 && !yBeforeRiver.contains(move.from.y) {
            return nil
        }
        return .invalidPosition
    }
    
    
    init(_ player: Player) {
        self.player = player
    }
}


