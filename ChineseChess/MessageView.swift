import UIKit
import SnapKit

class MessageView : UIView {
    private var label: UILabel!

    var text: String? {
        didSet {
            label.text = text
        }
    }

}