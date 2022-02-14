//
//  ViewController.swift
//  BandLabSample
//
//  Created by Muhammad Oneeb on 14/02/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    lazy var viewModel = {
            MainViewModel()
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindWithViewModel()
    }

    func bindWithViewModel() {
        mainTableView.register(UINib(nibName: viewModel.getCellIdentifier(), bundle: nil), forCellReuseIdentifier: viewModel.getCellIdentifier())
        self.viewModel.updateView = {[weak self] in
            self?.mainTableView.reloadData()
        }
        self.viewModel.fetchParsedDataForDisplay()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModelsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.getCellIdentifier(), for: indexPath) as! SongCell
        cell.viewModel = viewModel.getCellViewModel(at: indexPath)
        return cell
    }
    
    
}
