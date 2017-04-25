/*
 * Copyright 2017 Himani Shah,
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * instuctor and the University with the right to build and evaluate the software package for the purpose of determining your grade and program assessment
 *
 * Purpose: To add, delete and update placedescription objects from JSON Rpc server
 *
 * Ser423 Mobile Applications
 * @author Himani Shah Himani.shah@asu.edu
 *         Software Engineering, CIDSE, ASU Poly
 * @version April 2017
 */

import Foundation

public class PlaceDescriptionLibrary{
    
    let pdo1: PlaceDescription = PlaceDescription()
    var places:[String:PlaceDescription] = [String:PlaceDescription]()
    var placeNames:[String] = [String]()
    static var id:Int = 0
    var url:String = ""
    public init(){
        if let infoPlist = Bundle.main.infoDictionary {
            self.url = ((infoPlist["ServerURLString"]) as?  String!)!
            NSLog("The default urlString from info.plist is \(self.url)")
        }else{
            NSLog("error getting urlString from info.plist")
        }
        if let jsonpath = Bundle.main.path(forResource: "places", ofType: "json"){
            do{
                let jdata = try Data(contentsOf: URL(fileURLWithPath: jsonpath), options: .alwaysMapped)
                let jsonObj = JSON(data: jdata)
                if jsonObj != JSON.null{
                    for (key,value):(String, JSON) in jsonObj {
                        print("/n/nkey:"+key)

                        let pdo: PlaceDescription = PlaceDescription(name: value["name"].string!, description: value["description"].string!, category: value["category"].string!, addressTitle: value["address-title"].string!, addressStreet: value["address-street"].string!, elevation: value["elevation"].double!, latitude: value["latitude"].double!, longitude: value["longitude"].double!)
                        places[key] = pdo
                    }
                }
                else{
                    print("Could not get json from file, make sure that file contains valid JSON.")
                }
            }catch let error {
                print(error.localizedDescription)
            }
        }
        else{
            print("Name of file is invalid.")
        }
 
        placeNames = Array(places.keys)
        
    }
    

    // used by methods below to send a request asynchronously.
    // asyncHttpPostJson creates and posts a URLRequest that attaches a JSONRPC request as a Data object
    func asyncHttpPostJSON(url: String,  data: Data,
                           completion: @escaping (String, String?) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data
        HTTPsendRequest(request: request, callback: completion)
    }
    
    // sendHttpRequest
    func HTTPsendRequest(request: NSMutableURLRequest,
                         callback: @escaping (String, String?) -> Void) {
        // task.resume() below, causes the shared session http request to be posted in the background
        // (independent of the UI Thread)
        // the use of the DispatchQueue.main.async causes the callback to occur on the main queue --
        // where the UI can be altered, and it occurs after the result of the post is received.
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) -> Void in
            if (error != nil) {
                callback("", error!.localizedDescription)
            } else {
                DispatchQueue.main.async(execute: {callback(NSString(data: data!,
                                                                     encoding: String.Encoding.utf8.rawValue)! as String, nil)})
            }
        }
        task.resume()
    }
    func getNames(callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        PlaceDescriptionLibrary.id = PlaceDescriptionLibrary.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"getNames", "params":[ ], "id":PlaceDescriptionLibrary.id]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    func get(name: String, callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        PlaceDescriptionLibrary.id = PlaceDescriptionLibrary.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"get", "params":[name], "id":PlaceDescriptionLibrary.id]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    func removePlace(name: String, callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        PlaceDescriptionLibrary.id = PlaceDescriptionLibrary.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"remove", "params":[name], "id":PlaceDescriptionLibrary.id]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    func addPlace(jsonObject: NSMutableDictionary, callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        PlaceDescriptionLibrary.id = PlaceDescriptionLibrary.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"add", "params":[jsonObject], "id":PlaceDescriptionLibrary.id]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
}

