//
//  CLLocationCoordinate2D.swift
//  FourteenPoints
//
//  Created by Evan Coleman on 12/29/20.
//

#if canImport(CoreLocation)
import CoreLocation
import Foundation

public extension CLLocationCoordinate2D {
    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        return CLLocation(latitude: latitude, longitude: longitude)
            .distance(from: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
    }
}
#endif
