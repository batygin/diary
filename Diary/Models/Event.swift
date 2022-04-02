import Foundation
import RealmSwift

class Event: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var notes: String
    @Persisted var dateStart: Date
    @Persisted var dateEnd: Date

    convenience init(id: UUID, name: String, notes: String, dateStart: Date, dateEnd: Date) {
        self.init()
        self.id = id
        self.name = name
        self.notes = notes
        self.dateStart = dateStart
        self.dateEnd = dateEnd
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case notes = "description"
        case dateStart = "date_start"
        case dateEnd = "date_finish"
    }
}
