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
    
    
    init(_ player: Player) {
        self.player = player
    }
}

