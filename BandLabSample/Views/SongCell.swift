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
            updateActionButtonInterface()
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
    
    
    private func updateActionButtonInterface() {
        DispatchQueue.main.async {
            self.songActionButton.setImage(self.viewModel?.currentState.buttonImage, for: .normal)
            if let interaction = self.viewModel?.currentState.buttonInteractionEnabled {
                self.songActionButton.isEnabled = interaction
            }
        }
    }
    
    private func bindWithCellViewModel() {
        self.viewModel?.updateOfDownloadAndSavedToDocuments = {[weak self] in
            self?.updateActionButtonInterface()
        }
    }
    
    
    @IBAction func songActionButtonTapped(_ sender: Any) {
        if self.viewModel?.shouldBindForDownload == true {
            bindWithCellViewModel()
        }
        viewModel?.updateCurrentState()
        updateActionButtonInterface()
        
    }
    
    
}
