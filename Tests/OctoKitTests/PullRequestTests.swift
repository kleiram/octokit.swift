import OctoKit
import XCTest

class PullRequestTests: XCTestCase {
    func testGetPullRequest() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls/1",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_request",
                                            statusCode: 200)

        let task = Octokit().pullRequest(session, owner: "octocat", repository: "Hello-World", number: 1) { response in
            switch response {
            case let .success(pullRequests):
                XCTAssertEqual(pullRequests.id, 1)
                XCTAssertEqual(pullRequests.title, "new-feature")
                XCTAssertEqual(pullRequests.body, "Please pull these awesome changes")
                XCTAssertEqual(pullRequests.labels?.count, 1)
                XCTAssertEqual(pullRequests.user?.login, "octocat")

                XCTAssertEqual(pullRequests.base?.label, "master")
                XCTAssertEqual(pullRequests.base?.ref, "master")
                XCTAssertEqual(pullRequests.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(pullRequests.base?.user?.login, "octocat")
                XCTAssertEqual(pullRequests.base?.repo?.name, "Hello-World")

                XCTAssertEqual(pullRequests.head?.label, "new-topic")
                XCTAssertEqual(pullRequests.head?.ref, "new-topic")
                XCTAssertEqual(pullRequests.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(pullRequests.head?.user?.login, "octocat")
                XCTAssertEqual(pullRequests.head?.repo?.name, "Hello-World")
                XCTAssertEqual(pullRequests.requestedReviewers?[0].login, "octocat")
                XCTAssertEqual(pullRequests.draft, false)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetPullRequestAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls/1",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_request",
                                            statusCode: 200)

        let pullRequest = try await Octokit().pullRequest(session, owner: "octocat", repository: "Hello-World", number: 1)
        XCTAssertEqual(pullRequest.id, 1)
        XCTAssertEqual(pullRequest.title, "new-feature")
        XCTAssertEqual(pullRequest.body, "Please pull these awesome changes")
        XCTAssertEqual(pullRequest.labels?.count, 1)
        XCTAssertEqual(pullRequest.user?.login, "octocat")

        XCTAssertEqual(pullRequest.base?.label, "master")
        XCTAssertEqual(pullRequest.base?.ref, "master")
        XCTAssertEqual(pullRequest.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullRequest.base?.user?.login, "octocat")
        XCTAssertEqual(pullRequest.base?.repo?.name, "Hello-World")

        XCTAssertEqual(pullRequest.head?.label, "new-topic")
        XCTAssertEqual(pullRequest.head?.ref, "new-topic")
        XCTAssertEqual(pullRequest.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullRequest.head?.user?.login, "octocat")
        XCTAssertEqual(pullRequest.head?.repo?.name, "Hello-World")
        XCTAssertEqual(pullRequest.requestedReviewers?[0].login, "octocat")
        XCTAssertEqual(pullRequest.draft, false)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetPullRequests() {
        // Test filtering with on the base branch

        let baseSession = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls?base=develop&direction=desc&sort=created&state=open",
                                                expectedHTTPMethod: "GET",
                                                jsonFile: "pull_requests",
                                                statusCode: 200)

        let baseTask = Octokit().pullRequests(baseSession, owner: "octocat", repository: "Hello-World", base: "develop", state: Openness.open) { response in
            switch response {
            case let .success(pullRequests):
                XCTAssertEqual(pullRequests.count, 1)
                XCTAssertEqual(pullRequests.first?.title, "new-feature")
                XCTAssertEqual(pullRequests.first?.body, "Please pull these awesome changes")
                XCTAssertEqual(pullRequests.first?.labels?.count, 1)
                XCTAssertEqual(pullRequests.first?.user?.login, "octocat")

                XCTAssertEqual(pullRequests.first?.base?.label, "master")
                XCTAssertEqual(pullRequests.first?.base?.ref, "master")
                XCTAssertEqual(pullRequests.first?.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(pullRequests.first?.base?.user?.login, "octocat")
                XCTAssertEqual(pullRequests.first?.base?.repo?.name, "Hello-World")

                XCTAssertEqual(pullRequests.first?.head?.label, "new-topic")
                XCTAssertEqual(pullRequests.first?.head?.ref, "new-topic")
                XCTAssertEqual(pullRequests.first?.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(pullRequests.first?.head?.user?.login, "octocat")
                XCTAssertEqual(pullRequests.first?.head?.repo?.name, "Hello-World")
                XCTAssertEqual(pullRequests.first?.requestedReviewers?[0].login, "octocat")
                XCTAssertEqual(pullRequests.first?.draft, false)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(baseTask)
        XCTAssertTrue(baseSession.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetPullRequestsAsync() async throws {
        // Test filtering with on the base branch
        let baseSession = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls?base=develop&direction=desc&sort=created&state=open",
                                                expectedHTTPMethod: "GET",
                                                jsonFile: "pull_requests",
                                                statusCode: 200)

        let pullRequests = try await Octokit().pullRequests(baseSession, owner: "octocat", repository: "Hello-World", base: "develop", state: Openness.open)
        XCTAssertEqual(pullRequests.count, 1)
        XCTAssertEqual(pullRequests.first?.title, "new-feature")
        XCTAssertEqual(pullRequests.first?.body, "Please pull these awesome changes")
        XCTAssertEqual(pullRequests.first?.labels?.count, 1)
        XCTAssertEqual(pullRequests.first?.user?.login, "octocat")

        XCTAssertEqual(pullRequests.first?.base?.label, "master")
        XCTAssertEqual(pullRequests.first?.base?.ref, "master")
        XCTAssertEqual(pullRequests.first?.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullRequests.first?.base?.user?.login, "octocat")
        XCTAssertEqual(pullRequests.first?.base?.repo?.name, "Hello-World")

        XCTAssertEqual(pullRequests.first?.head?.label, "new-topic")
        XCTAssertEqual(pullRequests.first?.head?.ref, "new-topic")
        XCTAssertEqual(pullRequests.first?.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullRequests.first?.head?.user?.login, "octocat")
        XCTAssertEqual(pullRequests.first?.head?.repo?.name, "Hello-World")
        XCTAssertEqual(pullRequests.first?.requestedReviewers?[0].login, "octocat")
        XCTAssertEqual(pullRequests.first?.draft, false)
        XCTAssertTrue(baseSession.wasCalled)
    }
    #endif

    func testGetPullRequestWithHead() {
        // Test filtering with on the head branch
        let headSession = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls?direction=desc&head=octocat%3Anew-topic&sort=created&state=open",
                                                expectedHTTPMethod: "GET",
                                                jsonFile: "pull_requests",
                                                statusCode: 200)

        let headTask = Octokit().pullRequests(headSession, owner: "octocat", repository: "Hello-World", head: "octocat:new-topic", state: Openness.open) { response in
            switch response {
            case let .success(pullRequests):
                XCTAssertEqual(pullRequests.count, 1)
                XCTAssertEqual(pullRequests.first?.title, "new-feature")
                XCTAssertEqual(pullRequests.first?.body, "Please pull these awesome changes")
                XCTAssertEqual(pullRequests.first?.labels?.count, 1)
                XCTAssertEqual(pullRequests.first?.user?.login, "octocat")

                XCTAssertEqual(pullRequests.first?.base?.label, "master")
                XCTAssertEqual(pullRequests.first?.base?.ref, "master")
                XCTAssertEqual(pullRequests.first?.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(pullRequests.first?.base?.user?.login, "octocat")
                XCTAssertEqual(pullRequests.first?.base?.repo?.name, "Hello-World")

                XCTAssertEqual(pullRequests.first?.head?.label, "new-topic")
                XCTAssertEqual(pullRequests.first?.head?.ref, "new-topic")
                XCTAssertEqual(pullRequests.first?.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(pullRequests.first?.head?.user?.login, "octocat")
                XCTAssertEqual(pullRequests.first?.head?.repo?.name, "Hello-World")
                XCTAssertEqual(pullRequests.first?.requestedReviewers?[0].login, "octocat")
                XCTAssertEqual(pullRequests.first?.draft, false)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(headTask)
        XCTAssertTrue(headSession.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetPullRequestsWithHeadAsync() async throws {
        // Test filtering with on the head branch
        let headSession = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls?direction=desc&head=octocat%3Anew-topic&sort=created&state=open",
                                                expectedHTTPMethod: "GET",
                                                jsonFile: "pull_requests",
                                                statusCode: 200)

        let pullRequests = try await Octokit().pullRequests(headSession, owner: "octocat", repository: "Hello-World", head: "octocat:new-topic", state: Openness.open)
        XCTAssertEqual(pullRequests.count, 1)
        XCTAssertEqual(pullRequests.first?.title, "new-feature")
        XCTAssertEqual(pullRequests.first?.body, "Please pull these awesome changes")
        XCTAssertEqual(pullRequests.first?.labels?.count, 1)
        XCTAssertEqual(pullRequests.first?.user?.login, "octocat")

        XCTAssertEqual(pullRequests.first?.base?.label, "master")
        XCTAssertEqual(pullRequests.first?.base?.ref, "master")
        XCTAssertEqual(pullRequests.first?.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullRequests.first?.base?.user?.login, "octocat")
        XCTAssertEqual(pullRequests.first?.base?.repo?.name, "Hello-World")

        XCTAssertEqual(pullRequests.first?.head?.label, "new-topic")
        XCTAssertEqual(pullRequests.first?.head?.ref, "new-topic")
        XCTAssertEqual(pullRequests.first?.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullRequests.first?.head?.user?.login, "octocat")
        XCTAssertEqual(pullRequests.first?.head?.repo?.name, "Hello-World")
        XCTAssertEqual(pullRequests.first?.requestedReviewers?[0].login, "octocat")
        XCTAssertEqual(pullRequests.first?.draft, false)
        XCTAssertTrue(headSession.wasCalled)
    }
    #endif
}
