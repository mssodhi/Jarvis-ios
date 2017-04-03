import Foundation
import TRON
import SwiftyJSON

let BASE_URL = Bundle.main.infoDictionary!["BASE_URL"] as! String

struct JarvisServices {
    
    let tron = TRON(baseURL: BASE_URL)
    static let sharedInstance = JarvisServices()
    
    func statusCheck(completion: @escaping (HandleSuccess?, Error?) -> ()) {
        let request: APIRequest<HandleSuccess, JSONError> = tron.request("/jarvis/status")
        
        request.perform(withSuccess: { (handleSuccess) in
            completion(handleSuccess, nil)
        }) { (err) in
            completion(nil, err)
        }
    }
    
    func handleInput(command: String) {
        print(command)
        let request: APIRequest<HandleSuccess, JSONError> = tron.request("/jarvis/speech")
        
        request.method = .post
        request.parameters = ["input": command]
        
        request.perform(withSuccess: { (handleSuccess) in
            print("Success")
        }) { (err) in
            print("Error", err)
        }
    }
    
    class HandleSuccess: JSONDecodable {
        required init(json: JSON) throws {
            print("Success")
        }
    }
    
    class JSONError: JSONDecodable {
        required init(json: JSON) throws {
            print("JSON ERROR")
        }
    }
    
}
