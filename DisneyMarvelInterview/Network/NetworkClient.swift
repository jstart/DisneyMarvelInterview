//
//  NetworkClient.swift
//  DisneyMarvelInterview
//
//  Created by Chris Truman.
//

import Foundation
import Combine

struct NetworkClient {
  static let apiURL = URL(string: "https://gateway.marvel.com:443/v1/public")!
  let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
  }()

  func fetch(comicId: Int) -> AnyPublisher<ComicResponse, Error>? {
    let ts = Int(Date().timeIntervalSince1970)
    guard let comicURL = generateURL(for: comicId, timestamp: ts) else {
      print("Unable to generate URL for request")
      return nil
    }
    return URLSession.shared
        .dataTaskPublisher(for: comicURL)
        .tryMap() {
            guard let httpResponse = $0.response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            return $0.data
        }
        .decode(type: ComicResponse.self, decoder: decoder)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()

//    Non-Combine Approach using completion handlers and GCD
//    URLSession.shared.dataTask(with: comicURL, completionHandler: { data, response, error in
//      guard let data = data else {
//        DispatchQueue.main.async { completion(nil, error) }
//        return
//      }
//      do {
//        let comicResponse = try parseData(data, type: ComicResponse.self)
//        DispatchQueue.main.async { completion(comicResponse, error) }
//      } catch {
//        DispatchQueue.main.async { completion(nil, error) }
//      }
//    }).resume()
  }

  func parseData<T: Codable>(_ data: Data, type: T.Type) throws -> T {
    return try decoder.decode(type, from: data)
  }

  func generateURL(for comicId: Int, timestamp: Int) -> URL? {
    let url = NetworkClient.apiURL.appendingPathComponent("comics/\(comicId)")
    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    // Fun tip, don't try to use apiKey instead of apikey, you get this error
    // code: "MissingParameter",
    // message: "You must provide a user key."
    components?.queryItems = queryItems(ts: timestamp)
    guard let urlString = components?.string?.removingPercentEncoding else { return nil }
    return URL(string: urlString)
  }

  func queryItems(ts: Int) -> [URLQueryItem] {
    return [URLQueryItem(name: "ts", value: "\(ts)"),
            URLQueryItem(name: "apikey", value: Credentials.apiKey),
            URLQueryItem(name: "hash", value: Utilities.MD5("\(ts)" + Credentials.privateKey + Credentials.apiKey))
           ]
  }

}
