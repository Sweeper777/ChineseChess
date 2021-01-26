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
    
    
    init(_ player: Player) {
        self.player = player
    }
}


