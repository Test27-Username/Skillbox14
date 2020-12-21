
import Foundation
import RealmSwift

class RealmTask: Object {
    @objc dynamic var name: String?
    @objc dynamic var isCompleted: Bool = false
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

class RealmInstance {
    static let shared = RealmInstance()
    private let realm = try! Realm()
    
    func getWeather() -> WeatherData? {
        return realm.objects(WeatherData.self).first
    }
    
    func setWeather(_ weather: WeatherData?) {
        try! realm.write {
            realm.delete(realm.objects(WeatherData.self))
            if weather != nil {
                realm.add(weather!)
            }
        }
    }
}

extension RealmInstance: TaskControlDelegate {
    func getTasks() -> [Task] {
        var tasks: [Task] = []
        
        for item in realm.objects(RealmTask.self) {
            let task = Task()
            task.name = item.name
            task.isCompleted = item.isCompleted
            tasks.append(task)
        }
        
        return tasks
    }
    
    func createTask(task: Task) {
        try! realm.write {
            let newTask = RealmTask()
            
            newTask.name = task.name
            realm.add(newTask)
        }
    }
    
    func updateTask(index: Int, task: Task) {
        try! realm.write {
            let updatedTask = realm.objects(RealmTask.self)[index]
            
            updatedTask.name = task.name
            updatedTask.isCompleted = task.isCompleted
        }
    }
    
    func deleteTask(index: Int) {
        try! realm.write {
            realm.delete(realm.objects(RealmTask.self)[index])
        }
    }
}
