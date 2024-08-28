//
//  HZMemoryCache.swift
//  hz_cache_plugin
//
//  Created by itbox_djx on 2024/8/2.
//

import Foundation

public class MeteorMemoryCache: MeteorSharedCacheApi {
  
    public static let shared = MeteorMemoryCache()
    private init() {}

    private var cache = [String: Any]()
    private let queue = DispatchQueue(label: "com.example.MemoryCacheQueue", attributes: .concurrent)

    public func setString(key: String, value: String?) throws {
        queue.async(flags: .barrier) {
            self.cache[key] = value
        }
    }
    
    public func getString(key: String) throws -> String? {
        return queue.sync {
            return self.cache[key] as? String
        }
    }
    
    public func setBool(key: String, value: Bool?) throws {
        queue.async(flags: .barrier) {
            self.cache[key] = value
        }
    }
    
    public func getBool(key: String) throws -> Bool? {
        return queue.sync {
            return self.cache[key] as? Bool
        }
    }
    
    public func setInt(key: String, value: Int64?) throws {
        queue.async(flags: .barrier) {
            self.cache[key] = value
        }
    }
    
    public func getInt(key: String) throws -> Int64? {
        return queue.sync {
            return self.cache[key] as? Int64
        }
    }
    
    public func setDouble(key: String, value: Double?) throws {
        queue.async(flags: .barrier) {
            self.cache[key] = value
        }
    }
    
    public func getDouble(key: String) throws -> Double? {
        return queue.sync {
            return self.cache[key] as? Double
        }
    }
    
    public func setList(key: String, value: [Any?]?) throws {
        queue.async(flags: .barrier) {
            self.cache[key] = value
        }
    }
    
    public func getList(key: String) throws -> [Any?]? {
        return queue.sync {
            return self.cache[key] as? [Any?]
        }
    }
    
    public func setMap(key: String, value: [String : Any?]?) throws {
        queue.async(flags: .barrier) {
            self.cache[key] = value
        }
    }
    
    public func getMap(key: String) throws -> [String : Any?]? {
        return queue.sync {
            return self.cache[key] as? [String : Any?]
        }
    }
    
    public func setBytes(key: String, value: [Int64]?) throws {
        queue.async(flags: .barrier) {
            self.cache[key] = value
        }
    }
    
    public func getBytes(key: String) throws -> [Int64]? {
        return queue.sync {
            if let int64Array = self.cache[key] as? [Int64]{
                return int64Array
            } else if let data = self.cache[key] as? Data {
                var int64Array: [Int64] = []
                var index = 0
                while index < data.count {
                    let value: Int64 = data.withUnsafeBytes {
                        $0.load(fromByteOffset: index, as: Int64.self)
                    }
                    int64Array.append(value)
                    index += MemoryLayout<Int64>.size
                }
                return int64Array
            } else {
                return nil
            }
        }
    }
    
    public func setData(key: String, data: Data?) {
        queue.async(flags: .barrier) {
            self.cache[key] = data
        }
    }
    
    public func getData(key: String) -> Data? {
        
        return queue.sync {
            if let data = self.cache[key] as? Data {
                return data
            } else if let int64Array = self.cache[key] as? [Int64] {
                var data = Data()
                for value in int64Array {
                    var value = value
                    let valueData = Data(bytes: &value, count: MemoryLayout<Int64>.size)
                    data.append(valueData)
                }
                return data
            }
            return nil
        }
    }
    
    func setValue(key: String, value: Any?) throws {
        queue.async(flags: .barrier) {
            self.cache[key] = value
        }
    }
    func getValue(key: String) throws -> Any? {
        return queue.sync {
            return self.cache[key]
        }
    }
    
    public func clear() {
        queue.async(flags: .barrier) {
            self.cache.removeAll()
        }
    }
}
