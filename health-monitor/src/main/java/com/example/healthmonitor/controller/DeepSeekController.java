package com.example.healthmonitor.controller;

import com.example.healthmonitor.service.DeepSeekService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DeepSeekController {

    @Autowired
    private DeepSeekService deepSeekService;

    @PostMapping("/api/chat")
    public String chat(@RequestParam String question) {
        return deepSeekService.chat(question);
    }
}