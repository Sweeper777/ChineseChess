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
}