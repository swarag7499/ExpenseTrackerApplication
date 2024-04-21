import UIKit
import CoreData

class GraphViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch expense and income amounts from Core Data
        let (expenseAmount, incomeAmount) = fetchExpenseAndIncomeAmounts()
        
        // Calculate the total su
        let totalSum = expenseAmount + incomeAmount
        
        // Calculate the percentage of each category
        let expensePercentage = CGFloat(expenseAmount / totalSum)
        let incomePercentage = CGFloat(incomeAmount / totalSum)
        
        // Create a view to draw the pie chart
        let pieChartView = PieChartView(frame: CGRect(x: 45, y: 200, width: 300, height: 300),
                                        dataPoints: [expensePercentage, incomePercentage],
                                        colors: [.red, .green])
        view.addSubview(pieChartView)
    }
    
    // Function to fetch expense and income amounts from Core Data
    func fetchExpenseAndIncomeAmounts() -> (Float, Float) {
        var totalExpense: Float = 0
        var totalIncome: Float = 0
        
        // Fetch expense amounts
        let expenseResults = fetchTransactionData(for: "expense")
        for result in expenseResults {
            if let amount = result.value(forKey: "amount") as? Float {
                totalExpense += amount
            }
        }
        
        // Fetch income amounts
        let incomeResults = fetchTransactionData(for: "income")
        for result in incomeResults {
            if let amount = result.value(forKey: "amount") as? Float {
                totalIncome += amount
            }
        }
        
        return (totalExpense, totalIncome)
    }
    
    // Function to fetch transaction data from Core Data based on the expense type
    func fetchTransactionData(for expenseType: String) -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        fetchRequest.predicate = NSPredicate(format: "expanse = %@", expenseType)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results as! [NSManagedObject]
        } catch {
            print("Error fetching transaction data: \(error)")
            return []
        }
    }
}
