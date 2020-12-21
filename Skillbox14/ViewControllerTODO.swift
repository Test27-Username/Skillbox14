
import UIKit

class ViewControllerTODO: UIViewController, CustomTableViewDataControlDelegate {

    @IBOutlet var textFieldNewTask: UITextField!
    @IBOutlet var buttonNewTask: UIButton!
    @IBOutlet var buttonSaveTask: UIButton!
    @IBOutlet var tableView: UITableView!
    
    private var selectedTaskIndex: Int = -1
    private var tasks: [Task] = []
    private var taskControlDelegate: TaskControlDelegate = RealmInstance.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        buttonNewTask.isEnabled = false
        buttonSaveTask.isHidden = true
        loadData()
    }

    @IBAction func segmentedControl_ValueChanged(_ sender: UISegmentedControl) {
        taskControlDelegate = (sender.selectedSegmentIndex == 0) ? RealmInstance.shared : CoreDataInstance.shared
        afterRowUpdate()
    }
    
    @IBAction func textFieldNewTask_EditingChanged(_ sender: UITextField) {
        let fieldIsEmpty = (sender.text ?? "").count == 0
        if !buttonNewTask.isHidden {
            buttonNewTask.isEnabled = !fieldIsEmpty
        } else {
            buttonSaveTask.isEnabled = !fieldIsEmpty && sender.text != tasks[selectedTaskIndex].name
        }
    }
    
    @IBAction func buttonNewTask_TouchUpInside(_ sender: Any) {
        let newTask = Task()
        newTask.name = textFieldNewTask.text!
        taskControlDelegate.createTask(task: newTask)

        textFieldNewTask.text = nil
        buttonNewTask.isEnabled = false
        
        loadData()
    }
    
    @IBAction func buttonSaveTask_TouchUpInside(_ sender: Any) {
        let updatedTask = tasks[selectedTaskIndex]
        updatedTask.name = textFieldNewTask.text
        taskControlDelegate.updateTask(index: selectedTaskIndex, task: updatedTask)
        
        afterRowUpdate()
    }
    
    func afterRowUpdate() {
        selectedTaskIndex = -1
        textFieldNewTask.text = nil
        buttonNewTask.isHidden = false
        buttonSaveTask.isHidden = true
        
        loadData()
    }
    
    func loadData() {
        tasks = taskControlDelegate.getTasks()
        tableView.reloadData()
    }
    
    func changeRow(index: Int, isCompleted: Bool) {
        let updatedTask = tasks[index]
        updatedTask.isCompleted = isCompleted
        taskControlDelegate.updateTask(index: index, task: updatedTask)
        
        afterRowUpdate()
    }
    
    func removeRow(index: Int) {
        taskControlDelegate.deleteTask(index: index)
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
        
        cell.labelTask.text = tasks[indexPath.row].name
        cell.switchTask.isOn = tasks[indexPath.row].isCompleted
        cell.delegateMaster = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedTaskIndex == indexPath.row {
            tableView.deselectRow(at: indexPath, animated: false)
            afterRowUpdate()
        } else {
            selectedTaskIndex = indexPath.row
            textFieldNewTask.text = tasks[selectedTaskIndex].name
            buttonNewTask.isHidden = true
            buttonSaveTask.isHidden = false
        }
        
        textFieldNewTask_EditingChanged(textFieldNewTask)
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedTaskIndex = -1
        textFieldNewTask.text = nil
        buttonNewTask.isHidden = false
        buttonSaveTask.isHidden = true
        
        return indexPath
    }
}
