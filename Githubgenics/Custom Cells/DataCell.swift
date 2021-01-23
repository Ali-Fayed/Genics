
import UIKit
import Kingfisher

class DataCell: UITableViewCell {
    
    static let identifier = "Cell"
    @IBOutlet var UserTitleLabel: UILabel!
    @IBOutlet var UserAvatar: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    static func nib() -> UINib {
        return UINib(nibName: "DataCell",
                     bundle: nil)
    }

  
    
}
