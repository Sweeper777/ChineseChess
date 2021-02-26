import SceneKit
import ChessModel

enum ChessAnimations {
    static func animation(from move: Move, completion: @escaping () -> Void) -> SCNAnimationProtocol {
        let animation = CAKeyframeAnimation(keyPath: "position")
        let startPos = boardPosToScenePos(move.from)
        let endPos = boardPosToScenePos(move.to)
        animation.values = [
            startPos,
            SCNVector3(startPos.x, 0.5, startPos.z),
            SCNVector3(endPos.x, 0.5, endPos.z),
            endPos
        ]
        animation.duration = 0.5
        let scnAnimation = SCNAnimation(caAnimation: animation)
        scnAnimation.animationDidStop = { animation, animatable, b in
            completion()
        }
        return scnAnimation
    }

}