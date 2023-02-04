import XCTest

@testable import Navigation

final class AuthentificationTests: XCTestCase {
    private var sut: LoginInspector!
    
    override func setUpWithError() throws {
        sut = LoginInspector()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_login_with_invalid_username() {
        let email = "josh"
        let password = ""
        let result = sut.checkCredentials(email: email, password: password)

        XCTAssertTrue(result == LoginResult.wrongEmail, "Email check doesnt work" )
    }
    
    func test_login_with_invalid_password () {
        let email = "josh@mail.ru"
        let password = ""
        let result = sut.checkCredentials(email: email, password: password)
        
        XCTAssertTrue(result == LoginResult.shortPassword, "Password check doesnt work" )
        
    }
    
    func test_login_with_short_passsword () {
        let email = "josh@mail.ru"
        let password = "2323444"
        let result = sut.checkCredentials(email: email, password: password)
        
        XCTAssertTrue(result == LoginResult.userNotFound, "Incorrect check doesnt work" )
        
    }

}

class ChuckJokesGetterTests: XCTestCase {
    var result: Joke?
    private var sut: ChuckJokesGetter!
    
    override func setUpWithError() throws {
        sut = ChuckJokesGetter()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_login_with_short_passsword () {
        let expectation = expectation(description: "Joke received")
        sut.getRandomJoke{joke in
            if joke != nil {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5.0)
    }
    
}



