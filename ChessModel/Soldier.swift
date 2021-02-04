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

    var abbreviation: String {
        switch player {
        case .red:
            return "P"
        case .black:
            return "p"
        }
    }

    func validateMove(_ move: Move, in board: Board) -> MoveError? {
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
    
    func allMoves(from position: Position, in board: Board) -> [Move] {
        var endPositions = [Position]()
        let yBeforeRiver: ClosedRange<Int>
        switch player {
        case .red:
            yBeforeRiver = 5...9
            endPositions.append(position.above())
        case .black:
            yBeforeRiver = 0...4
            endPositions.append(position.below())
        }
        if !yBeforeRiver.contains(position.y) {
            endPositions.append(position.left())
            endPositions.append(position.right())
        }
        return endPositions.map { Move(from: position, to: $0) }
    }
    
    init(_ player: Player) {
        self.player = player
    }
}


