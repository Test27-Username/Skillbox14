
import UIKit

private var storedKeyboardSize: CGFloat?

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
                storedKeyboardSize = keyboardSize.height
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if storedKeyboardSize != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += storedKeyboardSize!
                storedKeyboardSize = nil;
            }
        }
    }
}
