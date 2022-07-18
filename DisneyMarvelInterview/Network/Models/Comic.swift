//
//  Comic.swift
//  DisneyMarvelInterview
//
//  Created by Chris Truman.
//

import Foundation

struct ComicResponse: Codable, Equatable {
  var data: ComicData
}

struct ComicData: Codable, Equatable {
  var results: [Comic]
}

struct Comic: Codable, Equatable {

  struct ComicDate: Codable, Equatable {
    var type: String
    var date: Date
  }

  struct ComicURL: Codable, Equatable {
    var type: String
    var url: String
  }

  static let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.locale = .autoupdatingCurrent
    return dateFormatter
  }()

  var id: Int
  var title: String
  var issueNumber: Int
  var description: String
  var resourceURI: String
  var urls: [ComicURL]
  var dates: [ComicDate]
  var thumbnail: [String: String]
  var images: [[String: String]]

  var thumbnailURL: URL? {
    let urlText = "\(thumbnail["path"] ?? "")" + ".jpg"
    let secureUrl = urlText.replacingOccurrences(of: "http", with: "https")
    return URL(string: secureUrl)
  }

  var publishedDateText: String {
    let df = Comic.dateFormatter
    for comicDate in dates {
      if comicDate.type == "onsaleDate" {
        return df.string(from: comicDate.date)
      }
    }
    return "Unknown"
  }

  var detailsURL: URL? {
    guard let url = urls.first(where: { $0.type == "detail" }).map({ URL(string: $0.url) }) else { return nil }
    return url
  }
}
