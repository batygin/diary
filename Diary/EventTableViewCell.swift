import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameEventLabel: UILabel!
    
    var event: Event?
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .short
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with event: Event) {
//        timeLabel.text = dateFormatter.string(from: event.dateStart)
        timeLabel.text = dateFormatter.string(from: event.dateStart)
        nameEventLabel.text = event.name
    }

}
