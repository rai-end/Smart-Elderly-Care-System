package com.example.healthmonitor.repository;

import com.example.healthmonitor.entity.Admin;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface AdminRepository extends JpaRepository<Admin, Integer> {
    // 根据管理员账号查询
    Optional<Admin> findByAdminAccount(String adminAccount);
}