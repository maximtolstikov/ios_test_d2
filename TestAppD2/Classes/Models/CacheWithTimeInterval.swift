//
//  CacheWithTimeInterval.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class CacheWithTimeInterval: NSObject {
    
    private static let cacheKey = "cache"
    private static let maxInterval = 5.0 * 60.0

    class func objectForKey(_ key: String) -> Data? {
        var arrayOfCachedData: [Data] = []
        if UserDefaults.standard.array(forKey: CacheWithTimeInterval.cacheKey) != nil,
           let unwrappedDataArray = UserDefaults.standard.array(forKey: CacheWithTimeInterval.cacheKey) as? [Data] {
            arrayOfCachedData = unwrappedDataArray
        } else {
            arrayOfCachedData = []
        }
        var mutableArrayOfCachedData = arrayOfCachedData
        var deletedCount = 0
        for (index, data) in arrayOfCachedData.enumerated() {
            if let storedData = try? PropertyListDecoder().decode(StoredData.self, from: data),
               abs(storedData.date.timeIntervalSinceNow) < CacheWithTimeInterval.maxInterval {
                if storedData.key == key {
                    return storedData.data
                }
            } else {
                mutableArrayOfCachedData.remove(at: index - deletedCount)
                deletedCount += 1
                UserDefaults.standard.set(mutableArrayOfCachedData, forKey: CacheWithTimeInterval.cacheKey)
            }
        }
        return nil
    }
    
    class func set(data: Data?, for key: String) {
        var arrayOfCachedData: [Data] = []
        if UserDefaults.standard.array(forKey: CacheWithTimeInterval.cacheKey) != nil {
            arrayOfCachedData = UserDefaults.standard.array(forKey: CacheWithTimeInterval.cacheKey) as! [Data]
        }
        if let unwrappedData = data {
            if CacheWithTimeInterval.objectForKey(key) == nil {
                let storedData = StoredData(key: key, date: Date(), data: unwrappedData)
                if let encodedData = try? PropertyListEncoder().encode(storedData) {
                    arrayOfCachedData.append(encodedData)
                }                
            }
        }
        UserDefaults.standard.set(arrayOfCachedData, forKey: CacheWithTimeInterval.cacheKey)
    }
    
}
