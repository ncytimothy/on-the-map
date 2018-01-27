//
//  ParseClient.swift
//  On The Map
//
//  Created by Timothy Ng on 1/12/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    // MARK: Properties
    
    // Shared session
    var session = URLSession.shared
    
    // Locations
    var locations: [[String:AnyObject]]? = nil
    
    // MARK: GET
    func taskForGETMethod(_ method: String, _ parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Build the URL, Configure the request */
        
        let request = NSMutableURLRequest(url: parseURL(parameters, withPathExtension: method))
        request.addValue(APIKeys.ParseAppID, forHTTPHeaderField: HTTPHeader.ParseHeader)
        request.addValue(APIKeys.RESTKey, forHTTPHeaderField: HTTPHeader.RESTHeader)
        
        /* 2. Make the request */
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
        /* 3. Parse the data and use the data (in the completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        })
        
        /* 4. Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: POST
    func taskForPOSTMethod(_ method: String, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /*1. Build the URL and Configure the request */
        let request = NSMutableURLRequest(url: parseURL(withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: .utf8)
        
        /* 2. Make the request */
        let task = session.dataTask(with: request as URLRequest, completionHandler: {( data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was error with your request: '\(error)'")
                return
            }
            
            /* GUARD: Was a successful status code returned? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by your request!")
                return
            }
            
            /* 3. Parse the result returned by the request and use the data */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        })
        
        /* 4. Start the request */
        task.resume()
        
        return task
        
    }
    
    // MARK: PUT
    func taskForPUTMethod(_ method: String, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Build the URL and Configure the request */
        let request = NSMutableURLRequest(url: parseURL(withPathExtension: method))
        print("parseURL: \(parseURL(withPathExtension: method))")
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: .utf8)
        
        /* 2. Make the request */
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPUTMethod", code: 1, userInfo: userInfo))
            }
         
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was error with your request: '\(error)'")
                return
            }
            
            /* GUARD: Was there a successful error returned? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
        /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by your request!")
                return
            }
            
            /* 3. Parse the result returned by the request and use the data */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        })

        /* 4. Start the request */
        task.resume()

        return task
        
    }
    
    // Given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        print("parsedResult: \(parsedResult)")
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // Create URL from method
    private func parseURL(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Parse.ApiScheme
        components.host = Constants.Parse.ApiHost
        components.path = Constants.Parse.ParsePath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        
        return components.url!
    }
    
    private func parseURL(withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Parse.ApiScheme
        components.host = Constants.Parse.ApiHost
        components.path = Constants.Parse.ParsePath + (withPathExtension ?? "")
        
        return components.url!
    }
    
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}




