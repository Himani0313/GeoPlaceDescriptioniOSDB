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
 * Purpose: Purpose: iOS app to view and manage place descriptions fetched from iOS core data and intialized by JSON file.
 *
 * Ser423 Mobile Applications
 * @author Himani Shah Himani.shah@asu.edu
 *         Software Engineering, CIDSE, ASU Poly
 * @version April 2017
 */


import Foundation
import CoreData
import UIKit

public class PlaceDescriptionLibrary{
    
    let pdo1: PlaceDescription = PlaceDescription()
    var places:[String:PlaceDescription] = [String:PlaceDescription]()
    var placeNames:[String] = [String]()
    var mContext:NSManagedObjectContext?
    public init(){
        self.mContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if(isEmpty()){
            if let jsonpath = Bundle.main.path(forResource: "places", ofType: "json"){
                do{
                    let jdata = try Data(contentsOf: URL(fileURLWithPath: jsonpath), options: .alwaysMapped)
                    let jsonObj = JSON(data: jdata)
                    if jsonObj != JSON.null{
                        for (_,subJson):(String, JSON) in jsonObj {
                            //print("/n/nkey:"+key)
                            
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
                            let pdo: PlaceDescription = PlaceDescription(name: subJson["name"].string!, description: subJson["description"].string!, category: subJson["category"].string!, addressTitle: subJson["address-title"].string!, addressStreet: subJson["address-street"].string!, elevation: subJson["elevation"].double!, latitude: subJson["latitude"].double!, longitude: subJson["longitude"].double!)
                            //places[key] = pdo
                            let entityname = NSEntityDescription.entity(forEntityName: "Places", in: mContext!)
                            let placeObj = NSManagedObject(entity: entityname!, insertInto: mContext)
                            placeObj.setValue(pdo.name, forKey:"name")
                            placeObj.setValue(pdo.description, forKey:"desc")
                            placeObj.setValue(pdo.category, forKey:"category")
                            placeObj.setValue(pdo.addresstitle, forKey:"addtitle")
                            placeObj.setValue(pdo.address, forKey:"address")
                            placeObj.setValue(pdo.elevation, forKey:"elevation")
                            placeObj.setValue(pdo.latitude, forKey:"latitude")
                            placeObj.setValue(pdo.longitude, forKey:"longitude")
                            
                            do{
                                try mContext!.save()
                            } catch let error as NSError{
                                print("Error core data adding Place \(pdo.name). Error: \(String(describing:error))")
                            }
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
        }
        
        
        
//        let place1: PlaceDescription = PlaceDescription(jsonStr:"{\"addressTitle\":\"ASU West Campus\",\"addressStreet\":\"13591 N 47th Ave$Phoenix AZ 85051\",\"elevation\":1100.0,\"latitude\":33.608979,\"longitude\":-112.159469,\"name\":\"ASU-West\",\"description\":\"Home of ASU's Applied Computing Program\",\"category\":\"School\"}")
//        
//        let place2: PlaceDescription = PlaceDescription(jsonStr:"{\"addressTitle\":\"University of Alaska at Anchorage\",\"addressStreet\":\"290 Spirit Dr$Anchorage AK 99508\",\"elevation\":0.0,\"latitude\": 61.189748,\"longitude\":-149.826721,\"name\":\"UAK-Anchorage\",\"description\":\"University of Alaska's largest campus\",\"category\":\"School\"}")
//        
//        places = ["ASU-West":place1, "UAK-Anchorage":place2]
        
        //placeNames = Array(places.keys)
        
    }
    func isEmpty() -> Bool{
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
            let count  = try mContext?.count(for: request)
            return count == 0 ? true : false
        }catch{
            return true
        }
    }
    func getPlaceTitles() -> [String]{
        var placeNames:[String] = [String]()
        let selectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        do{
            let results = try mContext!.fetch(selectRequest)
            for placeObj in results {
                let pName:String = ((placeObj as AnyObject).value(forKey: "name") as? String)!
                placeNames.append(pName)
            }
        } catch let error as NSError{
            print("Error selecting all student names from core data: \(String(describing:error))")
        }
        
        return placeNames
    }
    
    func getPlaceDescription(placeTitle : String) -> PlaceDescription{
        let pdObj:PlaceDescription = PlaceDescription()
        let selectRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Places")
        selectRequest.predicate = NSPredicate(format: "name == %@", placeTitle)
        do {
            let results = try mContext!.fetch(selectRequest)
            if results.count > 0 {
                pdObj.name = placeTitle
                pdObj.description = ((results[0] as AnyObject).value(forKey: "desc") as? String)!
                pdObj.category = ((results[0] as AnyObject).value(forKey: "category") as? String)!
                pdObj.addresstitle = ((results[0] as AnyObject).value(forKey: "addtitle") as? String)!
                pdObj.address = ((results[0] as AnyObject).value(forKey: "address") as? String)!
                pdObj.elevation = ((results[0] as AnyObject).value(forKey: "elevation") as? Double)!
                pdObj.latitude = ((results[0] as AnyObject).value(forKey: "latitude") as? Double)!
                pdObj.longitude = ((results[0] as AnyObject).value(forKey: "longitude") as? Double)!
            }
        } catch let error as NSError {
            print("Error in core data get: \(String(describing:error))")
        }
        
        return pdObj
    }
    func remove(selectedPlace: String){
        let selectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        selectRequest.predicate = NSPredicate(format: "name == %@",selectedPlace)
        do{
            let results = try mContext!.fetch(selectRequest)
            if results.count > 0 {
                mContext!.delete(results[0] as! NSManagedObject)
                try mContext?.save()
            }
        } catch let error as NSError{
            print("Core data remove of student \(selectedPlace), encountered error: \(String(describing:error))")
        }
    }
    func add(selectedPlace: PlaceDescription, placeTitle : String) {
        let entityname = NSEntityDescription.entity(forEntityName: "Places", in: mContext!)
        let placeObj = NSManagedObject(entity: entityname!, insertInto: mContext)
        placeObj.setValue(selectedPlace.name, forKey:"name")
        placeObj.setValue(selectedPlace.description, forKey:"desc")
        placeObj.setValue(selectedPlace.category, forKey:"category")
        placeObj.setValue(selectedPlace.addresstitle, forKey:"addtitle")
        placeObj.setValue(selectedPlace.address, forKey:"address")
        placeObj.setValue(selectedPlace.elevation, forKey:"elevation")
        placeObj.setValue(selectedPlace.latitude, forKey:"latitude")
        placeObj.setValue(selectedPlace.longitude, forKey:"longitude")
        
        do{
            try mContext!.save()
        } catch let error as NSError{
            print("Error core data adding Place \(selectedPlace.name). Error: \(String(describing:error))")
        }
    }
    func update(placeTitle : String, selectedPlace : PlaceDescription) {
        let selectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        selectRequest.predicate = NSPredicate(format: "name == %@", placeTitle)
        do{
            let results = try mContext!.fetch(selectRequest)
            if results.count>0 {
                let placeObj = results[0] as! NSManagedObject
                placeObj.setValue(selectedPlace.name, forKey:"name")
                placeObj.setValue(selectedPlace.description, forKey:"desc")
                placeObj.setValue(selectedPlace.category, forKey:"category")
                placeObj.setValue(selectedPlace.addresstitle, forKey:"addtitle")
                placeObj.setValue(selectedPlace.address, forKey:"address")
                placeObj.setValue(selectedPlace.elevation, forKey:"elevation")
                placeObj.setValue(selectedPlace.latitude, forKey:"latitude")
                placeObj.setValue(selectedPlace.longitude, forKey:"longitude")
                try mContext?.save()
            }
        }
        catch let error as NSError{
            print("Error core data adding Place \(selectedPlace.name). Error: \(String(describing:error))")
        }
    }
}

