package com.example.healthmonitor.service;

import com.example.healthmonitor.common.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
public class FallDetectionService {

    @Value("${fall.detection.python-api-url:http://localhost:5000/api/fall-detect}")
    private String pythonApiUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    /**
     * 调用Python YOLOv11进行跌倒检测
     * @param imgBase64 base64编码的图片（自动去除前缀）
     * @return 检测结果
     */
    public Result<Map<String, Object>> detectFall(String imgBase64) {
        try {
            log.info("开始调用YOLOv11跌倒检测API...");

            // 🔥 自动去除base64前缀（data:image/jpeg;base64,）
            String cleanBase64 = imgBase64;
            if (imgBase64.contains(",")) {
                cleanBase64 = imgBase64.split(",")[1];
            }

            // 准备请求体
            Map<String, String> requestBody = new HashMap<>();
            requestBody.put("imgBase64", cleanBase64);

            // 设置请求头
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            // 创建HTTP请求
            HttpEntity<Map<String, String>> request = new HttpEntity<>(requestBody, headers);

            // 发送POST请求到Python API
            ResponseEntity<Map> response = restTemplate.postForEntity(
                    pythonApiUrl,
                    request,
                    Map.class
            );

            // 解析响应
            if (response.getStatusCode() == HttpStatus.OK) {
                Map<String, Object> responseBody = response.getBody();

                String fallStatus = (String) responseBody.getOrDefault("fallStatus", "normal");
                double confidence = ((Number) responseBody.getOrDefault("confidence", 0.0)).doubleValue();
                String msg = (String) responseBody.getOrDefault("msg", "检测成功");

                log.info("YOLOv11检测完成 - 状态: {}, 置信度: {:.2f}", fallStatus, confidence);

                Map<String, Object> result = new HashMap<>();
                result.put("fallStatus", fallStatus);
                result.put("confidence", confidence);
                result.put("msg", msg);
                result.put("isFall", "fall".equals(fallStatus));

                return Result.success(result);
            } else {
                log.error("YOLOv11 API返回错误状态码: {}", response.getStatusCode());
                return Result.error("跌倒检测服务异常，状态码: " + response.getStatusCode());
            }

        } catch (Exception e) {
            log.error("调用YOLOv11跌倒检测失败: ", e);
            return Result.error("跌倒检测服务调用失败: " + e.getMessage());
        }
    }

    /**
     * 检查Python服务是否可用
     * @return 服务状态
     */
    public boolean isServiceAvailable() {
        try {
            // 尝试访问Python服务根路径
            restTemplate.getForEntity(pythonApiUrl.replace("/api/fall-detect", "/"), String.class);
            return true;
        } catch (Exception e) {
            log.warn("YOLOv11服务不可用: {}", e.getMessage());
            return false;
        }
    }
}