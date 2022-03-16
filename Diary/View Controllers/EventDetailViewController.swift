import UIKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var event: Event!

    var events = [Event]()

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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let saveEvents = Event.loadEvents() {
            events = saveEvents
        } else {
            events = Event.loadSampleEvent()
        }

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

// MARK: - Navigation

    @IBSegueAction func changeEvent(_ coder: NSCoder, sender: Any?) -> AddEditEventTableViewController? {
        return AddEditEventTableViewController(coder: coder, event: event)
    }

    @IBAction func unwindToNewEvent(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddEditEventTableViewController,
              let event = sourceViewController.event else {
                  return
              }

        if let indexEvent = events.firstIndex(where: { $0.id == event.id }) {
            events[indexEvent] = event
            self.event = event
            update()
        }

        Event.saveEvents(events)
    }

}
