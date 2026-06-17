package com.example.healthmonitor.config;

import com.example.healthmonitor.common.LoginContext;
import com.example.healthmonitor.service.MockHealthDataService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

import jakarta.annotation.PostConstruct;

@Slf4j
@Configuration
@EnableScheduling
public class MockDataScheduleConfig {
    @Autowired
    private MockHealthDataService mockHealthDataService;

    @PostConstruct
    public void init() {
        log.info("【定时任务配置】MockDataScheduleConfig 已加载");
    }

    // 你原有的单个用户数据生成
    @Scheduled(fixedRate = 5000)
    public void generateMockHealthDataForCurrentUser() {
        String currentDeviceId = LoginContext.getCurrentDeviceId();
        if (currentDeviceId == null || currentDeviceId.trim().isEmpty()) {
            return;
        }
        log.info("【定时任务】为当前登录设备 {} 生成数据", currentDeviceId);
        mockHealthDataService.generateAndUpdateCurrentDeviceData(currentDeviceId);
    }

    // 【新增】为管理员后台生成所有用户数据（每5秒）
    @Scheduled(fixedRate = 5000)
    public void generateMockDataForAdmin() {
        log.info("【定时任务】为管理员后台生成所有用户模拟数据");
        mockHealthDataService.generateMockDataForAllDevices();
    }
}