//
//  APIRequest.swift
//  HoloArts
//
//  Created by Oleh Korchytskyi on 06/07/2017.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import Foundation

protocol URLAddressExtention {
    var addressExtention: String { get }
    func extending(address: String?) -> String
}

protocol URLAddressExtendable {
    func append(_ addressExtention: URLAddressExtention?) -> Self?
}

extension URLAddressExtention {
    func extending(address: String?) -> String {
        if address?.characters.last == "/" {
            return "\(address ?? "")\(addressExtention)"
        } else {
            return "\(address ?? "")/\(addressExtention)"
        }
    }
}

extension String: URLAddressExtendable {
    func append(_ addressExtention: URLAddressExtention?) -> String? {
        return addressExtention?.extending(address: self)
    }
}

typealias ServerEnvironment = Server.Environment
typealias ServerClientScope = Server.ClientScope

struct Server {
    
    struct Environment {
        
        typealias Address = String
        
        static let mainAddress: Address = "https://api.vrcafe.titanium.team"
        static let mainEnvironment: Environment = .init()
        
        let address: Address
        
        var url: URL? {
            return URL(string: address)
        }
        
        init(address: Address) {
            self.address = address
        }
        
        init() {
            self.init(address: Environment.mainAddress)
        }
        
    }
    
    static let mainEnvironment = Environment()

    struct ClientScope: URLAddressExtention {
        
        typealias Name = String
        
        static let main: Name = "mobile"
        static let mainScope: ClientScope = .init()
        
        let name: Name
        
        var addressExtention: String {
            return "\(name)"
        }
        
        init(name: Name) {
            self.name = name
        }
        
        init() {
            self.init(name: ClientScope.main)
        }
    }
    
}

enum APIEndpoint: String, URLAddressExtention {
    case SignUp = "sign_up"
    case SignIn = "sign_in"
    case User   = "get_profile"
    case QRLogin = "login_by_qr"
    
    enum Method: String {
        case GET
        case POST
    }
    
    var method: Method {
        switch self {
        case .SignUp,.SignIn,.User,.QRLogin: return .POST
        }
    }
    
    var addressExtention: String {
        switch self {
        case .SignUp,.SignIn,.User,.QRLogin: return rawValue
        }
    }
}

enum APIRequestError: Error {
    case BadRequest
    case DataNotAcquired
    case Deserialization
    case BadData
    case ErrorMessage(String)
    case ResponseError(Error)
    
    var localizedDescription: String {
        switch self {
        case .BadRequest: return "Invalid request."
        case .DataNotAcquired: return "Data not acquired."
        case .Deserialization: return "Cannot deserialise received data."
        case .BadData: return "Cannot handle received data."
        case .ErrorMessage(let message): return message
        case .ResponseError(let error): return error.localizedDescription
        }
    }
}

struct APIRequest {
    
    var environment: ServerEnvironment
    var clientScope: ServerClientScope?
    var endpoint: APIEndpoint
    var headers: [String : String]
    var params: [String : Any]

    var url: URL? {
        
        return URL(string: environment.address.append(clientScope)?.append(endpoint) ?? "")
    }
    
    private var json: (string: String, data: Data)? {
        do {
            
            let data = try JSONSerialization.data(withJSONObject: params)
            
            guard let jsonString: String = String(data: data, encoding: .utf8) else {
                print("Cannot generate JSON string!")
                return nil
            }
            
            return (string: jsonString, data: data)
            
        } catch let error {
            print("JSON generating error:",error.localizedDescription)
            return nil
        }
    }
    
    private var jsonString: String? {
        do {
            
            let json = try JSONSerialization.data(withJSONObject: params)
            
            guard let jsonString: String = String(data: json, encoding: .utf8) else {
                print("Cannot generate JSON string!")
                return nil
            }
            
            return jsonString
            
        } catch let error {
            print("JSON generating error:",error.localizedDescription)
            return nil
        }
    }
    
    private var jsonData: Data? {
        do {
            
            return try JSONSerialization.data(withJSONObject: params)
            
        } catch let error {
            print("JSON generating error:",error.localizedDescription)
            return nil
        }
    }
    
    
    
    var urlComponents: URLComponents? {
        guard let url = self.url else {
            return nil
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        switch endpoint.method {
        case .GET:
            
            var queryItems: [URLQueryItem] = []
            
            for (key,value) in params {
                queryItems.append(.init(name: key, value: String(describing: value)))
            }
            
            components?.queryItems = queryItems
            
            break
        default:
            break
        }
        
        return components
    }
    
    var urlRequest: URLRequest? {
        guard let url = urlComponents?.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        switch endpoint.method {
        case .POST:
            
            if let json = json {
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.setValue("\(json.string.lengthOfBytes(using: .utf8))", forHTTPHeaderField: "Content-Length")
                
                request.httpBody = json.data
                
            }
            
            break
        default:
            break
        }
        
        
        return request
    }
    
    
    init(environment: ServerEnvironment = .mainEnvironment,
         clientScope: ServerClientScope? = .mainScope,
         endpoint: APIEndpoint,
         headers: [String : String] = [:],
         params: [String : Any] = [:]) {
        
        self.environment = environment
        self.clientScope = clientScope
        self.endpoint = endpoint
        self.headers = headers
        self.params = params
        
    }
    
}

struct APIRequestResult {
    let response: String?
    let json: [String : Any]?
}

typealias APIRequestSuccess = (APIRequestResult) -> Void
typealias APIRequestFailure = (APIRequestError) -> Void

protocol PerformingAPIRequest {
    func perform(_ request: APIRequest, _ success: APIRequestSuccess?, _ failure: APIRequestFailure?)
}

extension APIRequest: PerformingAPIRequest { }

extension PerformingAPIRequest where Self == APIRequest {
    
    func perform(_ success: APIRequestSuccess? = nil, _ failure: APIRequestFailure? = nil) {
        perform(self, success, failure)
    }
    
    func perform(_ request: APIRequest, _ success: APIRequestSuccess? = nil, _ failure: APIRequestFailure? = nil) {
        guard let urlRequest = request.urlRequest else {
            failure?(.BadRequest)
            return
        }
        
        print("Will performa data task with URL:", urlRequest.url?.absoluteString ?? "**CANNTO_EXTRACT_URL_ADDRESS**")
        
        if let body = urlRequest.httpBody {
            print("BODY:", String.init(data: body, encoding: .utf8) ?? "**CANNTO_EXTRACT_BODY_STRING**")
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, url, error) in
            if let error = error {
                failure?(.ResponseError(error))
                return
            }
            
            guard let data = data else {
                failure?(.DataNotAcquired)
                return
            }
            
            let responsString = String.init(data: data, encoding: .utf8)

            print("Did received response:", responsString ?? "**CANNOT CONVERT**")
            
            do {
                
                
                if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] {
                    
                    if let errorMessage = json["error"] as? String {
                        failure?(.ErrorMessage(errorMessage))
                    } else {
                        success?(APIRequestResult(response: responsString, json: json))
                    }
                    
                    
                } else {
                    failure?(.Deserialization)
                    return
                }
                
            } catch (let error) {
                print("URL:",url,"Response",responsString)
                print(error)
                failure?(.Deserialization)
                return
            }
            
        }
        
        task.resume()
    }
}

