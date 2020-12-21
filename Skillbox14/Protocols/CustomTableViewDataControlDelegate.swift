
import Foundation

protocol CustomTableViewDataControlDelegate{
    func changeRow(index: Int, isCompleted: Bool)
    func removeRow(index: Int)
}
