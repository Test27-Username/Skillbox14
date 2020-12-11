
import UIKit

class TableViewCellTODO: UITableViewCell {

    @IBOutlet var labelTask: UILabel!
    
    var delegateMaster: CustomTableViewDataControlDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonRemove_TouchUpInside(_ sender: Any) {
        if let delegateMaster = delegateMaster {
            delegateMaster.removeRow(self.indexPath!.row)
        }
    }
}
