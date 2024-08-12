// Autogenerated from Pigeon (v21.1.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
@file:Suppress("UNCHECKED_CAST", "ArrayInDataClass")


import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  return if (exception is FlutterError) {
    listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()
private object SharedCacheApiPigeonCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return     super.readValueOfType(type, buffer)
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    super.writeValue(stream, value)
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface MeteorCacheApi {
  fun setString(key: String, value: String?)
  fun getString(key: String): String?
  fun setBool(key: String, value: Boolean?)
  fun getBool(key: String): Boolean?
  fun setInt(key: String, value: Long?)
  fun getInt(key: String): Long?
  fun setDouble(key: String, value: Double?)
  fun getDouble(key: String): Double?
  fun setList(key: String, value: List<Any?>?)
  fun getList(key: String): List<Any?>?
  fun setMap(key: String, value: Map<String, Any?>?)
  fun getMap(key: String): Map<String, Any?>?
  fun setBytes(key: String, value: List<Long>?)
  fun getBytes(key: String): List<Long>?

  companion object {
    /** The codec used by CacheApi. */
    val codec: MessageCodec<Any?> by lazy {
      SharedCacheApiPigeonCodec
    }
    /** Sets up an instance of `CacheApi` to handle messages through the `binaryMessenger`. */
    @JvmOverloads
    fun setUp(binaryMessenger: BinaryMessenger, api: MeteorCacheApi?, messageChannelSuffix: String = "") {
      val separatedMessageChannelSuffix = if (messageChannelSuffix.isNotEmpty()) ".$messageChannelSuffix" else ""
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "cn.itbox.flutter_meteor.CacheApi.setString$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val keyArg = args[0] as String
            val valueArg = args[1] as String?
            val wrapped: List<Any?> = try {
              api.setString(keyArg, valueArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "cn.itbox.flutter_meteor.CacheApi.getString$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val keyArg = args[0] as String
            val wrapped: List<Any?> = try {
              listOf(api.getString(keyArg))
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "cn.itbox.flutter_meteor.CacheApi.setBool$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val keyArg = args[0] as String
            val valueArg = args[1] as Boolean?
            val wrapped: List<Any?> = try {
              api.setBool(keyArg, valueArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "cn.itbox.flutter_meteor.CacheApi.getBool$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val keyArg = args[0] as String
            val wrapped: List<Any?> = try {
              listOf(api.getBool(keyArg))
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "cn.itbox.flutter_meteor.CacheApi.setInt$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val keyArg = args[0] as String
            val valueArg = args[1].let { num -> if (num is Int) num.toLong() else num as Long? }
            val wrapped: List<Any?> = try {
              api.setInt(keyArg, valueArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "cn.itbox.flutter_meteor.CacheApi.getInt$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val keyArg = args[0] as String
            val wrapped: List<Any?> = try {
              listOf(api.getInt(keyArg))
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "cn.itbox.flutter_meteor.CacheApi.setDouble$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val keyArg = args[0] as String
            val valueArg = args[1] as Double?
            val wrapped: List<Any?> = try {
              api.setDouble(keyArg, valueArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "cn.itbox.flutter_meteor.CacheApi.getDouble$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val keyArg = args[0] as String
            val wrapped: List<Any?> = try {
              listOf(api.getDouble(keyArg))
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "cn.itbox.flutter_meteor.CacheApi.setList$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val keyArg = args[0] as String
            val valueArg = args[1] as List<Any?>?
            val wrapped: List<Any?> = try {
              api.setList(keyArg, valueArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "cn.itbox.flutter_meteor.CacheApi.getList$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val keyArg = args[0] as String
            val wrapped: List<Any?> = try {
              listOf(api.getList(keyArg))
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "cn.itbox.flutter_meteor.CacheApi.setMap$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val keyArg = args[0] as String
            val valueArg = args[1] as Map<String, Any?>?
            val wrapped: List<Any?> = try {
              api.setMap(keyArg, valueArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "cn.itbox.flutter_meteor.CacheApi.getMap$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val keyArg = args[0] as String
            val wrapped: List<Any?> = try {
              listOf(api.getMap(keyArg))
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "cn.itbox.flutter_meteor.CacheApi.setBytes$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val keyArg = args[0] as String
            val valueArg = args[1] as List<Long>?
            val wrapped: List<Any?> = try {
              api.setBytes(keyArg, valueArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "cn.itbox.flutter_meteor.CacheApi.getBytes$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val keyArg = args[0] as String
            val wrapped: List<Any?> = try {
              listOf(api.getBytes(keyArg))
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
