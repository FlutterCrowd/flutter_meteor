package cn.itbox.hz_cache_plugin

import MeteorCacheApi
import kotlin.collections.HashMap

object MeteorMemoryChache: MeteorCacheApi {
    private val storage = HashMap<String, Any?>()

    @Synchronized
    override fun setString(key: String, value: String?) {
        storage[key] = value
    }

    @Synchronized
    override fun getString(key: String): String? {
        return storage[key] as? String
    }

    @Synchronized
    override fun setBool(key: String, value: Boolean?) {
        storage[key] = value
    }

    @Synchronized
    override fun getBool(key: String): Boolean? {
        return storage[key] as? Boolean
    }

    @Synchronized
    override fun setInt(key: String, value: Long?) {
        storage[key] = value
    }

    @Synchronized
    override fun getInt(key: String): Long? {
        return storage[key] as? Long
    }

    @Synchronized
    override fun setDouble(key: String, value: Double?) {
        storage[key] = value
    }

    @Synchronized
    override fun getDouble(key: String): Double? {
        return storage[key] as? Double
    }

    @Synchronized
    override fun setList(key: String, value: List<Any?>?) {
        storage[key] = value
    }

    @Synchronized
    override fun getList(key: String): List<Any?>? {
        return storage[key] as? List<Any?>
    }

    @Synchronized
    override fun setMap(key: String, value: Map<String, Any?>?) {
        storage[key] = value
    }

    @Synchronized
    override fun getMap(key: String): Map<String, Any?>? {
        return storage[key] as? Map<String, Any?>
    }

    @Synchronized
    override fun setBytes(key: String, value: List<Long>?) {
        storage[key] = value
    }

    @Synchronized
    override fun getBytes(key: String): List<Long>? {
        return storage[key] as? List<Long>
    }
}