import Foundation

enum HostLocation {
  case localhost
  case LANIP

  var serverURL: URL {
    switch self {
    case .localhost:
      let url = URL(string: "http://localhost:8080")
      return url!
    case .LANIP:
      let url = URL(string: "http://192.168.0.228:8080")
      return url!
    }
  }
}
