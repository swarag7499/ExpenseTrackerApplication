import UIKit
import CoreData

class AddTransactionViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var attachLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    var moneySpend: String = ""
    var tid = UUID().uuidString.lowercased()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // These views are invisible at the start
        datePicker.isHidden = true
        imageView.isHidden = true
        
        // Select date from date picker
        pickDate()
        
        // Add photos from library
        attachLabel.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        attachLabel.addGestureRecognizer(imageTapRecognizer)
        
        addButton.isEnabled = false // Button not enabled at the start
        
        amountTextField.addTarget(self, action: #selector(checkButtonAvailability), for: .editingChanged)
        categoryTextField.addTarget(self, action: #selector(checkButtonAvailability), for: .editingChanged)
        
        // Income segment does not have image adding option
        segmentControl.addTarget(self, action: #selector(switchSegments), for: .valueChanged)
    }
    
    @objc func switchSegments() {
        switch segmentControl.selectedSegmentIndex {
            case 0: // Expense
                attachLabel.isEnabled = true
                attachLabel.isUserInteractionEnabled = true
            case 1: // Income
                attachLabel.isEnabled = false
                attachLabel.isUserInteractionEnabled = false
                imageView.isHidden = true
            default:
                break
        }
    }
    
    // User must enter amount and category for transaction info.
    @objc func checkButtonAvailability(){
        if amountTextField.text!.isEmpty || categoryTextField.text!.isEmpty {
            addButton.isEnabled = false
        } else {
            addButton.isEnabled = true
        }
    }
    
    func pickDate() {
        datePicker.addTarget(self, action: #selector(updateDate), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        dateTextField.addGestureRecognizer(tapGesture)
    }
    
    @objc func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        dateTextField.text = selectedDate
        datePicker.endEditing(true)
        datePicker.isHidden = true // Hide date picker after selecting date
    }
    
    // Do not show date picker before selecting other values
    @objc func showDatePicker() {
        datePicker.isHidden = false
    }
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        imageView.isHidden = false
        self.imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveTransactionInfo() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newTransaction = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: context)
        
        // Attributes
        newTransaction.setValue(dateTextField.text!, forKey: "date")
        newTransaction.setValue(categoryTextField.text!, forKey: "category")
        newTransaction.setValue(noteTextField.text!, forKey: "note")
        
        // Convert to float
        if let amount = Float(amountTextField.text!) {
            newTransaction.setValue(amount, forKey: "amount")
        }
        
        if segmentControl.selectedSegmentIndex == 0 {
            newTransaction.setValue("expense", forKey: "expanse")
        } else {
            newTransaction.setValue("income", forKey: "expanse")
        }
        
        newTransaction.setValue(tid, forKey: "transactionid")
        
        // Add receipt image
        let image = imageView.image!.jpegData(compressionQuality: 0.5)
        newTransaction.setValue(image, forKey: "image")
        
        // Check whether the save was successful
        do {
            try context.save()
            print("Transaction information saved successfully!")
            
        } catch {
            print("An error occurred while saving transaction information!")
        }
    }
    
    // Save transaction info and segue to home or show message to perform segue or add new transactions
    @IBAction func addTransaction(_ sender: Any) {

        saveTransactionInfo()
        
        performSegue(withIdentifier: "toAddHomeVC", sender: nil)
    }
    
    @IBAction func segmentedSwitcher(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            moneySpend = "expense"
        } else {
            moneySpend = "income"
        }
    }
}
