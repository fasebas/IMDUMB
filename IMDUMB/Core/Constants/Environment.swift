import Foundation

enum Environment {
    static var baseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("BASE_URL not found in Info.plist")
        }
        return url
    }
}
