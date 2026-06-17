package com.example.healthmonitor.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "health_data")
public class HealthData {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "device_id", nullable = false, length = 50)
    private String deviceId;

    @Column(name = "heart_rate")
    private Integer heartRate;

    @Column(name = "systolic")
    private Integer systolic;

    @Column(name = "diastolic")
    private Integer diastolic;

    @Column(name = "sp_o2")
    private Integer spO2;

    @Column(name = "total_steps")
    private Integer totalSteps;

    @Column(name = "period_data", length = 200)
    private String periodData;

    @Column(name = "total_sleep", precision = 2, scale = 1)
    private BigDecimal totalSleep;

    @Column(name = "deep_sleep", precision = 2, scale = 1)
    private BigDecimal deepSleep;

    @Column(name = "shallow_sleep", precision = 2, scale = 1)
    private BigDecimal shallowSleep;

    @Column(name = "sleep_quality", length = 20)
    private String sleepQuality;

    @Column(name = "fall_status", length = 20)
    private String fallStatus;

    @Column(name = "fall_risk_level", length = 10)
    private String fallRiskLevel;

    @Column(name = "fall_check_time")
    private LocalDateTime fallCheckTime;

    // 【新增】跌倒阈值字段：0-100
    @Column(name = "fall_score")
    private Integer fallScore;

    @Column(name = "temperature", precision = 3, scale = 1)
    private BigDecimal temperature;

    @Column(name = "temperature_status", length = 20)
    private String temperatureStatus;

    @Column(name = "update_time")
    private LocalDateTime updateTime;

    @PrePersist
    @PreUpdate
    public void preUpdate() {
        updateTime = LocalDateTime.now();
    }
}