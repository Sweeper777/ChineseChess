public struct Move : Equatable, CustomStringConvertible {
    public let from: Position
    public let to: Position
    
    public var dx: Int {
        to.x - from.x
    }
    
    public var dy: Int {
        to.y - from.y
    }
    
    public var description: String {
        "Move from \(from) to \(to)"
    }
}
