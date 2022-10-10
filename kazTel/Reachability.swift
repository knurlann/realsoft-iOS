import Foundation

public class Reachability {

    class func isConnectedToNetwork()->Bool{

        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        let session = URLSession.shared

        session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            print("data \(String(describing: data))")
            print("response \(String(describing: response))")
            print("error \(String(describing: error))")

            if let httpResponse = response as? HTTPURLResponse {
                print("httpResponse.statusCode \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    Status = true
                }
            }

        }).resume()


        return Status
    }
}

let headers = [
    "Content-Type": "application/json",
    "Authorization": "Basic UHVzaCBOb3RpZmljYXRpb25zOnF5MmlnMUgnNztxQkx0RFNRI082elM="
]
