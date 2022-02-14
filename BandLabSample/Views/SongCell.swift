//
//  SongCell.swift
//  BandLabSample
//
//  Created by Muhammad Oneeb on 14/02/2022.
//

import UIKit

class SongCell: UITableViewCell {

    @IBOutlet weak var songTitleLabel: UILabel!
    
    
    var viewModel: SongCellViewModel? {
        didSet{
            songTitleLabel.text = viewModel?.displayData.name ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
