import UIKit

class AddEditEventTableViewController: UITableViewController, UITextViewDelegate {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateStartLabel: UILabel!
    @IBOutlet weak var dateStartPicker: UIDatePicker!
    @IBOutlet weak var dateEndLabel: UILabel!
    @IBOutlet weak var dateEndPicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    var dateStartPickerHidden = true
    var dateEndPickerHidden = true
    let dateStartLabelIndexPath = IndexPath(row: 0, section: 1)
    let dateStartPickerIndexPath = IndexPath(row: 1, section: 1)
    let dateEndLabelIndexPath = IndexPath(row: 2, section: 1)
    let dateEndPickerIndexPath = IndexPath(row: 3, section: 1)
    let descriptionView = IndexPath(row: 0, section: 2)

    var event: Event?

    init?(coder: NSCoder, event: Event) {
        self.event = event
        super.init(coder: coder)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextView.delegate = self

        updateSaveButtonState()

        dateStartLabel.text = dateFormatter.string(from: dateStartPicker.date)
        dateEndLabel.text = dateFormatter.string(from: dateEndPicker.date)

        if let event = event {
            titleField.text = event.name
            descriptionTextView.text = event.description
            dateStartPicker.date = event.dateStart
            dateEndPicker.date = event.dateEnd
            dateStartLabel.text = dateFormatter.string(from: event.dateStart)
            dateEndLabel.text = dateFormatter.string(from: event.dateEnd)
            title = "Изменить событие"
            saveButton.title = "Сохранить"
        }
    }

    func updateSaveButtonState() {
        let shouldEnableSaveButton = titleField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }

    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        if sender == dateStartPicker {
            dateStartLabel.text = dateFormatter.string(from: sender.date)
        } else {
            dateEndLabel.text = dateFormatter.string(from: sender.date)
        }

        updateSaveButtonState()
    }

    @IBAction func textEditingChange(_ sender: UITextField) {
        updateSaveButtonState()
    }

    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

    func textViewDidChange(_ textView: UITextView) {
        updateSaveButtonState()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case dateStartPickerIndexPath where dateStartPickerHidden == true:
            return 0
        case dateEndPickerIndexPath where dateEndPickerHidden == true:
            return 0
        case descriptionView:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath {
        case dateStartLabelIndexPath:
            dateStartPickerHidden.toggle()
            tableView.beginUpdates()
            tableView.endUpdates()
        case dateEndLabelIndexPath:
            dateEndPickerHidden.toggle()
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard segue.identifier == "saveUnwind" else { return }

        let id = event?.id ?? UUID()
        let name = titleField.text!
        let dateStart = dateStartPicker.date
        let dateEnd = dateEndPicker.date
        let description = descriptionTextView.text

        event = Event(id: id, dateStart: dateStart, dateEnd: dateEnd, name: name, description: description ?? "")
    }

}
