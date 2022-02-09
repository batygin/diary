import Foundation

struct Event: Equatable {
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
    
    static func eventList() -> [Event] {
        return [
            Event(id: UUID(), dateStart: Date(), dateEnd: Date(), name: "Mobile-практикум SimbirSoft", description: "Онлайн-практикум Mobile по двум потокам – Android и iOS. Под руководством ведущих специалистов SimbirSoft за 1,5-2 месяца ты освоишь основной технологический стек и выполнишь индивидуальный проект с поддерживаемым и расширяемым кодом.")
        ]
    }
}
