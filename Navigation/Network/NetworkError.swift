
import Foundation

enum NetworkError: Error {
    case `default`
    case serverError
    case parseError(reason: String)
    case unknownError
}
