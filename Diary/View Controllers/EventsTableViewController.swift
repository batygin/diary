import UIKit
import RealmSwift

// swiftlint:disable force_try

class EventsTableViewController: UITableViewController {

    @IBOutlet weak var selectDate: UIBarButtonItem!

    var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        let locale = Locale(identifier: "ru_RU")
        datePicker.locale = locale
        datePicker.datePickerMode = .date

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        return datePicker
    }()

    var toolBar = UIToolbar()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .long
        return formatter
    }()

    var realm: Realm!

    var hoursList = Array(repeating: [Event](), count: 24)

    var events: Results<Event> {
        return realm.objects(Event.self)
    }

    let sectionsTitle = [
        "00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11",
        "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"
    ]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        realm = try! Realm()

        updateHoursList()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)

        navigationItem.title = dateFormatter.string(from: datePicker.date)
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.title = "Изменить"
    }

    @IBAction func showDatePicker(_ sender: UIBarButtonItem) {
        datePicker.frame = CGRect(
            x: 0.0,
            y: UIScreen.main.bounds.size.height - 230,
            width: UIScreen.main.bounds.size.width,
            height: 230
        )
        datePicker.backgroundColor = UIColor.systemBackground
        self.view.superview!.addSubview(datePicker)

        toolBar = UIToolbar(
            frame: CGRect(
                x: 0,
                y: UIScreen.main.bounds.size.height - 230,
                width: UIScreen.main.bounds.size.width,
                height: 50
            )
        )
        toolBar.barStyle = .default
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: self,
            action: #selector(self.toolbarDoneTap)
        )

        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: true)

        selectDate.isEnabled = false

        self.view.superview!.addSubview(toolBar)
    }

    @objc func toolbarDoneTap() {
        navigationItem.title = dateFormatter.string(from: datePicker.date)
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
        selectDate.isEnabled = true

        updateHoursList()
        tableView.reloadData()
    }

    func updateHoursList() {
        hoursList = Array(repeating: [Event](), count: 24)

        let selectedDateString = dateFormatter.string(from: datePicker.date)

        let selectedDateEvents = events.map { event -> Event? in
            if self.dateFormatter.string(from: event.dateStart) == selectedDateString {
                return event
            }
            return nil
        }

        for event in selectedDateEvents {
            let calendar = Calendar.current
            let hourEvent = calendar.component(.hour, from: event?.dateStart ?? Date())

            var hourEventString = String(hourEvent)

            if hourEventString.count == 1 {
                hourEventString = "0\(hourEventString)"
            }

            if let index = sectionsTitle.firstIndex(where: { $0 == hourEventString }),
               let event = event {
                hoursList[index].append(event)
            }
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return hoursList.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(sectionsTitle[section]):00"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hoursList[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Event", for: indexPath)

        let event = hoursList[indexPath.section][indexPath.row]
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")

        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = formatter.string(from: event.dateStart)

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let event = hoursList[indexPath.section][indexPath.row]

            try! self.realm.write({
                self.realm.delete(event)
            })

            updateHoursList()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.editButtonItem.title = editing ? "Готово" : "Изменить"
    }

    // MARK: - Navigation

    @IBSegueAction func showEventDetail(_ coder: NSCoder, sender: UITableViewCell?) -> EventDetailViewController? {
        if let cell = sender {
            let indexPath = tableView.indexPath(for: cell)
            let event = hoursList[indexPath!.section][indexPath!.row]

            return EventDetailViewController(coder: coder, event: event)
        }
        return nil
    }

    @IBAction func unwindToNewEvent(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddEditEventTableViewController,
              let event = sourceViewController.event else {
                  return
              }

        try! realm.write({
            realm.add(event, update: .modified)
        })

        updateHoursList()
        tableView.reloadData()
    }

}
