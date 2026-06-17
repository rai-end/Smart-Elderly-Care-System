package com.example.healthmonitor.repository;

import com.example.healthmonitor.entity.UserDevice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserDeviceRepository extends JpaRepository<UserDevice, Long> {
    // 根据设备ID查询用户
    Optional<UserDevice> findByDeviceId(String deviceId);
}