import Foundation

enum Endpoint {
    
    private static let baseURL = "https://dummyjson.com"
    
    case products(limit: Int, skip: Int)
    
    var path: String {
        switch self {
        case .products:
            return "/products"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .products(limit, skip):
            return [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "skip", value: "\(skip)")
            ]
        }
    }
    
    var url: URL? {
        var components = URLComponents(string: Self.baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
}
