import UIKit
import SwiftyButton

class MainMenuViewController : UIViewController {

    @IBOutlet var twoDButton: PressableButton!
    @IBOutlet var threeDButton: PressableButton!
    
    @IBAction func twoDClick() {
        performSegue(withIdentifier: "show2D", sender: nil)
    }

    @IBAction func threeDClick() {
        performSegue(withIdentifier: "show3D", sender: nil)
    }


}
