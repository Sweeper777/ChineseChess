class Advisor : Piece {
    
    var player: Player
    
    var description: String {
        "\(player) Advisor"
    }
    
    var localisedDescription: String {
        switch player {
        case .red:
            return "仕"
        case .black:
            return "士"
        }
    }
    
    func validateMove(_ move: Move, in board: Array2D<Piece?>) -> MoveError? {
        let possibleEndLocations: [Position]
        switch player {
        case .black:
            possibleEndLocations = [
                Position(3, 0),
                Position(5, 0),
                Position(4, 1),
                Position(3, 2),
                Position(5, 2),
            ]
        case .red:
            possibleEndLocations = [
                Position(3, 7),
                Position(5, 7),
                Position(4, 8),
                Position(3, 9),
                Position(5, 9),
            ]
        }
        
        guard possibleEndLocations.contains(move.to) else {
            return .invalidPosition
        }
        
        guard abs(move.dx) == 1 && abs(move.dy) == 1 else {
            return .invalidPosition
        }
        
        return nil
    }
    
    func allMoves(from position: Position, in board: Array2D<Piece?>) -> [Move] {
        let xRange = 3...5
        let yRange: ClosedRange<Int>
        switch player {
        case .black:
            yRange = 0...2
        case .red:
            yRange = 7...9
        }
        
        let endPositions = [
            position.above().left(),
            position.above().right(),
            position.below().left(),
            position.below().right(),
        ].filter { xRange.contains($0.x) && yRange.contains($0.y) }
        return endPositions.map { Move(from: position, to: $0) }
    }
    
    init(_ player: Player) {
        self.player = player
    }
}
