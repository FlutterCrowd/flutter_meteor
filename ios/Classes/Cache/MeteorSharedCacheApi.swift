// Autogenerated from Pigeon (v21.1.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

/// Error class for passing custom error details to Dart side.
final class PigeonError: Error {
  let code: String
  let message: String?
  let details: Any?

  init(code: String, message: String?, details: Any?) {
    self.code = code
    self.message = message
    self.details = details
  }

  var localizedDescription: String {
    return
      "PigeonError(code: \(code), message: \(message ?? "<nil>"), details: \(details ?? "<nil>")"
      }
}

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let pigeonError = error as? PigeonError {
    return [
      pigeonError.code,
      pigeonError.message,
      pigeonError.details,
    ]
  }
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details,
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)",
  ]
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}
private class HzSharedCacheApiPigeonCodecReader: FlutterStandardReader {
}

private class HzSharedCacheApiPigeonCodecWriter: FlutterStandardWriter {
}

private class HzSharedCacheApiPigeonCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return HzSharedCacheApiPigeonCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return HzSharedCacheApiPigeonCodecWriter(data: data)
  }
}

class HzSharedCacheApiPigeonCodec: FlutterStandardMessageCodec, @unchecked Sendable {
  static let shared = HzSharedCacheApiPigeonCodec(readerWriter: HzSharedCacheApiPigeonCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol MeteorSharedCacheApi {
  func setString(key: String, value: String?) throws
  func getString(key: String) throws -> String?
  func setBool(key: String, value: Bool?) throws
  func getBool(key: String) throws -> Bool?
  func setInt(key: String, value: Int64?) throws
  func getInt(key: String) throws -> Int64?
  func setDouble(key: String, value: Double?) throws
  func getDouble(key: String) throws -> Double?
  func setList(key: String, value: [Any?]?) throws
  func getList(key: String) throws -> [Any?]?
  func setMap(key: String, value: [String: Any?]?) throws
  func getMap(key: String) throws -> [String: Any?]?
  func setBytes(key: String, value: [Int64]?) throws
  func getBytes(key: String) throws -> [Int64]?
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class MeteorCacheApiSetup {
  static var codec: FlutterStandardMessageCodec { HzSharedCacheApiPigeonCodec.shared }
  /// Sets up an instance of `CacheApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: MeteorSharedCacheApi?, messageChannelSuffix: String = "") {
    let channelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
    let setStringChannel = FlutterBasicMessageChannel(name: "cn.itbox.flutter_meteor.CacheApi.setString\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setStringChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        let valueArg: String? = nilOrValue(args[1])
        do {
          try api.setString(key: keyArg, value: valueArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setStringChannel.setMessageHandler(nil)
    }
    let getStringChannel = FlutterBasicMessageChannel(name: "cn.itbox.flutter_meteor.CacheApi.getString\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getStringChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        do {
          let result = try api.getString(key: keyArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getStringChannel.setMessageHandler(nil)
    }
    let setBoolChannel = FlutterBasicMessageChannel(name: "cn.itbox.flutter_meteor.CacheApi.setBool\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setBoolChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        let valueArg: Bool? = nilOrValue(args[1])
        do {
          try api.setBool(key: keyArg, value: valueArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setBoolChannel.setMessageHandler(nil)
    }
    let getBoolChannel = FlutterBasicMessageChannel(name: "cn.itbox.flutter_meteor.CacheApi.getBool\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getBoolChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        do {
          let result = try api.getBool(key: keyArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getBoolChannel.setMessageHandler(nil)
    }
    let setIntChannel = FlutterBasicMessageChannel(name: "cn.itbox.flutter_meteor.CacheApi.setInt\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setIntChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        let valueArg: Int64? = isNullish(args[1]) ? nil : (args[1] is Int64? ? args[1] as! Int64? : Int64(args[1] as! Int32))
        do {
          try api.setInt(key: keyArg, value: valueArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setIntChannel.setMessageHandler(nil)
    }
    let getIntChannel = FlutterBasicMessageChannel(name: "cn.itbox.flutter_meteor.CacheApi.getInt\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getIntChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        do {
          let result = try api.getInt(key: keyArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getIntChannel.setMessageHandler(nil)
    }
    let setDoubleChannel = FlutterBasicMessageChannel(name: "cn.itbox.flutter_meteor.CacheApi.setDouble\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setDoubleChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        let valueArg: Double? = nilOrValue(args[1])
        do {
          try api.setDouble(key: keyArg, value: valueArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setDoubleChannel.setMessageHandler(nil)
    }
    let getDoubleChannel = FlutterBasicMessageChannel(name: "cn.itbox.flutter_meteor.CacheApi.getDouble\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getDoubleChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        do {
          let result = try api.getDouble(key: keyArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getDoubleChannel.setMessageHandler(nil)
    }
    let setListChannel = FlutterBasicMessageChannel(name: "cn.itbox.flutter_meteor.CacheApi.setList\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setListChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        let valueArg: [Any?]? = nilOrValue(args[1])
        do {
          try api.setList(key: keyArg, value: valueArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setListChannel.setMessageHandler(nil)
    }
    let getListChannel = FlutterBasicMessageChannel(name: "cn.itbox.flutter_meteor.CacheApi.getList\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getListChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        do {
          let result = try api.getList(key: keyArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getListChannel.setMessageHandler(nil)
    }
    let setMapChannel = FlutterBasicMessageChannel(name: "cn.itbox.flutter_meteor.CacheApi.setMap\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setMapChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        let valueArg: [String: Any?]? = nilOrValue(args[1])
        do {
          try api.setMap(key: keyArg, value: valueArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setMapChannel.setMessageHandler(nil)
    }
    let getMapChannel = FlutterBasicMessageChannel(name: "cn.itbox.flutter_meteor.CacheApi.getMap\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getMapChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        do {
          let result = try api.getMap(key: keyArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getMapChannel.setMessageHandler(nil)
    }
    let setBytesChannel = FlutterBasicMessageChannel(name: "cn.itbox.flutter_meteor.CacheApi.setBytes\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setBytesChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        let valueArg: [Int64]? = nilOrValue(args[1])
        do {
          try api.setBytes(key: keyArg, value: valueArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setBytesChannel.setMessageHandler(nil)
    }
    let getBytesChannel = FlutterBasicMessageChannel(name: "cn.itbox.flutter_meteor.CacheApi.getBytes\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getBytesChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let keyArg = args[0] as! String
        do {
          let result = try api.getBytes(key: keyArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getBytesChannel.setMessageHandler(nil)
    }
  }
}
