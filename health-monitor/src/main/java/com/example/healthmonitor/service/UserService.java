package com.example.healthmonitor.service;

import com.example.healthmonitor.common.Result;
import com.example.healthmonitor.entity.UserDevice;
import com.example.healthmonitor.repository.UserDeviceRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * 用户业务层（直接使用，无需Impl实现类）
 */
@Slf4j // 日志注解，方便排查问题
@Service
public class UserService {
    @Autowired
    private UserDeviceRepository userDeviceRepository;

    // 登录接口：补充参数非空校验 + 异常捕获
    public Result<UserDevice> login(String deviceId, String password) {
        // 1. 非空校验（避免空指针）
        if (deviceId == null || deviceId.trim().isEmpty()) {
            return Result.error("设备ID不能为空");
        }
        if (password == null || password.trim().isEmpty()) {
            return Result.error("密码不能为空");
        }

        try {
            // 2. 查询用户
            Optional<UserDevice> userOptional = userDeviceRepository.findByDeviceId(deviceId);
            if (userOptional.isEmpty()) {
                log.warn("登录失败：设备ID {} 不存在", deviceId);
                return Result.error("设备ID不存在");
            }

            // 3. 密码校验
            UserDevice user = userOptional.get();
            if (!user.getPassword().equals(password)) {
                log.warn("登录失败：设备ID {} 密码错误", deviceId);
                return Result.error("密码错误");
            }

            log.info("设备ID {} 登录成功", deviceId);
            return Result.success(user);
        } catch (Exception e) {
            log.error("登录异常（设备ID：{}）：{}", deviceId, e.getMessage(), e);
            return Result.error("登录失败：系统异常");
        }
    }

    // 获取用户信息：补充参数校验 + 异常捕获
    public Result<UserDevice> getUserInfo(String deviceId) {
        // 1. 非空校验
        if (deviceId == null || deviceId.trim().isEmpty()) {
            return Result.error("设备ID不能为空");
        }

        try {
            Optional<UserDevice> userOptional = userDeviceRepository.findByDeviceId(deviceId);
            return userOptional.map(Result::success)
                    .orElseGet(() -> {
                        log.warn("查询用户信息失败：设备ID {} 不存在", deviceId);
                        return Result.error("用户不存在");
                    });
        } catch (Exception e) {
            log.error("查询用户信息异常（设备ID：{}）：{}", deviceId, e.getMessage(), e);
            return Result.error("查询用户信息失败：系统异常");
        }
    }

    // 管理员查询所有用户列表：优化异常提示
    public Result<List<UserDevice>> listAllForAdmin() {
        try {
            List<UserDevice> userList = userDeviceRepository.findAll();
            log.info("查询所有用户列表成功，共 {} 条数据", userList.size());
            return Result.success(userList);
        } catch (Exception e) {
            log.error("查询用户列表异常：{}", e.getMessage(), e);
            return Result.error("查询用户列表失败：" + e.getMessage());
        }
    }
}