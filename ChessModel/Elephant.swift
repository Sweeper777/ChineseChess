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
    
    func validateMove(_ move: Move, in board: Array2D<Piece?>) -> MoveError? {
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
    
    
    init(_ player: Player) {
        self.player = player
    }
}
