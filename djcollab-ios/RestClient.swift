//
//  RestClient.swift
//  djcollab-ios
//
//  Created by Ashley Coleman on 3/4/17.
//  Copyright © 2017 Ashley Coleman. All rights reserved.
//

import UIKit
import Gloss
import Alamofire

struct RestClient {
    
    private static func validatorBase(_ completionHandler: @escaping (_ success: Bool, _ statusCode:Int, _ json:JSON?)-> Void) -> (DataResponse<Any>) -> Void{
        let function: (DataResponse<Any>) -> Void = { response in
            
            let statusCode = response.response?.statusCode ?? -1
            
            if let err = response.result.error{
                print("Unable to connect to the internet: " + String(describing: err))
                completionHandler(false, -1, nil)
                return
            }
            
            if !((statusCode > 199 && statusCode < 300) || statusCode == 401){
                
                print("Request URL: '\(response.request?.url?.absoluteString ?? "")' Status Code: \(String(describing: statusCode))")
                
                if let json = response.result.value as? JSON{
                    print("Error message: \(json)")
                }else{
                    print("Server reported status code: " + String(describing: statusCode))
                }
                
                completionHandler(false, statusCode, nil)
                return
            }
            
            if let json = response.result.value as? JSON{
                completionHandler(true, statusCode, json)
                return
            }
            
            if let jsonArr = response.result.value as? [JSON]{
                
                if(jsonArr.count == 0){
                    completionHandler(true, statusCode, nil)
                    return
                }
                
                let wrappedJSON:JSON = [ "items" : jsonArr ]
                completionHandler(true, statusCode, wrappedJSON)
                return
            }
            
            if(statusCode == 204){
                completionHandler(true, statusCode, nil)
                return
            }
            
            completionHandler(false, statusCode, nil)
            print("Error, Malformed JSON \(response.result.value)")
        }
        
        return function
    }
    
    static func Validator(_ completionHandler: @escaping (_ success: Bool, _ statusCode:Int, _ json:JSON?)-> Void) -> (DataResponse<Any>) -> Void{
        return validatorBase(completionHandler)
    }
    
    static func CreateParty(name: String, _ completionHandler: @escaping (_ success:Bool, _ statusCode: Int, _ json:JSON?) -> Void){
        var parameters:[String:AnyObject] = [:]
        
        parameters["name"] = name as AnyObject?
        parameters["user-id"] = 1 as AnyObject?
        parameters["threshold"] = 5 as AnyObject?
        
        Alamofire.request("http://djcollab.com/api/party", method: .put, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: RestClient.Validator(completionHandler))
    }
    
    static func AddSong(partyID: Int, songURI:String, _ completionHandler: @escaping (_ success:Bool, _ statusCode: Int, _ json:JSON?) -> Void){
        var parameters:[String:AnyObject] = [:]
        
        parameters["party-id"] = partyID as AnyObject?
        parameters["song-id"] = songURI as AnyObject?
        
        Alamofire.request("http://djcollab.com/api/party/song", method: .put, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: RestClient.Validator(completionHandler))
    }
    
    static func DeleteSong(partyID: Int, songURI:String, _ completionHandler: @escaping (_ success:Bool, _ statusCode: Int, _ json:JSON?) -> Void){
        var parameters:[String:AnyObject] = [:]
        
        parameters["party-id"] = partyID as AnyObject?
        parameters["song-id"] = songURI as AnyObject?
        
        Alamofire.request("http://djcollab.com/api/party/song", method: .delete, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: RestClient.Validator(completionHandler))
    }
    
    static func PartyByID(partyID: Int,  _ completionHandler: @escaping (_ success:Bool, _ statusCode: Int, _ json:JSON?) -> Void){
        var parameters:[String:AnyObject] = [:]
        parameters["party-id"] = partyID as AnyObject?
        
        Alamofire.request("http://djcollab.com/api/party/", method: .get, parameters: parameters).responseJSON(completionHandler: RestClient.Validator(completionHandler))
    }
    
    static func PartyByName(name: String,  _ completionHandler: @escaping (_ success:Bool, _ statusCode: Int, _ json:JSON?) -> Void){
        var parameters:[String:AnyObject] = [:]
        parameters["name"] = name as AnyObject?
        
        Alamofire.request("http://djcollab.com/api/party/", method: .get, parameters: parameters).responseJSON(completionHandler: RestClient.Validator(completionHandler))
    }
    
    static func Queue(partyID: Int,  _ completionHandler: @escaping (_ success:Bool, _ statusCode: Int, _ json:JSON?) -> Void){
        var parameters:[String:AnyObject] = [:]
        parameters["party-id"] = partyID as AnyObject?
        
        Alamofire.request("http://djcollab.com/api/queue/", method: .get, parameters: parameters).responseJSON(completionHandler: RestClient.Validator(completionHandler))
    }
}
