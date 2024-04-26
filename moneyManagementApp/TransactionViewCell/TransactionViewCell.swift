import UIKit

class TransactionViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    // Padding constants
    let padding: CGFloat = 10 // Padding value
    let cornerRadius: CGFloat = 25 // Corner radius value
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.black // Change the background color to black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with transactionType: String, amount: Float) {
        contentView.backgroundColor = UIColor.systemPink // Change background color to pink
        
        if transactionType == "expense" {
            amountLabel.textColor = .white
        } else {
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
