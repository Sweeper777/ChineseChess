public class Game {
    var board = Array2D<Piece?>(columns: 9, rows: 10, initialValue: nil)
    public var currentPlayer = Player.red
    
    public init() {
    }
    
}
