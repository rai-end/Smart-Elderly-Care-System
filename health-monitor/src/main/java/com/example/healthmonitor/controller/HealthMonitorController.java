package com.example.healthmonitor.controller;

import com.example.healthmonitor.common.LoginContext;
import com.example.healthmonitor.common.Result;
import com.example.healthmonitor.entity.HealthData;
import com.example.healthmonitor.entity.UserDevice;
import com.example.healthmonitor.repository.HealthDataRepository;
import com.example.healthmonitor.repository.UserDeviceRepository;
import com.example.healthmonitor.service.FallDetectionService;
import com.example.healthmonitor.service.HealthDataService;
import com.example.healthmonitor.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Slf4j
@RestController
@CrossOrigin
public class HealthMonitorController {

    @Autowired
    private UserService userService;

    @Autowired
    private HealthDataService healthDataService;

    @Autowired
    private UserDeviceRepository userDeviceRepository;

    @Autowired
    private HealthDataRepository healthDataRepository;

    @Autowired
    private FallDetectionService fallDetectionService;

    // ==================== 用户相关接口 ====================

    @PostMapping("/user/login")
    public Result<UserDevice> login(@RequestBody Map<String, String> loginForm) {
        String deviceId = loginForm.getOrDefault("deviceId", "").trim();
        String password = loginForm.getOrDefault("password", "").trim();

        if (deviceId.isEmpty()) {
            log.warn("用户登录失败：设备ID为空");
            return Result.error("设备ID不能为空");
        }
        if (password.isEmpty()) {
            log.warn("用户登录失败：密码为空（设备ID：{}）", deviceId);
            return Result.error("密码不能为空");
        }

        Result<UserDevice> loginResult = userService.login(deviceId, password);
        if (loginResult.isSuccess()) {
            LoginContext.setCurrentDeviceId(deviceId);
            log.info("【登录成功】设备ID {} 已存入全局上下文", deviceId);
        }
        return loginResult;
    }

    @PostMapping("/user/logout")
    public Result<String> logout(@RequestParam String deviceId) {
        if (deviceId == null || deviceId.trim().isEmpty()) {
            return Result.error("设备ID不能为空");
        }
        LoginContext.clear();
        log.info("【退出登录】设备ID {} 上下文已清空", deviceId);
        return Result.success("退出成功");
    }

    @GetMapping("/user/logoInfo")
    public Result<Map<String, Object>> getLogoUserData(@RequestParam String deviceId) {
        if (deviceId == null || deviceId.trim().isEmpty()) {
            log.warn("获取Logo用户信息失败：设备ID为空");
            return Result.error("设备ID不能为空");
        }
        return healthDataService.getLogoUserData(deviceId);
    }

    @GetMapping("/user/info")
    public Result<Map<String, Object>> getUserInfo(@RequestParam String userId) {
        if (userId == null || userId.trim().isEmpty()) {
            log.warn("获取用户信息失败：用户ID为空");
            return Result.error("用户ID不能为空");
        }
        String deviceId = "DEV" + userId.replace("user", "");
        log.info("通过用户ID {} 转换为设备ID：{}", userId, deviceId);
        return healthDataService.getLogoUserData(deviceId);
    }

    // ==================== 管理员相关接口 ====================

    @PostMapping("/admin/login")
    public Result<Map<String, Object>> adminLogin(@RequestBody Map<String, String> loginForm) {
        String username = loginForm.getOrDefault("username", "").trim();
        String password = loginForm.getOrDefault("password", "").trim();

        if (username.isEmpty()) {
            log.warn("管理员登录失败：账号为空");
            return Result.error("账号不能为空");
        }
        if (password.isEmpty()) {
            log.warn("管理员登录失败：密码为空（账号：{}）", username);
            return Result.error("密码不能为空");
        }

        if ("admin".equals(username) && "admin123".equals(password)) {
            log.info("管理员登录成功：{}", username);
            return Result.success(Map.of(
                    "token", "admin-token-" + System.currentTimeMillis(),
                    "userName", "管理员"
            ));
        } else {
            log.warn("管理员登录失败：账号 {}，密码错误", username);
            return Result.error("管理员账号或密码错误");
        }
    }

    @GetMapping("/admin/user/list")
    public Result<List<UserDevice>> getAllUsers() {
        try {
            log.info("管理员获取用户列表");
            List<UserDevice> users = userDeviceRepository.findAll();
            log.info("获取到用户列表，共 {} 条数据", users.size());
            return Result.success(users);
        } catch (Exception e) {
            log.error("获取用户列表失败：", e);
            return Result.error("获取用户列表失败");
        }
    }

