package com.example.healthmonitor.service;

import com.example.healthmonitor.common.Result;
import com.example.healthmonitor.entity.HealthData;
import com.example.healthmonitor.entity.UserDevice;
import com.example.healthmonitor.repository.HealthDataRepository;
import com.example.healthmonitor.repository.UserDeviceRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Slf4j
@Service
public class HealthDataService {

    @Autowired
    private UserDeviceRepository userDeviceRepository;

    @Autowired
    private HealthDataRepository healthDataRepository;

    // 随机数生成器（全局复用，避免频繁创建）
    private final Random random = new Random();

    // ==================== 1. 总健康数据接口 ====================
    public Result<?> getHealthData(String deviceId) {
        try {
            Map<String, Object> totalHealthData = new HashMap<>();
            totalHealthData.put("heartRate", getHeartRateData(deviceId).getData());
            totalHealthData.put("bloodPressure", getBloodPressureData(deviceId).getData());
            totalHealthData.put("bloodOxygen", getBloodOxygenData(deviceId).getData());
            totalHealthData.put("activity", getActivityData(deviceId).getData());
            totalHealthData.put("sleep", getSleepQualityData(deviceId).getData());
            totalHealthData.put("fallDetection", getFallDetectionData(deviceId).getData());
            totalHealthData.put("temperature", getTemperatureData(deviceId).getData());
            // 取数据库最新更新时间，而非当前时间
            Optional<HealthData> latestData = healthDataRepository.findTopByDeviceIdOrderByUpdateTimeDesc(deviceId);
            String updateTime = latestData.map(data ->
                            data.getUpdateTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")))
                    .orElse(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            totalHealthData.put("updateTime", updateTime);

            return Result.success(totalHealthData);
        } catch (Exception e) {
            log.error("获取总健康数据失败（deviceId：{}）：", deviceId, e);
            return Result.error("获取总健康数据失败");
        }
    }

    // ==================== 2. 心率数据接口（优先查最新数据）====================
    public Result<Map<String, Object>> getHeartRateData(String deviceId) {
        Map<String, Object> heartRateData = new HashMap<>();

        try {
            // 核心修改：查询最新的一条数据（按更新时间倒序）
            Optional<HealthData> healthDataOpt = healthDataRepository.findTopByDeviceIdOrderByUpdateTimeDesc(deviceId);
            if (healthDataOpt.isPresent() && healthDataOpt.get().getHeartRate() != null) {
                HealthData dbData = healthDataOpt.get();
                log.info("【数据库】{} 心率：{}", deviceId, dbData.getHeartRate());

                heartRateData.put("current", dbData.getHeartRate());
                heartRateData.put("normalRange", "60-100");
                // 动态生成趋势（基于最新值小幅波动）
                List<Integer> trend = new ArrayList<>();
                int base = dbData.getHeartRate();
                for (int i = 0; i < 6; i++) {
                    trend.add(Math.max(60, Math.min(100, base + (random.nextInt(11) - 5))));
                }
                heartRateData.put("trend", trend);
                heartRateData.put("unit", "次/分钟");
                heartRateData.put("status", (dbData.getHeartRate() >= 60 && dbData.getHeartRate() <= 100) ? "正常" : "异常");
            } else {
                log.info("【Mock】{} 无心率数据", deviceId);
                heartRateData.put("current", 75);
                heartRateData.put("normalRange", "60-100");
                heartRateData.put("trend", Arrays.asList(70, 72, 75, 73, 76, 74));
                heartRateData.put("unit", "次/分钟");
                heartRateData.put("status", "正常");
            }
        } catch (Exception e) {
            log.error("获取心率失败：", e);
            heartRateData.put("current", 75);
            heartRateData.put("normalRange", "60-100");
            heartRateData.put("trend", Arrays.asList(70, 72, 75, 73, 76));
            heartRateData.put("unit", "次/分钟");
            heartRateData.put("status", "正常");
        }

        return Result.success(heartRateData);
    }

    // ==================== 3. 血压数据接口（优先查最新数据）====================
    public Result<Map<String, Object>> getBloodPressureData(String deviceId) {
        Map<String, Object> bpData = new HashMap<>();

        try {
            Optional<HealthData> healthDataOpt = healthDataRepository.findTopByDeviceIdOrderByUpdateTimeDesc(deviceId);
            if (healthDataOpt.isPresent() && healthDataOpt.get().getSystolic() != null) {
                HealthData dbData = healthDataOpt.get();
                log.info("【数据库】{} 血压：{}/{}", deviceId, dbData.getSystolic(), dbData.getDiastolic());

                bpData.put("systolic", dbData.getSystolic());
                bpData.put("diastolic", dbData.getDiastolic() != null ? dbData.getDiastolic() : 80);
                bpData.put("normalRange", "90-140/60-90");
                // 动态生成血压趋势
                List<List<Integer>> trend = new ArrayList<>();
                int sysBase = dbData.getSystolic();
                int diaBase = dbData.getDiastolic() != null ? dbData.getDiastolic() : 80;
                for (int i = 0; i < 5; i++) {
                    int sys = Math.max(90, Math.min(140, sysBase + (random.nextInt(7) - 3)));
                    int dia = Math.max(60, Math.min(90, diaBase + (random.nextInt(5) - 2)));
                    trend.add(Arrays.asList(sys, dia));
                }
                bpData.put("trend", trend);
                bpData.put("unit", "mmHg");
                bpData.put("status", (sysBase >=90 && sysBase <=140 && diaBase >=60 && diaBase <=90) ? "正常" : "异常");
            } else {
                log.info("【Mock】{} 无血压数据", deviceId);
                bpData.put("systolic", 120);
                bpData.put("diastolic", 80);
                bpData.put("normalRange", "90-140/60-90");
                bpData.put("trend", Arrays.asList(Arrays.asList(120, 80), Arrays.asList(125, 82), Arrays.asList(118, 79)));
                bpData.put("unit", "mmHg");
                bpData.put("status", "正常");
            }
        } catch (Exception e) {
            log.error("获取血压失败：", e);
            bpData.put("systolic", 120);
            bpData.put("diastolic", 80);
            bpData.put("normalRange", "90-140/60-90");
            bpData.put("trend", Arrays.asList(Arrays.asList(120, 80)));
            bpData.put("unit", "mmHg");
            bpData.put("status", "正常");
        }

        return Result.success(bpData);
    }

    // ==================== 4. 血氧数据接口（优先查最新数据）====================
    public Result<Map<String, Object>> getBloodOxygenData(String deviceId) {
        Map<String, Object> boData = new HashMap<>();

        try {
            Optional<HealthData> healthDataOpt = healthDataRepository.findTopByDeviceIdOrderByUpdateTimeDesc(deviceId);
            if (healthDataOpt.isPresent() && healthDataOpt.get().getSpO2() != null) {
                HealthData dbData = healthDataOpt.get();
                log.info("【数据库】{} 血氧：{}", deviceId, dbData.getSpO2());

                boData.put("current", dbData.getSpO2());
                boData.put("normalRange", "95-100");
                // 动态血氧趋势
                List<Integer> trend = new ArrayList<>();
                int base = dbData.getSpO2();
                for (int i = 0; i < 5; i++) {
                    trend.add(Math.max(95, Math.min(100, base + (random.nextInt(3) - 1))));
                }
                boData.put("trend", trend);
                boData.put("unit", "%");
                boData.put("status", (dbData.getSpO2() >= 95) ? "正常" : "异常");
            } else {
                log.info("【Mock】{} 无血氧数据", deviceId);
                boData.put("current", 98);
                boData.put("normalRange", "95-100");
                boData.put("trend", Arrays.asList(98, 97, 98, 99, 98));
                boData.put("unit", "%");
                boData.put("status", "正常");
            }
        } catch (Exception e) {
            log.error("获取血氧失败：", e);
            boData.put("current", 98);
            boData.put("normalRange", "95-100");
            boData.put("trend", Arrays.asList(98, 97, 98));
            boData.put("unit", "%");
            boData.put("status", "正常");
        }

        return Result.success(boData);
    }

    // ==================== 5. 活动量数据接口（优先查最新数据）====================
    public Result<Map<String, Object>> getActivityData(String deviceId) {
        Map<String, Object> activityData = new HashMap<>();

        try {
            Optional<HealthData> healthDataOpt = healthDataRepository.findTopByDeviceIdOrderByUpdateTimeDesc(deviceId);
            if (healthDataOpt.isPresent() && healthDataOpt.get().getTotalSteps() != null) {
                HealthData dbData = healthDataOpt.get();
                log.info("【数据库】{} 活动量：{}", deviceId, dbData.getTotalSteps());

                activityData.put("totalSteps", dbData.getTotalSteps());
                // 动态生成时段步数（基于总步数比例）
                int total = dbData.getTotalSteps();
                List<Integer> periodData = Arrays.asList(
                        Math.min(total/4, 1000),
                        Math.min(total/3, 800),
                        Math.min(total/2, 1200),
                        Math.min(total%500, 500)
                );
                activityData.put("periodData", periodData);
                activityData.put("calorie", (int)(dbData.getTotalSteps() * 0.04));
                activityData.put("distance", Math.round(dbData.getTotalSteps() * 0.0007 * 10.0) / 10.0);
                activityData.put("goal", 5000);
                activityData.put("completion", Math.round((dbData.getTotalSteps() / 5000.0) * 100.0) / 10.0);
            } else {
                log.info("【Mock】{} 无活动量数据", deviceId);
                activityData.put("totalSteps", 2856);
                activityData.put("periodData", Arrays.asList(850, 620, 1100, 286));
                activityData.put("calorie", 120);
                activityData.put("distance", 1.8);
                activityData.put("goal", 5000);
                activityData.put("completion", 57.1);
            }
        } catch (Exception e) {
            log.error("获取活动量失败：", e);
            activityData.put("totalSteps", 2856);
            activityData.put("periodData", Arrays.asList(850, 620, 1100, 286));
            activityData.put("calorie", 120);
            activityData.put("distance", 1.8);
            activityData.put("goal", 5000);
            activityData.put("completion", 57.1);
        }

        return Result.success(activityData);
    }

    // ==================== 6. 睡眠数据接口（优先查最新数据）====================
    public Result<Map<String, Object>> getSleepQualityData(String deviceId) {
        Map<String, Object> sleepData = new HashMap<>();

        try {
            Optional<HealthData> healthDataOpt = healthDataRepository.findTopByDeviceIdOrderByUpdateTimeDesc(deviceId);
            if (healthDataOpt.isPresent() && healthDataOpt.get().getTotalSleep() != null) {
                HealthData dbData = healthDataOpt.get();
                log.info("【数据库】{} 睡眠：{}", deviceId, dbData.getTotalSleep());

                sleepData.put("totalTime", dbData.getTotalSleep());
                sleepData.put("deepSleep", dbData.getDeepSleep() != null ? dbData.getDeepSleep() : new BigDecimal("2.5"));
                sleepData.put("lightSleep", dbData.getShallowSleep() != null ? dbData.getShallowSleep() : new BigDecimal("5.0"));
                sleepData.put("wakeTimes", random.nextInt(3) + 1);
                sleepData.put("sleepScore", Math.min(100, (int)(dbData.getTotalSleep().doubleValue() * 12)));
                sleepData.put("status", dbData.getSleepQuality() != null ? dbData.getSleepQuality() : "良好");
                sleepData.put("sleepTime", "22:" + (random.nextInt(30) + 30));
                sleepData.put("wakeTime", "06:" + random.nextInt(10));
            } else {
                log.info("【Mock】{} 无睡眠数据", deviceId);
                sleepData.put("totalTime", 7.5);
                sleepData.put("deepSleep", 2.5);
                sleepData.put("lightSleep", 4.0);
                sleepData.put("wakeTimes", 1);
                sleepData.put("sleepScore", 85);
                sleepData.put("status", "良好");
                sleepData.put("sleepTime", "22:30");
                sleepData.put("wakeTime", "06:00");
            }
        } catch (Exception e) {
            log.error("获取睡眠失败：", e);
            sleepData.put("totalTime", 7.5);
            sleepData.put("deepSleep", 2.5);
            sleepData.put("lightSleep", 4.0);
            sleepData.put("wakeTimes", 1);
            sleepData.put("sleepScore", 85);
            sleepData.put("status", "良好");
            sleepData.put("sleepTime", "22:30");
            sleepData.put("wakeTime", "06:00");
        }

        return Result.success(sleepData);
    }

    // ==================== 7. 跌倒检测接口（优先查数据库）====================
    public Result<Map<String, Object>> getFallDetectionData(String deviceId) {
        Map<String, Object> fallData = new HashMap<>();

        try {
            Optional<HealthData> healthDataOpt = healthDataRepository.findTopByDeviceIdOrderByUpdateTimeDesc(deviceId);
            if (healthDataOpt.isPresent()) {
                HealthData dbData = healthDataOpt.get();
                fallData.put("status", dbData.getFallStatus() != null ? dbData.getFallStatus() : "未检测到跌倒");
                fallData.put("lastCheckTime", dbData.getFallCheckTime() != null ?
                        dbData.getFallCheckTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) :
                        LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
                fallData.put("riskLevel", dbData.getFallRiskLevel() != null ? dbData.getFallRiskLevel() : "中");
            } else {
                fallData.put("status", "未检测到跌倒");
                fallData.put("lastCheckTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
                fallData.put("riskLevel", "中");
            }
            fallData.put("alertStatus", "关闭");
        } catch (Exception e) {
            log.error("获取跌倒检测数据失败：", e);
            fallData.put("status", "未检测到跌倒");
            fallData.put("lastCheckTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            fallData.put("riskLevel", "中");
            fallData.put("alertStatus", "关闭");
        }

        return Result.success(fallData);
    }

    // ==================== 8. 体温数据接口（优先查最新数据）====================
    public Result<Map<String, Object>> getTemperatureData(String deviceId) {
        Map<String, Object> tempData = new HashMap<>();

        try {
            Optional<HealthData> healthDataOpt = healthDataRepository.findTopByDeviceIdOrderByUpdateTimeDesc(deviceId);
            if (healthDataOpt.isPresent() && healthDataOpt.get().getTemperature() != null) {
                HealthData dbData = healthDataOpt.get();
                log.info("【数据库】{} 体温：{}", deviceId, dbData.getTemperature());

                tempData.put("current", dbData.getTemperature());
                tempData.put("normalRange", "36.0-37.2");
                // 动态体温趋势
                List<BigDecimal> trend = new ArrayList<>();
                BigDecimal base = dbData.getTemperature();
                for (int i = 0; i < 4; i++) {
                    BigDecimal fluctuate = BigDecimal.valueOf(random.nextDouble() * 0.2 - 0.1)
                            .setScale(1, RoundingMode.HALF_UP);
                    BigDecimal temp = base.add(fluctuate);
                    temp = BigDecimal.valueOf(Math.max(36.0, Math.min(37.2, temp.doubleValue())))
                            .setScale(1, RoundingMode.HALF_UP);
                    trend.add(temp);
                }
                tempData.put("trend", trend);
                tempData.put("unit", "℃");
                tempData.put("status", dbData.getTemperatureStatus() != null ? dbData.getTemperatureStatus() :
                        (dbData.getTemperature().doubleValue() > 37.0 ? "偏高" : "正常"));
            } else {
                log.info("【Mock】{} 无体温数据", deviceId);
                tempData.put("current", 36.5);
                tempData.put("normalRange", "36.0-37.2");
                tempData.put("trend", Arrays.asList(new BigDecimal("36.5"), new BigDecimal("36.6"), new BigDecimal("36.4")));
                tempData.put("unit", "℃");
                tempData.put("status", "正常");
            }
        } catch (Exception e) {
            log.error("获取体温失败：", e);
            tempData.put("current", 36.5);
            tempData.put("normalRange", "36.0-37.2");
            tempData.put("trend", Arrays.asList(new BigDecimal("36.5"), new BigDecimal("36.6")));
            tempData.put("unit", "℃");
            tempData.put("status", "正常");
        }

        return Result.success(tempData);
    }

    // ==================== 9. Logo用户信息接口（保持不变）====================
    public Result<Map<String, Object>> getLogoUserData(String deviceId) {
        try {
            log.info("开始查询设备ID：{} 的用户信息", deviceId);
            Optional<UserDevice> userOptional = userDeviceRepository.findByDeviceId(deviceId);
            if (userOptional.isEmpty()) {
                log.warn("设备ID {} 不存在", deviceId);
                return Result.error(404, "设备ID不存在：" + deviceId);
            }

            UserDevice user = userOptional.get();
            log.info("查询到用户信息：{} - {}", user.getDeviceId(), user.getUserName());

            Map<String, Object> logoData = new HashMap<>();
            logoData.put("deviceId", deviceId);
            logoData.put("userName", user.getUserName());
            logoData.put("age", user.getAge());
            logoData.put("gender", user.getGender());
            logoData.put("avatar", "/static/avatar/default.png");
            logoData.put("bindTime", user.getCreateTime() != null ?
                    user.getCreateTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) : "未知");

            log.info("返回用户信息：{}", logoData);
            return Result.success(logoData);
        } catch (Exception e) {
            log.error("获取Logo用户信息失败（deviceId：{}）：", deviceId, e);
            Map<String, Object> fallbackData = new HashMap<>();
            fallbackData.put("deviceId", deviceId);
            fallbackData.put("userName", "未知用户");
            fallbackData.put("age", 0);
            fallbackData.put("gender", "未知");
            fallbackData.put("avatar", "/static/avatar/default.png");
            fallbackData.put("bindTime", "未知");
            return Result.success(fallbackData);
        }
    }
}