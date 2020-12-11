
import Foundation

protocol TaskControlDelegate {
    func getTasks() -> [String]
    func createTask(_ name: String)
    func deleteTask(_ index: Int)
}
