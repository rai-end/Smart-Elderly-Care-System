package com.example.healthmonitor;

import com.example.healthmonitor.service.DeepSeekService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class DeepSeekServiceTest {

    @Autowired
    private DeepSeekService deepSeekService;

    @Test
    public void testChat() {
        String question = "老人跌倒了应该怎么处理？";
        String answer = deepSeekService.chat(question);
        System.out.println("问题：" + question);
        System.out.println("AI回答：\n" + answer);
    }
}