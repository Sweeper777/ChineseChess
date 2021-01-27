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
    
}

