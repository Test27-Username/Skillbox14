
import UIKit

class TableViewCellTODO: UITableViewCell {

    @IBOutlet var labelTask: UILabel!
    @IBOutlet var switchTask: UISwitch!
    
    var delegateMaster: CustomTableViewDataControlDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchTask_ValueChanged(_ sender: UISwitch) {
        if let delegateMaster = delegateMaster {
            delegateMaster.changeRow(index: self.indexPath!.row, isCompleted: sender.isOn)
        }
    }
    
    @IBAction func buttonRemove_TouchUpInside(_ sender: Any) {
        if let delegateMaster = delegateMaster {
            delegateMaster.removeRow(index: self.indexPath!.row)
        }
    }
}
