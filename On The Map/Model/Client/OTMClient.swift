//
//  OTMClient.swift
//  On The Map
//
//  Created by Timothy Ng on 1/8/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation

class OTMClient: NSObject {
    
    //MARK: Properties
    
    // Shared session (default)
    var session = URLSession.shared
    


    // MARK: GET
    func taskForGETMethod() {
        
    }
    
    //MARK: POST
    
    func taskForPOSTMethod(_ method: String, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
    /* 1. Build the URL and Configure the request */
        let request  = NSMutableURLRequest(url: udacityURLWithPathExtension(withPathExtension: method))
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
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
        
    }
    
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Cannot parse data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
    }
    
    func display() {
        print("\(User.username)")
        print("\(User.password)")
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
        
        print(components.url!)
        
        return components.url!
    }
    
    
    
}
