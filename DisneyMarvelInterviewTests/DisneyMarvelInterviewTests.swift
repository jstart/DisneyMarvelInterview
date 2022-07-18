//
//  DisneyMarvelInterviewTests.swift
//  DisneyMarvelInterviewTests
//
//  Created by Chris Truman on 7/15/22.
//

import XCTest
@testable import DisneyMarvelInterview

class DisneyMarvelInterviewTests: XCTestCase {
  let client = NetworkClient()

  override func setUpWithError() throws {
  }

  override func tearDownWithError() throws {
  }

  func parseTest() {
    let comic = Comic(id: 52564,
                      title: "Spider-Man/Deadpool (2016) #6",
                      issueNumber: 6,
                      description: "Deadpool goes Hollywood! See the M w/the M on the set of his own MOVIE! And he brings his pal Spidey along, as he has lots of experience selling out! All-Star Special Issue-written by Scott Aukerman of TV's Comedy Bang Bang!",
                      resourceURI: "http://gateway.marvel.com/v1/public/comics/52564",
                      urls: [Comic.ComicURL(type: "", url: "")],
                      dates: [Comic.ComicDate(type: "", date: Date())],
                      thumbnail: ["":""],
                      images: [["":""]])
    let comicData = ComicData(results: [comic])
    let staticResponse = ComicResponse(data: comicData)
    let bundle = Bundle(for: type(of: self))
    guard let path = bundle.path(forResource: "ComicResponse", ofType: "json") else { XCTFail("Response file not found"); return}
    guard let data = FileManager.default.contents(atPath: path) else { XCTFail("Response data not found"); return }
    do {
      let parsedResponse = try client.parseData(data, type: ComicResponse.self)
      guard let parsedComic = parsedResponse.data.results.first else { return }
      guard let staticComic = staticResponse.data.results.first else { return }
      XCTAssertEqual(parsedComic.id, staticComic.id)
      XCTAssertEqual(parsedComic.title, staticComic.title)
      XCTAssertEqual(parsedComic.description, staticComic.description)
      XCTAssertEqual(parsedComic.resourceURI, staticComic.resourceURI)

    } catch {
      XCTFail("Data failed to parse into model object")
    }
  }

  func testParse() throws {
    parseTest()
  }

  func testPerformanceParse() throws {
      measure {
        parseTest()
      }
  }

  func testURLGeneration() {
    let ts = Int(Date().timeIntervalSince1970)
    guard let generatedURL = client.generateURL(for: 52564, timestamp: ts) else { XCTFail("Could not generate URL"); return }
    XCTAssertTrue(generatedURL.absoluteString.starts(with: "https://gateway.marvel.com:443/v1/public/comics/52564?ts=\(ts)&apikey=\(Credentials.apiKey)"))
  }

  func testMD5Hash() {
    let ts = 1657947178
    let mockAPIKey = "123456789"
    XCTAssertEqual("c0e322bf4ca49035351ba60518edd88d", Utilities.MD5("\(ts)" + mockAPIKey))
  }

}
