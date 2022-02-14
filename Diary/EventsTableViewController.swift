import UIKit

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
    
    var hoursList = Array(repeating: [Event](), count: 24)
    var events = [Event]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = dateFormatter.string(from: datePicker.date)
        
        if let saveEvents = Event.loadEvents() {
            events = saveEvents
        } else {
            events = Event.loadSampleEvent()
        }
        
        updateHoursList()
    }
    
    @IBAction func showDatePicker(_ sender: UIBarButtonItem) {
        datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 230, width: UIScreen.main.bounds.size.width, height: 230)
        datePicker.backgroundColor = UIColor.systemBackground
        self.view.superview!.addSubview(datePicker)
                
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 230, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(self.toolbarDoneTap))
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
            if dateFormatter.string(from: event.dateStart) == selectedDateString {
                return event
            }
            return nil
        }
        
        for event in selectedDateEvents {
            let calendar = Calendar.current
            let hourEvent = calendar.component(.hour, from: event?.dateStart ?? Date())
            
            if event != nil {
                switch event {
                case _ where hourEvent == 00:
                    hoursList[0].append(event!)
                case _ where hourEvent == 01:
                    hoursList[1].append(event!)
                case _ where hourEvent == 02:
                    hoursList[2].append(event!)
                case _ where hourEvent == 03:
                    hoursList[3].append(event!)
                case _ where hourEvent == 04:
                    hoursList[4].append(event!)
                case _ where hourEvent == 05:
                    hoursList[5].append(event!)
                case _ where hourEvent == 06:
                    hoursList[6].append(event!)
                case _ where hourEvent == 07:
                    hoursList[7].append(event!)
                case _ where hourEvent == 08:
                    hoursList[8].append(event!)
                case _ where hourEvent == 09:
                    hoursList[9].append(event!)
                case _ where hourEvent == 10:
                    hoursList[10].append(event!)
                case _ where hourEvent == 11:
                    hoursList[11].append(event!)
                case _ where hourEvent == 12:
                    hoursList[12].append(event!)
                case _ where hourEvent == 13:
                    hoursList[13].append(event!)
                case _ where hourEvent == 14:
                    hoursList[14].append(event!)
                case _ where hourEvent == 15:
                    hoursList[15].append(event!)
                case _ where hourEvent == 16:
                    hoursList[16].append(event!)
                case _ where hourEvent == 17:
                    hoursList[17].append(event!)
                case _ where hourEvent == 18:
                    hoursList[18].append(event!)
                case _ where hourEvent == 19:
                    hoursList[19].append(event!)
                case _ where hourEvent == 20:
                    hoursList[20].append(event!)
                case _ where hourEvent == 21:
                    hoursList[21].append(event!)
                case _ where hourEvent == 22:
                    hoursList[22].append(event!)
                case _ where hourEvent == 23:
                    hoursList[23].append(event!)
                default:
                    break
                }
            }
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return hoursList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title: String
        
        switch section {
        case 0: title = "00:00"; case 1: title = "01:00"; case 2: title = "02:00"; case 3: title = "03:00"; case 4: title = "04:00"; case 5: title = "05:00"; case 6: title = "06:00"; case 7: title = "07:00"; case 8: title = "08:00"; case 9: title = "09:00"; case 10: title = "10:00"; case 11: title = "11:00"; case 12: title = "12:00"; case 13: title = "13:00"; case 14: title = "14:00"; case 15: title = "15:00"; case 16: title = "16:00"; case 17: title = "17:00"; case 18: title = "18:00"; case 19: title = "19:00"; case 20: title = "20:00"; case 21: title = "21:00"; case 22: title = "22:00"; case 23: title = "23:00";
        default:
            title = ""
        }
        
        return title
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
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (elements) -> UIMenu? in
            let delete = UIAction(title: "Удалить") { (action) in
                self.deleteEvent(at: indexPath)
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [delete])
        }
        
        return config
    }
    
    func deleteEvent(at indexPath: IndexPath) {
        let event = hoursList[indexPath.section][indexPath.row]
        guard let indexEvent = events.firstIndex(where: { $0.id == event.id }) else { return }
        
        events.remove(at: indexEvent)
        updateHoursList()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        Event.saveEvents(events)
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
              let sourceViewController = segue.source as? NewEventTableViewController,
              let event = sourceViewController.event else {
                  return
              }
        
        events.append(event)
        updateHoursList()
        tableView.reloadData()
        Event.saveEvents(events)
    }

}
