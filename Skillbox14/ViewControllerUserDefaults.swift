
import UIKit

class ViewControllerUserDefaults: UIViewController {

    @IBOutlet var textFieldFirstName: UITextField!
    @IBOutlet var textFieldLastName: UITextField!
    @IBOutlet var buttonSave: UIButton!
    
    private var firstName: String?
    private var lastName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        firstName = UserDefaultsInstance.shared.firstName ?? ""
        lastName = UserDefaultsInstance.shared.lastName ?? ""
        
        textFieldFirstName.text = firstName
        textFieldLastName.text = lastName
        
        changeSaveButton(enabling: false)
    }

    @IBAction func textFieldFirstName_EditingChanged(_ sender: UITextField) {
        if !buttonSave.isEnabled && sender.text != firstName {
            changeSaveButton(enabling: true)
        }
        
        if buttonSave.isEnabled && sender.text == firstName {
            changeSaveButton(enabling: false)
        }
    }
    
    @IBAction func textFieldLastName_EditingChanged(_ sender: UITextField) {
        if !buttonSave.isEnabled && sender.text != lastName {
            changeSaveButton(enabling: true)
        }
        
        if buttonSave.isEnabled && sender.text == lastName {
            changeSaveButton(enabling: false)
        }
    }
    
    @IBAction func buttonSave_TouchUpInside(_ sender: Any) {
        firstName = textFieldFirstName.text
        lastName = textFieldLastName.text
        
        UserDefaultsInstance.shared.firstName = firstName
        UserDefaultsInstance.shared.lastName = lastName
        
        changeSaveButton(enabling: false)
    }
    
    func changeSaveButton(enabling: Bool) {
        buttonSave.backgroundColor = enabling ? .systemBlue : .systemGray4
        buttonSave.isEnabled = enabling
    }
}

