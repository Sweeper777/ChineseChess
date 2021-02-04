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

    var abbreviation: String {
        switch player {
        case .red:
            return "N"
        case .black:
            return "n"
        }
    }
    
    func validateMove(_ move: Move, in board: Board) -> MoveError? {
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
    
    func allMoves(from position: Position, in board: Board) -> [Move] {
        var endPositions = [Position]()
        let above = position.above()
        if board[above] == nil {
            endPositions.append(above.above().left())
            endPositions.append(above.above().right())
        }
        let below = position.below()
        if board[below] == nil {
            endPositions.append(below.below().left())
            endPositions.append(below.below().right())
        }
        let left = position.left()
        if board[left] == nil {
            endPositions.append(left.left().above())
            endPositions.append(left.left().below())
        }
        let right = position.right()
        if board[right] == nil {
            endPositions.append(right.right().above())
            endPositions.append(right.right().below())
        }
        
        return endPositions.map { Move(from: position, to: $0) }
    }
    
    init(_ player: Player) {
        self.player = player
    }
}

