import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var transactionTableView: UITableView!
    
    // Define arrays
    var categoryArray = [String]()
    var amountArray = [Float]()
    var expanseArray = [String]()
    var idArray = [String?]()
    var expenseAmount = [Float]()
    var incomeAmount = [Float]()
    
    var sumOfExpenses: Float = 0
    var sumOfIncomes: Float = 0
    
    var selectedTransactionId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let matteBackgroundColor = UIColor(red: 44/255, green: 13/255, blue: 71/255, alpha: 0.9)

        
        // Set background color
        view.backgroundColor = matteBackgroundColor

        // Define back button for details view controller

        
        let backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        
        // Home page header
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Home"
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .left
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        // Add pre-created cell to table view
        let cell = UINib(nibName: "TransactionViewCell", bundle: nil)
        self.transactionTableView.register(cell, forCellReuseIdentifier: "TransactionViewCell")
        
        // Must be added for table view usage
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
    
        getData()
        
        // Set background color for the table view
        transactionTableView.backgroundColor = UIColor(red: 44/255, green: 13/255, blue: 71/255, alpha: 1.0)
            
        
        sumOfExpense()
        sumOfIncome()
        
        // Add long press gesture recognizer
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        transactionTableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: transactionTableView)
            if let indexPath = transactionTableView.indexPathForRow(at: touchPoint) {
                // Display alert for confirmation
                let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this transaction?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    self.deleteTransaction(at: indexPath)
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func deleteTransaction(at indexPath: IndexPath) {
        guard let id = idArray[indexPath.row] else { return }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        fetchRequest.predicate = NSPredicate(format: "transactionid = %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let objectToDelete = results.first as? NSManagedObject {
                context.delete(objectToDelete)
                
                // Update data arrays
                idArray.remove(at: indexPath.row)
                categoryArray.remove(at: indexPath.row)
                amountArray.remove(at: indexPath.row)
                expanseArray.remove(at: indexPath.row)
                
                // Reload table view
                transactionTableView.reloadData()
                
                // Update expense and income labels
                sumOfExpense()
                sumOfIncome()
                
                // Update balance label
                let balance = sumOfIncomes - sumOfExpenses
                balanceLabel.text = "\(balance) $"
            }
        } catch {
            print("Error deleting transaction: \(error)")
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as? DetailsViewController
            destinationVC?.chosenTransactionId = selectedTransactionId
        }
    }
    
    // Get data from core data
    @objc func getData(){
        
        // So that data is not written twice
        categoryArray.removeAll(keepingCapacity: false)
        amountArray.removeAll(keepingCapacity: false)
        expanseArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        fetchRequest.returnsObjectsAsFaults = false // This helps to fetch objects faster
        
        do {
            let results =  try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let category = result.value(forKey: "category") as? String {
                        self.categoryArray.append(category)
                    }
                    
                    if let amount = result.value(forKey: "amount") as? Float {
                        self.amountArray.append(amount)
                    }
                    
                    if let expanse = result.value(forKey: "expanse") as? String {
                        self.expanseArray.append(expanse)
                    }
                    
                    if let id = result.value(forKey: "transactionid") as? String {
                        self.idArray.append(id)
                    }
                    
                    self.transactionTableView.reloadData()
                }
            }
        } catch {
            print("Error!")
        }
    }
    
    func sumOfExpense() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        fetchRequest.returnsObjectsAsFaults = false
        
        let filter = "expense"
        let predicate = NSPredicate(format: "expanse = %@", filter)
        fetchRequest.predicate = predicate
        
        do {
            let results =  try context.fetch(fetchRequest)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    if let amount = result.value(forKey: "amount") as? Float,
                       let category = result.value(forKey: "category") as? String {
                        self.expenseAmount.append(amount)
                        self.expanseArray.append(category)
                    }
                }
            }
        } catch {
            print("Error!")
        }
    }
    
    func sumOfIncome() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        fetchRequest.returnsObjectsAsFaults = false
        
        let filter = "income"
        let predicate = NSPredicate(format: "expanse = %@", filter)
        fetchRequest.predicate = predicate
        
        do {
            let results =  try context.fetch(fetchRequest)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    if let amount = result.value(forKey: "amount") as? Float,
                       let category = result.value(forKey: "category") as? String {
                        self.incomeAmount.append(amount)
                        self.expanseArray.append(category)
                    }
                }
            }
        } catch {
            print("Error!")
        }
    }
}


// Table view operations
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Define table view's row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Add some extra space below the cell
        return 64 + 10 // Height of the cell + extra space
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Cause it is necessary to enter amount
        return amountArray.count
    }
    
    // Inside cellForRowAt method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = Bundle.main.loadNibNamed("TransactionViewCell", owner: self, options: nil)?.first as! TransactionViewCell

        cell.categoryLabel?.text = categoryArray[indexPath.row]
        cell.configure(with: expanseArray[indexPath.row], amount: amountArray[indexPath.row])

        return cell
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedTransactionId = idArray[indexPath.row] ?? ""
        
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
}