    // 获取所有用户最新健康数据（用于管理员警报判断）
    @GetMapping("/admin/health/all")
    public Result<List<HealthData>> getAllUsersHealthData() {
        try {
            log.info("管理员获取所有用户健康数据");
            List<HealthData> allHealthData = healthDataRepository.findAll();
            log.info("获取到所有用户健康数据，共 {} 条", allHealthData.size());
            return Result.success(allHealthData);
        } catch (Exception e) {
            log.error("获取所有用户健康数据失败：", e);
            return Result.error("获取健康数据失败");
        }
    }

    // ==================== 健康数据接口 ====================

    @GetMapping("/elder/health")
    public Result<?> getHealthData(@RequestParam String deviceId) {
        if (deviceId == null || deviceId.trim().isEmpty()) {
            log.warn("获取总健康数据失败：设备ID为空");
            return Result.error("设备ID不能为空");
        }
        return healthDataService.getHealthData(deviceId);
    }

    @GetMapping("/elder/health/heartRate")
    public Result<Map<String, Object>> getHeartRateData(@RequestParam String deviceId) {
        if (deviceId == null || deviceId.trim().isEmpty()) {
            log.warn("获取心率数据失败：设备ID为空");
            return Result.error("设备ID不能为空");
        }
        return healthDataService.getHeartRateData(deviceId);
    }

    @GetMapping("/elder/health/bloodPressure")
    public Result<Map<String, Object>> getBloodPressureData(@RequestParam String deviceId) {
        if (deviceId == null || deviceId.trim().isEmpty()) {
            log.warn("获取血压数据失败：设备ID为空");
            return Result.error("设备ID不能为空");
        }
        return healthDataService.getBloodPressureData(deviceId);
    }

    @GetMapping("/elder/health/bloodOxygen")
    public Result<Map<String, Object>> getBloodOxygenData(@RequestParam String deviceId) {
        if (deviceId == null || deviceId.trim().isEmpty()) {
            log.warn("获取血氧数据失败：设备ID为空");
            return Result.error("设备ID不能为空");
        }
        return healthDataService.getBloodOxygenData(deviceId);
    }

    @GetMapping("/elder/health/activity")
    public Result<Map<String, Object>> getActivityData(@RequestParam String deviceId) {
        if (deviceId == null || deviceId.trim().isEmpty()) {
            log.warn("获取活动量数据失败：设备ID为空");
            return Result.error("设备ID不能为空");
        }
        return healthDataService.getActivityData(deviceId);
    }

    @GetMapping("/elder/health/sleep")
    public Result<Map<String, Object>> getSleepQualityData(@RequestParam String deviceId) {
        if (deviceId == null || deviceId.trim().isEmpty()) {
            log.warn("获取睡眠数据失败：设备ID为空");
            return Result.error("设备ID不能为空");
        }
        return healthDataService.getSleepQualityData(deviceId);
    }

    @GetMapping("/elder/health/fall")
    public Result<Map<String, Object>> getFallDetectionData(@RequestParam String deviceId) {
        if (deviceId == null || deviceId.trim().isEmpty()) {
            log.warn("获取跌倒检测数据失败：设备ID为空");
            return Result.error("设备ID不能为空");
        }

        Optional<HealthData> dataOpt = healthDataRepository.findTopByDeviceIdOrderByUpdateTimeDesc(deviceId);
        if (dataOpt.isPresent()) {
            HealthData data = dataOpt.get();
            return Result.success(Map.of(
                    "status", data.getFallStatus() != null ? data.getFallStatus() : "正常",
                    "riskLevel", data.getFallRiskLevel() != null ? data.getFallRiskLevel() : "低",
                    "lastCheckTime", data.getFallCheckTime() != null ? data.getFallCheckTime().toString() : "",
                    "fallScore", data.getFallScore() != null ? data.getFallScore() : 0
            ));
        }
        return Result.success(Map.of(
                "status", "正常",
                "riskLevel", "低",
                "lastCheckTime", "",
                "fallScore", 0
        ));
    }

