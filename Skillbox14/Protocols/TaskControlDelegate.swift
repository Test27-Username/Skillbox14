
import Foundation

protocol TaskControlDelegate {
    func getTasks() -> [Task]
    func createTask(task: Task)
    func updateTask(index: Int, task: Task)
    func deleteTask(index: Int)
}
