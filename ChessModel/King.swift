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

    var abbreviation: String {
        switch player {
        case .red:
            return "K"
        case .black:
            return "k"
        }
    }
    
    func validateMove(_ move: Move, in board: Board) -> MoveError? {
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
    
    func allMoves(from position: Position, in board: Board) -> [Move] {
        func isValid(_ position: Position) -> Bool {
            if (0..<9).contains(position.x) && (0..<10).contains(position.y) {
                return board[position] == nil
            } else {
                return false
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
        
        var endPositions = [
            position.above(),
            position.below(),
            position.left(),
            position.right(),
        ].filter { xRange.contains($0.x) && yRange.contains($0.y) }
        
        let directionFuncs: [(Position) -> Position] = [
            { $0.above() }, { $0.below() }
        ]
        for directionFunc in directionFuncs {
            var currentPos = directionFunc(position)
            while isValid(currentPos) {
                currentPos = directionFunc(currentPos)
            }
            let pieceFound = board[currentPos]
            if pieceFound?.player == self.player.opponent &&
                pieceFound is King {
                endPositions.append(currentPos)
            }
        }
        
        return endPositions.map { Move(from: position, to: $0) }
    }
    
    init(_ player: Player) {
        self.player = player
    }
}
