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
 * Purpose: Purpose: iOS app to view and manage place descriptions fetched from JSON file
 *
 * Ser423 Mobile Applications
 * @author Himani Shah Himani.shah@asu.edu
 *         Software Engineering, CIDSE, ASU Poly
 * @version March 2017
 */

import Foundation
class PlaceDescription {
    var name :String
    var description :String
    var category: String
    var addresstitle: String
    var address: String
    var elevation: Double
    var latitude: Double
    var longitude: Double
    public init(){
        self.name = ""
        self.description = ""
        self.category = ""
        self.addresstitle = ""
        self.address = ""
        self.elevation = 0
        self.latitude = 0
        self.longitude = 0
    }
//    public init (jsonStr: String){
//        self.name = ""
//        self.description = ""
//        self.category = ""
//        self.addresstitle = ""
//        self.address = ""
//        self.elevation = 0
//        self.latitude = 0
//        self.longitude = 0
//        
//        if let data: NSData = jsonStr.data(using: String.Encoding.utf8) as NSData?{
//            do{
//                let dict = try JSONSerialization.jsonObject(with: data as Data,options:.mutableContainers) as?[String:AnyObject]
//                self.name = (dict!["name"] as? String)!
//                self.description = (dict!["description"] as? String)!
//                self.category = (dict!["category"] as? String)!
//                self.addresstitle = (dict!["addressTitle"] as? String)!
//                self.address = (dict!["addressStreet"] as? String)!
//                self.elevation = (dict!["elevation"] as? Float)!
//                self.latitude = (dict!["latitude"] as? Float)!
//                self.longitude = (dict!["longitude"] as? Float)!
//            } catch {
//                print("unable to convert Json to a dictionary")
//                
//            }
//        }
//    }
    public init(name: String, description: String, category: String, addressTitle: String, addressStreet: String, elevation: Double, latitude: Double, longitude: Double){
        self.name = name
        self.description = description
        self.category = category
        self.addresstitle = addressTitle
        self.address = addressStreet
        self.elevation = elevation
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public func toJsonString() -> String {
        var jsonStr = "";
        let dict:[String : Any] = ["name": name, "description": description, "category":category, "addresstittle":addresstitle, "address":address, "elvation":elevation, "latitude":latitude, "longitude":longitude] as [String : Any]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            jsonStr = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        } catch let error as NSError {
            print("unable to convert dictionary to a Json Object with error: \(error)")
        }
        return jsonStr
    }
}
