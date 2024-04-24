import UIKit

class TransactionViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    // Padding constants
    let padding: CGFloat = 10 // Padding value
    let cornerRadius: CGFloat = 12 // Corner radius value
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with transactionType: String, amount: Float) {
        if transactionType == "expense" {
            contentView.backgroundColor = UIColor(red: 237/255, green: 9/255, blue: 120/255, alpha: 1.0) // Expense color: #ed0978
            amountLabel.textColor = .white
        } else {
            contentView.backgroundColor = UIColor(red: 251/255, green: 109/255, blue: 11/255, alpha: 1.0) // Income color: #fb6d0b
            amountLabel.textColor = .white
        }
        
        categoryLabel.text = transactionType
        amountLabel.text = "\(transactionType == "expense" ? "-" : "+")\(amount) $"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Adjust frame to include padding
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0))
    }
}
