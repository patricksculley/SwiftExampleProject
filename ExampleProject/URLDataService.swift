//
//  FetchDataService.swift
//  CoreDataExample
//
//  Created by Patrick Sculley on 6/20/17.
//  Copyright © 2017 Nisum. All rights reserved.
//

import Foundation

class URLDataService {
    
    let serverURLBase = "http://localhost:4002/"
    
    func doURLRequest<T>(objectType:String, responseHandler:@escaping (T?) -> Void)	{
        let requestURL: URL = URL(string: "\(serverURLBase)\(objectType)")!
        let urlRequest: URLRequest = URLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
                if (error == nil) {
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    if (statusCode == 200) {
                        if [Any]() is T   {
                            let array = self.readJSONArray(data: data)
                            responseHandler(array as? T)
                        }
                    }
                } else  {
                    print("doURLRequest error: \(error!.localizedDescription)")
                    responseHandler(nil)
                }
        }
        task.resume()
    }
    
    func readJSONArray(data:Data?) -> [Any]?	{
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
            if let array = json as? [Any]    {
                for object in array {
                    if let jsonObject = object as? Dictionary<String, Any> {
                        if let stringValue = jsonObject["name"] as? String {
                            print("Name: \(stringValue)")
                        }
                    }
                    if let jsonArray = object as? [Any] {
                        print("nestedArray found: \(jsonArray.count)")
                    }
                }
                return array
            }
        } catch {
            print("Error with Json: \(error)")
        }
        return nil
    }
}
