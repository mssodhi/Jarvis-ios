import Foundation

class JarvisServices {
    
    let BASE_URL = Bundle.main.infoDictionary!["BASE_URL"] as! String
    
    func api(url: String) {
        let apiUrl = NSURL(string: "http://" + BASE_URL + url)
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: apiUrl as! URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                NSLog("HTTP 200: ", url)
             }
        }
        
        task.resume()
        
    }
    
}
