import UIKit

public enum ErrorHandlingDomain: Error, Equatable {

  public static func == (lhs: ErrorHandlingDomain, rhs: ErrorHandlingDomain) -> Bool {
    lhs.localizedDescription == rhs.localizedDescription
  }

  case noDataReceived
  case noTokenParsed
  case requestError(errorCode: HTTPURLResponse)
  case parsingFailed
  case wrongCredentials
  case tokenExpired
  case unknownError
  case imageDataConvertingError
  case serverUnreachable
  case noUserStored
  case noPostsStored
  case noTokenStored
  case unavailableInOfflineMode
  case networkError(error: Error)
  var localizedDescription: (String, String) {
    switch self {
    case
      .noDataReceived:
      return ("No data received", "Data task cannot retrieve the data piece")
    case .noTokenParsed:
      return ("Cannot parse a token", "Cannot get token from received data")
    case .parsingFailed:
      return ("Parsing error", "Failed to decode received data")
    case .wrongCredentials:
      return ("Login failed", "Wrong credentials provided")
    case .tokenExpired:
      return ("Token expired", "Please sign in")
    case .unknownError:
      return ("Unidentified error", "Something goes wrong")
    case .imageDataConvertingError:
      return("Image processing error", "Can't convert image data to base64String")
    case .serverUnreachable:
      return("The server is unreachable at this moment", "The application switched to offline mode")
    case .networkError(error: let error):
      return ("Network error", error.localizedDescription)
    case .noUserStored:
      return("No offline data", "The requested user wasn't cached at offline store")
    case .noPostsStored:
      return ("No offline data", "The requested post or posts not saved at offline store")
    case .unavailableInOfflineMode:
      return ("Offline mode", "This function is unavailable due to offline mode" )
    case .noTokenStored:
      return ("Here is no stored accounts", "Please sign in")
    case .requestError(let errorCode):
      switch errorCode.statusCode {
      case 404:
        return ("404", "Not found")
      case 400:
        return ("400", "Bad request")
      case 401:
        return ("401", "Unauthorized. Please sign in again")
      case 406:
        return ("406", "Not acceptable")
      case 422:
        return ("422", "Unprocessable")
      default:
        return ("Unknown error", "Unknown error")
      }
    }
  }
}
