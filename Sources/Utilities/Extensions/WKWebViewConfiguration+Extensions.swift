//
//  WKWebViewConfiguration+Extensions.swift
//  
//
//  Created by Evan Coleman on 6/8/22.
//

import Foundation
import WebKit

extension WKWebViewConfiguration {
    public func clearAllWebsiteData() {
        let allTypes: Set<String> = [
            WKWebsiteDataTypeSessionStorage,
            WKWebsiteDataTypeCookies,
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeMemoryCache,
            WKWebsiteDataTypeWebSQLDatabases,
            WKWebsiteDataTypeLocalStorage,
            WKWebsiteDataTypeIndexedDBDatabases,
            WKWebsiteDataTypeOfflineWebApplicationCache,
        ]
        websiteDataStore.fetchDataRecords(ofTypes: allTypes) { records in
            self.websiteDataStore.removeData(
                ofTypes: allTypes,
                for: records,
                completionHandler: {}
            )
        }
    }
}
