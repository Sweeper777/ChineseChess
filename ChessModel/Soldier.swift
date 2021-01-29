class Soldier : Piece {
    
    var player: Player
    
    var description: String {
        "\(player) Soldier"
    }
    
    
    init(_ player: Player) {
        self.player = player
    }
}


