//
//  WeakDictionary.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/12.
//

import UIKit

public class FMWeakDictionary<Key: AnyObject, Value: AnyObject> {
    public let mapTable: NSMapTable<Key, Value>
      
    init() {
        mapTable = NSMapTable<Key, Value>(
            keyOptions: .weakMemory,
            valueOptions: .weakMemory,
            capacity: 0
        )
    }
      
    subscript(key: Key) -> Value? {
        get { return mapTable.object(forKey: key) }
        set { mapTable.setObject(newValue, forKey: key) }
    }
    
    public func object(forKey:Key?) {
        mapTable.object(forKey: forKey)
    }
    
    public func removeObject(forKey:Key?) {
        mapTable.removeObject(forKey: forKey)
    }
    
    public func count() -> Int{
        return mapTable.count
    }
    
    public func allObjects() -> [AnyObject]?{
        return mapTable.objectEnumerator()?.allObjects as? [AnyObject]
    }
}
