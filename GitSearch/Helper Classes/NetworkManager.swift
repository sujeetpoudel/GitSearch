//
//  NetworkManager.swift
//
//  Created by Chanappa on 23/08/19.
//

import Foundation
import UIKit
import SystemConfiguration

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    typealias completionHandlers = (Data?,URLResponse?,Error?) -> Void
    
    let baseURl = "https://api.github.com/search/"
    
    enum NetworkError: LocalizedError {
        case noInternet
        
        var errorDescription: String? {
            switch self {
            case .noInternet:
                return "Internet Connection seems to be offline"
            }
        }
    }
    
    enum HttpMethod: String {
        case get
        case post
        
        func value() -> String {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            }
        }
    }
    
    enum EndPoints {
        case searchUser(String)
        
        func value() -> String {
            switch self {
            case .searchUser(let userName):
                return "users?q=\(userName)"
            }
        }
    }
    
    func callWebservice(withUrl url: URL, httpMethod: HttpMethod, parameters: Data?, header: [String:String]?,completionHandler:@escaping completionHandlers) {
        
        if Reachability.isConnectedToNetwork() {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.value()
            request.httpBody = parameters
            request.allHTTPHeaderFields = header
            let session = URLSession.shared
            DispatchQueue.global(qos: .default).async {
                let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
                    
                    completionHandler(data, response, error)
                }
                dataTask.resume()
            }
        } else {
            completionHandler(nil,nil,NetworkError.noInternet)
        }
        
    }
    
}

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}
