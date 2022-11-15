import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

open class IssueSearchResult: Codable {
  open var totalCount: Int?
  open var incompleteResults: Bool?
  open var items: [Issue]?
  
  enum CodingKeys: String, CodingKey {
    case totalCount = "total_count"
    case incompleteResults = "incomplete_results"
    case items
  }
}

// MARK: Request

public extension Octokit {
  @discardableResult
  func search(_ session: RequestKitURLSession = URLSession.shared,
              query: String,
              completion: @escaping (_ response: Result<IssueSearchResult, Error>) -> Void) -> URLSessionDataTaskProtocol? {
    let router = IssueSearchRouter.readIssueSearch(configuration, query)
    
    return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: IssueSearchResult.self) { issueSearchResult, error in
      if let error = error {
        completion(.failure(error))
      } else {
        if let issueSearchResult = issueSearchResult {
          completion(.success(issueSearchResult))
        }
      }
    }
  }
  
  #if compiler(>=5.2.2) && canImport(_Concurrency)
  @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
  func search(_ session: RequestKitURLSession = URLSession.shared,
              query: String) async throws -> IssueSearchResult {
    let router = IssueSearchRouter.readIssueSearch(configuration, query)
    
    return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: IssueSearchResult.self)
  }
  #endif
}

enum IssueSearchRouter: JSONPostRouter {
  case readIssueSearch(Configuration, String)
  
  var method: HTTPMethod {
    switch self {
    case .readIssueSearch:
      return .GET
    }
  }
  
  var encoding: HTTPEncoding {
    switch self {
    default:
      return .url
    }
  }
  
  var configuration: Configuration {
    switch self {
    case let .readIssueSearch(config, _): return config
    }
  }
  
  var params: [String : Any] {
    switch self {
    case let .readIssueSearch(_, query):
      return ["q": query]
    }
  }
  
  var path: String {
    switch self {
    case .readIssueSearch:
      return "/search/issues"
    }
  }
}
