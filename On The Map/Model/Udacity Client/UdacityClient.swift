//
//  UdacityClient.swift
//  On The Map
//
//  Created by Timothy Ng on 1/8/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    //MARK: Properties
    
    // Shared session (default)
    var session = URLSession.shared
    
    // Username and Password
    
    var username: String? = nil
    var password: String? = nil
    


    // MARK: GET
    func taskForGETMethod() {
        
    }
    
    //MARK: POST
    
    func taskForPOSTMethod(_ method: String, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
       
     /* 1. Build the URL and Configure the request */
        let request  = NSMutableURLRequest(url: udacityURLWithPathExtension(withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: .utf8)
       
        
    /* 2. Make the reqeust */
        let task = session.dataTask(with: request as URLRequest, completionHandler: {( data, response, error) in

            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }

            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)!")
                return
            }


            /* GUARD: Was a successful status code returned? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }

            /* GUARD: Was there any data returned? */

            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }

             /* 3. Parse the result returned by the request and use the data */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        })
        
        /* 4. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: DELETE
    func taskForDELETEMethod(_ method: String, completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
    /*1. Build the URL and Congifure the requst */
        let request = NSMutableURLRequest(url: udacityURLWithPathExtension(withPathExtension: method))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
    
   /* 2. Make the request */
        let task = session.dataTask(with: request as URLRequest, completionHandler: {( data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)!")
                return
            }
            
            
            /* GUARD: Was a successful status code returned? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 3. Parse the result by the request and use the data */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDELETE)
        })
        
        /* 4. Start the request */
        task.resume()
        
        return task
    }
        
        
//    var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
//    request.httpMethod = "DELETE"
//    var xsrfCookie: HTTPCookie? = nil
//    let sharedCookieStorage = HTTPCookieStorage.shared
//    for cookie in sharedCookieStorage.cookies! {
//    if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
//    }
//    if let xsrfCookie = xsrfCookie {
//    request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
//    }
//    let session = URLSession.shared
//    let task = session.dataTask(with: request) { data, response, error in
//    if error != nil { // Handle error…
//    return
//    }
//    let range = Range(5..<data!.count)
//    let newData = data?.subdata(in: range) /* subset response data! */
//    print(String(data: newData!, encoding: .utf8)!)
//    }
//    task.resume()
    
    
    
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let range = Range(5..<data.count)
        let newData = data.subdata(in: range) /* subset response data! */
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Cannot parse data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
        
    }
    

    
    
    
    private func udacityURLWithPathExtension(withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Udacity.ApiScheme
        components.host = Constants.Udacity.ApiHost
        components.path = Constants.Udacity.ApiPath + (withPathExtension ?? "")
        
        //NO QUERY ITEMS USED IN THE API: LEFT FOR USE IF NEEDED
//        components.queryItems = [URLQueryItem]()
//
//        for (key, value) in parameters {
//            let queryItem = URLQueryItem(name: key, value: "\(value)")
//            components.queryItems!.append(queryItem)
//        }
        
        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    
    
}
