import UIKit
import ChessModel
import SwiftyUtils

class ChessBoardView: UIView {

    var board: Board? {
        didSet {
            setNeedsDisplay()
        }
    }

    var selectedPosition: Position? {
        didSet {
            setNeedsDisplay()
        }
    }

    var selectablePositions: [Position] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    var selectablePositionsColor: UIColor = .label {
        didSet {
            setNeedsDisplay()
        }
    }

    var previousLocation: Position? {
        didSet {
            setNeedsDisplay()
        }
    }

    var previousLocationColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    weak var delegate: ChessBoardViewDelegate?
    
    override func draw(_ rect: CGRect) {
        let squareSize = width / 9
        let path = UIBezierPath()
        let strokeWidth = squareSize / 20

        func drawBlackSide() {
            for x in 0..<8 {
                for y in 0..<4 {
                    let square = UIBezierPath(rect: CGRect(
                            x: x.f * squareSize,
                            y: y.f * squareSize,
                            width: squareSize,
                            height: squareSize
                    ))
                    path.append(square)
                }
            }
        }

        func drawRiver() {
            let riverRect = CGRect(
                    x: 0, y: 4 * squareSize, width: 8 * squareSize, height: squareSize
            )
            let transformedRiverRect = riverRect.applying(
                    CGAffineTransform(translationX: squareSize / 2, y: squareSize / 2)
            ).insetBy(dx: 0, dy: riverRect.height * 0.1)
            let riverText = "楚河　　　汉界" as NSString
            let sealScriptFont = UIFont(name: "FZXiaoZhuanTi-S13T", size: 10)!
            let fontSize = fontSizeThatFits(
                    size: transformedRiverRect.size,
                    text: riverText,
                    font: sealScriptFont
            )
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.alignment = .center
            riverText.draw(in: transformedRiverRect, withAttributes: [
                .font: sealScriptFont.withSize(fontSize),
                .foregroundColor: UIColor.label,
                .paragraphStyle: paraStyle
            ])

            let river = UIBezierPath(rect: riverRect)
            path.append(river)
        }

        func drawRedSide() {
            for x in 0..<8 {
                for y in 5..<9 {
                    let square = UIBezierPath(rect: CGRect(
                            x: x.f * squareSize,
                            y: y.f * squareSize,
                            width: squareSize,
                            height: squareSize
                    ))
                    path.append(square)
                }
            }
        }

        func drawPalaces() {
            let palaces = UIBezierPath()

            palaces.move(to: CGPoint(x: 3 * squareSize, y: 0))
            palaces.addLine(to: CGPoint(x: 5 * squareSize, y: 2 * squareSize))
            palaces.move(to: CGPoint(x: 5 * squareSize, y: 0))
            palaces.addLine(to: CGPoint(x: 3 * squareSize, y: 2 * squareSize))

            palaces.move(to: CGPoint(x: 3 * squareSize, y: 7 * squareSize))
            palaces.addLine(to: CGPoint(x: 5 * squareSize, y: 9 * squareSize))
            palaces.move(to: CGPoint(x: 5 * squareSize, y: 7 * squareSize))
            palaces.addLine(to: CGPoint(x: 3 * squareSize, y: 9 * squareSize))

            path.append(palaces)
        }
        
        func drawMarkingAt(x: Int, y: Int) -> UIBezierPath {
            let markingOffset = squareSize / 10
            let markingLength = squareSize / 5
            let path = UIBezierPath()
            if x < 8 {
                // top right
                path.move(to: CGPoint(x: x.f * squareSize + markingOffset, y: y.f * squareSize - markingOffset - markingLength))
                path.addLine(to: CGPoint(x: x.f * squareSize + markingOffset, y: y.f * squareSize - markingOffset))
                path.addLine(to: CGPoint(x: x.f * squareSize + markingOffset + markingLength, y: y.f * squareSize - markingOffset))
                
                // bottom right
                path.move(to: CGPoint(x: x.f * squareSize + markingOffset, y: y.f * squareSize + markingOffset + markingLength))
                path.addLine(to: CGPoint(x: x.f * squareSize + markingOffset, y: y.f * squareSize + markingOffset))
                path.addLine(to: CGPoint(x: x.f * squareSize + markingOffset + markingLength, y: y.f * squareSize + markingOffset))
            }
            
            if x > 0 {
                // top left
                path.move(to: CGPoint(x: x.f * squareSize - markingOffset, y: y.f * squareSize - markingOffset - markingLength))
                path.addLine(to: CGPoint(x: x.f * squareSize - markingOffset, y: y.f * squareSize - markingOffset))
                path.addLine(to: CGPoint(x: x.f * squareSize - markingOffset - markingLength, y: y.f * squareSize - markingOffset))
                
                // bottom left
                path.move(to: CGPoint(x: x.f * squareSize - markingOffset, y: y.f * squareSize + markingOffset + markingLength))
                path.addLine(to: CGPoint(x: x.f * squareSize - markingOffset, y: y.f * squareSize + markingOffset))
                path.addLine(to: CGPoint(x: x.f * squareSize - markingOffset - markingLength, y: y.f * squareSize + markingOffset))
            }
            
            return path
        }

        func drawMarkings() {
            path.append(drawMarkingAt(x: 1, y: 2))
            path.append(drawMarkingAt(x: 7, y: 2))
            path.append(drawMarkingAt(x: 1, y: 7))
            path.append(drawMarkingAt(x: 7, y: 7))
            for x in stride(from: 0, through: 8, by: 2) {
                path.append(drawMarkingAt(x: x, y: 3))
                path.append(drawMarkingAt(x: x, y: 6))
            }
        }

        drawBlackSide()
        drawRedSide()
        drawRiver()
        drawPalaces()
        drawMarkings()
        
        path.apply(CGAffineTransform(translationX: squareSize / 2, y: squareSize / 2))
        path.lineWidth = strokeWidth
        UIColor.label.setStroke()
        path.stroke()

        func calculateFontSize() -> CGFloat {
            fontSizeThatFits(
                    size: CGSize(width: squareSize / 2,
                    height: squareSize / 2), text: "将",
                    font: UIFont.systemFont(ofSize: 1)
            )
        }

        func calculateOffset(withFont font: UIFont) -> CGPoint {
            let sizeWithFont = ("将" as NSString).size(withAttributes: [.font: font])
            return CGPoint(
                    x: (squareSize - sizeWithFont.width) / 2,
                    y: (squareSize - sizeWithFont.height) / 2
            )
        }

        func center(forPosition position: Position) -> CGPoint {
            CGPoint(
                    x: position.x.f * squareSize,
                    y: position.y.f * squareSize
            ).applying(CGAffineTransform(translationX: squareSize / 2, y: squareSize / 2))
        }

        func drawChessPiece(_ piece: Piece, at position: Position, font: UIFont, offset: CGPoint, isSelected: Bool) {
            let pieceName = piece.localisedDescription
            let backgroundColor = piece.player == .red ? UIColor(named: "redPieceBackground")! : UIColor(named: "blackPieceBackground")!
            let centerOfPiece = center(forPosition: position)
            let circlePath = UIBezierPath(
                    ovalIn: CGRect(origin: centerOfPiece, size: .zero)
                            .insetBy(dx: -squareSize * 0.4, dy: -squareSize * 0.4)
            )
            circlePath.lineWidth = strokeWidth * 1.2

            if isSelected {
                UIColor(named: "selectedBorderColor")!.setStroke()
            } else {
                UIColor.label.setStroke()
            }
            backgroundColor.setFill()
            circlePath.fill()
            circlePath.stroke()

            (pieceName as NSString).draw(at: CGPoint(
                    x: position.x.f * squareSize + offset.x,
                    y: position.y.f * squareSize + offset.y
            ), withAttributes: [.font: font, .foregroundColor: UIColor.white])
        }

        func drawPreviousLocation(_ position: Position) {
            let centerOfPiece = center(forPosition: position)
            let circlePath = UIBezierPath(
                    ovalIn: CGRect(origin: centerOfPiece, size: .zero)
                            .insetBy(dx: -squareSize * 0.4, dy: -squareSize * 0.4)
            )
            circlePath.lineWidth = strokeWidth * 1.2
            let pattern = [strokeWidth * 4, strokeWidth]
            circlePath.setLineDash(pattern, count: 2, phase: 0)
            previousLocationColor?.setStroke()
            circlePath.stroke()
        }

        let fontSize = calculateFontSize()
        let font = UIFont.systemFont(ofSize: fontSize)
        let offset = calculateOffset(withFont: font)

        guard let board = board else {
            return
        }

        for x in 0..<9 {
            for y in 0..<10 {
                let pos = Position(x, y)
                if let piece = board.piece(at: pos) {
                    drawChessPiece(piece, at: pos, font: font, offset: offset, isSelected: selectedPosition == pos)
                }
            }
        }

        if let prevLoc = previousLocation {
            drawPreviousLocation(prevLoc)
        }

        func drawSelectablePositions() {
            for pos in selectablePositions {
                let dotRect = CGRect(origin: center(forPosition: pos), size: .zero)
                                .insetBy(dx: -squareSize / 5, dy: -squareSize / 5)
                let path = UIBezierPath(ovalIn: dotRect)
                selectablePositionsColor.setFill()
                path.fill()
            }
        }

        drawSelectablePositions()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        let squareSize = width / 9
        let touchLocation = touch.location(in: self)
        let x = Int(touchLocation.x / squareSize)
        let y = Int(touchLocation.y / squareSize)
        delegate?.didTapPosition(Position(x, y))
    }

    func deselectAll() {
        selectedPosition = nil
        selectablePositions = []
    }
}

protocol ChessBoardViewDelegate : class {
    func didTapPosition(_ position: Position)
}