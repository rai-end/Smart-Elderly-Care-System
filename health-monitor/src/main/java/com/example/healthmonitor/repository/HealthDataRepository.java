package com.example.healthmonitor.repository;

import com.example.healthmonitor.entity.HealthData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface HealthDataRepository extends JpaRepository<HealthData, Long> {
    // 原有方法：根据deviceId查询任意一条
    Optional<HealthData> findByDeviceId(String deviceId);

    // 新增方法：根据deviceId查最新的一条（按updateTime倒序取第一条）
    Optional<HealthData> findTopByDeviceIdOrderByUpdateTimeDesc(String deviceId);
}