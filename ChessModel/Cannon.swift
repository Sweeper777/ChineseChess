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
    
    func validateMove(_ move: Move, in board: Board) -> MoveError? {
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
            currentPos = directionFunc(currentPos)
            while isValid(currentPos) {
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


