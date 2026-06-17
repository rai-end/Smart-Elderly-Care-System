package com.example.healthmonitor.service;

import com.example.healthmonitor.entity.HealthData;
import com.example.healthmonitor.repository.HealthDataRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@Slf4j
@Service
public class MockHealthDataService {
    @Autowired
    private HealthDataRepository healthDataRepository;

    private final Random random = new Random();

    /**
     * 为单个设备生成数据（用户端）
     */
    @Transactional
    public void generateAndUpdateCurrentDeviceData(String deviceId) {
        log.info("【Mock数据生成】开始为设备 {} 生成最新健康数据...", deviceId);

        Optional<HealthData> existData = healthDataRepository.findTopByDeviceIdOrderByUpdateTimeDesc(deviceId);
        HealthData healthData = existData.orElse(new HealthData());

        healthData.setDeviceId(deviceId);

        // 心率
        int baseHeartRate = healthData.getHeartRate() != null ? healthData.getHeartRate() : 75;
        healthData.setHeartRate(Math.max(60, Math.min(100, baseHeartRate + (random.nextInt(11) - 5))));

        // 血压
        int baseSystolic = healthData.getSystolic() != null ? healthData.getSystolic() : 120;
        healthData.setSystolic(Math.max(90, Math.min(140, baseSystolic + (random.nextInt(7) - 3))));
        int baseDiastolic = healthData.getDiastolic() != null ? healthData.getDiastolic() : 80;
        healthData.setDiastolic(Math.max(60, Math.min(90, baseDiastolic + (random.nextInt(5) - 2))));

        // 血氧
        int baseSpO2 = healthData.getSpO2() != null ? healthData.getSpO2() : 98;
        healthData.setSpO2(Math.max(95, Math.min(100, baseSpO2 + (random.nextInt(3) - 1))));

        // 步数
        int baseSteps = healthData.getTotalSteps() != null ? healthData.getTotalSteps() : 2000;
        healthData.setTotalSteps(baseSteps + random.nextInt(41) + 10);

        // 体温
        BigDecimal baseTemp = healthData.getTemperature() != null ? healthData.getTemperature() : new BigDecimal("36.5");
        BigDecimal newTemp = baseTemp.add(new BigDecimal(random.nextDouble() * 0.2 - 0.1)).setScale(1, RoundingMode.HALF_UP);
        healthData.setTemperature(new BigDecimal(Math.max(36.0, Math.min(37.2, newTemp.doubleValue()))).setScale(1, RoundingMode.HALF_UP));

        // 睡眠
        healthData.setTotalSleep(BigDecimal.valueOf(7.0 + random.nextDouble() * 1.0).setScale(1, RoundingMode.HALF_UP));
        healthData.setDeepSleep(BigDecimal.valueOf(2.0 + random.nextDouble() * 1.0).setScale(1, RoundingMode.HALF_UP));
        healthData.setShallowSleep(healthData.getTotalSleep().subtract(healthData.getDeepSleep()));
        healthData.setSleepQuality(random.nextBoolean() ? "良好" : "一般");

        // 【核心修改】跌倒检测：改为阈值逻辑（0-100，>70为跌倒）
        int fallScore = random.nextInt(100);
        // 10%概率触发跌倒（>70）
        if (random.nextInt(10) < 1) {
            fallScore = 71 + random.nextInt(29); // 71-100
        } else {
            fallScore = random.nextInt(70); // 0-69
        }
        healthData.setFallScore(fallScore);
        healthData.setFallStatus(fallScore > 70 ? "跌倒" : "正常");
        healthData.setFallRiskLevel(fallScore > 70 ? "高" : (fallScore > 50 ? "中" : "低"));
        healthData.setFallCheckTime(LocalDateTime.now());

        // 体温状态
        healthData.setTemperatureStatus(healthData.getTemperature().doubleValue() > 37.0 ? "偏高" : "正常");
        healthData.setUpdateTime(LocalDateTime.now());

        healthDataRepository.save(healthData);
        log.info("【Mock数据生成】设备 {} 数据已保存！跌倒阈值={}, 状态={}",
                deviceId, healthData.getFallScore(), healthData.getFallStatus());
    }

    /**
     * 【新增】为所有设备生成数据（管理员端）
     */
    @Transactional
    public void generateMockDataForAllDevices() {
        // 这里模拟为 DEV001, DEV002, DEV003 生成数据
        String[] devices = {"DEV001", "DEV002", "DEV003"};
        for (String deviceId : devices) {
            generateAndUpdateCurrentDeviceData(deviceId);
        }
    }
}