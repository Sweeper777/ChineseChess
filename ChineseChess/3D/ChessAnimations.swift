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
        animation.duration = animationDuration
        let scnAnimation = SCNAnimation(caAnimation: animation)
        scnAnimation.animationDidStop = { animation, animatable, b in
            if b {
                completion()
            }
        }
        return scnAnimation
    }

    static func selectAnimation(completion: @escaping (Float) -> Void) -> SCNAnimationProtocol {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = 0
        animation.toValue = selectedHeight
        animation.duration = selectAnimationDuration
        let scnAnimation = SCNAnimation(caAnimation: animation)
        scnAnimation.animationDidStop = { animation, animatable, b in
            if b {
                completion(0.5)
            }
        }
        return scnAnimation
    }

    static func deselectAnimation(completion: @escaping (Float) -> Void) -> SCNAnimationProtocol {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = selectedHeight
        animation.toValue = 0
        animation.duration = selectAnimationDuration
        let scnAnimation = SCNAnimation(caAnimation: animation)
        scnAnimation.animationDidStop = { animation, animatable, b in
            if b {
                completion(0)
            }
        }
        return scnAnimation
    }

    static func rotationAnimation(forPiece piece: SCNNode, completion: @escaping (Float) -> Void) -> SCNAnimationProtocol {
        let animation = CABasicAnimation(keyPath: "eulerAngles.y")
        if piece.eulerAngles.y == 0 {
            animation.fromValue = 0
            animation.toValue = Float.pi
        } else {
            animation.fromValue = piece.eulerAngles.y
            animation.toValue = 0.0 as Float
        }
        animation.duration = selectAnimationDuration
        let scnAnimation = SCNAnimation(caAnimation: animation)
        scnAnimation.animationDidStop = { anim, animatable, b in
            if b {
                completion(animation.toValue as! Float)
            }
        }
        return scnAnimation
    }
}