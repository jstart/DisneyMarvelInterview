//
//  ComicDetailViewController.swift
//  DisneyMarvelInterview
//
//  Created by Chris Truman.
//

import Foundation
import UIKit

class ComicDetailViewController: UIViewController {

  let scrollView = UIScrollView()
  let titleLabel = UILabel()
  let summaryLabel = UILabel()
  let dateLabel = UILabel()
  let profileImageView = UIImageView()
  let buttonStack = UIStackView()
  let detailsButton = UIButton(type: .custom)
  let otherButton = UIButton(type: .custom)

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    setupViews()
  }

  func setupViews() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
    view.addSubview(scrollView)
    scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(titleLabel)
    titleLabel.numberOfLines = 0
    titleLabel.font = .preferredFont(forTextStyle: .title1)
    titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true

    summaryLabel.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(summaryLabel)
    summaryLabel.numberOfLines = 0
    summaryLabel.font = .preferredFont(forTextStyle: .body)

    summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
    summaryLabel.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
    summaryLabel.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true

    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(dateLabel)
    dateLabel.numberOfLines = 0
    dateLabel.font = .preferredFont(forTextStyle: .callout)

    dateLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 15).isActive = true
    dateLabel.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
    dateLabel.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true

    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(profileImageView)
    profileImageView.contentMode = .scaleAspectFit

    profileImageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15).isActive = true
    profileImageView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
    profileImageView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    profileImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15).isActive = true

    buttonStack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(buttonStack)
    buttonStack.addArrangedSubview(detailsButton)
    buttonStack.addArrangedSubview(otherButton)
    buttonStack.axis = .vertical
    buttonStack.distribution = .fillEqually
    buttonStack.spacing = 10

    detailsButton.setTitle(NSLocalizedString("view_details", comment: ""), for: .normal)
    detailsButton.backgroundColor = .systemBackground
    detailsButton.setTitleColor(.label, for: .normal)
    detailsButton.layer.borderColor = UIColor.blue.cgColor
    detailsButton.layer.borderWidth = 2
    detailsButton.layer.cornerRadius = 5

    otherButton.setTitle(NSLocalizedString("excelsior", comment: ""), for: .normal)
    otherButton.backgroundColor = .systemBackground
    otherButton.setTitleColor(.label, for: .normal)
    otherButton.layer.borderColor = UIColor.red.cgColor
    otherButton.layer.borderWidth = 2
    otherButton.layer.cornerRadius = 5

    buttonStack.heightAnchor.constraint(equalToConstant: 100).isActive = true
    buttonStack.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
    buttonStack.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
    buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
  }

  func configure(with comic: Comic) {
    titleLabel.text = comic.title
    summaryLabel.text = comic.description
    dateLabel.text = NSLocalizedString("published_prefix", comment: "") + comic.publishedDateText

    detailsButton.addAction(UIAction(handler: { _ in
      guard let detailsURL = comic.detailsURL else { return }
      UIApplication.shared.open(detailsURL)

    }), for: .touchUpInside)

    otherButton.addAction(UIAction(handler: { [weak self] _ in
      let alert = UIAlertController(title: "Hi I'm Chris", message: "Nice to meet you :)", preferredStyle: .alert)
      let dismiss = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: nil)
      alert.addAction(dismiss)
      self?.navigationController?.present(alert, animated: true)
    }), for: .touchUpInside)
    guard let url = comic.thumbnailURL else { return }

    URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
      guard let data = data else { return }
      guard let image = UIImage(data: data) else { return }

      DispatchQueue.main.async {
        self?.profileImageView.image = image
      }
    }).resume()
  }
}
