import UIKit

class MainMenuViewController : UIViewController {

    @IBAction func twoDClick() {
        performSegue(withIdentifier: "show2D", sender: nil)
    }

    @IBAction func threeDClick() {
        performSegue(withIdentifier: "show3D", sender: nil)
    }


}