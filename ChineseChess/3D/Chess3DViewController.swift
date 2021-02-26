import UIKit
import SceneKit

class Chess3DViewController : UIViewController {
    @IBOutlet var sceneView: SCNView!

    var scene: ChineseChessScene!

    override func viewDidLoad() {
        scene = ChineseChessScene()
        scene.setup()
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .black
        sceneView.showsStatistics = true
        sceneView.backgroundColor = .white
        sceneView.pointOfView = scene.cameraNode
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        if let point = touches.first?.location(in: sceneView) {
            let results = sceneView.hitTest(point)
            if let firstResult = results.first(where: { $0.node.name == "piece" }) {
                let scenePos = firstResult.worldCoordinates
                let boardPos = scenePosToBoardPos(scenePos)
                scene.didTapBoardPos(boardPos, nodeTapped: firstResult.node)
            }
        }
    }
}