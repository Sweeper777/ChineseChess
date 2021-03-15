import UIKit
import SwiftyButton

class MainMenuViewController : UIViewController {

    @IBOutlet var twoDButton: PressableButton!
    @IBOutlet var threeDButton: PressableButton!
    
    override func viewDidLoad() {
        twoDButton.colors = .init(button: .brown, shadow: UIColor.brown.darker())
        threeDButton.colors = .init(button: UIColor.green.darker(), shadow: UIColor.green.darker().darker())
    }
    
    @IBAction func twoDClick() {
        performSegue(withIdentifier: "show2D", sender: nil)
    }

    @IBAction func threeDClick() {
        performSegue(withIdentifier: "show3D", sender: nil)
    }


}
