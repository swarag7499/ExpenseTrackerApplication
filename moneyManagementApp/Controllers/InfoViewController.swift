import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    var userEmail: String = ""
    var userPassword: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailLabel.text! = userEmail
        passwordLabel.text! = userPassword
        
        // Create a button
        let backButton = UIButton(type: .system)
        backButton.setTitle("Back to Login", for: .normal)
        backButton.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)
        
        // Set button frame and add to view
        backButton.frame = CGRect(x: 20, y: 120, width: 200, height: 40)
        view.addSubview(backButton)
    }
    
    @objc func backToLogin() {
        performSegue(withIdentifier: "toLoginVC", sender: nil)
    }
}
