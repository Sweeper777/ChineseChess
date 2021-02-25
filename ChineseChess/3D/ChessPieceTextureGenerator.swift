import UIKit
import ChessModel
import SceneKit

enum ChessPieceTextureGenerator {
    private static var textureCache: [String: UIImage] = [:]

    static func texture(for chessPiece: Piece) -> UIImage {
        if let cached = textureCache[chessPiece.description] {
            return cached
        }

        let size = 500
        let textSize = 400
        let offset = (size - textSize) / 2

        let fontSize = fontSizeThatFits(size: CGSize(width: textSize, height: textSize), text: chessPiece.localisedDescription as NSString, font: UIFont.systemFont(ofSize: 0))
        UIGraphicsBeginImageContext(CGSize(width: size, height: size))
        (chessPiece.player == .red ? UIColor(named: "redPieceBackground") : UIColor(named: "blackPieceBackground"))!
            .setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size, height: size))
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .center
        (chessPiece.localisedDescription as NSString).draw(in: CGRect(x: offset, y: offset, width: textSize, height: textSize), withAttributes: [
            .font: UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paraStyle
        ])
        let context = UIGraphicsGetCurrentContext()!
        context.scaleBy(x: -1, y: 1)
        context.translateBy(x: -size.f, y: 0)
        let image = UIGraphicsGetImageFromCurrentImageContext()!.flipImage()!
        textureCache[chessPiece.description] = image
        return image
    }

    static func materials(for chessPiece: Piece) -> [SCNMaterial] {
        let color = chessPiece.player == .red ? UIColor(named: "redPieceBackground") : UIColor(named: "blackPieceBackground")
        let topFace = texture(for: chessPiece)
        let topFaceMaterial = SCNMaterial()
        topFaceMaterial.diffuse.contents = topFace
        topFaceMaterial.specular.contents = UIColor.white
        topFaceMaterial.shininess = 1
        let bottomFaceMaterial = SCNMaterial()
        bottomFaceMaterial.diffuse.contents = color
        bottomFaceMaterial.specular.contents = UIColor.white
        bottomFaceMaterial.shininess = 1
        return [bottomFaceMaterial, topFaceMaterial, bottomFaceMaterial]
    }

}

extension UIImage {
    func flipImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let bitmap = UIGraphicsGetCurrentContext()!

        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        bitmap.scaleBy(x: -1.0, y: -1.0)

        bitmap.translateBy(x: -size.width / 2, y: -size.height / 2)
        bitmap.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}