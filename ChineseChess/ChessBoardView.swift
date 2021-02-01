import UIKit
import ChessModel
import SwiftyUtils

class ChessBoardView: UIView {

    
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
            let river = UIBezierPath(rect: CGRect(
                    x: 0, y: 4 * squareSize, width: 8 * squareSize, height: squareSize
            ))
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

    }
}

