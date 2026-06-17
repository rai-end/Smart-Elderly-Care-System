package com.example.healthmonitor.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "admin")
public class Admin {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 【关键修改】添加 length = 50，避免索引超限
    @Column(name = "admin_account", unique = true, nullable = false, length = 50)
    private String adminAccount;

    // 【关键修改】添加 length = 50
    @Column(name = "admin_password", nullable = false, length = 50)
    private String adminPassword;

    @Column(name = "admin_name", length = 50)
    private String adminName;

    @Column(name = "create_time")
    private LocalDateTime createTime;
}