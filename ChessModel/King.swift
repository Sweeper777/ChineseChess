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
    
}
