class Elephant : Piece {
    
    var player: Player
    
    var description: String {
        "\(player) Elephant"
    }
    
    var localisedDescription: String {
        switch player {
        case .red:
            return "相"
        case .black:
            return "象"
        }
    }
    
    func validateMove(_ move: Move, in board: Board) -> MoveError? {
        let possibleEndLocations: [Position]
        switch player {
        case .black:
            possibleEndLocations = [
                Position(2, 0),
                Position(6, 0),
                Position(0, 2),
                Position(2, 4),
                Position(4, 2),
                Position(8, 2),
                Position(6, 4),
            ]
        case .red:
            possibleEndLocations = [
                Position(2, 9),
                Position(6, 9),
                Position(0, 7),
                Position(2, 5),
                Position(4, 7),
                Position(8, 7),
                Position(6, 5),
            ]
        }
        
        guard possibleEndLocations.contains(move.to) else {
            return .invalidPosition
        }
        
        guard abs(move.dx) == 2 && abs(move.dy) == 2 else {
            return .invalidPosition
        }
        
        let elephantsEye = Position((move.to.x + move.from.x) / 2, (move.to.y + move.from.y) / 2)
        guard board[elephantsEye] == nil else {
            return .blocked
        }
        
        return nil
    }
    
    func allMoves(from position: Position, in board: Board) -> [Move] {
        let yBeforeRiver: ClosedRange<Int>
        switch player {
        case .red:
            yBeforeRiver = 5...9
        case .black:
            yBeforeRiver = 0...4
        }
        
        let dxDys = [
            (dx: 1, dy: 1),
            (dx: 1, dy: -1),
            (dx: -1, dy: 1),
            (dx: -1, dy: -1),
        ]
        var endPositions = [Position]()
        for dxDy in dxDys {
            let eyePos = Position(position.x + dxDy.dx, position.y + dxDy.dy)
            if (board[safe: eyePos] as? Piece) == nil {
                endPositions.append(Position(position.x + dxDy.dx * 2, position.y + dxDy.dy * 2))
            }
        }
        return endPositions.filter { yBeforeRiver.contains($0.y) }.map { Move(from: position, to: $0) }
    }
    
    init(_ player: Player) {
        self.player = player
    }
}
