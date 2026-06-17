package com.example.healthmonitor;

import com.example.healthmonitor.config.DeepSeekProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EnableJpaRepositories("com.example.healthmonitor.repository")
@EnableConfigurationProperties(DeepSeekProperties.class)  // 这里启用 DeepSeek 配置
public class HealthMonitorApplication {
    public static void main(String[] args) {
        SpringApplication.run(HealthMonitorApplication.class, args);
    }
}