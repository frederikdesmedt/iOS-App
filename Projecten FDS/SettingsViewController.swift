import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var negativeValuesSwitch: UISwitch!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        negativeValuesSwitch.setOn(userDefaults.boolForKey("negative"), animated: false)
        nameTextField.text = userDefaults.stringForKey("name") ?? "Anonymous"
    }
    
    @IBAction func nameDidChange() {
        userDefaults.setValue(nameTextField.text ?? "Anonymous", forKey: "name")
    }
    
    @IBAction func negativeValuesDidChange() {
        userDefaults.setValue(negativeValuesSwitch.on, forKey: "negative")
    }
}