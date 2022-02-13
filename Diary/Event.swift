import Foundation

struct Event: Equatable, Codable {
    var id: UUID
    var dateStart: Date
    var dateEnd: Date
    var name: String
    var description: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case dateStart = "date_start"
        case dateEnd = "date_finish"
        case name
        case description
    }
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentDirectory.appendingPathComponent("events").appendingPathExtension("plist")
    
    static func loadEvents() -> [Event]? {
        guard let codedEvents = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Event>.self, from: codedEvents)
    }
    
    static func saveEvents(_ events: [Event]) {
        let propertyListEncoder = PropertyListEncoder()
        let codetEvents = try? propertyListEncoder.encode(events)
        try? codetEvents?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadSampleEvent() -> [Event] {
        return [
            Event(id: UUID(), dateStart: Date(), dateEnd: Date(), name: "Mobile-практикум SimbirSoft", description: "Онлайн-практикум Mobile по двум потокам – Android и iOS. Под руководством ведущих специалистов SimbirSoft за 1,5-2 месяца ты освоишь основной технологический стек и выполнишь индивидуальный проект с поддерживаемым и расширяемым кодом.")
        ]
    }
}
