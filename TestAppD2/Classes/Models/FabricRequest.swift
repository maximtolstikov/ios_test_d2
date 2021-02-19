//
//  FabricRequest.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

final class FabricRequest: NSObject {
    
    class func request(tagged stringTagged: String, numberOfPageToLoad: Int, withBlock completionHandler: @escaping (_ data: Data?) -> Void) {
        let protocolHostPath = "https://api.stackexchange.com/2.2/questions"
        let parameters = "order=desc&sort=activity&site=stackoverflow&key=G*0DJzE8SfBrKn4tMej85Q(("
        let stringURL = protocolHostPath + "?" + parameters + "&pagesize=50&tagged=" + stringTagged + String(format: "&page=%ld", numberOfPageToLoad)
        if CacheWithTimeInterval.objectForKey(stringURL) == nil {
            let stringURL = protocolHostPath + "?" + parameters + "&pagesize=50&tagged=" + stringTagged + String(format: "&page=%ld", numberOfPageToLoad)
            guard let request = request(for: stringURL) else {
                completionHandler(nil)
                return
            }
            let task: URLSessionDataTask = urlSession().dataTask(with: request) { (data, _, _) in
                guard let data = data else {
                    completionHandler(nil)
                    return
                }
                completionHandler(data)
                CacheWithTimeInterval.set(data: data, for: stringURL)
            }
            task.resume()
        } else {
            completionHandler(CacheWithTimeInterval.objectForKey(stringURL))
        }
    }
    
    class func request(withQuestionID questionID: Int, withBlock completionHandler: @escaping (_ data: Data?) -> Void) {
        let protocolHostPath = "https://api.stackexchange.com/2.2/questions"
        let parameters = "order=desc&sort=activity&site=stackoverflow&key=G*0DJzE8SfBrKn4tMej85Q(("
        let stringURL = String(format: "%@/%li/answers?%@&filter=!9YdnSMKKT", protocolHostPath, questionID, parameters)
        guard let request = request(for: stringURL) else {
            completionHandler(nil)
            return
        }
        let task: URLSessionDataTask = urlSession().dataTask(with: request) { (data, _, _) in
            guard let data = data else {
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }
        task.resume()
    }
    
    class private func urlSession() -> URLSession {
        let defaultConfiguration = URLSessionConfiguration.default
        return URLSession(configuration: defaultConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    class private func request(for stringUrl: String) -> URLRequest? {
        guard let unwrappedUrl = URL(string: stringUrl) else {
            assertionFailure()
            return nil
        }
        var request = URLRequest(url: unwrappedUrl)
        request.httpMethod = "GET"
        return request
    }
}
