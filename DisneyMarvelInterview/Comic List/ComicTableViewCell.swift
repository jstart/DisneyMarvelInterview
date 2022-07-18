//
//  ComicTableViewCell.swift
//  DisneyMarvelInterview
//
//  Created by Chris Truman.
//

import Foundation
import UIKit

class ComicTableViewCell: UITableViewCell {

  static let reuseIdentifier = String(describing: ComicTableViewCell.self)

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    textLabel?.text = nil
    detailTextLabel?.text = nil
    imageView?.image = nil
  }
  
  func configure(with comic: Comic) {
    detailTextLabel?.numberOfLines = 2
    imageView?.contentMode = .scaleToFill
    textLabel?.text = comic.title
    detailTextLabel?.text = comic.description

    guard let url = comic.thumbnailURL else { return }

    URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
      guard let data = data else { return }
      guard let image = UIImage(data: data) else { return }

      let targetSize = CGSize(width: 40, height: 40)
      let scaledImage = image.scalePreservingAspectRatio(targetSize: targetSize)

      DispatchQueue.main.async {
        self?.imageView?.image = scaledImage
        self?.layoutSubviews()
      }
    }).resume()
  }
}
