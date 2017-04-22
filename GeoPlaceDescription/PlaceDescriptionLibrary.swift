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

public class PlaceDescriptionLibrary{
    
    let pdo1: PlaceDescription = PlaceDescription()
    var places:[String:PlaceDescription] = [String:PlaceDescription]()
    var placeNames:[String] = [String]()
    
    public init(){
        if let jsonpath = Bundle.main.path(forResource: "places", ofType: "json"){
            do{
                let jdata = try Data(contentsOf: URL(fileURLWithPath: jsonpath), options: .alwaysMapped)
                let jsonObj = JSON(data: jdata)
                if jsonObj != JSON.null{
                    for (key,value):(String, JSON) in jsonObj {
                        print("/n/nkey:"+key)
                        
//                        let straddt = "{\"addressTitle\":"+value["address-title"].string!
//                        let stradds = ",\"addressStreet\":"+value["address-street"].string!
//                        let strelev = ",\"elevation\":" + String(value["elevation"].float!)
//                        let strlat = ",\"latitude\":" + String(value["latitude"].float!)
//                        let strlong = ",\"longitude\":" + String(value["longitude"].float!)
//                        let strnam = ",\"name\":"+value["name"].string!
//                        let strdes = ",\"description\":"+value["description"].string!
//                        let strcate = ",\"category\":"+value["category"].string!+"}"
//                        let str = straddt + stradds + strelev + strlat + strlong + strnam + strdes + strcate
//                        let place1: PlaceDescription = PlaceDescription(jsonStr: str)
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
        
        
//        let place1: PlaceDescription = PlaceDescription(jsonStr:"{\"addressTitle\":\"ASU West Campus\",\"addressStreet\":\"13591 N 47th Ave$Phoenix AZ 85051\",\"elevation\":1100.0,\"latitude\":33.608979,\"longitude\":-112.159469,\"name\":\"ASU-West\",\"description\":\"Home of ASU's Applied Computing Program\",\"category\":\"School\"}")
//        
//        let place2: PlaceDescription = PlaceDescription(jsonStr:"{\"addressTitle\":\"University of Alaska at Anchorage\",\"addressStreet\":\"290 Spirit Dr$Anchorage AK 99508\",\"elevation\":0.0,\"latitude\": 61.189748,\"longitude\":-149.826721,\"name\":\"UAK-Anchorage\",\"description\":\"University of Alaska's largest campus\",\"category\":\"School\"}")
//        
//        places = ["ASU-West":place1, "UAK-Anchorage":place2]
        placeNames = Array(places.keys)
        
    }
    
    func getPlaceTitles() -> [String]{
        return placeNames
    }
    
    func getPlaceDescription(placeTitle : String) -> PlaceDescription{
        return places[placeTitle]!
    }
    func remove(selectedPlace: String){
        places.removeValue(forKey: selectedPlace)
        self.placeNames = Array(places.keys)
    }
    func add(selectedPlace: PlaceDescription, placeTitle : String) {
        places[placeTitle] = selectedPlace
        self.placeNames = Array(places.keys)
    }
}

