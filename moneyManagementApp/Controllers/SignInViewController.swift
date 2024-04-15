import UIKit
import CoreData

class SignInViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var userId: String = ""
    let transIndexViewController = 1
    let profileIndexViewController = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation operations are done in the view controller that will return
        let backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if checkInfo() {
            // perform segue
            self.performSegue(withIdentifier: "toTabBar", sender: nil)
            UserDefaults.standard.removeObject(forKey:"isLogin")
            UserDefaults.standard.set(true, forKey: "isLogin")
            UserDefaults.standard.set(userId, forKey: "id") // set user id to default db
        } else {
            // show alert message
            makeAlert(titleInput: "An Error Occurred!", messageInput: "Please re-enter your account information.")
        }
    }
    
    // perform segue to sign up view controller.
    @IBAction func signUpClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSignUpVC", sender: nil)
    }
    
    // check if email and passwords are compatible with each other
    func checkInfo() -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email = %@ AND password = %@", self.emailTextField.text!, self.passwordTextField.text!)
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.count > 0 {
                // If there's a match, set the user ID and return true
                if let user = result.first as? NSManagedObject {
                    userId = user.value(forKey: "userid") as? String ?? ""
                }
                return true
            } else {
                // If not matched, return false
                return false
            }
        } catch {
            print("Failed to fetch user: \(error)")
            return false
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in print("Button clicked")}
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

