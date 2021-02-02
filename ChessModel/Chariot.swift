class Chariot : Piece {
    
    var player: Player
    
    var description: String {
        "\(player) Chariot"
    }
    
    var localisedDescription: String {
        switch player {
        case .red:
            return "俥"
        case .black:
            return "車"
        }
    }
    
    func validateMove(_ move: Move, in board: Board) -> MoveError? {
        if abs(move.dx) > 0 && abs(move.dy) > 0 {
            return .invalidPosition
        }
        
        let blocked: Bool
        if abs(move.dx) > 0 {
            let start = min(move.from.x, move.to.x)
            let end = max(move.from.x, move.to.x)
            blocked = ((start + 1)..<end).contains(where: {
                board[Position($0, move.from.y)] != nil
            })
        } else {
            let start = min(move.from.y, move.to.y)
            let end = max(move.from.y, move.to.y)
            blocked = ((start + 1)..<end).contains(where: {
                board[Position(move.from.x, $0)] != nil
            })
        }
        if blocked {
            return .invalidPosition
        } else {
            return nil
        }
    }
    
    func allMoves(from position: Position, in board: Board) -> [Move] {
        func isValid(_ position: Position) -> Bool {
            if let piece = board[safe: position] {
                return piece == nil
            } else {
                return false
            }
        }
        
        let directionFuncs: [(Position) -> Position] = [
            { $0.above() }, { $0.below() }, { $0.left() }, { $0.right() }
        ]
        var endPositions = [Position]()
        for directionFunc in directionFuncs {
            var currentPos = directionFunc(position)
            while isValid(currentPos) {
                endPositions.append(currentPos)
                currentPos = directionFunc(currentPos)
            }
            if (board[safe: currentPos] as? Piece)?.player == self.player.opponent {
                endPositions.append(currentPos)
            }
        }
        
        return endPositions.map { Move(from: position, to: $0) }
    }
    
    init(_ player: Player) {
        self.player = player
    }
}

