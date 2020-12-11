
import Foundation
import RealmSwift

class RealmTask: Object {
    @objc dynamic var name: String?
}

class WeatherData: Object {
    @objc dynamic var date: Date?
    @objc dynamic var desc: String?
    @objc dynamic var tempMin: Int = 0
    @objc dynamic var tempMax: Int = 0
    @objc dynamic var windSpeed: Float = 0
    @objc dynamic var windDeg: Float = 0
    @objc dynamic var timezoneOffset: Int = 0
    @objc dynamic var cityName: String?
    @objc dynamic var temp: Int = 0
    @objc dynamic var tempFeelsLike: Int = 0
    @objc dynamic var humidity: Int = 0
    
    var windName: String {
        get {
            switch windDeg {
            case 11.25..<33.75:
                return "ССВ"
            case 33.75..<56.25:
                return "СВ"
            case 56.25..<78.75:
                return "СВС"
            case 78.75..<101.25:
                return "В"
            case 101.25..<123.75:
                return "ВЮВ"
            case 123.75..<146.25:
                return "ЮВ"
            case 146.25..<168.75:
                return "ЮЮВ"
            case 168.75..<191.25:
                return "Ю"
            case 191.25..<213.75:
                return "ЮЮЗ"
            case 213.75..<236.25:
                return "ЮЗ"
            case 236.25..<258.75:
                return "ЗЮЗ"
            case 258.75..<281.25:
                return "З"
            case 281.25..<303.75:
                return "ЗСЗ"
            case 303.75..<326.25:
                return "СЗ"
            case 326.25..<348.75:
                return "ССЗ"
            default:
                return "С"
            }
        }
    }
}

class RealmInstance: TaskControlDelegate {
    static let shared = RealmInstance()
    private let realm = try! Realm()
    
    func getTasks() -> [String] {
        var tasks: [String] = []
        
        for task in realm.objects(RealmTask.self) {
            tasks.append(task.name!)
        }
        
        return tasks
    }
    
    func createTask(_ name: String) {
        try! realm.write {
            let newTask = RealmTask()
            
            newTask.name = name
            self.realm.add(newTask)
        }
    }
    
    func deleteTask(_ index: Int) {
        try! realm.write {
            self.realm.delete(realm.objects(RealmTask.self)[index])
        }
    }
    
    func getWeather() -> WeatherData? {
        return realm.objects(WeatherData.self).first
    }
    
    func setWeather(_ weather: WeatherData?) {
        try! realm.write {
            self.realm.delete(realm.objects(WeatherData.self))
            if weather != nil {
                self.realm.add(weather!)
            }
        }
    }
}
