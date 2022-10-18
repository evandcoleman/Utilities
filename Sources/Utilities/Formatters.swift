//
//  Formatters.swift
//  Covidualizer
//
//  Created by Evan Coleman on 6/27/20.
//  Copyright © 2020 Evan Coleman. All rights reserved.
//

#if canImport(Contacts)
import Contacts
import Foundation

public struct Formatters {
    public struct Date {
        public static let monthDayYear = DateFormatter().with {
            $0.dateFormat = "M/d/yy"
        }

        public static let short = DateFormatter().with {
            $0.dateStyle = .medium
            $0.timeStyle = .none
        }

        public static let api = DateFormatter().with {
            $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        }

        public static let apiShort = DateFormatter().with {
            $0.dateFormat = "yyyy-MM-dd"
        }

        public static let relativeFull = RelativeDateTimeFormatter().with {
            $0.unitsStyle = .full
        }
    }

    public struct Address {
        public static let postalAddress = CNPostalAddressFormatter()
    }

    public struct Measurement {
        public static let distance = MeasurementFormatter().with {
            $0.unitStyle  = .medium
            
        }
    }
}
#endif
