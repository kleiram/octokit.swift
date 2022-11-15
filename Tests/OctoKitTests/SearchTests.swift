import OctoKit
import XCTest

class SearchTests: XCTestCase {
  func testGetIssueSearch() {
    let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/search/issues?q=example",
                                        expectedHTTPMethod: "GET",
                                        jsonFile: "issue_search",
                                        statusCode: 200)
    
    let task = Octokit().search(session, query: "example") { response in
      switch response {
      case let .success(issueSearchResult):
          XCTAssertEqual(issueSearchResult.totalCount, 9)
          XCTAssertEqual(issueSearchResult.incompleteResults, false)
          XCTAssertEqual(issueSearchResult.items?.count, 9)
      case let .failure(error):
          XCTAssertNil(error)
      }
    }
  }
}
