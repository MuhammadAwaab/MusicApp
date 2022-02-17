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
    
    var circularProgress: ProgressView?
    
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
    
    private func createCircularProgressViewAndAddToCell() {
         circularProgress = ProgressView(frame: CGRect(x: 0.0, y: 0.0, width: stateBackgroundView.frame.width, height: stateBackgroundView.frame.height))
                
        circularProgress!.center = stateBackgroundView.center
        stateBackgroundView.addSubview(circularProgress!)
        updateActionButtonInterface()
    }
    
    private func updateActionButtonInterface() {
        DispatchQueue.main.async {
            self.songActionButton.setImage(self.viewModel?.currentState.buttonImage, for: .normal)
            if let hideActionButton = self.viewModel?.currentState.shouldHideButton {
                self.songActionButton.isHidden = hideActionButton
                if hideActionButton == false {
                    self.circularProgress?.removeFromSuperview()
                }
            }
        }
    }
    
    private func bindWithCellViewModel() {
        createCircularProgressViewAndAddToCell()
        self.viewModel?.updateOfDownloadAndSavedToDocuments = {[weak self] in
            self?.updateActionButtonInterface()
        }
        
        self.viewModel?.showDownloadProgressOfCurrentContent = { percentage in
            DispatchQueue.main.async {
                self.circularProgress?.setProgressWithAnimation(duration: 0.0, value: Float(percentage))
            }
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
