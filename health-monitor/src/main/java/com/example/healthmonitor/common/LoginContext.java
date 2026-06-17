package com.example.healthmonitor.common;

/**
 * 登录上下文：用静态变量存储当前登录的设备ID（替代 ThreadLocal，解决线程隔离问题）
 */
public class LoginContext {
    // 【关键修改】用静态变量替代 ThreadLocal，所有线程共享
    private static String currentDeviceId = null;

    // 设置当前登录的设备ID
    public static void setCurrentDeviceId(String deviceId) {
        currentDeviceId = deviceId;
    }

    // 获取当前登录的设备ID
    public static String getCurrentDeviceId() {
        return currentDeviceId;
    }

    // 清空（用户退出登录时调用）
    public static void clear() {
        currentDeviceId = null;
    }
}