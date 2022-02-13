import UIKit

class EventDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var event: Event!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    init?(coder: NSCoder, event: Event) {
        self.event = event
        super.init(coder: coder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    func update() {
        let startEventString = dateFormatter.string(from: event.dateStart)
        dateFormatter.dateStyle = .none
        let endEventString = dateFormatter.string(from: event.dateEnd)
        
        titleLabel.text = event.name
        dateLabel.text = "\(startEventString) - \(endEventString)"
        descriptionLabel.text = event.description
    }

}
