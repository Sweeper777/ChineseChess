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
    
    
    init(_ player: Player) {
        self.player = player
    }
}
