class King : Piece {
    
    var player: Player
    
    var description: String {
        "\(player) King"
    }
    
    var localisedDescription: String {
        switch player {
        case .red:
            return "帥"
        case .black:
            return "將"
        }
    }
    
    func validateMove(_ move: Move, in board: Array2D<Piece?>) -> MoveError? {
        if move.dx == 0 && (board[move.to] as? King)?.player == self.player.opponent {
            let startY = min(move.from.y, move.to.y)
            let endY = max(move.from.y, move.to.y)
            let blocked = ((startY + 1)..<endY).contains(where: {
                board[Position(move.from.x, $0)] != nil
            })
            if !blocked {
                return nil
            }
        }
        
        let xRange = 3...5
        let yRange: ClosedRange<Int>
        switch player {
        case .black:
            yRange = 0...2
        case .red:
            yRange = 7...9
        }
        guard xRange.contains(move.to.x) && yRange.contains(move.to.y) else {
            return .invalidPosition
        }
        guard (abs(move.dx) == 1 && move.dy == 0) || (move.dx == 0 && abs(move.dy) == 1) else {
            return .invalidPosition
        }
        return nil
    }
    
}
