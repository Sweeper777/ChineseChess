import SceneKit
import ChessModel

enum ChessAnimations {

    private static let selectedHeight: Float = 0.5
    private static let animationDuration = 0.5
    private static let selectAnimationDuration = 0.2

    static func animation(from move: Move, isAlreadySelected: Bool, completion: @escaping (SCNVector3) -> Void) -> SCNAnimationProtocol {
        let animation = CAKeyframeAnimation(keyPath: "position")
        let startPos = boardPosToScenePos(move.from)
        let endPos = boardPosToScenePos(move.to)
        if isAlreadySelected {
            animation.values = [
                SCNVector3(startPos.x, selectedHeight, startPos.z),
                SCNVector3(endPos.x, selectedHeight, endPos.z),
                endPos
            ]
        } else {
            animation.values = [
                startPos,
                SCNVector3(startPos.x, selectedHeight, startPos.z),
                SCNVector3(endPos.x, selectedHeight, endPos.z),
                endPos
            ]
        }
        animation.duration = animationDuration
        let scnAnimation = SCNAnimation(caAnimation: animation)
        scnAnimation.animationDidStop = { animation, animatable, b in
            if b {
                completion(endPos)
            }
        }
        return scnAnimation
    }

    static func fadeAnimation(completion: @escaping () -> Void) -> SCNAnimationProtocol {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = 0.5
        let scnAnimation = SCNAnimation(caAnimation: animation)
        scnAnimation.animationDidStop = { animation, animatable, b in
            completion()
        }
        return scnAnimation
    }
}