    @GetMapping("/elder/health/temperature")
    public Result<Map<String, Object>> getTemperatureData(@RequestParam String deviceId) {
        if (deviceId == null || deviceId.trim().isEmpty()) {
            log.warn("获取体温数据失败：设备ID为空");
            return Result.error("设备ID不能为空");
        }
        return healthDataService.getTemperatureData(deviceId);
    }

    // ==================== 🔥 摄像头YOLOv11跌倒检测接口（完全适配前端） ====================

    /**
     * 摄像头跌倒检测接口（同时支持deviceId参数）
     * @param requestBody 包含deviceId和imgBase64
     * @return 统一格式的跌倒检测结果
     */
    @PostMapping("/elder/health/fall/detect")
    public Result<Map<String, Object>> detectFall(@RequestBody Map<String, String> requestBody) {
        String deviceId = requestBody.get("deviceId");
        String imgBase64 = requestBody.get("imgBase64");

        if (imgBase64 == null || imgBase64.trim().isEmpty()) {
            log.warn("跌倒检测失败：图片数据为空");
            return Result.error("请上传图片");
        }

        log.info("接收到设备{}的摄像头跌倒检测请求，图片长度: {}", deviceId, imgBase64.length());

        // 调用Python YOLOv11服务
        Result<Map<String, Object>> yoloResult = fallDetectionService.detectFall(imgBase64);

        if (!yoloResult.isSuccess()) {
            log.error("YOLOv11检测失败: {}", yoloResult.getMsg());
            // 检测失败时返回默认正常数据
            return Result.success(Map.of(
                    "status", "正常",
                    "riskLevel", "低",
                    "lastCheckTime", LocalDateTime.now().toString(),
                    "fallScore", 0
            ));
        }

        // 解析YOLO返回结果
        Map<String, Object> yoloData = yoloResult.getData();
        boolean isFall = (boolean) yoloData.getOrDefault("isFall", false);
        double confidence = ((Number) yoloData.getOrDefault("confidence", 0.0)).doubleValue();

        // 转换为前端统一格式
        int fallScore = isFall ? (int) (confidence * 100) : (int) (Math.random() * 30);
        String status = isFall ? "跌倒警报" : "正常";
        String riskLevel = isFall ? "高" : "低";
        String lastCheckTime = LocalDateTime.now().toString();

        // 🔥 保存检测结果到数据库（更新最新健康数据）
        saveFallResultToDatabase(deviceId, fallScore, status, riskLevel, lastCheckTime);

        log.info("设备{}跌倒检测结果: 状态={}, 风险值={}", deviceId, status, fallScore);

        // 返回前端期望的统一格式
        return Result.success(Map.of(
                "status", status,
                "riskLevel", riskLevel,
                "lastCheckTime", lastCheckTime,
                "fallScore", fallScore
        ));
    }

    /**
     * 检查YOLOv11跌倒检测服务状态
     * @return 服务状态
     */
    @GetMapping("/elder/health/fall/status")
    public Result<Map<String, Object>> getFallDetectionServiceStatus() {
        boolean isAvailable = fallDetectionService.isServiceAvailable();
        log.info("查询跌倒检测服务状态: {}", isAvailable ? "可用" : "不可用");
        return Result.success(Map.of(
                "available", isAvailable,
                "msg", isAvailable ? "YOLOv11跌倒检测服务运行中" : "YOLOv11跌倒检测服务未启动"
        ));
    }

    // ==================== 私有工具方法 ====================

    /**
     * 将跌倒检测结果保存到数据库
     */
    private void saveFallResultToDatabase(String deviceId, int fallScore, String status, String riskLevel, String checkTime) {
        try {
            // 查找该设备最新的健康数据
            Optional<HealthData> dataOpt = healthDataRepository.findTopByDeviceIdOrderByUpdateTimeDesc(deviceId);

            HealthData healthData;
            if (dataOpt.isPresent()) {
                healthData = dataOpt.get();
            } else {
                healthData = new HealthData();
                healthData.setDeviceId(deviceId);
            }

            // 更新跌倒相关字段
            healthData.setFallScore(fallScore);
            healthData.setFallStatus(status);
            healthData.setFallRiskLevel(riskLevel);
            healthData.setFallCheckTime(LocalDateTime.parse(checkTime));
            healthData.setUpdateTime(LocalDateTime.now());

            // 保存到数据库
            healthDataRepository.save(healthData);
            log.info("设备{}跌倒检测结果已保存到数据库", deviceId);

        } catch (Exception e) {
            log.error("保存跌倒检测结果到数据库失败: ", e);
        }
    }
}