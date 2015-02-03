//
//  Mapcode.swift
//  MapCode
//
//  Created by Dmitry Shmidt on 19/08/14.
//  Copyright (c) 2014 Dmitry Shmidt. All rights reserved.
//

import Foundation
import CoreLocation
class Mapcode {

    func mapCode(fromCoordinate coordinate:CLLocationCoordinate2D, region:String?) -> String? {
        if let regionCode = region {
            println("regionCode: \(regionCode)")
        }
        let lat = coordinate.latitude
        let lon =  coordinate.longitude
        let mapcode = MapcodeHelper.mapcodeCoordinate(coordinate, error: nil)//{
        return mapcode
    }
    
    func coordinate(fromMapCode mapCode:String) -> CLLocationCoordinate2D {
        
        let coord = MapcodeHelper.coordinateFromMapcode(mapCode, error: nil)
        return coord
    }
}
