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
    
    
    init(_ player: Player) {
        self.player = player
    }
}
