//
//  DisneyMarvelInterviewUITests.swift
//  DisneyMarvelInterviewUITests
//
//  Created by Chris Truman on 7/15/22.
//

import XCTest

class DisneyMarvelInterviewUITests: XCTestCase {

  override func setUpWithError() throws {
      continueAfterFailure = false
  }

  override func tearDownWithError() throws {
  }

  func testBasicFlow() throws {
    let app = XCUIApplication()
    app.tables.staticTexts["Spider-Man/Deadpool (2016) #6"].tap();
    app.navigationBars["Comics"].buttons["Comics"].tap();
  }

  func testDetailFlow() throws {
    let app = XCUIApplication()

    app.tables/*@START_MENU_TOKEN@*/.staticTexts["Spider-Man/Deadpool (2016) #6"]/*[[".cells.staticTexts[\"Spider-Man\/Deadpool (2016) #6\"]",".staticTexts[\"Spider-Man\/Deadpool (2016) #6\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    app/*@START_MENU_TOKEN@*/.scrollViews.containing(.staticText, identifier:"Spider-Man/Deadpool (2016) #6").element/*[[".scrollViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\").element",".scrollViews.containing(.other, identifier:\"Vertical scroll bar, 2 pages\").element",".scrollViews.containing(.staticText, identifier:\"Published: 6\/28\/16\").element",".scrollViews.containing(.staticText, identifier:\"Deadpool goes Hollywood! See the M w\/the M on the set of his own MOVIE! And he brings his pal Spidey along, as he has lots of experience selling out! All-Star Special Issue—written by Scott Aukerman of TV’s Comedy Bang Bang!\").element",".scrollViews.containing(.staticText, identifier:\"Spider-Man\/Deadpool (2016) #6\").element"],[[[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
    app/*@START_MENU_TOKEN@*/.staticTexts["Excelsior"]/*[[".buttons[\"Excelsior\"].staticTexts[\"Excelsior\"]",".staticTexts[\"Excelsior\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    app.alerts["Hi I'm Chris"].scrollViews.otherElements.buttons["Ok"].tap()
    app/*@START_MENU_TOKEN@*/.staticTexts["View Details"]/*[[".buttons[\"View Details\"].staticTexts[\"View Details\"]",".staticTexts[\"View Details\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
  }

  func testAddFlow() throws {
    let app = XCUIApplication()
    let addButton = app.navigationBars["Comics"].buttons["Add"]
    addButton.tap()

    let scrollViewsQuery = app.alerts["Enter Comic ID"].scrollViews
    let elementsQuery = scrollViewsQuery.otherElements
    let textField = elementsQuery.collectionViews.cells.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element
    textField.tap()

    let addButtonSubmit = elementsQuery.buttons["Add"]
    addButtonSubmit.tap()
  }


}
