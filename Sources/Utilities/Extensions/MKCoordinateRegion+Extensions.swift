//
//  MKCoordinateSpan+Extensions.swift
//  Clean Kitchen
//
//  Created by Evan Coleman on 11/23/21.
//

#if canImport(UIKit)
#if canImport(CoreLocation)
import CoreLocation
import MapKit
import UIKit

public extension MKCoordinateRegion {
    var radius: Double {
        let loc1 = CLLocation(
            latitude: center.latitude - span.latitudeDelta * 0.5,
            longitude: center.longitude
        )
        let loc2 = CLLocation(
            latitude: center.latitude + span.latitudeDelta * 0.5,
            longitude: center.longitude
        )
        let loc3 = CLLocation(
            latitude: center.latitude,
            longitude: center.longitude - span.longitudeDelta * 0.5
        )
        let loc4 = CLLocation(
            latitude: center.latitude,
            longitude: center.longitude + span.longitudeDelta * 0.5
        )

        let metersInLatitude = loc1.distance(from: loc2)
        let metersInLongitude = loc3.distance(from: loc4)

        return max(metersInLatitude, metersInLongitude)
    }

    var mapRect: MKMapRect {
        let topLeft = CLLocationCoordinate2D(
            latitude: center.latitude + (span.latitudeDelta / 2),
            longitude: center.longitude - (span.longitudeDelta / 2)
        )
        let bottomRight = CLLocationCoordinate2D(
            latitude: center.latitude - (span.latitudeDelta / 2),
            longitude: center.longitude + (span.longitudeDelta / 2)
        )
        let a = MKMapPoint(topLeft)
        let b = MKMapPoint(bottomRight)

        return MKMapRect(
            origin: MKMapPoint(x: min(a.x, b.x), y: min(a.y, b.y)),
            size: MKMapSize(width: abs(a.x - b.x), height: abs(a.y - b.y))
        )
    }

    func inset(by edgeInsets: UIEdgeInsets) -> MKCoordinateRegion {
        let mapRect = self.mapRect
        let rect = CGRect(x: mapRect.origin.x, y: mapRect.origin.y, width: mapRect.width, height: mapRect.height)
            .inset(by: edgeInsets)

        return MKCoordinateRegion(MKMapRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height))
    }
}
#endif
#endif
