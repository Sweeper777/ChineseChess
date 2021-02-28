import UIKit
import SnapKit

class MessageView : UIView {
    private var label: UILabel!

    var text: String? {
        didSet {
            label.text = text
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        layer.borderWidth = 3
        layer.borderColor = UIColor.label.cgColor
        backgroundColor = .systemBackground

        label = UILabel(frame: bounds)
        label.numberOfLines = 0

        addSubview(label)

        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.lessThanOrEqualTo(300)
        }
    }
}