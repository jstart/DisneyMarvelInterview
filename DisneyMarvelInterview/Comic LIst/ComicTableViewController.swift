//
//  ComicTableViewController.swift
//  DisneyMarvelInterview
//
//  Created by Chris Truman.
//

import UIKit

class ComicTableViewController: UITableViewController {

  var viewModel: ComicTableViewModel

  init() {
    self.viewModel = ComicTableViewModel()
    super.init(style: .plain)
    self.viewModel.attach(tableVC: self)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(ComicTableViewCell.self, forCellReuseIdentifier: ComicTableViewCell.reuseIdentifier)

    title = NSLocalizedString("comics_title", comment: "")

    navigationItem.rightBarButtonItem = viewModel.addItem

    viewModel.fetchInitialComic()
  }

  func update(state: ComicTableViewModel.State) {
    title = NSLocalizedString("comics_title", comment: "")
    navigationController?.presentedViewController?.dismiss(animated: false, completion: nil)
    switch state {
    case .loading:
      title = NSLocalizedString("loading", comment: "")
    case .finished:
      tableView.reloadData()
    case .add:
      presentAlert(viewModel.addComicAlert)
    case .error(_):
      presentAlert(viewModel.errorAlert)
    }
  }

  func presentAlert(_ alertVC: UIAlertController) {
    navigationController?.present(alertVC, animated: true, completion: nil)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.comics.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ComicTableViewCell.reuseIdentifier, for: indexPath) as! ComicTableViewCell
    let comic = viewModel.comics[indexPath.row]
    cell.configure(with: comic)
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let sessionDetailVC = ComicDetailViewController()
    let comic = viewModel.comics[indexPath.row]
    sessionDetailVC.configure(with: comic)
    navigationController?.pushViewController(sessionDetailVC, animated: true)
  }
}

