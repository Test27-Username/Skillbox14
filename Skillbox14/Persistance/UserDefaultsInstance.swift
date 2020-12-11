
import Foundation

class UserDefaultsInstance {
    static let shared = UserDefaultsInstance()
    
    private let kFirstName = "firstName"
    private let kLastName = "lastName"
    
    var firstName: String? {
        set { UserDefaults.standard.set((newValue ?? "").count > 0 ? newValue : nil, forKey: kFirstName) }
        get { UserDefaults.standard.string(forKey: kFirstName) }
    }
    
    var lastName: String? {
        set { UserDefaults.standard.set((newValue ?? "").count > 0 ? newValue : nil, forKey: kLastName) }
        get { UserDefaults.standard.string(forKey: kLastName) }
    }
}
