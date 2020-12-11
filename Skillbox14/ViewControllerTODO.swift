
import UIKit

class ViewControllerTODO: UIViewController, CustomTableViewDataControlDelegate {

    @IBOutlet var textFieldNewTask: UITextField!
    @IBOutlet var buttonNewTask: UIButton!
    @IBOutlet var tableView: UITableView!
    
    private var tasks: [String] = []
    private var taskControlDelegate: TaskControlDelegate = RealmInstance.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        buttonNewTask.isEnabled = false
        loadData()
    }

    @IBAction func segmentedControl_ValueChanged(_ sender: UISegmentedControl) {
        taskControlDelegate = (sender.selectedSegmentIndex == 0) ? RealmInstance.shared : CoreDataInstance.shared
        loadData()
    }
    
    @IBAction func textFieldNewTask_EditingChanged(_ sender: UITextField) {
        buttonNewTask.isEnabled = (sender.text ?? "").count > 0
    }
    
    @IBAction func buttonNewTask_TouchUpInside(_ sender: Any) {
        taskControlDelegate.createTask(textFieldNewTask.text!)
        tasks.append(textFieldNewTask.text!)
        textFieldNewTask.text = nil
        buttonNewTask.isEnabled = false
        tableView.reloadData()
    }
    
    func loadData() {
        tasks = taskControlDelegate.getTasks()
        tableView.reloadData()
    }
    
    func removeRow(_ index: Int) {
        taskControlDelegate.deleteTask(index)
        tasks.remove(at: index)
        tableView.reloadData()
    }
}

extension ViewControllerTODO: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellTODO", for: indexPath) as! TableViewCellTODO
        
        cell.labelTask.text = tasks[indexPath.row]
        cell.delegateMaster = self
        
        return cell
    }
}
