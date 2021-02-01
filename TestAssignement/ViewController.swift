//
//  ViewController.swift
//  TestAssignement
//
//  Created by Андрей Гедзюра on 30.01.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var itemListTable: UITableView!
    var viewModelController = ViewModelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModelController.requestItems(completion: ({
            DispatchQueue.main.async {
                self.itemListTable.reloadData()
            }
        }, {error in
            DispatchQueue.main.async {
                self.generateAlert(title: "Oops!", message: error.localizedDescription, buttonTitle: "Try Again")
            }
        }))
    }

    private func setUpTable() {
        itemListTable.register(UINib(nibName: String(describing: PictureCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PictureCell.self))
        itemListTable.register(UINib(nibName: String(describing: SelectorCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SelectorCell.self))
        itemListTable.register(UINib(nibName: String(describing: TextBlockCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TextBlockCell.self))
        itemListTable.delegate = self
        itemListTable.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelController.itemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModelController.itemAtIndex(indexPath.item) {
        case .success(let item):
            if let picture = item as? Picture {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PictureCell.self), for: indexPath) as? PictureCell else {
                    generateAlert(title: "Oops", message: "Can't create cell.", buttonTitle: "Try Again")
                    return UITableViewCell()
                }
                cell.viewModel = picture
                return cell
            } else if let text = item as? TextBlock {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextBlockCell.self), for: indexPath) as? TextBlockCell else {
                    generateAlert(title: "Oops", message: "Can't create cell.", buttonTitle: "Try Again")
                    return UITableViewCell()
                }
                cell.viewModel = text
                return cell
            } else if let selector = item as? Selector {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SelectorCell.self), for: indexPath) as? SelectorCell else {
                    generateAlert(title: "Oops", message: "Can't create cell.", buttonTitle: "Try Again")
                    return UITableViewCell()
                }
                cell.viewModel = selector
                cell.alertDetails = {id, name, selectedId in
                    self.generateAlert(title: "Info", message: "ID: \(id), name: \(name), selectedID: \(selectedId).", buttonTitle: "OK")
                }
                return cell
            } else {
                generateAlert(title: "Oops", message: "Invalid item type.", buttonTitle: "Try Again")
                return UITableViewCell()
            }
        case .failure(let error):
            generateAlert(title: "Oops", message: error.localizedDescription, buttonTitle: "Try Again")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModelController.itemAtIndex(indexPath.item)
        switch item {
        case .success(let item):
            self.generateAlert(title: "Info", message: "ID: \(item.id), name: \(item.name)", buttonTitle: "OK")
        case .failure(let error):
            self.generateAlert(title: "Oops!", message: error.localizedDescription, buttonTitle: "Try Again")
        }
    }
    
}

