//
//  SongCell.swift
//  BandLabSample
//
//  Created by Muhammad Oneeb on 14/02/2022.
//

import UIKit

class SongCell: UITableViewCell {

    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var stateBackgroundView: UIView!
    @IBOutlet weak var songActionButton: UIButton!
    
    
    var viewModel: SongCellViewModel? {
        didSet{
            songTitleLabel.text = viewModel?.displayData.name ?? ""
            songActionButton.setImage(viewModel?.currentState.buttonImage, for: .normal)
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
    
    @IBAction func songActionButtonTapped(_ sender: Any) {
        viewModel?.updateCurrentState()
        songActionButton.setImage(viewModel?.currentState.buttonImage, for: .normal)
        if let interaction = viewModel?.currentState.buttonInteractionEnabled {
            songActionButton.isEnabled = interaction
        }
    }
    
    
}
