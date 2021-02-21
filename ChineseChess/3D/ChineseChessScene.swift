import SceneKit

class ChineseChessScene: SCNScene {
    var cameraNode: SCNNode!

    func setup() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 0)
        cameraNode.eulerAngles.y = -.pi / 2
    }
}