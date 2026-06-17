package com.example.healthmonitor.service;

import com.example.healthmonitor.entity.Admin;
import com.example.healthmonitor.repository.AdminRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class AdminService {
    private static final Logger log = LoggerFactory.getLogger(AdminService.class);

    @Autowired
    private AdminRepository adminRepository;

    // 【测试专用】暂时完全关闭BCrypt，只验证明文密码
    public Admin login(String account, String password) {
        try {
            // 1. 根据 admin_account 查询管理员
            Optional<Admin> adminOptional = adminRepository.findByAdminAccount(account);
            if (adminOptional.isEmpty()) {
                log.warn("管理员账号不存在：{}", account);
                return null;
            }

            Admin admin = adminOptional.get();

            // 2. 只验证明文密码（测试用，正式环境再改回加密）
            if (password.equals(admin.getAdminPassword())) {
                log.info("管理员登录成功：{}", account);
                return admin;
            } else {
                log.warn("管理员密码错误：{}，输入的密码：{}，数据库密码：{}",
                        account, password, admin.getAdminPassword());
                return null;
            }
        } catch (Exception e) {
            log.error("管理员登录查询异常", e);
            return null;
        }
    }
}