import UIKit
import SnapKit

class LaunchViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("LOG: Launch Screen")
        
        AppManager.shared.appContainer = self
        AppManager.shared.showApp()
    }

}
