//
//  ComicTableViewModel.swift
//  DisneyMarvelInterview
//
//  Created by Chris Truman on 7/17/22.
//

import Foundation
import Combine
import CryptoKit
import UIKit

class ComicTableViewModel {
  enum State {
    case loading
    case finished
    case add
    case error(Error)
  }
  
  private weak var tableVC: ComicTableViewController?
  private var client = NetworkClient()
  private var cancellable: AnyCancellable?

  private(set) var state = State.finished {
    didSet {
      tableVC?.update(state: state)
    }
  }

  private(set) var comics = [Comic]()

  // Initial comic for demonstration purposes
  private var comicIDs = [52564]

  func attach(tableVC: ComicTableViewController) {
    self.tableVC = tableVC
  }

  func fetchInitialComic() {
    fetchComic(comicIDs.first)
  }

  func fetchComic(_ comicID: Int?) {
    state = .loading
    guard let comicID = comicID else { return }

    cancellable = client.fetch(comicId: comicID)?.sink(receiveCompletion: { completion in
      switch completion {
      case .failure(let error):
        print(error)
        self.state = .error(error)
      case .finished:
        return
      }

    }, receiveValue: { [weak self] fetchedComics in
        guard let comic = fetchedComics.data.results.first else {
          self?.state = .error(URLError(.badServerResponse))
          return
        }
        self?.comics.append(comic)
        self?.state = .finished
    }) ?? nil
  }

  var addItem: UIBarButtonItem {
    return UIBarButtonItem(systemItem: .add,
                                primaryAction: UIAction(handler: { [weak self] _ in
                                  self?.state = .add
                                }), menu: .none)
  }

  var addComicAlert: UIAlertController {
    let alert = UIAlertController(title: NSLocalizedString("enter_comic_id", comment: ""), message: nil, preferredStyle: .alert)
    alert.addTextField(configurationHandler: nil)
    alert.addAction(UIAlertAction(title: NSLocalizedString("add", comment: ""), style: .default, handler: { [weak self] _ in
      guard let comicID = alert.textFields?.first?.text else { return }
      guard let comicIDInt = Int(comicID) else { return }
      self?.fetchComic(comicIDInt)
    }))
    return alert
  }

  var errorAlert: UIAlertController {
    let alert = UIAlertController(title: NSLocalizedString("can_not_fetch_comics", comment: ""), message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
    return alert
  }
  
}
