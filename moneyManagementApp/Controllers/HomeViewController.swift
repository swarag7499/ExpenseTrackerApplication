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
    var idArray = [String]()
    var expenseAmount = [Float]()
    var incomeAmount = [Float]()
    
    var sumOfExpenses: Float = 0
    var sumOfIncomes: Float = 0
    
    var selectedTransactionId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        sumOfExpense()
        sumOfIncome()
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
                    if let amount = result.value(forKey: "amount") as? Float {
                        self.expenseAmount.append(amount)
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
                    if let amount = result.value(forKey: "amount") as? Float {
                        self.incomeAmount.append(amount)
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
           return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Cause it is necessary to enter amount
        return amountArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TransactionViewCell", owner: self, options: nil)?.first as! TransactionViewCell

        cell.categoryLabel?.text = categoryArray[indexPath.row]
        
        if expanseArray[indexPath.row] == "expense" {
            cell.amountLabel.textColor = UIColor.systemRed
            cell.amountLabel.text = "-\(amountArray[indexPath.row]) ₺"
            
            sumOfExpenses = expenseAmount.reduce(0, {$0 + $1})
            expenseLabel.text = "-\(sumOfExpenses) ₺"
            
            
        } else {
            cell.amountLabel.textColor = UIColor.systemGreen
            cell.amountLabel.text = "+\(amountArray[indexPath.row]) ₺"
            
            sumOfIncomes = incomeAmount.reduce(0, {$0 + $1})
            incomeLabel.text = "+\(sumOfIncomes) ₺"
           
        }
        
        balanceLabel.text = "\(sumOfIncomes - sumOfExpenses) ₺"
        
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedTransactionId = idArray[indexPath.row]
        
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
}
