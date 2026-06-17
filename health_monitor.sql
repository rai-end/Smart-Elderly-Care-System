/*
 Navicat Premium Dump SQL

 Source Server         : root
 Source Server Type    : MySQL
 Source Server Version : 50726 (5.7.26)
 Source Host           : localhost:3306
 Source Schema         : health_monitor

 Target Server Type    : MySQL
 Target Server Version : 50726 (5.7.26)
 File Encoding         : 65001

 Date: 24/03/2026 20:39:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `admin_account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `admin_password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `admin_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `admin_account`(`admin_account`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (3, 'admin', 'admin123', '系统管理员', '2026-03-21 21:51:58');

-- ----------------------------
-- Table structure for health_data
-- ----------------------------
DROP TABLE IF EXISTS `health_data`;
CREATE TABLE `health_data`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `device_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '关联设备ID',
  `heart_rate` int(11) NULL DEFAULT NULL COMMENT '心率（次/分钟）',
  `systolic` int(11) NULL DEFAULT NULL COMMENT '收缩压（mmHg）',
  `diastolic` int(11) NULL DEFAULT NULL COMMENT '舒张压（mmHg）',
  `sp_o2` int(11) NULL DEFAULT NULL COMMENT '血氧（%）',
  `total_steps` int(11) NULL DEFAULT NULL COMMENT '总活动量（步）',
  `period_data` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时段活动量（JSON字符串）',
  `total_sleep` decimal(2, 1) NULL DEFAULT NULL,
  `deep_sleep` decimal(2, 1) NULL DEFAULT NULL,
  `shallow_sleep` decimal(2, 1) NULL DEFAULT NULL,
  `sleep_quality` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '睡眠质量',
  `fall_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '跌倒状态',
  `fall_risk_level` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '跌倒风险等级',
  `fall_check_time` datetime NULL DEFAULT NULL COMMENT '跌倒最后检测时间',
  `temperature` decimal(3, 1) NOT NULL DEFAULT 0.0,
  `temperature_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '体温状态',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据更新时间',
  `fall_score` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `device_id`(`device_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '健康数据总表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of health_data
-- ----------------------------
INSERT INTO `health_data` VALUES (1, 'DEV001', 67, 110, 85, 99, 27119, NULL, 7.0, 2.4, 4.6, '一般', '正常', '低', '2026-03-24 20:36:52', 36.4, '正常', '2026-03-24 20:36:52', 21);
INSERT INTO `health_data` VALUES (2, 'DEV002', 64, 90, 80, 95, 9164, NULL, 7.9, 2.2, 5.7, '良好', '跌倒', '高', '2026-03-24 20:36:52', 36.8, '正常', '2026-03-24 20:36:52', 98);
INSERT INTO `health_data` VALUES (3, 'DEV003', 93, 120, 66, 96, 8330, NULL, 7.2, 2.8, 4.4, '良好', '正常', '低', '2026-03-24 20:36:52', 36.2, '正常', '2026-03-24 20:36:52', 43);

-- ----------------------------
-- Table structure for health_data_backup_20260323
-- ----------------------------
DROP TABLE IF EXISTS `health_data_backup_20260323`;
CREATE TABLE `health_data_backup_20260323`  (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `device_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '关联设备ID',
  `heart_rate` int(11) NULL DEFAULT NULL COMMENT '心率（次/分钟）',
  `systolic` int(11) NULL DEFAULT NULL COMMENT '收缩压（mmHg）',
  `diastolic` int(11) NULL DEFAULT NULL COMMENT '舒张压（mmHg）',
  `sp_o2` int(11) NULL DEFAULT NULL COMMENT '血氧（%）',
  `total_steps` int(11) NULL DEFAULT NULL COMMENT '总活动量（步）',
  `period_data` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时段活动量（JSON字符串）',
  `total_sleep` decimal(2, 1) NULL DEFAULT NULL,
  `deep_sleep` decimal(2, 1) NULL DEFAULT NULL,
  `shallow_sleep` decimal(2, 1) NULL DEFAULT NULL,
  `sleep_quality` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '睡眠质量',
  `fall_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '跌倒状态',
  `fall_risk_level` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '跌倒风险等级',
  `fall_check_time` datetime NULL DEFAULT NULL COMMENT '跌倒最后检测时间',
  `temperature` decimal(3, 1) NOT NULL DEFAULT 0.0,
  `temperature_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '体温状态',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据更新时间'
) ENGINE = MyISAM CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of health_data_backup_20260323
-- ----------------------------
INSERT INTO `health_data_backup_20260323` VALUES (16, 'DEV001', 99, 103, 68, 100, 1100, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.4, 2.6, 5.8, '一般', '疑似跌倒', '中', '2026-03-23 21:24:05', 37.2, '偏高', '2026-03-23 21:24:05');
INSERT INTO `health_data_backup_20260323` VALUES (15, 'DEV003', 78, 125, 82, 96, 2100, NULL, 6.5, 2.0, 4.5, '一般', '未检测到跌倒', NULL, NULL, 36.3, '正常', '2026-03-21 21:22:42');
INSERT INTO `health_data_backup_20260323` VALUES (13, 'DEV001', 75, 120, 80, 98, 2856, NULL, 7.5, 2.5, 5.0, '良好', '未检测到跌倒', NULL, NULL, 36.5, '正常', '2026-03-21 21:22:42');
INSERT INTO `health_data_backup_20260323` VALUES (14, 'DEV002', 72, 115, 75, 97, 3200, NULL, 8.0, 3.0, 5.0, '优秀', '未检测到跌倒', NULL, NULL, 36.7, '正常', '2026-03-21 21:22:42');
INSERT INTO `health_data_backup_20260323` VALUES (17, 'DEV002', 68, 138, 79, 100, 3277, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.2, 2.1, 6.1, '良好', '疑似跌倒', '中', '2026-03-23 21:24:05', 36.8, '正常', '2026-03-23 21:24:05');
INSERT INTO `health_data_backup_20260323` VALUES (18, 'DEV003', 77, 95, 86, 96, 5240, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.4, 3.4, 3.0, '一般', '疑似跌倒', '中', '2026-03-23 21:24:05', 36.2, '正常', '2026-03-23 21:24:05');
INSERT INTO `health_data_backup_20260323` VALUES (1016, 'DEV001', 76, 130, 72, 96, 4216, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.5, 4.3, 2.2, '良好', '疑似跌倒', '中', '2026-03-23 21:24:10', 36.5, '正常', '2026-03-23 21:24:10');
INSERT INTO `health_data_backup_20260323` VALUES (1017, 'DEV002', 89, 98, 61, 96, 3347, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.4, 4.7, 3.7, '良好', '无跌倒', '中', '2026-03-23 21:24:10', 36.5, '正常', '2026-03-23 21:24:10');
INSERT INTO `health_data_backup_20260323` VALUES (1018, 'DEV003', 78, 137, 60, 99, 5833, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.4, 5.6, 1.8, '一般', '无跌倒', '中', '2026-03-23 21:24:10', 37.1, '偏高', '2026-03-23 21:24:10');
INSERT INTO `health_data_backup_20260323` VALUES (2016, 'DEV001', 67, 130, 63, 99, 3511, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.7, 5.8, 0.9, '一般', '疑似跌倒', '低', '2026-03-23 21:24:15', 36.5, '正常', '2026-03-23 21:24:15');
INSERT INTO `health_data_backup_20260323` VALUES (2017, 'DEV002', 91, 90, 77, 100, 1278, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.9, 5.7, 3.2, '良好', '疑似跌倒', '低', '2026-03-23 21:24:15', 36.4, '正常', '2026-03-23 21:24:15');
INSERT INTO `health_data_backup_20260323` VALUES (2018, 'DEV003', 97, 109, 67, 95, 5044, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.5, 2.3, 6.2, '一般', '无跌倒', '中', '2026-03-23 21:24:15', 36.7, '正常', '2026-03-23 21:24:15');
INSERT INTO `health_data_backup_20260323` VALUES (3016, 'DEV001', 92, 94, 72, 95, 4219, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.9, 4.0, 2.9, '良好', '疑似跌倒', '中', '2026-03-23 21:24:20', 36.2, '正常', '2026-03-23 21:24:20');
INSERT INTO `health_data_backup_20260323` VALUES (3017, 'DEV002', 62, 106, 84, 97, 4698, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.3, 3.0, 5.3, '良好', '无跌倒', '中', '2026-03-23 21:24:20', 37.1, '偏高', '2026-03-23 21:24:20');
INSERT INTO `health_data_backup_20260323` VALUES (3018, 'DEV003', 93, 96, 90, 99, 5189, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.8, 5.8, 3.0, '良好', '无跌倒', '中', '2026-03-23 21:24:20', 36.8, '正常', '2026-03-23 21:24:20');
INSERT INTO `health_data_backup_20260323` VALUES (4016, 'DEV001', 90, 101, 73, 97, 3589, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.8, 5.5, 1.3, '一般', '无跌倒', '低', '2026-03-23 21:24:25', 36.1, '正常', '2026-03-23 21:24:25');
INSERT INTO `health_data_backup_20260323` VALUES (4017, 'DEV002', 81, 124, 67, 100, 2017, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.8, 4.8, 2.0, '良好', '无跌倒', '中', '2026-03-23 21:24:25', 36.6, '正常', '2026-03-23 21:24:25');
INSERT INTO `health_data_backup_20260323` VALUES (4018, 'DEV003', 97, 134, 76, 97, 1406, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.9, 5.3, 2.6, '一般', '无跌倒', '中', '2026-03-23 21:24:25', 36.9, '正常', '2026-03-23 21:24:25');
INSERT INTO `health_data_backup_20260323` VALUES (5016, 'DEV001', 85, 105, 84, 98, 2033, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.8, 3.6, 4.2, '良好', '无跌倒', '低', '2026-03-23 21:24:30', 36.2, '正常', '2026-03-23 21:24:30');
INSERT INTO `health_data_backup_20260323` VALUES (5017, 'DEV002', 81, 111, 89, 97, 2019, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.7, 5.2, 1.5, '一般', '疑似跌倒', '低', '2026-03-23 21:24:30', 36.3, '正常', '2026-03-23 21:24:30');
INSERT INTO `health_data_backup_20260323` VALUES (5018, 'DEV003', 62, 115, 68, 96, 1770, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.4, 2.1, 5.3, '一般', '疑似跌倒', '低', '2026-03-23 21:24:30', 36.2, '正常', '2026-03-23 21:24:30');
INSERT INTO `health_data_backup_20260323` VALUES (6016, 'DEV001', 94, 106, 84, 96, 5799, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.8, 4.6, 4.2, '一般', '疑似跌倒', '中', '2026-03-23 21:24:35', 36.1, '正常', '2026-03-23 21:24:35');
INSERT INTO `health_data_backup_20260323` VALUES (6017, 'DEV002', 84, 111, 74, 98, 2997, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.4, 2.5, 3.9, '良好', '无跌倒', '中', '2026-03-23 21:24:35', 36.5, '正常', '2026-03-23 21:24:35');
INSERT INTO `health_data_backup_20260323` VALUES (6018, 'DEV003', 84, 134, 82, 98, 5722, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.3, 2.4, 5.9, '一般', '疑似跌倒', '低', '2026-03-23 21:24:35', 36.6, '正常', '2026-03-23 21:24:35');
INSERT INTO `health_data_backup_20260323` VALUES (7016, 'DEV001', 95, 117, 72, 99, 4025, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.2, 3.2, 3.0, '一般', '无跌倒', '低', '2026-03-23 21:24:40', 36.8, '正常', '2026-03-23 21:24:40');
INSERT INTO `health_data_backup_20260323` VALUES (7017, 'DEV002', 74, 106, 90, 97, 4460, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.1, 2.4, 3.7, '一般', '无跌倒', '低', '2026-03-23 21:24:40', 36.6, '正常', '2026-03-23 21:24:40');
INSERT INTO `health_data_backup_20260323` VALUES (7018, 'DEV003', 60, 98, 72, 96, 5665, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.7, 4.8, 1.9, '一般', '疑似跌倒', '中', '2026-03-23 21:24:40', 36.1, '正常', '2026-03-23 21:24:40');
INSERT INTO `health_data_backup_20260323` VALUES (8016, 'DEV001', 64, 114, 78, 97, 2636, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.0, 4.2, 2.8, '一般', '疑似跌倒', '低', '2026-03-23 21:24:45', 37.1, '偏高', '2026-03-23 21:24:45');
INSERT INTO `health_data_backup_20260323` VALUES (8017, 'DEV002', 100, 91, 61, 97, 5338, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.8, 2.1, 4.7, '良好', '疑似跌倒', '低', '2026-03-23 21:24:45', 36.8, '正常', '2026-03-23 21:24:45');
INSERT INTO `health_data_backup_20260323` VALUES (8018, 'DEV003', 81, 131, 79, 95, 4826, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.2, 5.3, 1.9, '一般', '疑似跌倒', '低', '2026-03-23 21:24:45', 36.6, '正常', '2026-03-23 21:24:45');
INSERT INTO `health_data_backup_20260323` VALUES (9016, 'DEV001', 74, 111, 84, 96, 1719, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.7, 2.9, 5.8, '一般', '疑似跌倒', '低', '2026-03-23 21:24:50', 37.0, '正常', '2026-03-23 21:24:50');
INSERT INTO `health_data_backup_20260323` VALUES (9017, 'DEV002', 97, 124, 84, 98, 5908, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.2, 5.5, 0.7, '良好', '无跌倒', '中', '2026-03-23 21:24:50', 36.2, '正常', '2026-03-23 21:24:50');
INSERT INTO `health_data_backup_20260323` VALUES (9018, 'DEV003', 78, 121, 72, 98, 1828, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.5, 3.4, 3.1, '一般', '疑似跌倒', '低', '2026-03-23 21:24:50', 36.9, '正常', '2026-03-23 21:24:50');
INSERT INTO `health_data_backup_20260323` VALUES (10016, 'DEV001', 82, 114, 82, 97, 3663, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.3, 2.8, 5.5, '良好', '疑似跌倒', '中', '2026-03-23 21:24:55', 36.0, '正常', '2026-03-23 21:24:55');
INSERT INTO `health_data_backup_20260323` VALUES (10017, 'DEV002', 95, 126, 74, 95, 5461, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.3, 5.1, 1.2, '良好', '无跌倒', '低', '2026-03-23 21:24:55', 36.9, '正常', '2026-03-23 21:24:55');
INSERT INTO `health_data_backup_20260323` VALUES (10018, 'DEV003', 94, 100, 68, 99, 3347, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.1, 5.4, 1.7, '良好', '无跌倒', '低', '2026-03-23 21:24:55', 36.6, '正常', '2026-03-23 21:24:55');
INSERT INTO `health_data_backup_20260323` VALUES (11016, 'DEV001', 91, 102, 85, 100, 1408, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 3.3, 4.3, '良好', '无跌倒', '中', '2026-03-23 21:25:00', 36.3, '正常', '2026-03-23 21:25:00');
INSERT INTO `health_data_backup_20260323` VALUES (11017, 'DEV002', 76, 137, 68, 99, 2141, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.3, 5.2, 3.1, '良好', '无跌倒', '中', '2026-03-23 21:25:00', 36.4, '正常', '2026-03-23 21:25:00');
INSERT INTO `health_data_backup_20260323` VALUES (11018, 'DEV003', 77, 136, 90, 98, 5737, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.7, 4.6, 4.1, '良好', '疑似跌倒', '中', '2026-03-23 21:25:00', 36.9, '正常', '2026-03-23 21:25:00');
INSERT INTO `health_data_backup_20260323` VALUES (12016, 'DEV001', 78, 91, 69, 100, 1824, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.1, 5.9, 2.2, '良好', '疑似跌倒', '中', '2026-03-23 21:25:05', 36.0, '正常', '2026-03-23 21:25:05');
INSERT INTO `health_data_backup_20260323` VALUES (12017, 'DEV002', 71, 101, 75, 99, 3174, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.2, 3.7, 4.5, '良好', '无跌倒', '中', '2026-03-23 21:25:05', 36.0, '正常', '2026-03-23 21:25:05');
INSERT INTO `health_data_backup_20260323` VALUES (12018, 'DEV003', 96, 104, 82, 99, 3530, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.1, 3.7, 3.4, '一般', '无跌倒', '低', '2026-03-23 21:25:05', 36.0, '正常', '2026-03-23 21:25:05');
INSERT INTO `health_data_backup_20260323` VALUES (13016, 'DEV001', 72, 110, 82, 99, 2992, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.2, 3.8, 2.4, '一般', '疑似跌倒', '低', '2026-03-23 21:25:10', 36.2, '正常', '2026-03-23 21:25:10');
INSERT INTO `health_data_backup_20260323` VALUES (13017, 'DEV002', 84, 133, 65, 98, 5703, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.1, 4.6, 1.5, '一般', '无跌倒', '低', '2026-03-23 21:25:10', 36.1, '正常', '2026-03-23 21:25:10');
INSERT INTO `health_data_backup_20260323` VALUES (13018, 'DEV003', 68, 95, 83, 98, 1572, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.5, 3.1, 5.4, '良好', '无跌倒', '中', '2026-03-23 21:25:10', 36.8, '正常', '2026-03-23 21:25:10');
INSERT INTO `health_data_backup_20260323` VALUES (14016, 'DEV001', 71, 135, 83, 98, 1870, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 3.5, 4.1, '一般', '疑似跌倒', '中', '2026-03-23 21:25:15', 36.7, '正常', '2026-03-23 21:25:15');
INSERT INTO `health_data_backup_20260323` VALUES (14017, 'DEV002', 98, 103, 61, 97, 3533, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.7, 4.9, 2.8, '良好', '无跌倒', '低', '2026-03-23 21:25:15', 36.5, '正常', '2026-03-23 21:25:15');
INSERT INTO `health_data_backup_20260323` VALUES (14018, 'DEV003', 75, 125, 67, 98, 1528, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.5, 3.6, 4.9, '良好', '疑似跌倒', '中', '2026-03-23 21:25:15', 36.8, '正常', '2026-03-23 21:25:15');
INSERT INTO `health_data_backup_20260323` VALUES (15016, 'DEV001', 93, 108, 73, 97, 3231, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.4, 2.1, 5.3, '一般', '疑似跌倒', '低', '2026-03-23 21:25:20', 37.0, '正常', '2026-03-23 21:25:20');
INSERT INTO `health_data_backup_20260323` VALUES (15017, 'DEV002', 71, 94, 79, 100, 3041, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.4, 2.6, 4.8, '良好', '无跌倒', '中', '2026-03-23 21:25:20', 36.4, '正常', '2026-03-23 21:25:20');
INSERT INTO `health_data_backup_20260323` VALUES (15018, 'DEV003', 84, 123, 75, 95, 2162, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.7, 4.5, 2.2, '良好', '无跌倒', '中', '2026-03-23 21:25:20', 36.9, '正常', '2026-03-23 21:25:20');
INSERT INTO `health_data_backup_20260323` VALUES (16016, 'DEV001', 89, 131, 82, 97, 2841, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.7, 5.8, 2.9, '良好', '无跌倒', '低', '2026-03-23 21:25:25', 37.1, '偏高', '2026-03-23 21:25:25');
INSERT INTO `health_data_backup_20260323` VALUES (16017, 'DEV002', 80, 112, 60, 99, 2350, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.5, 4.6, 1.9, '一般', '无跌倒', '低', '2026-03-23 21:25:25', 36.8, '正常', '2026-03-23 21:25:25');
INSERT INTO `health_data_backup_20260323` VALUES (16018, 'DEV003', 69, 107, 69, 96, 1051, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.6, 5.8, 2.8, '一般', '无跌倒', '中', '2026-03-23 21:25:25', 36.3, '正常', '2026-03-23 21:25:25');
INSERT INTO `health_data_backup_20260323` VALUES (17016, 'DEV001', 100, 103, 90, 98, 3627, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.2, 4.6, 1.6, '良好', '疑似跌倒', '低', '2026-03-23 21:25:30', 36.2, '正常', '2026-03-23 21:25:30');
INSERT INTO `health_data_backup_20260323` VALUES (17017, 'DEV002', 75, 133, 82, 95, 4128, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.5, 2.2, 5.3, '良好', '疑似跌倒', '中', '2026-03-23 21:25:30', 36.4, '正常', '2026-03-23 21:25:30');
INSERT INTO `health_data_backup_20260323` VALUES (17018, 'DEV003', 89, 90, 75, 100, 4582, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 4.7, 2.9, '一般', '无跌倒', '中', '2026-03-23 21:25:30', 36.3, '正常', '2026-03-23 21:25:30');
INSERT INTO `health_data_backup_20260323` VALUES (18016, 'DEV001', 83, 95, 78, 95, 1654, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.0, 2.2, 3.8, '一般', '无跌倒', '低', '2026-03-23 21:25:35', 37.1, '偏高', '2026-03-23 21:25:35');
INSERT INTO `health_data_backup_20260323` VALUES (18017, 'DEV002', 80, 124, 73, 97, 3868, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.4, 2.3, 5.1, '一般', '无跌倒', '低', '2026-03-23 21:25:35', 37.2, '偏高', '2026-03-23 21:25:35');
INSERT INTO `health_data_backup_20260323` VALUES (18018, 'DEV003', 62, 132, 73, 98, 3726, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.9, 2.9, 4.0, '一般', '无跌倒', '低', '2026-03-23 21:25:35', 37.1, '偏高', '2026-03-23 21:25:35');
INSERT INTO `health_data_backup_20260323` VALUES (19016, 'DEV001', 66, 90, 63, 96, 5828, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.2, 4.0, 4.2, '良好', '疑似跌倒', '低', '2026-03-23 21:25:40', 37.0, '正常', '2026-03-23 21:25:40');
INSERT INTO `health_data_backup_20260323` VALUES (19017, 'DEV002', 71, 113, 64, 99, 4834, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.9, 3.7, 3.2, '一般', '无跌倒', '中', '2026-03-23 21:25:40', 36.3, '正常', '2026-03-23 21:25:40');
INSERT INTO `health_data_backup_20260323` VALUES (19018, 'DEV003', 82, 128, 87, 100, 2392, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.6, 5.6, 3.0, '一般', '疑似跌倒', '中', '2026-03-23 21:25:40', 36.2, '正常', '2026-03-23 21:25:40');
INSERT INTO `health_data_backup_20260323` VALUES (20016, 'DEV001', 66, 107, 89, 97, 4455, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.2, 2.1, 6.1, '一般', '无跌倒', '中', '2026-03-23 21:25:45', 36.1, '正常', '2026-03-23 21:25:45');
INSERT INTO `health_data_backup_20260323` VALUES (20017, 'DEV002', 78, 123, 72, 100, 5262, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.3, 4.1, 2.2, '一般', '无跌倒', '低', '2026-03-23 21:25:45', 37.1, '偏高', '2026-03-23 21:25:45');
INSERT INTO `health_data_backup_20260323` VALUES (20018, 'DEV003', 61, 135, 72, 97, 5079, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.4, 3.7, 3.7, '良好', '疑似跌倒', '低', '2026-03-23 21:25:45', 36.5, '正常', '2026-03-23 21:25:45');
INSERT INTO `health_data_backup_20260323` VALUES (21016, 'DEV001', 96, 117, 87, 98, 1952, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 2.6, 5.0, '一般', '无跌倒', '低', '2026-03-23 21:25:50', 36.3, '正常', '2026-03-23 21:25:50');
INSERT INTO `health_data_backup_20260323` VALUES (21017, 'DEV002', 84, 93, 66, 97, 3478, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.9, 4.2, 2.7, '良好', '无跌倒', '中', '2026-03-23 21:25:50', 36.3, '正常', '2026-03-23 21:25:50');
INSERT INTO `health_data_backup_20260323` VALUES (21018, 'DEV003', 64, 138, 71, 95, 5131, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.7, 2.9, 4.8, '良好', '无跌倒', '中', '2026-03-23 21:25:50', 36.2, '正常', '2026-03-23 21:25:50');
INSERT INTO `health_data_backup_20260323` VALUES (22016, 'DEV001', 79, 96, 85, 100, 2422, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.5, 3.6, 3.9, '一般', '疑似跌倒', '中', '2026-03-23 21:25:55', 36.3, '正常', '2026-03-23 21:25:55');
INSERT INTO `health_data_backup_20260323` VALUES (22017, 'DEV002', 70, 108, 77, 97, 5947, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.8, 4.7, 2.1, '良好', '无跌倒', '低', '2026-03-23 21:25:55', 36.1, '正常', '2026-03-23 21:25:55');
INSERT INTO `health_data_backup_20260323` VALUES (22018, 'DEV003', 77, 101, 62, 100, 1824, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.8, 3.3, 5.5, '良好', '无跌倒', '低', '2026-03-23 21:25:55', 36.2, '正常', '2026-03-23 21:25:55');
INSERT INTO `health_data_backup_20260323` VALUES (23016, 'DEV001', 89, 107, 77, 97, 1918, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.5, 2.1, 5.4, '一般', '疑似跌倒', '低', '2026-03-23 21:26:00', 36.2, '正常', '2026-03-23 21:26:00');
INSERT INTO `health_data_backup_20260323` VALUES (23017, 'DEV002', 97, 129, 72, 96, 3924, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.7, 5.5, 3.2, '一般', '疑似跌倒', '中', '2026-03-23 21:26:00', 36.5, '正常', '2026-03-23 21:26:00');
INSERT INTO `health_data_backup_20260323` VALUES (23018, 'DEV003', 84, 100, 75, 99, 1090, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.5, 2.0, 4.5, '一般', '无跌倒', '中', '2026-03-23 21:26:00', 36.7, '正常', '2026-03-23 21:26:00');
INSERT INTO `health_data_backup_20260323` VALUES (24016, 'DEV001', 78, 115, 77, 96, 2833, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.4, 5.8, 1.6, '良好', '无跌倒', '低', '2026-03-23 21:26:05', 36.4, '正常', '2026-03-23 21:26:05');
INSERT INTO `health_data_backup_20260323` VALUES (24017, 'DEV002', 89, 102, 90, 95, 1557, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.1, 2.1, 5.0, '一般', '无跌倒', '中', '2026-03-23 21:26:05', 36.3, '正常', '2026-03-23 21:26:05');
INSERT INTO `health_data_backup_20260323` VALUES (24018, 'DEV003', 63, 93, 75, 100, 5004, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.8, 3.7, 5.1, '一般', '疑似跌倒', '低', '2026-03-23 21:26:05', 36.3, '正常', '2026-03-23 21:26:05');
INSERT INTO `health_data_backup_20260323` VALUES (25016, 'DEV001', 84, 137, 63, 98, 4266, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.5, 2.8, 5.7, '一般', '无跌倒', '中', '2026-03-23 21:26:10', 37.0, '正常', '2026-03-23 21:26:10');
INSERT INTO `health_data_backup_20260323` VALUES (25017, 'DEV002', 80, 127, 77, 97, 5656, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.0, 2.3, 5.7, '一般', '无跌倒', '中', '2026-03-23 21:26:10', 36.9, '正常', '2026-03-23 21:26:10');
INSERT INTO `health_data_backup_20260323` VALUES (25018, 'DEV003', 73, 131, 68, 100, 3365, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.3, 4.3, 2.0, '一般', '疑似跌倒', '低', '2026-03-23 21:26:10', 36.4, '正常', '2026-03-23 21:26:10');
INSERT INTO `health_data_backup_20260323` VALUES (26016, 'DEV001', 92, 126, 90, 99, 3753, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.9, 5.3, 3.6, '一般', '无跌倒', '低', '2026-03-23 21:26:15', 36.7, '正常', '2026-03-23 21:26:15');
INSERT INTO `health_data_backup_20260323` VALUES (26017, 'DEV002', 64, 107, 76, 100, 5418, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.6, 5.6, 1.0, '良好', '疑似跌倒', '中', '2026-03-23 21:26:15', 36.7, '正常', '2026-03-23 21:26:15');
INSERT INTO `health_data_backup_20260323` VALUES (26018, 'DEV003', 62, 140, 63, 100, 4659, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 2.2, 5.4, '一般', '无跌倒', '低', '2026-03-23 21:26:15', 36.3, '正常', '2026-03-23 21:26:15');
INSERT INTO `health_data_backup_20260323` VALUES (27016, 'DEV001', 95, 110, 67, 99, 1322, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.5, 2.6, 5.9, '良好', '疑似跌倒', '低', '2026-03-23 21:26:20', 36.7, '正常', '2026-03-23 21:26:20');
INSERT INTO `health_data_backup_20260323` VALUES (27017, 'DEV002', 68, 104, 76, 97, 1316, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.7, 5.7, 3.0, '良好', '无跌倒', '中', '2026-03-23 21:26:20', 36.2, '正常', '2026-03-23 21:26:20');
INSERT INTO `health_data_backup_20260323` VALUES (27018, 'DEV003', 60, 139, 88, 95, 1410, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.4, 5.1, 3.3, '良好', '无跌倒', '中', '2026-03-23 21:26:20', 37.1, '偏高', '2026-03-23 21:26:20');
INSERT INTO `health_data_backup_20260323` VALUES (28016, 'DEV001', 76, 97, 76, 96, 3003, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.2, 2.3, 5.9, '良好', '无跌倒', '中', '2026-03-23 21:26:25', 36.7, '正常', '2026-03-23 21:26:25');
INSERT INTO `health_data_backup_20260323` VALUES (28017, 'DEV002', 79, 105, 81, 100, 4784, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.1, 3.6, 4.5, '良好', '无跌倒', '中', '2026-03-23 21:26:25', 37.2, '偏高', '2026-03-23 21:26:25');
INSERT INTO `health_data_backup_20260323` VALUES (28018, 'DEV003', 61, 111, 79, 98, 4559, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.4, 3.4, 4.0, '良好', '无跌倒', '中', '2026-03-23 21:26:25', 37.1, '偏高', '2026-03-23 21:26:25');
INSERT INTO `health_data_backup_20260323` VALUES (29016, 'DEV001', 70, 97, 80, 97, 2361, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.9, 3.8, 3.1, '一般', '疑似跌倒', '中', '2026-03-23 21:26:30', 36.6, '正常', '2026-03-23 21:26:30');
INSERT INTO `health_data_backup_20260323` VALUES (29017, 'DEV002', 65, 118, 60, 96, 4241, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.1, 3.6, 4.5, '一般', '疑似跌倒', '中', '2026-03-23 21:26:30', 37.0, '正常', '2026-03-23 21:26:30');
INSERT INTO `health_data_backup_20260323` VALUES (29018, 'DEV003', 64, 113, 90, 95, 3375, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.8, 4.9, 1.9, '良好', '无跌倒', '低', '2026-03-23 21:26:30', 36.6, '正常', '2026-03-23 21:26:30');
INSERT INTO `health_data_backup_20260323` VALUES (30016, 'DEV001', 87, 92, 78, 100, 1592, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.4, 3.5, 3.9, '良好', '无跌倒', '中', '2026-03-23 21:26:35', 37.0, '正常', '2026-03-23 21:26:35');
INSERT INTO `health_data_backup_20260323` VALUES (30017, 'DEV002', 96, 98, 70, 98, 5235, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.7, 5.0, 3.7, '一般', '疑似跌倒', '中', '2026-03-23 21:26:35', 37.1, '偏高', '2026-03-23 21:26:35');
INSERT INTO `health_data_backup_20260323` VALUES (30018, 'DEV003', 80, 115, 70, 95, 3255, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.1, 2.3, 5.8, '良好', '疑似跌倒', '中', '2026-03-23 21:26:35', 36.2, '正常', '2026-03-23 21:26:35');
INSERT INTO `health_data_backup_20260323` VALUES (31016, 'DEV001', 83, 119, 90, 95, 4080, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.5, 5.5, 1.0, '一般', '无跌倒', '低', '2026-03-23 21:26:40', 36.6, '正常', '2026-03-23 21:26:40');
INSERT INTO `health_data_backup_20260323` VALUES (31017, 'DEV002', 61, 101, 84, 97, 4493, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.2, 3.6, 2.6, '一般', '无跌倒', '低', '2026-03-23 21:26:40', 36.7, '正常', '2026-03-23 21:26:40');
INSERT INTO `health_data_backup_20260323` VALUES (31018, 'DEV003', 80, 131, 81, 98, 2379, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.6, 3.9, 2.7, '一般', '疑似跌倒', '低', '2026-03-23 21:26:40', 36.1, '正常', '2026-03-23 21:26:40');
INSERT INTO `health_data_backup_20260323` VALUES (32016, 'DEV001', 75, 96, 85, 99, 1665, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.1, 3.3, 2.8, '一般', '疑似跌倒', '中', '2026-03-23 21:26:45', 36.7, '正常', '2026-03-23 21:26:45');
INSERT INTO `health_data_backup_20260323` VALUES (32017, 'DEV002', 63, 120, 84, 97, 2724, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.3, 4.9, 3.4, '良好', '无跌倒', '中', '2026-03-23 21:26:45', 36.8, '正常', '2026-03-23 21:26:45');
INSERT INTO `health_data_backup_20260323` VALUES (32018, 'DEV003', 62, 98, 72, 99, 2000, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.7, 2.4, 5.3, '一般', '无跌倒', '低', '2026-03-23 21:26:45', 36.7, '正常', '2026-03-23 21:26:45');
INSERT INTO `health_data_backup_20260323` VALUES (33016, 'DEV001', 73, 107, 82, 100, 2288, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.7, 4.7, 2.0, '一般', '无跌倒', '低', '2026-03-23 21:26:50', 36.3, '正常', '2026-03-23 21:26:50');
INSERT INTO `health_data_backup_20260323` VALUES (33017, 'DEV002', 91, 131, 78, 99, 2342, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.0, 2.1, 5.9, '良好', '疑似跌倒', '中', '2026-03-23 21:26:50', 36.1, '正常', '2026-03-23 21:26:50');
INSERT INTO `health_data_backup_20260323` VALUES (33018, 'DEV003', 88, 91, 90, 96, 5958, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.6, 4.9, 3.7, '良好', '无跌倒', '低', '2026-03-23 21:26:50', 37.0, '正常', '2026-03-23 21:26:50');
INSERT INTO `health_data_backup_20260323` VALUES (34016, 'DEV001', 70, 124, 73, 99, 2571, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.7, 3.8, 4.9, '良好', '无跌倒', '低', '2026-03-23 21:26:55', 37.1, '偏高', '2026-03-23 21:26:55');
INSERT INTO `health_data_backup_20260323` VALUES (34017, 'DEV002', 87, 99, 79, 96, 4488, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.1, 3.9, 4.2, '良好', '无跌倒', '低', '2026-03-23 21:26:55', 37.1, '偏高', '2026-03-23 21:26:55');
INSERT INTO `health_data_backup_20260323` VALUES (34018, 'DEV003', 86, 125, 81, 95, 4301, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.8, 2.5, 6.3, '一般', '无跌倒', '低', '2026-03-23 21:26:55', 36.7, '正常', '2026-03-23 21:26:55');
INSERT INTO `health_data_backup_20260323` VALUES (35016, 'DEV001', 81, 138, 82, 99, 5375, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.2, 5.9, 1.3, '一般', '疑似跌倒', '中', '2026-03-23 21:27:00', 36.5, '正常', '2026-03-23 21:27:00');
INSERT INTO `health_data_backup_20260323` VALUES (35017, 'DEV002', 68, 102, 72, 96, 2347, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.7, 4.5, 3.2, '一般', '疑似跌倒', '低', '2026-03-23 21:27:00', 36.9, '正常', '2026-03-23 21:27:00');
INSERT INTO `health_data_backup_20260323` VALUES (35018, 'DEV003', 71, 131, 80, 100, 2480, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.2, 5.4, 1.8, '一般', '无跌倒', '低', '2026-03-23 21:27:00', 36.0, '正常', '2026-03-23 21:27:00');
INSERT INTO `health_data_backup_20260323` VALUES (36016, 'DEV001', 60, 116, 85, 99, 4407, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 2.7, 4.9, '一般', '疑似跌倒', '中', '2026-03-23 21:27:05', 36.7, '正常', '2026-03-23 21:27:05');
INSERT INTO `health_data_backup_20260323` VALUES (36017, 'DEV002', 70, 130, 76, 96, 5250, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.8, 2.8, 6.0, '一般', '疑似跌倒', '中', '2026-03-23 21:27:05', 36.7, '正常', '2026-03-23 21:27:05');
INSERT INTO `health_data_backup_20260323` VALUES (36018, 'DEV003', 78, 129, 63, 98, 3667, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 3.8, 3.8, '良好', '疑似跌倒', '低', '2026-03-23 21:27:05', 36.7, '正常', '2026-03-23 21:27:05');
INSERT INTO `health_data_backup_20260323` VALUES (37016, 'DEV001', 73, 117, 61, 96, 5822, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.2, 5.1, 2.1, '一般', '疑似跌倒', '中', '2026-03-23 21:27:10', 36.5, '正常', '2026-03-23 21:27:10');
INSERT INTO `health_data_backup_20260323` VALUES (37017, 'DEV002', 79, 99, 86, 96, 1271, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.0, 3.7, 4.3, '良好', '无跌倒', '中', '2026-03-23 21:27:10', 36.0, '正常', '2026-03-23 21:27:10');
INSERT INTO `health_data_backup_20260323` VALUES (37018, 'DEV003', 77, 106, 89, 95, 4726, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.3, 4.4, 1.9, '一般', '疑似跌倒', '中', '2026-03-23 21:27:10', 37.1, '偏高', '2026-03-23 21:27:10');
INSERT INTO `health_data_backup_20260323` VALUES (38016, 'DEV001', 93, 104, 62, 98, 2346, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.8, 3.0, 4.8, '一般', '疑似跌倒', '中', '2026-03-23 21:27:15', 37.0, '正常', '2026-03-23 21:27:15');
INSERT INTO `health_data_backup_20260323` VALUES (38017, 'DEV002', 67, 134, 62, 99, 4811, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 2.1, 5.5, '一般', '无跌倒', '低', '2026-03-23 21:27:15', 37.1, '偏高', '2026-03-23 21:27:15');
INSERT INTO `health_data_backup_20260323` VALUES (38018, 'DEV003', 76, 140, 88, 97, 4126, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.6, 5.3, 3.3, '良好', '无跌倒', '低', '2026-03-23 21:27:15', 36.5, '正常', '2026-03-23 21:27:15');
INSERT INTO `health_data_backup_20260323` VALUES (39016, 'DEV001', 76, 122, 62, 96, 3699, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 4.5, 3.1, '一般', '无跌倒', '低', '2026-03-23 21:27:20', 37.0, '正常', '2026-03-23 21:27:20');
INSERT INTO `health_data_backup_20260323` VALUES (39017, 'DEV002', 67, 136, 80, 96, 2022, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.7, 3.0, 5.7, '良好', '疑似跌倒', '低', '2026-03-23 21:27:20', 36.7, '正常', '2026-03-23 21:27:20');
INSERT INTO `health_data_backup_20260323` VALUES (39018, 'DEV003', 77, 108, 82, 99, 4845, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.3, 4.8, 3.5, '一般', '疑似跌倒', '低', '2026-03-23 21:27:20', 36.6, '正常', '2026-03-23 21:27:20');
INSERT INTO `health_data_backup_20260323` VALUES (40016, 'DEV001', 86, 101, 61, 97, 2007, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.4, 2.9, 4.5, '一般', '疑似跌倒', '中', '2026-03-23 21:27:25', 36.4, '正常', '2026-03-23 21:27:25');
INSERT INTO `health_data_backup_20260323` VALUES (40017, 'DEV002', 75, 116, 65, 96, 2165, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.3, 3.4, 4.9, '良好', '疑似跌倒', '中', '2026-03-23 21:27:25', 36.5, '正常', '2026-03-23 21:27:25');
INSERT INTO `health_data_backup_20260323` VALUES (40018, 'DEV003', 60, 115, 66, 99, 3826, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.0, 2.9, 4.1, '一般', '无跌倒', '低', '2026-03-23 21:27:25', 37.1, '偏高', '2026-03-23 21:27:25');
INSERT INTO `health_data_backup_20260323` VALUES (41016, 'DEV001', 94, 116, 74, 95, 2829, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.0, 2.6, 4.4, '良好', '无跌倒', '低', '2026-03-23 21:27:30', 36.4, '正常', '2026-03-23 21:27:30');
INSERT INTO `health_data_backup_20260323` VALUES (41017, 'DEV002', 68, 111, 64, 95, 3543, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.8, 3.5, 3.3, '一般', '疑似跌倒', '低', '2026-03-23 21:27:30', 36.9, '正常', '2026-03-23 21:27:30');
INSERT INTO `health_data_backup_20260323` VALUES (41018, 'DEV003', 87, 100, 76, 99, 1243, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.1, 5.1, 2.0, '一般', '无跌倒', '低', '2026-03-23 21:27:30', 36.9, '正常', '2026-03-23 21:27:30');
INSERT INTO `health_data_backup_20260323` VALUES (42016, 'DEV001', 67, 122, 89, 100, 5207, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.0, 4.4, 3.6, '良好', '疑似跌倒', '中', '2026-03-23 21:27:35', 36.1, '正常', '2026-03-23 21:27:35');
INSERT INTO `health_data_backup_20260323` VALUES (42017, 'DEV002', 82, 117, 60, 96, 3963, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.9, 3.2, 4.7, '一般', '疑似跌倒', '中', '2026-03-23 21:27:35', 36.7, '正常', '2026-03-23 21:27:35');
INSERT INTO `health_data_backup_20260323` VALUES (42018, 'DEV003', 71, 104, 90, 95, 2089, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.8, 5.8, 3.0, '良好', '疑似跌倒', '中', '2026-03-23 21:27:35', 36.7, '正常', '2026-03-23 21:27:35');
INSERT INTO `health_data_backup_20260323` VALUES (43016, 'DEV001', 62, 124, 80, 95, 4814, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.2, 4.5, 1.7, '一般', '疑似跌倒', '低', '2026-03-23 21:27:40', 36.3, '正常', '2026-03-23 21:27:40');
INSERT INTO `health_data_backup_20260323` VALUES (43017, 'DEV002', 93, 121, 79, 99, 3350, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.9, 2.1, 6.8, '良好', '无跌倒', '低', '2026-03-23 21:27:40', 36.4, '正常', '2026-03-23 21:27:40');
INSERT INTO `health_data_backup_20260323` VALUES (43018, 'DEV003', 71, 109, 65, 95, 5084, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.4, 2.3, 4.1, '良好', '无跌倒', '低', '2026-03-23 21:27:40', 36.7, '正常', '2026-03-23 21:27:40');
INSERT INTO `health_data_backup_20260323` VALUES (44016, 'DEV001', 62, 106, 70, 95, 5846, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.2, 5.9, 2.3, '一般', '无跌倒', '低', '2026-03-23 21:27:48', 36.7, '正常', '2026-03-23 21:27:48');
INSERT INTO `health_data_backup_20260323` VALUES (44017, 'DEV002', 88, 96, 66, 96, 3231, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.9, 2.8, 5.1, '一般', '疑似跌倒', '中', '2026-03-23 21:27:48', 37.1, '偏高', '2026-03-23 21:27:48');
INSERT INTO `health_data_backup_20260323` VALUES (44018, 'DEV003', 62, 126, 72, 97, 2629, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.4, 3.6, 4.8, '良好', '疑似跌倒', '低', '2026-03-23 21:27:48', 36.3, '正常', '2026-03-23 21:27:48');
INSERT INTO `health_data_backup_20260323` VALUES (45016, 'DEV001', 87, 112, 77, 99, 1307, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 4.5, 3.1, '一般', '无跌倒', '中', '2026-03-23 21:27:50', 36.3, '正常', '2026-03-23 21:27:50');
INSERT INTO `health_data_backup_20260323` VALUES (45017, 'DEV002', 99, 134, 63, 95, 4898, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.4, 5.6, 1.8, '良好', '无跌倒', '中', '2026-03-23 21:27:50', 36.7, '正常', '2026-03-23 21:27:50');
INSERT INTO `health_data_backup_20260323` VALUES (45018, 'DEV003', 81, 101, 67, 97, 3009, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.7, 4.2, 2.5, '良好', '无跌倒', '低', '2026-03-23 21:27:50', 37.2, '偏高', '2026-03-23 21:27:50');
INSERT INTO `health_data_backup_20260323` VALUES (46016, 'DEV001', 80, 100, 86, 100, 4938, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.8, 3.0, 5.8, '良好', '疑似跌倒', '低', '2026-03-23 21:27:55', 36.6, '正常', '2026-03-23 21:27:55');
INSERT INTO `health_data_backup_20260323` VALUES (46017, 'DEV002', 82, 127, 86, 97, 4835, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.5, 5.6, 2.9, '一般', '无跌倒', '低', '2026-03-23 21:27:55', 36.1, '正常', '2026-03-23 21:27:55');
INSERT INTO `health_data_backup_20260323` VALUES (46018, 'DEV003', 86, 134, 74, 97, 3159, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.1, 5.3, 1.8, '一般', '疑似跌倒', '低', '2026-03-23 21:27:55', 36.4, '正常', '2026-03-23 21:27:55');
INSERT INTO `health_data_backup_20260323` VALUES (47016, 'DEV001', 99, 136, 60, 100, 3866, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.0, 4.7, 2.3, '一般', '疑似跌倒', '低', '2026-03-23 21:28:00', 37.0, '正常', '2026-03-23 21:28:00');
INSERT INTO `health_data_backup_20260323` VALUES (47017, 'DEV002', 84, 104, 85, 98, 1035, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.2, 5.9, 1.3, '一般', '无跌倒', '低', '2026-03-23 21:28:00', 37.0, '正常', '2026-03-23 21:28:00');
INSERT INTO `health_data_backup_20260323` VALUES (47018, 'DEV003', 65, 134, 68, 98, 1302, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.9, 5.4, 1.5, '一般', '无跌倒', '中', '2026-03-23 21:28:00', 36.6, '正常', '2026-03-23 21:28:00');
INSERT INTO `health_data_backup_20260323` VALUES (48016, 'DEV001', 86, 92, 88, 95, 4078, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.2, 4.0, 3.2, '一般', '无跌倒', '低', '2026-03-23 21:28:05', 36.1, '正常', '2026-03-23 21:28:05');
INSERT INTO `health_data_backup_20260323` VALUES (48017, 'DEV002', 89, 130, 79, 97, 1722, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.5, 6.0, 0.5, '良好', '疑似跌倒', '中', '2026-03-23 21:28:05', 36.3, '正常', '2026-03-23 21:28:05');
INSERT INTO `health_data_backup_20260323` VALUES (48018, 'DEV003', 89, 105, 71, 95, 3243, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.0, 3.5, 2.5, '一般', '无跌倒', '低', '2026-03-23 21:28:05', 36.6, '正常', '2026-03-23 21:28:05');
INSERT INTO `health_data_backup_20260323` VALUES (49016, 'DEV001', 85, 119, 79, 96, 3399, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.2, 4.8, 1.4, '良好', '疑似跌倒', '中', '2026-03-23 21:28:10', 36.8, '正常', '2026-03-23 21:28:10');
INSERT INTO `health_data_backup_20260323` VALUES (49017, 'DEV002', 69, 106, 71, 98, 3086, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.3, 2.1, 5.2, '良好', '疑似跌倒', '低', '2026-03-23 21:28:10', 36.6, '正常', '2026-03-23 21:28:10');
INSERT INTO `health_data_backup_20260323` VALUES (49018, 'DEV003', 94, 108, 89, 99, 2864, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.7, 4.8, 2.9, '一般', '无跌倒', '中', '2026-03-23 21:28:10', 36.8, '正常', '2026-03-23 21:28:10');
INSERT INTO `health_data_backup_20260323` VALUES (50016, 'DEV001', 100, 130, 84, 98, 3602, '{\"hourly_heart_rate\": [75,76,74,77]}', 9.0, 2.6, 6.4, '一般', '无跌倒', '中', '2026-03-23 21:28:15', 36.9, '正常', '2026-03-23 21:28:15');
INSERT INTO `health_data_backup_20260323` VALUES (50017, 'DEV002', 75, 137, 86, 99, 1026, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.4, 5.6, 2.8, '一般', '疑似跌倒', '中', '2026-03-23 21:28:15', 36.5, '正常', '2026-03-23 21:28:15');
INSERT INTO `health_data_backup_20260323` VALUES (50018, 'DEV003', 76, 135, 72, 98, 1043, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.3, 5.5, 2.8, '一般', '疑似跌倒', '中', '2026-03-23 21:28:15', 36.4, '正常', '2026-03-23 21:28:15');
INSERT INTO `health_data_backup_20260323` VALUES (51016, 'DEV001', 96, 97, 81, 99, 2745, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 4.2, 3.4, '良好', '疑似跌倒', '中', '2026-03-23 21:28:20', 36.3, '正常', '2026-03-23 21:28:20');
INSERT INTO `health_data_backup_20260323` VALUES (51017, 'DEV002', 65, 126, 73, 100, 3005, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.8, 4.1, 4.7, '一般', '无跌倒', '中', '2026-03-23 21:28:20', 36.5, '正常', '2026-03-23 21:28:20');
INSERT INTO `health_data_backup_20260323` VALUES (51018, 'DEV003', 81, 94, 77, 98, 2826, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.0, 4.4, 3.6, '一般', '疑似跌倒', '低', '2026-03-23 21:28:20', 36.2, '正常', '2026-03-23 21:28:20');
INSERT INTO `health_data_backup_20260323` VALUES (52016, 'DEV001', 71, 91, 88, 100, 5613, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.2, 2.6, 4.6, '一般', '疑似跌倒', '中', '2026-03-23 21:28:25', 36.3, '正常', '2026-03-23 21:28:25');
INSERT INTO `health_data_backup_20260323` VALUES (52017, 'DEV002', 84, 137, 63, 95, 3433, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.4, 4.4, 2.0, '一般', '无跌倒', '中', '2026-03-23 21:28:25', 36.9, '正常', '2026-03-23 21:28:25');
INSERT INTO `health_data_backup_20260323` VALUES (52018, 'DEV003', 62, 116, 74, 96, 4213, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.3, 2.7, 3.6, '一般', '无跌倒', '中', '2026-03-23 21:28:25', 36.2, '正常', '2026-03-23 21:28:25');
INSERT INTO `health_data_backup_20260323` VALUES (53016, 'DEV001', 69, 130, 80, 95, 4413, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.9, 2.9, 4.0, '一般', '无跌倒', '中', '2026-03-23 21:28:30', 36.1, '正常', '2026-03-23 21:28:30');
INSERT INTO `health_data_backup_20260323` VALUES (53017, 'DEV002', 88, 117, 90, 96, 4504, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.2, 3.5, 4.7, '良好', '无跌倒', '低', '2026-03-23 21:28:30', 36.2, '正常', '2026-03-23 21:28:30');
INSERT INTO `health_data_backup_20260323` VALUES (53018, 'DEV003', 83, 120, 65, 97, 3620, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 5.2, 2.4, '良好', '疑似跌倒', '中', '2026-03-23 21:28:30', 36.5, '正常', '2026-03-23 21:28:30');
INSERT INTO `health_data_backup_20260323` VALUES (54016, 'DEV001', 89, 136, 68, 95, 5552, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.2, 5.9, 1.3, '良好', '疑似跌倒', '中', '2026-03-23 21:28:35', 36.4, '正常', '2026-03-23 21:28:35');
INSERT INTO `health_data_backup_20260323` VALUES (54017, 'DEV002', 85, 109, 80, 98, 3477, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 5.7, 1.9, '良好', '无跌倒', '中', '2026-03-23 21:28:35', 36.8, '正常', '2026-03-23 21:28:35');
INSERT INTO `health_data_backup_20260323` VALUES (54018, 'DEV003', 81, 99, 82, 100, 2421, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.5, 4.7, 1.8, '一般', '无跌倒', '低', '2026-03-23 21:28:35', 36.6, '正常', '2026-03-23 21:28:35');
INSERT INTO `health_data_backup_20260323` VALUES (55016, 'DEV001', 73, 91, 79, 95, 2210, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.6, 4.0, 4.6, '良好', '无跌倒', '低', '2026-03-23 21:28:40', 36.8, '正常', '2026-03-23 21:28:40');
INSERT INTO `health_data_backup_20260323` VALUES (55017, 'DEV002', 75, 103, 67, 100, 5213, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.6, 5.6, 1.0, '一般', '疑似跌倒', '中', '2026-03-23 21:28:40', 36.7, '正常', '2026-03-23 21:28:40');
INSERT INTO `health_data_backup_20260323` VALUES (55018, 'DEV003', 61, 102, 68, 99, 3824, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.0, 4.7, 2.3, '一般', '疑似跌倒', '低', '2026-03-23 21:28:40', 36.7, '正常', '2026-03-23 21:28:40');
INSERT INTO `health_data_backup_20260323` VALUES (56016, 'DEV001', 87, 111, 70, 97, 3166, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.3, 4.1, 2.2, '一般', '疑似跌倒', '中', '2026-03-23 21:28:45', 36.8, '正常', '2026-03-23 21:28:45');
INSERT INTO `health_data_backup_20260323` VALUES (56017, 'DEV002', 77, 92, 81, 97, 3232, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 3.5, 4.1, '良好', '无跌倒', '中', '2026-03-23 21:28:45', 36.5, '正常', '2026-03-23 21:28:45');
INSERT INTO `health_data_backup_20260323` VALUES (56018, 'DEV003', 75, 121, 82, 97, 2519, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.9, 4.3, 2.6, '一般', '无跌倒', '低', '2026-03-23 21:28:45', 36.2, '正常', '2026-03-23 21:28:45');
INSERT INTO `health_data_backup_20260323` VALUES (57016, 'DEV001', 85, 140, 88, 97, 4284, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.9, 2.5, 6.4, '一般', '疑似跌倒', '中', '2026-03-23 21:28:50', 36.9, '正常', '2026-03-23 21:28:50');
INSERT INTO `health_data_backup_20260323` VALUES (57017, 'DEV002', 70, 133, 67, 96, 3631, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.1, 2.6, 3.5, '一般', '疑似跌倒', '中', '2026-03-23 21:28:50', 36.1, '正常', '2026-03-23 21:28:50');
INSERT INTO `health_data_backup_20260323` VALUES (57018, 'DEV003', 91, 138, 64, 95, 5448, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.5, 4.5, 4.0, '良好', '无跌倒', '中', '2026-03-23 21:28:50', 36.6, '正常', '2026-03-23 21:28:50');
INSERT INTO `health_data_backup_20260323` VALUES (58016, 'DEV001', 64, 101, 87, 95, 4551, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.1, 2.3, 4.8, '一般', '无跌倒', '中', '2026-03-23 21:28:55', 36.5, '正常', '2026-03-23 21:28:55');
INSERT INTO `health_data_backup_20260323` VALUES (58017, 'DEV002', 99, 119, 79, 99, 2059, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.1, 3.6, 3.5, '一般', '无跌倒', '中', '2026-03-23 21:28:55', 36.0, '正常', '2026-03-23 21:28:55');
INSERT INTO `health_data_backup_20260323` VALUES (58018, 'DEV003', 87, 111, 68, 96, 4633, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.2, 5.4, 0.8, '一般', '疑似跌倒', '中', '2026-03-23 21:28:55', 36.9, '正常', '2026-03-23 21:28:55');
INSERT INTO `health_data_backup_20260323` VALUES (59016, 'DEV001', 65, 124, 74, 98, 1339, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.5, 4.5, 4.0, '一般', '无跌倒', '低', '2026-03-23 21:29:00', 36.9, '正常', '2026-03-23 21:29:00');
INSERT INTO `health_data_backup_20260323` VALUES (59017, 'DEV002', 64, 124, 71, 96, 3214, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.6, 5.9, 0.7, '一般', '无跌倒', '中', '2026-03-23 21:29:00', 36.3, '正常', '2026-03-23 21:29:00');
INSERT INTO `health_data_backup_20260323` VALUES (59018, 'DEV003', 74, 109, 88, 98, 3467, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.1, 4.9, 3.2, '一般', '无跌倒', '低', '2026-03-23 21:29:00', 36.1, '正常', '2026-03-23 21:29:00');
INSERT INTO `health_data_backup_20260323` VALUES (60016, 'DEV001', 75, 123, 72, 98, 3397, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.9, 5.2, 2.7, '一般', '无跌倒', '低', '2026-03-23 21:29:05', 36.2, '正常', '2026-03-23 21:29:05');
INSERT INTO `health_data_backup_20260323` VALUES (60017, 'DEV002', 99, 96, 78, 97, 5771, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.4, 3.9, 4.5, '良好', '无跌倒', '中', '2026-03-23 21:29:05', 36.6, '正常', '2026-03-23 21:29:05');
INSERT INTO `health_data_backup_20260323` VALUES (60018, 'DEV003', 74, 109, 64, 99, 1128, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.5, 5.4, 1.1, '一般', '无跌倒', '中', '2026-03-23 21:29:05', 36.4, '正常', '2026-03-23 21:29:05');
INSERT INTO `health_data_backup_20260323` VALUES (61016, 'DEV001', 96, 93, 67, 99, 5781, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.5, 5.6, 1.9, '良好', '疑似跌倒', '低', '2026-03-23 21:29:10', 37.1, '偏高', '2026-03-23 21:29:10');
INSERT INTO `health_data_backup_20260323` VALUES (61017, 'DEV002', 77, 97, 85, 98, 3215, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.7, 3.7, 5.0, '良好', '疑似跌倒', '低', '2026-03-23 21:29:10', 36.3, '正常', '2026-03-23 21:29:10');
INSERT INTO `health_data_backup_20260323` VALUES (61018, 'DEV003', 80, 96, 62, 96, 4325, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.6, 2.2, 4.4, '良好', '疑似跌倒', '中', '2026-03-23 21:29:10', 37.1, '偏高', '2026-03-23 21:29:10');
INSERT INTO `health_data_backup_20260323` VALUES (62016, 'DEV001', 91, 135, 66, 99, 3458, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.9, 3.7, 3.2, '一般', '疑似跌倒', '低', '2026-03-23 21:29:15', 36.9, '正常', '2026-03-23 21:29:15');
INSERT INTO `health_data_backup_20260323` VALUES (62017, 'DEV002', 60, 121, 67, 98, 2237, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.6, 2.3, 6.3, '一般', '疑似跌倒', '中', '2026-03-23 21:29:15', 37.1, '偏高', '2026-03-23 21:29:15');
INSERT INTO `health_data_backup_20260323` VALUES (62018, 'DEV003', 96, 119, 76, 97, 1909, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 2.9, 4.7, '一般', '疑似跌倒', '低', '2026-03-23 21:29:15', 37.2, '偏高', '2026-03-23 21:29:15');
INSERT INTO `health_data_backup_20260323` VALUES (63016, 'DEV001', 92, 129, 84, 100, 1193, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.8, 2.4, 4.4, '一般', '疑似跌倒', '低', '2026-03-23 21:29:20', 37.1, '偏高', '2026-03-23 21:29:20');
INSERT INTO `health_data_backup_20260323` VALUES (63017, 'DEV002', 77, 109, 71, 97, 5458, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.5, 4.9, 3.6, '一般', '无跌倒', '中', '2026-03-23 21:29:20', 36.9, '正常', '2026-03-23 21:29:20');
INSERT INTO `health_data_backup_20260323` VALUES (63018, 'DEV003', 63, 136, 69, 97, 4554, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.1, 3.2, 4.9, '良好', '无跌倒', '低', '2026-03-23 21:29:20', 37.1, '偏高', '2026-03-23 21:29:20');
INSERT INTO `health_data_backup_20260323` VALUES (64016, 'DEV001', 74, 133, 71, 97, 4090, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.8, 3.8, 3.0, '良好', '疑似跌倒', '低', '2026-03-23 21:29:25', 36.8, '正常', '2026-03-23 21:29:25');
INSERT INTO `health_data_backup_20260323` VALUES (64017, 'DEV002', 84, 119, 79, 100, 4591, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.3, 4.2, 2.1, '一般', '无跌倒', '中', '2026-03-23 21:29:25', 36.5, '正常', '2026-03-23 21:29:25');
INSERT INTO `health_data_backup_20260323` VALUES (64018, 'DEV003', 100, 100, 64, 98, 4568, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.4, 5.7, 1.7, '一般', '疑似跌倒', '中', '2026-03-23 21:29:25', 36.2, '正常', '2026-03-23 21:29:25');
INSERT INTO `health_data_backup_20260323` VALUES (65016, 'DEV001', 99, 127, 88, 98, 4995, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.2, 5.5, 0.7, '一般', '疑似跌倒', '中', '2026-03-23 21:29:30', 36.9, '正常', '2026-03-23 21:29:30');
INSERT INTO `health_data_backup_20260323` VALUES (65017, 'DEV002', 83, 103, 79, 95, 3696, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.4, 2.6, 3.8, '一般', '疑似跌倒', '中', '2026-03-23 21:29:30', 36.0, '正常', '2026-03-23 21:29:30');
INSERT INTO `health_data_backup_20260323` VALUES (65018, 'DEV003', 77, 117, 62, 96, 4884, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.0, 3.9, 4.1, '良好', '疑似跌倒', '中', '2026-03-23 21:29:30', 37.1, '偏高', '2026-03-23 21:29:30');
INSERT INTO `health_data_backup_20260323` VALUES (66016, 'DEV001', 76, 106, 71, 99, 1629, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.0, 5.6, 1.4, '一般', '无跌倒', '中', '2026-03-23 21:29:35', 36.9, '正常', '2026-03-23 21:29:35');
INSERT INTO `health_data_backup_20260323` VALUES (66017, 'DEV002', 67, 131, 79, 98, 1792, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.1, 4.1, 2.0, '良好', '无跌倒', '低', '2026-03-23 21:29:35', 36.4, '正常', '2026-03-23 21:29:35');
INSERT INTO `health_data_backup_20260323` VALUES (66018, 'DEV003', 89, 111, 69, 97, 4928, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.3, 4.7, 3.6, '一般', '无跌倒', '中', '2026-03-23 21:29:35', 36.4, '正常', '2026-03-23 21:29:35');
INSERT INTO `health_data_backup_20260323` VALUES (67016, 'DEV001', 64, 115, 64, 97, 5136, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.8, 4.3, 2.5, '一般', '无跌倒', '中', '2026-03-23 21:29:40', 36.5, '正常', '2026-03-23 21:29:40');
INSERT INTO `health_data_backup_20260323` VALUES (67017, 'DEV002', 92, 101, 79, 97, 5321, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.9, 3.9, 3.0, '良好', '疑似跌倒', '中', '2026-03-23 21:29:40', 36.1, '正常', '2026-03-23 21:29:40');
INSERT INTO `health_data_backup_20260323` VALUES (67018, 'DEV003', 67, 134, 67, 100, 4699, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.7, 4.3, 3.4, '良好', '疑似跌倒', '中', '2026-03-23 21:29:40', 36.0, '正常', '2026-03-23 21:29:40');
INSERT INTO `health_data_backup_20260323` VALUES (68016, 'DEV001', 82, 130, 70, 95, 1835, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.2, 2.5, 5.7, '良好', '无跌倒', '低', '2026-03-23 21:29:45', 36.5, '正常', '2026-03-23 21:29:45');
INSERT INTO `health_data_backup_20260323` VALUES (68017, 'DEV002', 84, 98, 88, 95, 3570, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.9, 5.9, 1.0, '一般', '无跌倒', '中', '2026-03-23 21:29:45', 36.5, '正常', '2026-03-23 21:29:45');
INSERT INTO `health_data_backup_20260323` VALUES (68018, 'DEV003', 66, 97, 71, 97, 1600, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.8, 3.4, 4.4, '良好', '无跌倒', '中', '2026-03-23 21:29:45', 36.8, '正常', '2026-03-23 21:29:45');
INSERT INTO `health_data_backup_20260323` VALUES (69016, 'DEV001', 66, 131, 61, 100, 1642, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.1, 2.4, 3.7, '良好', '无跌倒', '低', '2026-03-23 21:29:50', 36.8, '正常', '2026-03-23 21:29:50');
INSERT INTO `health_data_backup_20260323` VALUES (69017, 'DEV002', 85, 110, 69, 100, 1471, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.5, 3.6, 3.9, '一般', '疑似跌倒', '中', '2026-03-23 21:29:50', 37.2, '偏高', '2026-03-23 21:29:50');
INSERT INTO `health_data_backup_20260323` VALUES (69018, 'DEV003', 60, 117, 90, 97, 2015, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.0, 3.1, 4.9, '一般', '无跌倒', '低', '2026-03-23 21:29:50', 36.9, '正常', '2026-03-23 21:29:50');
INSERT INTO `health_data_backup_20260323` VALUES (70016, 'DEV001', 71, 134, 63, 100, 1895, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.0, 3.4, 3.6, '良好', '疑似跌倒', '中', '2026-03-23 21:29:55', 36.2, '正常', '2026-03-23 21:29:55');
INSERT INTO `health_data_backup_20260323` VALUES (70017, 'DEV002', 86, 134, 88, 99, 4191, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.6, 5.3, 3.3, '良好', '疑似跌倒', '中', '2026-03-23 21:29:55', 36.4, '正常', '2026-03-23 21:29:55');
INSERT INTO `health_data_backup_20260323` VALUES (70018, 'DEV003', 97, 108, 66, 100, 3873, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.2, 4.8, 2.4, '良好', '疑似跌倒', '中', '2026-03-23 21:29:55', 36.5, '正常', '2026-03-23 21:29:55');
INSERT INTO `health_data_backup_20260323` VALUES (71016, 'DEV001', 72, 112, 68, 99, 2046, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.4, 5.4, 1.0, '良好', '无跌倒', '中', '2026-03-23 21:30:00', 37.1, '偏高', '2026-03-23 21:30:00');
INSERT INTO `health_data_backup_20260323` VALUES (71017, 'DEV002', 63, 99, 84, 95, 5662, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.2, 5.3, 0.9, '一般', '无跌倒', '中', '2026-03-23 21:30:00', 36.2, '正常', '2026-03-23 21:30:00');
INSERT INTO `health_data_backup_20260323` VALUES (71018, 'DEV003', 97, 112, 79, 96, 5055, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.9, 2.8, 6.1, '良好', '疑似跌倒', '低', '2026-03-23 21:30:00', 36.6, '正常', '2026-03-23 21:30:00');
INSERT INTO `health_data_backup_20260323` VALUES (72016, 'DEV001', 95, 105, 62, 95, 2188, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.9, 4.1, 3.8, '良好', '无跌倒', '低', '2026-03-23 21:30:05', 37.1, '偏高', '2026-03-23 21:30:05');
INSERT INTO `health_data_backup_20260323` VALUES (72017, 'DEV002', 62, 122, 75, 95, 4164, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.2, 2.3, 3.9, '一般', '无跌倒', '中', '2026-03-23 21:30:05', 36.8, '正常', '2026-03-23 21:30:05');
INSERT INTO `health_data_backup_20260323` VALUES (72018, 'DEV003', 81, 124, 85, 98, 1933, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.6, 5.5, 1.1, '良好', '疑似跌倒', '中', '2026-03-23 21:30:05', 36.6, '正常', '2026-03-23 21:30:05');
INSERT INTO `health_data_backup_20260323` VALUES (73016, 'DEV001', 82, 109, 87, 98, 3294, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 4.7, 2.9, '良好', '疑似跌倒', '中', '2026-03-23 21:30:10', 36.2, '正常', '2026-03-23 21:30:10');
INSERT INTO `health_data_backup_20260323` VALUES (73017, 'DEV002', 83, 122, 84, 98, 4472, '{\"hourly_heart_rate\": [75,76,74,77]}', 7.6, 3.6, 4.0, '一般', '疑似跌倒', '低', '2026-03-23 21:30:10', 36.1, '正常', '2026-03-23 21:30:10');
INSERT INTO `health_data_backup_20260323` VALUES (73018, 'DEV003', 64, 121, 73, 97, 3386, '{\"hourly_heart_rate\": [75,76,74,77]}', 8.1, 5.6, 2.5, '良好', '无跌倒', '中', '2026-03-23 21:30:10', 36.5, '正常', '2026-03-23 21:30:10');
INSERT INTO `health_data_backup_20260323` VALUES (74016, 'DEV001', 75, 131, 89, 97, 5409, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.6, 5.1, 1.5, '良好', '无跌倒', '中', '2026-03-23 21:35:52', 36.6, '正常', '2026-03-23 21:35:52');
INSERT INTO `health_data_backup_20260323` VALUES (74017, 'DEV002', 74, 93, 72, 100, 1165, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.4, 3.3, 3.1, '良好', '疑似跌倒', '低', '2026-03-23 21:35:52', 36.5, '正常', '2026-03-23 21:35:52');
INSERT INTO `health_data_backup_20260323` VALUES (74018, 'DEV003', 73, 92, 80, 96, 2177, '{\"hourly_heart_rate\": [75,76,74,77]}', 6.3, 4.6, 1.7, '良好', '无跌倒', '低', '2026-03-23 21:35:52', 36.9, '正常', '2026-03-23 21:35:52');

-- ----------------------------
-- Table structure for user_device
-- ----------------------------
DROP TABLE IF EXISTS `user_device`;
CREATE TABLE `user_device`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `device_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `age` int(11) NULL DEFAULT 0,
  `gender` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `device_id`(`device_id`) USING BTREE,
  INDEX `idx_device_id`(`device_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_device
-- ----------------------------
INSERT INTO `user_device` VALUES (9, 'DEV003', '123456', '王五', '2026-03-21 21:22:42', 70, '男');
INSERT INTO `user_device` VALUES (8, 'DEV002', '123456', '李四', '2026-03-21 21:22:42', 68, '女');
INSERT INTO `user_device` VALUES (7, 'DEV001', '123456', '张三', '2026-03-21 21:22:42', 65, '男');

SET FOREIGN_KEY_CHECKS = 1;
