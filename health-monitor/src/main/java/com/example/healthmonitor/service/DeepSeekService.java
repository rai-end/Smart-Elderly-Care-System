package com.example.healthmonitor.service;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class DeepSeekService {

    @Value("${deepseek.api-key}")
    private String apiKey;

    @Value("${deepseek.api-url}")
    private String apiUrl;

    @Value("${deepseek.model}")
    private String model;

    private final RestTemplate restTemplate = new RestTemplate();

    public String chat(String question) {
        try {
            // 请求头
            org.springframework.http.HttpHeaders headers = new org.springframework.http.HttpHeaders();
            headers.add("Authorization", "Bearer " + apiKey);
            headers.add("Content-Type", "application/json");

            // 请求体
            JSONObject body = new JSONObject();
            body.put("model", model);

            JSONArray messages = new JSONArray();
            JSONObject systemMsg = new JSONObject();
            systemMsg.put("role", "system");
            systemMsg.put("content", "你是专业老人看护助手，回答简洁、安全、实用，专注跌倒急救、老人护理、健康建议。");

            JSONObject userMsg = new JSONObject();
            userMsg.put("role", "user");
            userMsg.put("content", question);

            messages.add(systemMsg);
            messages.add(userMsg);
            body.put("messages", messages);

            // 发送请求
            org.springframework.http.HttpEntity<String> request =
                    new org.springframework.http.HttpEntity<>(body.toJSONString(), headers);

            String response = restTemplate.postForObject(apiUrl, request, String.class);

            // 解析结果
            JSONObject resJson = JSON.parseObject(response);
            return resJson.getJSONArray("choices")
                    .getJSONObject(0)
                    .getJSONObject("message")
                    .getString("content");

        } catch (Exception e) {
            return "AI 服务异常：" + e.getMessage();
        }
    }
}