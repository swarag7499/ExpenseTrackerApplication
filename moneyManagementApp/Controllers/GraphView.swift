import UIKit

class PieChartView: UIView {
    // Data points for the pie chart
    var dataPoints: [CGFloat] = []
    let colors: [UIColor]
    
    private var selectedSliceIndex: Int?
    
    // Selection handler closure
    var selectionHandler: ((Int, CGFloat) -> Void)?
    
    var sliceLabels: [UILabel] = []
    
    init(frame: CGRect, dataPoints: [CGFloat], colors: [UIColor]) {
        self.dataPoints = dataPoints
        self.colors = colors
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard UIGraphicsGetCurrentContext() != nil else { return }
        
        // Calculate total value of data points
        let total = dataPoints.reduce(0, +)
        
        // Define center and radius for the pie chart
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        // Draw thick white border for the entire pie chart
        let borderPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        UIColor.white.setStroke()
        borderPath.lineWidth = 10
        borderPath.stroke()
        
        // Set the starting angle
        var startAngle: CGFloat = -CGFloat.pi / 2
        
        // Draw each slice of the pie chart
        for (index, value) in dataPoints.enumerated() {
            let endAngle = startAngle + 2 * CGFloat.pi * (value / total)
            
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            
            // Draw thick white border for each slice
            UIColor.white.setStroke()
            path.lineWidth = 9
            path.stroke()
            
            colors[index % colors.count].setFill()
            path.fill()
            
            // Draw slice labels
            let sliceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
            sliceLabel.textAlignment = .right
            sliceLabel.textColor = UIColor.black
            sliceLabel.font = UIFont.systemFont(ofSize: 18)
            sliceLabel.text = String(format: "%.0f%%", (value / total) * 100)
            sliceLabel.sizeToFit()
            
            // Position label
            let labelRadius = radius * 0.75
            let labelAngle = startAngle + (endAngle - startAngle) / 2
            let x = center.x + labelRadius * cos(labelAngle)
            let y = center.y + labelRadius * sin(labelAngle)
            sliceLabel.center = CGPoint(x: x, y: y)
            addSubview(sliceLabel)
            sliceLabels.append(sliceLabel)
            
            startAngle = endAngle
        }
    }
}
