/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50018
Source Host           : localhost:3306
Source Database       : libereye2

Target Server Type    : MYSQL
Target Server Version : 50018
File Encoding         : 65001

Date: 2015-12-09 14:10:49
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for account
-- ----------------------------
DROP TABLE IF EXISTS `account`;
CREATE TABLE `account` (
  `account_id` int(11) NOT NULL auto_increment,
  `shop_id` int(11) default NULL,
  `email` varchar(100) NOT NULL default '',
  `pass` varchar(32) NOT NULL default '',
  `fname` varchar(50) NOT NULL default '',
  `delivery_name` varchar(255) NOT NULL default '',
  `address` varchar(255) NOT NULL,
  `country_id` int(11) NOT NULL,
  `city` varchar(50) NOT NULL,
  `street` varchar(50) NOT NULL,
  `building` varchar(20) NOT NULL,
  `apartment` varchar(10) NOT NULL,
  `comment` varchar(255) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `timezone_id` int(11) default NULL,
  `status` enum('client','seller','admin') NOT NULL default 'admin',
  `cdate` datetime NOT NULL default '0000-00-00 00:00:00',
  `last_login` datetime NOT NULL,
  `zoom_id` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `is_active` tinyint(4) NOT NULL,
  `confirm_code` varchar(32) NOT NULL,
  `confirm_date` datetime NOT NULL,
  PRIMARY KEY  (`account_id`),
  UNIQUE KEY `email` (`email`),
  KEY `zoom_id` (`zoom_id`),
  KEY `country_id` (`country_id`),
  KEY `shop_id` (`shop_id`),
  KEY `timezone_id` (`timezone_id`),
  CONSTRAINT `account_ibfk_1` FOREIGN KEY (`timezone_id`) REFERENCES `timezone` (`timezone_id`),
  CONSTRAINT `country_id` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`),
  CONSTRAINT `shop_id` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Таблица для пользователей сайта';

-- ----------------------------
-- Records of account
-- ----------------------------
INSERT INTO `account` VALUES ('6', '1', 'admin@libereye.com', '96e79218965eb72c92a549dd5a330112', 'admin', '', 'R', '1', '', '', '', '', '', '+12345678', null, 'admin', '2007-04-07 21:40:00', '2015-09-17 13:24:11', 'sk3Jh24RSUC6ed9Lr11SXw', '', '0', '', '0000-00-00 00:00:00');
INSERT INTO `account` VALUES ('20', '1', 'rudserg@tut.by', '96e79218965eb72c92a549dd5a330112', 'Продавец №1', '!', 'Дубай', '1', '', '', '', '', '', '+375297711394', null, 'seller', '2015-08-15 16:41:20', '2015-11-19 19:37:28', 'wEeMIWpXQsitCGb-WlFLPg', '<p><em><strong>&nbsp;Продавец&nbsp;-&nbsp;консультант Versace&nbsp;Collection</strong></em></p>', '0', '', '0000-00-00 00:00:00');
INSERT INTO `account` VALUES ('23', '1', 'paouccello@gmail.com', '09aa8e3fce9a92ccc8f58cd34e87b325', 'Клиент', '', 'Минск, ул. Ленина 1', '1', '', '', '', '', '', '+23423234', null, 'client', '2015-08-15 20:58:20', '2015-09-10 20:16:46', 'QWzkOYNCTrWmrOWWfWD3ew', '', '0', '', '0000-00-00 00:00:00');
INSERT INTO `account` VALUES ('24', '1', 'rudsed@sfdsfsd.df', '96e79218965eb72c92a549dd5a330112', 'дло', 'дло', 'Дубай', '1', '', '', '', '', '', '111111', null, 'client', '2015-09-08 12:34:56', '0000-00-00 00:00:00', '', '', '0', '', '0000-00-00 00:00:00');
INSERT INTO `account` VALUES ('25', '1', 'rudsedee@sfdsfsd.df', '96e79218965eb72c92a549dd5a330112', 'дло', 'дло', 'Дубай', '1', '', '', '', '', '', '111111', null, 'client', '2015-09-08 12:36:35', '0000-00-00 00:00:00', '', '', '0', '', '0000-00-00 00:00:00');
INSERT INTO `account` VALUES ('26', '1', 'rudsedddee@sfdsfsd.df', '96e79218965eb72c92a549dd5a330112', 'дло', 'дло', 'Дубай', '1', '', '', '', '', '', '111111', null, 'client', '2015-09-08 12:37:06', '0000-00-00 00:00:00', '', '', '0', '', '0000-00-00 00:00:00');

-- ----------------------------
-- Table structure for booking
-- ----------------------------
DROP TABLE IF EXISTS `booking`;
CREATE TABLE `booking` (
  `booking_id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL,
  `seller_id` int(11) NOT NULL,
  `fromdate` datetime NOT NULL,
  `todate` datetime NOT NULL,
  `description` text NOT NULL,
  `status` enum('pending','confirm','cancelled') NOT NULL,
  `cdate` datetime NOT NULL,
  `udate` datetime NOT NULL,
  `zoom_id` varchar(50) NOT NULL,
  `zoom_start_url` text NOT NULL,
  `zoom_join_url` varchar(50) NOT NULL,
  `ip` varchar(15) NOT NULL,
  PRIMARY KEY  (`booking_id`),
  KEY `account_id` (`account_id`),
  KEY `seller_id` (`seller_id`),
  CONSTRAINT `account_id` FOREIGN KEY (`account_id`) REFERENCES `account` (`account_id`),
  CONSTRAINT `seller_id` FOREIGN KEY (`seller_id`) REFERENCES `account` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Таблица бронирования времени';

-- ----------------------------
-- Records of booking
-- ----------------------------
INSERT INTO `booking` VALUES ('57', '23', '20', '2015-08-16 09:00:00', '2015-08-16 09:30:00', '', 'pending', '2015-08-15 21:59:25', '2015-08-15 21:59:25', '141660314', 'https://api.zoom.us/s/141660314?zpk=o6U-p-u8AsOXwADo-KMRpAw0Z6UQeJm4uUBn2UT-2Yk.AwYkMjkwMzNjZWUtYjU0My00ZGEwLThmNDAtY2FhMmRjMjhkMDNjFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB', 'https://api.zoom.us/j/141660314', '');
INSERT INTO `booking` VALUES ('58', '23', '20', '2015-08-16 09:30:00', '2015-08-16 10:00:00', '', 'pending', '2015-08-15 22:05:18', '2015-08-15 22:05:18', '611635480', 'https://api.zoom.us/s/611635480?zpk=uJciaH2Mri4BGmZBg6xK-_Fkzl_7v8y7QMCfyiZFjhg.AwYkMDNhNWUzMWYtODRlZS00YzExLWIyYTktZjNlOTIxOWRkYWM0FndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB', 'https://api.zoom.us/j/611635480', '');
INSERT INTO `booking` VALUES ('62', '23', '20', '2015-08-16 15:30:00', '2015-08-16 16:00:00', '', 'pending', '2015-08-16 13:34:09', '2015-08-16 13:34:09', '250587742', 'https://api.zoom.us/s/250587742?zpk=ZQLQvazHJPQyI3S2XOLJeCmUPsxiu5z3spf6enlpP9A.AwYkNGU1YzQzZDMtMmY1OS00YjI1LTk2MzQtNThkNThmNDMxY2I5FndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB', 'https://api.zoom.us/j/250587742', '');
INSERT INTO `booking` VALUES ('65', '23', '20', '2015-08-18 10:30:00', '2015-08-18 11:00:00', '', 'pending', '2015-08-17 17:35:31', '2015-08-17 17:35:31', '737591994', 'https://api.zoom.us/s/737591994?zpk=jNDvEAPrlsCtfREJdmjKEAoNNO8VLwH9y1oUkTMbLws.AwYkYTUwNDQ4YTgtMDk4My00YzJkLWE0YjAtMDM4Zjk4N2U2NTExFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB', 'https://api.zoom.us/j/737591994', '');
INSERT INTO `booking` VALUES ('66', '23', '20', '2015-08-19 15:30:00', '2015-08-19 16:00:00', '', 'pending', '2015-08-17 22:35:57', '2015-08-17 22:35:57', '204342116', 'https://api.zoom.us/s/204342116?zpk=L7GA-eaazck49jvB1Eqq7oPDQecshdHEMEKKkmrKxqo.AwYkY2U0ZjdhMWMtOWZlMC00YTc0LWJkM2YtYjI1MzI1MjA4Y2ExFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB', 'https://api.zoom.us/j/204342116', '');
INSERT INTO `booking` VALUES ('67', '23', '20', '2015-08-21 10:30:00', '2015-08-21 11:00:00', '', 'pending', '2015-08-18 01:40:15', '2015-08-18 01:40:15', '664866602', 'https://api.zoom.us/s/664866602?zpk=l5eoKFuOAHdmN1wh3ObjHkBu_3k1-5WPNKRrwY6uPMY.AwYkZjJlMjIyNzItNTA5Mi00MjVlLWI3ZmQtYTNmMzNjODE0N2ZkFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB', 'https://api.zoom.us/j/664866602', '');
INSERT INTO `booking` VALUES ('69', '23', '20', '2015-08-23 11:00:00', '2015-08-23 11:30:00', '', 'pending', '2015-08-18 01:40:25', '2015-08-18 01:40:25', '714422916', 'https://api.zoom.us/s/714422916?zpk=wmHqjqTfpwFKS2CsPATiMyEdSFz0tyYrNxE_YktmJrc.AwYkOGU4MjkyNGQtZTRjNC00Yjg0LTk0OTAtODgxYzcyYzE5MGJjFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB', 'https://api.zoom.us/j/714422916', '');
INSERT INTO `booking` VALUES ('70', '23', '20', '2015-08-21 09:30:00', '2015-08-21 10:00:00', '', 'pending', '2015-08-20 15:37:38', '2015-08-20 15:37:38', '961460875', 'https://libereye.zoom.us/s/961460875?zpk=YwgEupL8JbFcik455Sinz265Nqr4lTWsRSLrb1_immQ.AwYkYzE3ZGNhYzktZWJiNC00ZTMzLTgwNDItMGEyODliNDM5NTQwFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB', 'https://libereye.zoom.us/j/961460875', '');
INSERT INTO `booking` VALUES ('71', '23', '20', '2015-08-21 09:00:00', '2015-08-21 09:30:00', '', 'pending', '2015-08-20 15:43:43', '2015-08-20 15:43:43', '843360256', 'https://libereye.zoom.us/s/843360256?zpk=ZcjH2AhFBfqUI9aCYJZvdn8hG60gecfUFOSkfLfr7Qw.AwYkMzljYmI4NTYtZWI3Yi00NTdjLWI1ZjYtNjI0MDAxN2E4NGNjFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB', 'https://libereye.zoom.us/j/843360256', '');
INSERT INTO `booking` VALUES ('72', '23', '20', '2015-08-21 11:00:00', '2015-08-21 11:30:00', 'Хочу армани!', 'pending', '2015-08-20 15:44:29', '2015-08-20 15:44:29', '414477283', 'https://libereye.zoom.us/s/414477283?zpk=_TkPDhZsi5kMSBkrVpjlyRzoQQTSd4_Snsva9-EAM4U.AwYkNzM0Y2U0M2QtZDkzYi00ZTExLWIzN2EtNDJjNmFhMTM1N2JjFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB', 'https://libereye.zoom.us/j/414477283', '');
INSERT INTO `booking` VALUES ('73', '23', '20', '2015-08-21 12:00:00', '2015-08-21 12:30:00', 'Не знаю, но хочу заценить \"бббб\" </script>', 'pending', '2015-08-20 16:00:21', '2015-08-20 16:00:21', '780402473', 'https://libereye.zoom.us/s/780402473?zpk=OVk2dM-XdBVn8QpmlP3hUEDS0K8b_U6HQb9gvrGZCDM.AwYkZjNmYTYzNjMtNDg5Yi00OTBlLTgxMWItNzMwNzEwMWQ0ZjAyFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB', 'https://libereye.zoom.us/j/780402473', '');
INSERT INTO `booking` VALUES ('74', '23', '20', '2015-08-21 14:30:00', '2015-08-21 15:00:00', '<h1>ГЫВЫВЫВЫВ</h1>', 'pending', '2015-08-20 16:02:45', '2015-08-20 16:02:45', '677100381', 'https://libereye.zoom.us/s/677100381?zpk=uY29_aBrm2YU3MwF1Ka2n6unQqyytYlu3LIq10P9AZA.AwYkZTMyNmQ0MGMtNjg1Yy00YjQ5LTg3ZTYtM2ExNDI0NjRjMmRhFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB', 'https://libereye.zoom.us/j/677100381', '');
INSERT INTO `booking` VALUES ('75', '23', '20', '2015-09-12 15:00:00', '2015-09-12 15:30:00', '', 'pending', '2015-09-10 21:58:29', '2015-09-10 21:58:29', '100746364', 'https://libereye.zoom.us/s/100746364?zpk=MeIqCpKa8oWcTKRWGmuUuZIeB1C88PqaRC4JwwRFSsw.AwYkY2RhOGYwZjctNzdiOS00NThmLWE2ODgtZjhmOGRlNmYxN2E1FndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB', 'https://libereye.zoom.us/j/100746364', '127.0.0.1');

-- ----------------------------
-- Table structure for brand
-- ----------------------------
DROP TABLE IF EXISTS `brand`;
CREATE TABLE `brand` (
  `brand_id` int(11) NOT NULL auto_increment,
  `image_id` int(11) default NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY  (`brand_id`),
  KEY `image_id` (`image_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Таблица брендов';

-- ----------------------------
-- Records of brand
-- ----------------------------
INSERT INTO `brand` VALUES ('1', null, 'A TESTONI', '');
INSERT INTO `brand` VALUES ('2', null, 'ABSOLUMENT MAISON', '');
INSERT INTO `brand` VALUES ('3', null, 'ABSORBA', '');
INSERT INTO `brand` VALUES ('4', null, 'ACCESSOIRE DIFFUSION', '');
INSERT INTO `brand` VALUES ('5', null, 'ACNÉ', '');
INSERT INTO `brand` VALUES ('6', null, 'ACQUA DI PARMA', '');
INSERT INTO `brand` VALUES ('7', null, 'ADIDAS', '');
INSERT INTO `brand` VALUES ('8', null, 'AESOP', '');
INSERT INTO `brand` VALUES ('9', null, 'AGATHA', '');
INSERT INTO `brand` VALUES ('10', null, 'AGENT PROVOCATEUR', '');
INSERT INTO `brand` VALUES ('11', null, 'AGNÈS B', '');
INSERT INTO `brand` VALUES ('12', null, 'AIGLE', '');
INSERT INTO `brand` VALUES ('13', null, 'ALADIN', '');
INSERT INTO `brand` VALUES ('14', null, 'ALAÏA', '');
INSERT INTO `brand` VALUES ('15', null, 'ALAIN FIGARET', '');
INSERT INTO `brand` VALUES ('16', null, 'ALBERTINE', '');
INSERT INTO `brand` VALUES ('17', null, 'ALDO CHAUSSURES', '');
INSERT INTO `brand` VALUES ('18', null, 'ALESSI', '');
INSERT INTO `brand` VALUES ('19', null, 'ALEXANDER MCQUEEN', '');
INSERT INTO `brand` VALUES ('20', null, 'ALEXANDER WANG', '');
INSERT INTO `brand` VALUES ('21', null, 'ALEXANDRE DE PARIS', '');
INSERT INTO `brand` VALUES ('22', null, 'ALICE & OLIVIA', '');
INSERT INTO `brand` VALUES ('23', null, 'AM-PM', '');
INSERT INTO `brand` VALUES ('24', null, 'AMERICAN APPAREL', '');
INSERT INTO `brand` VALUES ('25', null, 'AMERICAN RÉTRO', '');
INSERT INTO `brand` VALUES ('26', null, 'AMERICAN VINTAGE', '');
INSERT INTO `brand` VALUES ('27', null, 'AMI', '');
INSERT INTO `brand` VALUES ('28', null, 'ANAPLUSH / WWF', '');
INSERT INTO `brand` VALUES ('29', null, 'ANDRÉ', '');
INSERT INTO `brand` VALUES ('30', null, 'ANN DEMEULEMEESTER', '');
INSERT INTO `brand` VALUES ('31', null, 'ANNE DE SOLÈNE', '');
INSERT INTO `brand` VALUES ('32', null, 'ANNE FONTAINE', '');
INSERT INTO `brand` VALUES ('33', null, 'ANNICK GOUTAL', '');
INSERT INTO `brand` VALUES ('34', null, 'ANTHROPOLOGIE', '');
INSERT INTO `brand` VALUES ('35', null, 'AOKI', '');
INSERT INTO `brand` VALUES ('36', null, 'APC', '');
INSERT INTO `brand` VALUES ('37', null, 'APM MONACO', '');
INSERT INTO `brand` VALUES ('38', null, 'APPLE', '');
INSERT INTO `brand` VALUES ('39', null, 'ARC’TERYX', '');
INSERT INTO `brand` VALUES ('40', null, 'ARCHE', '');
INSERT INTO `brand` VALUES ('41', null, 'ARCHIMÈDE', '');
INSERT INTO `brand` VALUES ('42', null, 'ARENA', '');
INSERT INTO `brand` VALUES ('43', null, 'ARMANI', '');
INSERT INTO `brand` VALUES ('44', null, 'ARMANI COLLEZIONI', '');
INSERT INTO `brand` VALUES ('45', null, 'ARMANI JEANS', '');
INSERT INTO `brand` VALUES ('46', null, 'ARMOR LUX', '');
INSERT INTO `brand` VALUES ('47', null, 'ARROW', '');
INSERT INTO `brand` VALUES ('48', null, 'ARTHUR', '');
INSERT INTO `brand` VALUES ('49', null, 'ARTHUR & ASTON', '');
INSERT INTO `brand` VALUES ('50', null, 'ASA', '');
INSERT INTO `brand` VALUES ('51', null, 'ASH', '');
INSERT INTO `brand` VALUES ('52', null, 'ATELIER COLOGNE', '');
INSERT INTO `brand` VALUES ('53', null, 'ATELIER DU VIN', '');
INSERT INTO `brand` VALUES ('54', null, 'ATELIER MERCADAL', '');
INSERT INTO `brand` VALUES ('55', null, 'AUBADE', '');
INSERT INTO `brand` VALUES ('56', null, 'AUBECQ', '');
INSERT INTO `brand` VALUES ('57', null, 'AURA', '');
INSERT INTO `brand` VALUES ('58', null, 'AVANT PREMIÈRE', '');
INSERT INTO `brand` VALUES ('59', null, 'AVRIL GAU', '');
INSERT INTO `brand` VALUES ('60', null, 'AZZARO', '');
INSERT INTO `brand` VALUES ('61', null, 'BA&SH', '');
INSERT INTO `brand` VALUES ('62', null, 'BABY BJORN', '');
INSERT INTO `brand` VALUES ('63', null, 'BACCARAT', '');
INSERT INTO `brand` VALUES ('64', null, 'BAIN', '');
INSERT INTO `brand` VALUES ('65', null, 'BALA', '');
INSERT INTO `brand` VALUES ('66', null, 'BOOSTÉ', '');
INSERT INTO `brand` VALUES ('67', null, 'BALENCIAGA', '');
INSERT INTO `brand` VALUES ('68', null, 'BALIBARIS', '');
INSERT INTO `brand` VALUES ('69', null, 'BALLY', '');
INSERT INTO `brand` VALUES ('70', null, 'BANANA MOON', '');
INSERT INTO `brand` VALUES ('71', null, 'BARBARA RIHL', '');
INSERT INTO `brand` VALUES ('72', null, 'BARBOUR', '');
INSERT INTO `brand` VALUES ('73', null, 'BARONS PAPILLOM', '');
INSERT INTO `brand` VALUES ('74', null, 'BATH', '');
INSERT INTO `brand` VALUES ('75', null, 'BAZAAR', '');
INSERT INTO `brand` VALUES ('76', null, 'BAUME & MERCIER', '');
INSERT INTO `brand` VALUES ('77', null, 'BEABA', '');
INSERT INTO `brand` VALUES ('78', null, 'BELL & ROSS', '');
INSERT INTO `brand` VALUES ('79', null, 'BEN SHERMAN', '');
INSERT INTO `brand` VALUES ('80', null, 'BÉRÉNICE', '');
INSERT INTO `brand` VALUES ('81', null, 'BERNARDAUD', '');
INSERT INTO `brand` VALUES ('82', null, 'BIALETTI', '');
INSERT INTO `brand` VALUES ('83', null, 'BIKINI BAR', '');
INSERT INTO `brand` VALUES ('84', null, 'BILL TORNADE', '');
INSERT INTO `brand` VALUES ('85', null, 'BILLABONG', '');
INSERT INTO `brand` VALUES ('86', null, 'BILLIE BLUSH', '');
INSERT INTO `brand` VALUES ('87', null, 'BILLYBANDIT', '');
INSERT INTO `brand` VALUES ('88', null, 'BIONDINI CHAUSSURES', '');
INSERT INTO `brand` VALUES ('89', null, 'BIOTHERM', '');
INSERT INTO `brand` VALUES ('90', null, 'BLANCPAIN', '');
INSERT INTO `brand` VALUES ('91', null, 'BLUE MARINE', '');
INSERT INTO `brand` VALUES ('92', null, 'BOBBI', '');
INSERT INTO `brand` VALUES ('93', null, 'BROWN', '');
INSERT INTO `brand` VALUES ('94', null, 'BOCAGE', '');
INSERT INTO `brand` VALUES ('95', null, 'BODUM', '');
INSERT INTO `brand` VALUES ('96', null, 'BOGGI', '');
INSERT INTO `brand` VALUES ('97', null, 'BOMBUM', '');
INSERT INTO `brand` VALUES ('98', null, 'BONPOINT', '');
INSERT INTO `brand` VALUES ('99', null, 'BONTON', '');
INSERT INTO `brand` VALUES ('100', null, 'BOTTEGA VENETA', '');
INSERT INTO `brand` VALUES ('101', null, 'BOUCHERON', '');
INSERT INTO `brand` VALUES ('102', null, 'BOURJOIS', '');
INSERT INTO `brand` VALUES ('103', null, 'BOWEN', '');
INSERT INTO `brand` VALUES ('104', null, 'BREITLING', '');
INSERT INTO `brand` VALUES ('105', null, 'BRIC’S', '');
INSERT INTO `brand` VALUES ('106', null, 'BRIEFING', '');
INSERT INTO `brand` VALUES ('107', null, 'BRIO / VILAC', '');
INSERT INTO `brand` VALUES ('108', null, 'BRIONI', '');
INSERT INTO `brand` VALUES ('109', null, 'BUCCELLATI', '');
INSERT INTO `brand` VALUES ('110', null, 'BUGABOO', '');
INSERT INTO `brand` VALUES ('111', null, 'BULGARI', '');
INSERT INTO `brand` VALUES ('112', null, 'BULY', '');
INSERT INTO `brand` VALUES ('113', null, 'BURBERRY', '');
INSERT INTO `brand` VALUES ('114', null, 'BVT (BRUN DE VIAN-TIRAN)', '');
INSERT INTO `brand` VALUES ('115', null, 'BY MALENE BIRGER', '');
INSERT INTO `brand` VALUES ('116', null, 'BY REDO', '');
INSERT INTO `brand` VALUES ('117', null, 'C DE C (CORDELIA DE CASTELLANE)', '');
INSERT INTO `brand` VALUES ('118', null, 'CACHAREL', '');
INSERT INTO `brand` VALUES ('119', null, 'CADET ROUSSELLE', '');
INSERT INTO `brand` VALUES ('120', null, 'CALIPIGE', '');
INSERT INTO `brand` VALUES ('121', null, 'CALVIN KLEIN', '');
INSERT INTO `brand` VALUES ('122', null, 'CAMPER', '');
INSERT INTO `brand` VALUES ('123', null, 'CANADA GOOSE', '');
INSERT INTO `brand` VALUES ('124', null, 'CANASUC', '');
INSERT INTO `brand` VALUES ('125', null, 'CANOBIO', '');
INSERT INTO `brand` VALUES ('126', null, 'CARAN D’ACHE', '');
INSERT INTO `brand` VALUES ('127', null, 'CARDO', '');
INSERT INTO `brand` VALUES ('128', null, 'CAREL', '');
INSERT INTO `brand` VALUES ('129', null, 'CARHARTT', '');
INSERT INTO `brand` VALUES ('130', null, 'CARIOCA', '');
INSERT INTO `brand` VALUES ('131', null, 'CAROLINA HERRERA', '');
INSERT INTO `brand` VALUES ('132', null, 'CAROLINE NAJMAN', '');
INSERT INTO `brand` VALUES ('133', null, 'CAROLL', '');
INSERT INTO `brand` VALUES ('134', null, 'CARRÉ BLANC', '');
INSERT INTO `brand` VALUES ('135', null, 'CARRÉ ROYAL', '');
INSERT INTO `brand` VALUES ('136', null, 'CARRÉMENT BEAU', '');
INSERT INTO `brand` VALUES ('137', null, 'CARTIER', '');
INSERT INTO `brand` VALUES ('138', null, 'CARVEN', '');
INSERT INTO `brand` VALUES ('139', null, 'CASIO', '');
INSERT INTO `brand` VALUES ('140', null, 'CATH KIDSTON', '');
INSERT INTO `brand` VALUES ('141', null, 'CATIMINI', '');
INSERT INTO `brand` VALUES ('142', null, 'CATOUNETTE', '');
INSERT INTO `brand` VALUES ('143', null, 'CAUDALIE', '');
INSERT INTO `brand` VALUES ('144', null, 'CÉLINE', '');
INSERT INTO `brand` VALUES ('145', null, 'CERRUTI', '');
INSERT INTO `brand` VALUES ('146', null, 'CERRUTI JEANS', '');
INSERT INTO `brand` VALUES ('147', null, 'CHANEL', '');
INSERT INTO `brand` VALUES ('148', null, 'CHANEL HORLOGERIE', '');
INSERT INTO `brand` VALUES ('149', null, 'CHANTAL THOMASS', '');
INSERT INTO `brand` VALUES ('150', null, 'CHANTELLE', '');
INSERT INTO `brand` VALUES ('151', null, 'CHARABIA', '');
INSERT INTO `brand` VALUES ('152', null, 'CHARLES & KEITH', '');
INSERT INTO `brand` VALUES ('153', null, 'CHARLES KAMMER', '');
INSERT INTO `brand` VALUES ('154', null, 'CHARRIER CHAUMET', '');
INSERT INTO `brand` VALUES ('155', null, 'CHEF & SOMMELIER', '');
INSERT INTO `brand` VALUES ('156', null, 'CHEVIGNON', '');
INSERT INTO `brand` VALUES ('157', null, 'CHILEWICH', '');
INSERT INTO `brand` VALUES ('158', null, 'CHIPIE', '');
INSERT INTO `brand` VALUES ('159', null, 'CHLOÉ', '');
INSERT INTO `brand` VALUES ('160', null, 'CHOPARD', '');
INSERT INTO `brand` VALUES ('161', null, 'CHRISTIAN BRETON', '');
INSERT INTO `brand` VALUES ('162', null, 'CHRISTIAN CANE', '');
INSERT INTO `brand` VALUES ('163', null, 'CHRISTOFLE', '');
INSERT INTO `brand` VALUES ('164', null, 'CHRISTOPHER KANE', '');
INSERT INTO `brand` VALUES ('165', null, 'CHURCH’S', '');
INSERT INTO `brand` VALUES ('166', null, 'CLAIRE’S', '');
INSERT INTO `brand` VALUES ('167', null, 'CLARINS', '');
INSERT INTO `brand` VALUES ('168', null, 'CLARKS', '');
INSERT INTO `brand` VALUES ('169', null, 'CLAUDIE PIERLOT', '');
INSERT INTO `brand` VALUES ('170', null, 'CLINIQUE', '');
INSERT INTO `brand` VALUES ('171', null, 'CLIO BLUE', '');
INSERT INTO `brand` VALUES ('172', null, 'COACH', '');
INSERT INTO `brand` VALUES ('173', null, 'COLISÉE DE SACHA', '');
INSERT INTO `brand` VALUES ('174', null, 'COMME DES GARÇONS', '');
INSERT INTO `brand` VALUES ('175', null, 'COMPTOIR DES COTONNIERS', '');
INSERT INTO `brand` VALUES ('176', null, 'CONVERSE', '');
INSERT INTO `brand` VALUES ('177', null, 'COP COPINE', '');
INSERT INTO `brand` VALUES ('178', null, 'COROLLE', '');
INSERT INTO `brand` VALUES ('179', null, 'CORTHAY', '');
INSERT INTO `brand` VALUES ('180', null, 'COS', '');
INSERT INTO `brand` VALUES ('181', null, 'COSA BELLA', '');
INSERT INTO `brand` VALUES ('182', null, 'COSMOPARIS', '');
INSERT INTO `brand` VALUES ('183', null, 'COTÉLAC', '');
INSERT INTO `brand` VALUES ('184', null, 'COUZON', '');
INSERT INTO `brand` VALUES ('185', null, 'CRAYOLA', '');
INSERT INTO `brand` VALUES ('186', null, 'CRÈME DE LA MER', '');
INSERT INTO `brand` VALUES ('187', null, 'CRISTAL DE SÈVRES', '');
INSERT INTO `brand` VALUES ('188', null, 'CRISTEL', '');
INSERT INTO `brand` VALUES ('189', null, 'CROSS', '');
INSERT INTO `brand` VALUES ('190', null, 'CUCINELLI', '');
INSERT INTO `brand` VALUES ('191', null, 'CULTURE VINTAGE', '');
INSERT INTO `brand` VALUES ('192', null, 'CYBEX', '');
INSERT INTO `brand` VALUES ('193', null, 'CYRILLUS', '');
INSERT INTO `brand` VALUES ('194', null, 'DALLOYAU', '');
INSERT INTO `brand` VALUES ('195', null, 'DAUM', '');
INSERT INTO `brand` VALUES ('196', null, 'DAVID YURMAN', '');
INSERT INTO `brand` VALUES ('197', null, 'DC SHOES', '');
INSERT INTO `brand` VALUES ('198', null, 'DD (DORÉ DORÉ)', '');
INSERT INTO `brand` VALUES ('199', null, 'DDP', '');
INSERT INTO `brand` VALUES ('200', null, 'DE BEERS', '');
INSERT INTO `brand` VALUES ('201', null, 'DE FURSAC', '');
INSERT INTO `brand` VALUES ('202', null, 'DÉCORATIONS NOËL', '');
INSERT INTO `brand` VALUES ('203', null, 'DÉGUISEMENTS', '');
INSERT INTO `brand` VALUES ('204', null, 'DELSEY', '');
INSERT INTO `brand` VALUES ('205', null, 'DELVAUX', '');
INSERT INTO `brand` VALUES ('206', null, 'DENIM & SUPPLY RALPH LAUREN', '');
INSERT INTO `brand` VALUES ('207', null, 'DERHY', '');
INSERT INTO `brand` VALUES ('208', null, 'DERHY KIDS', '');
INSERT INTO `brand` VALUES ('209', null, 'DEROEUX DES PETITS HAUTS', '');
INSERT INTO `brand` VALUES ('210', null, 'DESCAMPS', '');
INSERT INTO `brand` VALUES ('211', null, 'DESHOULIERES', '');
INSERT INTO `brand` VALUES ('212', null, 'DESIGUAL', '');
INSERT INTO `brand` VALUES ('213', null, 'DEVERNOIS', '');
INSERT INTO `brand` VALUES ('214', null, 'DIANE VON FURSTENBERG', '');
INSERT INTO `brand` VALUES ('215', null, 'DICE KAYEK', '');
INSERT INTO `brand` VALUES ('216', null, 'DIDIER GUÉRIN', '');
INSERT INTO `brand` VALUES ('217', null, 'DIDIER GUILLEMAIN', '');
INSERT INTO `brand` VALUES ('218', null, 'DIESEL', '');
INSERT INTO `brand` VALUES ('219', null, 'DIM', '');
INSERT INTO `brand` VALUES ('220', null, 'DINH VAN', '');
INSERT INTO `brand` VALUES ('221', null, 'DIOR', '');
INSERT INTO `brand` VALUES ('222', null, 'DIPTYQUE', '');
INSERT INTO `brand` VALUES ('223', null, 'DISNEY', '');
INSERT INTO `brand` VALUES ('224', null, 'DJECO', '');
INSERT INTO `brand` VALUES ('225', null, 'DKNY', '');
INSERT INTO `brand` VALUES ('226', null, 'DOCKERS', '');
INSERT INTO `brand` VALUES ('227', null, 'DODO', '');
INSERT INTO `brand` VALUES ('228', null, 'DOLCE & GABBANA', '');
INSERT INTO `brand` VALUES ('229', null, 'DOT', '');
INSERT INTO `brand` VALUES ('230', null, 'DROPS', '');
INSERT INTO `brand` VALUES ('231', null, 'DOUDOU & CIE', '');
INSERT INTO `brand` VALUES ('232', null, 'DOUDOUNES', '');
INSERT INTO `brand` VALUES ('233', null, 'DROUAULT', '');
INSERT INTO `brand` VALUES ('234', null, 'DSQUARED', '');
INSERT INTO `brand` VALUES ('235', null, 'DUNE', '');
INSERT INTO `brand` VALUES ('236', null, 'DUNHILL', '');
INSERT INTO `brand` VALUES ('237', null, 'DUNLOPILLO', '');
INSERT INTO `brand` VALUES ('238', null, 'DUPONT (ST)', '');
INSERT INTO `brand` VALUES ('239', null, 'DYSON', '');
INSERT INTO `brand` VALUES ('240', null, 'EASTPAK', '');
INSERT INTO `brand` VALUES ('241', null, 'EDEN PARK', '');
INSERT INTO `brand` VALUES ('242', null, 'EDEN SHOES', '');
INSERT INTO `brand` VALUES ('243', null, 'EDWIN', '');
INSERT INTO `brand` VALUES ('244', null, 'ELEMENT', '');
INSERT INTO `brand` VALUES ('245', null, 'ELEVEN PARIS', '');
INSERT INTO `brand` VALUES ('246', null, 'ELIZABETH STUART', '');
INSERT INTO `brand` VALUES ('247', null, 'EMINENCE', '');
INSERT INTO `brand` VALUES ('248', null, 'EMPREINTE', '');
INSERT INTO `brand` VALUES ('249', null, 'ERES', '');
INSERT INTO `brand` VALUES ('250', null, 'ERIC BOMPARD', '');
INSERT INTO `brand` VALUES ('251', null, 'ESPRIT', '');
INSERT INTO `brand` VALUES ('252', null, 'ESSENTIEL', '');
INSERT INTO `brand` VALUES ('253', null, 'ESSIE', '');
INSERT INTO `brand` VALUES ('254', null, 'ESTÉE LAUDER', '');
INSERT INTO `brand` VALUES ('255', null, 'ETAM ETOILE', '');
INSERT INTO `brand` VALUES ('256', null, 'EX NIHILO', '');
INSERT INTO `brand` VALUES ('257', null, 'EXACOMPTA', '');
INSERT INTO `brand` VALUES ('258', null, 'FABER-CASTELL', '');
INSERT INTO `brand` VALUES ('259', null, 'FAÇONNABLE', '');
INSERT INTO `brand` VALUES ('260', null, 'FAGUO', '');
INSERT INTO `brand` VALUES ('261', null, 'FALKE', '');
INSERT INTO `brand` VALUES ('262', null, 'FALKE ESS', '');
INSERT INTO `brand` VALUES ('263', null, 'FAURE LE PAGE', '');
INSERT INTO `brand` VALUES ('264', null, 'FENDI', '');
INSERT INTO `brand` VALUES ('265', null, 'FÉRAUD', '');
INSERT INTO `brand` VALUES ('266', null, 'FESTINA', '');
INSERT INTO `brand` VALUES ('267', null, 'FILOFAX', '');
INSERT INTO `brand` VALUES ('268', null, 'FISHER-PRICE', '');
INSERT INTO `brand` VALUES ('269', null, 'FISSLER', '');
INSERT INTO `brand` VALUES ('270', null, 'FLÉCHET', '');
INSERT INTO `brand` VALUES ('271', null, 'FLIK FLAK', '');
INSERT INTO `brand` VALUES ('272', null, 'FOSSIL', '');
INSERT INTO `brand` VALUES ('273', null, 'FPM', '');
INSERT INTO `brand` VALUES ('274', null, 'FRANCE CARTES / SMIR', '');
INSERT INTO `brand` VALUES ('275', null, 'FRATELLI ROSSETTI', '');
INSERT INTO `brand` VALUES ('276', null, 'FRED', '');
INSERT INTO `brand` VALUES ('277', null, 'FRED PERRY', '');
INSERT INTO `brand` VALUES ('278', null, 'FREDERIQUE CONSTANT', '');
INSERT INTO `brand` VALUES ('279', null, 'FREE LANCE', '');
INSERT INTO `brand` VALUES ('280', null, 'FRESCOBOL CARIOCA', '');
INSERT INTO `brand` VALUES ('281', null, 'FREYA', '');
INSERT INTO `brand` VALUES ('282', null, 'FROU-FROU', '');
INSERT INTO `brand` VALUES ('283', null, 'FURLA', '');
INSERT INTO `brand` VALUES ('284', null, 'G STAR', '');
INSERT INTO `brand` VALUES ('285', null, 'GAASTRA', '');
INSERT INTO `brand` VALUES ('286', null, 'GALERIES LAFAYETTE CACHEMIRE', '');
INSERT INTO `brand` VALUES ('287', null, 'GALERIES LAFAYETTE PARIS', '');
INSERT INTO `brand` VALUES ('288', null, 'GANT', '');
INSERT INTO `brand` VALUES ('289', null, 'GAP KIDS', '');
INSERT INTO `brand` VALUES ('290', null, 'GARANCE', '');
INSERT INTO `brand` VALUES ('291', null, 'GAS', '');
INSERT INTO `brand` VALUES ('292', null, 'GEMEY MAYBELINE', '');
INSERT INTO `brand` VALUES ('293', null, 'GEOX', '');
INSERT INTO `brand` VALUES ('294', null, 'GÉRARD DAREL', '');
INSERT INTO `brand` VALUES ('295', null, 'GERTRUDE', '');
INSERT INTO `brand` VALUES ('296', null, 'GHD', '');
INSERT INTO `brand` VALUES ('297', null, 'GIANVITO ROSSI', '');
INSERT INTO `brand` VALUES ('298', null, 'GIEN', '');
INSERT INTO `brand` VALUES ('299', null, 'GIENCHI', '');
INSERT INTO `brand` VALUES ('300', null, 'GIUSEPPE ZANOTTI', '');
INSERT INTO `brand` VALUES ('301', null, 'GIVENCHY', '');
INSERT INTO `brand` VALUES ('302', null, 'GO TRAVEL', '');
INSERT INTO `brand` VALUES ('303', null, 'GOSHA RUBCHINSKIY', '');
INSERT INTO `brand` VALUES ('304', null, 'GOURMET', '');
INSERT INTO `brand` VALUES ('305', null, 'GUCCI', '');
INSERT INTO `brand` VALUES ('306', null, 'GUERLAIN', '');
INSERT INTO `brand` VALUES ('307', null, 'GUESS', '');
INSERT INTO `brand` VALUES ('308', null, 'GUY DEGRENNE', '');
INSERT INTO `brand` VALUES ('309', null, 'HACKETT', '');
INSERT INTO `brand` VALUES ('310', null, 'HALLMARK / LA CARTERIE', '');
INSERT INTO `brand` VALUES ('311', null, 'HAMILTON', '');
INSERT INTO `brand` VALUES ('312', null, 'HANRO', '');
INSERT INTO `brand` VALUES ('313', null, 'HARRIS WILSON', '');
INSERT INTO `brand` VALUES ('314', null, 'HARTMANN', '');
INSERT INTO `brand` VALUES ('315', null, 'HASBRO JEUX DE SOCIÉTÉ', '');
INSERT INTO `brand` VALUES ('316', null, 'HAVAIANAS', '');
INSERT INTO `brand` VALUES ('317', null, 'HAVILAND', '');
INSERT INTO `brand` VALUES ('318', null, 'HELLO PARIS', '');
INSERT INTO `brand` VALUES ('319', null, 'HERBELIN', '');
INSERT INTO `brand` VALUES ('320', null, 'HERMÈS', '');
INSERT INTO `brand` VALUES ('321', null, 'HERSCHEL', '');
INSERT INTO `brand` VALUES ('322', null, 'HIDDEN EYE', '');
INSERT INTO `brand` VALUES ('323', null, 'HIGH', '');
INSERT INTO `brand` VALUES ('324', null, 'HILFIGER DENIM', '');
INSERT INTO `brand` VALUES ('325', null, 'HOGAN', '');
INSERT INTO `brand` VALUES ('326', null, 'HOM', '');
INSERT INTO `brand` VALUES ('327', null, 'HUBLOT', '');
INSERT INTO `brand` VALUES ('328', null, 'HUGO BOSS', '');
INSERT INTO `brand` VALUES ('329', null, 'HUIT', '');
INSERT INTO `brand` VALUES ('330', null, 'I WAS IN', '');
INSERT INTO `brand` VALUES ('331', null, 'IDÉES CADEAUX', '');
INSERT INTO `brand` VALUES ('332', null, 'IITTALA', '');
INSERT INTO `brand` VALUES ('333', null, 'IKKS', '');
INSERT INTO `brand` VALUES ('334', null, 'IMAGE D’ORIENT', '');
INSERT INTO `brand` VALUES ('335', null, 'IMPLICITE', '');
INSERT INTO `brand` VALUES ('336', null, 'INÈS DE LA FRESSANGE', '');
INSERT INTO `brand` VALUES ('337', null, 'IODUS', '');
INSERT INTO `brand` VALUES ('338', null, 'IRO', '');
INSERT INTO `brand` VALUES ('339', null, 'ISABEL MARANT', '');
INSERT INTO `brand` VALUES ('340', null, 'ISOTONER CHAUSSON', '');
INSERT INTO `brand` VALUES ('341', null, 'ISSEY MIYAKE', '');
INSERT INTO `brand` VALUES ('342', null, 'IWC', '');
INSERT INTO `brand` VALUES ('343', null, 'J.BRAND', '');
INSERT INTO `brand` VALUES ('344', null, 'JACADI', '');
INSERT INTO `brand` VALUES ('345', null, 'JACQUARD FRANÇAIS', '');
INSERT INTO `brand` VALUES ('346', null, 'JAEGER-LECOULTRE', '');
INSERT INTO `brand` VALUES ('347', null, 'JALLA', '');
INSERT INTO `brand` VALUES ('348', null, 'JANOD', '');
INSERT INTO `brand` VALUES ('349', null, 'JARDIN SECRET', '');
INSERT INTO `brand` VALUES ('350', null, 'JARS', '');
INSERT INTO `brand` VALUES ('351', null, 'JB MARTIN', '');
INSERT INTO `brand` VALUES ('352', null, 'JEAN-BAPTISTE RAUTUREAU', '');
INSERT INTO `brand` VALUES ('353', null, 'JEAN-PAUL GAULTIER', '');
INSERT INTO `brand` VALUES ('354', null, 'JEAN-PAUL HÉVIN', '');
INSERT INTO `brand` VALUES ('355', null, 'JÉRÔME DREYFUSS', '');
INSERT INTO `brand` VALUES ('356', null, 'JETABLE', '');
INSERT INTO `brand` VALUES ('357', null, 'JIL SANDER NAVY', '');
INSERT INTO `brand` VALUES ('358', null, 'JIMMY CHOO', '');
INSERT INTO `brand` VALUES ('359', null, 'JO MALONE', '');
INSERT INTO `brand` VALUES ('360', null, 'JODHPUR', '');
INSERT INTO `brand` VALUES ('361', null, 'JONAK', '');
INSERT INTO `brand` VALUES ('362', null, 'JOSEPH', '');
INSERT INTO `brand` VALUES ('363', null, 'JUICY COUTURE', '');
INSERT INTO `brand` VALUES ('364', null, 'JUMP', '');
INSERT INTO `brand` VALUES ('365', null, 'JUNYA WATANABE', '');
INSERT INTO `brand` VALUES ('366', null, 'JURA', '');
INSERT INTO `brand` VALUES ('367', null, 'JUST CAVALLI', '');
INSERT INTO `brand` VALUES ('368', null, 'JUUN J', '');
INSERT INTO `brand` VALUES ('369', null, 'KAPLA', '');
INSERT INTO `brand` VALUES ('370', null, 'KAPORAL 5', '');
INSERT INTO `brand` VALUES ('371', null, 'KAREN MILLEN', '');
INSERT INTO `brand` VALUES ('372', null, 'KARL LAGERFED', '');
INSERT INTO `brand` VALUES ('373', null, 'KATE SPADE', '');
INSERT INTO `brand` VALUES ('374', null, 'KENZO', '');
INSERT INTO `brand` VALUES ('375', null, 'KESSLORD', '');
INSERT INTO `brand` VALUES ('376', null, 'KICKERS', '');
INSERT INTO `brand` VALUES ('377', null, 'KID’S GRAFFITI', '');
INSERT INTO `brand` VALUES ('378', null, 'KIEHL’S', '');
INSERT INTO `brand` VALUES ('379', null, 'KIPLING', '');
INSERT INTO `brand` VALUES ('380', null, 'KITCHENAID', '');
INSERT INTO `brand` VALUES ('381', null, 'KITON', '');
INSERT INTO `brand` VALUES ('382', null, 'KITSUNÉ', '');
INSERT INTO `brand` VALUES ('383', null, 'KIWI', '');
INSERT INTO `brand` VALUES ('384', null, 'KOST', '');
INSERT INTO `brand` VALUES ('385', null, 'KRUPS', '');
INSERT INTO `brand` VALUES ('386', null, 'KURE BAZAR', '');
INSERT INTO `brand` VALUES ('387', null, 'KUSMI TEA', '');
INSERT INTO `brand` VALUES ('388', null, 'L’AIGLON', '');
INSERT INTO `brand` VALUES ('389', null, 'L’ARTISAN PARFUMEUR', '');
INSERT INTO `brand` VALUES ('390', null, 'L’OCCITANE', '');
INSERT INTO `brand` VALUES ('391', null, 'L’ORÉAL', '');
INSERT INTO `brand` VALUES ('392', null, 'L’ORÉAL PERFECTION', '');
INSERT INTO `brand` VALUES ('393', null, 'L.K.BENNETT', '');
INSERT INTO `brand` VALUES ('394', null, 'LA COLLINE', '');
INSERT INTO `brand` VALUES ('395', null, 'LA FÉE MARABOUTEE', '');
INSERT INTO `brand` VALUES ('396', null, 'LA PERLA', '');
INSERT INTO `brand` VALUES ('397', null, 'LA PRAIRIE', '');
INSERT INTO `brand` VALUES ('398', null, 'LA ROCHÈRE', '');
INSERT INTO `brand` VALUES ('399', null, 'LA ROUTE DES INDES', '');
INSERT INTO `brand` VALUES ('400', null, 'LABO CHAUSSURES CRÉATEURS', '');
INSERT INTO `brand` VALUES ('401', null, 'LABO CHAUSSURES VILLE', '');
INSERT INTO `brand` VALUES ('402', null, 'LABO CRÉATEURS 1', '');
INSERT INTO `brand` VALUES ('403', null, 'LABO CRÉATEURS 3', '');
INSERT INTO `brand` VALUES ('404', null, 'LABONAL', '');
INSERT INTO `brand` VALUES ('405', null, 'LACOSTE', '');
INSERT INTO `brand` VALUES ('406', null, 'LAGOSTINA', '');
INSERT INTO `brand` VALUES ('407', null, 'LALIQUE', '');
INSERT INTO `brand` VALUES ('408', null, 'LAMBERTO', '');
INSERT INTO `brand` VALUES ('409', null, 'LOSANI', '');
INSERT INTO `brand` VALUES ('410', null, 'LAMPE BERGER', '');
INSERT INTO `brand` VALUES ('411', null, 'LANCASTER', '');
INSERT INTO `brand` VALUES ('412', null, 'LANCEL', '');
INSERT INTO `brand` VALUES ('413', null, 'LANCÔME', '');
INSERT INTO `brand` VALUES ('414', null, 'LANVIN', '');
INSERT INTO `brand` VALUES ('415', null, 'LAURA STAR', '');
INSERT INTO `brand` VALUES ('416', null, 'LAURA TODD', '');
INSERT INTO `brand` VALUES ('417', null, 'LAUREN', '');
INSERT INTO `brand` VALUES ('418', null, 'LAURENCE', '');
INSERT INTO `brand` VALUES ('419', null, 'TAVERNIER', '');
INSERT INTO `brand` VALUES ('420', null, 'LE CHOCOLAT ALAIN DUCASSE', '');
INSERT INTO `brand` VALUES ('421', null, 'LE CREUSET LE SLIP FRANÇAIS', '');
INSERT INTO `brand` VALUES ('422', null, 'LE TANNEUR', '');
INSERT INTO `brand` VALUES ('423', null, 'LE TEMPS DES CERISES', '');
INSERT INTO `brand` VALUES ('424', null, 'LEE', '');
INSERT INTO `brand` VALUES ('425', null, 'LEGAZEL', '');
INSERT INTO `brand` VALUES ('426', null, 'LEGO', '');
INSERT INTO `brand` VALUES ('427', null, 'LEICA', '');
INSERT INTO `brand` VALUES ('428', null, 'LEMAIRE', '');
INSERT INTO `brand` VALUES ('429', null, 'LÉON & HARPER', '');
INSERT INTO `brand` VALUES ('430', null, 'LES INVASIONS EPHÉMÈRES', '');
INSERT INTO `brand` VALUES ('431', null, 'LES NEREIDES', '');
INSERT INTO `brand` VALUES ('432', null, 'LEVI’S', '');
INSERT INTO `brand` VALUES ('433', null, 'LILI GAUFRETTE', '');
INSERT INTO `brand` VALUES ('434', null, 'LIOU', '');
INSERT INTO `brand` VALUES ('435', null, 'LIPAULT', '');
INSERT INTO `brand` VALUES ('436', null, 'LISE CHARMEL', '');
INSERT INTO `brand` VALUES ('437', null, 'LIVIA', '');
INSERT INTO `brand` VALUES ('438', null, 'LOEWE', '');
INSERT INTO `brand` VALUES ('439', null, 'LOLË', '');
INSERT INTO `brand` VALUES ('440', null, 'LOLITA', '');
INSERT INTO `brand` VALUES ('441', null, 'LEMPICKA', '');
INSERT INTO `brand` VALUES ('442', null, 'LONGCHAMP', '');
INSERT INTO `brand` VALUES ('443', null, 'LONGCILS BONCZA', '');
INSERT INTO `brand` VALUES ('444', null, 'LONGINES', '');
INSERT INTO `brand` VALUES ('445', null, 'LORNA JANE', '');
INSERT INTO `brand` VALUES ('446', null, 'LOU', '');
INSERT INTO `brand` VALUES ('447', null, 'LOUIS PION', '');
INSERT INTO `brand` VALUES ('448', null, 'LOUIS QUATORZE', '');
INSERT INTO `brand` VALUES ('449', null, 'LOUIS VUITTON', '');
INSERT INTO `brand` VALUES ('450', null, 'LOUIS VUITTON ACCESSOIRES', '');
INSERT INTO `brand` VALUES ('451', null, 'LOUNGEWEAR', '');
INSERT INTO `brand` VALUES ('452', null, 'LOVE STORIES', '');
INSERT INTO `brand` VALUES ('453', null, 'LUCY LOCKET', '');
INSERT INTO `brand` VALUES ('454', null, 'M DE MISSONI', '');
INSERT INTO `brand` VALUES ('455', null, 'MAC', '');
INSERT INTO `brand` VALUES ('456', null, 'MAC LAREN', '');
INSERT INTO `brand` VALUES ('457', null, 'MAD ET LEN', '');
INSERT INTO `brand` VALUES ('458', null, 'MADURA', '');
INSERT INTO `brand` VALUES ('459', null, 'MAGIMIX', '');
INSERT INTO `brand` VALUES ('460', null, 'MAIDENFORM', '');
INSERT INTO `brand` VALUES ('461', null, 'MAISON LEJABY COUTURE', '');
INSERT INTO `brand` VALUES ('462', null, 'MAISON MARGIELA', '');
INSERT INTO `brand` VALUES ('463', null, 'MAJE', '');
INSERT INTO `brand` VALUES ('464', null, 'MAJORETTE', '');
INSERT INTO `brand` VALUES ('465', null, 'MALONGO', '');
INSERT INTO `brand` VALUES ('466', null, 'MANFIELD', '');
INSERT INTO `brand` VALUES ('467', null, 'MANOUSH', '');
INSERT INTO `brand` VALUES ('468', null, 'MARBELLA', '');
INSERT INTO `brand` VALUES ('469', null, 'MARC BY MARC JACOBS', '');
INSERT INTO `brand` VALUES ('470', null, 'MARC JACOBS', '');
INSERT INTO `brand` VALUES ('471', null, 'MARC LE BIHAN', '');
INSERT INTO `brand` VALUES ('472', null, 'MARC O’ POLO', '');
INSERT INTO `brand` VALUES ('473', null, 'MARC ROZIER', '');
INSERT INTO `brand` VALUES ('474', null, 'MARCELO BURLON', '');
INSERT INTO `brand` VALUES ('475', null, 'MARIAGE FRÈRES THÉS', '');
INSERT INTO `brand` VALUES ('476', null, 'MARIE JO MARIE SIXTINE', '');
INSERT INTO `brand` VALUES ('477', null, 'MARIMEKKO', '');
INSERT INTO `brand` VALUES ('478', null, 'MARINA RINALDI', '');
INSERT INTO `brand` VALUES ('479', null, 'MARINER', '');
INSERT INTO `brand` VALUES ('480', null, 'MARNI', '');
INSERT INTO `brand` VALUES ('481', null, 'MASSIMO DUTTI', '');
INSERT INTO `brand` VALUES ('482', null, 'MATTEL FILLE', '');
INSERT INTO `brand` VALUES ('483', null, 'MATTEL JEUX DE SOCIÉTÉ', '');
INSERT INTO `brand` VALUES ('484', null, 'MAUVIEL', '');
INSERT INTO `brand` VALUES ('485', null, 'MAVALA', '');
INSERT INTO `brand` VALUES ('486', null, 'MAX MARA STUDIO', '');
INSERT INTO `brand` VALUES ('487', null, 'MAX MARA WEEKEND', '');
INSERT INTO `brand` VALUES ('488', null, 'MAXIM’S', '');
INSERT INTO `brand` VALUES ('489', null, 'MC GREGOR', '');
INSERT INTO `brand` VALUES ('490', null, 'MCM', '');
INSERT INTO `brand` VALUES ('491', null, 'MCQ ALEXANDER MCQUEEN', '');
INSERT INTO `brand` VALUES ('492', null, 'MCS', '');
INSERT INTO `brand` VALUES ('493', null, 'MECCANO', '');
INSERT INTO `brand` VALUES ('494', null, 'MELISSA ODABASH', '');
INSERT INTO `brand` VALUES ('495', null, 'MELLOW YELLOW', '');
INSERT INTO `brand` VALUES ('496', null, 'MEMO', '');
INSERT INTO `brand` VALUES ('497', null, 'MENU', '');
INSERT INTO `brand` VALUES ('498', null, 'MEPHISTO', '');
INSERT INTO `brand` VALUES ('499', null, 'MESSIKA', '');
INSERT INTO `brand` VALUES ('500', null, 'MEXICANA', '');
INSERT INTO `brand` VALUES ('501', null, 'MICHAEL KORS', '');
INSERT INTO `brand` VALUES ('502', null, 'MIDO', '');
INSERT INTO `brand` VALUES ('503', null, 'MIGNON', '');
INSERT INTO `brand` VALUES ('504', null, 'MILLEFIORI', '');
INSERT INTO `brand` VALUES ('505', null, 'MIMISOL', '');
INSERT INTO `brand` VALUES ('506', null, 'MINELLI', '');
INSERT INTO `brand` VALUES ('507', null, 'MISE AU GREEN', '');
INSERT INTO `brand` VALUES ('508', null, 'MISS ETOILE', '');
INSERT INTO `brand` VALUES ('509', null, 'MIU MIU', '');
INSERT INTO `brand` VALUES ('510', null, 'MO&CO', '');
INSERT INTO `brand` VALUES ('511', null, 'MO&CO EDITION', '');
INSERT INTO `brand` VALUES ('512', null, 'MODELCO', '');
INSERT INTO `brand` VALUES ('513', null, 'MOIS MONT', '');
INSERT INTO `brand` VALUES ('514', null, 'MOLESKINE', '');
INSERT INTO `brand` VALUES ('515', null, 'MOLINARD', '');
INSERT INTO `brand` VALUES ('516', null, 'MOLLY BRACKEN', '');
INSERT INTO `brand` VALUES ('517', null, 'MONBENTO BOX', '');
INSERT INTO `brand` VALUES ('518', null, 'MONCLER', '');
INSERT INTO `brand` VALUES ('519', null, 'MONNALISA', '');
INSERT INTO `brand` VALUES ('520', null, 'MONSTER HIGH', '');
INSERT INTO `brand` VALUES ('521', null, 'MONT BLANC', '');
INSERT INTO `brand` VALUES ('522', null, 'MONTAGUT', '');
INSERT INTO `brand` VALUES ('523', null, 'MONTBLANC', '');
INSERT INTO `brand` VALUES ('524', null, 'MORGAN', '');
INSERT INTO `brand` VALUES ('525', null, 'MOULIN ROTY', '');
INSERT INTO `brand` VALUES ('526', null, 'MOYNAT', '');
INSERT INTO `brand` VALUES ('527', null, 'MSGM', '');
INSERT INTO `brand` VALUES ('528', null, 'MULBERRY', '');
INSERT INTO `brand` VALUES ('529', null, 'MULTIMARQUES BAGAGES', '');
INSERT INTO `brand` VALUES ('530', null, 'MY JEMMA', '');
INSERT INTO `brand` VALUES ('531', null, 'NAF NAF', '');
INSERT INTO `brand` VALUES ('532', null, 'NAILMATIC', '');
INSERT INTO `brand` VALUES ('533', null, 'NAPAPIJRI', '');
INSERT INTO `brand` VALUES ('534', null, 'NARCISSO RODRIGUEZ', '');
INSERT INTO `brand` VALUES ('535', null, 'NARS COSMECTICS', '');
INSERT INTO `brand` VALUES ('536', null, 'NAT & NIN', '');
INSERT INTO `brand` VALUES ('537', null, 'NERO PERLA', '');
INSERT INTO `brand` VALUES ('538', null, 'NESPRESSO', '');
INSERT INTO `brand` VALUES ('539', null, 'NEW BALANCE', '');
INSERT INTO `brand` VALUES ('540', null, 'NICHOLAS KIRKWOOD', '');
INSERT INTO `brand` VALUES ('541', null, 'NIKE', '');
INSERT INTO `brand` VALUES ('542', null, 'NINA RICCI', '');
INSERT INTO `brand` VALUES ('543', null, 'NIXON', '');
INSERT INTO `brand` VALUES ('544', null, 'NORTH FACE', '');
INSERT INTO `brand` VALUES ('545', null, 'O’FÉE', '');
INSERT INTO `brand` VALUES ('546', null, 'O’NEILL', '');
INSERT INTO `brand` VALUES ('547', null, 'OAKWOOD', '');
INSERT INTO `brand` VALUES ('548', null, 'OFF WHITE', '');
INSERT INTO `brand` VALUES ('549', null, 'OLAF BENZ', '');
INSERT INTO `brand` VALUES ('550', null, 'OLIVIER DESFORGES', '');
INSERT INTO `brand` VALUES ('551', null, 'OMEGA', '');
INSERT INTO `brand` VALUES ('552', null, 'ONE STEP', '');
INSERT INTO `brand` VALUES ('553', null, 'OREST', '');
INSERT INTO `brand` VALUES ('554', null, 'ORIGINAL PENGUIN', '');
INSERT INTO `brand` VALUES ('555', null, 'ORIS', '');
INSERT INTO `brand` VALUES ('556', null, 'OVALE', '');
INSERT INTO `brand` VALUES ('557', null, 'OYSHO', '');
INSERT INTO `brand` VALUES ('558', null, 'PABLO', '');
INSERT INTO `brand` VALUES ('559', null, 'PACO RABANNE', '');
INSERT INTO `brand` VALUES ('560', null, 'PAIN DE SUCRE', '');
INSERT INTO `brand` VALUES ('561', null, 'PAL ZILERI', '');
INSERT INTO `brand` VALUES ('562', null, 'PALADINI', '');
INSERT INTO `brand` VALUES ('563', null, 'PALLADIUM', '');
INSERT INTO `brand` VALUES ('564', null, 'PANDORA', '');
INSERT INTO `brand` VALUES ('565', null, 'PANERAÏ', '');
INSERT INTO `brand` VALUES ('566', null, 'PAPERCHASE', '');
INSERT INTO `brand` VALUES ('567', null, 'PAPO', '');
INSERT INTO `brand` VALUES ('568', null, 'PARAJUMPERS', '');
INSERT INTO `brand` VALUES ('569', null, 'PARALLÈLE', '');
INSERT INTO `brand` VALUES ('570', null, 'PARIS IN PARIS', '');
INSERT INTO `brand` VALUES ('571', null, 'PARKER', '');
INSERT INTO `brand` VALUES ('572', null, 'PASSION FRANCE', '');
INSERT INTO `brand` VALUES ('573', null, 'PASSIONATA', '');
INSERT INTO `brand` VALUES ('574', null, 'PATAGONIA', '');
INSERT INTO `brand` VALUES ('575', null, 'PATAUGAS', '');
INSERT INTO `brand` VALUES ('576', null, 'PATÉ DE SABLE', '');
INSERT INTO `brand` VALUES ('577', null, 'PAUL & JOE', '');
INSERT INTO `brand` VALUES ('578', null, 'PAUL & JOE SISTER', '');
INSERT INTO `brand` VALUES ('579', null, 'PAUL SMITH', '');
INSERT INTO `brand` VALUES ('580', null, 'PAULE KA', '');
INSERT INTO `brand` VALUES ('581', null, 'PEPE JEANS', '');
INSERT INTO `brand` VALUES ('582', null, 'PEQUIGNET', '');
INSERT INTO `brand` VALUES ('583', null, 'PETIT BATEAU', '');
INSERT INTO `brand` VALUES ('584', null, 'PETROSSIAN', '');
INSERT INTO `brand` VALUES ('585', null, 'PETRUSSE', '');
INSERT INTO `brand` VALUES ('586', null, 'PEUGEOT', '');
INSERT INTO `brand` VALUES ('587', null, 'PEUGEOT ŒNOLOGIE', '');
INSERT INTO `brand` VALUES ('588', null, 'PHILIPPE MODEL', '');
INSERT INTO `brand` VALUES ('589', null, 'PHILLIP LIM', '');
INSERT INTO `brand` VALUES ('590', null, 'PIAGET', '');
INSERT INTO `brand` VALUES ('591', null, 'PICARD', '');
INSERT INTO `brand` VALUES ('592', null, 'PIERRE-LOUIS MASCIA', '');
INSERT INTO `brand` VALUES ('593', null, 'PIETRO BRUNELLI', '');
INSERT INTO `brand` VALUES ('594', null, 'PIGALE', '');
INSERT INTO `brand` VALUES ('595', null, 'PILUS', '');
INSERT INTO `brand` VALUES ('596', null, 'PINKO', '');
INSERT INTO `brand` VALUES ('597', null, 'PLASTOY', '');
INSERT INTO `brand` VALUES ('598', null, 'PLAYMOBIL', '');
INSERT INTO `brand` VALUES ('599', null, 'PLAYSKOOL', '');
INSERT INTO `brand` VALUES ('600', null, 'PLEATS', '');
INSERT INTO `brand` VALUES ('601', null, 'PLEASE ISSEY MIYAKÉ', '');
INSERT INTO `brand` VALUES ('602', null, 'POIVRE BLANC', '');
INSERT INTO `brand` VALUES ('603', null, 'POLO RALPH LAUREN', '');
INSERT INTO `brand` VALUES ('604', null, 'POM D’API', '');
INSERT INTO `brand` VALUES ('605', null, 'POMAX', '');
INSERT INTO `brand` VALUES ('606', null, 'POMELLATO', '');
INSERT INTO `brand` VALUES ('607', null, 'PRADA', '');
INSERT INTO `brand` VALUES ('608', null, 'PRÉSENCE', '');
INSERT INTO `brand` VALUES ('609', null, 'PRIMA DONNA', '');
INSERT INTO `brand` VALUES ('610', null, 'PRINCESSE TAM-TAM', '');
INSERT INTO `brand` VALUES ('611', null, 'PROENZA SCHOULER', '');
INSERT INTO `brand` VALUES ('612', null, 'PSG', '');
INSERT INTO `brand` VALUES ('613', null, 'PUIFORCAT', '');
INSERT INTO `brand` VALUES ('614', null, 'PULL’IN', '');
INSERT INTO `brand` VALUES ('615', null, 'PUMA', '');
INSERT INTO `brand` VALUES ('616', null, 'PYRENEX', '');
INSERT INTO `brand` VALUES ('617', null, 'Q QUIKSILVER', '');
INSERT INTO `brand` VALUES ('618', null, 'QUO VADIS', '');
INSERT INTO `brand` VALUES ('619', null, 'R RADO', '');
INSERT INTO `brand` VALUES ('620', null, 'RAG & BONE', '');
INSERT INTO `brand` VALUES ('621', null, 'RALPH LAUREN', '');
INSERT INTO `brand` VALUES ('622', null, 'RAVENSBURGER', '');
INSERT INTO `brand` VALUES ('623', null, 'RED CARPET', '');
INSERT INTO `brand` VALUES ('624', null, 'RED SOX', '');
INSERT INTO `brand` VALUES ('625', null, 'REDKEN', '');
INSERT INTO `brand` VALUES ('626', null, 'REDSKINS', '');
INSERT INTO `brand` VALUES ('627', null, 'REEBOK', '');
INSERT INTO `brand` VALUES ('628', null, 'REMINISCENCE', '');
INSERT INTO `brand` VALUES ('629', null, 'RENAPUR', '');
INSERT INTO `brand` VALUES ('630', null, 'REPETTO', '');
INSERT INTO `brand` VALUES ('631', null, 'REPLAY', '');
INSERT INTO `brand` VALUES ('632', null, 'RÉVOL', '');
INSERT INTO `brand` VALUES ('633', null, 'RICK OWENS', '');
INSERT INTO `brand` VALUES ('634', null, 'RIMOWA', '');
INSERT INTO `brand` VALUES ('635', null, 'ROBERT CLERGERIE', '');
INSERT INTO `brand` VALUES ('636', null, 'ROBERTO CAVALLI', '');
INSERT INTO `brand` VALUES ('637', null, 'ROGER DUBUIS', '');
INSERT INTO `brand` VALUES ('638', null, 'ROGER GALLET', '');
INSERT INTO `brand` VALUES ('639', null, 'ROGER VIVIER', '');
INSERT INTO `brand` VALUES ('640', null, 'ROLEX RONCATO', '');
INSERT INTO `brand` VALUES ('641', null, 'ROSENTHAL', '');
INSERT INTO `brand` VALUES ('642', null, 'RÖSLE', '');
INSERT INTO `brand` VALUES ('643', null, 'ROSY', '');
INSERT INTO `brand` VALUES ('644', null, 'ROXY', '');
INSERT INTO `brand` VALUES ('645', null, 'ROYAL QUARTZ', '');
INSERT INTO `brand` VALUES ('646', null, 'RUBIES', '');
INSERT INTO `brand` VALUES ('647', null, 'SABRE', '');
INSERT INTO `brand` VALUES ('648', null, 'SAINT LAURENT', '');
INSERT INTO `brand` VALUES ('649', null, 'SAINT LOUIS', '');
INSERT INTO `brand` VALUES ('650', null, 'SALSA', '');
INSERT INTO `brand` VALUES ('651', null, 'SALVATORE FERRAGAMO', '');
INSERT INTO `brand` VALUES ('652', null, 'SAMSONITE', '');
INSERT INTO `brand` VALUES ('653', null, 'SANDRO', '');
INSERT INTO `brand` VALUES ('654', null, 'SANTONI', '');
INSERT INTO `brand` VALUES ('655', null, 'SARTORE', '');
INSERT INTO `brand` VALUES ('656', null, 'SATELLITE', '');
INSERT INTO `brand` VALUES ('657', null, 'SCOTCH & SODA', '');
INSERT INTO `brand` VALUES ('658', null, 'SCREWPULL', '');
INSERT INTO `brand` VALUES ('659', null, 'SEAFOLLY', '');
INSERT INTO `brand` VALUES ('660', null, 'SEB', '');
INSERT INTO `brand` VALUES ('661', null, 'SEE BY CHLOÉ', '');
INSERT INTO `brand` VALUES ('662', null, 'SEE U SOON', '');
INSERT INTO `brand` VALUES ('663', null, 'SEIDENSTICKER', '');
INSERT INTO `brand` VALUES ('664', null, 'SEIKO', '');
INSERT INTO `brand` VALUES ('665', null, 'SENTOSPHERE', '');
INSERT INTO `brand` VALUES ('666', null, 'SÉRAPHINE', '');
INSERT INTO `brand` VALUES ('667', null, 'SERGE LUTENS', '');
INSERT INTO `brand` VALUES ('668', null, 'SERGIO ROSSI', '');
INSERT INTO `brand` VALUES ('669', null, 'SESSUN', '');
INSERT INTO `brand` VALUES ('670', null, 'SHISEIDO', '');
INSERT INTO `brand` VALUES ('671', null, 'SHOUROUK', '');
INSERT INTO `brand` VALUES ('672', null, 'SHU UEMURA', '');
INSERT INTO `brand` VALUES ('673', null, 'SIMMONS', '');
INSERT INTO `brand` VALUES ('674', null, 'SIMONE PÉRÈLE', '');
INSERT INTO `brand` VALUES ('675', null, 'SINEQUANONE', '');
INSERT INTO `brand` VALUES ('676', null, 'SINFULCOLORS', '');
INSERT INTO `brand` VALUES ('677', null, 'SISLEY', '');
INSERT INTO `brand` VALUES ('678', null, 'SIX PIEDS TROIS POUCES', '');
INSERT INTO `brand` VALUES ('679', null, 'SMALTO', '');
INSERT INTO `brand` VALUES ('680', null, 'SMEG', '');
INSERT INTO `brand` VALUES ('681', null, 'SMOBY', '');
INSERT INTO `brand` VALUES ('682', null, 'SMYTHSON', '');
INSERT INTO `brand` VALUES ('683', null, 'SNEAKERS', '');
INSERT INTO `brand` VALUES ('684', null, 'SOFRAP', '');
INSERT INTO `brand` VALUES ('685', null, 'SONIA BY SONIA RYKIEL', '');
INSERT INTO `brand` VALUES ('686', null, 'SONIA RYKIEL', '');
INSERT INTO `brand` VALUES ('687', null, 'SOUVENIRS DE PARIS', '');
INSERT INTO `brand` VALUES ('688', null, 'SPANX', '');
INSERT INTO `brand` VALUES ('689', null, 'SPRUNG FRÈRES', '');
INSERT INTO `brand` VALUES ('690', null, 'STAUB', '');
INSERT INTO `brand` VALUES ('691', null, 'STEINER', '');
INSERT INTO `brand` VALUES ('692', null, 'STELLA LUNA', '');
INSERT INTO `brand` VALUES ('693', null, 'STELLA MC CARTNEY', '');
INSERT INTO `brand` VALUES ('694', null, 'STETSON', '');
INSERT INTO `brand` VALUES ('695', null, 'STUART WEITZMAN', '');
INSERT INTO `brand` VALUES ('696', null, 'STUDIO MAKE UP', '');
INSERT INTO `brand` VALUES ('697', null, 'SUD EXPRESS', '');
INSERT INTO `brand` VALUES ('698', null, 'SUNCOO', '');
INSERT INTO `brand` VALUES ('699', null, 'SWAROVSKI', '');
INSERT INTO `brand` VALUES ('700', null, 'SWATCH', '');
INSERT INTO `brand` VALUES ('701', null, 'SYLVANIAN', '');
INSERT INTO `brand` VALUES ('702', null, 'T TAG HEUER', '');
INSERT INTO `brand` VALUES ('703', null, 'TARA JARMON', '');
INSERT INTO `brand` VALUES ('704', null, 'TARTINE ET CHOCOLAT', '');
INSERT INTO `brand` VALUES ('705', null, 'TED BAKER', '');
INSERT INTO `brand` VALUES ('706', null, 'TEDDY SMITH', '');
INSERT INTO `brand` VALUES ('707', null, 'TEFAL', '');
INSERT INTO `brand` VALUES ('708', null, 'THE KOOPLES', '');
INSERT INTO `brand` VALUES ('709', null, 'THE KOOPLES SPORT', '');
INSERT INTO `brand` VALUES ('710', null, 'THEORY', '');
INSERT INTO `brand` VALUES ('711', null, 'THERMOS', '');
INSERT INTO `brand` VALUES ('712', null, 'THIERRY MUGLER', '');
INSERT INTO `brand` VALUES ('713', null, 'THOMAS SABO', '');
INSERT INTO `brand` VALUES ('714', null, 'TIFFANY & CO', '');
INSERT INTO `brand` VALUES ('715', null, 'TIGER OF SWEDEN', '');
INSERT INTO `brand` VALUES ('716', null, 'TIMBERLAND', '');
INSERT INTO `brand` VALUES ('717', null, 'TISSOT', '');
INSERT INTO `brand` VALUES ('718', null, 'TOD’S', '');
INSERT INTO `brand` VALUES ('719', null, 'TOKYO DESIGN', '');
INSERT INTO `brand` VALUES ('720', null, 'TOM FORD', '');
INSERT INTO `brand` VALUES ('721', null, 'TOMMY HILFIGER', '');
INSERT INTO `brand` VALUES ('722', null, 'TOO COOL FOR SCHOOL', '');
INSERT INTO `brand` VALUES ('723', null, 'TOPSHOP', '');
INSERT INTO `brand` VALUES ('724', null, 'TORY BURCH', '');
INSERT INTO `brand` VALUES ('725', null, 'TRECA', '');
INSERT INTO `brand` VALUES ('726', null, 'TRIUMPH', '');
INSERT INTO `brand` VALUES ('727', null, 'TROIZENFANTS', '');
INSERT INTO `brand` VALUES ('728', null, 'TRUSSARDI', '');
INSERT INTO `brand` VALUES ('729', null, 'TUDOR', '');
INSERT INTO `brand` VALUES ('730', null, 'TUMI', '');
INSERT INTO `brand` VALUES ('731', null, 'TURPAULT', '');
INSERT INTO `brand` VALUES ('732', null, 'TY BEANNIE BOOS', '');
INSERT INTO `brand` VALUES ('733', null, 'UGG', '');
INSERT INTO `brand` VALUES ('734', null, 'ULYSSE NARDIN', '');
INSERT INTO `brand` VALUES ('735', null, 'UNITED NUDE', '');
INSERT INTO `brand` VALUES ('736', null, 'URBAN OUTFITTERS', '');
INSERT INTO `brand` VALUES ('737', null, 'VACHERON CONSTANTIN', '');
INSERT INTO `brand` VALUES ('738', null, 'VALENTINO', '');
INSERT INTO `brand` VALUES ('739', null, 'VALEXTRA', '');
INSERT INTO `brand` VALUES ('740', null, 'VAN CLEEF & ARPELS', '');
INSERT INTO `brand` VALUES ('741', null, 'VAN LAACK', '');
INSERT INTO `brand` VALUES ('742', null, 'VAN’S', '');
INSERT INTO `brand` VALUES ('743', null, 'VANESSA BRUNO', '');
INSERT INTO `brand` VALUES ('744', null, 'VANITY FAIR', '');
INSERT INTO `brand` VALUES ('745', null, 'VERSACE', '');
INSERT INTO `brand` VALUES ('746', null, 'VERTU', '');
INSERT INTO `brand` VALUES ('747', null, 'VICOMTE ARTHUR', '');
INSERT INTO `brand` VALUES ('748', null, 'VICTORIA BECKHAM', '');
INSERT INTO `brand` VALUES ('749', null, 'VICTORINOX', '');
INSERT INTO `brand` VALUES ('750', null, 'VIKTOR & ROLF', '');
INSERT INTO `brand` VALUES ('751', null, 'VILLEROY ET BOCH', '');
INSERT INTO `brand` VALUES ('752', null, 'VIVARAISE', '');
INSERT INTO `brand` VALUES ('753', null, 'VIVIENNE WESTWOOD', '');
INSERT INTO `brand` VALUES ('754', null, 'VOLCOM', '');
INSERT INTO `brand` VALUES ('755', null, 'VTECH', '');
INSERT INTO `brand` VALUES ('756', null, 'VUE PANORAMIQUE', '');
INSERT INTO `brand` VALUES ('757', null, 'VULLI', '');
INSERT INTO `brand` VALUES ('758', null, 'WACOAL', '');
INSERT INTO `brand` VALUES ('759', null, 'WATERMAN', '');
INSERT INTO `brand` VALUES ('760', null, 'WEILL', '');
INSERT INTO `brand` VALUES ('761', null, 'WELLICIOUS', '');
INSERT INTO `brand` VALUES ('762', null, 'WESTON', '');
INSERT INTO `brand` VALUES ('763', null, 'WHAT FOR', '');
INSERT INTO `brand` VALUES ('764', null, 'WINKLER', '');
INSERT INTO `brand` VALUES ('765', null, 'WISMER', '');
INSERT INTO `brand` VALUES ('766', null, 'WOLFORD', '');
INSERT INTO `brand` VALUES ('767', null, 'WOLY', '');
INSERT INTO `brand` VALUES ('768', null, 'WONDERBRA', '');
INSERT INTO `brand` VALUES ('769', null, 'WOOLRICH', '');
INSERT INTO `brand` VALUES ('770', null, 'Y Y3', '');
INSERT INTO `brand` VALUES ('771', null, 'YAM', '');
INSERT INTO `brand` VALUES ('772', null, 'YEEZY BY ADIDAS', '');
INSERT INTO `brand` VALUES ('773', null, 'YEP', '');
INSERT INTO `brand` VALUES ('774', null, 'YOGA SEARCHER', '');
INSERT INTO `brand` VALUES ('775', null, 'YUJ', '');
INSERT INTO `brand` VALUES ('776', null, 'YVES DELORME', '');
INSERT INTO `brand` VALUES ('777', null, 'YVES SALOMON', '');
INSERT INTO `brand` VALUES ('778', null, 'Z ZADIG & VOLTAIRE', '');
INSERT INTO `brand` VALUES ('779', null, 'ZAK', '');
INSERT INTO `brand` VALUES ('780', null, 'ZAPA', '');
INSERT INTO `brand` VALUES ('781', null, 'ZARA', '');
INSERT INTO `brand` VALUES ('782', null, 'ZEGNA', '');
INSERT INTO `brand` VALUES ('783', null, 'ZENITH', '');
INSERT INTO `brand` VALUES ('784', null, 'ZWILLING', '');
INSERT INTO `brand` VALUES ('785', null, 'Autres', '');
INSERT INTO `brand` VALUES ('786', null, '10 IS', '');
INSERT INTO `brand` VALUES ('787', null, '7 FOR ALL MANKIND', '');

-- ----------------------------
-- Table structure for close_day
-- ----------------------------
DROP TABLE IF EXISTS `close_day`;
CREATE TABLE `close_day` (
  `close_day_id` int(11) NOT NULL auto_increment,
  `shop_id` int(11) NOT NULL,
  `close_date` date NOT NULL,
  PRIMARY KEY  (`close_day_id`),
  KEY `shop_id` (`shop_id`),
  CONSTRAINT `close_day_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Таблица с днями-исключениями для';

-- ----------------------------
-- Records of close_day
-- ----------------------------

-- ----------------------------
-- Table structure for content
-- ----------------------------
DROP TABLE IF EXISTS `content`;
CREATE TABLE `content` (
  `content_id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) default NULL,
  `language_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `uri` varchar(255) NOT NULL,
  `priority` int(11) NOT NULL,
  `meta_title` varchar(255) NOT NULL,
  `meta_h1` varchar(255) NOT NULL,
  `meta_keys` tinytext NOT NULL,
  `meta_desc` tinytext NOT NULL,
  `content` mediumtext NOT NULL,
  `cdate` datetime NOT NULL,
  `udate` datetime NOT NULL,
  PRIMARY KEY  (`content_id`),
  KEY `parent_id` (`parent_id`),
  KEY `uri` (`uri`),
  KEY `language_id` (`language_id`),
  CONSTRAINT `content_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `content` (`content_id`),
  CONSTRAINT `language_id` FOREIGN KEY (`language_id`) REFERENCES `language` (`language_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Таблица статических страниц\r\n';

-- ----------------------------
-- Records of content
-- ----------------------------
INSERT INTO `content` VALUES ('16', null, '1', '404', '404.html', '10000', '404', '', '', '', '<h1>Здрасьте, приехали!</h1>\r\n<p>Запрашиваемой страницы никогда не было на нашем сайте или она была удалена.<br>\r\n                    Если вы считаете, что кто-то тут не прав, <a href=\"mailto:support@libereyes.com\" _mce_href=\"mailto:info@libereyes.com\">пишите</a> — разберемся.</p>', '2014-01-29 14:16:58', '2015-08-13 14:25:48');
INSERT INTO `content` VALUES ('17', null, '1', 'Контакты', 'contacts', '1', 'Контакты', 'Контакты', '', '', '<p>Контактная информация</p><p>\r\nАдрес: 711, Post Street, 94109, San Francisco, USA\r\n</p><p>Email: <a href=\"mailto:info@libereye.com\" _mce_href=\"mailto:info@libereye.com\">info@libereye.com</a></p>', '2015-08-13 14:22:12', '0000-00-00 00:00:00');
INSERT INTO `content` VALUES ('18', null, '1', 'О сайте', 'about', '2', 'О сайте', 'О сайте', 'О сайте', 'О сайте', '<p><span style=\"font-size: medium;\">\"Либер-Aй\" - консьерж сервис дистанционного заказа товаров за рубежом, с уникальной функцией телеприсутствия в самых знаменитых магазинах Европы.</span><br _mce_bogus=\"1\"></p>', '2015-08-13 14:24:25', '0000-00-00 00:00:00');
INSERT INTO `content` VALUES ('19', null, '1', 'Инструкция', 'instructions', '3', 'Инструкция', 'Инструкция', 'Инструкция', 'Инструкция', '<p><br _mce_bogus=\"1\"></p>', '2015-08-19 17:09:43', '2015-08-19 17:10:14');
INSERT INTO `content` VALUES ('20', null, '1', 'Mагазины', 'shops', '4', 'Mагазины', 'Mагазины', 'Mагазины', 'Mагазины', '<p><br _mce_bogus=\"1\"></p>', '2015-08-19 17:15:18', '2015-08-19 17:15:25');
INSERT INTO `content` VALUES ('21', null, '1', 'Партнерам', 'partners', '5', 'Партнерам', 'Партнерам', 'Партнерам', '', '<p><br _mce_bogus=\"1\"></p>', '2015-08-19 17:16:27', '0000-00-00 00:00:00');
INSERT INTO `content` VALUES ('22', null, '1', 'Главная', 'main', '-1', 'LiberEye', 'LiberEye', 'LiberEye', 'LiberEye', '<aside class=\"aside-col\" style=\"width:400px;\" _mce_style=\"width: 400px;\">\r\n<div class=\"widget ad\" style=\"padding:10px 0 10px 12px;\" _mce_style=\"padding: 10px 0 10px 12px;\">\r\n	<div class=\"banner aside big\" style=\"width:376px;height:291px;min-height:291px;\" _mce_style=\"width: 376px; height: 291px; min-height: 291px;\">\r\n        <iframe height=\"100%\" width=\"100%\" allowfullscreen=\"\" frameborder=\"0\" src=\"//www.youtube.com/embed/HgJbi99htfI?wmode=transparent&amp;autoplay=0&amp;theme=dark&amp;controls=0&amp;autohide=0&amp;loop=0&amp;showinfo=1&amp;rel=0&amp;playlist=false&amp;enablejsapi=0\" _mce_src=\"http://www.youtube.com/embed/HgJbi99htfI?wmode=transparent&amp;autoplay=0&amp;theme=dark&amp;controls=0&amp;autohide=0&amp;loop=0&amp;showinfo=1&amp;rel=0&amp;playlist=false&amp;enablejsapi=0\"></iframe>\r\n	</div>\r\n</div>\r\n{SUBSCRIBE_FORM}\r\n    <br>\r\n</aside>\r\n<div class=\"main-col\" style=\"margin-right: 420px;\" _mce_style=\"margin-right: 420px;\">\r\n\r\n	<div class=\"feeds-container\">\r\n        <div data-feed=\"feed\" data-wait-load=\"true\" data-col-min-width=\"260\" data-autoresize=\"true\" class=\"feed feed-news\" style=\"text-align: center;\">\r\n            <article class=\"post post-news\"><div class=\"post-wrapper\">\r\n            <div class=\"post-content\">\r\n            <header class=\"post-header\">\r\n                <h3 class=\"post-title post-title-small\"><span style=\"font-size: 25px;\" _mce_style=\"font-size: 25px;\">Воспользуйтесь уникальной возможностью прямого доступа в лучшие магазины Европы с помощью сервиса LiberEye! Оцените его возможности и преимущества!</span></h3>\r\n            </header>\r\n            </div>\r\n            </div>\r\n            </article>\r\n            <article class=\"post post-news\"><div class=\"post-wrapper\">\r\n            <div class=\"post-content\">\r\n            <header class=\"post-header\">\r\n                <h3 class=\"post-title post-title-small\"><span style=\"font-size: 25px;\" _mce_style=\"font-size: 25px;\">LiberEye открывает для Вас двери лучших магазинов Европы и дарит привилегированный шанс совершить эксклюзивный тур в легендарные магазины \"Galeries Lafayette\" вместе с нами и в сопровождении индивидуального гида.</span></h3>\r\n            </header>\r\n            </div>\r\n            </div>\r\n            </article>\r\n            <article class=\"post post-news\"><div class=\"post-wrapper\">\r\n            <div class=\"post-content\">\r\n            <header class=\"post-header\">\r\n                <h3 class=\"post-title post-title-small\"><span style=\"font-size: 25px;\" _mce_style=\"font-size: 25px;\">Воспользуйтесь услугой профессионального помощника - русскоговорящего шоппинг гида для знакомства с последними коллекциями ведущих мировых брендов.</span></h3>\r\n            </header>\r\n            </div>\r\n            </div>\r\n            </article>\r\n\r\n\r\n\r\n            <iframe width=\"560\" height=\"315\" src=\"http://www.youtube.com/embed/7k5GfaFHCpo?wmode=transparent\" _mce_src=\"http://www.youtube.com/embed/7k5GfaFHCpo?wmode=transparent\" frameborder=\"0\" allowfullscreen=\"\"></iframe><br>\r\n            <br>\r\n            <br>\r\n            <br>\r\n            <br>\r\n            <br>\r\n            <br>\r\n            <br>\r\n\r\n        </div>\r\n    </div>\r\n</div>', '2015-09-09 15:49:05', '2015-09-21 11:26:18');
INSERT INTO `content` VALUES ('23', null, '2', '404', '404.html', '10000', '404', '', '', '', '<h1>Здрасьте, приехали!</h1>\r\n<p>Запрашиваемой страницы никогда не было на нашем сайте или она была удалена.<br>\r\n                    Если вы считаете, что кто-то тут не прав, <a href=\"mailto:support@libereyes.com\" _mce_href=\"mailto:info@libereyes.com\">пишите</a> — разберемся.</p>', '2014-01-29 14:16:58', '2015-08-13 14:25:48');
INSERT INTO `content` VALUES ('24', null, '2', 'Контакты', 'contacts', '1', 'Контакты', 'Контакты', '', '', '<p>Контактная информация</p><p>\r\nАдрес: 711, Post Street, 94109, San Francisco, USA\r\n</p><p>Email: <a href=\"mailto:info@libereye.com\" _mce_href=\"mailto:info@libereye.com\">info@libereye.com</a></p>', '2015-08-13 14:22:12', '0000-00-00 00:00:00');
INSERT INTO `content` VALUES ('25', null, '2', 'О сайте', 'about', '2', 'О сайте', 'О сайте', 'О сайте', 'О сайте', '<p><span style=\"font-size: medium;\">\"Либер-Aй\" - консьерж сервис дистанционного заказа товаров за рубежом, с уникальной функцией телеприсутствия в самых знаменитых магазинах Европы.</span><br _mce_bogus=\"1\"></p>', '2015-08-13 14:24:25', '0000-00-00 00:00:00');
INSERT INTO `content` VALUES ('26', null, '2', 'Инструкция', 'instructions', '3', 'Инструкция', 'Инструкция', 'Инструкция', 'Инструкция', '<p><br _mce_bogus=\"1\"></p>', '2015-08-19 17:09:43', '2015-08-19 17:10:14');
INSERT INTO `content` VALUES ('27', null, '2', 'Mагазины', 'shops', '4', 'Mагазины', 'Mагазины', 'Mагазины', 'Mагазины', '<p><br _mce_bogus=\"1\"></p>', '2015-08-19 17:15:18', '2015-08-19 17:15:25');
INSERT INTO `content` VALUES ('28', null, '2', 'Партнерам', 'partners', '5', 'Партнерам', 'Партнерам', 'Партнерам', '', '<p><br _mce_bogus=\"1\"></p>', '2015-08-19 17:16:27', '0000-00-00 00:00:00');
INSERT INTO `content` VALUES ('29', null, '2', 'Home', 'main', '-1', 'LiberEye', 'LiberEye', 'LiberEye', 'LiberEye', '<aside class=\"aside-col\" style=\"width:400px;\" _mce_style=\"width: 400px;\">\r\n<div class=\"widget ad\" style=\"padding:10px 0 10px 12px;\" _mce_style=\"padding: 10px 0 10px 12px;\">\r\n	<div class=\"banner aside big\" style=\"width:376px;height:291px;min-height:291px;\" _mce_style=\"width: 376px; height: 291px; min-height: 291px;\">\r\n        <iframe height=\"100%\" width=\"100%\" allowfullscreen=\"\" frameborder=\"0\" src=\"//www.youtube.com/embed/HgJbi99htfI?wmode=transparent&amp;autoplay=0&amp;theme=dark&amp;controls=0&amp;autohide=0&amp;loop=0&amp;showinfo=1&amp;rel=0&amp;playlist=false&amp;enablejsapi=0\" _mce_src=\"http://www.youtube.com/embed/HgJbi99htfI?wmode=transparent&amp;autoplay=0&amp;theme=dark&amp;controls=0&amp;autohide=0&amp;loop=0&amp;showinfo=1&amp;rel=0&amp;playlist=false&amp;enablejsapi=0\"></iframe>\r\n	</div>\r\n</div>\r\n{SUBSCRIBE_FORM}\r\n    <br>\r\n</aside>\r\n<div class=\"main-col\" style=\"margin-right: 420px;\" _mce_style=\"margin-right: 420px;\">\r\n\r\n	<div class=\"feeds-container\">\r\n        <div data-feed=\"feed\" data-wait-load=\"true\" data-col-min-width=\"260\" data-autoresize=\"true\" class=\"feed feed-news\">\r\n            <article class=\"post post-news\"><div class=\"post-wrapper\">\r\n            <div class=\"post-content\">\r\n            <header class=\"post-header\">\r\n                <h3 class=\"post-title post-title-small\"><span style=\"font-size: 25px;\" _mce_style=\"font-size: 25px;\">Take advantage of the unique opportunity of direct access to the best shopping in Europe with the help of service LiberEye! Rate features and benefits!</span></h3>\r\n            </header>\r\n            </div>\r\n            </div>\r\n            </article>\r\n            <article class=\"post post-news\"><div class=\"post-wrapper\">\r\n            <div class=\"post-content\">\r\n            <header class=\"post-header\">\r\n                <h3 class=\"post-title post-title-small\"><span style=\"font-size: 25px;\" _mce_style=\"font-size: 25px;\">LiberEye opens doors for you the best shopping in Europe and gives a privileged opportunity to make an exclusive tour of the legendary stores \"Galeries Lafayette\" with us and accompanied by a personal guide.</span></h3>\r\n            </header>\r\n            </div>\r\n            </div>\r\n            </article>\r\n            <article class=\"post post-news\"><div class=\"post-wrapper\">\r\n            <div class=\"post-content\">\r\n            <header class=\"post-header\">\r\n                <h3 class=\"post-title post-title-small\"><span style=\"font-size: 25px;\" _mce_style=\"font-size: 25px;\">Use the services of a professional assistant - Russian-speaking shopping guides to explore the latest collections of the world\'s leading brands.</span></h3>\r\n            </header>\r\n            </div>\r\n            </div>\r\n            </article>\r\n\r\n\r\n\r\n            <br>\r\n            <br>\r\n            <br>\r\n            <br>\r\n            <br>\r\n            <br>\r\n            <br>\r\n            <br>\r\n\r\n        </div>\r\n    </div>\r\n</div>', '2015-09-09 15:49:05', '2015-09-09 20:34:55');
INSERT INTO `content` VALUES ('30', null, '3', '404', '404.html', '10000', '404', '', '', '', '<h1>Здрасьте, приехали!</h1>\r\n<p>Запрашиваемой страницы никогда не было на нашем сайте или она была удалена.<br>\r\n                    Если вы считаете, что кто-то тут не прав, <a href=\"mailto:support@libereyes.com\" _mce_href=\"mailto:info@libereyes.com\">пишите</a> — разберемся.</p>', '2014-01-29 14:16:58', '2015-08-13 14:25:48');
INSERT INTO `content` VALUES ('31', null, '3', 'Контакты', 'contacts', '1', 'Контакты', 'Контакты', '', '', '<p>Контактная информация</p><p>\r\nАдрес: 711, Post Street, 94109, San Francisco, USA\r\n</p><p>Email: <a href=\"mailto:info@libereye.com\" _mce_href=\"mailto:info@libereye.com\">info@libereye.com</a></p>', '2015-08-13 14:22:12', '0000-00-00 00:00:00');
INSERT INTO `content` VALUES ('32', null, '3', 'О сайте', 'about', '2', 'О сайте', 'О сайте', 'О сайте', 'О сайте', '<p><span style=\"font-size: medium;\">\"Либер-Aй\" - консьерж сервис дистанционного заказа товаров за рубежом, с уникальной функцией телеприсутствия в самых знаменитых магазинах Европы.</span><br _mce_bogus=\"1\"></p>', '2015-08-13 14:24:25', '0000-00-00 00:00:00');
INSERT INTO `content` VALUES ('33', null, '3', 'Инструкция', 'instructions', '3', 'Инструкция', 'Инструкция', 'Инструкция', 'Инструкция', '<p><br _mce_bogus=\"1\"></p>', '2015-08-19 17:09:43', '2015-08-19 17:10:14');
INSERT INTO `content` VALUES ('34', null, '3', 'Mагазины', 'shops', '4', 'Mагазины', 'Mагазины', 'Mагазины', 'Mагазины', '<p><br _mce_bogus=\"1\"></p>', '2015-08-19 17:15:18', '2015-08-19 17:15:25');
INSERT INTO `content` VALUES ('35', null, '3', 'Партнерам', 'partners', '5', 'Партнерам', 'Партнерам', 'Партнерам', '', '<p><br _mce_bogus=\"1\"></p>', '2015-08-19 17:16:27', '0000-00-00 00:00:00');
INSERT INTO `content` VALUES ('36', null, '3', 'Accueil', 'main', '-1', 'LiberEye', 'LiberEye', 'LiberEye', 'LiberEye', '<aside class=\"aside-col\" style=\"width:400px;\" _mce_style=\"width: 400px;\">\r\n<div class=\"widget ad\" style=\"padding:10px 0 10px 12px;\" _mce_style=\"padding: 10px 0 10px 12px;\">\r\n	<div class=\"banner aside big\" style=\"width:376px;height:291px;min-height:291px;\" _mce_style=\"width: 376px; height: 291px; min-height: 291px;\">\r\n        <iframe height=\"100%\" width=\"100%\" allowfullscreen=\"\" frameborder=\"0\" src=\"//www.youtube.com/embed/HgJbi99htfI?wmode=transparent&amp;autoplay=0&amp;theme=dark&amp;controls=0&amp;autohide=0&amp;loop=0&amp;showinfo=1&amp;rel=0&amp;playlist=false&amp;enablejsapi=0\" _mce_src=\"http://www.youtube.com/embed/HgJbi99htfI?wmode=transparent&amp;autoplay=0&amp;theme=dark&amp;controls=0&amp;autohide=0&amp;loop=0&amp;showinfo=1&amp;rel=0&amp;playlist=false&amp;enablejsapi=0\"></iframe>\r\n	</div>\r\n</div>\r\n{SUBSCRIBE_FORM}\r\n    <br>\r\n</aside>\r\n<div class=\"main-col\" style=\"margin-right: 420px;\" _mce_style=\"margin-right: 420px;\">\r\n\r\n	<div class=\"feeds-container\">\r\n        <div data-feed=\"feed\" data-wait-load=\"true\" data-col-min-width=\"260\" data-autoresize=\"true\" class=\"feed feed-news\">\r\n            <article class=\"post post-news\"><div class=\"post-wrapper\">\r\n            <div class=\"post-content\">\r\n            <header class=\"post-header\">\r\n                <h3 class=\"post-title post-title-small\"><span style=\"font-size: 25px;\" _mce_style=\"font-size: 25px;\">Profitez de l\'occasion unique d\'accès direct aux meilleures boutiques en Europe, avec l\'aide du service LiberEye! Caractéristiques et les avantages noter!</span></h3>\r\n            </header>\r\n            </div>\r\n            </div>\r\n            </article>\r\n            <article class=\"post post-news\"><div class=\"post-wrapper\">\r\n            <div class=\"post-content\">\r\n            <header class=\"post-header\">\r\n                <h3 class=\"post-title post-title-small\"><span style=\"font-size: 25px;\" _mce_style=\"font-size: 25px;\">LiberEye ouvre des portes pour vous les meilleurs commerciaux en Europe et donne une occasion privilégiée de faire une visite exclusive des magasins légendaires \"Galeries Lafayette\" avec nous et accompagné par un guide personnel.</span></h3>\r\n            </header>\r\n            </div>\r\n            </div>\r\n            </article>\r\n            <article class=\"post post-news\"><div class=\"post-wrapper\">\r\n            <div class=\"post-content\">\r\n            <header class=\"post-header\">\r\n                <h3 class=\"post-title post-title-small\"><span style=\"font-size: 25px;\" _mce_style=\"font-size: 25px;\">Utilisez les services d\'un assistant professionnel - russophones guides shopping à explorer les dernières collections des plus grandes marques du monde.</span></h3>\r\n            </header>\r\n            </div>\r\n            </div>\r\n            </article>\r\n\r\n\r\n\r\n            <br>\r\n            <br>\r\n            <br>\r\n            <br>\r\n            <br>\r\n            <br>\r\n            <br>\r\n            <br>\r\n\r\n        </div>\r\n    </div>\r\n</div>', '2015-09-09 15:49:05', '2015-09-09 20:26:47');

-- ----------------------------
-- Table structure for country
-- ----------------------------
DROP TABLE IF EXISTS `country`;
CREATE TABLE `country` (
  `country_id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL,
  `code2` varchar(2) NOT NULL,
  `code3` varchar(3) NOT NULL,
  PRIMARY KEY  (`country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Страны';

-- ----------------------------
-- Records of country
-- ----------------------------
INSERT INTO `country` VALUES ('1', 'Россия', 'RU', 'RUS');

-- ----------------------------
-- Table structure for currency
-- ----------------------------
DROP TABLE IF EXISTS `currency`;
CREATE TABLE `currency` (
  `currency_id` int(11) NOT NULL,
  `code` varchar(3) NOT NULL,
  PRIMARY KEY  (`currency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of currency
-- ----------------------------
INSERT INTO `currency` VALUES ('1', 'EUR');
INSERT INTO `currency` VALUES ('2', 'USD');

-- ----------------------------
-- Table structure for image
-- ----------------------------
DROP TABLE IF EXISTS `image`;
CREATE TABLE `image` (
  `image_id` int(11) NOT NULL auto_increment,
  `object_type` enum('purchase','country','language') NOT NULL,
  `object_id` int(11) default NULL,
  `name` varchar(255) NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `md5_file` varchar(32) NOT NULL,
  `cdate` datetime NOT NULL,
  PRIMARY KEY  (`image_id`),
  KEY `md5_file` (`md5_file`),
  KEY `object_type` (`object_type`,`object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of image
-- ----------------------------
INSERT INTO `image` VALUES ('2', 'purchase', '67', '8/7/d/87d21970482aab73a0a4c439f433faac.jpg', '788', '380', 'bdea1d280a36deacad22cd661c0666c5', '2015-08-17 16:37:53');
INSERT INTO `image` VALUES ('3', 'purchase', '67', 'd/9/5/d956c5879310cb249bf50907b47d2485.jpg', '731', '826', '6267f858da8d7a54361ccb6403b3b7e6', '2015-08-17 16:37:53');
INSERT INTO `image` VALUES ('9', 'purchase', '66', 'e/3/a/e3abfdc517739a713c5314ce419b6be1.jpg', '2283', '6279', 'f4bd66d53cf1d691f93423460204b840', '2015-08-17 17:15:19');
INSERT INTO `image` VALUES ('10', 'purchase', '66', 'c/e/3/ce335ce072e7a84ac14899e33fe30f34.JPG', '640', '478', 'afd1ca491e28e5ceeb464d618de9df74', '2015-08-17 17:15:26');
INSERT INTO `image` VALUES ('11', 'purchase', '68', 'f/6/8/f687864134eb84d67d1029277bd1ee8c.jpg', '3032', '1704', '6c292791214d3e52c9b86cacd1482e24', '2015-11-19 14:40:55');
INSERT INTO `image` VALUES ('12', 'purchase', '68', '0/a/c/0ac14b820e8c7ef66b95c4f6f0c0b31a.jpg', '3016', '1696', '58fe231dd346fbeb8f197cf2d08ab37e', '2015-11-19 14:49:27');
INSERT INTO `image` VALUES ('13', 'purchase', '68', 'c/f/1/cf1d83501e6999875c262b7c89be43a1.jpg', '2000', '3552', '3119ffa4653e2e6a69acda9bb038754a', '2015-11-19 14:49:27');
INSERT INTO `image` VALUES ('14', 'purchase', '60', '5/c/d/5cdb2abb6f228a8321aa4551a267e954.jpg', '3016', '1696', '58fe231dd346fbeb8f197cf2d08ab37e', '2015-11-19 14:50:01');
INSERT INTO `image` VALUES ('15', 'purchase', '60', '0/3/4/0349354d80144acf10955fd0c1397d8d.jpg', '2000', '3552', '3119ffa4653e2e6a69acda9bb038754a', '2015-11-19 14:50:01');
INSERT INTO `image` VALUES ('16', 'purchase', '60', 'a/e/6/ae6fc74af42ac4243b51837a6b3a010d.jpg', '3032', '1704', '6c292791214d3e52c9b86cacd1482e24', '2015-11-19 14:55:46');
INSERT INTO `image` VALUES ('17', 'purchase', '69', '2/d/e/2de1b8a07a7507f62de5cd3ed394597b.jpg', '3016', '1696', '58fe231dd346fbeb8f197cf2d08ab37e', '2015-11-19 14:56:52');
INSERT INTO `image` VALUES ('18', 'purchase', '69', 'b/8/c/b8c12a631447339045946a1624e4a829.jpg', '2000', '3552', '3119ffa4653e2e6a69acda9bb038754a', '2015-11-19 14:56:53');

-- ----------------------------
-- Table structure for language
-- ----------------------------
DROP TABLE IF EXISTS `language`;
CREATE TABLE `language` (
  `language_id` int(11) NOT NULL auto_increment,
  `title` varchar(50) NOT NULL,
  `alias` varchar(3) NOT NULL,
  `is_default` tinyint(4) NOT NULL,
  PRIMARY KEY  (`language_id`),
  UNIQUE KEY `alias` (`alias`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of language
-- ----------------------------
INSERT INTO `language` VALUES ('1', 'Русский', 'ru', '1');
INSERT INTO `language` VALUES ('2', 'English', 'en', '0');
INSERT INTO `language` VALUES ('3', 'Français', 'fr', '0');

-- ----------------------------
-- Table structure for lang_phrase
-- ----------------------------
DROP TABLE IF EXISTS `lang_phrase`;
CREATE TABLE `lang_phrase` (
  `lang_phrase_id` int(11) NOT NULL auto_increment,
  `language_id` int(11) NOT NULL,
  `object_type_id` int(11) NOT NULL,
  `object_field` varchar(50) NOT NULL,
  `object_id` int(11) NOT NULL,
  `alias` varchar(255) NOT NULL,
  `phrase` text NOT NULL,
  PRIMARY KEY  (`lang_phrase_id`),
  UNIQUE KEY `language_id_2` USING BTREE (`language_id`,`alias`,`object_type_id`,`object_field`),
  KEY `language_id` (`language_id`),
  KEY `alias` (`alias`),
  KEY `object_id` (`object_id`),
  KEY `object_type` (`object_type_id`),
  KEY `object_field` (`object_field`),
  CONSTRAINT `lang_phrase_ibfk_1` FOREIGN KEY (`language_id`) REFERENCES `language` (`language_id`),
  CONSTRAINT `lang_phrase_ibfk_2` FOREIGN KEY (`object_type_id`) REFERENCES `object_type` (`object_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of lang_phrase
-- ----------------------------
INSERT INTO `lang_phrase` VALUES ('4', '1', '1', '', '0', 'We will inform you about the launch of the service', 'Мы сообщим вам о запуске сервиса');
INSERT INTO `lang_phrase` VALUES ('5', '2', '1', '', '0', 'We will inform you about the launch of the service', 'We will inform you about the launch of the service');
INSERT INTO `lang_phrase` VALUES ('6', '3', '1', '', '0', 'We will inform you about the launch of the service', 'Nous allons vous informer sur le lancement du serviceй');
INSERT INTO `lang_phrase` VALUES ('46', '1', '1', '', '0', 'Name', 'Имя');
INSERT INTO `lang_phrase` VALUES ('47', '2', '1', '', '0', 'Name', 'Name');
INSERT INTO `lang_phrase` VALUES ('48', '3', '1', '', '0', 'Name', 'Prénom');
INSERT INTO `lang_phrase` VALUES ('49', '1', '1', '', '0', 'Learn first', 'Узнайте первыми');
INSERT INTO `lang_phrase` VALUES ('50', '2', '1', '', '0', 'Learn first', 'Learn first');
INSERT INTO `lang_phrase` VALUES ('51', '3', '1', '', '0', 'Learn first', 'Apprenez d\'abord');
INSERT INTO `lang_phrase` VALUES ('52', '1', '1', '', '0', 'Email', 'Электронная почта');
INSERT INTO `lang_phrase` VALUES ('53', '2', '1', '', '0', 'Email', 'Email');
INSERT INTO `lang_phrase` VALUES ('54', '3', '1', '', '0', 'Email', 'Email');
INSERT INTO `lang_phrase` VALUES ('55', '1', '1', '', '0', 'My purchases', 'мои покупки');
INSERT INTO `lang_phrase` VALUES ('56', '2', '1', '', '0', 'My purchases', 'My purchases');
INSERT INTO `lang_phrase` VALUES ('57', '3', '1', '', '0', 'My purchases', 'Mes achats');
INSERT INTO `lang_phrase` VALUES ('58', '1', '1', '', '0', 'Booking', 'бронирование ');
INSERT INTO `lang_phrase` VALUES ('59', '2', '1', '', '0', 'Booking', 'Booking');
INSERT INTO `lang_phrase` VALUES ('60', '3', '1', '', '0', 'Booking', 'Réservation');
INSERT INTO `lang_phrase` VALUES ('61', '1', '1', '', '0', 'Settings', 'Настройки');
INSERT INTO `lang_phrase` VALUES ('62', '2', '1', '', '0', 'Settings', 'Settings');
INSERT INTO `lang_phrase` VALUES ('63', '3', '1', '', '0', 'Settings', 'Paramètres');
INSERT INTO `lang_phrase` VALUES ('64', '1', '1', '', '0', 'Exit', 'выйти');
INSERT INTO `lang_phrase` VALUES ('65', '2', '1', '', '0', 'Exit', 'Exit');
INSERT INTO `lang_phrase` VALUES ('66', '3', '1', '', '0', 'Exit', 'Sortie');
INSERT INTO `lang_phrase` VALUES ('67', '1', '1', '', '0', 'The service works in test mode', 'СЕРВИС РАБОТАЕТ В ТЕСТОВОМ РЕЖИМЕ, ЗАКАЗЫ НЕ ПРИНИМАЮТСЯ, КЛИЕНТЫ НЕ ОБСЛУЖИВАЮТСЯ!');
INSERT INTO `lang_phrase` VALUES ('68', '2', '1', '', '0', 'The service works in test mode', 'The service works in test mode, the order is not accepted, the client does not service!');
INSERT INTO `lang_phrase` VALUES ('69', '3', '1', '', '0', 'The service works in test mode', 'Le service fonctionne en mode de test, l\'ordre ne sont pas acceptées, le client ne dessert pas!');
INSERT INTO `lang_phrase` VALUES ('70', '1', '1', '', '0', 'Welcome LiberEye', 'Вас приветствует LiberEye');
INSERT INTO `lang_phrase` VALUES ('71', '2', '1', '', '0', 'Welcome LiberEye', 'Welcome LiberEye');
INSERT INTO `lang_phrase` VALUES ('72', '3', '1', '', '0', 'Welcome LiberEye', 'Bienvenue LiberEye');
INSERT INTO `lang_phrase` VALUES ('73', '1', '1', '', '0', 'Login', 'Войти');
INSERT INTO `lang_phrase` VALUES ('74', '2', '1', '', '0', 'Login', 'Login');
INSERT INTO `lang_phrase` VALUES ('75', '3', '1', '', '0', 'Login', 'Connexion');
INSERT INTO `lang_phrase` VALUES ('76', '1', '1', '', '0', 'Register', 'Регистрация');
INSERT INTO `lang_phrase` VALUES ('77', '2', '1', '', '0', 'Register', 'Register');
INSERT INTO `lang_phrase` VALUES ('78', '3', '1', '', '0', 'Register', 'Inscription');
INSERT INTO `lang_phrase` VALUES ('79', '1', '1', '', '0', 'Meetings', 'митинги');
INSERT INTO `lang_phrase` VALUES ('80', '2', '1', '', '0', 'Meetings', 'Meetings');
INSERT INTO `lang_phrase` VALUES ('81', '3', '1', '', '0', 'Meetings', 'Rassemblements');
INSERT INTO `lang_phrase` VALUES ('82', '1', '1', '', '0', 'Purchases', 'Покупки');
INSERT INTO `lang_phrase` VALUES ('83', '2', '1', '', '0', 'Purchases', 'Purchases');
INSERT INTO `lang_phrase` VALUES ('84', '3', '1', '', '0', 'Purchases', 'Shopping');
INSERT INTO `lang_phrase` VALUES ('85', '1', '1', '', '0', 'Subscribe', 'Подписаться');
INSERT INTO `lang_phrase` VALUES ('86', '2', '1', '', '0', 'Subscribe', 'Subscribe');
INSERT INTO `lang_phrase` VALUES ('87', '3', '1', '', '0', 'Subscribe', 'Abonnez-vous');
INSERT INTO `lang_phrase` VALUES ('88', '1', '1', '', '0', 'Copyright', '© 2015 \"Либер-Aй\" - консьерж сервис дистанционного заказа товаров за рубежом, с уникальной функцией телеприсутствия в самых знаменитых магазинах Европы.');
INSERT INTO `lang_phrase` VALUES ('89', '2', '1', '', '0', 'Copyright', '© 2015 \'Lieber-Ay \"- the concierge service of remote ordering goods overseas, a unique feature of telepresence in the most famous stores in Europe.');
INSERT INTO `lang_phrase` VALUES ('90', '3', '1', '', '0', 'Copyright', '© 2015 »Lieber-Ay\" - le service de conciergerie de produits de commande à distance à l\'étranger, une caractéristique unique de la téléprésence dans les plus grands magasins d\'Europe.');
INSERT INTO `lang_phrase` VALUES ('91', '1', '1', '', '0', 'About', 'О сайте');
INSERT INTO `lang_phrase` VALUES ('92', '2', '1', '', '0', 'About', 'About');
INSERT INTO `lang_phrase` VALUES ('93', '3', '1', '', '0', 'About', 'À propos');
INSERT INTO `lang_phrase` VALUES ('94', '1', '1', '', '0', 'Contacts', 'Контакты');
INSERT INTO `lang_phrase` VALUES ('95', '2', '1', '', '0', 'Contacts', 'Contacts');
INSERT INTO `lang_phrase` VALUES ('96', '3', '1', '', '0', 'Contacts', 'Contacts');
INSERT INTO `lang_phrase` VALUES ('97', '1', '1', '', '0', 'Site Map', 'Карта сайта');
INSERT INTO `lang_phrase` VALUES ('98', '2', '1', '', '0', 'Site Map', 'Site Map');
INSERT INTO `lang_phrase` VALUES ('99', '3', '1', '', '0', 'Site Map', 'Plan du site');
INSERT INTO `lang_phrase` VALUES ('100', '1', '1', '', '0', 'Email editors', 'Email редакции');
INSERT INTO `lang_phrase` VALUES ('101', '2', '1', '', '0', 'Email editors', 'Email editors');
INSERT INTO `lang_phrase` VALUES ('102', '3', '1', '', '0', 'Email editors', 'Email libellé');
INSERT INTO `lang_phrase` VALUES ('103', '1', '1', '', '0', 'Enter the site', 'Вход на сайт');
INSERT INTO `lang_phrase` VALUES ('104', '2', '1', '', '0', 'Enter the site', 'Enter the site');
INSERT INTO `lang_phrase` VALUES ('105', '3', '1', '', '0', 'Enter the site', 'Connectez-vous');
INSERT INTO `lang_phrase` VALUES ('106', '1', '1', '', '0', 'Password', 'Пароль');
INSERT INTO `lang_phrase` VALUES ('107', '2', '1', '', '0', 'Password', 'Password');
INSERT INTO `lang_phrase` VALUES ('108', '3', '1', '', '0', 'Password', 'Mot de passe');
INSERT INTO `lang_phrase` VALUES ('109', '1', '1', '', '0', 'Forgot your password', 'Напомнить пароль');
INSERT INTO `lang_phrase` VALUES ('110', '2', '1', '', '0', 'Forgot your password', 'Forgot your password');
INSERT INTO `lang_phrase` VALUES ('111', '3', '1', '', '0', 'Forgot your password', 'Mot de passe oublié');
INSERT INTO `lang_phrase` VALUES ('112', '1', '1', '', '0', 'Incorrect password or e-mail', 'Неправильный пароль или электронная почта');
INSERT INTO `lang_phrase` VALUES ('113', '2', '1', '', '0', 'Incorrect password or e-mail', 'Incorrect password or e-mail');
INSERT INTO `lang_phrase` VALUES ('114', '3', '1', '', '0', 'Incorrect password or e-mail', 'Mot de passe incorrect ou par e-mail');
INSERT INTO `lang_phrase` VALUES ('115', '1', '1', '', '0', 'Number', 'Номер');
INSERT INTO `lang_phrase` VALUES ('116', '2', '1', '', '0', 'Number', 'Number');
INSERT INTO `lang_phrase` VALUES ('117', '3', '1', '', '0', 'Number', 'Number');
INSERT INTO `lang_phrase` VALUES ('118', '1', '1', '', '0', 'Date', 'Дата');
INSERT INTO `lang_phrase` VALUES ('119', '2', '1', '', '0', 'Date', 'Date');
INSERT INTO `lang_phrase` VALUES ('120', '3', '1', '', '0', 'Date', 'Date');
INSERT INTO `lang_phrase` VALUES ('121', '1', '1', '', '0', 'Seller', 'Продавец');
INSERT INTO `lang_phrase` VALUES ('122', '2', '1', '', '0', 'Seller', 'Seller');
INSERT INTO `lang_phrase` VALUES ('123', '3', '1', '', '0', 'Seller', 'Vendeur');
INSERT INTO `lang_phrase` VALUES ('124', '1', '1', '', '0', 'Description', 'Описание');
INSERT INTO `lang_phrase` VALUES ('125', '2', '1', '', '0', 'Description', 'Description');
INSERT INTO `lang_phrase` VALUES ('126', '3', '1', '', '0', 'Description', 'Description');
INSERT INTO `lang_phrase` VALUES ('127', '1', '1', '', '0', 'Price', 'Стоимость');
INSERT INTO `lang_phrase` VALUES ('128', '2', '1', '', '0', 'Price', 'Price');
INSERT INTO `lang_phrase` VALUES ('129', '3', '1', '', '0', 'Price', 'Cours');
INSERT INTO `lang_phrase` VALUES ('130', '1', '1', '', '0', 'Status', 'Статус');
INSERT INTO `lang_phrase` VALUES ('131', '2', '1', '', '0', 'Status', 'Status');
INSERT INTO `lang_phrase` VALUES ('132', '3', '1', '', '0', 'Status', 'Status');
INSERT INTO `lang_phrase` VALUES ('133', '1', '1', '', '0', 'Pages', 'Страницы');
INSERT INTO `lang_phrase` VALUES ('134', '2', '1', '', '0', 'Pages', 'Pages');
INSERT INTO `lang_phrase` VALUES ('135', '3', '1', '', '0', 'Pages', 'Pages');
INSERT INTO `lang_phrase` VALUES ('136', '1', '1', '', '0', 'First', 'Первая');
INSERT INTO `lang_phrase` VALUES ('137', '2', '1', '', '0', 'First', 'First');
INSERT INTO `lang_phrase` VALUES ('138', '3', '1', '', '0', 'First', 'Premier');
INSERT INTO `lang_phrase` VALUES ('139', '1', '1', '', '0', 'Previous', 'Предыдущая');
INSERT INTO `lang_phrase` VALUES ('140', '2', '1', '', '0', 'Previous', 'Previous');
INSERT INTO `lang_phrase` VALUES ('141', '3', '1', '', '0', 'Previous', 'Antérieur');
INSERT INTO `lang_phrase` VALUES ('142', '1', '1', '', '0', 'Next', 'Следующая');
INSERT INTO `lang_phrase` VALUES ('143', '2', '1', '', '0', 'Next', 'Next');
INSERT INTO `lang_phrase` VALUES ('144', '3', '1', '', '0', 'Next', 'Suivantc');
INSERT INTO `lang_phrase` VALUES ('145', '1', '1', '', '0', 'Last', 'Последняя');
INSERT INTO `lang_phrase` VALUES ('146', '2', '1', '', '0', 'Last', 'Last');
INSERT INTO `lang_phrase` VALUES ('147', '3', '1', '', '0', 'Last', 'Dernier');
INSERT INTO `lang_phrase` VALUES ('148', '1', '1', '', '0', 'Checkout', 'Оплатить');
INSERT INTO `lang_phrase` VALUES ('149', '2', '1', '', '0', 'Checkout', 'Checkout');
INSERT INTO `lang_phrase` VALUES ('150', '3', '1', '', '0', 'Checkout', 'Commander');
INSERT INTO `lang_phrase` VALUES ('151', '1', '1', '', '0', 'The request failed paypal', 'Ошибка запроса paypal');
INSERT INTO `lang_phrase` VALUES ('152', '2', '1', '', '0', 'The request failed paypal', 'The request failed paypal');
INSERT INTO `lang_phrase` VALUES ('153', '3', '1', '', '0', 'The request failed paypal', 'La demande a échoué paypal');
INSERT INTO `lang_phrase` VALUES ('154', '1', '1', '', '0', 'Error payment', 'Ошибка при оплате');
INSERT INTO `lang_phrase` VALUES ('155', '2', '1', '', '0', 'Error payment', 'Error payment');
INSERT INTO `lang_phrase` VALUES ('156', '3', '1', '', '0', 'Error payment', 'Le paiement d\'erreur');
INSERT INTO `lang_phrase` VALUES ('157', '1', '1', '', '0', 'Purchase Found', 'Покупка не найдена');
INSERT INTO `lang_phrase` VALUES ('158', '2', '1', '', '0', 'Purchase Found', 'Purchase Found');
INSERT INTO `lang_phrase` VALUES ('159', '3', '1', '', '0', 'Purchase Found', 'Achat Trouvé');
INSERT INTO `lang_phrase` VALUES ('160', '1', '1', '', '0', 'Purchase successfully paid', 'Покупка №%s успешно оплачена');
INSERT INTO `lang_phrase` VALUES ('161', '2', '1', '', '0', 'Purchase successfully paid', 'Purchase №%s successfully paid');
INSERT INTO `lang_phrase` VALUES ('162', '3', '1', '', '0', 'Purchase successfully paid', 'Achat №%s payé avec succès');
INSERT INTO `lang_phrase` VALUES ('163', '1', '1', '', '0', 'Seller is not found', 'Продавец не найден');
INSERT INTO `lang_phrase` VALUES ('164', '2', '1', '', '0', 'Seller is not found', 'Seller is not found');
INSERT INTO `lang_phrase` VALUES ('165', '3', '1', '', '0', 'Seller is not found', 'Vendeur est introuvable');
INSERT INTO `lang_phrase` VALUES ('166', '1', '1', '', '0', 'Time booking stated incorrectly', 'Время бронирования указано некорректно');
INSERT INTO `lang_phrase` VALUES ('167', '2', '1', '', '0', 'Time booking stated incorrectly', 'Time booking stated incorrectly');
INSERT INTO `lang_phrase` VALUES ('168', '3', '1', '', '0', 'Time booking stated incorrectly', 'Réservation en temps déclaré incorrectement');
INSERT INTO `lang_phrase` VALUES ('169', '1', '1', '', '0', 'Booking time', 'Бронирование времени');
INSERT INTO `lang_phrase` VALUES ('170', '2', '1', '', '0', 'Booking time', 'Booking time');
INSERT INTO `lang_phrase` VALUES ('171', '3', '1', '', '0', 'Booking time', 'Réservation temps');
INSERT INTO `lang_phrase` VALUES ('172', '1', '1', '', '0', 'Time booking is already taken', 'Время бронирования уже занято');
INSERT INTO `lang_phrase` VALUES ('173', '2', '1', '', '0', 'Time booking is already taken', 'Time booking is already taken');
INSERT INTO `lang_phrase` VALUES ('174', '3', '1', '', '0', 'Time booking is already taken', 'Réservation en temps est déjà pris');
INSERT INTO `lang_phrase` VALUES ('175', '1', '1', '', '0', 'Time booking is not available', 'Время бронирования недоступно');
INSERT INTO `lang_phrase` VALUES ('176', '2', '1', '', '0', 'Time booking is not available', 'Time booking is not available');
INSERT INTO `lang_phrase` VALUES ('177', '3', '1', '', '0', 'Time booking is not available', 'Réservation en temps ne sont pas disponibles');
INSERT INTO `lang_phrase` VALUES ('178', '1', '1', '', '0', 'Time is not found', 'Время бронирования не найдено');
INSERT INTO `lang_phrase` VALUES ('179', '2', '1', '', '0', 'Time is not found', 'Time is not found');
INSERT INTO `lang_phrase` VALUES ('180', '3', '1', '', '0', 'Time is not found', 'Temps est introuvable');
INSERT INTO `lang_phrase` VALUES ('181', '1', '1', '', '0', 'Wait', 'Подождите');
INSERT INTO `lang_phrase` VALUES ('182', '2', '1', '', '0', 'Wait', 'Wait');
INSERT INTO `lang_phrase` VALUES ('183', '3', '1', '', '0', 'Wait', 'Attendez');
INSERT INTO `lang_phrase` VALUES ('184', '1', '1', '', '0', 'Acknowledgement', 'Подтверждение');
INSERT INTO `lang_phrase` VALUES ('185', '2', '1', '', '0', 'Acknowledgement', 'Acknowledgement');
INSERT INTO `lang_phrase` VALUES ('186', '3', '1', '', '0', 'Acknowledgement', 'Remerciements');
INSERT INTO `lang_phrase` VALUES ('187', '1', '1', '', '0', 'Loading ...', 'Идет загрузка...');
INSERT INTO `lang_phrase` VALUES ('188', '2', '1', '', '0', 'Loading ...', 'Loading ...');
INSERT INTO `lang_phrase` VALUES ('189', '3', '1', '', '0', 'Loading ...', 'Chargement ...');
INSERT INTO `lang_phrase` VALUES ('190', '1', '1', '', '0', 'Join Conferencing', 'Присоединиться к митингу');
INSERT INTO `lang_phrase` VALUES ('191', '2', '1', '', '0', 'Join Conferencing', 'Join Conferencing');
INSERT INTO `lang_phrase` VALUES ('192', '3', '1', '', '0', 'Join Conferencing', 'Rejoignez Conferencing');
INSERT INTO `lang_phrase` VALUES ('193', '1', '1', '', '0', 'Cancel', 'Отменить');
INSERT INTO `lang_phrase` VALUES ('194', '2', '1', '', '0', 'Cancel', 'Cancel');
INSERT INTO `lang_phrase` VALUES ('195', '3', '1', '', '0', 'Cancel', 'Annuler');
INSERT INTO `lang_phrase` VALUES ('196', '1', '1', '', '0', 'Errors', 'Ошибки');
INSERT INTO `lang_phrase` VALUES ('197', '2', '1', '', '0', 'Errors', 'Errors');
INSERT INTO `lang_phrase` VALUES ('198', '3', '1', '', '0', 'Errors', 'Erreurs');
INSERT INTO `lang_phrase` VALUES ('199', '1', '1', '', '0', 'Book', 'Забронировать');
INSERT INTO `lang_phrase` VALUES ('200', '2', '1', '', '0', 'Book', 'Book');
INSERT INTO `lang_phrase` VALUES ('201', '3', '1', '', '0', 'Book', 'Réserver');
INSERT INTO `lang_phrase` VALUES ('202', '1', '1', '', '0', 'The purpose of your video shopping?', 'Цель вашего видео шоппинга?');
INSERT INTO `lang_phrase` VALUES ('203', '2', '1', '', '0', 'The purpose of your video shopping?', 'The purpose of your video shopping?');
INSERT INTO `lang_phrase` VALUES ('204', '3', '1', '', '0', 'The purpose of your video shopping?', 'Le but de votre shopping vidéo?');
INSERT INTO `lang_phrase` VALUES ('205', '1', '1', '', '0', 'Do you really want to cancel the booking?', 'Вы действительно хотите отменить бронирование?');
INSERT INTO `lang_phrase` VALUES ('206', '2', '1', '', '0', 'Do you really want to cancel the booking?', 'Do you really want to cancel the booking?');
INSERT INTO `lang_phrase` VALUES ('207', '3', '1', '', '0', 'Do you really want to cancel the booking?', 'Voulez-vous vraiment annuler la réservation?');
INSERT INTO `lang_phrase` VALUES ('208', '1', '1', '', '0', 'My scheduled meetings', 'Мои запланированные митинги');
INSERT INTO `lang_phrase` VALUES ('209', '2', '1', '', '0', 'My scheduled meetings', 'My scheduled meetings');
INSERT INTO `lang_phrase` VALUES ('210', '3', '1', '', '0', 'My scheduled meetings', 'Mes réunions prévues');
INSERT INTO `lang_phrase` VALUES ('211', '1', '1', '', '0', 'Look', 'Смотреть');
INSERT INTO `lang_phrase` VALUES ('212', '2', '1', '', '0', 'Look', 'Look');
INSERT INTO `lang_phrase` VALUES ('213', '3', '1', '', '0', 'Look', 'Suivre');
INSERT INTO `lang_phrase` VALUES ('214', '1', '1', '', '0', 'Unavailable', 'Занято');
INSERT INTO `lang_phrase` VALUES ('215', '2', '1', '', '0', 'Unavailable', 'Unavailable');
INSERT INTO `lang_phrase` VALUES ('216', '3', '1', '', '0', 'Unavailable', 'Indisponible');
INSERT INTO `lang_phrase` VALUES ('217', '1', '1', '', '0', 'Start', 'Начать');
INSERT INTO `lang_phrase` VALUES ('218', '2', '1', '', '0', 'Start', 'Start');
INSERT INTO `lang_phrase` VALUES ('219', '3', '1', '', '0', 'Start', 'Commencé');
INSERT INTO `lang_phrase` VALUES ('220', '1', '1', '', '0', 'Mo', 'Пн');
INSERT INTO `lang_phrase` VALUES ('221', '2', '1', '', '0', 'Mo', 'Mon');
INSERT INTO `lang_phrase` VALUES ('222', '3', '1', '', '0', 'Mo', 'Lu');
INSERT INTO `lang_phrase` VALUES ('223', '1', '1', '', '0', 'Tu', 'Вт');
INSERT INTO `lang_phrase` VALUES ('224', '2', '1', '', '0', 'Tu', 'Tu');
INSERT INTO `lang_phrase` VALUES ('225', '3', '1', '', '0', 'Tu', 'Ma');
INSERT INTO `lang_phrase` VALUES ('226', '1', '1', '', '0', 'We', 'Ср');
INSERT INTO `lang_phrase` VALUES ('227', '2', '1', '', '0', 'We', 'We');
INSERT INTO `lang_phrase` VALUES ('228', '3', '1', '', '0', 'We', 'Me');
INSERT INTO `lang_phrase` VALUES ('229', '1', '1', '', '0', 'Th', 'Чт');
INSERT INTO `lang_phrase` VALUES ('230', '2', '1', '', '0', 'Th', 'Th');
INSERT INTO `lang_phrase` VALUES ('231', '3', '1', '', '0', 'Th', 'Je');
INSERT INTO `lang_phrase` VALUES ('232', '1', '1', '', '0', 'Fr', 'Пт');
INSERT INTO `lang_phrase` VALUES ('233', '2', '1', '', '0', 'Fr', 'Fr');
INSERT INTO `lang_phrase` VALUES ('234', '3', '1', '', '0', 'Fr', 'Ve');
INSERT INTO `lang_phrase` VALUES ('235', '1', '1', '', '0', 'Sa', 'Сб');
INSERT INTO `lang_phrase` VALUES ('236', '2', '1', '', '0', 'Sa', 'Sa');
INSERT INTO `lang_phrase` VALUES ('237', '3', '1', '', '0', 'Sa', 'Sa');
INSERT INTO `lang_phrase` VALUES ('238', '1', '1', '', '0', 'Su', 'Вс');
INSERT INTO `lang_phrase` VALUES ('239', '2', '1', '', '0', 'Su', 'Su');
INSERT INTO `lang_phrase` VALUES ('240', '3', '1', '', '0', 'Su', 'Di');
INSERT INTO `lang_phrase` VALUES ('241', '1', '1', '', '0', 'You have successfully subscribed', 'Вы успешно подписаны');
INSERT INTO `lang_phrase` VALUES ('242', '2', '1', '', '0', 'You have successfully subscribed', 'You have successfully signed');
INSERT INTO `lang_phrase` VALUES ('243', '3', '1', '', '0', 'You have successfully subscribed', 'Vous avez signé avec succès');
INSERT INTO `lang_phrase` VALUES ('244', '1', '1', '', '0', 'This email address is already subscribed', 'Такой электронный адрес уже подписан');
INSERT INTO `lang_phrase` VALUES ('245', '2', '1', '', '0', 'This email address is already subscribed', 'This email address is already subscribed');
INSERT INTO `lang_phrase` VALUES ('246', '3', '1', '', '0', 'This email address is already subscribed', 'Cette adresse email est déjà abonné');
INSERT INTO `lang_phrase` VALUES ('247', '1', '1', '', '0', 'Surname', 'Фамилия');
INSERT INTO `lang_phrase` VALUES ('248', '2', '1', '', '0', 'Surname', 'Surname');
INSERT INTO `lang_phrase` VALUES ('249', '3', '1', '', '0', 'Surname', 'Nom de famille');
INSERT INTO `lang_phrase` VALUES ('250', '1', '1', '', '0', 'Phone', 'Телефон');
INSERT INTO `lang_phrase` VALUES ('251', '2', '1', '', '0', 'Phone', 'Phone');
INSERT INTO `lang_phrase` VALUES ('252', '3', '1', '', '0', 'Phone', 'Téléphone');
INSERT INTO `lang_phrase` VALUES ('253', '1', '1', '', '0', 'Delivery address', 'Адрес доставки');
INSERT INTO `lang_phrase` VALUES ('254', '2', '1', '', '0', 'Delivery address', 'Delivery address');
INSERT INTO `lang_phrase` VALUES ('255', '3', '1', '', '0', 'Delivery address', 'Adresse de livraison');
INSERT INTO `lang_phrase` VALUES ('256', '1', '1', '', '0', 'Time zone', 'Часовой пояс');
INSERT INTO `lang_phrase` VALUES ('257', '2', '1', '', '0', 'Time zone', 'Time zone');
INSERT INTO `lang_phrase` VALUES ('258', '3', '1', '', '0', 'Time zone', 'Toutes les heures sont');
INSERT INTO `lang_phrase` VALUES ('259', '1', '1', '', '0', 'The password again', 'Пароль еще раз');
INSERT INTO `lang_phrase` VALUES ('260', '2', '1', '', '0', 'The password again', 'The password again');
INSERT INTO `lang_phrase` VALUES ('261', '3', '1', '', '0', 'The password again', 'Mot de passe nouveau');
INSERT INTO `lang_phrase` VALUES ('262', '1', '1', '', '0', 'This email address is already registered', 'Такой электронный адрес уже зарегистрирован');
INSERT INTO `lang_phrase` VALUES ('263', '2', '1', '', '0', 'This email address is already registered', 'This email address is already registered');
INSERT INTO `lang_phrase` VALUES ('264', '3', '1', '', '0', 'This email address is already registered', 'Cette adresse email est déjà enregistré');
INSERT INTO `lang_phrase` VALUES ('265', '1', '1', '', '0', 'Congratulations on your successful registration!', '<p>Поздравляем с успешной регистрацией!</p> 						<p>Теперь вы можете  <a href=\"/ru/login/\">войти</a> на сайт используя электронный адрес и пароль указанный при регистрации.</p> 						<p>На Ваш адрес отправлено письмо для подтверждения регистрации.</p> 						<hr> 						<a href=\"/ru/\" class=\"button\">Вернуться на сайт</a>');
INSERT INTO `lang_phrase` VALUES ('266', '2', '1', '', '0', 'Congratulations on your successful registration!', '<p> Congratulations on your successful registration! </ p> <p> Now you can <a href=\"/en/login/\"> </a> login to the site using the e-mail address and password provided during registration. </ p> <p> In a letter sent to your address to confirm your registration. </ p> <hr> <a href=\"/en/\" class=\"button\"> Back to site </a>');
INSERT INTO `lang_phrase` VALUES ('267', '3', '1', '', '0', 'Congratulations on your successful registration!', '<p> Félicitations pour votre inscription réussie! </ p> <p> Maintenant, vous pouvez href=\"/fr/login/\"> </A> vous connecter au site en utilisant l\'adresse e-mail et mot de passe fourni lors de l\'inscription. </ p> <p> Dans une lettre envoyée à votre adresse pour confirmer votre inscription. </ p> <hr> <a href=\"/fr/\" class=\"button\"> Retour au site </a>');
INSERT INTO `lang_phrase` VALUES ('268', '1', '1', '', '0', 'New password sent to your address', 'Новый пароль отправлен на ваш адрес');
INSERT INTO `lang_phrase` VALUES ('269', '2', '1', '', '0', 'New password sent to your address', 'New password sent to your address');
INSERT INTO `lang_phrase` VALUES ('270', '3', '1', '', '0', 'New password sent to your address', 'Nouveau mot de passe envoyé à votre adresse');
INSERT INTO `lang_phrase` VALUES ('271', '1', '1', '', '0', 'User with this email address will not be found', 'Пользователь с таким email не найден');
INSERT INTO `lang_phrase` VALUES ('272', '2', '1', '', '0', 'User with this email address will not be found', 'User with this email address will not be found');
INSERT INTO `lang_phrase` VALUES ('273', '3', '1', '', '0', 'User with this email address will not be found', 'Utilisateur avec cette adresse de messagerie ne sera pas trouvé');
INSERT INTO `lang_phrase` VALUES ('274', '1', '1', '', '0', 'Incorrect e-mail', 'Неправильная электронная почта');
INSERT INTO `lang_phrase` VALUES ('275', '2', '1', '', '0', 'Incorrect e-mail', 'Incorrect e-mail');
INSERT INTO `lang_phrase` VALUES ('276', '3', '1', '', '0', 'Incorrect e-mail', 'Mauvaise e-mail');
INSERT INTO `lang_phrase` VALUES ('277', '1', '1', '', '0', 'Password recovery', 'Восстановление пароля');
INSERT INTO `lang_phrase` VALUES ('278', '2', '1', '', '0', 'Password recovery', 'Password recovery');
INSERT INTO `lang_phrase` VALUES ('279', '3', '1', '', '0', 'Password recovery', 'Récupération de mot de passe');
INSERT INTO `lang_phrase` VALUES ('280', '1', '1', '', '0', 'The new password has been sent', '<p>Новый пароль отправлен на ваш электронный адрес.</p> 				<p>Если письмо не пришло в течении 2 часов, проверьте, возможно, оно попало в спам.</p>');
INSERT INTO `lang_phrase` VALUES ('281', '2', '1', '', '0', 'The new password has been sent', '<p> The new password has been sent to your email address. </ p> <p> If the letter has not come for 2 hours, check, perhaps it fell into the spam. </ p>');
INSERT INTO `lang_phrase` VALUES ('282', '3', '1', '', '0', 'The new password has been sent', '<p> Le nouveau mot de passe a été envoyé à votre adresse e-mail. </ p> <p> Si la lettre ne vient pas pendant 2 heures, vérifier, peut-être, il est tombé dans le spam. </p>');
INSERT INTO `lang_phrase` VALUES ('283', '1', '1', '', '0', 'Send', 'Отправить');
INSERT INTO `lang_phrase` VALUES ('284', '2', '1', '', '0', 'Send', 'Send');
INSERT INTO `lang_phrase` VALUES ('285', '3', '1', '', '0', 'Send', 'Envoyer');
INSERT INTO `lang_phrase` VALUES ('286', '1', '1', '', '0', 'Thank you for registering', 'Благодарим за регистрацию. Теперь Ваш акаунт активирован.<br>                     <a href=\"/ru/login/\">Войти в личный кабинет</a>');
INSERT INTO `lang_phrase` VALUES ('287', '2', '1', '', '0', 'Thank you for registering', 'Thank you for registering. Now your account as active. <br>                      <a href=\"/en/login/\"> Enter personal cabinet </a>');
INSERT INTO `lang_phrase` VALUES ('288', '3', '1', '', '0', 'Thank you for registering', 'Merci pour votre inscription. Maintenant que votre compte actif. <br>                      <a href=\"/fr/login/\"> Entrez </a> armoire personnelle');
INSERT INTO `lang_phrase` VALUES ('289', '1', '1', '', '0', 'An incorrect code is confirmed', 'Указан неверный код подтвержения');
INSERT INTO `lang_phrase` VALUES ('290', '2', '1', '', '0', 'An incorrect code is confirmed', 'An incorrect code is confirmed');
INSERT INTO `lang_phrase` VALUES ('291', '3', '1', '', '0', 'An incorrect code is confirmed', 'Un code incorrect est confirmé');
INSERT INTO `lang_phrase` VALUES ('292', '1', '1', '', '0', 'Shopping clients', 'Покупки клиентов');
INSERT INTO `lang_phrase` VALUES ('293', '2', '1', '', '0', 'Shopping clients', 'Shopping clients');
INSERT INTO `lang_phrase` VALUES ('294', '3', '1', '', '0', 'Shopping clients', 'Clients commerciaux');
INSERT INTO `lang_phrase` VALUES ('295', '1', '1', '', '0', 'Client', 'Клиент');
INSERT INTO `lang_phrase` VALUES ('296', '2', '1', '', '0', 'Client', 'Client');
INSERT INTO `lang_phrase` VALUES ('297', '3', '1', '', '0', 'Client', 'Client');
INSERT INTO `lang_phrase` VALUES ('298', '1', '1', '', '0', 'VAT', 'НДС');
INSERT INTO `lang_phrase` VALUES ('299', '2', '1', '', '0', 'VAT', 'VAT');
INSERT INTO `lang_phrase` VALUES ('300', '3', '1', '', '0', 'VAT', 'TVA');
INSERT INTO `lang_phrase` VALUES ('301', '1', '1', '', '0', 'Delivery', 'Доставка');
INSERT INTO `lang_phrase` VALUES ('302', '2', '1', '', '0', 'Delivery', 'Delivery');
INSERT INTO `lang_phrase` VALUES ('303', '3', '1', '', '0', 'Delivery', 'Délivrance');
INSERT INTO `lang_phrase` VALUES ('304', '1', '1', '', '0', 'Total', 'Итого');
INSERT INTO `lang_phrase` VALUES ('305', '2', '1', '', '0', 'Total', 'Total');
INSERT INTO `lang_phrase` VALUES ('306', '3', '1', '', '0', 'Total', 'En tout');
INSERT INTO `lang_phrase` VALUES ('307', '1', '1', '', '0', 'Delete', 'Удалить');
INSERT INTO `lang_phrase` VALUES ('308', '2', '1', '', '0', 'Delete', 'Delete');
INSERT INTO `lang_phrase` VALUES ('309', '3', '1', '', '0', 'Delete', 'Effacer');
INSERT INTO `lang_phrase` VALUES ('310', '1', '1', '', '0', 'Edit', 'Изменить');
INSERT INTO `lang_phrase` VALUES ('311', '2', '1', '', '0', 'Edit', 'Edit');
INSERT INTO `lang_phrase` VALUES ('312', '3', '1', '', '0', 'Edit', 'Change');
INSERT INTO `lang_phrase` VALUES ('313', '1', '1', '', '0', 'Just remove?', 'Точно удалить?');
INSERT INTO `lang_phrase` VALUES ('314', '2', '1', '', '0', 'Just remove?', 'Just remove?');
INSERT INTO `lang_phrase` VALUES ('315', '3', '1', '', '0', 'Just remove?', 'Il suffit de retirer?');
INSERT INTO `lang_phrase` VALUES ('316', '1', '1', '', '0', 'Editing purchases', 'Редактирование покупки');
INSERT INTO `lang_phrase` VALUES ('317', '2', '1', '', '0', 'Editing purchases', 'Editing purchases');
INSERT INTO `lang_phrase` VALUES ('318', '3', '1', '', '0', 'Editing purchases', 'Achats d\'édition');
INSERT INTO `lang_phrase` VALUES ('319', '1', '1', '', '0', 'Adding purchase', 'Добавление покупки');
INSERT INTO `lang_phrase` VALUES ('320', '2', '1', '', '0', 'Adding purchase', 'Adding purchase');
INSERT INTO `lang_phrase` VALUES ('321', '3', '1', '', '0', 'Adding purchase', 'Ajout d\'achat');
INSERT INTO `lang_phrase` VALUES ('322', '1', '1', '', '0', 'Currency of payment', 'Валюта оплаты');
INSERT INTO `lang_phrase` VALUES ('323', '2', '1', '', '0', 'Currency of payment', 'Currency of payment');
INSERT INTO `lang_phrase` VALUES ('324', '3', '1', '', '0', 'Currency of payment', 'Monnaie de paiement');
INSERT INTO `lang_phrase` VALUES ('325', '1', '1', '', '0', 'Cost of delivery', 'Стоимость доставки');
INSERT INTO `lang_phrase` VALUES ('326', '2', '1', '', '0', 'Cost of delivery', 'Cost of delivery');
INSERT INTO `lang_phrase` VALUES ('327', '3', '1', '', '0', 'Cost of delivery', 'Frais d\'expédition');
INSERT INTO `lang_phrase` VALUES ('328', '1', '1', '', '0', 'Images', 'Изображения');
INSERT INTO `lang_phrase` VALUES ('329', '2', '1', '', '0', 'Images', 'Images');
INSERT INTO `lang_phrase` VALUES ('330', '3', '1', '', '0', 'Images', 'Photos');
INSERT INTO `lang_phrase` VALUES ('331', '1', '1', '', '0', 'Save', 'Сохранить');
INSERT INTO `lang_phrase` VALUES ('332', '2', '1', '', '0', 'Save', 'Save');
INSERT INTO `lang_phrase` VALUES ('333', '3', '1', '', '0', 'Save', 'Sauvegarder');
INSERT INTO `lang_phrase` VALUES ('334', '1', '1', '', '0', 'Add', 'Добавить');
INSERT INTO `lang_phrase` VALUES ('335', '2', '1', '', '0', 'Add', 'Add');
INSERT INTO `lang_phrase` VALUES ('336', '3', '1', '', '0', 'Add', 'Ajouter');
INSERT INTO `lang_phrase` VALUES ('337', '1', '1', '', '0', 'Buying successfully saved', 'Покупка успешно сохранена');
INSERT INTO `lang_phrase` VALUES ('338', '2', '1', '', '0', 'Buying successfully saved', 'Buying successfully saved');
INSERT INTO `lang_phrase` VALUES ('339', '3', '1', '', '0', 'Buying successfully saved', 'Achetez enregistré avec succès');
INSERT INTO `lang_phrase` VALUES ('340', '1', '1', '', '0', 'Buying successfully added', 'Покупка успешно добавлена');
INSERT INTO `lang_phrase` VALUES ('341', '2', '1', '', '0', 'Buying successfully added', 'Buying successfully added');
INSERT INTO `lang_phrase` VALUES ('342', '3', '1', '', '0', 'Buying successfully added', 'Achetez ajouté avec succès');
INSERT INTO `lang_phrase` VALUES ('343', '1', '1', '', '0', 'add buy', 'добавить покупки');
INSERT INTO `lang_phrase` VALUES ('344', '2', '1', '', '0', 'add buy', 'add buy');
INSERT INTO `lang_phrase` VALUES ('345', '3', '1', '', '0', 'add buy', 'Ajouter acheter');
INSERT INTO `lang_phrase` VALUES ('346', '1', '1', '', '0', 'Data saved successfully', 'Данные успешно сохранены');
INSERT INTO `lang_phrase` VALUES ('347', '2', '1', '', '0', 'Data saved successfully', 'Data saved successfully');
INSERT INTO `lang_phrase` VALUES ('348', '3', '1', '', '0', 'Data saved successfully', 'Les données sauvegardées avec succès');
INSERT INTO `lang_phrase` VALUES ('349', '1', '1', '', '0', 'validator.field.pattern', 'Ошибка в поле `%s`.');
INSERT INTO `lang_phrase` VALUES ('350', '2', '1', '', '0', 'validator.field.pattern', 'Error in field `%s`.');
INSERT INTO `lang_phrase` VALUES ('351', '3', '1', '', '0', 'validator.field.pattern', 'Erreur dans le champ `%s`.');
INSERT INTO `lang_phrase` VALUES ('352', '1', '1', '', '0', 'validator.def.required', 'Поле `%s` обязательно для заполнения.');
INSERT INTO `lang_phrase` VALUES ('353', '2', '1', '', '0', 'validator.def.required', 'The field `%s` is required.');
INSERT INTO `lang_phrase` VALUES ('354', '3', '1', '', '0', 'validator.def.required', 'Le champ `%s` est nécessaire.');
INSERT INTO `lang_phrase` VALUES ('355', '1', '1', '', '0', 'validator.rule.==', 'Поля `%s` и `%s` должны совпадать.');
INSERT INTO `lang_phrase` VALUES ('356', '2', '1', '', '0', 'validator.rule.==', 'Fields `%s` and`%s` must match.');
INSERT INTO `lang_phrase` VALUES ('357', '3', '1', '', '0', 'validator.rule.==', 'Paul `%s` et`%s` doit correspondre.');
INSERT INTO `lang_phrase` VALUES ('358', '1', '1', '', '0', 'Are you sure you want to delete purchase', 'Вы действительно хотите удалить покупку');
INSERT INTO `lang_phrase` VALUES ('359', '2', '1', '', '0', 'Are you sure you want to delete purchase', 'Are you sure you want to delete purchase');
INSERT INTO `lang_phrase` VALUES ('360', '3', '1', '', '0', 'Are you sure you want to delete purchase', 'Etes-vous sûr que vous voulez supprimer achat');
INSERT INTO `lang_phrase` VALUES ('2180', '1', '6', 'title', '1', 'A TESTONI', 'A TESTONI');
INSERT INTO `lang_phrase` VALUES ('2181', '2', '6', 'title', '1', 'A TESTONI', 'A TESTONI');
INSERT INTO `lang_phrase` VALUES ('2182', '3', '6', 'title', '1', 'A TESTONI', 'A TESTONI');
INSERT INTO `lang_phrase` VALUES ('2183', '1', '6', 'title', '2', 'ABSOLUMENT MAISON', 'ABSOLUMENT MAISON');
INSERT INTO `lang_phrase` VALUES ('2184', '2', '6', 'title', '2', 'ABSOLUMENT MAISON', 'ABSOLUMENT MAISON');
INSERT INTO `lang_phrase` VALUES ('2185', '3', '6', 'title', '2', 'ABSOLUMENT MAISON', 'ABSOLUMENT MAISON');
INSERT INTO `lang_phrase` VALUES ('2186', '1', '6', 'title', '3', 'ABSORBA', 'ABSORBA');
INSERT INTO `lang_phrase` VALUES ('2187', '2', '6', 'title', '3', 'ABSORBA', 'ABSORBA');
INSERT INTO `lang_phrase` VALUES ('2188', '3', '6', 'title', '3', 'ABSORBA', 'ABSORBA');
INSERT INTO `lang_phrase` VALUES ('2189', '1', '6', 'title', '4', 'ACCESSOIRE DIFFUSION', 'ACCESSOIRE DIFFUSION');
INSERT INTO `lang_phrase` VALUES ('2190', '2', '6', 'title', '4', 'ACCESSOIRE DIFFUSION', 'ACCESSOIRE DIFFUSION');
INSERT INTO `lang_phrase` VALUES ('2191', '3', '6', 'title', '4', 'ACCESSOIRE DIFFUSION', 'ACCESSOIRE DIFFUSION');
INSERT INTO `lang_phrase` VALUES ('2192', '1', '6', 'title', '5', 'ACNÉ', 'ACNÉ');
INSERT INTO `lang_phrase` VALUES ('2193', '2', '6', 'title', '5', 'ACNÉ', 'ACNÉ');
INSERT INTO `lang_phrase` VALUES ('2194', '3', '6', 'title', '5', 'ACNÉ', 'ACNÉ');
INSERT INTO `lang_phrase` VALUES ('2195', '1', '6', 'title', '6', 'ACQUA DI PARMA', 'ACQUA DI PARMA');
INSERT INTO `lang_phrase` VALUES ('2196', '2', '6', 'title', '6', 'ACQUA DI PARMA', 'ACQUA DI PARMA');
INSERT INTO `lang_phrase` VALUES ('2197', '3', '6', 'title', '6', 'ACQUA DI PARMA', 'ACQUA DI PARMA');
INSERT INTO `lang_phrase` VALUES ('2198', '1', '6', 'title', '7', 'ADIDAS', 'ADIDAS');
INSERT INTO `lang_phrase` VALUES ('2199', '2', '6', 'title', '7', 'ADIDAS', 'ADIDAS');
INSERT INTO `lang_phrase` VALUES ('2200', '3', '6', 'title', '7', 'ADIDAS', 'ADIDAS');
INSERT INTO `lang_phrase` VALUES ('2201', '1', '6', 'title', '8', 'AESOP', 'AESOP');
INSERT INTO `lang_phrase` VALUES ('2202', '2', '6', 'title', '8', 'AESOP', 'AESOP');
INSERT INTO `lang_phrase` VALUES ('2203', '3', '6', 'title', '8', 'AESOP', 'AESOP');
INSERT INTO `lang_phrase` VALUES ('2204', '1', '6', 'title', '9', 'AGATHA', 'AGATHA');
INSERT INTO `lang_phrase` VALUES ('2205', '2', '6', 'title', '9', 'AGATHA', 'AGATHA');
INSERT INTO `lang_phrase` VALUES ('2206', '3', '6', 'title', '9', 'AGATHA', 'AGATHA');
INSERT INTO `lang_phrase` VALUES ('2207', '1', '6', 'title', '10', 'AGENT PROVOCATEUR', 'AGENT PROVOCATEUR');
INSERT INTO `lang_phrase` VALUES ('2208', '2', '6', 'title', '10', 'AGENT PROVOCATEUR', 'AGENT PROVOCATEUR');
INSERT INTO `lang_phrase` VALUES ('2209', '3', '6', 'title', '10', 'AGENT PROVOCATEUR', 'AGENT PROVOCATEUR');
INSERT INTO `lang_phrase` VALUES ('2210', '1', '6', 'title', '11', 'AGNÈS B', 'AGNÈS B');
INSERT INTO `lang_phrase` VALUES ('2211', '2', '6', 'title', '11', 'AGNÈS B', 'AGNÈS B');
INSERT INTO `lang_phrase` VALUES ('2212', '3', '6', 'title', '11', 'AGNÈS B', 'AGNÈS B');
INSERT INTO `lang_phrase` VALUES ('2213', '1', '6', 'title', '12', 'AIGLE', 'AIGLE');
INSERT INTO `lang_phrase` VALUES ('2214', '2', '6', 'title', '12', 'AIGLE', 'AIGLE');
INSERT INTO `lang_phrase` VALUES ('2215', '3', '6', 'title', '12', 'AIGLE', 'AIGLE');
INSERT INTO `lang_phrase` VALUES ('2216', '1', '6', 'title', '13', 'ALADIN', 'ALADIN');
INSERT INTO `lang_phrase` VALUES ('2217', '2', '6', 'title', '13', 'ALADIN', 'ALADIN');
INSERT INTO `lang_phrase` VALUES ('2218', '3', '6', 'title', '13', 'ALADIN', 'ALADIN');
INSERT INTO `lang_phrase` VALUES ('2219', '1', '6', 'title', '14', 'ALAÏA', 'ALAÏA');
INSERT INTO `lang_phrase` VALUES ('2220', '2', '6', 'title', '14', 'ALAÏA', 'ALAÏA');
INSERT INTO `lang_phrase` VALUES ('2221', '3', '6', 'title', '14', 'ALAÏA', 'ALAÏA');
INSERT INTO `lang_phrase` VALUES ('2222', '1', '6', 'title', '15', 'ALAIN FIGARET', 'ALAIN FIGARET');
INSERT INTO `lang_phrase` VALUES ('2223', '2', '6', 'title', '15', 'ALAIN FIGARET', 'ALAIN FIGARET');
INSERT INTO `lang_phrase` VALUES ('2224', '3', '6', 'title', '15', 'ALAIN FIGARET', 'ALAIN FIGARET');
INSERT INTO `lang_phrase` VALUES ('2225', '1', '6', 'title', '16', 'ALBERTINE', 'ALBERTINE');
INSERT INTO `lang_phrase` VALUES ('2226', '2', '6', 'title', '16', 'ALBERTINE', 'ALBERTINE');
INSERT INTO `lang_phrase` VALUES ('2227', '3', '6', 'title', '16', 'ALBERTINE', 'ALBERTINE');
INSERT INTO `lang_phrase` VALUES ('2228', '1', '6', 'title', '17', 'ALDO CHAUSSURES', 'ALDO CHAUSSURES');
INSERT INTO `lang_phrase` VALUES ('2229', '2', '6', 'title', '17', 'ALDO CHAUSSURES', 'ALDO CHAUSSURES');
INSERT INTO `lang_phrase` VALUES ('2230', '3', '6', 'title', '17', 'ALDO CHAUSSURES', 'ALDO CHAUSSURES');
INSERT INTO `lang_phrase` VALUES ('2231', '1', '6', 'title', '18', 'ALESSI', 'ALESSI');
INSERT INTO `lang_phrase` VALUES ('2232', '2', '6', 'title', '18', 'ALESSI', 'ALESSI');
INSERT INTO `lang_phrase` VALUES ('2233', '3', '6', 'title', '18', 'ALESSI', 'ALESSI');
INSERT INTO `lang_phrase` VALUES ('2234', '1', '6', 'title', '19', 'ALEXANDER MCQUEEN', 'ALEXANDER MCQUEEN');
INSERT INTO `lang_phrase` VALUES ('2235', '2', '6', 'title', '19', 'ALEXANDER MCQUEEN', 'ALEXANDER MCQUEEN');
INSERT INTO `lang_phrase` VALUES ('2236', '3', '6', 'title', '19', 'ALEXANDER MCQUEEN', 'ALEXANDER MCQUEEN');
INSERT INTO `lang_phrase` VALUES ('2237', '1', '6', 'title', '20', 'ALEXANDER WANG', 'ALEXANDER WANG');
INSERT INTO `lang_phrase` VALUES ('2238', '2', '6', 'title', '20', 'ALEXANDER WANG', 'ALEXANDER WANG');
INSERT INTO `lang_phrase` VALUES ('2239', '3', '6', 'title', '20', 'ALEXANDER WANG', 'ALEXANDER WANG');
INSERT INTO `lang_phrase` VALUES ('2240', '1', '6', 'title', '21', 'ALEXANDRE DE PARIS', 'ALEXANDRE DE PARIS');
INSERT INTO `lang_phrase` VALUES ('2241', '2', '6', 'title', '21', 'ALEXANDRE DE PARIS', 'ALEXANDRE DE PARIS');
INSERT INTO `lang_phrase` VALUES ('2242', '3', '6', 'title', '21', 'ALEXANDRE DE PARIS', 'ALEXANDRE DE PARIS');
INSERT INTO `lang_phrase` VALUES ('2243', '1', '6', 'title', '22', 'ALICE & OLIVIA', 'ALICE & OLIVIA');
INSERT INTO `lang_phrase` VALUES ('2244', '2', '6', 'title', '22', 'ALICE & OLIVIA', 'ALICE & OLIVIA');
INSERT INTO `lang_phrase` VALUES ('2245', '3', '6', 'title', '22', 'ALICE & OLIVIA', 'ALICE & OLIVIA');
INSERT INTO `lang_phrase` VALUES ('2246', '1', '6', 'title', '23', 'AM-PM', 'AM-PM');
INSERT INTO `lang_phrase` VALUES ('2247', '2', '6', 'title', '23', 'AM-PM', 'AM-PM');
INSERT INTO `lang_phrase` VALUES ('2248', '3', '6', 'title', '23', 'AM-PM', 'AM-PM');
INSERT INTO `lang_phrase` VALUES ('2249', '1', '6', 'title', '24', 'AMERICAN APPAREL', 'AMERICAN APPAREL');
INSERT INTO `lang_phrase` VALUES ('2250', '2', '6', 'title', '24', 'AMERICAN APPAREL', 'AMERICAN APPAREL');
INSERT INTO `lang_phrase` VALUES ('2251', '3', '6', 'title', '24', 'AMERICAN APPAREL', 'AMERICAN APPAREL');
INSERT INTO `lang_phrase` VALUES ('2252', '1', '6', 'title', '25', 'AMERICAN RÉTRO', 'AMERICAN RÉTRO');
INSERT INTO `lang_phrase` VALUES ('2253', '2', '6', 'title', '25', 'AMERICAN RÉTRO', 'AMERICAN RÉTRO');
INSERT INTO `lang_phrase` VALUES ('2254', '3', '6', 'title', '25', 'AMERICAN RÉTRO', 'AMERICAN RÉTRO');
INSERT INTO `lang_phrase` VALUES ('2255', '1', '6', 'title', '26', 'AMERICAN VINTAGE', 'AMERICAN VINTAGE');
INSERT INTO `lang_phrase` VALUES ('2256', '2', '6', 'title', '26', 'AMERICAN VINTAGE', 'AMERICAN VINTAGE');
INSERT INTO `lang_phrase` VALUES ('2257', '3', '6', 'title', '26', 'AMERICAN VINTAGE', 'AMERICAN VINTAGE');
INSERT INTO `lang_phrase` VALUES ('2258', '1', '6', 'title', '27', 'AMI', 'AMI');
INSERT INTO `lang_phrase` VALUES ('2259', '2', '6', 'title', '27', 'AMI', 'AMI');
INSERT INTO `lang_phrase` VALUES ('2260', '3', '6', 'title', '27', 'AMI', 'AMI');
INSERT INTO `lang_phrase` VALUES ('2261', '1', '6', 'title', '28', 'ANAPLUSH / WWF', 'ANAPLUSH / WWF');
INSERT INTO `lang_phrase` VALUES ('2262', '2', '6', 'title', '28', 'ANAPLUSH / WWF', 'ANAPLUSH / WWF');
INSERT INTO `lang_phrase` VALUES ('2263', '3', '6', 'title', '28', 'ANAPLUSH / WWF', 'ANAPLUSH / WWF');
INSERT INTO `lang_phrase` VALUES ('2264', '1', '6', 'title', '29', 'ANDRÉ', 'ANDRÉ');
INSERT INTO `lang_phrase` VALUES ('2265', '2', '6', 'title', '29', 'ANDRÉ', 'ANDRÉ');
INSERT INTO `lang_phrase` VALUES ('2266', '3', '6', 'title', '29', 'ANDRÉ', 'ANDRÉ');
INSERT INTO `lang_phrase` VALUES ('2267', '1', '6', 'title', '30', 'ANN DEMEULEMEESTER', 'ANN DEMEULEMEESTER');
INSERT INTO `lang_phrase` VALUES ('2268', '2', '6', 'title', '30', 'ANN DEMEULEMEESTER', 'ANN DEMEULEMEESTER');
INSERT INTO `lang_phrase` VALUES ('2269', '3', '6', 'title', '30', 'ANN DEMEULEMEESTER', 'ANN DEMEULEMEESTER');
INSERT INTO `lang_phrase` VALUES ('2270', '1', '6', 'title', '31', 'ANNE DE SOLÈNE', 'ANNE DE SOLÈNE');
INSERT INTO `lang_phrase` VALUES ('2271', '2', '6', 'title', '31', 'ANNE DE SOLÈNE', 'ANNE DE SOLÈNE');
INSERT INTO `lang_phrase` VALUES ('2272', '3', '6', 'title', '31', 'ANNE DE SOLÈNE', 'ANNE DE SOLÈNE');
INSERT INTO `lang_phrase` VALUES ('2273', '1', '6', 'title', '32', 'ANNE FONTAINE', 'ANNE FONTAINE');
INSERT INTO `lang_phrase` VALUES ('2274', '2', '6', 'title', '32', 'ANNE FONTAINE', 'ANNE FONTAINE');
INSERT INTO `lang_phrase` VALUES ('2275', '3', '6', 'title', '32', 'ANNE FONTAINE', 'ANNE FONTAINE');
INSERT INTO `lang_phrase` VALUES ('2276', '1', '6', 'title', '33', 'ANNICK GOUTAL', 'ANNICK GOUTAL');
INSERT INTO `lang_phrase` VALUES ('2277', '2', '6', 'title', '33', 'ANNICK GOUTAL', 'ANNICK GOUTAL');
INSERT INTO `lang_phrase` VALUES ('2278', '3', '6', 'title', '33', 'ANNICK GOUTAL', 'ANNICK GOUTAL');
INSERT INTO `lang_phrase` VALUES ('2279', '1', '6', 'title', '34', 'ANTHROPOLOGIE', 'ANTHROPOLOGIE');
INSERT INTO `lang_phrase` VALUES ('2280', '2', '6', 'title', '34', 'ANTHROPOLOGIE', 'ANTHROPOLOGIE');
INSERT INTO `lang_phrase` VALUES ('2281', '3', '6', 'title', '34', 'ANTHROPOLOGIE', 'ANTHROPOLOGIE');
INSERT INTO `lang_phrase` VALUES ('2282', '1', '6', 'title', '35', 'AOKI', 'AOKI');
INSERT INTO `lang_phrase` VALUES ('2283', '2', '6', 'title', '35', 'AOKI', 'AOKI');
INSERT INTO `lang_phrase` VALUES ('2284', '3', '6', 'title', '35', 'AOKI', 'AOKI');
INSERT INTO `lang_phrase` VALUES ('2285', '1', '6', 'title', '36', 'APC', 'APC');
INSERT INTO `lang_phrase` VALUES ('2286', '2', '6', 'title', '36', 'APC', 'APC');
INSERT INTO `lang_phrase` VALUES ('2287', '3', '6', 'title', '36', 'APC', 'APC');
INSERT INTO `lang_phrase` VALUES ('2288', '1', '6', 'title', '37', 'APM MONACO', 'APM MONACO');
INSERT INTO `lang_phrase` VALUES ('2289', '2', '6', 'title', '37', 'APM MONACO', 'APM MONACO');
INSERT INTO `lang_phrase` VALUES ('2290', '3', '6', 'title', '37', 'APM MONACO', 'APM MONACO');
INSERT INTO `lang_phrase` VALUES ('2291', '1', '6', 'title', '38', 'APPLE', 'APPLE');
INSERT INTO `lang_phrase` VALUES ('2292', '2', '6', 'title', '38', 'APPLE', 'APPLE');
INSERT INTO `lang_phrase` VALUES ('2293', '3', '6', 'title', '38', 'APPLE', 'APPLE');
INSERT INTO `lang_phrase` VALUES ('2294', '1', '6', 'title', '39', 'ARC’TERYX', 'ARC’TERYX');
INSERT INTO `lang_phrase` VALUES ('2295', '2', '6', 'title', '39', 'ARC’TERYX', 'ARC’TERYX');
INSERT INTO `lang_phrase` VALUES ('2296', '3', '6', 'title', '39', 'ARC’TERYX', 'ARC’TERYX');
INSERT INTO `lang_phrase` VALUES ('2297', '1', '6', 'title', '40', 'ARCHE', 'ARCHE');
INSERT INTO `lang_phrase` VALUES ('2298', '2', '6', 'title', '40', 'ARCHE', 'ARCHE');
INSERT INTO `lang_phrase` VALUES ('2299', '3', '6', 'title', '40', 'ARCHE', 'ARCHE');
INSERT INTO `lang_phrase` VALUES ('2300', '1', '6', 'title', '41', 'ARCHIMÈDE', 'ARCHIMÈDE');
INSERT INTO `lang_phrase` VALUES ('2301', '2', '6', 'title', '41', 'ARCHIMÈDE', 'ARCHIMÈDE');
INSERT INTO `lang_phrase` VALUES ('2302', '3', '6', 'title', '41', 'ARCHIMÈDE', 'ARCHIMÈDE');
INSERT INTO `lang_phrase` VALUES ('2303', '1', '6', 'title', '42', 'ARENA', 'ARENA');
INSERT INTO `lang_phrase` VALUES ('2304', '2', '6', 'title', '42', 'ARENA', 'ARENA');
INSERT INTO `lang_phrase` VALUES ('2305', '3', '6', 'title', '42', 'ARENA', 'ARENA');
INSERT INTO `lang_phrase` VALUES ('2306', '1', '6', 'title', '43', 'ARMANI', 'ARMANI');
INSERT INTO `lang_phrase` VALUES ('2307', '2', '6', 'title', '43', 'ARMANI', 'ARMANI');
INSERT INTO `lang_phrase` VALUES ('2308', '3', '6', 'title', '43', 'ARMANI', 'ARMANI');
INSERT INTO `lang_phrase` VALUES ('2309', '1', '6', 'title', '44', 'ARMANI COLLEZIONI', 'ARMANI COLLEZIONI');
INSERT INTO `lang_phrase` VALUES ('2310', '2', '6', 'title', '44', 'ARMANI COLLEZIONI', 'ARMANI COLLEZIONI');
INSERT INTO `lang_phrase` VALUES ('2311', '3', '6', 'title', '44', 'ARMANI COLLEZIONI', 'ARMANI COLLEZIONI');
INSERT INTO `lang_phrase` VALUES ('2312', '1', '6', 'title', '45', 'ARMANI JEANS', 'ARMANI JEANS');
INSERT INTO `lang_phrase` VALUES ('2313', '2', '6', 'title', '45', 'ARMANI JEANS', 'ARMANI JEANS');
INSERT INTO `lang_phrase` VALUES ('2314', '3', '6', 'title', '45', 'ARMANI JEANS', 'ARMANI JEANS');
INSERT INTO `lang_phrase` VALUES ('2315', '1', '6', 'title', '46', 'ARMOR LUX', 'ARMOR LUX');
INSERT INTO `lang_phrase` VALUES ('2316', '2', '6', 'title', '46', 'ARMOR LUX', 'ARMOR LUX');
INSERT INTO `lang_phrase` VALUES ('2317', '3', '6', 'title', '46', 'ARMOR LUX', 'ARMOR LUX');
INSERT INTO `lang_phrase` VALUES ('2318', '1', '6', 'title', '47', 'ARROW', 'ARROW');
INSERT INTO `lang_phrase` VALUES ('2319', '2', '6', 'title', '47', 'ARROW', 'ARROW');
INSERT INTO `lang_phrase` VALUES ('2320', '3', '6', 'title', '47', 'ARROW', 'ARROW');
INSERT INTO `lang_phrase` VALUES ('2321', '1', '6', 'title', '48', 'ARTHUR', 'ARTHUR');
INSERT INTO `lang_phrase` VALUES ('2322', '2', '6', 'title', '48', 'ARTHUR', 'ARTHUR');
INSERT INTO `lang_phrase` VALUES ('2323', '3', '6', 'title', '48', 'ARTHUR', 'ARTHUR');
INSERT INTO `lang_phrase` VALUES ('2324', '1', '6', 'title', '49', 'ARTHUR & ASTON', 'ARTHUR & ASTON');
INSERT INTO `lang_phrase` VALUES ('2325', '2', '6', 'title', '49', 'ARTHUR & ASTON', 'ARTHUR & ASTON');
INSERT INTO `lang_phrase` VALUES ('2326', '3', '6', 'title', '49', 'ARTHUR & ASTON', 'ARTHUR & ASTON');
INSERT INTO `lang_phrase` VALUES ('2327', '1', '6', 'title', '50', 'ASA', 'ASA');
INSERT INTO `lang_phrase` VALUES ('2328', '2', '6', 'title', '50', 'ASA', 'ASA');
INSERT INTO `lang_phrase` VALUES ('2329', '3', '6', 'title', '50', 'ASA', 'ASA');
INSERT INTO `lang_phrase` VALUES ('2330', '1', '6', 'title', '51', 'ASH', 'ASH');
INSERT INTO `lang_phrase` VALUES ('2331', '2', '6', 'title', '51', 'ASH', 'ASH');
INSERT INTO `lang_phrase` VALUES ('2332', '3', '6', 'title', '51', 'ASH', 'ASH');
INSERT INTO `lang_phrase` VALUES ('2333', '1', '6', 'title', '52', 'ATELIER COLOGNE', 'ATELIER COLOGNE');
INSERT INTO `lang_phrase` VALUES ('2334', '2', '6', 'title', '52', 'ATELIER COLOGNE', 'ATELIER COLOGNE');
INSERT INTO `lang_phrase` VALUES ('2335', '3', '6', 'title', '52', 'ATELIER COLOGNE', 'ATELIER COLOGNE');
INSERT INTO `lang_phrase` VALUES ('2336', '1', '6', 'title', '53', 'ATELIER DU VIN', 'ATELIER DU VIN');
INSERT INTO `lang_phrase` VALUES ('2337', '2', '6', 'title', '53', 'ATELIER DU VIN', 'ATELIER DU VIN');
INSERT INTO `lang_phrase` VALUES ('2338', '3', '6', 'title', '53', 'ATELIER DU VIN', 'ATELIER DU VIN');
INSERT INTO `lang_phrase` VALUES ('2339', '1', '6', 'title', '54', 'ATELIER MERCADAL', 'ATELIER MERCADAL');
INSERT INTO `lang_phrase` VALUES ('2340', '2', '6', 'title', '54', 'ATELIER MERCADAL', 'ATELIER MERCADAL');
INSERT INTO `lang_phrase` VALUES ('2341', '3', '6', 'title', '54', 'ATELIER MERCADAL', 'ATELIER MERCADAL');
INSERT INTO `lang_phrase` VALUES ('2342', '1', '6', 'title', '55', 'AUBADE', 'AUBADE');
INSERT INTO `lang_phrase` VALUES ('2343', '2', '6', 'title', '55', 'AUBADE', 'AUBADE');
INSERT INTO `lang_phrase` VALUES ('2344', '3', '6', 'title', '55', 'AUBADE', 'AUBADE');
INSERT INTO `lang_phrase` VALUES ('2345', '1', '6', 'title', '56', 'AUBECQ', 'AUBECQ');
INSERT INTO `lang_phrase` VALUES ('2346', '2', '6', 'title', '56', 'AUBECQ', 'AUBECQ');
INSERT INTO `lang_phrase` VALUES ('2347', '3', '6', 'title', '56', 'AUBECQ', 'AUBECQ');
INSERT INTO `lang_phrase` VALUES ('2348', '1', '6', 'title', '57', 'AURA', 'AURA');
INSERT INTO `lang_phrase` VALUES ('2349', '2', '6', 'title', '57', 'AURA', 'AURA');
INSERT INTO `lang_phrase` VALUES ('2350', '3', '6', 'title', '57', 'AURA', 'AURA');
INSERT INTO `lang_phrase` VALUES ('2351', '1', '6', 'title', '58', 'AVANT PREMIÈRE', 'AVANT PREMIÈRE');
INSERT INTO `lang_phrase` VALUES ('2352', '2', '6', 'title', '58', 'AVANT PREMIÈRE', 'AVANT PREMIÈRE');
INSERT INTO `lang_phrase` VALUES ('2353', '3', '6', 'title', '58', 'AVANT PREMIÈRE', 'AVANT PREMIÈRE');
INSERT INTO `lang_phrase` VALUES ('2354', '1', '6', 'title', '59', 'AVRIL GAU', 'AVRIL GAU');
INSERT INTO `lang_phrase` VALUES ('2355', '2', '6', 'title', '59', 'AVRIL GAU', 'AVRIL GAU');
INSERT INTO `lang_phrase` VALUES ('2356', '3', '6', 'title', '59', 'AVRIL GAU', 'AVRIL GAU');
INSERT INTO `lang_phrase` VALUES ('2357', '1', '6', 'title', '60', 'AZZARO', 'AZZARO');
INSERT INTO `lang_phrase` VALUES ('2358', '2', '6', 'title', '60', 'AZZARO', 'AZZARO');
INSERT INTO `lang_phrase` VALUES ('2359', '3', '6', 'title', '60', 'AZZARO', 'AZZARO');
INSERT INTO `lang_phrase` VALUES ('2360', '1', '6', 'title', '61', 'BA&SH', 'BA&SH');
INSERT INTO `lang_phrase` VALUES ('2361', '2', '6', 'title', '61', 'BA&SH', 'BA&SH');
INSERT INTO `lang_phrase` VALUES ('2362', '3', '6', 'title', '61', 'BA&SH', 'BA&SH');
INSERT INTO `lang_phrase` VALUES ('2363', '1', '6', 'title', '62', 'BABY BJORN', 'BABY BJORN');
INSERT INTO `lang_phrase` VALUES ('2364', '2', '6', 'title', '62', 'BABY BJORN', 'BABY BJORN');
INSERT INTO `lang_phrase` VALUES ('2365', '3', '6', 'title', '62', 'BABY BJORN', 'BABY BJORN');
INSERT INTO `lang_phrase` VALUES ('2366', '1', '6', 'title', '63', 'BACCARAT', 'BACCARAT');
INSERT INTO `lang_phrase` VALUES ('2367', '2', '6', 'title', '63', 'BACCARAT', 'BACCARAT');
INSERT INTO `lang_phrase` VALUES ('2368', '3', '6', 'title', '63', 'BACCARAT', 'BACCARAT');
INSERT INTO `lang_phrase` VALUES ('2369', '1', '6', 'title', '64', 'BAIN', 'BAIN');
INSERT INTO `lang_phrase` VALUES ('2370', '2', '6', 'title', '64', 'BAIN', 'BAIN');
INSERT INTO `lang_phrase` VALUES ('2371', '3', '6', 'title', '64', 'BAIN', 'BAIN');
INSERT INTO `lang_phrase` VALUES ('2372', '1', '6', 'title', '65', 'BALA', 'BALA');
INSERT INTO `lang_phrase` VALUES ('2373', '2', '6', 'title', '65', 'BALA', 'BALA');
INSERT INTO `lang_phrase` VALUES ('2374', '3', '6', 'title', '65', 'BALA', 'BALA');
INSERT INTO `lang_phrase` VALUES ('2375', '1', '6', 'title', '66', 'BOOSTÉ', 'BOOSTÉ');
INSERT INTO `lang_phrase` VALUES ('2376', '2', '6', 'title', '66', 'BOOSTÉ', 'BOOSTÉ');
INSERT INTO `lang_phrase` VALUES ('2377', '3', '6', 'title', '66', 'BOOSTÉ', 'BOOSTÉ');
INSERT INTO `lang_phrase` VALUES ('2378', '1', '6', 'title', '67', 'BALENCIAGA', 'BALENCIAGA');
INSERT INTO `lang_phrase` VALUES ('2379', '2', '6', 'title', '67', 'BALENCIAGA', 'BALENCIAGA');
INSERT INTO `lang_phrase` VALUES ('2380', '3', '6', 'title', '67', 'BALENCIAGA', 'BALENCIAGA');
INSERT INTO `lang_phrase` VALUES ('2381', '1', '6', 'title', '68', 'BALIBARIS', 'BALIBARIS');
INSERT INTO `lang_phrase` VALUES ('2382', '2', '6', 'title', '68', 'BALIBARIS', 'BALIBARIS');
INSERT INTO `lang_phrase` VALUES ('2383', '3', '6', 'title', '68', 'BALIBARIS', 'BALIBARIS');
INSERT INTO `lang_phrase` VALUES ('2384', '1', '6', 'title', '69', 'BALLY', 'BALLY');
INSERT INTO `lang_phrase` VALUES ('2385', '2', '6', 'title', '69', 'BALLY', 'BALLY');
INSERT INTO `lang_phrase` VALUES ('2386', '3', '6', 'title', '69', 'BALLY', 'BALLY');
INSERT INTO `lang_phrase` VALUES ('2387', '1', '6', 'title', '70', 'BANANA MOON', 'BANANA MOON');
INSERT INTO `lang_phrase` VALUES ('2388', '2', '6', 'title', '70', 'BANANA MOON', 'BANANA MOON');
INSERT INTO `lang_phrase` VALUES ('2389', '3', '6', 'title', '70', 'BANANA MOON', 'BANANA MOON');
INSERT INTO `lang_phrase` VALUES ('2390', '1', '6', 'title', '71', 'BARBARA RIHL', 'BARBARA RIHL');
INSERT INTO `lang_phrase` VALUES ('2391', '2', '6', 'title', '71', 'BARBARA RIHL', 'BARBARA RIHL');
INSERT INTO `lang_phrase` VALUES ('2392', '3', '6', 'title', '71', 'BARBARA RIHL', 'BARBARA RIHL');
INSERT INTO `lang_phrase` VALUES ('2393', '1', '6', 'title', '72', 'BARBOUR', 'BARBOUR');
INSERT INTO `lang_phrase` VALUES ('2394', '2', '6', 'title', '72', 'BARBOUR', 'BARBOUR');
INSERT INTO `lang_phrase` VALUES ('2395', '3', '6', 'title', '72', 'BARBOUR', 'BARBOUR');
INSERT INTO `lang_phrase` VALUES ('2396', '1', '6', 'title', '73', 'BARONS PAPILLOM', 'BARONS PAPILLOM');
INSERT INTO `lang_phrase` VALUES ('2397', '2', '6', 'title', '73', 'BARONS PAPILLOM', 'BARONS PAPILLOM');
INSERT INTO `lang_phrase` VALUES ('2398', '3', '6', 'title', '73', 'BARONS PAPILLOM', 'BARONS PAPILLOM');
INSERT INTO `lang_phrase` VALUES ('2399', '1', '6', 'title', '74', 'BATH', 'BATH');
INSERT INTO `lang_phrase` VALUES ('2400', '2', '6', 'title', '74', 'BATH', 'BATH');
INSERT INTO `lang_phrase` VALUES ('2401', '3', '6', 'title', '74', 'BATH', 'BATH');
INSERT INTO `lang_phrase` VALUES ('2402', '1', '6', 'title', '75', 'BAZAAR', 'BAZAAR');
INSERT INTO `lang_phrase` VALUES ('2403', '2', '6', 'title', '75', 'BAZAAR', 'BAZAAR');
INSERT INTO `lang_phrase` VALUES ('2404', '3', '6', 'title', '75', 'BAZAAR', 'BAZAAR');
INSERT INTO `lang_phrase` VALUES ('2405', '1', '6', 'title', '76', 'BAUME & MERCIER', 'BAUME & MERCIER');
INSERT INTO `lang_phrase` VALUES ('2406', '2', '6', 'title', '76', 'BAUME & MERCIER', 'BAUME & MERCIER');
INSERT INTO `lang_phrase` VALUES ('2407', '3', '6', 'title', '76', 'BAUME & MERCIER', 'BAUME & MERCIER');
INSERT INTO `lang_phrase` VALUES ('2408', '1', '6', 'title', '77', 'BEABA', 'BEABA');
INSERT INTO `lang_phrase` VALUES ('2409', '2', '6', 'title', '77', 'BEABA', 'BEABA');
INSERT INTO `lang_phrase` VALUES ('2410', '3', '6', 'title', '77', 'BEABA', 'BEABA');
INSERT INTO `lang_phrase` VALUES ('2411', '1', '6', 'title', '78', 'BELL & ROSS', 'BELL & ROSS');
INSERT INTO `lang_phrase` VALUES ('2412', '2', '6', 'title', '78', 'BELL & ROSS', 'BELL & ROSS');
INSERT INTO `lang_phrase` VALUES ('2413', '3', '6', 'title', '78', 'BELL & ROSS', 'BELL & ROSS');
INSERT INTO `lang_phrase` VALUES ('2414', '1', '6', 'title', '79', 'BEN SHERMAN', 'BEN SHERMAN');
INSERT INTO `lang_phrase` VALUES ('2415', '2', '6', 'title', '79', 'BEN SHERMAN', 'BEN SHERMAN');
INSERT INTO `lang_phrase` VALUES ('2416', '3', '6', 'title', '79', 'BEN SHERMAN', 'BEN SHERMAN');
INSERT INTO `lang_phrase` VALUES ('2417', '1', '6', 'title', '80', 'BÉRÉNICE', 'BÉRÉNICE');
INSERT INTO `lang_phrase` VALUES ('2418', '2', '6', 'title', '80', 'BÉRÉNICE', 'BÉRÉNICE');
INSERT INTO `lang_phrase` VALUES ('2419', '3', '6', 'title', '80', 'BÉRÉNICE', 'BÉRÉNICE');
INSERT INTO `lang_phrase` VALUES ('2420', '1', '6', 'title', '81', 'BERNARDAUD', 'BERNARDAUD');
INSERT INTO `lang_phrase` VALUES ('2421', '2', '6', 'title', '81', 'BERNARDAUD', 'BERNARDAUD');
INSERT INTO `lang_phrase` VALUES ('2422', '3', '6', 'title', '81', 'BERNARDAUD', 'BERNARDAUD');
INSERT INTO `lang_phrase` VALUES ('2423', '1', '6', 'title', '82', 'BIALETTI', 'BIALETTI');
INSERT INTO `lang_phrase` VALUES ('2424', '2', '6', 'title', '82', 'BIALETTI', 'BIALETTI');
INSERT INTO `lang_phrase` VALUES ('2425', '3', '6', 'title', '82', 'BIALETTI', 'BIALETTI');
INSERT INTO `lang_phrase` VALUES ('2426', '1', '6', 'title', '83', 'BIKINI BAR', 'BIKINI BAR');
INSERT INTO `lang_phrase` VALUES ('2427', '2', '6', 'title', '83', 'BIKINI BAR', 'BIKINI BAR');
INSERT INTO `lang_phrase` VALUES ('2428', '3', '6', 'title', '83', 'BIKINI BAR', 'BIKINI BAR');
INSERT INTO `lang_phrase` VALUES ('2429', '1', '6', 'title', '84', 'BILL TORNADE', 'BILL TORNADE');
INSERT INTO `lang_phrase` VALUES ('2430', '2', '6', 'title', '84', 'BILL TORNADE', 'BILL TORNADE');
INSERT INTO `lang_phrase` VALUES ('2431', '3', '6', 'title', '84', 'BILL TORNADE', 'BILL TORNADE');
INSERT INTO `lang_phrase` VALUES ('2432', '1', '6', 'title', '85', 'BILLABONG', 'BILLABONG');
INSERT INTO `lang_phrase` VALUES ('2433', '2', '6', 'title', '85', 'BILLABONG', 'BILLABONG');
INSERT INTO `lang_phrase` VALUES ('2434', '3', '6', 'title', '85', 'BILLABONG', 'BILLABONG');
INSERT INTO `lang_phrase` VALUES ('2435', '1', '6', 'title', '86', 'BILLIE BLUSH', 'BILLIE BLUSH');
INSERT INTO `lang_phrase` VALUES ('2436', '2', '6', 'title', '86', 'BILLIE BLUSH', 'BILLIE BLUSH');
INSERT INTO `lang_phrase` VALUES ('2437', '3', '6', 'title', '86', 'BILLIE BLUSH', 'BILLIE BLUSH');
INSERT INTO `lang_phrase` VALUES ('2438', '1', '6', 'title', '87', 'BILLYBANDIT', 'BILLYBANDIT');
INSERT INTO `lang_phrase` VALUES ('2439', '2', '6', 'title', '87', 'BILLYBANDIT', 'BILLYBANDIT');
INSERT INTO `lang_phrase` VALUES ('2440', '3', '6', 'title', '87', 'BILLYBANDIT', 'BILLYBANDIT');
INSERT INTO `lang_phrase` VALUES ('2441', '1', '6', 'title', '88', 'BIONDINI CHAUSSURES', 'BIONDINI CHAUSSURES');
INSERT INTO `lang_phrase` VALUES ('2442', '2', '6', 'title', '88', 'BIONDINI CHAUSSURES', 'BIONDINI CHAUSSURES');
INSERT INTO `lang_phrase` VALUES ('2443', '3', '6', 'title', '88', 'BIONDINI CHAUSSURES', 'BIONDINI CHAUSSURES');
INSERT INTO `lang_phrase` VALUES ('2444', '1', '6', 'title', '89', 'BIOTHERM', 'BIOTHERM');
INSERT INTO `lang_phrase` VALUES ('2445', '2', '6', 'title', '89', 'BIOTHERM', 'BIOTHERM');
INSERT INTO `lang_phrase` VALUES ('2446', '3', '6', 'title', '89', 'BIOTHERM', 'BIOTHERM');
INSERT INTO `lang_phrase` VALUES ('2447', '1', '6', 'title', '90', 'BLANCPAIN', 'BLANCPAIN');
INSERT INTO `lang_phrase` VALUES ('2448', '2', '6', 'title', '90', 'BLANCPAIN', 'BLANCPAIN');
INSERT INTO `lang_phrase` VALUES ('2449', '3', '6', 'title', '90', 'BLANCPAIN', 'BLANCPAIN');
INSERT INTO `lang_phrase` VALUES ('2450', '1', '6', 'title', '91', 'BLUE MARINE', 'BLUE MARINE');
INSERT INTO `lang_phrase` VALUES ('2451', '2', '6', 'title', '91', 'BLUE MARINE', 'BLUE MARINE');
INSERT INTO `lang_phrase` VALUES ('2452', '3', '6', 'title', '91', 'BLUE MARINE', 'BLUE MARINE');
INSERT INTO `lang_phrase` VALUES ('2453', '1', '6', 'title', '92', 'BOBBI', 'BOBBI');
INSERT INTO `lang_phrase` VALUES ('2454', '2', '6', 'title', '92', 'BOBBI', 'BOBBI');
INSERT INTO `lang_phrase` VALUES ('2455', '3', '6', 'title', '92', 'BOBBI', 'BOBBI');
INSERT INTO `lang_phrase` VALUES ('2456', '1', '6', 'title', '93', 'BROWN', 'BROWN');
INSERT INTO `lang_phrase` VALUES ('2457', '2', '6', 'title', '93', 'BROWN', 'BROWN');
INSERT INTO `lang_phrase` VALUES ('2458', '3', '6', 'title', '93', 'BROWN', 'BROWN');
INSERT INTO `lang_phrase` VALUES ('2459', '1', '6', 'title', '94', 'BOCAGE', 'BOCAGE');
INSERT INTO `lang_phrase` VALUES ('2460', '2', '6', 'title', '94', 'BOCAGE', 'BOCAGE');
INSERT INTO `lang_phrase` VALUES ('2461', '3', '6', 'title', '94', 'BOCAGE', 'BOCAGE');
INSERT INTO `lang_phrase` VALUES ('2462', '1', '6', 'title', '95', 'BODUM', 'BODUM');
INSERT INTO `lang_phrase` VALUES ('2463', '2', '6', 'title', '95', 'BODUM', 'BODUM');
INSERT INTO `lang_phrase` VALUES ('2464', '3', '6', 'title', '95', 'BODUM', 'BODUM');
INSERT INTO `lang_phrase` VALUES ('2465', '1', '6', 'title', '96', 'BOGGI', 'BOGGI');
INSERT INTO `lang_phrase` VALUES ('2466', '2', '6', 'title', '96', 'BOGGI', 'BOGGI');
INSERT INTO `lang_phrase` VALUES ('2467', '3', '6', 'title', '96', 'BOGGI', 'BOGGI');
INSERT INTO `lang_phrase` VALUES ('2468', '1', '6', 'title', '97', 'BOMBUM', 'BOMBUM');
INSERT INTO `lang_phrase` VALUES ('2469', '2', '6', 'title', '97', 'BOMBUM', 'BOMBUM');
INSERT INTO `lang_phrase` VALUES ('2470', '3', '6', 'title', '97', 'BOMBUM', 'BOMBUM');
INSERT INTO `lang_phrase` VALUES ('2471', '1', '6', 'title', '98', 'BONPOINT', 'BONPOINT');
INSERT INTO `lang_phrase` VALUES ('2472', '2', '6', 'title', '98', 'BONPOINT', 'BONPOINT');
INSERT INTO `lang_phrase` VALUES ('2473', '3', '6', 'title', '98', 'BONPOINT', 'BONPOINT');
INSERT INTO `lang_phrase` VALUES ('2474', '1', '6', 'title', '99', 'BONTON', 'BONTON');
INSERT INTO `lang_phrase` VALUES ('2475', '2', '6', 'title', '99', 'BONTON', 'BONTON');
INSERT INTO `lang_phrase` VALUES ('2476', '3', '6', 'title', '99', 'BONTON', 'BONTON');
INSERT INTO `lang_phrase` VALUES ('2477', '1', '6', 'title', '100', 'BOTTEGA VENETA', 'BOTTEGA VENETA');
INSERT INTO `lang_phrase` VALUES ('2478', '2', '6', 'title', '100', 'BOTTEGA VENETA', 'BOTTEGA VENETA');
INSERT INTO `lang_phrase` VALUES ('2479', '3', '6', 'title', '100', 'BOTTEGA VENETA', 'BOTTEGA VENETA');
INSERT INTO `lang_phrase` VALUES ('2480', '1', '6', 'title', '101', 'BOUCHERON', 'BOUCHERON');
INSERT INTO `lang_phrase` VALUES ('2481', '2', '6', 'title', '101', 'BOUCHERON', 'BOUCHERON');
INSERT INTO `lang_phrase` VALUES ('2482', '3', '6', 'title', '101', 'BOUCHERON', 'BOUCHERON');
INSERT INTO `lang_phrase` VALUES ('2483', '1', '6', 'title', '102', 'BOURJOIS', 'BOURJOIS');
INSERT INTO `lang_phrase` VALUES ('2484', '2', '6', 'title', '102', 'BOURJOIS', 'BOURJOIS');
INSERT INTO `lang_phrase` VALUES ('2485', '3', '6', 'title', '102', 'BOURJOIS', 'BOURJOIS');
INSERT INTO `lang_phrase` VALUES ('2486', '1', '6', 'title', '103', 'BOWEN', 'BOWEN');
INSERT INTO `lang_phrase` VALUES ('2487', '2', '6', 'title', '103', 'BOWEN', 'BOWEN');
INSERT INTO `lang_phrase` VALUES ('2488', '3', '6', 'title', '103', 'BOWEN', 'BOWEN');
INSERT INTO `lang_phrase` VALUES ('2489', '1', '6', 'title', '104', 'BREITLING', 'BREITLING');
INSERT INTO `lang_phrase` VALUES ('2490', '2', '6', 'title', '104', 'BREITLING', 'BREITLING');
INSERT INTO `lang_phrase` VALUES ('2491', '3', '6', 'title', '104', 'BREITLING', 'BREITLING');
INSERT INTO `lang_phrase` VALUES ('2492', '1', '6', 'title', '105', 'BRIC’S', 'BRIC’S');
INSERT INTO `lang_phrase` VALUES ('2493', '2', '6', 'title', '105', 'BRIC’S', 'BRIC’S');
INSERT INTO `lang_phrase` VALUES ('2494', '3', '6', 'title', '105', 'BRIC’S', 'BRIC’S');
INSERT INTO `lang_phrase` VALUES ('2495', '1', '6', 'title', '106', 'BRIEFING', 'BRIEFING');
INSERT INTO `lang_phrase` VALUES ('2496', '2', '6', 'title', '106', 'BRIEFING', 'BRIEFING');
INSERT INTO `lang_phrase` VALUES ('2497', '3', '6', 'title', '106', 'BRIEFING', 'BRIEFING');
INSERT INTO `lang_phrase` VALUES ('2498', '1', '6', 'title', '107', 'BRIO / VILAC', 'BRIO / VILAC');
INSERT INTO `lang_phrase` VALUES ('2499', '2', '6', 'title', '107', 'BRIO / VILAC', 'BRIO / VILAC');
INSERT INTO `lang_phrase` VALUES ('2500', '3', '6', 'title', '107', 'BRIO / VILAC', 'BRIO / VILAC');
INSERT INTO `lang_phrase` VALUES ('2501', '1', '6', 'title', '108', 'BRIONI', 'BRIONI');
INSERT INTO `lang_phrase` VALUES ('2502', '2', '6', 'title', '108', 'BRIONI', 'BRIONI');
INSERT INTO `lang_phrase` VALUES ('2503', '3', '6', 'title', '108', 'BRIONI', 'BRIONI');
INSERT INTO `lang_phrase` VALUES ('2504', '1', '6', 'title', '109', 'BUCCELLATI', 'BUCCELLATI');
INSERT INTO `lang_phrase` VALUES ('2505', '2', '6', 'title', '109', 'BUCCELLATI', 'BUCCELLATI');
INSERT INTO `lang_phrase` VALUES ('2506', '3', '6', 'title', '109', 'BUCCELLATI', 'BUCCELLATI');
INSERT INTO `lang_phrase` VALUES ('2507', '1', '6', 'title', '110', 'BUGABOO', 'BUGABOO');
INSERT INTO `lang_phrase` VALUES ('2508', '2', '6', 'title', '110', 'BUGABOO', 'BUGABOO');
INSERT INTO `lang_phrase` VALUES ('2509', '3', '6', 'title', '110', 'BUGABOO', 'BUGABOO');
INSERT INTO `lang_phrase` VALUES ('2510', '1', '6', 'title', '111', 'BULGARI', 'BULGARI');
INSERT INTO `lang_phrase` VALUES ('2511', '2', '6', 'title', '111', 'BULGARI', 'BULGARI');
INSERT INTO `lang_phrase` VALUES ('2512', '3', '6', 'title', '111', 'BULGARI', 'BULGARI');
INSERT INTO `lang_phrase` VALUES ('2513', '1', '6', 'title', '112', 'BULY', 'BULY');
INSERT INTO `lang_phrase` VALUES ('2514', '2', '6', 'title', '112', 'BULY', 'BULY');
INSERT INTO `lang_phrase` VALUES ('2515', '3', '6', 'title', '112', 'BULY', 'BULY');
INSERT INTO `lang_phrase` VALUES ('2516', '1', '6', 'title', '113', 'BURBERRY', 'BURBERRY');
INSERT INTO `lang_phrase` VALUES ('2517', '2', '6', 'title', '113', 'BURBERRY', 'BURBERRY');
INSERT INTO `lang_phrase` VALUES ('2518', '3', '6', 'title', '113', 'BURBERRY', 'BURBERRY');
INSERT INTO `lang_phrase` VALUES ('2519', '1', '6', 'title', '114', 'BVT (BRUN DE VIAN-TIRAN)', 'BVT (BRUN DE VIAN-TIRAN)');
INSERT INTO `lang_phrase` VALUES ('2520', '2', '6', 'title', '114', 'BVT (BRUN DE VIAN-TIRAN)', 'BVT (BRUN DE VIAN-TIRAN)');
INSERT INTO `lang_phrase` VALUES ('2521', '3', '6', 'title', '114', 'BVT (BRUN DE VIAN-TIRAN)', 'BVT (BRUN DE VIAN-TIRAN)');
INSERT INTO `lang_phrase` VALUES ('2522', '1', '6', 'title', '115', 'BY MALENE BIRGER', 'BY MALENE BIRGER');
INSERT INTO `lang_phrase` VALUES ('2523', '2', '6', 'title', '115', 'BY MALENE BIRGER', 'BY MALENE BIRGER');
INSERT INTO `lang_phrase` VALUES ('2524', '3', '6', 'title', '115', 'BY MALENE BIRGER', 'BY MALENE BIRGER');
INSERT INTO `lang_phrase` VALUES ('2525', '1', '6', 'title', '116', 'BY REDO', 'BY REDO');
INSERT INTO `lang_phrase` VALUES ('2526', '2', '6', 'title', '116', 'BY REDO', 'BY REDO');
INSERT INTO `lang_phrase` VALUES ('2527', '3', '6', 'title', '116', 'BY REDO', 'BY REDO');
INSERT INTO `lang_phrase` VALUES ('2528', '1', '6', 'title', '117', 'C DE C (CORDELIA DE CASTELLANE)', 'C DE C (CORDELIA DE CASTELLANE)');
INSERT INTO `lang_phrase` VALUES ('2529', '2', '6', 'title', '117', 'C DE C (CORDELIA DE CASTELLANE)', 'C DE C (CORDELIA DE CASTELLANE)');
INSERT INTO `lang_phrase` VALUES ('2530', '3', '6', 'title', '117', 'C DE C (CORDELIA DE CASTELLANE)', 'C DE C (CORDELIA DE CASTELLANE)');
INSERT INTO `lang_phrase` VALUES ('2531', '1', '6', 'title', '118', 'CACHAREL', 'CACHAREL');
INSERT INTO `lang_phrase` VALUES ('2532', '2', '6', 'title', '118', 'CACHAREL', 'CACHAREL');
INSERT INTO `lang_phrase` VALUES ('2533', '3', '6', 'title', '118', 'CACHAREL', 'CACHAREL');
INSERT INTO `lang_phrase` VALUES ('2534', '1', '6', 'title', '119', 'CADET ROUSSELLE', 'CADET ROUSSELLE');
INSERT INTO `lang_phrase` VALUES ('2535', '2', '6', 'title', '119', 'CADET ROUSSELLE', 'CADET ROUSSELLE');
INSERT INTO `lang_phrase` VALUES ('2536', '3', '6', 'title', '119', 'CADET ROUSSELLE', 'CADET ROUSSELLE');
INSERT INTO `lang_phrase` VALUES ('2537', '1', '6', 'title', '120', 'CALIPIGE', 'CALIPIGE');
INSERT INTO `lang_phrase` VALUES ('2538', '2', '6', 'title', '120', 'CALIPIGE', 'CALIPIGE');
INSERT INTO `lang_phrase` VALUES ('2539', '3', '6', 'title', '120', 'CALIPIGE', 'CALIPIGE');
INSERT INTO `lang_phrase` VALUES ('2540', '1', '6', 'title', '121', 'CALVIN KLEIN', 'CALVIN KLEIN');
INSERT INTO `lang_phrase` VALUES ('2541', '2', '6', 'title', '121', 'CALVIN KLEIN', 'CALVIN KLEIN');
INSERT INTO `lang_phrase` VALUES ('2542', '3', '6', 'title', '121', 'CALVIN KLEIN', 'CALVIN KLEIN');
INSERT INTO `lang_phrase` VALUES ('2543', '1', '6', 'title', '122', 'CAMPER', 'CAMPER');
INSERT INTO `lang_phrase` VALUES ('2544', '2', '6', 'title', '122', 'CAMPER', 'CAMPER');
INSERT INTO `lang_phrase` VALUES ('2545', '3', '6', 'title', '122', 'CAMPER', 'CAMPER');
INSERT INTO `lang_phrase` VALUES ('2546', '1', '6', 'title', '123', 'CANADA GOOSE', 'CANADA GOOSE');
INSERT INTO `lang_phrase` VALUES ('2547', '2', '6', 'title', '123', 'CANADA GOOSE', 'CANADA GOOSE');
INSERT INTO `lang_phrase` VALUES ('2548', '3', '6', 'title', '123', 'CANADA GOOSE', 'CANADA GOOSE');
INSERT INTO `lang_phrase` VALUES ('2549', '1', '6', 'title', '124', 'CANASUC', 'CANASUC');
INSERT INTO `lang_phrase` VALUES ('2550', '2', '6', 'title', '124', 'CANASUC', 'CANASUC');
INSERT INTO `lang_phrase` VALUES ('2551', '3', '6', 'title', '124', 'CANASUC', 'CANASUC');
INSERT INTO `lang_phrase` VALUES ('2552', '1', '6', 'title', '125', 'CANOBIO', 'CANOBIO');
INSERT INTO `lang_phrase` VALUES ('2553', '2', '6', 'title', '125', 'CANOBIO', 'CANOBIO');
INSERT INTO `lang_phrase` VALUES ('2554', '3', '6', 'title', '125', 'CANOBIO', 'CANOBIO');
INSERT INTO `lang_phrase` VALUES ('2555', '1', '6', 'title', '126', 'CARAN D’ACHE', 'CARAN D’ACHE');
INSERT INTO `lang_phrase` VALUES ('2556', '2', '6', 'title', '126', 'CARAN D’ACHE', 'CARAN D’ACHE');
INSERT INTO `lang_phrase` VALUES ('2557', '3', '6', 'title', '126', 'CARAN D’ACHE', 'CARAN D’ACHE');
INSERT INTO `lang_phrase` VALUES ('2558', '1', '6', 'title', '127', 'CARDO', 'CARDO');
INSERT INTO `lang_phrase` VALUES ('2559', '2', '6', 'title', '127', 'CARDO', 'CARDO');
INSERT INTO `lang_phrase` VALUES ('2560', '3', '6', 'title', '127', 'CARDO', 'CARDO');
INSERT INTO `lang_phrase` VALUES ('2561', '1', '6', 'title', '128', 'CAREL', 'CAREL');
INSERT INTO `lang_phrase` VALUES ('2562', '2', '6', 'title', '128', 'CAREL', 'CAREL');
INSERT INTO `lang_phrase` VALUES ('2563', '3', '6', 'title', '128', 'CAREL', 'CAREL');
INSERT INTO `lang_phrase` VALUES ('2564', '1', '6', 'title', '129', 'CARHARTT', 'CARHARTT');
INSERT INTO `lang_phrase` VALUES ('2565', '2', '6', 'title', '129', 'CARHARTT', 'CARHARTT');
INSERT INTO `lang_phrase` VALUES ('2566', '3', '6', 'title', '129', 'CARHARTT', 'CARHARTT');
INSERT INTO `lang_phrase` VALUES ('2567', '1', '6', 'title', '130', 'CARIOCA', 'CARIOCA');
INSERT INTO `lang_phrase` VALUES ('2568', '2', '6', 'title', '130', 'CARIOCA', 'CARIOCA');
INSERT INTO `lang_phrase` VALUES ('2569', '3', '6', 'title', '130', 'CARIOCA', 'CARIOCA');
INSERT INTO `lang_phrase` VALUES ('2570', '1', '6', 'title', '131', 'CAROLINA HERRERA', 'CAROLINA HERRERA');
INSERT INTO `lang_phrase` VALUES ('2571', '2', '6', 'title', '131', 'CAROLINA HERRERA', 'CAROLINA HERRERA');
INSERT INTO `lang_phrase` VALUES ('2572', '3', '6', 'title', '131', 'CAROLINA HERRERA', 'CAROLINA HERRERA');
INSERT INTO `lang_phrase` VALUES ('2573', '1', '6', 'title', '132', 'CAROLINE NAJMAN', 'CAROLINE NAJMAN');
INSERT INTO `lang_phrase` VALUES ('2574', '2', '6', 'title', '132', 'CAROLINE NAJMAN', 'CAROLINE NAJMAN');
INSERT INTO `lang_phrase` VALUES ('2575', '3', '6', 'title', '132', 'CAROLINE NAJMAN', 'CAROLINE NAJMAN');
INSERT INTO `lang_phrase` VALUES ('2576', '1', '6', 'title', '133', 'CAROLL', 'CAROLL');
INSERT INTO `lang_phrase` VALUES ('2577', '2', '6', 'title', '133', 'CAROLL', 'CAROLL');
INSERT INTO `lang_phrase` VALUES ('2578', '3', '6', 'title', '133', 'CAROLL', 'CAROLL');
INSERT INTO `lang_phrase` VALUES ('2579', '1', '6', 'title', '134', 'CARRÉ BLANC', 'CARRÉ BLANC');
INSERT INTO `lang_phrase` VALUES ('2580', '2', '6', 'title', '134', 'CARRÉ BLANC', 'CARRÉ BLANC');
INSERT INTO `lang_phrase` VALUES ('2581', '3', '6', 'title', '134', 'CARRÉ BLANC', 'CARRÉ BLANC');
INSERT INTO `lang_phrase` VALUES ('2582', '1', '6', 'title', '135', 'CARRÉ ROYAL', 'CARRÉ ROYAL');
INSERT INTO `lang_phrase` VALUES ('2583', '2', '6', 'title', '135', 'CARRÉ ROYAL', 'CARRÉ ROYAL');
INSERT INTO `lang_phrase` VALUES ('2584', '3', '6', 'title', '135', 'CARRÉ ROYAL', 'CARRÉ ROYAL');
INSERT INTO `lang_phrase` VALUES ('2585', '1', '6', 'title', '136', 'CARRÉMENT BEAU', 'CARRÉMENT BEAU');
INSERT INTO `lang_phrase` VALUES ('2586', '2', '6', 'title', '136', 'CARRÉMENT BEAU', 'CARRÉMENT BEAU');
INSERT INTO `lang_phrase` VALUES ('2587', '3', '6', 'title', '136', 'CARRÉMENT BEAU', 'CARRÉMENT BEAU');
INSERT INTO `lang_phrase` VALUES ('2588', '1', '6', 'title', '137', 'CARTIER', 'CARTIER');
INSERT INTO `lang_phrase` VALUES ('2589', '2', '6', 'title', '137', 'CARTIER', 'CARTIER');
INSERT INTO `lang_phrase` VALUES ('2590', '3', '6', 'title', '137', 'CARTIER', 'CARTIER');
INSERT INTO `lang_phrase` VALUES ('2591', '1', '6', 'title', '138', 'CARVEN', 'CARVEN');
INSERT INTO `lang_phrase` VALUES ('2592', '2', '6', 'title', '138', 'CARVEN', 'CARVEN');
INSERT INTO `lang_phrase` VALUES ('2593', '3', '6', 'title', '138', 'CARVEN', 'CARVEN');
INSERT INTO `lang_phrase` VALUES ('2594', '1', '6', 'title', '139', 'CASIO', 'CASIO');
INSERT INTO `lang_phrase` VALUES ('2595', '2', '6', 'title', '139', 'CASIO', 'CASIO');
INSERT INTO `lang_phrase` VALUES ('2596', '3', '6', 'title', '139', 'CASIO', 'CASIO');
INSERT INTO `lang_phrase` VALUES ('2597', '1', '6', 'title', '140', 'CATH KIDSTON', 'CATH KIDSTON');
INSERT INTO `lang_phrase` VALUES ('2598', '2', '6', 'title', '140', 'CATH KIDSTON', 'CATH KIDSTON');
INSERT INTO `lang_phrase` VALUES ('2599', '3', '6', 'title', '140', 'CATH KIDSTON', 'CATH KIDSTON');
INSERT INTO `lang_phrase` VALUES ('2600', '1', '6', 'title', '141', 'CATIMINI', 'CATIMINI');
INSERT INTO `lang_phrase` VALUES ('2601', '2', '6', 'title', '141', 'CATIMINI', 'CATIMINI');
INSERT INTO `lang_phrase` VALUES ('2602', '3', '6', 'title', '141', 'CATIMINI', 'CATIMINI');
INSERT INTO `lang_phrase` VALUES ('2603', '1', '6', 'title', '142', 'CATOUNETTE', 'CATOUNETTE');
INSERT INTO `lang_phrase` VALUES ('2604', '2', '6', 'title', '142', 'CATOUNETTE', 'CATOUNETTE');
INSERT INTO `lang_phrase` VALUES ('2605', '3', '6', 'title', '142', 'CATOUNETTE', 'CATOUNETTE');
INSERT INTO `lang_phrase` VALUES ('2606', '1', '6', 'title', '143', 'CAUDALIE', 'CAUDALIE');
INSERT INTO `lang_phrase` VALUES ('2607', '2', '6', 'title', '143', 'CAUDALIE', 'CAUDALIE');
INSERT INTO `lang_phrase` VALUES ('2608', '3', '6', 'title', '143', 'CAUDALIE', 'CAUDALIE');
INSERT INTO `lang_phrase` VALUES ('2609', '1', '6', 'title', '144', 'CÉLINE', 'CÉLINE');
INSERT INTO `lang_phrase` VALUES ('2610', '2', '6', 'title', '144', 'CÉLINE', 'CÉLINE');
INSERT INTO `lang_phrase` VALUES ('2611', '3', '6', 'title', '144', 'CÉLINE', 'CÉLINE');
INSERT INTO `lang_phrase` VALUES ('2612', '1', '6', 'title', '145', 'CERRUTI', 'CERRUTI');
INSERT INTO `lang_phrase` VALUES ('2613', '2', '6', 'title', '145', 'CERRUTI', 'CERRUTI');
INSERT INTO `lang_phrase` VALUES ('2614', '3', '6', 'title', '145', 'CERRUTI', 'CERRUTI');
INSERT INTO `lang_phrase` VALUES ('2615', '1', '6', 'title', '146', 'CERRUTI JEANS', 'CERRUTI JEANS');
INSERT INTO `lang_phrase` VALUES ('2616', '2', '6', 'title', '146', 'CERRUTI JEANS', 'CERRUTI JEANS');
INSERT INTO `lang_phrase` VALUES ('2617', '3', '6', 'title', '146', 'CERRUTI JEANS', 'CERRUTI JEANS');
INSERT INTO `lang_phrase` VALUES ('2618', '1', '6', 'title', '147', 'CHANEL', 'CHANEL');
INSERT INTO `lang_phrase` VALUES ('2619', '2', '6', 'title', '147', 'CHANEL', 'CHANEL');
INSERT INTO `lang_phrase` VALUES ('2620', '3', '6', 'title', '147', 'CHANEL', 'CHANEL');
INSERT INTO `lang_phrase` VALUES ('2621', '1', '6', 'title', '148', 'CHANEL HORLOGERIE', 'CHANEL HORLOGERIE');
INSERT INTO `lang_phrase` VALUES ('2622', '2', '6', 'title', '148', 'CHANEL HORLOGERIE', 'CHANEL HORLOGERIE');
INSERT INTO `lang_phrase` VALUES ('2623', '3', '6', 'title', '148', 'CHANEL HORLOGERIE', 'CHANEL HORLOGERIE');
INSERT INTO `lang_phrase` VALUES ('2624', '1', '6', 'title', '149', 'CHANTAL THOMASS', 'CHANTAL THOMASS');
INSERT INTO `lang_phrase` VALUES ('2625', '2', '6', 'title', '149', 'CHANTAL THOMASS', 'CHANTAL THOMASS');
INSERT INTO `lang_phrase` VALUES ('2626', '3', '6', 'title', '149', 'CHANTAL THOMASS', 'CHANTAL THOMASS');
INSERT INTO `lang_phrase` VALUES ('2627', '1', '6', 'title', '150', 'CHANTELLE', 'CHANTELLE');
INSERT INTO `lang_phrase` VALUES ('2628', '2', '6', 'title', '150', 'CHANTELLE', 'CHANTELLE');
INSERT INTO `lang_phrase` VALUES ('2629', '3', '6', 'title', '150', 'CHANTELLE', 'CHANTELLE');
INSERT INTO `lang_phrase` VALUES ('2630', '1', '6', 'title', '151', 'CHARABIA', 'CHARABIA');
INSERT INTO `lang_phrase` VALUES ('2631', '2', '6', 'title', '151', 'CHARABIA', 'CHARABIA');
INSERT INTO `lang_phrase` VALUES ('2632', '3', '6', 'title', '151', 'CHARABIA', 'CHARABIA');
INSERT INTO `lang_phrase` VALUES ('2633', '1', '6', 'title', '152', 'CHARLES & KEITH', 'CHARLES & KEITH');
INSERT INTO `lang_phrase` VALUES ('2634', '2', '6', 'title', '152', 'CHARLES & KEITH', 'CHARLES & KEITH');
INSERT INTO `lang_phrase` VALUES ('2635', '3', '6', 'title', '152', 'CHARLES & KEITH', 'CHARLES & KEITH');
INSERT INTO `lang_phrase` VALUES ('2636', '1', '6', 'title', '153', 'CHARLES KAMMER', 'CHARLES KAMMER');
INSERT INTO `lang_phrase` VALUES ('2637', '2', '6', 'title', '153', 'CHARLES KAMMER', 'CHARLES KAMMER');
INSERT INTO `lang_phrase` VALUES ('2638', '3', '6', 'title', '153', 'CHARLES KAMMER', 'CHARLES KAMMER');
INSERT INTO `lang_phrase` VALUES ('2639', '1', '6', 'title', '154', 'CHARRIER CHAUMET', 'CHARRIER CHAUMET');
INSERT INTO `lang_phrase` VALUES ('2640', '2', '6', 'title', '154', 'CHARRIER CHAUMET', 'CHARRIER CHAUMET');
INSERT INTO `lang_phrase` VALUES ('2641', '3', '6', 'title', '154', 'CHARRIER CHAUMET', 'CHARRIER CHAUMET');
INSERT INTO `lang_phrase` VALUES ('2642', '1', '6', 'title', '155', 'CHEF & SOMMELIER', 'CHEF & SOMMELIER');
INSERT INTO `lang_phrase` VALUES ('2643', '2', '6', 'title', '155', 'CHEF & SOMMELIER', 'CHEF & SOMMELIER');
INSERT INTO `lang_phrase` VALUES ('2644', '3', '6', 'title', '155', 'CHEF & SOMMELIER', 'CHEF & SOMMELIER');
INSERT INTO `lang_phrase` VALUES ('2645', '1', '6', 'title', '156', 'CHEVIGNON', 'CHEVIGNON');
INSERT INTO `lang_phrase` VALUES ('2646', '2', '6', 'title', '156', 'CHEVIGNON', 'CHEVIGNON');
INSERT INTO `lang_phrase` VALUES ('2647', '3', '6', 'title', '156', 'CHEVIGNON', 'CHEVIGNON');
INSERT INTO `lang_phrase` VALUES ('2648', '1', '6', 'title', '157', 'CHILEWICH', 'CHILEWICH');
INSERT INTO `lang_phrase` VALUES ('2649', '2', '6', 'title', '157', 'CHILEWICH', 'CHILEWICH');
INSERT INTO `lang_phrase` VALUES ('2650', '3', '6', 'title', '157', 'CHILEWICH', 'CHILEWICH');
INSERT INTO `lang_phrase` VALUES ('2651', '1', '6', 'title', '158', 'CHIPIE', 'CHIPIE');
INSERT INTO `lang_phrase` VALUES ('2652', '2', '6', 'title', '158', 'CHIPIE', 'CHIPIE');
INSERT INTO `lang_phrase` VALUES ('2653', '3', '6', 'title', '158', 'CHIPIE', 'CHIPIE');
INSERT INTO `lang_phrase` VALUES ('2654', '1', '6', 'title', '159', 'CHLOÉ', 'CHLOÉ');
INSERT INTO `lang_phrase` VALUES ('2655', '2', '6', 'title', '159', 'CHLOÉ', 'CHLOÉ');
INSERT INTO `lang_phrase` VALUES ('2656', '3', '6', 'title', '159', 'CHLOÉ', 'CHLOÉ');
INSERT INTO `lang_phrase` VALUES ('2657', '1', '6', 'title', '160', 'CHOPARD', 'CHOPARD');
INSERT INTO `lang_phrase` VALUES ('2658', '2', '6', 'title', '160', 'CHOPARD', 'CHOPARD');
INSERT INTO `lang_phrase` VALUES ('2659', '3', '6', 'title', '160', 'CHOPARD', 'CHOPARD');
INSERT INTO `lang_phrase` VALUES ('2660', '1', '6', 'title', '161', 'CHRISTIAN BRETON', 'CHRISTIAN BRETON');
INSERT INTO `lang_phrase` VALUES ('2661', '2', '6', 'title', '161', 'CHRISTIAN BRETON', 'CHRISTIAN BRETON');
INSERT INTO `lang_phrase` VALUES ('2662', '3', '6', 'title', '161', 'CHRISTIAN BRETON', 'CHRISTIAN BRETON');
INSERT INTO `lang_phrase` VALUES ('2663', '1', '6', 'title', '162', 'CHRISTIAN CANE', 'CHRISTIAN CANE');
INSERT INTO `lang_phrase` VALUES ('2664', '2', '6', 'title', '162', 'CHRISTIAN CANE', 'CHRISTIAN CANE');
INSERT INTO `lang_phrase` VALUES ('2665', '3', '6', 'title', '162', 'CHRISTIAN CANE', 'CHRISTIAN CANE');
INSERT INTO `lang_phrase` VALUES ('2666', '1', '6', 'title', '163', 'CHRISTOFLE', 'CHRISTOFLE');
INSERT INTO `lang_phrase` VALUES ('2667', '2', '6', 'title', '163', 'CHRISTOFLE', 'CHRISTOFLE');
INSERT INTO `lang_phrase` VALUES ('2668', '3', '6', 'title', '163', 'CHRISTOFLE', 'CHRISTOFLE');
INSERT INTO `lang_phrase` VALUES ('2669', '1', '6', 'title', '164', 'CHRISTOPHER KANE', 'CHRISTOPHER KANE');
INSERT INTO `lang_phrase` VALUES ('2670', '2', '6', 'title', '164', 'CHRISTOPHER KANE', 'CHRISTOPHER KANE');
INSERT INTO `lang_phrase` VALUES ('2671', '3', '6', 'title', '164', 'CHRISTOPHER KANE', 'CHRISTOPHER KANE');
INSERT INTO `lang_phrase` VALUES ('2672', '1', '6', 'title', '165', 'CHURCH’S', 'CHURCH’S');
INSERT INTO `lang_phrase` VALUES ('2673', '2', '6', 'title', '165', 'CHURCH’S', 'CHURCH’S');
INSERT INTO `lang_phrase` VALUES ('2674', '3', '6', 'title', '165', 'CHURCH’S', 'CHURCH’S');
INSERT INTO `lang_phrase` VALUES ('2675', '1', '6', 'title', '166', 'CLAIRE’S', 'CLAIRE’S');
INSERT INTO `lang_phrase` VALUES ('2676', '2', '6', 'title', '166', 'CLAIRE’S', 'CLAIRE’S');
INSERT INTO `lang_phrase` VALUES ('2677', '3', '6', 'title', '166', 'CLAIRE’S', 'CLAIRE’S');
INSERT INTO `lang_phrase` VALUES ('2678', '1', '6', 'title', '167', 'CLARINS', 'CLARINS');
INSERT INTO `lang_phrase` VALUES ('2679', '2', '6', 'title', '167', 'CLARINS', 'CLARINS');
INSERT INTO `lang_phrase` VALUES ('2680', '3', '6', 'title', '167', 'CLARINS', 'CLARINS');
INSERT INTO `lang_phrase` VALUES ('2681', '1', '6', 'title', '168', 'CLARKS', 'CLARKS');
INSERT INTO `lang_phrase` VALUES ('2682', '2', '6', 'title', '168', 'CLARKS', 'CLARKS');
INSERT INTO `lang_phrase` VALUES ('2683', '3', '6', 'title', '168', 'CLARKS', 'CLARKS');
INSERT INTO `lang_phrase` VALUES ('2684', '1', '6', 'title', '169', 'CLAUDIE PIERLOT', 'CLAUDIE PIERLOT');
INSERT INTO `lang_phrase` VALUES ('2685', '2', '6', 'title', '169', 'CLAUDIE PIERLOT', 'CLAUDIE PIERLOT');
INSERT INTO `lang_phrase` VALUES ('2686', '3', '6', 'title', '169', 'CLAUDIE PIERLOT', 'CLAUDIE PIERLOT');
INSERT INTO `lang_phrase` VALUES ('2687', '1', '6', 'title', '170', 'CLINIQUE', 'CLINIQUE');
INSERT INTO `lang_phrase` VALUES ('2688', '2', '6', 'title', '170', 'CLINIQUE', 'CLINIQUE');
INSERT INTO `lang_phrase` VALUES ('2689', '3', '6', 'title', '170', 'CLINIQUE', 'CLINIQUE');
INSERT INTO `lang_phrase` VALUES ('2690', '1', '6', 'title', '171', 'CLIO BLUE', 'CLIO BLUE');
INSERT INTO `lang_phrase` VALUES ('2691', '2', '6', 'title', '171', 'CLIO BLUE', 'CLIO BLUE');
INSERT INTO `lang_phrase` VALUES ('2692', '3', '6', 'title', '171', 'CLIO BLUE', 'CLIO BLUE');
INSERT INTO `lang_phrase` VALUES ('2693', '1', '6', 'title', '172', 'COACH', 'COACH');
INSERT INTO `lang_phrase` VALUES ('2694', '2', '6', 'title', '172', 'COACH', 'COACH');
INSERT INTO `lang_phrase` VALUES ('2695', '3', '6', 'title', '172', 'COACH', 'COACH');
INSERT INTO `lang_phrase` VALUES ('2696', '1', '6', 'title', '173', 'COLISÉE DE SACHA', 'COLISÉE DE SACHA');
INSERT INTO `lang_phrase` VALUES ('2697', '2', '6', 'title', '173', 'COLISÉE DE SACHA', 'COLISÉE DE SACHA');
INSERT INTO `lang_phrase` VALUES ('2698', '3', '6', 'title', '173', 'COLISÉE DE SACHA', 'COLISÉE DE SACHA');
INSERT INTO `lang_phrase` VALUES ('2699', '1', '6', 'title', '174', 'COMME DES GARÇONS', 'COMME DES GARÇONS');
INSERT INTO `lang_phrase` VALUES ('2700', '2', '6', 'title', '174', 'COMME DES GARÇONS', 'COMME DES GARÇONS');
INSERT INTO `lang_phrase` VALUES ('2701', '3', '6', 'title', '174', 'COMME DES GARÇONS', 'COMME DES GARÇONS');
INSERT INTO `lang_phrase` VALUES ('2702', '1', '6', 'title', '175', 'COMPTOIR DES COTONNIERS', 'COMPTOIR DES COTONNIERS');
INSERT INTO `lang_phrase` VALUES ('2703', '2', '6', 'title', '175', 'COMPTOIR DES COTONNIERS', 'COMPTOIR DES COTONNIERS');
INSERT INTO `lang_phrase` VALUES ('2704', '3', '6', 'title', '175', 'COMPTOIR DES COTONNIERS', 'COMPTOIR DES COTONNIERS');
INSERT INTO `lang_phrase` VALUES ('2705', '1', '6', 'title', '176', 'CONVERSE', 'CONVERSE');
INSERT INTO `lang_phrase` VALUES ('2706', '2', '6', 'title', '176', 'CONVERSE', 'CONVERSE');
INSERT INTO `lang_phrase` VALUES ('2707', '3', '6', 'title', '176', 'CONVERSE', 'CONVERSE');
INSERT INTO `lang_phrase` VALUES ('2708', '1', '6', 'title', '177', 'COP COPINE', 'COP COPINE');
INSERT INTO `lang_phrase` VALUES ('2709', '2', '6', 'title', '177', 'COP COPINE', 'COP COPINE');
INSERT INTO `lang_phrase` VALUES ('2710', '3', '6', 'title', '177', 'COP COPINE', 'COP COPINE');
INSERT INTO `lang_phrase` VALUES ('2711', '1', '6', 'title', '178', 'COROLLE', 'COROLLE');
INSERT INTO `lang_phrase` VALUES ('2712', '2', '6', 'title', '178', 'COROLLE', 'COROLLE');
INSERT INTO `lang_phrase` VALUES ('2713', '3', '6', 'title', '178', 'COROLLE', 'COROLLE');
INSERT INTO `lang_phrase` VALUES ('2714', '1', '6', 'title', '179', 'CORTHAY', 'CORTHAY');
INSERT INTO `lang_phrase` VALUES ('2715', '2', '6', 'title', '179', 'CORTHAY', 'CORTHAY');
INSERT INTO `lang_phrase` VALUES ('2716', '3', '6', 'title', '179', 'CORTHAY', 'CORTHAY');
INSERT INTO `lang_phrase` VALUES ('2717', '1', '6', 'title', '180', 'COS', 'COS');
INSERT INTO `lang_phrase` VALUES ('2718', '2', '6', 'title', '180', 'COS', 'COS');
INSERT INTO `lang_phrase` VALUES ('2719', '3', '6', 'title', '180', 'COS', 'COS');
INSERT INTO `lang_phrase` VALUES ('2720', '1', '6', 'title', '181', 'COSA BELLA', 'COSA BELLA');
INSERT INTO `lang_phrase` VALUES ('2721', '2', '6', 'title', '181', 'COSA BELLA', 'COSA BELLA');
INSERT INTO `lang_phrase` VALUES ('2722', '3', '6', 'title', '181', 'COSA BELLA', 'COSA BELLA');
INSERT INTO `lang_phrase` VALUES ('2723', '1', '6', 'title', '182', 'COSMOPARIS', 'COSMOPARIS');
INSERT INTO `lang_phrase` VALUES ('2724', '2', '6', 'title', '182', 'COSMOPARIS', 'COSMOPARIS');
INSERT INTO `lang_phrase` VALUES ('2725', '3', '6', 'title', '182', 'COSMOPARIS', 'COSMOPARIS');
INSERT INTO `lang_phrase` VALUES ('2726', '1', '6', 'title', '183', 'COTÉLAC', 'COTÉLAC');
INSERT INTO `lang_phrase` VALUES ('2727', '2', '6', 'title', '183', 'COTÉLAC', 'COTÉLAC');
INSERT INTO `lang_phrase` VALUES ('2728', '3', '6', 'title', '183', 'COTÉLAC', 'COTÉLAC');
INSERT INTO `lang_phrase` VALUES ('2729', '1', '6', 'title', '184', 'COUZON', 'COUZON');
INSERT INTO `lang_phrase` VALUES ('2730', '2', '6', 'title', '184', 'COUZON', 'COUZON');
INSERT INTO `lang_phrase` VALUES ('2731', '3', '6', 'title', '184', 'COUZON', 'COUZON');
INSERT INTO `lang_phrase` VALUES ('2732', '1', '6', 'title', '185', 'CRAYOLA', 'CRAYOLA');
INSERT INTO `lang_phrase` VALUES ('2733', '2', '6', 'title', '185', 'CRAYOLA', 'CRAYOLA');
INSERT INTO `lang_phrase` VALUES ('2734', '3', '6', 'title', '185', 'CRAYOLA', 'CRAYOLA');
INSERT INTO `lang_phrase` VALUES ('2735', '1', '6', 'title', '186', 'CRÈME DE LA MER', 'CRÈME DE LA MER');
INSERT INTO `lang_phrase` VALUES ('2736', '2', '6', 'title', '186', 'CRÈME DE LA MER', 'CRÈME DE LA MER');
INSERT INTO `lang_phrase` VALUES ('2737', '3', '6', 'title', '186', 'CRÈME DE LA MER', 'CRÈME DE LA MER');
INSERT INTO `lang_phrase` VALUES ('2738', '1', '6', 'title', '187', 'CRISTAL DE SÈVRES', 'CRISTAL DE SÈVRES');
INSERT INTO `lang_phrase` VALUES ('2739', '2', '6', 'title', '187', 'CRISTAL DE SÈVRES', 'CRISTAL DE SÈVRES');
INSERT INTO `lang_phrase` VALUES ('2740', '3', '6', 'title', '187', 'CRISTAL DE SÈVRES', 'CRISTAL DE SÈVRES');
INSERT INTO `lang_phrase` VALUES ('2741', '1', '6', 'title', '188', 'CRISTEL', 'CRISTEL');
INSERT INTO `lang_phrase` VALUES ('2742', '2', '6', 'title', '188', 'CRISTEL', 'CRISTEL');
INSERT INTO `lang_phrase` VALUES ('2743', '3', '6', 'title', '188', 'CRISTEL', 'CRISTEL');
INSERT INTO `lang_phrase` VALUES ('2744', '1', '6', 'title', '189', 'CROSS', 'CROSS');
INSERT INTO `lang_phrase` VALUES ('2745', '2', '6', 'title', '189', 'CROSS', 'CROSS');
INSERT INTO `lang_phrase` VALUES ('2746', '3', '6', 'title', '189', 'CROSS', 'CROSS');
INSERT INTO `lang_phrase` VALUES ('2747', '1', '6', 'title', '190', 'CUCINELLI', 'CUCINELLI');
INSERT INTO `lang_phrase` VALUES ('2748', '2', '6', 'title', '190', 'CUCINELLI', 'CUCINELLI');
INSERT INTO `lang_phrase` VALUES ('2749', '3', '6', 'title', '190', 'CUCINELLI', 'CUCINELLI');
INSERT INTO `lang_phrase` VALUES ('2750', '1', '6', 'title', '191', 'CULTURE VINTAGE', 'CULTURE VINTAGE');
INSERT INTO `lang_phrase` VALUES ('2751', '2', '6', 'title', '191', 'CULTURE VINTAGE', 'CULTURE VINTAGE');
INSERT INTO `lang_phrase` VALUES ('2752', '3', '6', 'title', '191', 'CULTURE VINTAGE', 'CULTURE VINTAGE');
INSERT INTO `lang_phrase` VALUES ('2753', '1', '6', 'title', '192', 'CYBEX', 'CYBEX');
INSERT INTO `lang_phrase` VALUES ('2754', '2', '6', 'title', '192', 'CYBEX', 'CYBEX');
INSERT INTO `lang_phrase` VALUES ('2755', '3', '6', 'title', '192', 'CYBEX', 'CYBEX');
INSERT INTO `lang_phrase` VALUES ('2756', '1', '6', 'title', '193', 'CYRILLUS', 'CYRILLUS');
INSERT INTO `lang_phrase` VALUES ('2757', '2', '6', 'title', '193', 'CYRILLUS', 'CYRILLUS');
INSERT INTO `lang_phrase` VALUES ('2758', '3', '6', 'title', '193', 'CYRILLUS', 'CYRILLUS');
INSERT INTO `lang_phrase` VALUES ('2759', '1', '6', 'title', '194', 'DALLOYAU', 'DALLOYAU');
INSERT INTO `lang_phrase` VALUES ('2760', '2', '6', 'title', '194', 'DALLOYAU', 'DALLOYAU');
INSERT INTO `lang_phrase` VALUES ('2761', '3', '6', 'title', '194', 'DALLOYAU', 'DALLOYAU');
INSERT INTO `lang_phrase` VALUES ('2762', '1', '6', 'title', '195', 'DAUM', 'DAUM');
INSERT INTO `lang_phrase` VALUES ('2763', '2', '6', 'title', '195', 'DAUM', 'DAUM');
INSERT INTO `lang_phrase` VALUES ('2764', '3', '6', 'title', '195', 'DAUM', 'DAUM');
INSERT INTO `lang_phrase` VALUES ('2765', '1', '6', 'title', '196', 'DAVID YURMAN', 'DAVID YURMAN');
INSERT INTO `lang_phrase` VALUES ('2766', '2', '6', 'title', '196', 'DAVID YURMAN', 'DAVID YURMAN');
INSERT INTO `lang_phrase` VALUES ('2767', '3', '6', 'title', '196', 'DAVID YURMAN', 'DAVID YURMAN');
INSERT INTO `lang_phrase` VALUES ('2768', '1', '6', 'title', '197', 'DC SHOES', 'DC SHOES');
INSERT INTO `lang_phrase` VALUES ('2769', '2', '6', 'title', '197', 'DC SHOES', 'DC SHOES');
INSERT INTO `lang_phrase` VALUES ('2770', '3', '6', 'title', '197', 'DC SHOES', 'DC SHOES');
INSERT INTO `lang_phrase` VALUES ('2771', '1', '6', 'title', '198', 'DD (DORÉ DORÉ)', 'DD (DORÉ DORÉ)');
INSERT INTO `lang_phrase` VALUES ('2772', '2', '6', 'title', '198', 'DD (DORÉ DORÉ)', 'DD (DORÉ DORÉ)');
INSERT INTO `lang_phrase` VALUES ('2773', '3', '6', 'title', '198', 'DD (DORÉ DORÉ)', 'DD (DORÉ DORÉ)');
INSERT INTO `lang_phrase` VALUES ('2774', '1', '6', 'title', '199', 'DDP', 'DDP');
INSERT INTO `lang_phrase` VALUES ('2775', '2', '6', 'title', '199', 'DDP', 'DDP');
INSERT INTO `lang_phrase` VALUES ('2776', '3', '6', 'title', '199', 'DDP', 'DDP');
INSERT INTO `lang_phrase` VALUES ('2777', '1', '6', 'title', '200', 'DE BEERS', 'DE BEERS');
INSERT INTO `lang_phrase` VALUES ('2778', '2', '6', 'title', '200', 'DE BEERS', 'DE BEERS');
INSERT INTO `lang_phrase` VALUES ('2779', '3', '6', 'title', '200', 'DE BEERS', 'DE BEERS');
INSERT INTO `lang_phrase` VALUES ('2780', '1', '6', 'title', '201', 'DE FURSAC', 'DE FURSAC');
INSERT INTO `lang_phrase` VALUES ('2781', '2', '6', 'title', '201', 'DE FURSAC', 'DE FURSAC');
INSERT INTO `lang_phrase` VALUES ('2782', '3', '6', 'title', '201', 'DE FURSAC', 'DE FURSAC');
INSERT INTO `lang_phrase` VALUES ('2783', '1', '6', 'title', '202', 'DÉCORATIONS NOËL', 'DÉCORATIONS NOËL');
INSERT INTO `lang_phrase` VALUES ('2784', '2', '6', 'title', '202', 'DÉCORATIONS NOËL', 'DÉCORATIONS NOËL');
INSERT INTO `lang_phrase` VALUES ('2785', '3', '6', 'title', '202', 'DÉCORATIONS NOËL', 'DÉCORATIONS NOËL');
INSERT INTO `lang_phrase` VALUES ('2786', '1', '6', 'title', '203', 'DÉGUISEMENTS', 'DÉGUISEMENTS');
INSERT INTO `lang_phrase` VALUES ('2787', '2', '6', 'title', '203', 'DÉGUISEMENTS', 'DÉGUISEMENTS');
INSERT INTO `lang_phrase` VALUES ('2788', '3', '6', 'title', '203', 'DÉGUISEMENTS', 'DÉGUISEMENTS');
INSERT INTO `lang_phrase` VALUES ('2789', '1', '6', 'title', '204', 'DELSEY', 'DELSEY');
INSERT INTO `lang_phrase` VALUES ('2790', '2', '6', 'title', '204', 'DELSEY', 'DELSEY');
INSERT INTO `lang_phrase` VALUES ('2791', '3', '6', 'title', '204', 'DELSEY', 'DELSEY');
INSERT INTO `lang_phrase` VALUES ('2792', '1', '6', 'title', '205', 'DELVAUX', 'DELVAUX');
INSERT INTO `lang_phrase` VALUES ('2793', '2', '6', 'title', '205', 'DELVAUX', 'DELVAUX');
INSERT INTO `lang_phrase` VALUES ('2794', '3', '6', 'title', '205', 'DELVAUX', 'DELVAUX');
INSERT INTO `lang_phrase` VALUES ('2795', '1', '6', 'title', '206', 'DENIM & SUPPLY RALPH LAUREN', 'DENIM & SUPPLY RALPH LAUREN');
INSERT INTO `lang_phrase` VALUES ('2796', '2', '6', 'title', '206', 'DENIM & SUPPLY RALPH LAUREN', 'DENIM & SUPPLY RALPH LAUREN');
INSERT INTO `lang_phrase` VALUES ('2797', '3', '6', 'title', '206', 'DENIM & SUPPLY RALPH LAUREN', 'DENIM & SUPPLY RALPH LAUREN');
INSERT INTO `lang_phrase` VALUES ('2798', '1', '6', 'title', '207', 'DERHY', 'DERHY');
INSERT INTO `lang_phrase` VALUES ('2799', '2', '6', 'title', '207', 'DERHY', 'DERHY');
INSERT INTO `lang_phrase` VALUES ('2800', '3', '6', 'title', '207', 'DERHY', 'DERHY');
INSERT INTO `lang_phrase` VALUES ('2801', '1', '6', 'title', '208', 'DERHY KIDS', 'DERHY KIDS');
INSERT INTO `lang_phrase` VALUES ('2802', '2', '6', 'title', '208', 'DERHY KIDS', 'DERHY KIDS');
INSERT INTO `lang_phrase` VALUES ('2803', '3', '6', 'title', '208', 'DERHY KIDS', 'DERHY KIDS');
INSERT INTO `lang_phrase` VALUES ('2804', '1', '6', 'title', '209', 'DEROEUX DES PETITS HAUTS', 'DEROEUX DES PETITS HAUTS');
INSERT INTO `lang_phrase` VALUES ('2805', '2', '6', 'title', '209', 'DEROEUX DES PETITS HAUTS', 'DEROEUX DES PETITS HAUTS');
INSERT INTO `lang_phrase` VALUES ('2806', '3', '6', 'title', '209', 'DEROEUX DES PETITS HAUTS', 'DEROEUX DES PETITS HAUTS');
INSERT INTO `lang_phrase` VALUES ('2807', '1', '6', 'title', '210', 'DESCAMPS', 'DESCAMPS');
INSERT INTO `lang_phrase` VALUES ('2808', '2', '6', 'title', '210', 'DESCAMPS', 'DESCAMPS');
INSERT INTO `lang_phrase` VALUES ('2809', '3', '6', 'title', '210', 'DESCAMPS', 'DESCAMPS');
INSERT INTO `lang_phrase` VALUES ('2810', '1', '6', 'title', '211', 'DESHOULIERES', 'DESHOULIERES');
INSERT INTO `lang_phrase` VALUES ('2811', '2', '6', 'title', '211', 'DESHOULIERES', 'DESHOULIERES');
INSERT INTO `lang_phrase` VALUES ('2812', '3', '6', 'title', '211', 'DESHOULIERES', 'DESHOULIERES');
INSERT INTO `lang_phrase` VALUES ('2813', '1', '6', 'title', '212', 'DESIGUAL', 'DESIGUAL');
INSERT INTO `lang_phrase` VALUES ('2814', '2', '6', 'title', '212', 'DESIGUAL', 'DESIGUAL');
INSERT INTO `lang_phrase` VALUES ('2815', '3', '6', 'title', '212', 'DESIGUAL', 'DESIGUAL');
INSERT INTO `lang_phrase` VALUES ('2816', '1', '6', 'title', '213', 'DEVERNOIS', 'DEVERNOIS');
INSERT INTO `lang_phrase` VALUES ('2817', '2', '6', 'title', '213', 'DEVERNOIS', 'DEVERNOIS');
INSERT INTO `lang_phrase` VALUES ('2818', '3', '6', 'title', '213', 'DEVERNOIS', 'DEVERNOIS');
INSERT INTO `lang_phrase` VALUES ('2819', '1', '6', 'title', '214', 'DIANE VON FURSTENBERG', 'DIANE VON FURSTENBERG');
INSERT INTO `lang_phrase` VALUES ('2820', '2', '6', 'title', '214', 'DIANE VON FURSTENBERG', 'DIANE VON FURSTENBERG');
INSERT INTO `lang_phrase` VALUES ('2821', '3', '6', 'title', '214', 'DIANE VON FURSTENBERG', 'DIANE VON FURSTENBERG');
INSERT INTO `lang_phrase` VALUES ('2822', '1', '6', 'title', '215', 'DICE KAYEK', 'DICE KAYEK');
INSERT INTO `lang_phrase` VALUES ('2823', '2', '6', 'title', '215', 'DICE KAYEK', 'DICE KAYEK');
INSERT INTO `lang_phrase` VALUES ('2824', '3', '6', 'title', '215', 'DICE KAYEK', 'DICE KAYEK');
INSERT INTO `lang_phrase` VALUES ('2825', '1', '6', 'title', '216', 'DIDIER GUÉRIN', 'DIDIER GUÉRIN');
INSERT INTO `lang_phrase` VALUES ('2826', '2', '6', 'title', '216', 'DIDIER GUÉRIN', 'DIDIER GUÉRIN');
INSERT INTO `lang_phrase` VALUES ('2827', '3', '6', 'title', '216', 'DIDIER GUÉRIN', 'DIDIER GUÉRIN');
INSERT INTO `lang_phrase` VALUES ('2828', '1', '6', 'title', '217', 'DIDIER GUILLEMAIN', 'DIDIER GUILLEMAIN');
INSERT INTO `lang_phrase` VALUES ('2829', '2', '6', 'title', '217', 'DIDIER GUILLEMAIN', 'DIDIER GUILLEMAIN');
INSERT INTO `lang_phrase` VALUES ('2830', '3', '6', 'title', '217', 'DIDIER GUILLEMAIN', 'DIDIER GUILLEMAIN');
INSERT INTO `lang_phrase` VALUES ('2831', '1', '6', 'title', '218', 'DIESEL', 'DIESEL');
INSERT INTO `lang_phrase` VALUES ('2832', '2', '6', 'title', '218', 'DIESEL', 'DIESEL');
INSERT INTO `lang_phrase` VALUES ('2833', '3', '6', 'title', '218', 'DIESEL', 'DIESEL');
INSERT INTO `lang_phrase` VALUES ('2834', '1', '6', 'title', '219', 'DIM', 'DIM');
INSERT INTO `lang_phrase` VALUES ('2835', '2', '6', 'title', '219', 'DIM', 'DIM');
INSERT INTO `lang_phrase` VALUES ('2836', '3', '6', 'title', '219', 'DIM', 'DIM');
INSERT INTO `lang_phrase` VALUES ('2837', '1', '6', 'title', '220', 'DINH VAN', 'DINH VAN');
INSERT INTO `lang_phrase` VALUES ('2838', '2', '6', 'title', '220', 'DINH VAN', 'DINH VAN');
INSERT INTO `lang_phrase` VALUES ('2839', '3', '6', 'title', '220', 'DINH VAN', 'DINH VAN');
INSERT INTO `lang_phrase` VALUES ('2840', '1', '6', 'title', '221', 'DIOR', 'DIOR');
INSERT INTO `lang_phrase` VALUES ('2841', '2', '6', 'title', '221', 'DIOR', 'DIOR');
INSERT INTO `lang_phrase` VALUES ('2842', '3', '6', 'title', '221', 'DIOR', 'DIOR');
INSERT INTO `lang_phrase` VALUES ('2843', '1', '6', 'title', '222', 'DIPTYQUE', 'DIPTYQUE');
INSERT INTO `lang_phrase` VALUES ('2844', '2', '6', 'title', '222', 'DIPTYQUE', 'DIPTYQUE');
INSERT INTO `lang_phrase` VALUES ('2845', '3', '6', 'title', '222', 'DIPTYQUE', 'DIPTYQUE');
INSERT INTO `lang_phrase` VALUES ('2846', '1', '6', 'title', '223', 'DISNEY', 'DISNEY');
INSERT INTO `lang_phrase` VALUES ('2847', '2', '6', 'title', '223', 'DISNEY', 'DISNEY');
INSERT INTO `lang_phrase` VALUES ('2848', '3', '6', 'title', '223', 'DISNEY', 'DISNEY');
INSERT INTO `lang_phrase` VALUES ('2849', '1', '6', 'title', '224', 'DJECO', 'DJECO');
INSERT INTO `lang_phrase` VALUES ('2850', '2', '6', 'title', '224', 'DJECO', 'DJECO');
INSERT INTO `lang_phrase` VALUES ('2851', '3', '6', 'title', '224', 'DJECO', 'DJECO');
INSERT INTO `lang_phrase` VALUES ('2852', '1', '6', 'title', '225', 'DKNY', 'DKNY');
INSERT INTO `lang_phrase` VALUES ('2853', '2', '6', 'title', '225', 'DKNY', 'DKNY');
INSERT INTO `lang_phrase` VALUES ('2854', '3', '6', 'title', '225', 'DKNY', 'DKNY');
INSERT INTO `lang_phrase` VALUES ('2855', '1', '6', 'title', '226', 'DOCKERS', 'DOCKERS');
INSERT INTO `lang_phrase` VALUES ('2856', '2', '6', 'title', '226', 'DOCKERS', 'DOCKERS');
INSERT INTO `lang_phrase` VALUES ('2857', '3', '6', 'title', '226', 'DOCKERS', 'DOCKERS');
INSERT INTO `lang_phrase` VALUES ('2858', '1', '6', 'title', '227', 'DODO', 'DODO');
INSERT INTO `lang_phrase` VALUES ('2859', '2', '6', 'title', '227', 'DODO', 'DODO');
INSERT INTO `lang_phrase` VALUES ('2860', '3', '6', 'title', '227', 'DODO', 'DODO');
INSERT INTO `lang_phrase` VALUES ('2861', '1', '6', 'title', '228', 'DOLCE & GABBANA', 'DOLCE & GABBANA');
INSERT INTO `lang_phrase` VALUES ('2862', '2', '6', 'title', '228', 'DOLCE & GABBANA', 'DOLCE & GABBANA');
INSERT INTO `lang_phrase` VALUES ('2863', '3', '6', 'title', '228', 'DOLCE & GABBANA', 'DOLCE & GABBANA');
INSERT INTO `lang_phrase` VALUES ('2864', '1', '6', 'title', '229', 'DOT', 'DOT');
INSERT INTO `lang_phrase` VALUES ('2865', '2', '6', 'title', '229', 'DOT', 'DOT');
INSERT INTO `lang_phrase` VALUES ('2866', '3', '6', 'title', '229', 'DOT', 'DOT');
INSERT INTO `lang_phrase` VALUES ('2867', '1', '6', 'title', '230', 'DROPS', 'DROPS');
INSERT INTO `lang_phrase` VALUES ('2868', '2', '6', 'title', '230', 'DROPS', 'DROPS');
INSERT INTO `lang_phrase` VALUES ('2869', '3', '6', 'title', '230', 'DROPS', 'DROPS');
INSERT INTO `lang_phrase` VALUES ('2870', '1', '6', 'title', '231', 'DOUDOU & CIE', 'DOUDOU & CIE');
INSERT INTO `lang_phrase` VALUES ('2871', '2', '6', 'title', '231', 'DOUDOU & CIE', 'DOUDOU & CIE');
INSERT INTO `lang_phrase` VALUES ('2872', '3', '6', 'title', '231', 'DOUDOU & CIE', 'DOUDOU & CIE');
INSERT INTO `lang_phrase` VALUES ('2873', '1', '6', 'title', '232', 'DOUDOUNES', 'DOUDOUNES');
INSERT INTO `lang_phrase` VALUES ('2874', '2', '6', 'title', '232', 'DOUDOUNES', 'DOUDOUNES');
INSERT INTO `lang_phrase` VALUES ('2875', '3', '6', 'title', '232', 'DOUDOUNES', 'DOUDOUNES');
INSERT INTO `lang_phrase` VALUES ('2876', '1', '6', 'title', '233', 'DROUAULT', 'DROUAULT');
INSERT INTO `lang_phrase` VALUES ('2877', '2', '6', 'title', '233', 'DROUAULT', 'DROUAULT');
INSERT INTO `lang_phrase` VALUES ('2878', '3', '6', 'title', '233', 'DROUAULT', 'DROUAULT');
INSERT INTO `lang_phrase` VALUES ('2879', '1', '6', 'title', '234', 'DSQUARED', 'DSQUARED');
INSERT INTO `lang_phrase` VALUES ('2880', '2', '6', 'title', '234', 'DSQUARED', 'DSQUARED');
INSERT INTO `lang_phrase` VALUES ('2881', '3', '6', 'title', '234', 'DSQUARED', 'DSQUARED');
INSERT INTO `lang_phrase` VALUES ('2882', '1', '6', 'title', '235', 'DUNE', 'DUNE');
INSERT INTO `lang_phrase` VALUES ('2883', '2', '6', 'title', '235', 'DUNE', 'DUNE');
INSERT INTO `lang_phrase` VALUES ('2884', '3', '6', 'title', '235', 'DUNE', 'DUNE');
INSERT INTO `lang_phrase` VALUES ('2885', '1', '6', 'title', '236', 'DUNHILL', 'DUNHILL');
INSERT INTO `lang_phrase` VALUES ('2886', '2', '6', 'title', '236', 'DUNHILL', 'DUNHILL');
INSERT INTO `lang_phrase` VALUES ('2887', '3', '6', 'title', '236', 'DUNHILL', 'DUNHILL');
INSERT INTO `lang_phrase` VALUES ('2888', '1', '6', 'title', '237', 'DUNLOPILLO', 'DUNLOPILLO');
INSERT INTO `lang_phrase` VALUES ('2889', '2', '6', 'title', '237', 'DUNLOPILLO', 'DUNLOPILLO');
INSERT INTO `lang_phrase` VALUES ('2890', '3', '6', 'title', '237', 'DUNLOPILLO', 'DUNLOPILLO');
INSERT INTO `lang_phrase` VALUES ('2891', '1', '6', 'title', '238', 'DUPONT (ST)', 'DUPONT (ST)');
INSERT INTO `lang_phrase` VALUES ('2892', '2', '6', 'title', '238', 'DUPONT (ST)', 'DUPONT (ST)');
INSERT INTO `lang_phrase` VALUES ('2893', '3', '6', 'title', '238', 'DUPONT (ST)', 'DUPONT (ST)');
INSERT INTO `lang_phrase` VALUES ('2894', '1', '6', 'title', '239', 'DYSON', 'DYSON');
INSERT INTO `lang_phrase` VALUES ('2895', '2', '6', 'title', '239', 'DYSON', 'DYSON');
INSERT INTO `lang_phrase` VALUES ('2896', '3', '6', 'title', '239', 'DYSON', 'DYSON');
INSERT INTO `lang_phrase` VALUES ('2897', '1', '6', 'title', '240', 'EASTPAK', 'EASTPAK');
INSERT INTO `lang_phrase` VALUES ('2898', '2', '6', 'title', '240', 'EASTPAK', 'EASTPAK');
INSERT INTO `lang_phrase` VALUES ('2899', '3', '6', 'title', '240', 'EASTPAK', 'EASTPAK');
INSERT INTO `lang_phrase` VALUES ('2900', '1', '6', 'title', '241', 'EDEN PARK', 'EDEN PARK');
INSERT INTO `lang_phrase` VALUES ('2901', '2', '6', 'title', '241', 'EDEN PARK', 'EDEN PARK');
INSERT INTO `lang_phrase` VALUES ('2902', '3', '6', 'title', '241', 'EDEN PARK', 'EDEN PARK');
INSERT INTO `lang_phrase` VALUES ('2903', '1', '6', 'title', '242', 'EDEN SHOES', 'EDEN SHOES');
INSERT INTO `lang_phrase` VALUES ('2904', '2', '6', 'title', '242', 'EDEN SHOES', 'EDEN SHOES');
INSERT INTO `lang_phrase` VALUES ('2905', '3', '6', 'title', '242', 'EDEN SHOES', 'EDEN SHOES');
INSERT INTO `lang_phrase` VALUES ('2906', '1', '6', 'title', '243', 'EDWIN', 'EDWIN');
INSERT INTO `lang_phrase` VALUES ('2907', '2', '6', 'title', '243', 'EDWIN', 'EDWIN');
INSERT INTO `lang_phrase` VALUES ('2908', '3', '6', 'title', '243', 'EDWIN', 'EDWIN');
INSERT INTO `lang_phrase` VALUES ('2909', '1', '6', 'title', '244', 'ELEMENT', 'ELEMENT');
INSERT INTO `lang_phrase` VALUES ('2910', '2', '6', 'title', '244', 'ELEMENT', 'ELEMENT');
INSERT INTO `lang_phrase` VALUES ('2911', '3', '6', 'title', '244', 'ELEMENT', 'ELEMENT');
INSERT INTO `lang_phrase` VALUES ('2912', '1', '6', 'title', '245', 'ELEVEN PARIS', 'ELEVEN PARIS');
INSERT INTO `lang_phrase` VALUES ('2913', '2', '6', 'title', '245', 'ELEVEN PARIS', 'ELEVEN PARIS');
INSERT INTO `lang_phrase` VALUES ('2914', '3', '6', 'title', '245', 'ELEVEN PARIS', 'ELEVEN PARIS');
INSERT INTO `lang_phrase` VALUES ('2915', '1', '6', 'title', '246', 'ELIZABETH STUART', 'ELIZABETH STUART');
INSERT INTO `lang_phrase` VALUES ('2916', '2', '6', 'title', '246', 'ELIZABETH STUART', 'ELIZABETH STUART');
INSERT INTO `lang_phrase` VALUES ('2917', '3', '6', 'title', '246', 'ELIZABETH STUART', 'ELIZABETH STUART');
INSERT INTO `lang_phrase` VALUES ('2918', '1', '6', 'title', '247', 'EMINENCE', 'EMINENCE');
INSERT INTO `lang_phrase` VALUES ('2919', '2', '6', 'title', '247', 'EMINENCE', 'EMINENCE');
INSERT INTO `lang_phrase` VALUES ('2920', '3', '6', 'title', '247', 'EMINENCE', 'EMINENCE');
INSERT INTO `lang_phrase` VALUES ('2921', '1', '6', 'title', '248', 'EMPREINTE', 'EMPREINTE');
INSERT INTO `lang_phrase` VALUES ('2922', '2', '6', 'title', '248', 'EMPREINTE', 'EMPREINTE');
INSERT INTO `lang_phrase` VALUES ('2923', '3', '6', 'title', '248', 'EMPREINTE', 'EMPREINTE');
INSERT INTO `lang_phrase` VALUES ('2924', '1', '6', 'title', '249', 'ERES', 'ERES');
INSERT INTO `lang_phrase` VALUES ('2925', '2', '6', 'title', '249', 'ERES', 'ERES');
INSERT INTO `lang_phrase` VALUES ('2926', '3', '6', 'title', '249', 'ERES', 'ERES');
INSERT INTO `lang_phrase` VALUES ('2927', '1', '6', 'title', '250', 'ERIC BOMPARD', 'ERIC BOMPARD');
INSERT INTO `lang_phrase` VALUES ('2928', '2', '6', 'title', '250', 'ERIC BOMPARD', 'ERIC BOMPARD');
INSERT INTO `lang_phrase` VALUES ('2929', '3', '6', 'title', '250', 'ERIC BOMPARD', 'ERIC BOMPARD');
INSERT INTO `lang_phrase` VALUES ('2930', '1', '6', 'title', '251', 'ESPRIT', 'ESPRIT');
INSERT INTO `lang_phrase` VALUES ('2931', '2', '6', 'title', '251', 'ESPRIT', 'ESPRIT');
INSERT INTO `lang_phrase` VALUES ('2932', '3', '6', 'title', '251', 'ESPRIT', 'ESPRIT');
INSERT INTO `lang_phrase` VALUES ('2933', '1', '6', 'title', '252', 'ESSENTIEL', 'ESSENTIEL');
INSERT INTO `lang_phrase` VALUES ('2934', '2', '6', 'title', '252', 'ESSENTIEL', 'ESSENTIEL');
INSERT INTO `lang_phrase` VALUES ('2935', '3', '6', 'title', '252', 'ESSENTIEL', 'ESSENTIEL');
INSERT INTO `lang_phrase` VALUES ('2936', '1', '6', 'title', '253', 'ESSIE', 'ESSIE');
INSERT INTO `lang_phrase` VALUES ('2937', '2', '6', 'title', '253', 'ESSIE', 'ESSIE');
INSERT INTO `lang_phrase` VALUES ('2938', '3', '6', 'title', '253', 'ESSIE', 'ESSIE');
INSERT INTO `lang_phrase` VALUES ('2939', '1', '6', 'title', '254', 'ESTÉE LAUDER', 'ESTÉE LAUDER');
INSERT INTO `lang_phrase` VALUES ('2940', '2', '6', 'title', '254', 'ESTÉE LAUDER', 'ESTÉE LAUDER');
INSERT INTO `lang_phrase` VALUES ('2941', '3', '6', 'title', '254', 'ESTÉE LAUDER', 'ESTÉE LAUDER');
INSERT INTO `lang_phrase` VALUES ('2942', '1', '6', 'title', '255', 'ETAM ETOILE', 'ETAM ETOILE');
INSERT INTO `lang_phrase` VALUES ('2943', '2', '6', 'title', '255', 'ETAM ETOILE', 'ETAM ETOILE');
INSERT INTO `lang_phrase` VALUES ('2944', '3', '6', 'title', '255', 'ETAM ETOILE', 'ETAM ETOILE');
INSERT INTO `lang_phrase` VALUES ('2945', '1', '6', 'title', '256', 'EX NIHILO', 'EX NIHILO');
INSERT INTO `lang_phrase` VALUES ('2946', '2', '6', 'title', '256', 'EX NIHILO', 'EX NIHILO');
INSERT INTO `lang_phrase` VALUES ('2947', '3', '6', 'title', '256', 'EX NIHILO', 'EX NIHILO');
INSERT INTO `lang_phrase` VALUES ('2948', '1', '6', 'title', '257', 'EXACOMPTA', 'EXACOMPTA');
INSERT INTO `lang_phrase` VALUES ('2949', '2', '6', 'title', '257', 'EXACOMPTA', 'EXACOMPTA');
INSERT INTO `lang_phrase` VALUES ('2950', '3', '6', 'title', '257', 'EXACOMPTA', 'EXACOMPTA');
INSERT INTO `lang_phrase` VALUES ('2951', '1', '6', 'title', '258', 'FABER-CASTELL', 'FABER-CASTELL');
INSERT INTO `lang_phrase` VALUES ('2952', '2', '6', 'title', '258', 'FABER-CASTELL', 'FABER-CASTELL');
INSERT INTO `lang_phrase` VALUES ('2953', '3', '6', 'title', '258', 'FABER-CASTELL', 'FABER-CASTELL');
INSERT INTO `lang_phrase` VALUES ('2954', '1', '6', 'title', '259', 'FAÇONNABLE', 'FAÇONNABLE');
INSERT INTO `lang_phrase` VALUES ('2955', '2', '6', 'title', '259', 'FAÇONNABLE', 'FAÇONNABLE');
INSERT INTO `lang_phrase` VALUES ('2956', '3', '6', 'title', '259', 'FAÇONNABLE', 'FAÇONNABLE');
INSERT INTO `lang_phrase` VALUES ('2957', '1', '6', 'title', '260', 'FAGUO', 'FAGUO');
INSERT INTO `lang_phrase` VALUES ('2958', '2', '6', 'title', '260', 'FAGUO', 'FAGUO');
INSERT INTO `lang_phrase` VALUES ('2959', '3', '6', 'title', '260', 'FAGUO', 'FAGUO');
INSERT INTO `lang_phrase` VALUES ('2960', '1', '6', 'title', '261', 'FALKE', 'FALKE');
INSERT INTO `lang_phrase` VALUES ('2961', '2', '6', 'title', '261', 'FALKE', 'FALKE');
INSERT INTO `lang_phrase` VALUES ('2962', '3', '6', 'title', '261', 'FALKE', 'FALKE');
INSERT INTO `lang_phrase` VALUES ('2963', '1', '6', 'title', '262', 'FALKE ESS', 'FALKE ESS');
INSERT INTO `lang_phrase` VALUES ('2964', '2', '6', 'title', '262', 'FALKE ESS', 'FALKE ESS');
INSERT INTO `lang_phrase` VALUES ('2965', '3', '6', 'title', '262', 'FALKE ESS', 'FALKE ESS');
INSERT INTO `lang_phrase` VALUES ('2966', '1', '6', 'title', '263', 'FAURE LE PAGE', 'FAURE LE PAGE');
INSERT INTO `lang_phrase` VALUES ('2967', '2', '6', 'title', '263', 'FAURE LE PAGE', 'FAURE LE PAGE');
INSERT INTO `lang_phrase` VALUES ('2968', '3', '6', 'title', '263', 'FAURE LE PAGE', 'FAURE LE PAGE');
INSERT INTO `lang_phrase` VALUES ('2969', '1', '6', 'title', '264', 'FENDI', 'FENDI');
INSERT INTO `lang_phrase` VALUES ('2970', '2', '6', 'title', '264', 'FENDI', 'FENDI');
INSERT INTO `lang_phrase` VALUES ('2971', '3', '6', 'title', '264', 'FENDI', 'FENDI');
INSERT INTO `lang_phrase` VALUES ('2972', '1', '6', 'title', '265', 'FÉRAUD', 'FÉRAUD');
INSERT INTO `lang_phrase` VALUES ('2973', '2', '6', 'title', '265', 'FÉRAUD', 'FÉRAUD');
INSERT INTO `lang_phrase` VALUES ('2974', '3', '6', 'title', '265', 'FÉRAUD', 'FÉRAUD');
INSERT INTO `lang_phrase` VALUES ('2975', '1', '6', 'title', '266', 'FESTINA', 'FESTINA');
INSERT INTO `lang_phrase` VALUES ('2976', '2', '6', 'title', '266', 'FESTINA', 'FESTINA');
INSERT INTO `lang_phrase` VALUES ('2977', '3', '6', 'title', '266', 'FESTINA', 'FESTINA');
INSERT INTO `lang_phrase` VALUES ('2978', '1', '6', 'title', '267', 'FILOFAX', 'FILOFAX');
INSERT INTO `lang_phrase` VALUES ('2979', '2', '6', 'title', '267', 'FILOFAX', 'FILOFAX');
INSERT INTO `lang_phrase` VALUES ('2980', '3', '6', 'title', '267', 'FILOFAX', 'FILOFAX');
INSERT INTO `lang_phrase` VALUES ('2981', '1', '6', 'title', '268', 'FISHER-PRICE', 'FISHER-PRICE');
INSERT INTO `lang_phrase` VALUES ('2982', '2', '6', 'title', '268', 'FISHER-PRICE', 'FISHER-PRICE');
INSERT INTO `lang_phrase` VALUES ('2983', '3', '6', 'title', '268', 'FISHER-PRICE', 'FISHER-PRICE');
INSERT INTO `lang_phrase` VALUES ('2984', '1', '6', 'title', '269', 'FISSLER', 'FISSLER');
INSERT INTO `lang_phrase` VALUES ('2985', '2', '6', 'title', '269', 'FISSLER', 'FISSLER');
INSERT INTO `lang_phrase` VALUES ('2986', '3', '6', 'title', '269', 'FISSLER', 'FISSLER');
INSERT INTO `lang_phrase` VALUES ('2987', '1', '6', 'title', '270', 'FLÉCHET', 'FLÉCHET');
INSERT INTO `lang_phrase` VALUES ('2988', '2', '6', 'title', '270', 'FLÉCHET', 'FLÉCHET');
INSERT INTO `lang_phrase` VALUES ('2989', '3', '6', 'title', '270', 'FLÉCHET', 'FLÉCHET');
INSERT INTO `lang_phrase` VALUES ('2990', '1', '6', 'title', '271', 'FLIK FLAK', 'FLIK FLAK');
INSERT INTO `lang_phrase` VALUES ('2991', '2', '6', 'title', '271', 'FLIK FLAK', 'FLIK FLAK');
INSERT INTO `lang_phrase` VALUES ('2992', '3', '6', 'title', '271', 'FLIK FLAK', 'FLIK FLAK');
INSERT INTO `lang_phrase` VALUES ('2993', '1', '6', 'title', '272', 'FOSSIL', 'FOSSIL');
INSERT INTO `lang_phrase` VALUES ('2994', '2', '6', 'title', '272', 'FOSSIL', 'FOSSIL');
INSERT INTO `lang_phrase` VALUES ('2995', '3', '6', 'title', '272', 'FOSSIL', 'FOSSIL');
INSERT INTO `lang_phrase` VALUES ('2996', '1', '6', 'title', '273', 'FPM', 'FPM');
INSERT INTO `lang_phrase` VALUES ('2997', '2', '6', 'title', '273', 'FPM', 'FPM');
INSERT INTO `lang_phrase` VALUES ('2998', '3', '6', 'title', '273', 'FPM', 'FPM');
INSERT INTO `lang_phrase` VALUES ('2999', '1', '6', 'title', '274', 'FRANCE CARTES / SMIR', 'FRANCE CARTES / SMIR');
INSERT INTO `lang_phrase` VALUES ('3000', '2', '6', 'title', '274', 'FRANCE CARTES / SMIR', 'FRANCE CARTES / SMIR');
INSERT INTO `lang_phrase` VALUES ('3001', '3', '6', 'title', '274', 'FRANCE CARTES / SMIR', 'FRANCE CARTES / SMIR');
INSERT INTO `lang_phrase` VALUES ('3002', '1', '6', 'title', '275', 'FRATELLI ROSSETTI', 'FRATELLI ROSSETTI');
INSERT INTO `lang_phrase` VALUES ('3003', '2', '6', 'title', '275', 'FRATELLI ROSSETTI', 'FRATELLI ROSSETTI');
INSERT INTO `lang_phrase` VALUES ('3004', '3', '6', 'title', '275', 'FRATELLI ROSSETTI', 'FRATELLI ROSSETTI');
INSERT INTO `lang_phrase` VALUES ('3005', '1', '6', 'title', '276', 'FRED', 'FRED');
INSERT INTO `lang_phrase` VALUES ('3006', '2', '6', 'title', '276', 'FRED', 'FRED');
INSERT INTO `lang_phrase` VALUES ('3007', '3', '6', 'title', '276', 'FRED', 'FRED');
INSERT INTO `lang_phrase` VALUES ('3008', '1', '6', 'title', '277', 'FRED PERRY', 'FRED PERRY');
INSERT INTO `lang_phrase` VALUES ('3009', '2', '6', 'title', '277', 'FRED PERRY', 'FRED PERRY');
INSERT INTO `lang_phrase` VALUES ('3010', '3', '6', 'title', '277', 'FRED PERRY', 'FRED PERRY');
INSERT INTO `lang_phrase` VALUES ('3011', '1', '6', 'title', '278', 'FREDERIQUE CONSTANT', 'FREDERIQUE CONSTANT');
INSERT INTO `lang_phrase` VALUES ('3012', '2', '6', 'title', '278', 'FREDERIQUE CONSTANT', 'FREDERIQUE CONSTANT');
INSERT INTO `lang_phrase` VALUES ('3013', '3', '6', 'title', '278', 'FREDERIQUE CONSTANT', 'FREDERIQUE CONSTANT');
INSERT INTO `lang_phrase` VALUES ('3014', '1', '6', 'title', '279', 'FREE LANCE', 'FREE LANCE');
INSERT INTO `lang_phrase` VALUES ('3015', '2', '6', 'title', '279', 'FREE LANCE', 'FREE LANCE');
INSERT INTO `lang_phrase` VALUES ('3016', '3', '6', 'title', '279', 'FREE LANCE', 'FREE LANCE');
INSERT INTO `lang_phrase` VALUES ('3017', '1', '6', 'title', '280', 'FRESCOBOL CARIOCA', 'FRESCOBOL CARIOCA');
INSERT INTO `lang_phrase` VALUES ('3018', '2', '6', 'title', '280', 'FRESCOBOL CARIOCA', 'FRESCOBOL CARIOCA');
INSERT INTO `lang_phrase` VALUES ('3019', '3', '6', 'title', '280', 'FRESCOBOL CARIOCA', 'FRESCOBOL CARIOCA');
INSERT INTO `lang_phrase` VALUES ('3020', '1', '6', 'title', '281', 'FREYA', 'FREYA');
INSERT INTO `lang_phrase` VALUES ('3021', '2', '6', 'title', '281', 'FREYA', 'FREYA');
INSERT INTO `lang_phrase` VALUES ('3022', '3', '6', 'title', '281', 'FREYA', 'FREYA');
INSERT INTO `lang_phrase` VALUES ('3023', '1', '6', 'title', '282', 'FROU-FROU', 'FROU-FROU');
INSERT INTO `lang_phrase` VALUES ('3024', '2', '6', 'title', '282', 'FROU-FROU', 'FROU-FROU');
INSERT INTO `lang_phrase` VALUES ('3025', '3', '6', 'title', '282', 'FROU-FROU', 'FROU-FROU');
INSERT INTO `lang_phrase` VALUES ('3026', '1', '6', 'title', '283', 'FURLA', 'FURLA');
INSERT INTO `lang_phrase` VALUES ('3027', '2', '6', 'title', '283', 'FURLA', 'FURLA');
INSERT INTO `lang_phrase` VALUES ('3028', '3', '6', 'title', '283', 'FURLA', 'FURLA');
INSERT INTO `lang_phrase` VALUES ('3029', '1', '6', 'title', '284', 'G STAR', 'G STAR');
INSERT INTO `lang_phrase` VALUES ('3030', '2', '6', 'title', '284', 'G STAR', 'G STAR');
INSERT INTO `lang_phrase` VALUES ('3031', '3', '6', 'title', '284', 'G STAR', 'G STAR');
INSERT INTO `lang_phrase` VALUES ('3032', '1', '6', 'title', '285', 'GAASTRA', 'GAASTRA');
INSERT INTO `lang_phrase` VALUES ('3033', '2', '6', 'title', '285', 'GAASTRA', 'GAASTRA');
INSERT INTO `lang_phrase` VALUES ('3034', '3', '6', 'title', '285', 'GAASTRA', 'GAASTRA');
INSERT INTO `lang_phrase` VALUES ('3035', '1', '6', 'title', '286', 'GALERIES LAFAYETTE CACHEMIRE', 'GALERIES LAFAYETTE CACHEMIRE');
INSERT INTO `lang_phrase` VALUES ('3036', '2', '6', 'title', '286', 'GALERIES LAFAYETTE CACHEMIRE', 'GALERIES LAFAYETTE CACHEMIRE');
INSERT INTO `lang_phrase` VALUES ('3037', '3', '6', 'title', '286', 'GALERIES LAFAYETTE CACHEMIRE', 'GALERIES LAFAYETTE CACHEMIRE');
INSERT INTO `lang_phrase` VALUES ('3038', '1', '6', 'title', '287', 'GALERIES LAFAYETTE PARIS', 'GALERIES LAFAYETTE PARIS');
INSERT INTO `lang_phrase` VALUES ('3039', '2', '6', 'title', '287', 'GALERIES LAFAYETTE PARIS', 'GALERIES LAFAYETTE PARIS');
INSERT INTO `lang_phrase` VALUES ('3040', '3', '6', 'title', '287', 'GALERIES LAFAYETTE PARIS', 'GALERIES LAFAYETTE PARIS');
INSERT INTO `lang_phrase` VALUES ('3041', '1', '6', 'title', '288', 'GANT', 'GANT');
INSERT INTO `lang_phrase` VALUES ('3042', '2', '6', 'title', '288', 'GANT', 'GANT');
INSERT INTO `lang_phrase` VALUES ('3043', '3', '6', 'title', '288', 'GANT', 'GANT');
INSERT INTO `lang_phrase` VALUES ('3044', '1', '6', 'title', '289', 'GAP KIDS', 'GAP KIDS');
INSERT INTO `lang_phrase` VALUES ('3045', '2', '6', 'title', '289', 'GAP KIDS', 'GAP KIDS');
INSERT INTO `lang_phrase` VALUES ('3046', '3', '6', 'title', '289', 'GAP KIDS', 'GAP KIDS');
INSERT INTO `lang_phrase` VALUES ('3047', '1', '6', 'title', '290', 'GARANCE', 'GARANCE');
INSERT INTO `lang_phrase` VALUES ('3048', '2', '6', 'title', '290', 'GARANCE', 'GARANCE');
INSERT INTO `lang_phrase` VALUES ('3049', '3', '6', 'title', '290', 'GARANCE', 'GARANCE');
INSERT INTO `lang_phrase` VALUES ('3050', '1', '6', 'title', '291', 'GAS', 'GAS');
INSERT INTO `lang_phrase` VALUES ('3051', '2', '6', 'title', '291', 'GAS', 'GAS');
INSERT INTO `lang_phrase` VALUES ('3052', '3', '6', 'title', '291', 'GAS', 'GAS');
INSERT INTO `lang_phrase` VALUES ('3053', '1', '6', 'title', '292', 'GEMEY MAYBELINE', 'GEMEY MAYBELINE');
INSERT INTO `lang_phrase` VALUES ('3054', '2', '6', 'title', '292', 'GEMEY MAYBELINE', 'GEMEY MAYBELINE');
INSERT INTO `lang_phrase` VALUES ('3055', '3', '6', 'title', '292', 'GEMEY MAYBELINE', 'GEMEY MAYBELINE');
INSERT INTO `lang_phrase` VALUES ('3056', '1', '6', 'title', '293', 'GEOX', 'GEOX');
INSERT INTO `lang_phrase` VALUES ('3057', '2', '6', 'title', '293', 'GEOX', 'GEOX');
INSERT INTO `lang_phrase` VALUES ('3058', '3', '6', 'title', '293', 'GEOX', 'GEOX');
INSERT INTO `lang_phrase` VALUES ('3059', '1', '6', 'title', '294', 'GÉRARD DAREL', 'GÉRARD DAREL');
INSERT INTO `lang_phrase` VALUES ('3060', '2', '6', 'title', '294', 'GÉRARD DAREL', 'GÉRARD DAREL');
INSERT INTO `lang_phrase` VALUES ('3061', '3', '6', 'title', '294', 'GÉRARD DAREL', 'GÉRARD DAREL');
INSERT INTO `lang_phrase` VALUES ('3062', '1', '6', 'title', '295', 'GERTRUDE', 'GERTRUDE');
INSERT INTO `lang_phrase` VALUES ('3063', '2', '6', 'title', '295', 'GERTRUDE', 'GERTRUDE');
INSERT INTO `lang_phrase` VALUES ('3064', '3', '6', 'title', '295', 'GERTRUDE', 'GERTRUDE');
INSERT INTO `lang_phrase` VALUES ('3065', '1', '6', 'title', '296', 'GHD', 'GHD');
INSERT INTO `lang_phrase` VALUES ('3066', '2', '6', 'title', '296', 'GHD', 'GHD');
INSERT INTO `lang_phrase` VALUES ('3067', '3', '6', 'title', '296', 'GHD', 'GHD');
INSERT INTO `lang_phrase` VALUES ('3068', '1', '6', 'title', '297', 'GIANVITO ROSSI', 'GIANVITO ROSSI');
INSERT INTO `lang_phrase` VALUES ('3069', '2', '6', 'title', '297', 'GIANVITO ROSSI', 'GIANVITO ROSSI');
INSERT INTO `lang_phrase` VALUES ('3070', '3', '6', 'title', '297', 'GIANVITO ROSSI', 'GIANVITO ROSSI');
INSERT INTO `lang_phrase` VALUES ('3071', '1', '6', 'title', '298', 'GIEN', 'GIEN');
INSERT INTO `lang_phrase` VALUES ('3072', '2', '6', 'title', '298', 'GIEN', 'GIEN');
INSERT INTO `lang_phrase` VALUES ('3073', '3', '6', 'title', '298', 'GIEN', 'GIEN');
INSERT INTO `lang_phrase` VALUES ('3074', '1', '6', 'title', '299', 'GIENCHI', 'GIENCHI');
INSERT INTO `lang_phrase` VALUES ('3075', '2', '6', 'title', '299', 'GIENCHI', 'GIENCHI');
INSERT INTO `lang_phrase` VALUES ('3076', '3', '6', 'title', '299', 'GIENCHI', 'GIENCHI');
INSERT INTO `lang_phrase` VALUES ('3077', '1', '6', 'title', '300', 'GIUSEPPE ZANOTTI', 'GIUSEPPE ZANOTTI');
INSERT INTO `lang_phrase` VALUES ('3078', '2', '6', 'title', '300', 'GIUSEPPE ZANOTTI', 'GIUSEPPE ZANOTTI');
INSERT INTO `lang_phrase` VALUES ('3079', '3', '6', 'title', '300', 'GIUSEPPE ZANOTTI', 'GIUSEPPE ZANOTTI');
INSERT INTO `lang_phrase` VALUES ('3080', '1', '6', 'title', '301', 'GIVENCHY', 'GIVENCHY');
INSERT INTO `lang_phrase` VALUES ('3081', '2', '6', 'title', '301', 'GIVENCHY', 'GIVENCHY');
INSERT INTO `lang_phrase` VALUES ('3082', '3', '6', 'title', '301', 'GIVENCHY', 'GIVENCHY');
INSERT INTO `lang_phrase` VALUES ('3083', '1', '6', 'title', '302', 'GO TRAVEL', 'GO TRAVEL');
INSERT INTO `lang_phrase` VALUES ('3084', '2', '6', 'title', '302', 'GO TRAVEL', 'GO TRAVEL');
INSERT INTO `lang_phrase` VALUES ('3085', '3', '6', 'title', '302', 'GO TRAVEL', 'GO TRAVEL');
INSERT INTO `lang_phrase` VALUES ('3086', '1', '6', 'title', '303', 'GOSHA RUBCHINSKIY', 'GOSHA RUBCHINSKIY');
INSERT INTO `lang_phrase` VALUES ('3087', '2', '6', 'title', '303', 'GOSHA RUBCHINSKIY', 'GOSHA RUBCHINSKIY');
INSERT INTO `lang_phrase` VALUES ('3088', '3', '6', 'title', '303', 'GOSHA RUBCHINSKIY', 'GOSHA RUBCHINSKIY');
INSERT INTO `lang_phrase` VALUES ('3089', '1', '6', 'title', '304', 'GOURMET', 'GOURMET');
INSERT INTO `lang_phrase` VALUES ('3090', '2', '6', 'title', '304', 'GOURMET', 'GOURMET');
INSERT INTO `lang_phrase` VALUES ('3091', '3', '6', 'title', '304', 'GOURMET', 'GOURMET');
INSERT INTO `lang_phrase` VALUES ('3092', '1', '6', 'title', '305', 'GUCCI', 'GUCCI');
INSERT INTO `lang_phrase` VALUES ('3093', '2', '6', 'title', '305', 'GUCCI', 'GUCCI');
INSERT INTO `lang_phrase` VALUES ('3094', '3', '6', 'title', '305', 'GUCCI', 'GUCCI');
INSERT INTO `lang_phrase` VALUES ('3095', '1', '6', 'title', '306', 'GUERLAIN', 'GUERLAIN');
INSERT INTO `lang_phrase` VALUES ('3096', '2', '6', 'title', '306', 'GUERLAIN', 'GUERLAIN');
INSERT INTO `lang_phrase` VALUES ('3097', '3', '6', 'title', '306', 'GUERLAIN', 'GUERLAIN');
INSERT INTO `lang_phrase` VALUES ('3098', '1', '6', 'title', '307', 'GUESS', 'GUESS');
INSERT INTO `lang_phrase` VALUES ('3099', '2', '6', 'title', '307', 'GUESS', 'GUESS');
INSERT INTO `lang_phrase` VALUES ('3100', '3', '6', 'title', '307', 'GUESS', 'GUESS');
INSERT INTO `lang_phrase` VALUES ('3101', '1', '6', 'title', '308', 'GUY DEGRENNE', 'GUY DEGRENNE');
INSERT INTO `lang_phrase` VALUES ('3102', '2', '6', 'title', '308', 'GUY DEGRENNE', 'GUY DEGRENNE');
INSERT INTO `lang_phrase` VALUES ('3103', '3', '6', 'title', '308', 'GUY DEGRENNE', 'GUY DEGRENNE');
INSERT INTO `lang_phrase` VALUES ('3104', '1', '6', 'title', '309', 'HACKETT', 'HACKETT');
INSERT INTO `lang_phrase` VALUES ('3105', '2', '6', 'title', '309', 'HACKETT', 'HACKETT');
INSERT INTO `lang_phrase` VALUES ('3106', '3', '6', 'title', '309', 'HACKETT', 'HACKETT');
INSERT INTO `lang_phrase` VALUES ('3107', '1', '6', 'title', '310', 'HALLMARK / LA CARTERIE', 'HALLMARK / LA CARTERIE');
INSERT INTO `lang_phrase` VALUES ('3108', '2', '6', 'title', '310', 'HALLMARK / LA CARTERIE', 'HALLMARK / LA CARTERIE');
INSERT INTO `lang_phrase` VALUES ('3109', '3', '6', 'title', '310', 'HALLMARK / LA CARTERIE', 'HALLMARK / LA CARTERIE');
INSERT INTO `lang_phrase` VALUES ('3110', '1', '6', 'title', '311', 'HAMILTON', 'HAMILTON');
INSERT INTO `lang_phrase` VALUES ('3111', '2', '6', 'title', '311', 'HAMILTON', 'HAMILTON');
INSERT INTO `lang_phrase` VALUES ('3112', '3', '6', 'title', '311', 'HAMILTON', 'HAMILTON');
INSERT INTO `lang_phrase` VALUES ('3113', '1', '6', 'title', '312', 'HANRO', 'HANRO');
INSERT INTO `lang_phrase` VALUES ('3114', '2', '6', 'title', '312', 'HANRO', 'HANRO');
INSERT INTO `lang_phrase` VALUES ('3115', '3', '6', 'title', '312', 'HANRO', 'HANRO');
INSERT INTO `lang_phrase` VALUES ('3116', '1', '6', 'title', '313', 'HARRIS WILSON', 'HARRIS WILSON');
INSERT INTO `lang_phrase` VALUES ('3117', '2', '6', 'title', '313', 'HARRIS WILSON', 'HARRIS WILSON');
INSERT INTO `lang_phrase` VALUES ('3118', '3', '6', 'title', '313', 'HARRIS WILSON', 'HARRIS WILSON');
INSERT INTO `lang_phrase` VALUES ('3119', '1', '6', 'title', '314', 'HARTMANN', 'HARTMANN');
INSERT INTO `lang_phrase` VALUES ('3120', '2', '6', 'title', '314', 'HARTMANN', 'HARTMANN');
INSERT INTO `lang_phrase` VALUES ('3121', '3', '6', 'title', '314', 'HARTMANN', 'HARTMANN');
INSERT INTO `lang_phrase` VALUES ('3122', '1', '6', 'title', '315', 'HASBRO JEUX DE SOCIÉTÉ', 'HASBRO JEUX DE SOCIÉTÉ');
INSERT INTO `lang_phrase` VALUES ('3123', '2', '6', 'title', '315', 'HASBRO JEUX DE SOCIÉTÉ', 'HASBRO JEUX DE SOCIÉTÉ');
INSERT INTO `lang_phrase` VALUES ('3124', '3', '6', 'title', '315', 'HASBRO JEUX DE SOCIÉTÉ', 'HASBRO JEUX DE SOCIÉTÉ');
INSERT INTO `lang_phrase` VALUES ('3125', '1', '6', 'title', '316', 'HAVAIANAS', 'HAVAIANAS');
INSERT INTO `lang_phrase` VALUES ('3126', '2', '6', 'title', '316', 'HAVAIANAS', 'HAVAIANAS');
INSERT INTO `lang_phrase` VALUES ('3127', '3', '6', 'title', '316', 'HAVAIANAS', 'HAVAIANAS');
INSERT INTO `lang_phrase` VALUES ('3128', '1', '6', 'title', '317', 'HAVILAND', 'HAVILAND');
INSERT INTO `lang_phrase` VALUES ('3129', '2', '6', 'title', '317', 'HAVILAND', 'HAVILAND');
INSERT INTO `lang_phrase` VALUES ('3130', '3', '6', 'title', '317', 'HAVILAND', 'HAVILAND');
INSERT INTO `lang_phrase` VALUES ('3131', '1', '6', 'title', '318', 'HELLO PARIS', 'HELLO PARIS');
INSERT INTO `lang_phrase` VALUES ('3132', '2', '6', 'title', '318', 'HELLO PARIS', 'HELLO PARIS');
INSERT INTO `lang_phrase` VALUES ('3133', '3', '6', 'title', '318', 'HELLO PARIS', 'HELLO PARIS');
INSERT INTO `lang_phrase` VALUES ('3134', '1', '6', 'title', '319', 'HERBELIN', 'HERBELIN');
INSERT INTO `lang_phrase` VALUES ('3135', '2', '6', 'title', '319', 'HERBELIN', 'HERBELIN');
INSERT INTO `lang_phrase` VALUES ('3136', '3', '6', 'title', '319', 'HERBELIN', 'HERBELIN');
INSERT INTO `lang_phrase` VALUES ('3137', '1', '6', 'title', '320', 'HERMÈS', 'HERMÈS');
INSERT INTO `lang_phrase` VALUES ('3138', '2', '6', 'title', '320', 'HERMÈS', 'HERMÈS');
INSERT INTO `lang_phrase` VALUES ('3139', '3', '6', 'title', '320', 'HERMÈS', 'HERMÈS');
INSERT INTO `lang_phrase` VALUES ('3140', '1', '6', 'title', '321', 'HERSCHEL', 'HERSCHEL');
INSERT INTO `lang_phrase` VALUES ('3141', '2', '6', 'title', '321', 'HERSCHEL', 'HERSCHEL');
INSERT INTO `lang_phrase` VALUES ('3142', '3', '6', 'title', '321', 'HERSCHEL', 'HERSCHEL');
INSERT INTO `lang_phrase` VALUES ('3143', '1', '6', 'title', '322', 'HIDDEN EYE', 'HIDDEN EYE');
INSERT INTO `lang_phrase` VALUES ('3144', '2', '6', 'title', '322', 'HIDDEN EYE', 'HIDDEN EYE');
INSERT INTO `lang_phrase` VALUES ('3145', '3', '6', 'title', '322', 'HIDDEN EYE', 'HIDDEN EYE');
INSERT INTO `lang_phrase` VALUES ('3146', '1', '6', 'title', '323', 'HIGH', 'HIGH');
INSERT INTO `lang_phrase` VALUES ('3147', '2', '6', 'title', '323', 'HIGH', 'HIGH');
INSERT INTO `lang_phrase` VALUES ('3148', '3', '6', 'title', '323', 'HIGH', 'HIGH');
INSERT INTO `lang_phrase` VALUES ('3149', '1', '6', 'title', '324', 'HILFIGER DENIM', 'HILFIGER DENIM');
INSERT INTO `lang_phrase` VALUES ('3150', '2', '6', 'title', '324', 'HILFIGER DENIM', 'HILFIGER DENIM');
INSERT INTO `lang_phrase` VALUES ('3151', '3', '6', 'title', '324', 'HILFIGER DENIM', 'HILFIGER DENIM');
INSERT INTO `lang_phrase` VALUES ('3152', '1', '6', 'title', '325', 'HOGAN', 'HOGAN');
INSERT INTO `lang_phrase` VALUES ('3153', '2', '6', 'title', '325', 'HOGAN', 'HOGAN');
INSERT INTO `lang_phrase` VALUES ('3154', '3', '6', 'title', '325', 'HOGAN', 'HOGAN');
INSERT INTO `lang_phrase` VALUES ('3155', '1', '6', 'title', '326', 'HOM', 'HOM');
INSERT INTO `lang_phrase` VALUES ('3156', '2', '6', 'title', '326', 'HOM', 'HOM');
INSERT INTO `lang_phrase` VALUES ('3157', '3', '6', 'title', '326', 'HOM', 'HOM');
INSERT INTO `lang_phrase` VALUES ('3158', '1', '6', 'title', '327', 'HUBLOT', 'HUBLOT');
INSERT INTO `lang_phrase` VALUES ('3159', '2', '6', 'title', '327', 'HUBLOT', 'HUBLOT');
INSERT INTO `lang_phrase` VALUES ('3160', '3', '6', 'title', '327', 'HUBLOT', 'HUBLOT');
INSERT INTO `lang_phrase` VALUES ('3161', '1', '6', 'title', '328', 'HUGO BOSS', 'HUGO BOSS');
INSERT INTO `lang_phrase` VALUES ('3162', '2', '6', 'title', '328', 'HUGO BOSS', 'HUGO BOSS');
INSERT INTO `lang_phrase` VALUES ('3163', '3', '6', 'title', '328', 'HUGO BOSS', 'HUGO BOSS');
INSERT INTO `lang_phrase` VALUES ('3164', '1', '6', 'title', '329', 'HUIT', 'HUIT');
INSERT INTO `lang_phrase` VALUES ('3165', '2', '6', 'title', '329', 'HUIT', 'HUIT');
INSERT INTO `lang_phrase` VALUES ('3166', '3', '6', 'title', '329', 'HUIT', 'HUIT');
INSERT INTO `lang_phrase` VALUES ('3167', '1', '6', 'title', '330', 'I WAS IN', 'I WAS IN');
INSERT INTO `lang_phrase` VALUES ('3168', '2', '6', 'title', '330', 'I WAS IN', 'I WAS IN');
INSERT INTO `lang_phrase` VALUES ('3169', '3', '6', 'title', '330', 'I WAS IN', 'I WAS IN');
INSERT INTO `lang_phrase` VALUES ('3170', '1', '6', 'title', '331', 'IDÉES CADEAUX', 'IDÉES CADEAUX');
INSERT INTO `lang_phrase` VALUES ('3171', '2', '6', 'title', '331', 'IDÉES CADEAUX', 'IDÉES CADEAUX');
INSERT INTO `lang_phrase` VALUES ('3172', '3', '6', 'title', '331', 'IDÉES CADEAUX', 'IDÉES CADEAUX');
INSERT INTO `lang_phrase` VALUES ('3173', '1', '6', 'title', '332', 'IITTALA', 'IITTALA');
INSERT INTO `lang_phrase` VALUES ('3174', '2', '6', 'title', '332', 'IITTALA', 'IITTALA');
INSERT INTO `lang_phrase` VALUES ('3175', '3', '6', 'title', '332', 'IITTALA', 'IITTALA');
INSERT INTO `lang_phrase` VALUES ('3176', '1', '6', 'title', '333', 'IKKS', 'IKKS');
INSERT INTO `lang_phrase` VALUES ('3177', '2', '6', 'title', '333', 'IKKS', 'IKKS');
INSERT INTO `lang_phrase` VALUES ('3178', '3', '6', 'title', '333', 'IKKS', 'IKKS');
INSERT INTO `lang_phrase` VALUES ('3179', '1', '6', 'title', '334', 'IMAGE D’ORIENT', 'IMAGE D’ORIENT');
INSERT INTO `lang_phrase` VALUES ('3180', '2', '6', 'title', '334', 'IMAGE D’ORIENT', 'IMAGE D’ORIENT');
INSERT INTO `lang_phrase` VALUES ('3181', '3', '6', 'title', '334', 'IMAGE D’ORIENT', 'IMAGE D’ORIENT');
INSERT INTO `lang_phrase` VALUES ('3182', '1', '6', 'title', '335', 'IMPLICITE', 'IMPLICITE');
INSERT INTO `lang_phrase` VALUES ('3183', '2', '6', 'title', '335', 'IMPLICITE', 'IMPLICITE');
INSERT INTO `lang_phrase` VALUES ('3184', '3', '6', 'title', '335', 'IMPLICITE', 'IMPLICITE');
INSERT INTO `lang_phrase` VALUES ('3185', '1', '6', 'title', '336', 'INÈS DE LA FRESSANGE', 'INÈS DE LA FRESSANGE');
INSERT INTO `lang_phrase` VALUES ('3186', '2', '6', 'title', '336', 'INÈS DE LA FRESSANGE', 'INÈS DE LA FRESSANGE');
INSERT INTO `lang_phrase` VALUES ('3187', '3', '6', 'title', '336', 'INÈS DE LA FRESSANGE', 'INÈS DE LA FRESSANGE');
INSERT INTO `lang_phrase` VALUES ('3188', '1', '6', 'title', '337', 'IODUS', 'IODUS');
INSERT INTO `lang_phrase` VALUES ('3189', '2', '6', 'title', '337', 'IODUS', 'IODUS');
INSERT INTO `lang_phrase` VALUES ('3190', '3', '6', 'title', '337', 'IODUS', 'IODUS');
INSERT INTO `lang_phrase` VALUES ('3191', '1', '6', 'title', '338', 'IRO', 'IRO');
INSERT INTO `lang_phrase` VALUES ('3192', '2', '6', 'title', '338', 'IRO', 'IRO');
INSERT INTO `lang_phrase` VALUES ('3193', '3', '6', 'title', '338', 'IRO', 'IRO');
INSERT INTO `lang_phrase` VALUES ('3194', '1', '6', 'title', '339', 'ISABEL MARANT', 'ISABEL MARANT');
INSERT INTO `lang_phrase` VALUES ('3195', '2', '6', 'title', '339', 'ISABEL MARANT', 'ISABEL MARANT');
INSERT INTO `lang_phrase` VALUES ('3196', '3', '6', 'title', '339', 'ISABEL MARANT', 'ISABEL MARANT');
INSERT INTO `lang_phrase` VALUES ('3197', '1', '6', 'title', '340', 'ISOTONER CHAUSSON', 'ISOTONER CHAUSSON');
INSERT INTO `lang_phrase` VALUES ('3198', '2', '6', 'title', '340', 'ISOTONER CHAUSSON', 'ISOTONER CHAUSSON');
INSERT INTO `lang_phrase` VALUES ('3199', '3', '6', 'title', '340', 'ISOTONER CHAUSSON', 'ISOTONER CHAUSSON');
INSERT INTO `lang_phrase` VALUES ('3200', '1', '6', 'title', '341', 'ISSEY MIYAKE', 'ISSEY MIYAKE');
INSERT INTO `lang_phrase` VALUES ('3201', '2', '6', 'title', '341', 'ISSEY MIYAKE', 'ISSEY MIYAKE');
INSERT INTO `lang_phrase` VALUES ('3202', '3', '6', 'title', '341', 'ISSEY MIYAKE', 'ISSEY MIYAKE');
INSERT INTO `lang_phrase` VALUES ('3203', '1', '6', 'title', '342', 'IWC', 'IWC');
INSERT INTO `lang_phrase` VALUES ('3204', '2', '6', 'title', '342', 'IWC', 'IWC');
INSERT INTO `lang_phrase` VALUES ('3205', '3', '6', 'title', '342', 'IWC', 'IWC');
INSERT INTO `lang_phrase` VALUES ('3206', '1', '6', 'title', '343', 'J.BRAND', 'J.BRAND');
INSERT INTO `lang_phrase` VALUES ('3207', '2', '6', 'title', '343', 'J.BRAND', 'J.BRAND');
INSERT INTO `lang_phrase` VALUES ('3208', '3', '6', 'title', '343', 'J.BRAND', 'J.BRAND');
INSERT INTO `lang_phrase` VALUES ('3209', '1', '6', 'title', '344', 'JACADI', 'JACADI');
INSERT INTO `lang_phrase` VALUES ('3210', '2', '6', 'title', '344', 'JACADI', 'JACADI');
INSERT INTO `lang_phrase` VALUES ('3211', '3', '6', 'title', '344', 'JACADI', 'JACADI');
INSERT INTO `lang_phrase` VALUES ('3212', '1', '6', 'title', '345', 'JACQUARD FRANÇAIS', 'JACQUARD FRANÇAIS');
INSERT INTO `lang_phrase` VALUES ('3213', '2', '6', 'title', '345', 'JACQUARD FRANÇAIS', 'JACQUARD FRANÇAIS');
INSERT INTO `lang_phrase` VALUES ('3214', '3', '6', 'title', '345', 'JACQUARD FRANÇAIS', 'JACQUARD FRANÇAIS');
INSERT INTO `lang_phrase` VALUES ('3215', '1', '6', 'title', '346', 'JAEGER-LECOULTRE', 'JAEGER-LECOULTRE');
INSERT INTO `lang_phrase` VALUES ('3216', '2', '6', 'title', '346', 'JAEGER-LECOULTRE', 'JAEGER-LECOULTRE');
INSERT INTO `lang_phrase` VALUES ('3217', '3', '6', 'title', '346', 'JAEGER-LECOULTRE', 'JAEGER-LECOULTRE');
INSERT INTO `lang_phrase` VALUES ('3218', '1', '6', 'title', '347', 'JALLA', 'JALLA');
INSERT INTO `lang_phrase` VALUES ('3219', '2', '6', 'title', '347', 'JALLA', 'JALLA');
INSERT INTO `lang_phrase` VALUES ('3220', '3', '6', 'title', '347', 'JALLA', 'JALLA');
INSERT INTO `lang_phrase` VALUES ('3221', '1', '6', 'title', '348', 'JANOD', 'JANOD');
INSERT INTO `lang_phrase` VALUES ('3222', '2', '6', 'title', '348', 'JANOD', 'JANOD');
INSERT INTO `lang_phrase` VALUES ('3223', '3', '6', 'title', '348', 'JANOD', 'JANOD');
INSERT INTO `lang_phrase` VALUES ('3224', '1', '6', 'title', '349', 'JARDIN SECRET', 'JARDIN SECRET');
INSERT INTO `lang_phrase` VALUES ('3225', '2', '6', 'title', '349', 'JARDIN SECRET', 'JARDIN SECRET');
INSERT INTO `lang_phrase` VALUES ('3226', '3', '6', 'title', '349', 'JARDIN SECRET', 'JARDIN SECRET');
INSERT INTO `lang_phrase` VALUES ('3227', '1', '6', 'title', '350', 'JARS', 'JARS');
INSERT INTO `lang_phrase` VALUES ('3228', '2', '6', 'title', '350', 'JARS', 'JARS');
INSERT INTO `lang_phrase` VALUES ('3229', '3', '6', 'title', '350', 'JARS', 'JARS');
INSERT INTO `lang_phrase` VALUES ('3230', '1', '6', 'title', '351', 'JB MARTIN', 'JB MARTIN');
INSERT INTO `lang_phrase` VALUES ('3231', '2', '6', 'title', '351', 'JB MARTIN', 'JB MARTIN');
INSERT INTO `lang_phrase` VALUES ('3232', '3', '6', 'title', '351', 'JB MARTIN', 'JB MARTIN');
INSERT INTO `lang_phrase` VALUES ('3233', '1', '6', 'title', '352', 'JEAN-BAPTISTE RAUTUREAU', 'JEAN-BAPTISTE RAUTUREAU');
INSERT INTO `lang_phrase` VALUES ('3234', '2', '6', 'title', '352', 'JEAN-BAPTISTE RAUTUREAU', 'JEAN-BAPTISTE RAUTUREAU');
INSERT INTO `lang_phrase` VALUES ('3235', '3', '6', 'title', '352', 'JEAN-BAPTISTE RAUTUREAU', 'JEAN-BAPTISTE RAUTUREAU');
INSERT INTO `lang_phrase` VALUES ('3236', '1', '6', 'title', '353', 'JEAN-PAUL GAULTIER', 'JEAN-PAUL GAULTIER');
INSERT INTO `lang_phrase` VALUES ('3237', '2', '6', 'title', '353', 'JEAN-PAUL GAULTIER', 'JEAN-PAUL GAULTIER');
INSERT INTO `lang_phrase` VALUES ('3238', '3', '6', 'title', '353', 'JEAN-PAUL GAULTIER', 'JEAN-PAUL GAULTIER');
INSERT INTO `lang_phrase` VALUES ('3239', '1', '6', 'title', '354', 'JEAN-PAUL HÉVIN', 'JEAN-PAUL HÉVIN');
INSERT INTO `lang_phrase` VALUES ('3240', '2', '6', 'title', '354', 'JEAN-PAUL HÉVIN', 'JEAN-PAUL HÉVIN');
INSERT INTO `lang_phrase` VALUES ('3241', '3', '6', 'title', '354', 'JEAN-PAUL HÉVIN', 'JEAN-PAUL HÉVIN');
INSERT INTO `lang_phrase` VALUES ('3242', '1', '6', 'title', '355', 'JÉRÔME DREYFUSS', 'JÉRÔME DREYFUSS');
INSERT INTO `lang_phrase` VALUES ('3243', '2', '6', 'title', '355', 'JÉRÔME DREYFUSS', 'JÉRÔME DREYFUSS');
INSERT INTO `lang_phrase` VALUES ('3244', '3', '6', 'title', '355', 'JÉRÔME DREYFUSS', 'JÉRÔME DREYFUSS');
INSERT INTO `lang_phrase` VALUES ('3245', '1', '6', 'title', '356', 'JETABLE', 'JETABLE');
INSERT INTO `lang_phrase` VALUES ('3246', '2', '6', 'title', '356', 'JETABLE', 'JETABLE');
INSERT INTO `lang_phrase` VALUES ('3247', '3', '6', 'title', '356', 'JETABLE', 'JETABLE');
INSERT INTO `lang_phrase` VALUES ('3248', '1', '6', 'title', '357', 'JIL SANDER NAVY', 'JIL SANDER NAVY');
INSERT INTO `lang_phrase` VALUES ('3249', '2', '6', 'title', '357', 'JIL SANDER NAVY', 'JIL SANDER NAVY');
INSERT INTO `lang_phrase` VALUES ('3250', '3', '6', 'title', '357', 'JIL SANDER NAVY', 'JIL SANDER NAVY');
INSERT INTO `lang_phrase` VALUES ('3251', '1', '6', 'title', '358', 'JIMMY CHOO', 'JIMMY CHOO');
INSERT INTO `lang_phrase` VALUES ('3252', '2', '6', 'title', '358', 'JIMMY CHOO', 'JIMMY CHOO');
INSERT INTO `lang_phrase` VALUES ('3253', '3', '6', 'title', '358', 'JIMMY CHOO', 'JIMMY CHOO');
INSERT INTO `lang_phrase` VALUES ('3254', '1', '6', 'title', '359', 'JO MALONE', 'JO MALONE');
INSERT INTO `lang_phrase` VALUES ('3255', '2', '6', 'title', '359', 'JO MALONE', 'JO MALONE');
INSERT INTO `lang_phrase` VALUES ('3256', '3', '6', 'title', '359', 'JO MALONE', 'JO MALONE');
INSERT INTO `lang_phrase` VALUES ('3257', '1', '6', 'title', '360', 'JODHPUR', 'JODHPUR');
INSERT INTO `lang_phrase` VALUES ('3258', '2', '6', 'title', '360', 'JODHPUR', 'JODHPUR');
INSERT INTO `lang_phrase` VALUES ('3259', '3', '6', 'title', '360', 'JODHPUR', 'JODHPUR');
INSERT INTO `lang_phrase` VALUES ('3260', '1', '6', 'title', '361', 'JONAK', 'JONAK');
INSERT INTO `lang_phrase` VALUES ('3261', '2', '6', 'title', '361', 'JONAK', 'JONAK');
INSERT INTO `lang_phrase` VALUES ('3262', '3', '6', 'title', '361', 'JONAK', 'JONAK');
INSERT INTO `lang_phrase` VALUES ('3263', '1', '6', 'title', '362', 'JOSEPH', 'JOSEPH');
INSERT INTO `lang_phrase` VALUES ('3264', '2', '6', 'title', '362', 'JOSEPH', 'JOSEPH');
INSERT INTO `lang_phrase` VALUES ('3265', '3', '6', 'title', '362', 'JOSEPH', 'JOSEPH');
INSERT INTO `lang_phrase` VALUES ('3266', '1', '6', 'title', '363', 'JUICY COUTURE', 'JUICY COUTURE');
INSERT INTO `lang_phrase` VALUES ('3267', '2', '6', 'title', '363', 'JUICY COUTURE', 'JUICY COUTURE');
INSERT INTO `lang_phrase` VALUES ('3268', '3', '6', 'title', '363', 'JUICY COUTURE', 'JUICY COUTURE');
INSERT INTO `lang_phrase` VALUES ('3269', '1', '6', 'title', '364', 'JUMP', 'JUMP');
INSERT INTO `lang_phrase` VALUES ('3270', '2', '6', 'title', '364', 'JUMP', 'JUMP');
INSERT INTO `lang_phrase` VALUES ('3271', '3', '6', 'title', '364', 'JUMP', 'JUMP');
INSERT INTO `lang_phrase` VALUES ('3272', '1', '6', 'title', '365', 'JUNYA WATANABE', 'JUNYA WATANABE');
INSERT INTO `lang_phrase` VALUES ('3273', '2', '6', 'title', '365', 'JUNYA WATANABE', 'JUNYA WATANABE');
INSERT INTO `lang_phrase` VALUES ('3274', '3', '6', 'title', '365', 'JUNYA WATANABE', 'JUNYA WATANABE');
INSERT INTO `lang_phrase` VALUES ('3275', '1', '6', 'title', '366', 'JURA', 'JURA');
INSERT INTO `lang_phrase` VALUES ('3276', '2', '6', 'title', '366', 'JURA', 'JURA');
INSERT INTO `lang_phrase` VALUES ('3277', '3', '6', 'title', '366', 'JURA', 'JURA');
INSERT INTO `lang_phrase` VALUES ('3278', '1', '6', 'title', '367', 'JUST CAVALLI', 'JUST CAVALLI');
INSERT INTO `lang_phrase` VALUES ('3279', '2', '6', 'title', '367', 'JUST CAVALLI', 'JUST CAVALLI');
INSERT INTO `lang_phrase` VALUES ('3280', '3', '6', 'title', '367', 'JUST CAVALLI', 'JUST CAVALLI');
INSERT INTO `lang_phrase` VALUES ('3281', '1', '6', 'title', '368', 'JUUN J', 'JUUN J');
INSERT INTO `lang_phrase` VALUES ('3282', '2', '6', 'title', '368', 'JUUN J', 'JUUN J');
INSERT INTO `lang_phrase` VALUES ('3283', '3', '6', 'title', '368', 'JUUN J', 'JUUN J');
INSERT INTO `lang_phrase` VALUES ('3284', '1', '6', 'title', '369', 'KAPLA', 'KAPLA');
INSERT INTO `lang_phrase` VALUES ('3285', '2', '6', 'title', '369', 'KAPLA', 'KAPLA');
INSERT INTO `lang_phrase` VALUES ('3286', '3', '6', 'title', '369', 'KAPLA', 'KAPLA');
INSERT INTO `lang_phrase` VALUES ('3287', '1', '6', 'title', '370', 'KAPORAL 5', 'KAPORAL 5');
INSERT INTO `lang_phrase` VALUES ('3288', '2', '6', 'title', '370', 'KAPORAL 5', 'KAPORAL 5');
INSERT INTO `lang_phrase` VALUES ('3289', '3', '6', 'title', '370', 'KAPORAL 5', 'KAPORAL 5');
INSERT INTO `lang_phrase` VALUES ('3290', '1', '6', 'title', '371', 'KAREN MILLEN', 'KAREN MILLEN');
INSERT INTO `lang_phrase` VALUES ('3291', '2', '6', 'title', '371', 'KAREN MILLEN', 'KAREN MILLEN');
INSERT INTO `lang_phrase` VALUES ('3292', '3', '6', 'title', '371', 'KAREN MILLEN', 'KAREN MILLEN');
INSERT INTO `lang_phrase` VALUES ('3293', '1', '6', 'title', '372', 'KARL LAGERFED', 'KARL LAGERFED');
INSERT INTO `lang_phrase` VALUES ('3294', '2', '6', 'title', '372', 'KARL LAGERFED', 'KARL LAGERFED');
INSERT INTO `lang_phrase` VALUES ('3295', '3', '6', 'title', '372', 'KARL LAGERFED', 'KARL LAGERFED');
INSERT INTO `lang_phrase` VALUES ('3296', '1', '6', 'title', '373', 'KATE SPADE', 'KATE SPADE');
INSERT INTO `lang_phrase` VALUES ('3297', '2', '6', 'title', '373', 'KATE SPADE', 'KATE SPADE');
INSERT INTO `lang_phrase` VALUES ('3298', '3', '6', 'title', '373', 'KATE SPADE', 'KATE SPADE');
INSERT INTO `lang_phrase` VALUES ('3299', '1', '6', 'title', '374', 'KENZO', 'KENZO');
INSERT INTO `lang_phrase` VALUES ('3300', '2', '6', 'title', '374', 'KENZO', 'KENZO');
INSERT INTO `lang_phrase` VALUES ('3301', '3', '6', 'title', '374', 'KENZO', 'KENZO');
INSERT INTO `lang_phrase` VALUES ('3302', '1', '6', 'title', '375', 'KESSLORD', 'KESSLORD');
INSERT INTO `lang_phrase` VALUES ('3303', '2', '6', 'title', '375', 'KESSLORD', 'KESSLORD');
INSERT INTO `lang_phrase` VALUES ('3304', '3', '6', 'title', '375', 'KESSLORD', 'KESSLORD');
INSERT INTO `lang_phrase` VALUES ('3305', '1', '6', 'title', '376', 'KICKERS', 'KICKERS');
INSERT INTO `lang_phrase` VALUES ('3306', '2', '6', 'title', '376', 'KICKERS', 'KICKERS');
INSERT INTO `lang_phrase` VALUES ('3307', '3', '6', 'title', '376', 'KICKERS', 'KICKERS');
INSERT INTO `lang_phrase` VALUES ('3308', '1', '6', 'title', '377', 'KID’S GRAFFITI', 'KID’S GRAFFITI');
INSERT INTO `lang_phrase` VALUES ('3309', '2', '6', 'title', '377', 'KID’S GRAFFITI', 'KID’S GRAFFITI');
INSERT INTO `lang_phrase` VALUES ('3310', '3', '6', 'title', '377', 'KID’S GRAFFITI', 'KID’S GRAFFITI');
INSERT INTO `lang_phrase` VALUES ('3311', '1', '6', 'title', '378', 'KIEHL’S', 'KIEHL’S');
INSERT INTO `lang_phrase` VALUES ('3312', '2', '6', 'title', '378', 'KIEHL’S', 'KIEHL’S');
INSERT INTO `lang_phrase` VALUES ('3313', '3', '6', 'title', '378', 'KIEHL’S', 'KIEHL’S');
INSERT INTO `lang_phrase` VALUES ('3314', '1', '6', 'title', '379', 'KIPLING', 'KIPLING');
INSERT INTO `lang_phrase` VALUES ('3315', '2', '6', 'title', '379', 'KIPLING', 'KIPLING');
INSERT INTO `lang_phrase` VALUES ('3316', '3', '6', 'title', '379', 'KIPLING', 'KIPLING');
INSERT INTO `lang_phrase` VALUES ('3317', '1', '6', 'title', '380', 'KITCHENAID', 'KITCHENAID');
INSERT INTO `lang_phrase` VALUES ('3318', '2', '6', 'title', '380', 'KITCHENAID', 'KITCHENAID');
INSERT INTO `lang_phrase` VALUES ('3319', '3', '6', 'title', '380', 'KITCHENAID', 'KITCHENAID');
INSERT INTO `lang_phrase` VALUES ('3320', '1', '6', 'title', '381', 'KITON', 'KITON');
INSERT INTO `lang_phrase` VALUES ('3321', '2', '6', 'title', '381', 'KITON', 'KITON');
INSERT INTO `lang_phrase` VALUES ('3322', '3', '6', 'title', '381', 'KITON', 'KITON');
INSERT INTO `lang_phrase` VALUES ('3323', '1', '6', 'title', '382', 'KITSUNÉ', 'KITSUNÉ');
INSERT INTO `lang_phrase` VALUES ('3324', '2', '6', 'title', '382', 'KITSUNÉ', 'KITSUNÉ');
INSERT INTO `lang_phrase` VALUES ('3325', '3', '6', 'title', '382', 'KITSUNÉ', 'KITSUNÉ');
INSERT INTO `lang_phrase` VALUES ('3326', '1', '6', 'title', '383', 'KIWI', 'KIWI');
INSERT INTO `lang_phrase` VALUES ('3327', '2', '6', 'title', '383', 'KIWI', 'KIWI');
INSERT INTO `lang_phrase` VALUES ('3328', '3', '6', 'title', '383', 'KIWI', 'KIWI');
INSERT INTO `lang_phrase` VALUES ('3329', '1', '6', 'title', '384', 'KOST', 'KOST');
INSERT INTO `lang_phrase` VALUES ('3330', '2', '6', 'title', '384', 'KOST', 'KOST');
INSERT INTO `lang_phrase` VALUES ('3331', '3', '6', 'title', '384', 'KOST', 'KOST');
INSERT INTO `lang_phrase` VALUES ('3332', '1', '6', 'title', '385', 'KRUPS', 'KRUPS');
INSERT INTO `lang_phrase` VALUES ('3333', '2', '6', 'title', '385', 'KRUPS', 'KRUPS');
INSERT INTO `lang_phrase` VALUES ('3334', '3', '6', 'title', '385', 'KRUPS', 'KRUPS');
INSERT INTO `lang_phrase` VALUES ('3335', '1', '6', 'title', '386', 'KURE BAZAR', 'KURE BAZAR');
INSERT INTO `lang_phrase` VALUES ('3336', '2', '6', 'title', '386', 'KURE BAZAR', 'KURE BAZAR');
INSERT INTO `lang_phrase` VALUES ('3337', '3', '6', 'title', '386', 'KURE BAZAR', 'KURE BAZAR');
INSERT INTO `lang_phrase` VALUES ('3338', '1', '6', 'title', '387', 'KUSMI TEA', 'KUSMI TEA');
INSERT INTO `lang_phrase` VALUES ('3339', '2', '6', 'title', '387', 'KUSMI TEA', 'KUSMI TEA');
INSERT INTO `lang_phrase` VALUES ('3340', '3', '6', 'title', '387', 'KUSMI TEA', 'KUSMI TEA');
INSERT INTO `lang_phrase` VALUES ('3341', '1', '6', 'title', '388', 'L’AIGLON', 'L’AIGLON');
INSERT INTO `lang_phrase` VALUES ('3342', '2', '6', 'title', '388', 'L’AIGLON', 'L’AIGLON');
INSERT INTO `lang_phrase` VALUES ('3343', '3', '6', 'title', '388', 'L’AIGLON', 'L’AIGLON');
INSERT INTO `lang_phrase` VALUES ('3344', '1', '6', 'title', '389', 'L’ARTISAN PARFUMEUR', 'L’ARTISAN PARFUMEUR');
INSERT INTO `lang_phrase` VALUES ('3345', '2', '6', 'title', '389', 'L’ARTISAN PARFUMEUR', 'L’ARTISAN PARFUMEUR');
INSERT INTO `lang_phrase` VALUES ('3346', '3', '6', 'title', '389', 'L’ARTISAN PARFUMEUR', 'L’ARTISAN PARFUMEUR');
INSERT INTO `lang_phrase` VALUES ('3347', '1', '6', 'title', '390', 'L’OCCITANE', 'L’OCCITANE');
INSERT INTO `lang_phrase` VALUES ('3348', '2', '6', 'title', '390', 'L’OCCITANE', 'L’OCCITANE');
INSERT INTO `lang_phrase` VALUES ('3349', '3', '6', 'title', '390', 'L’OCCITANE', 'L’OCCITANE');
INSERT INTO `lang_phrase` VALUES ('3350', '1', '6', 'title', '391', 'L’ORÉAL', 'L’ORÉAL');
INSERT INTO `lang_phrase` VALUES ('3351', '2', '6', 'title', '391', 'L’ORÉAL', 'L’ORÉAL');
INSERT INTO `lang_phrase` VALUES ('3352', '3', '6', 'title', '391', 'L’ORÉAL', 'L’ORÉAL');
INSERT INTO `lang_phrase` VALUES ('3353', '1', '6', 'title', '392', 'L’ORÉAL PERFECTION', 'L’ORÉAL PERFECTION');
INSERT INTO `lang_phrase` VALUES ('3354', '2', '6', 'title', '392', 'L’ORÉAL PERFECTION', 'L’ORÉAL PERFECTION');
INSERT INTO `lang_phrase` VALUES ('3355', '3', '6', 'title', '392', 'L’ORÉAL PERFECTION', 'L’ORÉAL PERFECTION');
INSERT INTO `lang_phrase` VALUES ('3356', '1', '6', 'title', '393', 'L.K.BENNETT', 'L.K.BENNETT');
INSERT INTO `lang_phrase` VALUES ('3357', '2', '6', 'title', '393', 'L.K.BENNETT', 'L.K.BENNETT');
INSERT INTO `lang_phrase` VALUES ('3358', '3', '6', 'title', '393', 'L.K.BENNETT', 'L.K.BENNETT');
INSERT INTO `lang_phrase` VALUES ('3359', '1', '6', 'title', '394', 'LA COLLINE', 'LA COLLINE');
INSERT INTO `lang_phrase` VALUES ('3360', '2', '6', 'title', '394', 'LA COLLINE', 'LA COLLINE');
INSERT INTO `lang_phrase` VALUES ('3361', '3', '6', 'title', '394', 'LA COLLINE', 'LA COLLINE');
INSERT INTO `lang_phrase` VALUES ('3362', '1', '6', 'title', '395', 'LA FÉE MARABOUTEE', 'LA FÉE MARABOUTEE');
INSERT INTO `lang_phrase` VALUES ('3363', '2', '6', 'title', '395', 'LA FÉE MARABOUTEE', 'LA FÉE MARABOUTEE');
INSERT INTO `lang_phrase` VALUES ('3364', '3', '6', 'title', '395', 'LA FÉE MARABOUTEE', 'LA FÉE MARABOUTEE');
INSERT INTO `lang_phrase` VALUES ('3365', '1', '6', 'title', '396', 'LA PERLA', 'LA PERLA');
INSERT INTO `lang_phrase` VALUES ('3366', '2', '6', 'title', '396', 'LA PERLA', 'LA PERLA');
INSERT INTO `lang_phrase` VALUES ('3367', '3', '6', 'title', '396', 'LA PERLA', 'LA PERLA');
INSERT INTO `lang_phrase` VALUES ('3368', '1', '6', 'title', '397', 'LA PRAIRIE', 'LA PRAIRIE');
INSERT INTO `lang_phrase` VALUES ('3369', '2', '6', 'title', '397', 'LA PRAIRIE', 'LA PRAIRIE');
INSERT INTO `lang_phrase` VALUES ('3370', '3', '6', 'title', '397', 'LA PRAIRIE', 'LA PRAIRIE');
INSERT INTO `lang_phrase` VALUES ('3371', '1', '6', 'title', '398', 'LA ROCHÈRE', 'LA ROCHÈRE');
INSERT INTO `lang_phrase` VALUES ('3372', '2', '6', 'title', '398', 'LA ROCHÈRE', 'LA ROCHÈRE');
INSERT INTO `lang_phrase` VALUES ('3373', '3', '6', 'title', '398', 'LA ROCHÈRE', 'LA ROCHÈRE');
INSERT INTO `lang_phrase` VALUES ('3374', '1', '6', 'title', '399', 'LA ROUTE DES INDES', 'LA ROUTE DES INDES');
INSERT INTO `lang_phrase` VALUES ('3375', '2', '6', 'title', '399', 'LA ROUTE DES INDES', 'LA ROUTE DES INDES');
INSERT INTO `lang_phrase` VALUES ('3376', '3', '6', 'title', '399', 'LA ROUTE DES INDES', 'LA ROUTE DES INDES');
INSERT INTO `lang_phrase` VALUES ('3377', '1', '6', 'title', '400', 'LABO CHAUSSURES CRÉATEURS', 'LABO CHAUSSURES CRÉATEURS');
INSERT INTO `lang_phrase` VALUES ('3378', '2', '6', 'title', '400', 'LABO CHAUSSURES CRÉATEURS', 'LABO CHAUSSURES CRÉATEURS');
INSERT INTO `lang_phrase` VALUES ('3379', '3', '6', 'title', '400', 'LABO CHAUSSURES CRÉATEURS', 'LABO CHAUSSURES CRÉATEURS');
INSERT INTO `lang_phrase` VALUES ('3380', '1', '6', 'title', '401', 'LABO CHAUSSURES VILLE', 'LABO CHAUSSURES VILLE');
INSERT INTO `lang_phrase` VALUES ('3381', '2', '6', 'title', '401', 'LABO CHAUSSURES VILLE', 'LABO CHAUSSURES VILLE');
INSERT INTO `lang_phrase` VALUES ('3382', '3', '6', 'title', '401', 'LABO CHAUSSURES VILLE', 'LABO CHAUSSURES VILLE');
INSERT INTO `lang_phrase` VALUES ('3383', '1', '6', 'title', '402', 'LABO CRÉATEURS 1', 'LABO CRÉATEURS 1');
INSERT INTO `lang_phrase` VALUES ('3384', '2', '6', 'title', '402', 'LABO CRÉATEURS 1', 'LABO CRÉATEURS 1');
INSERT INTO `lang_phrase` VALUES ('3385', '3', '6', 'title', '402', 'LABO CRÉATEURS 1', 'LABO CRÉATEURS 1');
INSERT INTO `lang_phrase` VALUES ('3386', '1', '6', 'title', '403', 'LABO CRÉATEURS 3', 'LABO CRÉATEURS 3');
INSERT INTO `lang_phrase` VALUES ('3387', '2', '6', 'title', '403', 'LABO CRÉATEURS 3', 'LABO CRÉATEURS 3');
INSERT INTO `lang_phrase` VALUES ('3388', '3', '6', 'title', '403', 'LABO CRÉATEURS 3', 'LABO CRÉATEURS 3');
INSERT INTO `lang_phrase` VALUES ('3389', '1', '6', 'title', '404', 'LABONAL', 'LABONAL');
INSERT INTO `lang_phrase` VALUES ('3390', '2', '6', 'title', '404', 'LABONAL', 'LABONAL');
INSERT INTO `lang_phrase` VALUES ('3391', '3', '6', 'title', '404', 'LABONAL', 'LABONAL');
INSERT INTO `lang_phrase` VALUES ('3392', '1', '6', 'title', '405', 'LACOSTE', 'LACOSTE');
INSERT INTO `lang_phrase` VALUES ('3393', '2', '6', 'title', '405', 'LACOSTE', 'LACOSTE');
INSERT INTO `lang_phrase` VALUES ('3394', '3', '6', 'title', '405', 'LACOSTE', 'LACOSTE');
INSERT INTO `lang_phrase` VALUES ('3395', '1', '6', 'title', '406', 'LAGOSTINA', 'LAGOSTINA');
INSERT INTO `lang_phrase` VALUES ('3396', '2', '6', 'title', '406', 'LAGOSTINA', 'LAGOSTINA');
INSERT INTO `lang_phrase` VALUES ('3397', '3', '6', 'title', '406', 'LAGOSTINA', 'LAGOSTINA');
INSERT INTO `lang_phrase` VALUES ('3398', '1', '6', 'title', '407', 'LALIQUE', 'LALIQUE');
INSERT INTO `lang_phrase` VALUES ('3399', '2', '6', 'title', '407', 'LALIQUE', 'LALIQUE');
INSERT INTO `lang_phrase` VALUES ('3400', '3', '6', 'title', '407', 'LALIQUE', 'LALIQUE');
INSERT INTO `lang_phrase` VALUES ('3401', '1', '6', 'title', '408', 'LAMBERTO', 'LAMBERTO');
INSERT INTO `lang_phrase` VALUES ('3402', '2', '6', 'title', '408', 'LAMBERTO', 'LAMBERTO');
INSERT INTO `lang_phrase` VALUES ('3403', '3', '6', 'title', '408', 'LAMBERTO', 'LAMBERTO');
INSERT INTO `lang_phrase` VALUES ('3404', '1', '6', 'title', '409', 'LOSANI', 'LOSANI');
INSERT INTO `lang_phrase` VALUES ('3405', '2', '6', 'title', '409', 'LOSANI', 'LOSANI');
INSERT INTO `lang_phrase` VALUES ('3406', '3', '6', 'title', '409', 'LOSANI', 'LOSANI');
INSERT INTO `lang_phrase` VALUES ('3407', '1', '6', 'title', '410', 'LAMPE BERGER', 'LAMPE BERGER');
INSERT INTO `lang_phrase` VALUES ('3408', '2', '6', 'title', '410', 'LAMPE BERGER', 'LAMPE BERGER');
INSERT INTO `lang_phrase` VALUES ('3409', '3', '6', 'title', '410', 'LAMPE BERGER', 'LAMPE BERGER');
INSERT INTO `lang_phrase` VALUES ('3410', '1', '6', 'title', '411', 'LANCASTER', 'LANCASTER');
INSERT INTO `lang_phrase` VALUES ('3411', '2', '6', 'title', '411', 'LANCASTER', 'LANCASTER');
INSERT INTO `lang_phrase` VALUES ('3412', '3', '6', 'title', '411', 'LANCASTER', 'LANCASTER');
INSERT INTO `lang_phrase` VALUES ('3413', '1', '6', 'title', '412', 'LANCEL', 'LANCEL');
INSERT INTO `lang_phrase` VALUES ('3414', '2', '6', 'title', '412', 'LANCEL', 'LANCEL');
INSERT INTO `lang_phrase` VALUES ('3415', '3', '6', 'title', '412', 'LANCEL', 'LANCEL');
INSERT INTO `lang_phrase` VALUES ('3416', '1', '6', 'title', '413', 'LANCÔME', 'LANCÔME');
INSERT INTO `lang_phrase` VALUES ('3417', '2', '6', 'title', '413', 'LANCÔME', 'LANCÔME');
INSERT INTO `lang_phrase` VALUES ('3418', '3', '6', 'title', '413', 'LANCÔME', 'LANCÔME');
INSERT INTO `lang_phrase` VALUES ('3419', '1', '6', 'title', '414', 'LANVIN', 'LANVIN');
INSERT INTO `lang_phrase` VALUES ('3420', '2', '6', 'title', '414', 'LANVIN', 'LANVIN');
INSERT INTO `lang_phrase` VALUES ('3421', '3', '6', 'title', '414', 'LANVIN', 'LANVIN');
INSERT INTO `lang_phrase` VALUES ('3422', '1', '6', 'title', '415', 'LAURA STAR', 'LAURA STAR');
INSERT INTO `lang_phrase` VALUES ('3423', '2', '6', 'title', '415', 'LAURA STAR', 'LAURA STAR');
INSERT INTO `lang_phrase` VALUES ('3424', '3', '6', 'title', '415', 'LAURA STAR', 'LAURA STAR');
INSERT INTO `lang_phrase` VALUES ('3425', '1', '6', 'title', '416', 'LAURA TODD', 'LAURA TODD');
INSERT INTO `lang_phrase` VALUES ('3426', '2', '6', 'title', '416', 'LAURA TODD', 'LAURA TODD');
INSERT INTO `lang_phrase` VALUES ('3427', '3', '6', 'title', '416', 'LAURA TODD', 'LAURA TODD');
INSERT INTO `lang_phrase` VALUES ('3428', '1', '6', 'title', '417', 'LAUREN', 'LAUREN');
INSERT INTO `lang_phrase` VALUES ('3429', '2', '6', 'title', '417', 'LAUREN', 'LAUREN');
INSERT INTO `lang_phrase` VALUES ('3430', '3', '6', 'title', '417', 'LAUREN', 'LAUREN');
INSERT INTO `lang_phrase` VALUES ('3431', '1', '6', 'title', '418', 'LAURENCE', 'LAURENCE');
INSERT INTO `lang_phrase` VALUES ('3432', '2', '6', 'title', '418', 'LAURENCE', 'LAURENCE');
INSERT INTO `lang_phrase` VALUES ('3433', '3', '6', 'title', '418', 'LAURENCE', 'LAURENCE');
INSERT INTO `lang_phrase` VALUES ('3434', '1', '6', 'title', '419', 'TAVERNIER', 'TAVERNIER');
INSERT INTO `lang_phrase` VALUES ('3435', '2', '6', 'title', '419', 'TAVERNIER', 'TAVERNIER');
INSERT INTO `lang_phrase` VALUES ('3436', '3', '6', 'title', '419', 'TAVERNIER', 'TAVERNIER');
INSERT INTO `lang_phrase` VALUES ('3437', '1', '6', 'title', '420', 'LE CHOCOLAT ALAIN DUCASSE', 'LE CHOCOLAT ALAIN DUCASSE');
INSERT INTO `lang_phrase` VALUES ('3438', '2', '6', 'title', '420', 'LE CHOCOLAT ALAIN DUCASSE', 'LE CHOCOLAT ALAIN DUCASSE');
INSERT INTO `lang_phrase` VALUES ('3439', '3', '6', 'title', '420', 'LE CHOCOLAT ALAIN DUCASSE', 'LE CHOCOLAT ALAIN DUCASSE');
INSERT INTO `lang_phrase` VALUES ('3440', '1', '6', 'title', '421', 'LE CREUSET LE SLIP FRANÇAIS', 'LE CREUSET LE SLIP FRANÇAIS');
INSERT INTO `lang_phrase` VALUES ('3441', '2', '6', 'title', '421', 'LE CREUSET LE SLIP FRANÇAIS', 'LE CREUSET LE SLIP FRANÇAIS');
INSERT INTO `lang_phrase` VALUES ('3442', '3', '6', 'title', '421', 'LE CREUSET LE SLIP FRANÇAIS', 'LE CREUSET LE SLIP FRANÇAIS');
INSERT INTO `lang_phrase` VALUES ('3443', '1', '6', 'title', '422', 'LE TANNEUR', 'LE TANNEUR');
INSERT INTO `lang_phrase` VALUES ('3444', '2', '6', 'title', '422', 'LE TANNEUR', 'LE TANNEUR');
INSERT INTO `lang_phrase` VALUES ('3445', '3', '6', 'title', '422', 'LE TANNEUR', 'LE TANNEUR');
INSERT INTO `lang_phrase` VALUES ('3446', '1', '6', 'title', '423', 'LE TEMPS DES CERISES', 'LE TEMPS DES CERISES');
INSERT INTO `lang_phrase` VALUES ('3447', '2', '6', 'title', '423', 'LE TEMPS DES CERISES', 'LE TEMPS DES CERISES');
INSERT INTO `lang_phrase` VALUES ('3448', '3', '6', 'title', '423', 'LE TEMPS DES CERISES', 'LE TEMPS DES CERISES');
INSERT INTO `lang_phrase` VALUES ('3449', '1', '6', 'title', '424', 'LEE', 'LEE');
INSERT INTO `lang_phrase` VALUES ('3450', '2', '6', 'title', '424', 'LEE', 'LEE');
INSERT INTO `lang_phrase` VALUES ('3451', '3', '6', 'title', '424', 'LEE', 'LEE');
INSERT INTO `lang_phrase` VALUES ('3452', '1', '6', 'title', '425', 'LEGAZEL', 'LEGAZEL');
INSERT INTO `lang_phrase` VALUES ('3453', '2', '6', 'title', '425', 'LEGAZEL', 'LEGAZEL');
INSERT INTO `lang_phrase` VALUES ('3454', '3', '6', 'title', '425', 'LEGAZEL', 'LEGAZEL');
INSERT INTO `lang_phrase` VALUES ('3455', '1', '6', 'title', '426', 'LEGO', 'LEGO');
INSERT INTO `lang_phrase` VALUES ('3456', '2', '6', 'title', '426', 'LEGO', 'LEGO');
INSERT INTO `lang_phrase` VALUES ('3457', '3', '6', 'title', '426', 'LEGO', 'LEGO');
INSERT INTO `lang_phrase` VALUES ('3458', '1', '6', 'title', '427', 'LEICA', 'LEICA');
INSERT INTO `lang_phrase` VALUES ('3459', '2', '6', 'title', '427', 'LEICA', 'LEICA');
INSERT INTO `lang_phrase` VALUES ('3460', '3', '6', 'title', '427', 'LEICA', 'LEICA');
INSERT INTO `lang_phrase` VALUES ('3461', '1', '6', 'title', '428', 'LEMAIRE', 'LEMAIRE');
INSERT INTO `lang_phrase` VALUES ('3462', '2', '6', 'title', '428', 'LEMAIRE', 'LEMAIRE');
INSERT INTO `lang_phrase` VALUES ('3463', '3', '6', 'title', '428', 'LEMAIRE', 'LEMAIRE');
INSERT INTO `lang_phrase` VALUES ('3464', '1', '6', 'title', '429', 'LÉON & HARPER', 'LÉON & HARPER');
INSERT INTO `lang_phrase` VALUES ('3465', '2', '6', 'title', '429', 'LÉON & HARPER', 'LÉON & HARPER');
INSERT INTO `lang_phrase` VALUES ('3466', '3', '6', 'title', '429', 'LÉON & HARPER', 'LÉON & HARPER');
INSERT INTO `lang_phrase` VALUES ('3467', '1', '6', 'title', '430', 'LES INVASIONS EPHÉMÈRES', 'LES INVASIONS EPHÉMÈRES');
INSERT INTO `lang_phrase` VALUES ('3468', '2', '6', 'title', '430', 'LES INVASIONS EPHÉMÈRES', 'LES INVASIONS EPHÉMÈRES');
INSERT INTO `lang_phrase` VALUES ('3469', '3', '6', 'title', '430', 'LES INVASIONS EPHÉMÈRES', 'LES INVASIONS EPHÉMÈRES');
INSERT INTO `lang_phrase` VALUES ('3470', '1', '6', 'title', '431', 'LES NEREIDES', 'LES NEREIDES');
INSERT INTO `lang_phrase` VALUES ('3471', '2', '6', 'title', '431', 'LES NEREIDES', 'LES NEREIDES');
INSERT INTO `lang_phrase` VALUES ('3472', '3', '6', 'title', '431', 'LES NEREIDES', 'LES NEREIDES');
INSERT INTO `lang_phrase` VALUES ('3473', '1', '6', 'title', '432', 'LEVI’S', 'LEVI’S');
INSERT INTO `lang_phrase` VALUES ('3474', '2', '6', 'title', '432', 'LEVI’S', 'LEVI’S');
INSERT INTO `lang_phrase` VALUES ('3475', '3', '6', 'title', '432', 'LEVI’S', 'LEVI’S');
INSERT INTO `lang_phrase` VALUES ('3476', '1', '6', 'title', '433', 'LILI GAUFRETTE', 'LILI GAUFRETTE');
INSERT INTO `lang_phrase` VALUES ('3477', '2', '6', 'title', '433', 'LILI GAUFRETTE', 'LILI GAUFRETTE');
INSERT INTO `lang_phrase` VALUES ('3478', '3', '6', 'title', '433', 'LILI GAUFRETTE', 'LILI GAUFRETTE');
INSERT INTO `lang_phrase` VALUES ('3479', '1', '6', 'title', '434', 'LIOU', 'LIOU');
INSERT INTO `lang_phrase` VALUES ('3480', '2', '6', 'title', '434', 'LIOU', 'LIOU');
INSERT INTO `lang_phrase` VALUES ('3481', '3', '6', 'title', '434', 'LIOU', 'LIOU');
INSERT INTO `lang_phrase` VALUES ('3482', '1', '6', 'title', '435', 'LIPAULT', 'LIPAULT');
INSERT INTO `lang_phrase` VALUES ('3483', '2', '6', 'title', '435', 'LIPAULT', 'LIPAULT');
INSERT INTO `lang_phrase` VALUES ('3484', '3', '6', 'title', '435', 'LIPAULT', 'LIPAULT');
INSERT INTO `lang_phrase` VALUES ('3485', '1', '6', 'title', '436', 'LISE CHARMEL', 'LISE CHARMEL');
INSERT INTO `lang_phrase` VALUES ('3486', '2', '6', 'title', '436', 'LISE CHARMEL', 'LISE CHARMEL');
INSERT INTO `lang_phrase` VALUES ('3487', '3', '6', 'title', '436', 'LISE CHARMEL', 'LISE CHARMEL');
INSERT INTO `lang_phrase` VALUES ('3488', '1', '6', 'title', '437', 'LIVIA', 'LIVIA');
INSERT INTO `lang_phrase` VALUES ('3489', '2', '6', 'title', '437', 'LIVIA', 'LIVIA');
INSERT INTO `lang_phrase` VALUES ('3490', '3', '6', 'title', '437', 'LIVIA', 'LIVIA');
INSERT INTO `lang_phrase` VALUES ('3491', '1', '6', 'title', '438', 'LOEWE', 'LOEWE');
INSERT INTO `lang_phrase` VALUES ('3492', '2', '6', 'title', '438', 'LOEWE', 'LOEWE');
INSERT INTO `lang_phrase` VALUES ('3493', '3', '6', 'title', '438', 'LOEWE', 'LOEWE');
INSERT INTO `lang_phrase` VALUES ('3494', '1', '6', 'title', '439', 'LOLË', 'LOLË');
INSERT INTO `lang_phrase` VALUES ('3495', '2', '6', 'title', '439', 'LOLË', 'LOLË');
INSERT INTO `lang_phrase` VALUES ('3496', '3', '6', 'title', '439', 'LOLË', 'LOLË');
INSERT INTO `lang_phrase` VALUES ('3497', '1', '6', 'title', '440', 'LOLITA', 'LOLITA');
INSERT INTO `lang_phrase` VALUES ('3498', '2', '6', 'title', '440', 'LOLITA', 'LOLITA');
INSERT INTO `lang_phrase` VALUES ('3499', '3', '6', 'title', '440', 'LOLITA', 'LOLITA');
INSERT INTO `lang_phrase` VALUES ('3500', '1', '6', 'title', '441', 'LEMPICKA', 'LEMPICKA');
INSERT INTO `lang_phrase` VALUES ('3501', '2', '6', 'title', '441', 'LEMPICKA', 'LEMPICKA');
INSERT INTO `lang_phrase` VALUES ('3502', '3', '6', 'title', '441', 'LEMPICKA', 'LEMPICKA');
INSERT INTO `lang_phrase` VALUES ('3503', '1', '6', 'title', '442', 'LONGCHAMP', 'LONGCHAMP');
INSERT INTO `lang_phrase` VALUES ('3504', '2', '6', 'title', '442', 'LONGCHAMP', 'LONGCHAMP');
INSERT INTO `lang_phrase` VALUES ('3505', '3', '6', 'title', '442', 'LONGCHAMP', 'LONGCHAMP');
INSERT INTO `lang_phrase` VALUES ('3506', '1', '6', 'title', '443', 'LONGCILS BONCZA', 'LONGCILS BONCZA');
INSERT INTO `lang_phrase` VALUES ('3507', '2', '6', 'title', '443', 'LONGCILS BONCZA', 'LONGCILS BONCZA');
INSERT INTO `lang_phrase` VALUES ('3508', '3', '6', 'title', '443', 'LONGCILS BONCZA', 'LONGCILS BONCZA');
INSERT INTO `lang_phrase` VALUES ('3509', '1', '6', 'title', '444', 'LONGINES', 'LONGINES');
INSERT INTO `lang_phrase` VALUES ('3510', '2', '6', 'title', '444', 'LONGINES', 'LONGINES');
INSERT INTO `lang_phrase` VALUES ('3511', '3', '6', 'title', '444', 'LONGINES', 'LONGINES');
INSERT INTO `lang_phrase` VALUES ('3512', '1', '6', 'title', '445', 'LORNA JANE', 'LORNA JANE');
INSERT INTO `lang_phrase` VALUES ('3513', '2', '6', 'title', '445', 'LORNA JANE', 'LORNA JANE');
INSERT INTO `lang_phrase` VALUES ('3514', '3', '6', 'title', '445', 'LORNA JANE', 'LORNA JANE');
INSERT INTO `lang_phrase` VALUES ('3515', '1', '6', 'title', '446', 'LOU', 'LOU');
INSERT INTO `lang_phrase` VALUES ('3516', '2', '6', 'title', '446', 'LOU', 'LOU');
INSERT INTO `lang_phrase` VALUES ('3517', '3', '6', 'title', '446', 'LOU', 'LOU');
INSERT INTO `lang_phrase` VALUES ('3518', '1', '6', 'title', '447', 'LOUIS PION', 'LOUIS PION');
INSERT INTO `lang_phrase` VALUES ('3519', '2', '6', 'title', '447', 'LOUIS PION', 'LOUIS PION');
INSERT INTO `lang_phrase` VALUES ('3520', '3', '6', 'title', '447', 'LOUIS PION', 'LOUIS PION');
INSERT INTO `lang_phrase` VALUES ('3521', '1', '6', 'title', '448', 'LOUIS QUATORZE', 'LOUIS QUATORZE');
INSERT INTO `lang_phrase` VALUES ('3522', '2', '6', 'title', '448', 'LOUIS QUATORZE', 'LOUIS QUATORZE');
INSERT INTO `lang_phrase` VALUES ('3523', '3', '6', 'title', '448', 'LOUIS QUATORZE', 'LOUIS QUATORZE');
INSERT INTO `lang_phrase` VALUES ('3524', '1', '6', 'title', '449', 'LOUIS VUITTON', 'LOUIS VUITTON');
INSERT INTO `lang_phrase` VALUES ('3525', '2', '6', 'title', '449', 'LOUIS VUITTON', 'LOUIS VUITTON');
INSERT INTO `lang_phrase` VALUES ('3526', '3', '6', 'title', '449', 'LOUIS VUITTON', 'LOUIS VUITTON');
INSERT INTO `lang_phrase` VALUES ('3527', '1', '6', 'title', '450', 'LOUIS VUITTON ACCESSOIRES', 'LOUIS VUITTON ACCESSOIRES');
INSERT INTO `lang_phrase` VALUES ('3528', '2', '6', 'title', '450', 'LOUIS VUITTON ACCESSOIRES', 'LOUIS VUITTON ACCESSOIRES');
INSERT INTO `lang_phrase` VALUES ('3529', '3', '6', 'title', '450', 'LOUIS VUITTON ACCESSOIRES', 'LOUIS VUITTON ACCESSOIRES');
INSERT INTO `lang_phrase` VALUES ('3530', '1', '6', 'title', '451', 'LOUNGEWEAR', 'LOUNGEWEAR');
INSERT INTO `lang_phrase` VALUES ('3531', '2', '6', 'title', '451', 'LOUNGEWEAR', 'LOUNGEWEAR');
INSERT INTO `lang_phrase` VALUES ('3532', '3', '6', 'title', '451', 'LOUNGEWEAR', 'LOUNGEWEAR');
INSERT INTO `lang_phrase` VALUES ('3533', '1', '6', 'title', '452', 'LOVE STORIES', 'LOVE STORIES');
INSERT INTO `lang_phrase` VALUES ('3534', '2', '6', 'title', '452', 'LOVE STORIES', 'LOVE STORIES');
INSERT INTO `lang_phrase` VALUES ('3535', '3', '6', 'title', '452', 'LOVE STORIES', 'LOVE STORIES');
INSERT INTO `lang_phrase` VALUES ('3536', '1', '6', 'title', '453', 'LUCY LOCKET', 'LUCY LOCKET');
INSERT INTO `lang_phrase` VALUES ('3537', '2', '6', 'title', '453', 'LUCY LOCKET', 'LUCY LOCKET');
INSERT INTO `lang_phrase` VALUES ('3538', '3', '6', 'title', '453', 'LUCY LOCKET', 'LUCY LOCKET');
INSERT INTO `lang_phrase` VALUES ('3539', '1', '6', 'title', '454', 'M DE MISSONI', 'M DE MISSONI');
INSERT INTO `lang_phrase` VALUES ('3540', '2', '6', 'title', '454', 'M DE MISSONI', 'M DE MISSONI');
INSERT INTO `lang_phrase` VALUES ('3541', '3', '6', 'title', '454', 'M DE MISSONI', 'M DE MISSONI');
INSERT INTO `lang_phrase` VALUES ('3542', '1', '6', 'title', '455', 'MAC', 'MAC');
INSERT INTO `lang_phrase` VALUES ('3543', '2', '6', 'title', '455', 'MAC', 'MAC');
INSERT INTO `lang_phrase` VALUES ('3544', '3', '6', 'title', '455', 'MAC', 'MAC');
INSERT INTO `lang_phrase` VALUES ('3545', '1', '6', 'title', '456', 'MAC LAREN', 'MAC LAREN');
INSERT INTO `lang_phrase` VALUES ('3546', '2', '6', 'title', '456', 'MAC LAREN', 'MAC LAREN');
INSERT INTO `lang_phrase` VALUES ('3547', '3', '6', 'title', '456', 'MAC LAREN', 'MAC LAREN');
INSERT INTO `lang_phrase` VALUES ('3548', '1', '6', 'title', '457', 'MAD ET LEN', 'MAD ET LEN');
INSERT INTO `lang_phrase` VALUES ('3549', '2', '6', 'title', '457', 'MAD ET LEN', 'MAD ET LEN');
INSERT INTO `lang_phrase` VALUES ('3550', '3', '6', 'title', '457', 'MAD ET LEN', 'MAD ET LEN');
INSERT INTO `lang_phrase` VALUES ('3551', '1', '6', 'title', '458', 'MADURA', 'MADURA');
INSERT INTO `lang_phrase` VALUES ('3552', '2', '6', 'title', '458', 'MADURA', 'MADURA');
INSERT INTO `lang_phrase` VALUES ('3553', '3', '6', 'title', '458', 'MADURA', 'MADURA');
INSERT INTO `lang_phrase` VALUES ('3554', '1', '6', 'title', '459', 'MAGIMIX', 'MAGIMIX');
INSERT INTO `lang_phrase` VALUES ('3555', '2', '6', 'title', '459', 'MAGIMIX', 'MAGIMIX');
INSERT INTO `lang_phrase` VALUES ('3556', '3', '6', 'title', '459', 'MAGIMIX', 'MAGIMIX');
INSERT INTO `lang_phrase` VALUES ('3557', '1', '6', 'title', '460', 'MAIDENFORM', 'MAIDENFORM');
INSERT INTO `lang_phrase` VALUES ('3558', '2', '6', 'title', '460', 'MAIDENFORM', 'MAIDENFORM');
INSERT INTO `lang_phrase` VALUES ('3559', '3', '6', 'title', '460', 'MAIDENFORM', 'MAIDENFORM');
INSERT INTO `lang_phrase` VALUES ('3560', '1', '6', 'title', '461', 'MAISON LEJABY COUTURE', 'MAISON LEJABY COUTURE');
INSERT INTO `lang_phrase` VALUES ('3561', '2', '6', 'title', '461', 'MAISON LEJABY COUTURE', 'MAISON LEJABY COUTURE');
INSERT INTO `lang_phrase` VALUES ('3562', '3', '6', 'title', '461', 'MAISON LEJABY COUTURE', 'MAISON LEJABY COUTURE');
INSERT INTO `lang_phrase` VALUES ('3563', '1', '6', 'title', '462', 'MAISON MARGIELA', 'MAISON MARGIELA');
INSERT INTO `lang_phrase` VALUES ('3564', '2', '6', 'title', '462', 'MAISON MARGIELA', 'MAISON MARGIELA');
INSERT INTO `lang_phrase` VALUES ('3565', '3', '6', 'title', '462', 'MAISON MARGIELA', 'MAISON MARGIELA');
INSERT INTO `lang_phrase` VALUES ('3566', '1', '6', 'title', '463', 'MAJE', 'MAJE');
INSERT INTO `lang_phrase` VALUES ('3567', '2', '6', 'title', '463', 'MAJE', 'MAJE');
INSERT INTO `lang_phrase` VALUES ('3568', '3', '6', 'title', '463', 'MAJE', 'MAJE');
INSERT INTO `lang_phrase` VALUES ('3569', '1', '6', 'title', '464', 'MAJORETTE', 'MAJORETTE');
INSERT INTO `lang_phrase` VALUES ('3570', '2', '6', 'title', '464', 'MAJORETTE', 'MAJORETTE');
INSERT INTO `lang_phrase` VALUES ('3571', '3', '6', 'title', '464', 'MAJORETTE', 'MAJORETTE');
INSERT INTO `lang_phrase` VALUES ('3572', '1', '6', 'title', '465', 'MALONGO', 'MALONGO');
INSERT INTO `lang_phrase` VALUES ('3573', '2', '6', 'title', '465', 'MALONGO', 'MALONGO');
INSERT INTO `lang_phrase` VALUES ('3574', '3', '6', 'title', '465', 'MALONGO', 'MALONGO');
INSERT INTO `lang_phrase` VALUES ('3575', '1', '6', 'title', '466', 'MANFIELD', 'MANFIELD');
INSERT INTO `lang_phrase` VALUES ('3576', '2', '6', 'title', '466', 'MANFIELD', 'MANFIELD');
INSERT INTO `lang_phrase` VALUES ('3577', '3', '6', 'title', '466', 'MANFIELD', 'MANFIELD');
INSERT INTO `lang_phrase` VALUES ('3578', '1', '6', 'title', '467', 'MANOUSH', 'MANOUSH');
INSERT INTO `lang_phrase` VALUES ('3579', '2', '6', 'title', '467', 'MANOUSH', 'MANOUSH');
INSERT INTO `lang_phrase` VALUES ('3580', '3', '6', 'title', '467', 'MANOUSH', 'MANOUSH');
INSERT INTO `lang_phrase` VALUES ('3581', '1', '6', 'title', '468', 'MARBELLA', 'MARBELLA');
INSERT INTO `lang_phrase` VALUES ('3582', '2', '6', 'title', '468', 'MARBELLA', 'MARBELLA');
INSERT INTO `lang_phrase` VALUES ('3583', '3', '6', 'title', '468', 'MARBELLA', 'MARBELLA');
INSERT INTO `lang_phrase` VALUES ('3584', '1', '6', 'title', '469', 'MARC BY MARC JACOBS', 'MARC BY MARC JACOBS');
INSERT INTO `lang_phrase` VALUES ('3585', '2', '6', 'title', '469', 'MARC BY MARC JACOBS', 'MARC BY MARC JACOBS');
INSERT INTO `lang_phrase` VALUES ('3586', '3', '6', 'title', '469', 'MARC BY MARC JACOBS', 'MARC BY MARC JACOBS');
INSERT INTO `lang_phrase` VALUES ('3587', '1', '6', 'title', '470', 'MARC JACOBS', 'MARC JACOBS');
INSERT INTO `lang_phrase` VALUES ('3588', '2', '6', 'title', '470', 'MARC JACOBS', 'MARC JACOBS');
INSERT INTO `lang_phrase` VALUES ('3589', '3', '6', 'title', '470', 'MARC JACOBS', 'MARC JACOBS');
INSERT INTO `lang_phrase` VALUES ('3590', '1', '6', 'title', '471', 'MARC LE BIHAN', 'MARC LE BIHAN');
INSERT INTO `lang_phrase` VALUES ('3591', '2', '6', 'title', '471', 'MARC LE BIHAN', 'MARC LE BIHAN');
INSERT INTO `lang_phrase` VALUES ('3592', '3', '6', 'title', '471', 'MARC LE BIHAN', 'MARC LE BIHAN');
INSERT INTO `lang_phrase` VALUES ('3593', '1', '6', 'title', '472', 'MARC O’ POLO', 'MARC O’ POLO');
INSERT INTO `lang_phrase` VALUES ('3594', '2', '6', 'title', '472', 'MARC O’ POLO', 'MARC O’ POLO');
INSERT INTO `lang_phrase` VALUES ('3595', '3', '6', 'title', '472', 'MARC O’ POLO', 'MARC O’ POLO');
INSERT INTO `lang_phrase` VALUES ('3596', '1', '6', 'title', '473', 'MARC ROZIER', 'MARC ROZIER');
INSERT INTO `lang_phrase` VALUES ('3597', '2', '6', 'title', '473', 'MARC ROZIER', 'MARC ROZIER');
INSERT INTO `lang_phrase` VALUES ('3598', '3', '6', 'title', '473', 'MARC ROZIER', 'MARC ROZIER');
INSERT INTO `lang_phrase` VALUES ('3599', '1', '6', 'title', '474', 'MARCELO BURLON', 'MARCELO BURLON');
INSERT INTO `lang_phrase` VALUES ('3600', '2', '6', 'title', '474', 'MARCELO BURLON', 'MARCELO BURLON');
INSERT INTO `lang_phrase` VALUES ('3601', '3', '6', 'title', '474', 'MARCELO BURLON', 'MARCELO BURLON');
INSERT INTO `lang_phrase` VALUES ('3602', '1', '6', 'title', '475', 'MARIAGE FRÈRES THÉS', 'MARIAGE FRÈRES THÉS');
INSERT INTO `lang_phrase` VALUES ('3603', '2', '6', 'title', '475', 'MARIAGE FRÈRES THÉS', 'MARIAGE FRÈRES THÉS');
INSERT INTO `lang_phrase` VALUES ('3604', '3', '6', 'title', '475', 'MARIAGE FRÈRES THÉS', 'MARIAGE FRÈRES THÉS');
INSERT INTO `lang_phrase` VALUES ('3605', '1', '6', 'title', '476', 'MARIE JO MARIE SIXTINE', 'MARIE JO MARIE SIXTINE');
INSERT INTO `lang_phrase` VALUES ('3606', '2', '6', 'title', '476', 'MARIE JO MARIE SIXTINE', 'MARIE JO MARIE SIXTINE');
INSERT INTO `lang_phrase` VALUES ('3607', '3', '6', 'title', '476', 'MARIE JO MARIE SIXTINE', 'MARIE JO MARIE SIXTINE');
INSERT INTO `lang_phrase` VALUES ('3608', '1', '6', 'title', '477', 'MARIMEKKO', 'MARIMEKKO');
INSERT INTO `lang_phrase` VALUES ('3609', '2', '6', 'title', '477', 'MARIMEKKO', 'MARIMEKKO');
INSERT INTO `lang_phrase` VALUES ('3610', '3', '6', 'title', '477', 'MARIMEKKO', 'MARIMEKKO');
INSERT INTO `lang_phrase` VALUES ('3611', '1', '6', 'title', '478', 'MARINA RINALDI', 'MARINA RINALDI');
INSERT INTO `lang_phrase` VALUES ('3612', '2', '6', 'title', '478', 'MARINA RINALDI', 'MARINA RINALDI');
INSERT INTO `lang_phrase` VALUES ('3613', '3', '6', 'title', '478', 'MARINA RINALDI', 'MARINA RINALDI');
INSERT INTO `lang_phrase` VALUES ('3614', '1', '6', 'title', '479', 'MARINER', 'MARINER');
INSERT INTO `lang_phrase` VALUES ('3615', '2', '6', 'title', '479', 'MARINER', 'MARINER');
INSERT INTO `lang_phrase` VALUES ('3616', '3', '6', 'title', '479', 'MARINER', 'MARINER');
INSERT INTO `lang_phrase` VALUES ('3617', '1', '6', 'title', '480', 'MARNI', 'MARNI');
INSERT INTO `lang_phrase` VALUES ('3618', '2', '6', 'title', '480', 'MARNI', 'MARNI');
INSERT INTO `lang_phrase` VALUES ('3619', '3', '6', 'title', '480', 'MARNI', 'MARNI');
INSERT INTO `lang_phrase` VALUES ('3620', '1', '6', 'title', '481', 'MASSIMO DUTTI', 'MASSIMO DUTTI');
INSERT INTO `lang_phrase` VALUES ('3621', '2', '6', 'title', '481', 'MASSIMO DUTTI', 'MASSIMO DUTTI');
INSERT INTO `lang_phrase` VALUES ('3622', '3', '6', 'title', '481', 'MASSIMO DUTTI', 'MASSIMO DUTTI');
INSERT INTO `lang_phrase` VALUES ('3623', '1', '6', 'title', '482', 'MATTEL FILLE', 'MATTEL FILLE');
INSERT INTO `lang_phrase` VALUES ('3624', '2', '6', 'title', '482', 'MATTEL FILLE', 'MATTEL FILLE');
INSERT INTO `lang_phrase` VALUES ('3625', '3', '6', 'title', '482', 'MATTEL FILLE', 'MATTEL FILLE');
INSERT INTO `lang_phrase` VALUES ('3626', '1', '6', 'title', '483', 'MATTEL JEUX DE SOCIÉTÉ', 'MATTEL JEUX DE SOCIÉTÉ');
INSERT INTO `lang_phrase` VALUES ('3627', '2', '6', 'title', '483', 'MATTEL JEUX DE SOCIÉTÉ', 'MATTEL JEUX DE SOCIÉTÉ');
INSERT INTO `lang_phrase` VALUES ('3628', '3', '6', 'title', '483', 'MATTEL JEUX DE SOCIÉTÉ', 'MATTEL JEUX DE SOCIÉTÉ');
INSERT INTO `lang_phrase` VALUES ('3629', '1', '6', 'title', '484', 'MAUVIEL', 'MAUVIEL');
INSERT INTO `lang_phrase` VALUES ('3630', '2', '6', 'title', '484', 'MAUVIEL', 'MAUVIEL');
INSERT INTO `lang_phrase` VALUES ('3631', '3', '6', 'title', '484', 'MAUVIEL', 'MAUVIEL');
INSERT INTO `lang_phrase` VALUES ('3632', '1', '6', 'title', '485', 'MAVALA', 'MAVALA');
INSERT INTO `lang_phrase` VALUES ('3633', '2', '6', 'title', '485', 'MAVALA', 'MAVALA');
INSERT INTO `lang_phrase` VALUES ('3634', '3', '6', 'title', '485', 'MAVALA', 'MAVALA');
INSERT INTO `lang_phrase` VALUES ('3635', '1', '6', 'title', '486', 'MAX MARA STUDIO', 'MAX MARA STUDIO');
INSERT INTO `lang_phrase` VALUES ('3636', '2', '6', 'title', '486', 'MAX MARA STUDIO', 'MAX MARA STUDIO');
INSERT INTO `lang_phrase` VALUES ('3637', '3', '6', 'title', '486', 'MAX MARA STUDIO', 'MAX MARA STUDIO');
INSERT INTO `lang_phrase` VALUES ('3638', '1', '6', 'title', '487', 'MAX MARA WEEKEND', 'MAX MARA WEEKEND');
INSERT INTO `lang_phrase` VALUES ('3639', '2', '6', 'title', '487', 'MAX MARA WEEKEND', 'MAX MARA WEEKEND');
INSERT INTO `lang_phrase` VALUES ('3640', '3', '6', 'title', '487', 'MAX MARA WEEKEND', 'MAX MARA WEEKEND');
INSERT INTO `lang_phrase` VALUES ('3641', '1', '6', 'title', '488', 'MAXIM’S', 'MAXIM’S');
INSERT INTO `lang_phrase` VALUES ('3642', '2', '6', 'title', '488', 'MAXIM’S', 'MAXIM’S');
INSERT INTO `lang_phrase` VALUES ('3643', '3', '6', 'title', '488', 'MAXIM’S', 'MAXIM’S');
INSERT INTO `lang_phrase` VALUES ('3644', '1', '6', 'title', '489', 'MC GREGOR', 'MC GREGOR');
INSERT INTO `lang_phrase` VALUES ('3645', '2', '6', 'title', '489', 'MC GREGOR', 'MC GREGOR');
INSERT INTO `lang_phrase` VALUES ('3646', '3', '6', 'title', '489', 'MC GREGOR', 'MC GREGOR');
INSERT INTO `lang_phrase` VALUES ('3647', '1', '6', 'title', '490', 'MCM', 'MCM');
INSERT INTO `lang_phrase` VALUES ('3648', '2', '6', 'title', '490', 'MCM', 'MCM');
INSERT INTO `lang_phrase` VALUES ('3649', '3', '6', 'title', '490', 'MCM', 'MCM');
INSERT INTO `lang_phrase` VALUES ('3650', '1', '6', 'title', '491', 'MCQ ALEXANDER MCQUEEN', 'MCQ ALEXANDER MCQUEEN');
INSERT INTO `lang_phrase` VALUES ('3651', '2', '6', 'title', '491', 'MCQ ALEXANDER MCQUEEN', 'MCQ ALEXANDER MCQUEEN');
INSERT INTO `lang_phrase` VALUES ('3652', '3', '6', 'title', '491', 'MCQ ALEXANDER MCQUEEN', 'MCQ ALEXANDER MCQUEEN');
INSERT INTO `lang_phrase` VALUES ('3653', '1', '6', 'title', '492', 'MCS', 'MCS');
INSERT INTO `lang_phrase` VALUES ('3654', '2', '6', 'title', '492', 'MCS', 'MCS');
INSERT INTO `lang_phrase` VALUES ('3655', '3', '6', 'title', '492', 'MCS', 'MCS');
INSERT INTO `lang_phrase` VALUES ('3656', '1', '6', 'title', '493', 'MECCANO', 'MECCANO');
INSERT INTO `lang_phrase` VALUES ('3657', '2', '6', 'title', '493', 'MECCANO', 'MECCANO');
INSERT INTO `lang_phrase` VALUES ('3658', '3', '6', 'title', '493', 'MECCANO', 'MECCANO');
INSERT INTO `lang_phrase` VALUES ('3659', '1', '6', 'title', '494', 'MELISSA ODABASH', 'MELISSA ODABASH');
INSERT INTO `lang_phrase` VALUES ('3660', '2', '6', 'title', '494', 'MELISSA ODABASH', 'MELISSA ODABASH');
INSERT INTO `lang_phrase` VALUES ('3661', '3', '6', 'title', '494', 'MELISSA ODABASH', 'MELISSA ODABASH');
INSERT INTO `lang_phrase` VALUES ('3662', '1', '6', 'title', '495', 'MELLOW YELLOW', 'MELLOW YELLOW');
INSERT INTO `lang_phrase` VALUES ('3663', '2', '6', 'title', '495', 'MELLOW YELLOW', 'MELLOW YELLOW');
INSERT INTO `lang_phrase` VALUES ('3664', '3', '6', 'title', '495', 'MELLOW YELLOW', 'MELLOW YELLOW');
INSERT INTO `lang_phrase` VALUES ('3665', '1', '6', 'title', '496', 'MEMO', 'MEMO');
INSERT INTO `lang_phrase` VALUES ('3666', '2', '6', 'title', '496', 'MEMO', 'MEMO');
INSERT INTO `lang_phrase` VALUES ('3667', '3', '6', 'title', '496', 'MEMO', 'MEMO');
INSERT INTO `lang_phrase` VALUES ('3668', '1', '6', 'title', '497', 'MENU', 'MENU');
INSERT INTO `lang_phrase` VALUES ('3669', '2', '6', 'title', '497', 'MENU', 'MENU');
INSERT INTO `lang_phrase` VALUES ('3670', '3', '6', 'title', '497', 'MENU', 'MENU');
INSERT INTO `lang_phrase` VALUES ('3671', '1', '6', 'title', '498', 'MEPHISTO', 'MEPHISTO');
INSERT INTO `lang_phrase` VALUES ('3672', '2', '6', 'title', '498', 'MEPHISTO', 'MEPHISTO');
INSERT INTO `lang_phrase` VALUES ('3673', '3', '6', 'title', '498', 'MEPHISTO', 'MEPHISTO');
INSERT INTO `lang_phrase` VALUES ('3674', '1', '6', 'title', '499', 'MESSIKA', 'MESSIKA');
INSERT INTO `lang_phrase` VALUES ('3675', '2', '6', 'title', '499', 'MESSIKA', 'MESSIKA');
INSERT INTO `lang_phrase` VALUES ('3676', '3', '6', 'title', '499', 'MESSIKA', 'MESSIKA');
INSERT INTO `lang_phrase` VALUES ('3677', '1', '6', 'title', '500', 'MEXICANA', 'MEXICANA');
INSERT INTO `lang_phrase` VALUES ('3678', '2', '6', 'title', '500', 'MEXICANA', 'MEXICANA');
INSERT INTO `lang_phrase` VALUES ('3679', '3', '6', 'title', '500', 'MEXICANA', 'MEXICANA');
INSERT INTO `lang_phrase` VALUES ('3680', '1', '6', 'title', '501', 'MICHAEL KORS', 'MICHAEL KORS');
INSERT INTO `lang_phrase` VALUES ('3681', '2', '6', 'title', '501', 'MICHAEL KORS', 'MICHAEL KORS');
INSERT INTO `lang_phrase` VALUES ('3682', '3', '6', 'title', '501', 'MICHAEL KORS', 'MICHAEL KORS');
INSERT INTO `lang_phrase` VALUES ('3683', '1', '6', 'title', '502', 'MIDO', 'MIDO');
INSERT INTO `lang_phrase` VALUES ('3684', '2', '6', 'title', '502', 'MIDO', 'MIDO');
INSERT INTO `lang_phrase` VALUES ('3685', '3', '6', 'title', '502', 'MIDO', 'MIDO');
INSERT INTO `lang_phrase` VALUES ('3686', '1', '6', 'title', '503', 'MIGNON', 'MIGNON');
INSERT INTO `lang_phrase` VALUES ('3687', '2', '6', 'title', '503', 'MIGNON', 'MIGNON');
INSERT INTO `lang_phrase` VALUES ('3688', '3', '6', 'title', '503', 'MIGNON', 'MIGNON');
INSERT INTO `lang_phrase` VALUES ('3689', '1', '6', 'title', '504', 'MILLEFIORI', 'MILLEFIORI');
INSERT INTO `lang_phrase` VALUES ('3690', '2', '6', 'title', '504', 'MILLEFIORI', 'MILLEFIORI');
INSERT INTO `lang_phrase` VALUES ('3691', '3', '6', 'title', '504', 'MILLEFIORI', 'MILLEFIORI');
INSERT INTO `lang_phrase` VALUES ('3692', '1', '6', 'title', '505', 'MIMISOL', 'MIMISOL');
INSERT INTO `lang_phrase` VALUES ('3693', '2', '6', 'title', '505', 'MIMISOL', 'MIMISOL');
INSERT INTO `lang_phrase` VALUES ('3694', '3', '6', 'title', '505', 'MIMISOL', 'MIMISOL');
INSERT INTO `lang_phrase` VALUES ('3695', '1', '6', 'title', '506', 'MINELLI', 'MINELLI');
INSERT INTO `lang_phrase` VALUES ('3696', '2', '6', 'title', '506', 'MINELLI', 'MINELLI');
INSERT INTO `lang_phrase` VALUES ('3697', '3', '6', 'title', '506', 'MINELLI', 'MINELLI');
INSERT INTO `lang_phrase` VALUES ('3698', '1', '6', 'title', '507', 'MISE AU GREEN', 'MISE AU GREEN');
INSERT INTO `lang_phrase` VALUES ('3699', '2', '6', 'title', '507', 'MISE AU GREEN', 'MISE AU GREEN');
INSERT INTO `lang_phrase` VALUES ('3700', '3', '6', 'title', '507', 'MISE AU GREEN', 'MISE AU GREEN');
INSERT INTO `lang_phrase` VALUES ('3701', '1', '6', 'title', '508', 'MISS ETOILE', 'MISS ETOILE');
INSERT INTO `lang_phrase` VALUES ('3702', '2', '6', 'title', '508', 'MISS ETOILE', 'MISS ETOILE');
INSERT INTO `lang_phrase` VALUES ('3703', '3', '6', 'title', '508', 'MISS ETOILE', 'MISS ETOILE');
INSERT INTO `lang_phrase` VALUES ('3704', '1', '6', 'title', '509', 'MIU MIU', 'MIU MIU');
INSERT INTO `lang_phrase` VALUES ('3705', '2', '6', 'title', '509', 'MIU MIU', 'MIU MIU');
INSERT INTO `lang_phrase` VALUES ('3706', '3', '6', 'title', '509', 'MIU MIU', 'MIU MIU');
INSERT INTO `lang_phrase` VALUES ('3707', '1', '6', 'title', '510', 'MO&CO', 'MO&CO');
INSERT INTO `lang_phrase` VALUES ('3708', '2', '6', 'title', '510', 'MO&CO', 'MO&CO');
INSERT INTO `lang_phrase` VALUES ('3709', '3', '6', 'title', '510', 'MO&CO', 'MO&CO');
INSERT INTO `lang_phrase` VALUES ('3710', '1', '6', 'title', '511', 'MO&CO EDITION', 'MO&CO EDITION');
INSERT INTO `lang_phrase` VALUES ('3711', '2', '6', 'title', '511', 'MO&CO EDITION', 'MO&CO EDITION');
INSERT INTO `lang_phrase` VALUES ('3712', '3', '6', 'title', '511', 'MO&CO EDITION', 'MO&CO EDITION');
INSERT INTO `lang_phrase` VALUES ('3713', '1', '6', 'title', '512', 'MODELCO', 'MODELCO');
INSERT INTO `lang_phrase` VALUES ('3714', '2', '6', 'title', '512', 'MODELCO', 'MODELCO');
INSERT INTO `lang_phrase` VALUES ('3715', '3', '6', 'title', '512', 'MODELCO', 'MODELCO');
INSERT INTO `lang_phrase` VALUES ('3716', '1', '6', 'title', '513', 'MOIS MONT', 'MOIS MONT');
INSERT INTO `lang_phrase` VALUES ('3717', '2', '6', 'title', '513', 'MOIS MONT', 'MOIS MONT');
INSERT INTO `lang_phrase` VALUES ('3718', '3', '6', 'title', '513', 'MOIS MONT', 'MOIS MONT');
INSERT INTO `lang_phrase` VALUES ('3719', '1', '6', 'title', '514', 'MOLESKINE', 'MOLESKINE');
INSERT INTO `lang_phrase` VALUES ('3720', '2', '6', 'title', '514', 'MOLESKINE', 'MOLESKINE');
INSERT INTO `lang_phrase` VALUES ('3721', '3', '6', 'title', '514', 'MOLESKINE', 'MOLESKINE');
INSERT INTO `lang_phrase` VALUES ('3722', '1', '6', 'title', '515', 'MOLINARD', 'MOLINARD');
INSERT INTO `lang_phrase` VALUES ('3723', '2', '6', 'title', '515', 'MOLINARD', 'MOLINARD');
INSERT INTO `lang_phrase` VALUES ('3724', '3', '6', 'title', '515', 'MOLINARD', 'MOLINARD');
INSERT INTO `lang_phrase` VALUES ('3725', '1', '6', 'title', '516', 'MOLLY BRACKEN', 'MOLLY BRACKEN');
INSERT INTO `lang_phrase` VALUES ('3726', '2', '6', 'title', '516', 'MOLLY BRACKEN', 'MOLLY BRACKEN');
INSERT INTO `lang_phrase` VALUES ('3727', '3', '6', 'title', '516', 'MOLLY BRACKEN', 'MOLLY BRACKEN');
INSERT INTO `lang_phrase` VALUES ('3728', '1', '6', 'title', '517', 'MONBENTO BOX', 'MONBENTO BOX');
INSERT INTO `lang_phrase` VALUES ('3729', '2', '6', 'title', '517', 'MONBENTO BOX', 'MONBENTO BOX');
INSERT INTO `lang_phrase` VALUES ('3730', '3', '6', 'title', '517', 'MONBENTO BOX', 'MONBENTO BOX');
INSERT INTO `lang_phrase` VALUES ('3731', '1', '6', 'title', '518', 'MONCLER', 'MONCLER');
INSERT INTO `lang_phrase` VALUES ('3732', '2', '6', 'title', '518', 'MONCLER', 'MONCLER');
INSERT INTO `lang_phrase` VALUES ('3733', '3', '6', 'title', '518', 'MONCLER', 'MONCLER');
INSERT INTO `lang_phrase` VALUES ('3734', '1', '6', 'title', '519', 'MONNALISA', 'MONNALISA');
INSERT INTO `lang_phrase` VALUES ('3735', '2', '6', 'title', '519', 'MONNALISA', 'MONNALISA');
INSERT INTO `lang_phrase` VALUES ('3736', '3', '6', 'title', '519', 'MONNALISA', 'MONNALISA');
INSERT INTO `lang_phrase` VALUES ('3737', '1', '6', 'title', '520', 'MONSTER HIGH', 'MONSTER HIGH');
INSERT INTO `lang_phrase` VALUES ('3738', '2', '6', 'title', '520', 'MONSTER HIGH', 'MONSTER HIGH');
INSERT INTO `lang_phrase` VALUES ('3739', '3', '6', 'title', '520', 'MONSTER HIGH', 'MONSTER HIGH');
INSERT INTO `lang_phrase` VALUES ('3740', '1', '6', 'title', '521', 'MONT BLANC', 'MONT BLANC');
INSERT INTO `lang_phrase` VALUES ('3741', '2', '6', 'title', '521', 'MONT BLANC', 'MONT BLANC');
INSERT INTO `lang_phrase` VALUES ('3742', '3', '6', 'title', '521', 'MONT BLANC', 'MONT BLANC');
INSERT INTO `lang_phrase` VALUES ('3743', '1', '6', 'title', '522', 'MONTAGUT', 'MONTAGUT');
INSERT INTO `lang_phrase` VALUES ('3744', '2', '6', 'title', '522', 'MONTAGUT', 'MONTAGUT');
INSERT INTO `lang_phrase` VALUES ('3745', '3', '6', 'title', '522', 'MONTAGUT', 'MONTAGUT');
INSERT INTO `lang_phrase` VALUES ('3746', '1', '6', 'title', '523', 'MONTBLANC', 'MONTBLANC');
INSERT INTO `lang_phrase` VALUES ('3747', '2', '6', 'title', '523', 'MONTBLANC', 'MONTBLANC');
INSERT INTO `lang_phrase` VALUES ('3748', '3', '6', 'title', '523', 'MONTBLANC', 'MONTBLANC');
INSERT INTO `lang_phrase` VALUES ('3749', '1', '6', 'title', '524', 'MORGAN', 'MORGAN');
INSERT INTO `lang_phrase` VALUES ('3750', '2', '6', 'title', '524', 'MORGAN', 'MORGAN');
INSERT INTO `lang_phrase` VALUES ('3751', '3', '6', 'title', '524', 'MORGAN', 'MORGAN');
INSERT INTO `lang_phrase` VALUES ('3752', '1', '6', 'title', '525', 'MOULIN ROTY', 'MOULIN ROTY');
INSERT INTO `lang_phrase` VALUES ('3753', '2', '6', 'title', '525', 'MOULIN ROTY', 'MOULIN ROTY');
INSERT INTO `lang_phrase` VALUES ('3754', '3', '6', 'title', '525', 'MOULIN ROTY', 'MOULIN ROTY');
INSERT INTO `lang_phrase` VALUES ('3755', '1', '6', 'title', '526', 'MOYNAT', 'MOYNAT');
INSERT INTO `lang_phrase` VALUES ('3756', '2', '6', 'title', '526', 'MOYNAT', 'MOYNAT');
INSERT INTO `lang_phrase` VALUES ('3757', '3', '6', 'title', '526', 'MOYNAT', 'MOYNAT');
INSERT INTO `lang_phrase` VALUES ('3758', '1', '6', 'title', '527', 'MSGM', 'MSGM');
INSERT INTO `lang_phrase` VALUES ('3759', '2', '6', 'title', '527', 'MSGM', 'MSGM');
INSERT INTO `lang_phrase` VALUES ('3760', '3', '6', 'title', '527', 'MSGM', 'MSGM');
INSERT INTO `lang_phrase` VALUES ('3761', '1', '6', 'title', '528', 'MULBERRY', 'MULBERRY');
INSERT INTO `lang_phrase` VALUES ('3762', '2', '6', 'title', '528', 'MULBERRY', 'MULBERRY');
INSERT INTO `lang_phrase` VALUES ('3763', '3', '6', 'title', '528', 'MULBERRY', 'MULBERRY');
INSERT INTO `lang_phrase` VALUES ('3764', '1', '6', 'title', '529', 'MULTIMARQUES BAGAGES', 'MULTIMARQUES BAGAGES');
INSERT INTO `lang_phrase` VALUES ('3765', '2', '6', 'title', '529', 'MULTIMARQUES BAGAGES', 'MULTIMARQUES BAGAGES');
INSERT INTO `lang_phrase` VALUES ('3766', '3', '6', 'title', '529', 'MULTIMARQUES BAGAGES', 'MULTIMARQUES BAGAGES');
INSERT INTO `lang_phrase` VALUES ('3767', '1', '6', 'title', '530', 'MY JEMMA', 'MY JEMMA');
INSERT INTO `lang_phrase` VALUES ('3768', '2', '6', 'title', '530', 'MY JEMMA', 'MY JEMMA');
INSERT INTO `lang_phrase` VALUES ('3769', '3', '6', 'title', '530', 'MY JEMMA', 'MY JEMMA');
INSERT INTO `lang_phrase` VALUES ('3770', '1', '6', 'title', '531', 'NAF NAF', 'NAF NAF');
INSERT INTO `lang_phrase` VALUES ('3771', '2', '6', 'title', '531', 'NAF NAF', 'NAF NAF');
INSERT INTO `lang_phrase` VALUES ('3772', '3', '6', 'title', '531', 'NAF NAF', 'NAF NAF');
INSERT INTO `lang_phrase` VALUES ('3773', '1', '6', 'title', '532', 'NAILMATIC', 'NAILMATIC');
INSERT INTO `lang_phrase` VALUES ('3774', '2', '6', 'title', '532', 'NAILMATIC', 'NAILMATIC');
INSERT INTO `lang_phrase` VALUES ('3775', '3', '6', 'title', '532', 'NAILMATIC', 'NAILMATIC');
INSERT INTO `lang_phrase` VALUES ('3776', '1', '6', 'title', '533', 'NAPAPIJRI', 'NAPAPIJRI');
INSERT INTO `lang_phrase` VALUES ('3777', '2', '6', 'title', '533', 'NAPAPIJRI', 'NAPAPIJRI');
INSERT INTO `lang_phrase` VALUES ('3778', '3', '6', 'title', '533', 'NAPAPIJRI', 'NAPAPIJRI');
INSERT INTO `lang_phrase` VALUES ('3779', '1', '6', 'title', '534', 'NARCISSO RODRIGUEZ', 'NARCISSO RODRIGUEZ');
INSERT INTO `lang_phrase` VALUES ('3780', '2', '6', 'title', '534', 'NARCISSO RODRIGUEZ', 'NARCISSO RODRIGUEZ');
INSERT INTO `lang_phrase` VALUES ('3781', '3', '6', 'title', '534', 'NARCISSO RODRIGUEZ', 'NARCISSO RODRIGUEZ');
INSERT INTO `lang_phrase` VALUES ('3782', '1', '6', 'title', '535', 'NARS COSMECTICS', 'NARS COSMECTICS');
INSERT INTO `lang_phrase` VALUES ('3783', '2', '6', 'title', '535', 'NARS COSMECTICS', 'NARS COSMECTICS');
INSERT INTO `lang_phrase` VALUES ('3784', '3', '6', 'title', '535', 'NARS COSMECTICS', 'NARS COSMECTICS');
INSERT INTO `lang_phrase` VALUES ('3785', '1', '6', 'title', '536', 'NAT & NIN', 'NAT & NIN');
INSERT INTO `lang_phrase` VALUES ('3786', '2', '6', 'title', '536', 'NAT & NIN', 'NAT & NIN');
INSERT INTO `lang_phrase` VALUES ('3787', '3', '6', 'title', '536', 'NAT & NIN', 'NAT & NIN');
INSERT INTO `lang_phrase` VALUES ('3788', '1', '6', 'title', '537', 'NERO PERLA', 'NERO PERLA');
INSERT INTO `lang_phrase` VALUES ('3789', '2', '6', 'title', '537', 'NERO PERLA', 'NERO PERLA');
INSERT INTO `lang_phrase` VALUES ('3790', '3', '6', 'title', '537', 'NERO PERLA', 'NERO PERLA');
INSERT INTO `lang_phrase` VALUES ('3791', '1', '6', 'title', '538', 'NESPRESSO', 'NESPRESSO');
INSERT INTO `lang_phrase` VALUES ('3792', '2', '6', 'title', '538', 'NESPRESSO', 'NESPRESSO');
INSERT INTO `lang_phrase` VALUES ('3793', '3', '6', 'title', '538', 'NESPRESSO', 'NESPRESSO');
INSERT INTO `lang_phrase` VALUES ('3794', '1', '6', 'title', '539', 'NEW BALANCE', 'NEW BALANCE');
INSERT INTO `lang_phrase` VALUES ('3795', '2', '6', 'title', '539', 'NEW BALANCE', 'NEW BALANCE');
INSERT INTO `lang_phrase` VALUES ('3796', '3', '6', 'title', '539', 'NEW BALANCE', 'NEW BALANCE');
INSERT INTO `lang_phrase` VALUES ('3797', '1', '6', 'title', '540', 'NICHOLAS KIRKWOOD', 'NICHOLAS KIRKWOOD');
INSERT INTO `lang_phrase` VALUES ('3798', '2', '6', 'title', '540', 'NICHOLAS KIRKWOOD', 'NICHOLAS KIRKWOOD');
INSERT INTO `lang_phrase` VALUES ('3799', '3', '6', 'title', '540', 'NICHOLAS KIRKWOOD', 'NICHOLAS KIRKWOOD');
INSERT INTO `lang_phrase` VALUES ('3800', '1', '6', 'title', '541', 'NIKE', 'NIKE');
INSERT INTO `lang_phrase` VALUES ('3801', '2', '6', 'title', '541', 'NIKE', 'NIKE');
INSERT INTO `lang_phrase` VALUES ('3802', '3', '6', 'title', '541', 'NIKE', 'NIKE');
INSERT INTO `lang_phrase` VALUES ('3803', '1', '6', 'title', '542', 'NINA RICCI', 'NINA RICCI');
INSERT INTO `lang_phrase` VALUES ('3804', '2', '6', 'title', '542', 'NINA RICCI', 'NINA RICCI');
INSERT INTO `lang_phrase` VALUES ('3805', '3', '6', 'title', '542', 'NINA RICCI', 'NINA RICCI');
INSERT INTO `lang_phrase` VALUES ('3806', '1', '6', 'title', '543', 'NIXON', 'NIXON');
INSERT INTO `lang_phrase` VALUES ('3807', '2', '6', 'title', '543', 'NIXON', 'NIXON');
INSERT INTO `lang_phrase` VALUES ('3808', '3', '6', 'title', '543', 'NIXON', 'NIXON');
INSERT INTO `lang_phrase` VALUES ('3809', '1', '6', 'title', '544', 'NORTH FACE', 'NORTH FACE');
INSERT INTO `lang_phrase` VALUES ('3810', '2', '6', 'title', '544', 'NORTH FACE', 'NORTH FACE');
INSERT INTO `lang_phrase` VALUES ('3811', '3', '6', 'title', '544', 'NORTH FACE', 'NORTH FACE');
INSERT INTO `lang_phrase` VALUES ('3812', '1', '6', 'title', '545', 'O’FÉE', 'O’FÉE');
INSERT INTO `lang_phrase` VALUES ('3813', '2', '6', 'title', '545', 'O’FÉE', 'O’FÉE');
INSERT INTO `lang_phrase` VALUES ('3814', '3', '6', 'title', '545', 'O’FÉE', 'O’FÉE');
INSERT INTO `lang_phrase` VALUES ('3815', '1', '6', 'title', '546', 'O’NEILL', 'O’NEILL');
INSERT INTO `lang_phrase` VALUES ('3816', '2', '6', 'title', '546', 'O’NEILL', 'O’NEILL');
INSERT INTO `lang_phrase` VALUES ('3817', '3', '6', 'title', '546', 'O’NEILL', 'O’NEILL');
INSERT INTO `lang_phrase` VALUES ('3818', '1', '6', 'title', '547', 'OAKWOOD', 'OAKWOOD');
INSERT INTO `lang_phrase` VALUES ('3819', '2', '6', 'title', '547', 'OAKWOOD', 'OAKWOOD');
INSERT INTO `lang_phrase` VALUES ('3820', '3', '6', 'title', '547', 'OAKWOOD', 'OAKWOOD');
INSERT INTO `lang_phrase` VALUES ('3821', '1', '6', 'title', '548', 'OFF WHITE', 'OFF WHITE');
INSERT INTO `lang_phrase` VALUES ('3822', '2', '6', 'title', '548', 'OFF WHITE', 'OFF WHITE');
INSERT INTO `lang_phrase` VALUES ('3823', '3', '6', 'title', '548', 'OFF WHITE', 'OFF WHITE');
INSERT INTO `lang_phrase` VALUES ('3824', '1', '6', 'title', '549', 'OLAF BENZ', 'OLAF BENZ');
INSERT INTO `lang_phrase` VALUES ('3825', '2', '6', 'title', '549', 'OLAF BENZ', 'OLAF BENZ');
INSERT INTO `lang_phrase` VALUES ('3826', '3', '6', 'title', '549', 'OLAF BENZ', 'OLAF BENZ');
INSERT INTO `lang_phrase` VALUES ('3827', '1', '6', 'title', '550', 'OLIVIER DESFORGES', 'OLIVIER DESFORGES');
INSERT INTO `lang_phrase` VALUES ('3828', '2', '6', 'title', '550', 'OLIVIER DESFORGES', 'OLIVIER DESFORGES');
INSERT INTO `lang_phrase` VALUES ('3829', '3', '6', 'title', '550', 'OLIVIER DESFORGES', 'OLIVIER DESFORGES');
INSERT INTO `lang_phrase` VALUES ('3830', '1', '6', 'title', '551', 'OMEGA', 'OMEGA');
INSERT INTO `lang_phrase` VALUES ('3831', '2', '6', 'title', '551', 'OMEGA', 'OMEGA');
INSERT INTO `lang_phrase` VALUES ('3832', '3', '6', 'title', '551', 'OMEGA', 'OMEGA');
INSERT INTO `lang_phrase` VALUES ('3833', '1', '6', 'title', '552', 'ONE STEP', 'ONE STEP');
INSERT INTO `lang_phrase` VALUES ('3834', '2', '6', 'title', '552', 'ONE STEP', 'ONE STEP');
INSERT INTO `lang_phrase` VALUES ('3835', '3', '6', 'title', '552', 'ONE STEP', 'ONE STEP');
INSERT INTO `lang_phrase` VALUES ('3836', '1', '6', 'title', '553', 'OREST', 'OREST');
INSERT INTO `lang_phrase` VALUES ('3837', '2', '6', 'title', '553', 'OREST', 'OREST');
INSERT INTO `lang_phrase` VALUES ('3838', '3', '6', 'title', '553', 'OREST', 'OREST');
INSERT INTO `lang_phrase` VALUES ('3839', '1', '6', 'title', '554', 'ORIGINAL PENGUIN', 'ORIGINAL PENGUIN');
INSERT INTO `lang_phrase` VALUES ('3840', '2', '6', 'title', '554', 'ORIGINAL PENGUIN', 'ORIGINAL PENGUIN');
INSERT INTO `lang_phrase` VALUES ('3841', '3', '6', 'title', '554', 'ORIGINAL PENGUIN', 'ORIGINAL PENGUIN');
INSERT INTO `lang_phrase` VALUES ('3842', '1', '6', 'title', '555', 'ORIS', 'ORIS');
INSERT INTO `lang_phrase` VALUES ('3843', '2', '6', 'title', '555', 'ORIS', 'ORIS');
INSERT INTO `lang_phrase` VALUES ('3844', '3', '6', 'title', '555', 'ORIS', 'ORIS');
INSERT INTO `lang_phrase` VALUES ('3845', '1', '6', 'title', '556', 'OVALE', 'OVALE');
INSERT INTO `lang_phrase` VALUES ('3846', '2', '6', 'title', '556', 'OVALE', 'OVALE');
INSERT INTO `lang_phrase` VALUES ('3847', '3', '6', 'title', '556', 'OVALE', 'OVALE');
INSERT INTO `lang_phrase` VALUES ('3848', '1', '6', 'title', '557', 'OYSHO', 'OYSHO');
INSERT INTO `lang_phrase` VALUES ('3849', '2', '6', 'title', '557', 'OYSHO', 'OYSHO');
INSERT INTO `lang_phrase` VALUES ('3850', '3', '6', 'title', '557', 'OYSHO', 'OYSHO');
INSERT INTO `lang_phrase` VALUES ('3851', '1', '6', 'title', '558', 'PABLO', 'PABLO');
INSERT INTO `lang_phrase` VALUES ('3852', '2', '6', 'title', '558', 'PABLO', 'PABLO');
INSERT INTO `lang_phrase` VALUES ('3853', '3', '6', 'title', '558', 'PABLO', 'PABLO');
INSERT INTO `lang_phrase` VALUES ('3854', '1', '6', 'title', '559', 'PACO RABANNE', 'PACO RABANNE');
INSERT INTO `lang_phrase` VALUES ('3855', '2', '6', 'title', '559', 'PACO RABANNE', 'PACO RABANNE');
INSERT INTO `lang_phrase` VALUES ('3856', '3', '6', 'title', '559', 'PACO RABANNE', 'PACO RABANNE');
INSERT INTO `lang_phrase` VALUES ('3857', '1', '6', 'title', '560', 'PAIN DE SUCRE', 'PAIN DE SUCRE');
INSERT INTO `lang_phrase` VALUES ('3858', '2', '6', 'title', '560', 'PAIN DE SUCRE', 'PAIN DE SUCRE');
INSERT INTO `lang_phrase` VALUES ('3859', '3', '6', 'title', '560', 'PAIN DE SUCRE', 'PAIN DE SUCRE');
INSERT INTO `lang_phrase` VALUES ('3860', '1', '6', 'title', '561', 'PAL ZILERI', 'PAL ZILERI');
INSERT INTO `lang_phrase` VALUES ('3861', '2', '6', 'title', '561', 'PAL ZILERI', 'PAL ZILERI');
INSERT INTO `lang_phrase` VALUES ('3862', '3', '6', 'title', '561', 'PAL ZILERI', 'PAL ZILERI');
INSERT INTO `lang_phrase` VALUES ('3863', '1', '6', 'title', '562', 'PALADINI', 'PALADINI');
INSERT INTO `lang_phrase` VALUES ('3864', '2', '6', 'title', '562', 'PALADINI', 'PALADINI');
INSERT INTO `lang_phrase` VALUES ('3865', '3', '6', 'title', '562', 'PALADINI', 'PALADINI');
INSERT INTO `lang_phrase` VALUES ('3866', '1', '6', 'title', '563', 'PALLADIUM', 'PALLADIUM');
INSERT INTO `lang_phrase` VALUES ('3867', '2', '6', 'title', '563', 'PALLADIUM', 'PALLADIUM');
INSERT INTO `lang_phrase` VALUES ('3868', '3', '6', 'title', '563', 'PALLADIUM', 'PALLADIUM');
INSERT INTO `lang_phrase` VALUES ('3869', '1', '6', 'title', '564', 'PANDORA', 'PANDORA');
INSERT INTO `lang_phrase` VALUES ('3870', '2', '6', 'title', '564', 'PANDORA', 'PANDORA');
INSERT INTO `lang_phrase` VALUES ('3871', '3', '6', 'title', '564', 'PANDORA', 'PANDORA');
INSERT INTO `lang_phrase` VALUES ('3872', '1', '6', 'title', '565', 'PANERAÏ', 'PANERAÏ');
INSERT INTO `lang_phrase` VALUES ('3873', '2', '6', 'title', '565', 'PANERAÏ', 'PANERAÏ');
INSERT INTO `lang_phrase` VALUES ('3874', '3', '6', 'title', '565', 'PANERAÏ', 'PANERAÏ');
INSERT INTO `lang_phrase` VALUES ('3875', '1', '6', 'title', '566', 'PAPERCHASE', 'PAPERCHASE');
INSERT INTO `lang_phrase` VALUES ('3876', '2', '6', 'title', '566', 'PAPERCHASE', 'PAPERCHASE');
INSERT INTO `lang_phrase` VALUES ('3877', '3', '6', 'title', '566', 'PAPERCHASE', 'PAPERCHASE');
INSERT INTO `lang_phrase` VALUES ('3878', '1', '6', 'title', '567', 'PAPO', 'PAPO');
INSERT INTO `lang_phrase` VALUES ('3879', '2', '6', 'title', '567', 'PAPO', 'PAPO');
INSERT INTO `lang_phrase` VALUES ('3880', '3', '6', 'title', '567', 'PAPO', 'PAPO');
INSERT INTO `lang_phrase` VALUES ('3881', '1', '6', 'title', '568', 'PARAJUMPERS', 'PARAJUMPERS');
INSERT INTO `lang_phrase` VALUES ('3882', '2', '6', 'title', '568', 'PARAJUMPERS', 'PARAJUMPERS');
INSERT INTO `lang_phrase` VALUES ('3883', '3', '6', 'title', '568', 'PARAJUMPERS', 'PARAJUMPERS');
INSERT INTO `lang_phrase` VALUES ('3884', '1', '6', 'title', '569', 'PARALLÈLE', 'PARALLÈLE');
INSERT INTO `lang_phrase` VALUES ('3885', '2', '6', 'title', '569', 'PARALLÈLE', 'PARALLÈLE');
INSERT INTO `lang_phrase` VALUES ('3886', '3', '6', 'title', '569', 'PARALLÈLE', 'PARALLÈLE');
INSERT INTO `lang_phrase` VALUES ('3887', '1', '6', 'title', '570', 'PARIS IN PARIS', 'PARIS IN PARIS');
INSERT INTO `lang_phrase` VALUES ('3888', '2', '6', 'title', '570', 'PARIS IN PARIS', 'PARIS IN PARIS');
INSERT INTO `lang_phrase` VALUES ('3889', '3', '6', 'title', '570', 'PARIS IN PARIS', 'PARIS IN PARIS');
INSERT INTO `lang_phrase` VALUES ('3890', '1', '6', 'title', '571', 'PARKER', 'PARKER');
INSERT INTO `lang_phrase` VALUES ('3891', '2', '6', 'title', '571', 'PARKER', 'PARKER');
INSERT INTO `lang_phrase` VALUES ('3892', '3', '6', 'title', '571', 'PARKER', 'PARKER');
INSERT INTO `lang_phrase` VALUES ('3893', '1', '6', 'title', '572', 'PASSION FRANCE', 'PASSION FRANCE');
INSERT INTO `lang_phrase` VALUES ('3894', '2', '6', 'title', '572', 'PASSION FRANCE', 'PASSION FRANCE');
INSERT INTO `lang_phrase` VALUES ('3895', '3', '6', 'title', '572', 'PASSION FRANCE', 'PASSION FRANCE');
INSERT INTO `lang_phrase` VALUES ('3896', '1', '6', 'title', '573', 'PASSIONATA', 'PASSIONATA');
INSERT INTO `lang_phrase` VALUES ('3897', '2', '6', 'title', '573', 'PASSIONATA', 'PASSIONATA');
INSERT INTO `lang_phrase` VALUES ('3898', '3', '6', 'title', '573', 'PASSIONATA', 'PASSIONATA');
INSERT INTO `lang_phrase` VALUES ('3899', '1', '6', 'title', '574', 'PATAGONIA', 'PATAGONIA');
INSERT INTO `lang_phrase` VALUES ('3900', '2', '6', 'title', '574', 'PATAGONIA', 'PATAGONIA');
INSERT INTO `lang_phrase` VALUES ('3901', '3', '6', 'title', '574', 'PATAGONIA', 'PATAGONIA');
INSERT INTO `lang_phrase` VALUES ('3902', '1', '6', 'title', '575', 'PATAUGAS', 'PATAUGAS');
INSERT INTO `lang_phrase` VALUES ('3903', '2', '6', 'title', '575', 'PATAUGAS', 'PATAUGAS');
INSERT INTO `lang_phrase` VALUES ('3904', '3', '6', 'title', '575', 'PATAUGAS', 'PATAUGAS');
INSERT INTO `lang_phrase` VALUES ('3905', '1', '6', 'title', '576', 'PATÉ DE SABLE', 'PATÉ DE SABLE');
INSERT INTO `lang_phrase` VALUES ('3906', '2', '6', 'title', '576', 'PATÉ DE SABLE', 'PATÉ DE SABLE');
INSERT INTO `lang_phrase` VALUES ('3907', '3', '6', 'title', '576', 'PATÉ DE SABLE', 'PATÉ DE SABLE');
INSERT INTO `lang_phrase` VALUES ('3908', '1', '6', 'title', '577', 'PAUL & JOE', 'PAUL & JOE');
INSERT INTO `lang_phrase` VALUES ('3909', '2', '6', 'title', '577', 'PAUL & JOE', 'PAUL & JOE');
INSERT INTO `lang_phrase` VALUES ('3910', '3', '6', 'title', '577', 'PAUL & JOE', 'PAUL & JOE');
INSERT INTO `lang_phrase` VALUES ('3911', '1', '6', 'title', '578', 'PAUL & JOE SISTER', 'PAUL & JOE SISTER');
INSERT INTO `lang_phrase` VALUES ('3912', '2', '6', 'title', '578', 'PAUL & JOE SISTER', 'PAUL & JOE SISTER');
INSERT INTO `lang_phrase` VALUES ('3913', '3', '6', 'title', '578', 'PAUL & JOE SISTER', 'PAUL & JOE SISTER');
INSERT INTO `lang_phrase` VALUES ('3914', '1', '6', 'title', '579', 'PAUL SMITH', 'PAUL SMITH');
INSERT INTO `lang_phrase` VALUES ('3915', '2', '6', 'title', '579', 'PAUL SMITH', 'PAUL SMITH');
INSERT INTO `lang_phrase` VALUES ('3916', '3', '6', 'title', '579', 'PAUL SMITH', 'PAUL SMITH');
INSERT INTO `lang_phrase` VALUES ('3917', '1', '6', 'title', '580', 'PAULE KA', 'PAULE KA');
INSERT INTO `lang_phrase` VALUES ('3918', '2', '6', 'title', '580', 'PAULE KA', 'PAULE KA');
INSERT INTO `lang_phrase` VALUES ('3919', '3', '6', 'title', '580', 'PAULE KA', 'PAULE KA');
INSERT INTO `lang_phrase` VALUES ('3920', '1', '6', 'title', '581', 'PEPE JEANS', 'PEPE JEANS');
INSERT INTO `lang_phrase` VALUES ('3921', '2', '6', 'title', '581', 'PEPE JEANS', 'PEPE JEANS');
INSERT INTO `lang_phrase` VALUES ('3922', '3', '6', 'title', '581', 'PEPE JEANS', 'PEPE JEANS');
INSERT INTO `lang_phrase` VALUES ('3923', '1', '6', 'title', '582', 'PEQUIGNET', 'PEQUIGNET');
INSERT INTO `lang_phrase` VALUES ('3924', '2', '6', 'title', '582', 'PEQUIGNET', 'PEQUIGNET');
INSERT INTO `lang_phrase` VALUES ('3925', '3', '6', 'title', '582', 'PEQUIGNET', 'PEQUIGNET');
INSERT INTO `lang_phrase` VALUES ('3926', '1', '6', 'title', '583', 'PETIT BATEAU', 'PETIT BATEAU');
INSERT INTO `lang_phrase` VALUES ('3927', '2', '6', 'title', '583', 'PETIT BATEAU', 'PETIT BATEAU');
INSERT INTO `lang_phrase` VALUES ('3928', '3', '6', 'title', '583', 'PETIT BATEAU', 'PETIT BATEAU');
INSERT INTO `lang_phrase` VALUES ('3929', '1', '6', 'title', '584', 'PETROSSIAN', 'PETROSSIAN');
INSERT INTO `lang_phrase` VALUES ('3930', '2', '6', 'title', '584', 'PETROSSIAN', 'PETROSSIAN');
INSERT INTO `lang_phrase` VALUES ('3931', '3', '6', 'title', '584', 'PETROSSIAN', 'PETROSSIAN');
INSERT INTO `lang_phrase` VALUES ('3932', '1', '6', 'title', '585', 'PETRUSSE', 'PETRUSSE');
INSERT INTO `lang_phrase` VALUES ('3933', '2', '6', 'title', '585', 'PETRUSSE', 'PETRUSSE');
INSERT INTO `lang_phrase` VALUES ('3934', '3', '6', 'title', '585', 'PETRUSSE', 'PETRUSSE');
INSERT INTO `lang_phrase` VALUES ('3935', '1', '6', 'title', '586', 'PEUGEOT', 'PEUGEOT');
INSERT INTO `lang_phrase` VALUES ('3936', '2', '6', 'title', '586', 'PEUGEOT', 'PEUGEOT');
INSERT INTO `lang_phrase` VALUES ('3937', '3', '6', 'title', '586', 'PEUGEOT', 'PEUGEOT');
INSERT INTO `lang_phrase` VALUES ('3938', '1', '6', 'title', '587', 'PEUGEOT ŒNOLOGIE', 'PEUGEOT ŒNOLOGIE');
INSERT INTO `lang_phrase` VALUES ('3939', '2', '6', 'title', '587', 'PEUGEOT ŒNOLOGIE', 'PEUGEOT ŒNOLOGIE');
INSERT INTO `lang_phrase` VALUES ('3940', '3', '6', 'title', '587', 'PEUGEOT ŒNOLOGIE', 'PEUGEOT ŒNOLOGIE');
INSERT INTO `lang_phrase` VALUES ('3941', '1', '6', 'title', '588', 'PHILIPPE MODEL', 'PHILIPPE MODEL');
INSERT INTO `lang_phrase` VALUES ('3942', '2', '6', 'title', '588', 'PHILIPPE MODEL', 'PHILIPPE MODEL');
INSERT INTO `lang_phrase` VALUES ('3943', '3', '6', 'title', '588', 'PHILIPPE MODEL', 'PHILIPPE MODEL');
INSERT INTO `lang_phrase` VALUES ('3944', '1', '6', 'title', '589', 'PHILLIP LIM', 'PHILLIP LIM');
INSERT INTO `lang_phrase` VALUES ('3945', '2', '6', 'title', '589', 'PHILLIP LIM', 'PHILLIP LIM');
INSERT INTO `lang_phrase` VALUES ('3946', '3', '6', 'title', '589', 'PHILLIP LIM', 'PHILLIP LIM');
INSERT INTO `lang_phrase` VALUES ('3947', '1', '6', 'title', '590', 'PIAGET', 'PIAGET');
INSERT INTO `lang_phrase` VALUES ('3948', '2', '6', 'title', '590', 'PIAGET', 'PIAGET');
INSERT INTO `lang_phrase` VALUES ('3949', '3', '6', 'title', '590', 'PIAGET', 'PIAGET');
INSERT INTO `lang_phrase` VALUES ('3950', '1', '6', 'title', '591', 'PICARD', 'PICARD');
INSERT INTO `lang_phrase` VALUES ('3951', '2', '6', 'title', '591', 'PICARD', 'PICARD');
INSERT INTO `lang_phrase` VALUES ('3952', '3', '6', 'title', '591', 'PICARD', 'PICARD');
INSERT INTO `lang_phrase` VALUES ('3953', '1', '6', 'title', '592', 'PIERRE-LOUIS MASCIA', 'PIERRE-LOUIS MASCIA');
INSERT INTO `lang_phrase` VALUES ('3954', '2', '6', 'title', '592', 'PIERRE-LOUIS MASCIA', 'PIERRE-LOUIS MASCIA');
INSERT INTO `lang_phrase` VALUES ('3955', '3', '6', 'title', '592', 'PIERRE-LOUIS MASCIA', 'PIERRE-LOUIS MASCIA');
INSERT INTO `lang_phrase` VALUES ('3956', '1', '6', 'title', '593', 'PIETRO BRUNELLI', 'PIETRO BRUNELLI');
INSERT INTO `lang_phrase` VALUES ('3957', '2', '6', 'title', '593', 'PIETRO BRUNELLI', 'PIETRO BRUNELLI');
INSERT INTO `lang_phrase` VALUES ('3958', '3', '6', 'title', '593', 'PIETRO BRUNELLI', 'PIETRO BRUNELLI');
INSERT INTO `lang_phrase` VALUES ('3959', '1', '6', 'title', '594', 'PIGALE', 'PIGALE');
INSERT INTO `lang_phrase` VALUES ('3960', '2', '6', 'title', '594', 'PIGALE', 'PIGALE');
INSERT INTO `lang_phrase` VALUES ('3961', '3', '6', 'title', '594', 'PIGALE', 'PIGALE');
INSERT INTO `lang_phrase` VALUES ('3962', '1', '6', 'title', '595', 'PILUS', 'PILUS');
INSERT INTO `lang_phrase` VALUES ('3963', '2', '6', 'title', '595', 'PILUS', 'PILUS');
INSERT INTO `lang_phrase` VALUES ('3964', '3', '6', 'title', '595', 'PILUS', 'PILUS');
INSERT INTO `lang_phrase` VALUES ('3965', '1', '6', 'title', '596', 'PINKO', 'PINKO');
INSERT INTO `lang_phrase` VALUES ('3966', '2', '6', 'title', '596', 'PINKO', 'PINKO');
INSERT INTO `lang_phrase` VALUES ('3967', '3', '6', 'title', '596', 'PINKO', 'PINKO');
INSERT INTO `lang_phrase` VALUES ('3968', '1', '6', 'title', '597', 'PLASTOY', 'PLASTOY');
INSERT INTO `lang_phrase` VALUES ('3969', '2', '6', 'title', '597', 'PLASTOY', 'PLASTOY');
INSERT INTO `lang_phrase` VALUES ('3970', '3', '6', 'title', '597', 'PLASTOY', 'PLASTOY');
INSERT INTO `lang_phrase` VALUES ('3971', '1', '6', 'title', '598', 'PLAYMOBIL', 'PLAYMOBIL');
INSERT INTO `lang_phrase` VALUES ('3972', '2', '6', 'title', '598', 'PLAYMOBIL', 'PLAYMOBIL');
INSERT INTO `lang_phrase` VALUES ('3973', '3', '6', 'title', '598', 'PLAYMOBIL', 'PLAYMOBIL');
INSERT INTO `lang_phrase` VALUES ('3974', '1', '6', 'title', '599', 'PLAYSKOOL', 'PLAYSKOOL');
INSERT INTO `lang_phrase` VALUES ('3975', '2', '6', 'title', '599', 'PLAYSKOOL', 'PLAYSKOOL');
INSERT INTO `lang_phrase` VALUES ('3976', '3', '6', 'title', '599', 'PLAYSKOOL', 'PLAYSKOOL');
INSERT INTO `lang_phrase` VALUES ('3977', '1', '6', 'title', '600', 'PLEATS', 'PLEATS');
INSERT INTO `lang_phrase` VALUES ('3978', '2', '6', 'title', '600', 'PLEATS', 'PLEATS');
INSERT INTO `lang_phrase` VALUES ('3979', '3', '6', 'title', '600', 'PLEATS', 'PLEATS');
INSERT INTO `lang_phrase` VALUES ('3980', '1', '6', 'title', '601', 'PLEASE ISSEY MIYAKÉ', 'PLEASE ISSEY MIYAKÉ');
INSERT INTO `lang_phrase` VALUES ('3981', '2', '6', 'title', '601', 'PLEASE ISSEY MIYAKÉ', 'PLEASE ISSEY MIYAKÉ');
INSERT INTO `lang_phrase` VALUES ('3982', '3', '6', 'title', '601', 'PLEASE ISSEY MIYAKÉ', 'PLEASE ISSEY MIYAKÉ');
INSERT INTO `lang_phrase` VALUES ('3983', '1', '6', 'title', '602', 'POIVRE BLANC', 'POIVRE BLANC');
INSERT INTO `lang_phrase` VALUES ('3984', '2', '6', 'title', '602', 'POIVRE BLANC', 'POIVRE BLANC');
INSERT INTO `lang_phrase` VALUES ('3985', '3', '6', 'title', '602', 'POIVRE BLANC', 'POIVRE BLANC');
INSERT INTO `lang_phrase` VALUES ('3986', '1', '6', 'title', '603', 'POLO RALPH LAUREN', 'POLO RALPH LAUREN');
INSERT INTO `lang_phrase` VALUES ('3987', '2', '6', 'title', '603', 'POLO RALPH LAUREN', 'POLO RALPH LAUREN');
INSERT INTO `lang_phrase` VALUES ('3988', '3', '6', 'title', '603', 'POLO RALPH LAUREN', 'POLO RALPH LAUREN');
INSERT INTO `lang_phrase` VALUES ('3989', '1', '6', 'title', '604', 'POM D’API', 'POM D’API');
INSERT INTO `lang_phrase` VALUES ('3990', '2', '6', 'title', '604', 'POM D’API', 'POM D’API');
INSERT INTO `lang_phrase` VALUES ('3991', '3', '6', 'title', '604', 'POM D’API', 'POM D’API');
INSERT INTO `lang_phrase` VALUES ('3992', '1', '6', 'title', '605', 'POMAX', 'POMAX');
INSERT INTO `lang_phrase` VALUES ('3993', '2', '6', 'title', '605', 'POMAX', 'POMAX');
INSERT INTO `lang_phrase` VALUES ('3994', '3', '6', 'title', '605', 'POMAX', 'POMAX');
INSERT INTO `lang_phrase` VALUES ('3995', '1', '6', 'title', '606', 'POMELLATO', 'POMELLATO');
INSERT INTO `lang_phrase` VALUES ('3996', '2', '6', 'title', '606', 'POMELLATO', 'POMELLATO');
INSERT INTO `lang_phrase` VALUES ('3997', '3', '6', 'title', '606', 'POMELLATO', 'POMELLATO');
INSERT INTO `lang_phrase` VALUES ('3998', '1', '6', 'title', '607', 'PRADA', 'PRADA');
INSERT INTO `lang_phrase` VALUES ('3999', '2', '6', 'title', '607', 'PRADA', 'PRADA');
INSERT INTO `lang_phrase` VALUES ('4000', '3', '6', 'title', '607', 'PRADA', 'PRADA');
INSERT INTO `lang_phrase` VALUES ('4001', '1', '6', 'title', '608', 'PRÉSENCE', 'PRÉSENCE');
INSERT INTO `lang_phrase` VALUES ('4002', '2', '6', 'title', '608', 'PRÉSENCE', 'PRÉSENCE');
INSERT INTO `lang_phrase` VALUES ('4003', '3', '6', 'title', '608', 'PRÉSENCE', 'PRÉSENCE');
INSERT INTO `lang_phrase` VALUES ('4004', '1', '6', 'title', '609', 'PRIMA DONNA', 'PRIMA DONNA');
INSERT INTO `lang_phrase` VALUES ('4005', '2', '6', 'title', '609', 'PRIMA DONNA', 'PRIMA DONNA');
INSERT INTO `lang_phrase` VALUES ('4006', '3', '6', 'title', '609', 'PRIMA DONNA', 'PRIMA DONNA');
INSERT INTO `lang_phrase` VALUES ('4007', '1', '6', 'title', '610', 'PRINCESSE TAM-TAM', 'PRINCESSE TAM-TAM');
INSERT INTO `lang_phrase` VALUES ('4008', '2', '6', 'title', '610', 'PRINCESSE TAM-TAM', 'PRINCESSE TAM-TAM');
INSERT INTO `lang_phrase` VALUES ('4009', '3', '6', 'title', '610', 'PRINCESSE TAM-TAM', 'PRINCESSE TAM-TAM');
INSERT INTO `lang_phrase` VALUES ('4010', '1', '6', 'title', '611', 'PROENZA SCHOULER', 'PROENZA SCHOULER');
INSERT INTO `lang_phrase` VALUES ('4011', '2', '6', 'title', '611', 'PROENZA SCHOULER', 'PROENZA SCHOULER');
INSERT INTO `lang_phrase` VALUES ('4012', '3', '6', 'title', '611', 'PROENZA SCHOULER', 'PROENZA SCHOULER');
INSERT INTO `lang_phrase` VALUES ('4013', '1', '6', 'title', '612', 'PSG', 'PSG');
INSERT INTO `lang_phrase` VALUES ('4014', '2', '6', 'title', '612', 'PSG', 'PSG');
INSERT INTO `lang_phrase` VALUES ('4015', '3', '6', 'title', '612', 'PSG', 'PSG');
INSERT INTO `lang_phrase` VALUES ('4016', '1', '6', 'title', '613', 'PUIFORCAT', 'PUIFORCAT');
INSERT INTO `lang_phrase` VALUES ('4017', '2', '6', 'title', '613', 'PUIFORCAT', 'PUIFORCAT');
INSERT INTO `lang_phrase` VALUES ('4018', '3', '6', 'title', '613', 'PUIFORCAT', 'PUIFORCAT');
INSERT INTO `lang_phrase` VALUES ('4019', '1', '6', 'title', '614', 'PULL’IN', 'PULL’IN');
INSERT INTO `lang_phrase` VALUES ('4020', '2', '6', 'title', '614', 'PULL’IN', 'PULL’IN');
INSERT INTO `lang_phrase` VALUES ('4021', '3', '6', 'title', '614', 'PULL’IN', 'PULL’IN');
INSERT INTO `lang_phrase` VALUES ('4022', '1', '6', 'title', '615', 'PUMA', 'PUMA');
INSERT INTO `lang_phrase` VALUES ('4023', '2', '6', 'title', '615', 'PUMA', 'PUMA');
INSERT INTO `lang_phrase` VALUES ('4024', '3', '6', 'title', '615', 'PUMA', 'PUMA');
INSERT INTO `lang_phrase` VALUES ('4025', '1', '6', 'title', '616', 'PYRENEX', 'PYRENEX');
INSERT INTO `lang_phrase` VALUES ('4026', '2', '6', 'title', '616', 'PYRENEX', 'PYRENEX');
INSERT INTO `lang_phrase` VALUES ('4027', '3', '6', 'title', '616', 'PYRENEX', 'PYRENEX');
INSERT INTO `lang_phrase` VALUES ('4028', '1', '6', 'title', '617', 'Q QUIKSILVER', 'Q QUIKSILVER');
INSERT INTO `lang_phrase` VALUES ('4029', '2', '6', 'title', '617', 'Q QUIKSILVER', 'Q QUIKSILVER');
INSERT INTO `lang_phrase` VALUES ('4030', '3', '6', 'title', '617', 'Q QUIKSILVER', 'Q QUIKSILVER');
INSERT INTO `lang_phrase` VALUES ('4031', '1', '6', 'title', '618', 'QUO VADIS', 'QUO VADIS');
INSERT INTO `lang_phrase` VALUES ('4032', '2', '6', 'title', '618', 'QUO VADIS', 'QUO VADIS');
INSERT INTO `lang_phrase` VALUES ('4033', '3', '6', 'title', '618', 'QUO VADIS', 'QUO VADIS');
INSERT INTO `lang_phrase` VALUES ('4034', '1', '6', 'title', '619', 'R RADO', 'R RADO');
INSERT INTO `lang_phrase` VALUES ('4035', '2', '6', 'title', '619', 'R RADO', 'R RADO');
INSERT INTO `lang_phrase` VALUES ('4036', '3', '6', 'title', '619', 'R RADO', 'R RADO');
INSERT INTO `lang_phrase` VALUES ('4037', '1', '6', 'title', '620', 'RAG & BONE', 'RAG & BONE');
INSERT INTO `lang_phrase` VALUES ('4038', '2', '6', 'title', '620', 'RAG & BONE', 'RAG & BONE');
INSERT INTO `lang_phrase` VALUES ('4039', '3', '6', 'title', '620', 'RAG & BONE', 'RAG & BONE');
INSERT INTO `lang_phrase` VALUES ('4040', '1', '6', 'title', '621', 'RALPH LAUREN', 'RALPH LAUREN');
INSERT INTO `lang_phrase` VALUES ('4041', '2', '6', 'title', '621', 'RALPH LAUREN', 'RALPH LAUREN');
INSERT INTO `lang_phrase` VALUES ('4042', '3', '6', 'title', '621', 'RALPH LAUREN', 'RALPH LAUREN');
INSERT INTO `lang_phrase` VALUES ('4043', '1', '6', 'title', '622', 'RAVENSBURGER', 'RAVENSBURGER');
INSERT INTO `lang_phrase` VALUES ('4044', '2', '6', 'title', '622', 'RAVENSBURGER', 'RAVENSBURGER');
INSERT INTO `lang_phrase` VALUES ('4045', '3', '6', 'title', '622', 'RAVENSBURGER', 'RAVENSBURGER');
INSERT INTO `lang_phrase` VALUES ('4046', '1', '6', 'title', '623', 'RED CARPET', 'RED CARPET');
INSERT INTO `lang_phrase` VALUES ('4047', '2', '6', 'title', '623', 'RED CARPET', 'RED CARPET');
INSERT INTO `lang_phrase` VALUES ('4048', '3', '6', 'title', '623', 'RED CARPET', 'RED CARPET');
INSERT INTO `lang_phrase` VALUES ('4049', '1', '6', 'title', '624', 'RED SOX', 'RED SOX');
INSERT INTO `lang_phrase` VALUES ('4050', '2', '6', 'title', '624', 'RED SOX', 'RED SOX');
INSERT INTO `lang_phrase` VALUES ('4051', '3', '6', 'title', '624', 'RED SOX', 'RED SOX');
INSERT INTO `lang_phrase` VALUES ('4052', '1', '6', 'title', '625', 'REDKEN', 'REDKEN');
INSERT INTO `lang_phrase` VALUES ('4053', '2', '6', 'title', '625', 'REDKEN', 'REDKEN');
INSERT INTO `lang_phrase` VALUES ('4054', '3', '6', 'title', '625', 'REDKEN', 'REDKEN');
INSERT INTO `lang_phrase` VALUES ('4055', '1', '6', 'title', '626', 'REDSKINS', 'REDSKINS');
INSERT INTO `lang_phrase` VALUES ('4056', '2', '6', 'title', '626', 'REDSKINS', 'REDSKINS');
INSERT INTO `lang_phrase` VALUES ('4057', '3', '6', 'title', '626', 'REDSKINS', 'REDSKINS');
INSERT INTO `lang_phrase` VALUES ('4058', '1', '6', 'title', '627', 'REEBOK', 'REEBOK');
INSERT INTO `lang_phrase` VALUES ('4059', '2', '6', 'title', '627', 'REEBOK', 'REEBOK');
INSERT INTO `lang_phrase` VALUES ('4060', '3', '6', 'title', '627', 'REEBOK', 'REEBOK');
INSERT INTO `lang_phrase` VALUES ('4061', '1', '6', 'title', '628', 'REMINISCENCE', 'REMINISCENCE');
INSERT INTO `lang_phrase` VALUES ('4062', '2', '6', 'title', '628', 'REMINISCENCE', 'REMINISCENCE');
INSERT INTO `lang_phrase` VALUES ('4063', '3', '6', 'title', '628', 'REMINISCENCE', 'REMINISCENCE');
INSERT INTO `lang_phrase` VALUES ('4064', '1', '6', 'title', '629', 'RENAPUR', 'RENAPUR');
INSERT INTO `lang_phrase` VALUES ('4065', '2', '6', 'title', '629', 'RENAPUR', 'RENAPUR');
INSERT INTO `lang_phrase` VALUES ('4066', '3', '6', 'title', '629', 'RENAPUR', 'RENAPUR');
INSERT INTO `lang_phrase` VALUES ('4067', '1', '6', 'title', '630', 'REPETTO', 'REPETTO');
INSERT INTO `lang_phrase` VALUES ('4068', '2', '6', 'title', '630', 'REPETTO', 'REPETTO');
INSERT INTO `lang_phrase` VALUES ('4069', '3', '6', 'title', '630', 'REPETTO', 'REPETTO');
INSERT INTO `lang_phrase` VALUES ('4070', '1', '6', 'title', '631', 'REPLAY', 'REPLAY');
INSERT INTO `lang_phrase` VALUES ('4071', '2', '6', 'title', '631', 'REPLAY', 'REPLAY');
INSERT INTO `lang_phrase` VALUES ('4072', '3', '6', 'title', '631', 'REPLAY', 'REPLAY');
INSERT INTO `lang_phrase` VALUES ('4073', '1', '6', 'title', '632', 'RÉVOL', 'RÉVOL');
INSERT INTO `lang_phrase` VALUES ('4074', '2', '6', 'title', '632', 'RÉVOL', 'RÉVOL');
INSERT INTO `lang_phrase` VALUES ('4075', '3', '6', 'title', '632', 'RÉVOL', 'RÉVOL');
INSERT INTO `lang_phrase` VALUES ('4076', '1', '6', 'title', '633', 'RICK OWENS', 'RICK OWENS');
INSERT INTO `lang_phrase` VALUES ('4077', '2', '6', 'title', '633', 'RICK OWENS', 'RICK OWENS');
INSERT INTO `lang_phrase` VALUES ('4078', '3', '6', 'title', '633', 'RICK OWENS', 'RICK OWENS');
INSERT INTO `lang_phrase` VALUES ('4079', '1', '6', 'title', '634', 'RIMOWA', 'RIMOWA');
INSERT INTO `lang_phrase` VALUES ('4080', '2', '6', 'title', '634', 'RIMOWA', 'RIMOWA');
INSERT INTO `lang_phrase` VALUES ('4081', '3', '6', 'title', '634', 'RIMOWA', 'RIMOWA');
INSERT INTO `lang_phrase` VALUES ('4082', '1', '6', 'title', '635', 'ROBERT CLERGERIE', 'ROBERT CLERGERIE');
INSERT INTO `lang_phrase` VALUES ('4083', '2', '6', 'title', '635', 'ROBERT CLERGERIE', 'ROBERT CLERGERIE');
INSERT INTO `lang_phrase` VALUES ('4084', '3', '6', 'title', '635', 'ROBERT CLERGERIE', 'ROBERT CLERGERIE');
INSERT INTO `lang_phrase` VALUES ('4085', '1', '6', 'title', '636', 'ROBERTO CAVALLI', 'ROBERTO CAVALLI');
INSERT INTO `lang_phrase` VALUES ('4086', '2', '6', 'title', '636', 'ROBERTO CAVALLI', 'ROBERTO CAVALLI');
INSERT INTO `lang_phrase` VALUES ('4087', '3', '6', 'title', '636', 'ROBERTO CAVALLI', 'ROBERTO CAVALLI');
INSERT INTO `lang_phrase` VALUES ('4088', '1', '6', 'title', '637', 'ROGER DUBUIS', 'ROGER DUBUIS');
INSERT INTO `lang_phrase` VALUES ('4089', '2', '6', 'title', '637', 'ROGER DUBUIS', 'ROGER DUBUIS');
INSERT INTO `lang_phrase` VALUES ('4090', '3', '6', 'title', '637', 'ROGER DUBUIS', 'ROGER DUBUIS');
INSERT INTO `lang_phrase` VALUES ('4091', '1', '6', 'title', '638', 'ROGER GALLET', 'ROGER GALLET');
INSERT INTO `lang_phrase` VALUES ('4092', '2', '6', 'title', '638', 'ROGER GALLET', 'ROGER GALLET');
INSERT INTO `lang_phrase` VALUES ('4093', '3', '6', 'title', '638', 'ROGER GALLET', 'ROGER GALLET');
INSERT INTO `lang_phrase` VALUES ('4094', '1', '6', 'title', '639', 'ROGER VIVIER', 'ROGER VIVIER');
INSERT INTO `lang_phrase` VALUES ('4095', '2', '6', 'title', '639', 'ROGER VIVIER', 'ROGER VIVIER');
INSERT INTO `lang_phrase` VALUES ('4096', '3', '6', 'title', '639', 'ROGER VIVIER', 'ROGER VIVIER');
INSERT INTO `lang_phrase` VALUES ('4097', '1', '6', 'title', '640', 'ROLEX RONCATO', 'ROLEX RONCATO');
INSERT INTO `lang_phrase` VALUES ('4098', '2', '6', 'title', '640', 'ROLEX RONCATO', 'ROLEX RONCATO');
INSERT INTO `lang_phrase` VALUES ('4099', '3', '6', 'title', '640', 'ROLEX RONCATO', 'ROLEX RONCATO');
INSERT INTO `lang_phrase` VALUES ('4100', '1', '6', 'title', '641', 'ROSENTHAL', 'ROSENTHAL');
INSERT INTO `lang_phrase` VALUES ('4101', '2', '6', 'title', '641', 'ROSENTHAL', 'ROSENTHAL');
INSERT INTO `lang_phrase` VALUES ('4102', '3', '6', 'title', '641', 'ROSENTHAL', 'ROSENTHAL');
INSERT INTO `lang_phrase` VALUES ('4103', '1', '6', 'title', '642', 'RÖSLE', 'RÖSLE');
INSERT INTO `lang_phrase` VALUES ('4104', '2', '6', 'title', '642', 'RÖSLE', 'RÖSLE');
INSERT INTO `lang_phrase` VALUES ('4105', '3', '6', 'title', '642', 'RÖSLE', 'RÖSLE');
INSERT INTO `lang_phrase` VALUES ('4106', '1', '6', 'title', '643', 'ROSY', 'ROSY');
INSERT INTO `lang_phrase` VALUES ('4107', '2', '6', 'title', '643', 'ROSY', 'ROSY');
INSERT INTO `lang_phrase` VALUES ('4108', '3', '6', 'title', '643', 'ROSY', 'ROSY');
INSERT INTO `lang_phrase` VALUES ('4109', '1', '6', 'title', '644', 'ROXY', 'ROXY');
INSERT INTO `lang_phrase` VALUES ('4110', '2', '6', 'title', '644', 'ROXY', 'ROXY');
INSERT INTO `lang_phrase` VALUES ('4111', '3', '6', 'title', '644', 'ROXY', 'ROXY');
INSERT INTO `lang_phrase` VALUES ('4112', '1', '6', 'title', '645', 'ROYAL QUARTZ', 'ROYAL QUARTZ');
INSERT INTO `lang_phrase` VALUES ('4113', '2', '6', 'title', '645', 'ROYAL QUARTZ', 'ROYAL QUARTZ');
INSERT INTO `lang_phrase` VALUES ('4114', '3', '6', 'title', '645', 'ROYAL QUARTZ', 'ROYAL QUARTZ');
INSERT INTO `lang_phrase` VALUES ('4115', '1', '6', 'title', '646', 'RUBIES', 'RUBIES');
INSERT INTO `lang_phrase` VALUES ('4116', '2', '6', 'title', '646', 'RUBIES', 'RUBIES');
INSERT INTO `lang_phrase` VALUES ('4117', '3', '6', 'title', '646', 'RUBIES', 'RUBIES');
INSERT INTO `lang_phrase` VALUES ('4118', '1', '6', 'title', '647', 'SABRE', 'SABRE');
INSERT INTO `lang_phrase` VALUES ('4119', '2', '6', 'title', '647', 'SABRE', 'SABRE');
INSERT INTO `lang_phrase` VALUES ('4120', '3', '6', 'title', '647', 'SABRE', 'SABRE');
INSERT INTO `lang_phrase` VALUES ('4121', '1', '6', 'title', '648', 'SAINT LAURENT', 'SAINT LAURENT');
INSERT INTO `lang_phrase` VALUES ('4122', '2', '6', 'title', '648', 'SAINT LAURENT', 'SAINT LAURENT');
INSERT INTO `lang_phrase` VALUES ('4123', '3', '6', 'title', '648', 'SAINT LAURENT', 'SAINT LAURENT');
INSERT INTO `lang_phrase` VALUES ('4124', '1', '6', 'title', '649', 'SAINT LOUIS', 'SAINT LOUIS');
INSERT INTO `lang_phrase` VALUES ('4125', '2', '6', 'title', '649', 'SAINT LOUIS', 'SAINT LOUIS');
INSERT INTO `lang_phrase` VALUES ('4126', '3', '6', 'title', '649', 'SAINT LOUIS', 'SAINT LOUIS');
INSERT INTO `lang_phrase` VALUES ('4127', '1', '6', 'title', '650', 'SALSA', 'SALSA');
INSERT INTO `lang_phrase` VALUES ('4128', '2', '6', 'title', '650', 'SALSA', 'SALSA');
INSERT INTO `lang_phrase` VALUES ('4129', '3', '6', 'title', '650', 'SALSA', 'SALSA');
INSERT INTO `lang_phrase` VALUES ('4130', '1', '6', 'title', '651', 'SALVATORE FERRAGAMO', 'SALVATORE FERRAGAMO');
INSERT INTO `lang_phrase` VALUES ('4131', '2', '6', 'title', '651', 'SALVATORE FERRAGAMO', 'SALVATORE FERRAGAMO');
INSERT INTO `lang_phrase` VALUES ('4132', '3', '6', 'title', '651', 'SALVATORE FERRAGAMO', 'SALVATORE FERRAGAMO');
INSERT INTO `lang_phrase` VALUES ('4133', '1', '6', 'title', '652', 'SAMSONITE', 'SAMSONITE');
INSERT INTO `lang_phrase` VALUES ('4134', '2', '6', 'title', '652', 'SAMSONITE', 'SAMSONITE');
INSERT INTO `lang_phrase` VALUES ('4135', '3', '6', 'title', '652', 'SAMSONITE', 'SAMSONITE');
INSERT INTO `lang_phrase` VALUES ('4136', '1', '6', 'title', '653', 'SANDRO', 'SANDRO');
INSERT INTO `lang_phrase` VALUES ('4137', '2', '6', 'title', '653', 'SANDRO', 'SANDRO');
INSERT INTO `lang_phrase` VALUES ('4138', '3', '6', 'title', '653', 'SANDRO', 'SANDRO');
INSERT INTO `lang_phrase` VALUES ('4139', '1', '6', 'title', '654', 'SANTONI', 'SANTONI');
INSERT INTO `lang_phrase` VALUES ('4140', '2', '6', 'title', '654', 'SANTONI', 'SANTONI');
INSERT INTO `lang_phrase` VALUES ('4141', '3', '6', 'title', '654', 'SANTONI', 'SANTONI');
INSERT INTO `lang_phrase` VALUES ('4142', '1', '6', 'title', '655', 'SARTORE', 'SARTORE');
INSERT INTO `lang_phrase` VALUES ('4143', '2', '6', 'title', '655', 'SARTORE', 'SARTORE');
INSERT INTO `lang_phrase` VALUES ('4144', '3', '6', 'title', '655', 'SARTORE', 'SARTORE');
INSERT INTO `lang_phrase` VALUES ('4145', '1', '6', 'title', '656', 'SATELLITE', 'SATELLITE');
INSERT INTO `lang_phrase` VALUES ('4146', '2', '6', 'title', '656', 'SATELLITE', 'SATELLITE');
INSERT INTO `lang_phrase` VALUES ('4147', '3', '6', 'title', '656', 'SATELLITE', 'SATELLITE');
INSERT INTO `lang_phrase` VALUES ('4148', '1', '6', 'title', '657', 'SCOTCH & SODA', 'SCOTCH & SODA');
INSERT INTO `lang_phrase` VALUES ('4149', '2', '6', 'title', '657', 'SCOTCH & SODA', 'SCOTCH & SODA');
INSERT INTO `lang_phrase` VALUES ('4150', '3', '6', 'title', '657', 'SCOTCH & SODA', 'SCOTCH & SODA');
INSERT INTO `lang_phrase` VALUES ('4151', '1', '6', 'title', '658', 'SCREWPULL', 'SCREWPULL');
INSERT INTO `lang_phrase` VALUES ('4152', '2', '6', 'title', '658', 'SCREWPULL', 'SCREWPULL');
INSERT INTO `lang_phrase` VALUES ('4153', '3', '6', 'title', '658', 'SCREWPULL', 'SCREWPULL');
INSERT INTO `lang_phrase` VALUES ('4154', '1', '6', 'title', '659', 'SEAFOLLY', 'SEAFOLLY');
INSERT INTO `lang_phrase` VALUES ('4155', '2', '6', 'title', '659', 'SEAFOLLY', 'SEAFOLLY');
INSERT INTO `lang_phrase` VALUES ('4156', '3', '6', 'title', '659', 'SEAFOLLY', 'SEAFOLLY');
INSERT INTO `lang_phrase` VALUES ('4157', '1', '6', 'title', '660', 'SEB', 'SEB');
INSERT INTO `lang_phrase` VALUES ('4158', '2', '6', 'title', '660', 'SEB', 'SEB');
INSERT INTO `lang_phrase` VALUES ('4159', '3', '6', 'title', '660', 'SEB', 'SEB');
INSERT INTO `lang_phrase` VALUES ('4160', '1', '6', 'title', '661', 'SEE BY CHLOÉ', 'SEE BY CHLOÉ');
INSERT INTO `lang_phrase` VALUES ('4161', '2', '6', 'title', '661', 'SEE BY CHLOÉ', 'SEE BY CHLOÉ');
INSERT INTO `lang_phrase` VALUES ('4162', '3', '6', 'title', '661', 'SEE BY CHLOÉ', 'SEE BY CHLOÉ');
INSERT INTO `lang_phrase` VALUES ('4163', '1', '6', 'title', '662', 'SEE U SOON', 'SEE U SOON');
INSERT INTO `lang_phrase` VALUES ('4164', '2', '6', 'title', '662', 'SEE U SOON', 'SEE U SOON');
INSERT INTO `lang_phrase` VALUES ('4165', '3', '6', 'title', '662', 'SEE U SOON', 'SEE U SOON');
INSERT INTO `lang_phrase` VALUES ('4166', '1', '6', 'title', '663', 'SEIDENSTICKER', 'SEIDENSTICKER');
INSERT INTO `lang_phrase` VALUES ('4167', '2', '6', 'title', '663', 'SEIDENSTICKER', 'SEIDENSTICKER');
INSERT INTO `lang_phrase` VALUES ('4168', '3', '6', 'title', '663', 'SEIDENSTICKER', 'SEIDENSTICKER');
INSERT INTO `lang_phrase` VALUES ('4169', '1', '6', 'title', '664', 'SEIKO', 'SEIKO');
INSERT INTO `lang_phrase` VALUES ('4170', '2', '6', 'title', '664', 'SEIKO', 'SEIKO');
INSERT INTO `lang_phrase` VALUES ('4171', '3', '6', 'title', '664', 'SEIKO', 'SEIKO');
INSERT INTO `lang_phrase` VALUES ('4172', '1', '6', 'title', '665', 'SENTOSPHERE', 'SENTOSPHERE');
INSERT INTO `lang_phrase` VALUES ('4173', '2', '6', 'title', '665', 'SENTOSPHERE', 'SENTOSPHERE');
INSERT INTO `lang_phrase` VALUES ('4174', '3', '6', 'title', '665', 'SENTOSPHERE', 'SENTOSPHERE');
INSERT INTO `lang_phrase` VALUES ('4175', '1', '6', 'title', '666', 'SÉRAPHINE', 'SÉRAPHINE');
INSERT INTO `lang_phrase` VALUES ('4176', '2', '6', 'title', '666', 'SÉRAPHINE', 'SÉRAPHINE');
INSERT INTO `lang_phrase` VALUES ('4177', '3', '6', 'title', '666', 'SÉRAPHINE', 'SÉRAPHINE');
INSERT INTO `lang_phrase` VALUES ('4178', '1', '6', 'title', '667', 'SERGE LUTENS', 'SERGE LUTENS');
INSERT INTO `lang_phrase` VALUES ('4179', '2', '6', 'title', '667', 'SERGE LUTENS', 'SERGE LUTENS');
INSERT INTO `lang_phrase` VALUES ('4180', '3', '6', 'title', '667', 'SERGE LUTENS', 'SERGE LUTENS');
INSERT INTO `lang_phrase` VALUES ('4181', '1', '6', 'title', '668', 'SERGIO ROSSI', 'SERGIO ROSSI');
INSERT INTO `lang_phrase` VALUES ('4182', '2', '6', 'title', '668', 'SERGIO ROSSI', 'SERGIO ROSSI');
INSERT INTO `lang_phrase` VALUES ('4183', '3', '6', 'title', '668', 'SERGIO ROSSI', 'SERGIO ROSSI');
INSERT INTO `lang_phrase` VALUES ('4184', '1', '6', 'title', '669', 'SESSUN', 'SESSUN');
INSERT INTO `lang_phrase` VALUES ('4185', '2', '6', 'title', '669', 'SESSUN', 'SESSUN');
INSERT INTO `lang_phrase` VALUES ('4186', '3', '6', 'title', '669', 'SESSUN', 'SESSUN');
INSERT INTO `lang_phrase` VALUES ('4187', '1', '6', 'title', '670', 'SHISEIDO', 'SHISEIDO');
INSERT INTO `lang_phrase` VALUES ('4188', '2', '6', 'title', '670', 'SHISEIDO', 'SHISEIDO');
INSERT INTO `lang_phrase` VALUES ('4189', '3', '6', 'title', '670', 'SHISEIDO', 'SHISEIDO');
INSERT INTO `lang_phrase` VALUES ('4190', '1', '6', 'title', '671', 'SHOUROUK', 'SHOUROUK');
INSERT INTO `lang_phrase` VALUES ('4191', '2', '6', 'title', '671', 'SHOUROUK', 'SHOUROUK');
INSERT INTO `lang_phrase` VALUES ('4192', '3', '6', 'title', '671', 'SHOUROUK', 'SHOUROUK');
INSERT INTO `lang_phrase` VALUES ('4193', '1', '6', 'title', '672', 'SHU UEMURA', 'SHU UEMURA');
INSERT INTO `lang_phrase` VALUES ('4194', '2', '6', 'title', '672', 'SHU UEMURA', 'SHU UEMURA');
INSERT INTO `lang_phrase` VALUES ('4195', '3', '6', 'title', '672', 'SHU UEMURA', 'SHU UEMURA');
INSERT INTO `lang_phrase` VALUES ('4196', '1', '6', 'title', '673', 'SIMMONS', 'SIMMONS');
INSERT INTO `lang_phrase` VALUES ('4197', '2', '6', 'title', '673', 'SIMMONS', 'SIMMONS');
INSERT INTO `lang_phrase` VALUES ('4198', '3', '6', 'title', '673', 'SIMMONS', 'SIMMONS');
INSERT INTO `lang_phrase` VALUES ('4199', '1', '6', 'title', '674', 'SIMONE PÉRÈLE', 'SIMONE PÉRÈLE');
INSERT INTO `lang_phrase` VALUES ('4200', '2', '6', 'title', '674', 'SIMONE PÉRÈLE', 'SIMONE PÉRÈLE');
INSERT INTO `lang_phrase` VALUES ('4201', '3', '6', 'title', '674', 'SIMONE PÉRÈLE', 'SIMONE PÉRÈLE');
INSERT INTO `lang_phrase` VALUES ('4202', '1', '6', 'title', '675', 'SINEQUANONE', 'SINEQUANONE');
INSERT INTO `lang_phrase` VALUES ('4203', '2', '6', 'title', '675', 'SINEQUANONE', 'SINEQUANONE');
INSERT INTO `lang_phrase` VALUES ('4204', '3', '6', 'title', '675', 'SINEQUANONE', 'SINEQUANONE');
INSERT INTO `lang_phrase` VALUES ('4205', '1', '6', 'title', '676', 'SINFULCOLORS', 'SINFULCOLORS');
INSERT INTO `lang_phrase` VALUES ('4206', '2', '6', 'title', '676', 'SINFULCOLORS', 'SINFULCOLORS');
INSERT INTO `lang_phrase` VALUES ('4207', '3', '6', 'title', '676', 'SINFULCOLORS', 'SINFULCOLORS');
INSERT INTO `lang_phrase` VALUES ('4208', '1', '6', 'title', '677', 'SISLEY', 'SISLEY');
INSERT INTO `lang_phrase` VALUES ('4209', '2', '6', 'title', '677', 'SISLEY', 'SISLEY');
INSERT INTO `lang_phrase` VALUES ('4210', '3', '6', 'title', '677', 'SISLEY', 'SISLEY');
INSERT INTO `lang_phrase` VALUES ('4211', '1', '6', 'title', '678', 'SIX PIEDS TROIS POUCES', 'SIX PIEDS TROIS POUCES');
INSERT INTO `lang_phrase` VALUES ('4212', '2', '6', 'title', '678', 'SIX PIEDS TROIS POUCES', 'SIX PIEDS TROIS POUCES');
INSERT INTO `lang_phrase` VALUES ('4213', '3', '6', 'title', '678', 'SIX PIEDS TROIS POUCES', 'SIX PIEDS TROIS POUCES');
INSERT INTO `lang_phrase` VALUES ('4214', '1', '6', 'title', '679', 'SMALTO', 'SMALTO');
INSERT INTO `lang_phrase` VALUES ('4215', '2', '6', 'title', '679', 'SMALTO', 'SMALTO');
INSERT INTO `lang_phrase` VALUES ('4216', '3', '6', 'title', '679', 'SMALTO', 'SMALTO');
INSERT INTO `lang_phrase` VALUES ('4217', '1', '6', 'title', '680', 'SMEG', 'SMEG');
INSERT INTO `lang_phrase` VALUES ('4218', '2', '6', 'title', '680', 'SMEG', 'SMEG');
INSERT INTO `lang_phrase` VALUES ('4219', '3', '6', 'title', '680', 'SMEG', 'SMEG');
INSERT INTO `lang_phrase` VALUES ('4220', '1', '6', 'title', '681', 'SMOBY', 'SMOBY');
INSERT INTO `lang_phrase` VALUES ('4221', '2', '6', 'title', '681', 'SMOBY', 'SMOBY');
INSERT INTO `lang_phrase` VALUES ('4222', '3', '6', 'title', '681', 'SMOBY', 'SMOBY');
INSERT INTO `lang_phrase` VALUES ('4223', '1', '6', 'title', '682', 'SMYTHSON', 'SMYTHSON');
INSERT INTO `lang_phrase` VALUES ('4224', '2', '6', 'title', '682', 'SMYTHSON', 'SMYTHSON');
INSERT INTO `lang_phrase` VALUES ('4225', '3', '6', 'title', '682', 'SMYTHSON', 'SMYTHSON');
INSERT INTO `lang_phrase` VALUES ('4226', '1', '6', 'title', '683', 'SNEAKERS', 'SNEAKERS');
INSERT INTO `lang_phrase` VALUES ('4227', '2', '6', 'title', '683', 'SNEAKERS', 'SNEAKERS');
INSERT INTO `lang_phrase` VALUES ('4228', '3', '6', 'title', '683', 'SNEAKERS', 'SNEAKERS');
INSERT INTO `lang_phrase` VALUES ('4229', '1', '6', 'title', '684', 'SOFRAP', 'SOFRAP');
INSERT INTO `lang_phrase` VALUES ('4230', '2', '6', 'title', '684', 'SOFRAP', 'SOFRAP');
INSERT INTO `lang_phrase` VALUES ('4231', '3', '6', 'title', '684', 'SOFRAP', 'SOFRAP');
INSERT INTO `lang_phrase` VALUES ('4232', '1', '6', 'title', '685', 'SONIA BY SONIA RYKIEL', 'SONIA BY SONIA RYKIEL');
INSERT INTO `lang_phrase` VALUES ('4233', '2', '6', 'title', '685', 'SONIA BY SONIA RYKIEL', 'SONIA BY SONIA RYKIEL');
INSERT INTO `lang_phrase` VALUES ('4234', '3', '6', 'title', '685', 'SONIA BY SONIA RYKIEL', 'SONIA BY SONIA RYKIEL');
INSERT INTO `lang_phrase` VALUES ('4235', '1', '6', 'title', '686', 'SONIA RYKIEL', 'SONIA RYKIEL');
INSERT INTO `lang_phrase` VALUES ('4236', '2', '6', 'title', '686', 'SONIA RYKIEL', 'SONIA RYKIEL');
INSERT INTO `lang_phrase` VALUES ('4237', '3', '6', 'title', '686', 'SONIA RYKIEL', 'SONIA RYKIEL');
INSERT INTO `lang_phrase` VALUES ('4238', '1', '6', 'title', '687', 'SOUVENIRS DE PARIS', 'SOUVENIRS DE PARIS');
INSERT INTO `lang_phrase` VALUES ('4239', '2', '6', 'title', '687', 'SOUVENIRS DE PARIS', 'SOUVENIRS DE PARIS');
INSERT INTO `lang_phrase` VALUES ('4240', '3', '6', 'title', '687', 'SOUVENIRS DE PARIS', 'SOUVENIRS DE PARIS');
INSERT INTO `lang_phrase` VALUES ('4241', '1', '6', 'title', '688', 'SPANX', 'SPANX');
INSERT INTO `lang_phrase` VALUES ('4242', '2', '6', 'title', '688', 'SPANX', 'SPANX');
INSERT INTO `lang_phrase` VALUES ('4243', '3', '6', 'title', '688', 'SPANX', 'SPANX');
INSERT INTO `lang_phrase` VALUES ('4244', '1', '6', 'title', '689', 'SPRUNG FRÈRES', 'SPRUNG FRÈRES');
INSERT INTO `lang_phrase` VALUES ('4245', '2', '6', 'title', '689', 'SPRUNG FRÈRES', 'SPRUNG FRÈRES');
INSERT INTO `lang_phrase` VALUES ('4246', '3', '6', 'title', '689', 'SPRUNG FRÈRES', 'SPRUNG FRÈRES');
INSERT INTO `lang_phrase` VALUES ('4247', '1', '6', 'title', '690', 'STAUB', 'STAUB');
INSERT INTO `lang_phrase` VALUES ('4248', '2', '6', 'title', '690', 'STAUB', 'STAUB');
INSERT INTO `lang_phrase` VALUES ('4249', '3', '6', 'title', '690', 'STAUB', 'STAUB');
INSERT INTO `lang_phrase` VALUES ('4250', '1', '6', 'title', '691', 'STEINER', 'STEINER');
INSERT INTO `lang_phrase` VALUES ('4251', '2', '6', 'title', '691', 'STEINER', 'STEINER');
INSERT INTO `lang_phrase` VALUES ('4252', '3', '6', 'title', '691', 'STEINER', 'STEINER');
INSERT INTO `lang_phrase` VALUES ('4253', '1', '6', 'title', '692', 'STELLA LUNA', 'STELLA LUNA');
INSERT INTO `lang_phrase` VALUES ('4254', '2', '6', 'title', '692', 'STELLA LUNA', 'STELLA LUNA');
INSERT INTO `lang_phrase` VALUES ('4255', '3', '6', 'title', '692', 'STELLA LUNA', 'STELLA LUNA');
INSERT INTO `lang_phrase` VALUES ('4256', '1', '6', 'title', '693', 'STELLA MC CARTNEY', 'STELLA MC CARTNEY');
INSERT INTO `lang_phrase` VALUES ('4257', '2', '6', 'title', '693', 'STELLA MC CARTNEY', 'STELLA MC CARTNEY');
INSERT INTO `lang_phrase` VALUES ('4258', '3', '6', 'title', '693', 'STELLA MC CARTNEY', 'STELLA MC CARTNEY');
INSERT INTO `lang_phrase` VALUES ('4259', '1', '6', 'title', '694', 'STETSON', 'STETSON');
INSERT INTO `lang_phrase` VALUES ('4260', '2', '6', 'title', '694', 'STETSON', 'STETSON');
INSERT INTO `lang_phrase` VALUES ('4261', '3', '6', 'title', '694', 'STETSON', 'STETSON');
INSERT INTO `lang_phrase` VALUES ('4262', '1', '6', 'title', '695', 'STUART WEITZMAN', 'STUART WEITZMAN');
INSERT INTO `lang_phrase` VALUES ('4263', '2', '6', 'title', '695', 'STUART WEITZMAN', 'STUART WEITZMAN');
INSERT INTO `lang_phrase` VALUES ('4264', '3', '6', 'title', '695', 'STUART WEITZMAN', 'STUART WEITZMAN');
INSERT INTO `lang_phrase` VALUES ('4265', '1', '6', 'title', '696', 'STUDIO MAKE UP', 'STUDIO MAKE UP');
INSERT INTO `lang_phrase` VALUES ('4266', '2', '6', 'title', '696', 'STUDIO MAKE UP', 'STUDIO MAKE UP');
INSERT INTO `lang_phrase` VALUES ('4267', '3', '6', 'title', '696', 'STUDIO MAKE UP', 'STUDIO MAKE UP');
INSERT INTO `lang_phrase` VALUES ('4268', '1', '6', 'title', '697', 'SUD EXPRESS', 'SUD EXPRESS');
INSERT INTO `lang_phrase` VALUES ('4269', '2', '6', 'title', '697', 'SUD EXPRESS', 'SUD EXPRESS');
INSERT INTO `lang_phrase` VALUES ('4270', '3', '6', 'title', '697', 'SUD EXPRESS', 'SUD EXPRESS');
INSERT INTO `lang_phrase` VALUES ('4271', '1', '6', 'title', '698', 'SUNCOO', 'SUNCOO');
INSERT INTO `lang_phrase` VALUES ('4272', '2', '6', 'title', '698', 'SUNCOO', 'SUNCOO');
INSERT INTO `lang_phrase` VALUES ('4273', '3', '6', 'title', '698', 'SUNCOO', 'SUNCOO');
INSERT INTO `lang_phrase` VALUES ('4274', '1', '6', 'title', '699', 'SWAROVSKI', 'SWAROVSKI');
INSERT INTO `lang_phrase` VALUES ('4275', '2', '6', 'title', '699', 'SWAROVSKI', 'SWAROVSKI');
INSERT INTO `lang_phrase` VALUES ('4276', '3', '6', 'title', '699', 'SWAROVSKI', 'SWAROVSKI');
INSERT INTO `lang_phrase` VALUES ('4277', '1', '6', 'title', '700', 'SWATCH', 'SWATCH');
INSERT INTO `lang_phrase` VALUES ('4278', '2', '6', 'title', '700', 'SWATCH', 'SWATCH');
INSERT INTO `lang_phrase` VALUES ('4279', '3', '6', 'title', '700', 'SWATCH', 'SWATCH');
INSERT INTO `lang_phrase` VALUES ('4280', '1', '6', 'title', '701', 'SYLVANIAN', 'SYLVANIAN');
INSERT INTO `lang_phrase` VALUES ('4281', '2', '6', 'title', '701', 'SYLVANIAN', 'SYLVANIAN');
INSERT INTO `lang_phrase` VALUES ('4282', '3', '6', 'title', '701', 'SYLVANIAN', 'SYLVANIAN');
INSERT INTO `lang_phrase` VALUES ('4283', '1', '6', 'title', '702', 'T TAG HEUER', 'T TAG HEUER');
INSERT INTO `lang_phrase` VALUES ('4284', '2', '6', 'title', '702', 'T TAG HEUER', 'T TAG HEUER');
INSERT INTO `lang_phrase` VALUES ('4285', '3', '6', 'title', '702', 'T TAG HEUER', 'T TAG HEUER');
INSERT INTO `lang_phrase` VALUES ('4286', '1', '6', 'title', '703', 'TARA JARMON', 'TARA JARMON');
INSERT INTO `lang_phrase` VALUES ('4287', '2', '6', 'title', '703', 'TARA JARMON', 'TARA JARMON');
INSERT INTO `lang_phrase` VALUES ('4288', '3', '6', 'title', '703', 'TARA JARMON', 'TARA JARMON');
INSERT INTO `lang_phrase` VALUES ('4289', '1', '6', 'title', '704', 'TARTINE ET CHOCOLAT', 'TARTINE ET CHOCOLAT');
INSERT INTO `lang_phrase` VALUES ('4290', '2', '6', 'title', '704', 'TARTINE ET CHOCOLAT', 'TARTINE ET CHOCOLAT');
INSERT INTO `lang_phrase` VALUES ('4291', '3', '6', 'title', '704', 'TARTINE ET CHOCOLAT', 'TARTINE ET CHOCOLAT');
INSERT INTO `lang_phrase` VALUES ('4292', '1', '6', 'title', '705', 'TED BAKER', 'TED BAKER');
INSERT INTO `lang_phrase` VALUES ('4293', '2', '6', 'title', '705', 'TED BAKER', 'TED BAKER');
INSERT INTO `lang_phrase` VALUES ('4294', '3', '6', 'title', '705', 'TED BAKER', 'TED BAKER');
INSERT INTO `lang_phrase` VALUES ('4295', '1', '6', 'title', '706', 'TEDDY SMITH', 'TEDDY SMITH');
INSERT INTO `lang_phrase` VALUES ('4296', '2', '6', 'title', '706', 'TEDDY SMITH', 'TEDDY SMITH');
INSERT INTO `lang_phrase` VALUES ('4297', '3', '6', 'title', '706', 'TEDDY SMITH', 'TEDDY SMITH');
INSERT INTO `lang_phrase` VALUES ('4298', '1', '6', 'title', '707', 'TEFAL', 'TEFAL');
INSERT INTO `lang_phrase` VALUES ('4299', '2', '6', 'title', '707', 'TEFAL', 'TEFAL');
INSERT INTO `lang_phrase` VALUES ('4300', '3', '6', 'title', '707', 'TEFAL', 'TEFAL');
INSERT INTO `lang_phrase` VALUES ('4301', '1', '6', 'title', '708', 'THE KOOPLES', 'THE KOOPLES');
INSERT INTO `lang_phrase` VALUES ('4302', '2', '6', 'title', '708', 'THE KOOPLES', 'THE KOOPLES');
INSERT INTO `lang_phrase` VALUES ('4303', '3', '6', 'title', '708', 'THE KOOPLES', 'THE KOOPLES');
INSERT INTO `lang_phrase` VALUES ('4304', '1', '6', 'title', '709', 'THE KOOPLES SPORT', 'THE KOOPLES SPORT');
INSERT INTO `lang_phrase` VALUES ('4305', '2', '6', 'title', '709', 'THE KOOPLES SPORT', 'THE KOOPLES SPORT');
INSERT INTO `lang_phrase` VALUES ('4306', '3', '6', 'title', '709', 'THE KOOPLES SPORT', 'THE KOOPLES SPORT');
INSERT INTO `lang_phrase` VALUES ('4307', '1', '6', 'title', '710', 'THEORY', 'THEORY');
INSERT INTO `lang_phrase` VALUES ('4308', '2', '6', 'title', '710', 'THEORY', 'THEORY');
INSERT INTO `lang_phrase` VALUES ('4309', '3', '6', 'title', '710', 'THEORY', 'THEORY');
INSERT INTO `lang_phrase` VALUES ('4310', '1', '6', 'title', '711', 'THERMOS', 'THERMOS');
INSERT INTO `lang_phrase` VALUES ('4311', '2', '6', 'title', '711', 'THERMOS', 'THERMOS');
INSERT INTO `lang_phrase` VALUES ('4312', '3', '6', 'title', '711', 'THERMOS', 'THERMOS');
INSERT INTO `lang_phrase` VALUES ('4313', '1', '6', 'title', '712', 'THIERRY MUGLER', 'THIERRY MUGLER');
INSERT INTO `lang_phrase` VALUES ('4314', '2', '6', 'title', '712', 'THIERRY MUGLER', 'THIERRY MUGLER');
INSERT INTO `lang_phrase` VALUES ('4315', '3', '6', 'title', '712', 'THIERRY MUGLER', 'THIERRY MUGLER');
INSERT INTO `lang_phrase` VALUES ('4316', '1', '6', 'title', '713', 'THOMAS SABO', 'THOMAS SABO');
INSERT INTO `lang_phrase` VALUES ('4317', '2', '6', 'title', '713', 'THOMAS SABO', 'THOMAS SABO');
INSERT INTO `lang_phrase` VALUES ('4318', '3', '6', 'title', '713', 'THOMAS SABO', 'THOMAS SABO');
INSERT INTO `lang_phrase` VALUES ('4319', '1', '6', 'title', '714', 'TIFFANY & CO', 'TIFFANY & CO');
INSERT INTO `lang_phrase` VALUES ('4320', '2', '6', 'title', '714', 'TIFFANY & CO', 'TIFFANY & CO');
INSERT INTO `lang_phrase` VALUES ('4321', '3', '6', 'title', '714', 'TIFFANY & CO', 'TIFFANY & CO');
INSERT INTO `lang_phrase` VALUES ('4322', '1', '6', 'title', '715', 'TIGER OF SWEDEN', 'TIGER OF SWEDEN');
INSERT INTO `lang_phrase` VALUES ('4323', '2', '6', 'title', '715', 'TIGER OF SWEDEN', 'TIGER OF SWEDEN');
INSERT INTO `lang_phrase` VALUES ('4324', '3', '6', 'title', '715', 'TIGER OF SWEDEN', 'TIGER OF SWEDEN');
INSERT INTO `lang_phrase` VALUES ('4325', '1', '6', 'title', '716', 'TIMBERLAND', 'TIMBERLAND');
INSERT INTO `lang_phrase` VALUES ('4326', '2', '6', 'title', '716', 'TIMBERLAND', 'TIMBERLAND');
INSERT INTO `lang_phrase` VALUES ('4327', '3', '6', 'title', '716', 'TIMBERLAND', 'TIMBERLAND');
INSERT INTO `lang_phrase` VALUES ('4328', '1', '6', 'title', '717', 'TISSOT', 'TISSOT');
INSERT INTO `lang_phrase` VALUES ('4329', '2', '6', 'title', '717', 'TISSOT', 'TISSOT');
INSERT INTO `lang_phrase` VALUES ('4330', '3', '6', 'title', '717', 'TISSOT', 'TISSOT');
INSERT INTO `lang_phrase` VALUES ('4331', '1', '6', 'title', '718', 'TOD’S', 'TOD’S');
INSERT INTO `lang_phrase` VALUES ('4332', '2', '6', 'title', '718', 'TOD’S', 'TOD’S');
INSERT INTO `lang_phrase` VALUES ('4333', '3', '6', 'title', '718', 'TOD’S', 'TOD’S');
INSERT INTO `lang_phrase` VALUES ('4334', '1', '6', 'title', '719', 'TOKYO DESIGN', 'TOKYO DESIGN');
INSERT INTO `lang_phrase` VALUES ('4335', '2', '6', 'title', '719', 'TOKYO DESIGN', 'TOKYO DESIGN');
INSERT INTO `lang_phrase` VALUES ('4336', '3', '6', 'title', '719', 'TOKYO DESIGN', 'TOKYO DESIGN');
INSERT INTO `lang_phrase` VALUES ('4337', '1', '6', 'title', '720', 'TOM FORD', 'TOM FORD');
INSERT INTO `lang_phrase` VALUES ('4338', '2', '6', 'title', '720', 'TOM FORD', 'TOM FORD');
INSERT INTO `lang_phrase` VALUES ('4339', '3', '6', 'title', '720', 'TOM FORD', 'TOM FORD');
INSERT INTO `lang_phrase` VALUES ('4340', '1', '6', 'title', '721', 'TOMMY HILFIGER', 'TOMMY HILFIGER');
INSERT INTO `lang_phrase` VALUES ('4341', '2', '6', 'title', '721', 'TOMMY HILFIGER', 'TOMMY HILFIGER');
INSERT INTO `lang_phrase` VALUES ('4342', '3', '6', 'title', '721', 'TOMMY HILFIGER', 'TOMMY HILFIGER');
INSERT INTO `lang_phrase` VALUES ('4343', '1', '6', 'title', '722', 'TOO COOL FOR SCHOOL', 'TOO COOL FOR SCHOOL');
INSERT INTO `lang_phrase` VALUES ('4344', '2', '6', 'title', '722', 'TOO COOL FOR SCHOOL', 'TOO COOL FOR SCHOOL');
INSERT INTO `lang_phrase` VALUES ('4345', '3', '6', 'title', '722', 'TOO COOL FOR SCHOOL', 'TOO COOL FOR SCHOOL');
INSERT INTO `lang_phrase` VALUES ('4346', '1', '6', 'title', '723', 'TOPSHOP', 'TOPSHOP');
INSERT INTO `lang_phrase` VALUES ('4347', '2', '6', 'title', '723', 'TOPSHOP', 'TOPSHOP');
INSERT INTO `lang_phrase` VALUES ('4348', '3', '6', 'title', '723', 'TOPSHOP', 'TOPSHOP');
INSERT INTO `lang_phrase` VALUES ('4349', '1', '6', 'title', '724', 'TORY BURCH', 'TORY BURCH');
INSERT INTO `lang_phrase` VALUES ('4350', '2', '6', 'title', '724', 'TORY BURCH', 'TORY BURCH');
INSERT INTO `lang_phrase` VALUES ('4351', '3', '6', 'title', '724', 'TORY BURCH', 'TORY BURCH');
INSERT INTO `lang_phrase` VALUES ('4352', '1', '6', 'title', '725', 'TRECA', 'TRECA');
INSERT INTO `lang_phrase` VALUES ('4353', '2', '6', 'title', '725', 'TRECA', 'TRECA');
INSERT INTO `lang_phrase` VALUES ('4354', '3', '6', 'title', '725', 'TRECA', 'TRECA');
INSERT INTO `lang_phrase` VALUES ('4355', '1', '6', 'title', '726', 'TRIUMPH', 'TRIUMPH');
INSERT INTO `lang_phrase` VALUES ('4356', '2', '6', 'title', '726', 'TRIUMPH', 'TRIUMPH');
INSERT INTO `lang_phrase` VALUES ('4357', '3', '6', 'title', '726', 'TRIUMPH', 'TRIUMPH');
INSERT INTO `lang_phrase` VALUES ('4358', '1', '6', 'title', '727', 'TROIZENFANTS', 'TROIZENFANTS');
INSERT INTO `lang_phrase` VALUES ('4359', '2', '6', 'title', '727', 'TROIZENFANTS', 'TROIZENFANTS');
INSERT INTO `lang_phrase` VALUES ('4360', '3', '6', 'title', '727', 'TROIZENFANTS', 'TROIZENFANTS');
INSERT INTO `lang_phrase` VALUES ('4361', '1', '6', 'title', '728', 'TRUSSARDI', 'TRUSSARDI');
INSERT INTO `lang_phrase` VALUES ('4362', '2', '6', 'title', '728', 'TRUSSARDI', 'TRUSSARDI');
INSERT INTO `lang_phrase` VALUES ('4363', '3', '6', 'title', '728', 'TRUSSARDI', 'TRUSSARDI');
INSERT INTO `lang_phrase` VALUES ('4364', '1', '6', 'title', '729', 'TUDOR', 'TUDOR');
INSERT INTO `lang_phrase` VALUES ('4365', '2', '6', 'title', '729', 'TUDOR', 'TUDOR');
INSERT INTO `lang_phrase` VALUES ('4366', '3', '6', 'title', '729', 'TUDOR', 'TUDOR');
INSERT INTO `lang_phrase` VALUES ('4367', '1', '6', 'title', '730', 'TUMI', 'TUMI');
INSERT INTO `lang_phrase` VALUES ('4368', '2', '6', 'title', '730', 'TUMI', 'TUMI');
INSERT INTO `lang_phrase` VALUES ('4369', '3', '6', 'title', '730', 'TUMI', 'TUMI');
INSERT INTO `lang_phrase` VALUES ('4370', '1', '6', 'title', '731', 'TURPAULT', 'TURPAULT');
INSERT INTO `lang_phrase` VALUES ('4371', '2', '6', 'title', '731', 'TURPAULT', 'TURPAULT');
INSERT INTO `lang_phrase` VALUES ('4372', '3', '6', 'title', '731', 'TURPAULT', 'TURPAULT');
INSERT INTO `lang_phrase` VALUES ('4373', '1', '6', 'title', '732', 'TY BEANNIE BOOS', 'TY BEANNIE BOOS');
INSERT INTO `lang_phrase` VALUES ('4374', '2', '6', 'title', '732', 'TY BEANNIE BOOS', 'TY BEANNIE BOOS');
INSERT INTO `lang_phrase` VALUES ('4375', '3', '6', 'title', '732', 'TY BEANNIE BOOS', 'TY BEANNIE BOOS');
INSERT INTO `lang_phrase` VALUES ('4376', '1', '6', 'title', '733', 'UGG', 'UGG');
INSERT INTO `lang_phrase` VALUES ('4377', '2', '6', 'title', '733', 'UGG', 'UGG');
INSERT INTO `lang_phrase` VALUES ('4378', '3', '6', 'title', '733', 'UGG', 'UGG');
INSERT INTO `lang_phrase` VALUES ('4379', '1', '6', 'title', '734', 'ULYSSE NARDIN', 'ULYSSE NARDIN');
INSERT INTO `lang_phrase` VALUES ('4380', '2', '6', 'title', '734', 'ULYSSE NARDIN', 'ULYSSE NARDIN');
INSERT INTO `lang_phrase` VALUES ('4381', '3', '6', 'title', '734', 'ULYSSE NARDIN', 'ULYSSE NARDIN');
INSERT INTO `lang_phrase` VALUES ('4382', '1', '6', 'title', '735', 'UNITED NUDE', 'UNITED NUDE');
INSERT INTO `lang_phrase` VALUES ('4383', '2', '6', 'title', '735', 'UNITED NUDE', 'UNITED NUDE');
INSERT INTO `lang_phrase` VALUES ('4384', '3', '6', 'title', '735', 'UNITED NUDE', 'UNITED NUDE');
INSERT INTO `lang_phrase` VALUES ('4385', '1', '6', 'title', '736', 'URBAN OUTFITTERS', 'URBAN OUTFITTERS');
INSERT INTO `lang_phrase` VALUES ('4386', '2', '6', 'title', '736', 'URBAN OUTFITTERS', 'URBAN OUTFITTERS');
INSERT INTO `lang_phrase` VALUES ('4387', '3', '6', 'title', '736', 'URBAN OUTFITTERS', 'URBAN OUTFITTERS');
INSERT INTO `lang_phrase` VALUES ('4388', '1', '6', 'title', '737', 'VACHERON CONSTANTIN', 'VACHERON CONSTANTIN');
INSERT INTO `lang_phrase` VALUES ('4389', '2', '6', 'title', '737', 'VACHERON CONSTANTIN', 'VACHERON CONSTANTIN');
INSERT INTO `lang_phrase` VALUES ('4390', '3', '6', 'title', '737', 'VACHERON CONSTANTIN', 'VACHERON CONSTANTIN');
INSERT INTO `lang_phrase` VALUES ('4391', '1', '6', 'title', '738', 'VALENTINO', 'VALENTINO');
INSERT INTO `lang_phrase` VALUES ('4392', '2', '6', 'title', '738', 'VALENTINO', 'VALENTINO');
INSERT INTO `lang_phrase` VALUES ('4393', '3', '6', 'title', '738', 'VALENTINO', 'VALENTINO');
INSERT INTO `lang_phrase` VALUES ('4394', '1', '6', 'title', '739', 'VALEXTRA', 'VALEXTRA');
INSERT INTO `lang_phrase` VALUES ('4395', '2', '6', 'title', '739', 'VALEXTRA', 'VALEXTRA');
INSERT INTO `lang_phrase` VALUES ('4396', '3', '6', 'title', '739', 'VALEXTRA', 'VALEXTRA');
INSERT INTO `lang_phrase` VALUES ('4397', '1', '6', 'title', '740', 'VAN CLEEF & ARPELS', 'VAN CLEEF & ARPELS');
INSERT INTO `lang_phrase` VALUES ('4398', '2', '6', 'title', '740', 'VAN CLEEF & ARPELS', 'VAN CLEEF & ARPELS');
INSERT INTO `lang_phrase` VALUES ('4399', '3', '6', 'title', '740', 'VAN CLEEF & ARPELS', 'VAN CLEEF & ARPELS');
INSERT INTO `lang_phrase` VALUES ('4400', '1', '6', 'title', '741', 'VAN LAACK', 'VAN LAACK');
INSERT INTO `lang_phrase` VALUES ('4401', '2', '6', 'title', '741', 'VAN LAACK', 'VAN LAACK');
INSERT INTO `lang_phrase` VALUES ('4402', '3', '6', 'title', '741', 'VAN LAACK', 'VAN LAACK');
INSERT INTO `lang_phrase` VALUES ('4403', '1', '6', 'title', '742', 'VAN’S', 'VAN’S');
INSERT INTO `lang_phrase` VALUES ('4404', '2', '6', 'title', '742', 'VAN’S', 'VAN’S');
INSERT INTO `lang_phrase` VALUES ('4405', '3', '6', 'title', '742', 'VAN’S', 'VAN’S');
INSERT INTO `lang_phrase` VALUES ('4406', '1', '6', 'title', '743', 'VANESSA BRUNO', 'VANESSA BRUNO');
INSERT INTO `lang_phrase` VALUES ('4407', '2', '6', 'title', '743', 'VANESSA BRUNO', 'VANESSA BRUNO');
INSERT INTO `lang_phrase` VALUES ('4408', '3', '6', 'title', '743', 'VANESSA BRUNO', 'VANESSA BRUNO');
INSERT INTO `lang_phrase` VALUES ('4409', '1', '6', 'title', '744', 'VANITY FAIR', 'VANITY FAIR');
INSERT INTO `lang_phrase` VALUES ('4410', '2', '6', 'title', '744', 'VANITY FAIR', 'VANITY FAIR');
INSERT INTO `lang_phrase` VALUES ('4411', '3', '6', 'title', '744', 'VANITY FAIR', 'VANITY FAIR');
INSERT INTO `lang_phrase` VALUES ('4412', '1', '6', 'title', '745', 'VERSACE', 'VERSACE');
INSERT INTO `lang_phrase` VALUES ('4413', '2', '6', 'title', '745', 'VERSACE', 'VERSACE');
INSERT INTO `lang_phrase` VALUES ('4414', '3', '6', 'title', '745', 'VERSACE', 'VERSACE');
INSERT INTO `lang_phrase` VALUES ('4415', '1', '6', 'title', '746', 'VERTU', 'VERTU');
INSERT INTO `lang_phrase` VALUES ('4416', '2', '6', 'title', '746', 'VERTU', 'VERTU');
INSERT INTO `lang_phrase` VALUES ('4417', '3', '6', 'title', '746', 'VERTU', 'VERTU');
INSERT INTO `lang_phrase` VALUES ('4418', '1', '6', 'title', '747', 'VICOMTE ARTHUR', 'VICOMTE ARTHUR');
INSERT INTO `lang_phrase` VALUES ('4419', '2', '6', 'title', '747', 'VICOMTE ARTHUR', 'VICOMTE ARTHUR');
INSERT INTO `lang_phrase` VALUES ('4420', '3', '6', 'title', '747', 'VICOMTE ARTHUR', 'VICOMTE ARTHUR');
INSERT INTO `lang_phrase` VALUES ('4421', '1', '6', 'title', '748', 'VICTORIA BECKHAM', 'VICTORIA BECKHAM');
INSERT INTO `lang_phrase` VALUES ('4422', '2', '6', 'title', '748', 'VICTORIA BECKHAM', 'VICTORIA BECKHAM');
INSERT INTO `lang_phrase` VALUES ('4423', '3', '6', 'title', '748', 'VICTORIA BECKHAM', 'VICTORIA BECKHAM');
INSERT INTO `lang_phrase` VALUES ('4424', '1', '6', 'title', '749', 'VICTORINOX', 'VICTORINOX');
INSERT INTO `lang_phrase` VALUES ('4425', '2', '6', 'title', '749', 'VICTORINOX', 'VICTORINOX');
INSERT INTO `lang_phrase` VALUES ('4426', '3', '6', 'title', '749', 'VICTORINOX', 'VICTORINOX');
INSERT INTO `lang_phrase` VALUES ('4427', '1', '6', 'title', '750', 'VIKTOR & ROLF', 'VIKTOR & ROLF');
INSERT INTO `lang_phrase` VALUES ('4428', '2', '6', 'title', '750', 'VIKTOR & ROLF', 'VIKTOR & ROLF');
INSERT INTO `lang_phrase` VALUES ('4429', '3', '6', 'title', '750', 'VIKTOR & ROLF', 'VIKTOR & ROLF');
INSERT INTO `lang_phrase` VALUES ('4430', '1', '6', 'title', '751', 'VILLEROY ET BOCH', 'VILLEROY ET BOCH');
INSERT INTO `lang_phrase` VALUES ('4431', '2', '6', 'title', '751', 'VILLEROY ET BOCH', 'VILLEROY ET BOCH');
INSERT INTO `lang_phrase` VALUES ('4432', '3', '6', 'title', '751', 'VILLEROY ET BOCH', 'VILLEROY ET BOCH');
INSERT INTO `lang_phrase` VALUES ('4433', '1', '6', 'title', '752', 'VIVARAISE', 'VIVARAISE');
INSERT INTO `lang_phrase` VALUES ('4434', '2', '6', 'title', '752', 'VIVARAISE', 'VIVARAISE');
INSERT INTO `lang_phrase` VALUES ('4435', '3', '6', 'title', '752', 'VIVARAISE', 'VIVARAISE');
INSERT INTO `lang_phrase` VALUES ('4436', '1', '6', 'title', '753', 'VIVIENNE WESTWOOD', 'VIVIENNE WESTWOOD');
INSERT INTO `lang_phrase` VALUES ('4437', '2', '6', 'title', '753', 'VIVIENNE WESTWOOD', 'VIVIENNE WESTWOOD');
INSERT INTO `lang_phrase` VALUES ('4438', '3', '6', 'title', '753', 'VIVIENNE WESTWOOD', 'VIVIENNE WESTWOOD');
INSERT INTO `lang_phrase` VALUES ('4439', '1', '6', 'title', '754', 'VOLCOM', 'VOLCOM');
INSERT INTO `lang_phrase` VALUES ('4440', '2', '6', 'title', '754', 'VOLCOM', 'VOLCOM');
INSERT INTO `lang_phrase` VALUES ('4441', '3', '6', 'title', '754', 'VOLCOM', 'VOLCOM');
INSERT INTO `lang_phrase` VALUES ('4442', '1', '6', 'title', '755', 'VTECH', 'VTECH');
INSERT INTO `lang_phrase` VALUES ('4443', '2', '6', 'title', '755', 'VTECH', 'VTECH');
INSERT INTO `lang_phrase` VALUES ('4444', '3', '6', 'title', '755', 'VTECH', 'VTECH');
INSERT INTO `lang_phrase` VALUES ('4445', '1', '6', 'title', '756', 'VUE PANORAMIQUE', 'VUE PANORAMIQUE');
INSERT INTO `lang_phrase` VALUES ('4446', '2', '6', 'title', '756', 'VUE PANORAMIQUE', 'VUE PANORAMIQUE');
INSERT INTO `lang_phrase` VALUES ('4447', '3', '6', 'title', '756', 'VUE PANORAMIQUE', 'VUE PANORAMIQUE');
INSERT INTO `lang_phrase` VALUES ('4448', '1', '6', 'title', '757', 'VULLI', 'VULLI');
INSERT INTO `lang_phrase` VALUES ('4449', '2', '6', 'title', '757', 'VULLI', 'VULLI');
INSERT INTO `lang_phrase` VALUES ('4450', '3', '6', 'title', '757', 'VULLI', 'VULLI');
INSERT INTO `lang_phrase` VALUES ('4451', '1', '6', 'title', '758', 'WACOAL', 'WACOAL');
INSERT INTO `lang_phrase` VALUES ('4452', '2', '6', 'title', '758', 'WACOAL', 'WACOAL');
INSERT INTO `lang_phrase` VALUES ('4453', '3', '6', 'title', '758', 'WACOAL', 'WACOAL');
INSERT INTO `lang_phrase` VALUES ('4454', '1', '6', 'title', '759', 'WATERMAN', 'WATERMAN');
INSERT INTO `lang_phrase` VALUES ('4455', '2', '6', 'title', '759', 'WATERMAN', 'WATERMAN');
INSERT INTO `lang_phrase` VALUES ('4456', '3', '6', 'title', '759', 'WATERMAN', 'WATERMAN');
INSERT INTO `lang_phrase` VALUES ('4457', '1', '6', 'title', '760', 'WEILL', 'WEILL');
INSERT INTO `lang_phrase` VALUES ('4458', '2', '6', 'title', '760', 'WEILL', 'WEILL');
INSERT INTO `lang_phrase` VALUES ('4459', '3', '6', 'title', '760', 'WEILL', 'WEILL');
INSERT INTO `lang_phrase` VALUES ('4460', '1', '6', 'title', '761', 'WELLICIOUS', 'WELLICIOUS');
INSERT INTO `lang_phrase` VALUES ('4461', '2', '6', 'title', '761', 'WELLICIOUS', 'WELLICIOUS');
INSERT INTO `lang_phrase` VALUES ('4462', '3', '6', 'title', '761', 'WELLICIOUS', 'WELLICIOUS');
INSERT INTO `lang_phrase` VALUES ('4463', '1', '6', 'title', '762', 'WESTON', 'WESTON');
INSERT INTO `lang_phrase` VALUES ('4464', '2', '6', 'title', '762', 'WESTON', 'WESTON');
INSERT INTO `lang_phrase` VALUES ('4465', '3', '6', 'title', '762', 'WESTON', 'WESTON');
INSERT INTO `lang_phrase` VALUES ('4466', '1', '6', 'title', '763', 'WHAT FOR', 'WHAT FOR');
INSERT INTO `lang_phrase` VALUES ('4467', '2', '6', 'title', '763', 'WHAT FOR', 'WHAT FOR');
INSERT INTO `lang_phrase` VALUES ('4468', '3', '6', 'title', '763', 'WHAT FOR', 'WHAT FOR');
INSERT INTO `lang_phrase` VALUES ('4469', '1', '6', 'title', '764', 'WINKLER', 'WINKLER');
INSERT INTO `lang_phrase` VALUES ('4470', '2', '6', 'title', '764', 'WINKLER', 'WINKLER');
INSERT INTO `lang_phrase` VALUES ('4471', '3', '6', 'title', '764', 'WINKLER', 'WINKLER');
INSERT INTO `lang_phrase` VALUES ('4472', '1', '6', 'title', '765', 'WISMER', 'WISMER');
INSERT INTO `lang_phrase` VALUES ('4473', '2', '6', 'title', '765', 'WISMER', 'WISMER');
INSERT INTO `lang_phrase` VALUES ('4474', '3', '6', 'title', '765', 'WISMER', 'WISMER');
INSERT INTO `lang_phrase` VALUES ('4475', '1', '6', 'title', '766', 'WOLFORD', 'WOLFORD');
INSERT INTO `lang_phrase` VALUES ('4476', '2', '6', 'title', '766', 'WOLFORD', 'WOLFORD');
INSERT INTO `lang_phrase` VALUES ('4477', '3', '6', 'title', '766', 'WOLFORD', 'WOLFORD');
INSERT INTO `lang_phrase` VALUES ('4478', '1', '6', 'title', '767', 'WOLY', 'WOLY');
INSERT INTO `lang_phrase` VALUES ('4479', '2', '6', 'title', '767', 'WOLY', 'WOLY');
INSERT INTO `lang_phrase` VALUES ('4480', '3', '6', 'title', '767', 'WOLY', 'WOLY');
INSERT INTO `lang_phrase` VALUES ('4481', '1', '6', 'title', '768', 'WONDERBRA', 'WONDERBRA');
INSERT INTO `lang_phrase` VALUES ('4482', '2', '6', 'title', '768', 'WONDERBRA', 'WONDERBRA');
INSERT INTO `lang_phrase` VALUES ('4483', '3', '6', 'title', '768', 'WONDERBRA', 'WONDERBRA');
INSERT INTO `lang_phrase` VALUES ('4484', '1', '6', 'title', '769', 'WOOLRICH', 'WOOLRICH');
INSERT INTO `lang_phrase` VALUES ('4485', '2', '6', 'title', '769', 'WOOLRICH', 'WOOLRICH');
INSERT INTO `lang_phrase` VALUES ('4486', '3', '6', 'title', '769', 'WOOLRICH', 'WOOLRICH');
INSERT INTO `lang_phrase` VALUES ('4487', '1', '6', 'title', '770', 'Y Y3', 'Y Y3');
INSERT INTO `lang_phrase` VALUES ('4488', '2', '6', 'title', '770', 'Y Y3', 'Y Y3');
INSERT INTO `lang_phrase` VALUES ('4489', '3', '6', 'title', '770', 'Y Y3', 'Y Y3');
INSERT INTO `lang_phrase` VALUES ('4490', '1', '6', 'title', '771', 'YAM', 'YAM');
INSERT INTO `lang_phrase` VALUES ('4491', '2', '6', 'title', '771', 'YAM', 'YAM');
INSERT INTO `lang_phrase` VALUES ('4492', '3', '6', 'title', '771', 'YAM', 'YAM');
INSERT INTO `lang_phrase` VALUES ('4493', '1', '6', 'title', '772', 'YEEZY BY ADIDAS', 'YEEZY BY ADIDAS');
INSERT INTO `lang_phrase` VALUES ('4494', '2', '6', 'title', '772', 'YEEZY BY ADIDAS', 'YEEZY BY ADIDAS');
INSERT INTO `lang_phrase` VALUES ('4495', '3', '6', 'title', '772', 'YEEZY BY ADIDAS', 'YEEZY BY ADIDAS');
INSERT INTO `lang_phrase` VALUES ('4496', '1', '6', 'title', '773', 'YEP', 'YEP');
INSERT INTO `lang_phrase` VALUES ('4497', '2', '6', 'title', '773', 'YEP', 'YEP');
INSERT INTO `lang_phrase` VALUES ('4498', '3', '6', 'title', '773', 'YEP', 'YEP');
INSERT INTO `lang_phrase` VALUES ('4499', '1', '6', 'title', '774', 'YOGA SEARCHER', 'YOGA SEARCHER');
INSERT INTO `lang_phrase` VALUES ('4500', '2', '6', 'title', '774', 'YOGA SEARCHER', 'YOGA SEARCHER');
INSERT INTO `lang_phrase` VALUES ('4501', '3', '6', 'title', '774', 'YOGA SEARCHER', 'YOGA SEARCHER');
INSERT INTO `lang_phrase` VALUES ('4502', '1', '6', 'title', '775', 'YUJ', 'YUJ');
INSERT INTO `lang_phrase` VALUES ('4503', '2', '6', 'title', '775', 'YUJ', 'YUJ');
INSERT INTO `lang_phrase` VALUES ('4504', '3', '6', 'title', '775', 'YUJ', 'YUJ');
INSERT INTO `lang_phrase` VALUES ('4505', '1', '6', 'title', '776', 'YVES DELORME', 'YVES DELORME');
INSERT INTO `lang_phrase` VALUES ('4506', '2', '6', 'title', '776', 'YVES DELORME', 'YVES DELORME');
INSERT INTO `lang_phrase` VALUES ('4507', '3', '6', 'title', '776', 'YVES DELORME', 'YVES DELORME');
INSERT INTO `lang_phrase` VALUES ('4508', '1', '6', 'title', '777', 'YVES SALOMON', 'YVES SALOMON');
INSERT INTO `lang_phrase` VALUES ('4509', '2', '6', 'title', '777', 'YVES SALOMON', 'YVES SALOMON');
INSERT INTO `lang_phrase` VALUES ('4510', '3', '6', 'title', '777', 'YVES SALOMON', 'YVES SALOMON');
INSERT INTO `lang_phrase` VALUES ('4511', '1', '6', 'title', '778', 'Z ZADIG & VOLTAIRE', 'Z ZADIG & VOLTAIRE');
INSERT INTO `lang_phrase` VALUES ('4512', '2', '6', 'title', '778', 'Z ZADIG & VOLTAIRE', 'Z ZADIG & VOLTAIRE');
INSERT INTO `lang_phrase` VALUES ('4513', '3', '6', 'title', '778', 'Z ZADIG & VOLTAIRE', 'Z ZADIG & VOLTAIRE');
INSERT INTO `lang_phrase` VALUES ('4514', '1', '6', 'title', '779', 'ZAK', 'ZAK');
INSERT INTO `lang_phrase` VALUES ('4515', '2', '6', 'title', '779', 'ZAK', 'ZAK');
INSERT INTO `lang_phrase` VALUES ('4516', '3', '6', 'title', '779', 'ZAK', 'ZAK');
INSERT INTO `lang_phrase` VALUES ('4517', '1', '6', 'title', '780', 'ZAPA', 'ZAPA');
INSERT INTO `lang_phrase` VALUES ('4518', '2', '6', 'title', '780', 'ZAPA', 'ZAPA');
INSERT INTO `lang_phrase` VALUES ('4519', '3', '6', 'title', '780', 'ZAPA', 'ZAPA');
INSERT INTO `lang_phrase` VALUES ('4520', '1', '6', 'title', '781', 'ZARA', 'ZARA');
INSERT INTO `lang_phrase` VALUES ('4521', '2', '6', 'title', '781', 'ZARA', 'ZARA');
INSERT INTO `lang_phrase` VALUES ('4522', '3', '6', 'title', '781', 'ZARA', 'ZARA');
INSERT INTO `lang_phrase` VALUES ('4523', '1', '6', 'title', '782', 'ZEGNA', 'ZEGNA');
INSERT INTO `lang_phrase` VALUES ('4524', '2', '6', 'title', '782', 'ZEGNA', 'ZEGNA');
INSERT INTO `lang_phrase` VALUES ('4525', '3', '6', 'title', '782', 'ZEGNA', 'ZEGNA');
INSERT INTO `lang_phrase` VALUES ('4526', '1', '6', 'title', '783', 'ZENITH', 'ZENITH');
INSERT INTO `lang_phrase` VALUES ('4527', '2', '6', 'title', '783', 'ZENITH', 'ZENITH');
INSERT INTO `lang_phrase` VALUES ('4528', '3', '6', 'title', '783', 'ZENITH', 'ZENITH');
INSERT INTO `lang_phrase` VALUES ('4529', '1', '6', 'title', '784', 'ZWILLING', 'ZWILLING');
INSERT INTO `lang_phrase` VALUES ('4530', '2', '6', 'title', '784', 'ZWILLING', 'ZWILLING');
INSERT INTO `lang_phrase` VALUES ('4531', '3', '6', 'title', '784', 'ZWILLING', 'ZWILLING');
INSERT INTO `lang_phrase` VALUES ('4532', '1', '6', 'title', '785', 'Autres', 'Autres');
INSERT INTO `lang_phrase` VALUES ('4533', '2', '6', 'title', '785', 'Autres', 'Autres');
INSERT INTO `lang_phrase` VALUES ('4534', '3', '6', 'title', '785', 'Autres', 'Autres');
INSERT INTO `lang_phrase` VALUES ('4535', '1', '6', 'title', '786', '10 IS', '10 IS');
INSERT INTO `lang_phrase` VALUES ('4536', '2', '6', 'title', '786', '10 IS', '10 IS');
INSERT INTO `lang_phrase` VALUES ('4537', '3', '6', 'title', '786', '10 IS', '10 IS');
INSERT INTO `lang_phrase` VALUES ('4538', '1', '6', 'title', '787', '7 FOR ALL MANKIND', '7 FOR ALL MANKIND');
INSERT INTO `lang_phrase` VALUES ('4539', '2', '6', 'title', '787', '7 FOR ALL MANKIND', '7 FOR ALL MANKIND');
INSERT INTO `lang_phrase` VALUES ('4540', '3', '6', 'title', '787', '7 FOR ALL MANKIND', '7 FOR ALL MANKIND');
INSERT INTO `lang_phrase` VALUES ('4601', '1', '7', 'title', '1', 'Women\'s Clothing', 'Женская Одежда');
INSERT INTO `lang_phrase` VALUES ('4602', '2', '7', 'title', '1', 'Women\'s Clothing', 'Women\'s Clothing');
INSERT INTO `lang_phrase` VALUES ('4603', '3', '7', 'title', '1', 'Women\'s Clothing', 'Vêtements pour femmes');
INSERT INTO `lang_phrase` VALUES ('4604', '1', '7', 'title', '2', 'Men\'s Clothes', 'Мужская Одежда');
INSERT INTO `lang_phrase` VALUES ('4605', '2', '7', 'title', '2', 'Men\'s Clothes', 'Men\'s Clothes');
INSERT INTO `lang_phrase` VALUES ('4606', '3', '7', 'title', '2', 'Men\'s Clothes', 'Vêtements pour homme');
INSERT INTO `lang_phrase` VALUES ('4607', '1', '7', 'title', '3', 'Footwear', 'Обувь');
INSERT INTO `lang_phrase` VALUES ('4608', '2', '7', 'title', '3', 'Footwear', 'Footwear');
INSERT INTO `lang_phrase` VALUES ('4609', '3', '7', 'title', '3', 'Footwear', 'Chaussures');
INSERT INTO `lang_phrase` VALUES ('4610', '1', '7', 'title', '4', 'Accessories', 'Аксессуары');
INSERT INTO `lang_phrase` VALUES ('4611', '2', '7', 'title', '4', 'Accessories', 'Accessories');
INSERT INTO `lang_phrase` VALUES ('4612', '3', '7', 'title', '4', 'Accessories', 'Accessoires');
INSERT INTO `lang_phrase` VALUES ('4613', '1', '7', 'title', '5', 'Decorations', 'Украшения');
INSERT INTO `lang_phrase` VALUES ('4614', '2', '7', 'title', '5', 'Decorations', 'Decorations');
INSERT INTO `lang_phrase` VALUES ('4615', '3', '7', 'title', '5', 'Decorations', 'Décorations');
INSERT INTO `lang_phrase` VALUES ('4616', '1', '7', 'title', '6', 'Cosmetics & Fragrances', 'Косметика & Духи');
INSERT INTO `lang_phrase` VALUES ('4617', '2', '7', 'title', '6', 'Cosmetics & Fragrances', 'Cosmetics & Fragrances');
INSERT INTO `lang_phrase` VALUES ('4618', '3', '7', 'title', '6', 'Cosmetics & Fragrances', 'Cosmétiques et Parfums');
INSERT INTO `lang_phrase` VALUES ('4619', '1', '7', 'title', '7', 'Household products', 'Товары для дома');
INSERT INTO `lang_phrase` VALUES ('4620', '2', '7', 'title', '7', 'Household products', 'Household products');
INSERT INTO `lang_phrase` VALUES ('4621', '3', '7', 'title', '7', 'Household products', 'Linge de maison');
INSERT INTO `lang_phrase` VALUES ('4622', '1', '7', 'title', '8', 'Smartphones', 'Смартфоны');
INSERT INTO `lang_phrase` VALUES ('4623', '2', '7', 'title', '8', 'Smartphones', 'Smartphones');
INSERT INTO `lang_phrase` VALUES ('4624', '3', '7', 'title', '8', 'Smartphones', 'Smartphones');
INSERT INTO `lang_phrase` VALUES ('4625', '1', '7', 'title', '9', 'Products for children', 'Товары для Детей');
INSERT INTO `lang_phrase` VALUES ('4626', '2', '7', 'title', '9', 'Products for children', 'Products for children');
INSERT INTO `lang_phrase` VALUES ('4627', '3', '7', 'title', '9', 'Products for children', 'Enfant en bas âge');
INSERT INTO `lang_phrase` VALUES ('4628', '1', '7', 'title', '10', 'Bags', 'Сумки');
INSERT INTO `lang_phrase` VALUES ('4629', '2', '7', 'title', '10', 'Bags', 'Bags');
INSERT INTO `lang_phrase` VALUES ('4630', '3', '7', 'title', '10', 'Bags', 'Sacs');
INSERT INTO `lang_phrase` VALUES ('5396', '1', '3', 'title', '1', 'Dresses', 'Платья');
INSERT INTO `lang_phrase` VALUES ('5397', '2', '3', 'title', '1', 'Dresses', 'Dresses');
INSERT INTO `lang_phrase` VALUES ('5398', '3', '3', 'title', '1', 'Dresses', 'Robes');
INSERT INTO `lang_phrase` VALUES ('5399', '1', '3', 'title', '2', 'Coat', 'Пальто');
INSERT INTO `lang_phrase` VALUES ('5400', '2', '3', 'title', '2', 'Coat', 'Coat');
INSERT INTO `lang_phrase` VALUES ('5401', '3', '3', 'title', '2', 'Coat', 'Manteaux');
INSERT INTO `lang_phrase` VALUES ('5402', '1', '3', 'title', '3', 'Jackets', 'Пуховики');
INSERT INTO `lang_phrase` VALUES ('5403', '2', '3', 'title', '3', 'Jackets', 'Jackets');
INSERT INTO `lang_phrase` VALUES ('5404', '3', '3', 'title', '3', 'Jackets', 'Vestes');
INSERT INTO `lang_phrase` VALUES ('5405', '1', '3', 'title', '4', 'Parks', 'Парки');
INSERT INTO `lang_phrase` VALUES ('5406', '2', '3', 'title', '4', 'Parks', 'Parks');
INSERT INTO `lang_phrase` VALUES ('5407', '3', '3', 'title', '4', 'Parks', 'parcs');
INSERT INTO `lang_phrase` VALUES ('5408', '1', '3', 'title', '5', 'Skirts', 'Юбки');
INSERT INTO `lang_phrase` VALUES ('5409', '2', '3', 'title', '5', 'Skirts', 'Skirts');
INSERT INTO `lang_phrase` VALUES ('5410', '3', '3', 'title', '5', 'Skirts', 'Jupes');
INSERT INTO `lang_phrase` VALUES ('5411', '1', '3', 'title', '6', 'Pants', 'Брюки');
INSERT INTO `lang_phrase` VALUES ('5412', '2', '3', 'title', '6', 'Pants', 'Pants');
INSERT INTO `lang_phrase` VALUES ('5413', '3', '3', 'title', '6', 'Pants', 'pantalon');
INSERT INTO `lang_phrase` VALUES ('5414', '1', '3', 'title', '7', 'Blouses and shirts', 'Блузы и рубашки');
INSERT INTO `lang_phrase` VALUES ('5415', '2', '3', 'title', '7', 'Blouses and shirts', 'Blouses and shirts');
INSERT INTO `lang_phrase` VALUES ('5416', '3', '3', 'title', '7', 'Blouses and shirts', 'Blouses et chemises');
INSERT INTO `lang_phrase` VALUES ('5417', '1', '3', 'title', '8', 'Jeans', 'Джинсы');
INSERT INTO `lang_phrase` VALUES ('5418', '2', '3', 'title', '8', 'Jeans', 'Jeans');
INSERT INTO `lang_phrase` VALUES ('5419', '3', '3', 'title', '8', 'Jeans', 'toile de jean');
INSERT INTO `lang_phrase` VALUES ('5420', '1', '3', 'title', '9', 'Sweaters and Knitwear', 'Свитеры и трикотаж');
INSERT INTO `lang_phrase` VALUES ('5421', '2', '3', 'title', '9', 'Sweaters and Knitwear', 'Sweaters and Knitwear');
INSERT INTO `lang_phrase` VALUES ('5422', '3', '3', 'title', '9', 'Sweaters and Knitwear', 'Pulls et Tricots');
INSERT INTO `lang_phrase` VALUES ('5423', '1', '3', 'title', '10', 'coveralls', 'Комбинезоны');
INSERT INTO `lang_phrase` VALUES ('5424', '2', '3', 'title', '10', 'coveralls', 'coveralls');
INSERT INTO `lang_phrase` VALUES ('5425', '3', '3', 'title', '10', 'coveralls', 'combinaisons');
INSERT INTO `lang_phrase` VALUES ('5426', '1', '3', 'title', '11', 'Tops', 'Топы');
INSERT INTO `lang_phrase` VALUES ('5427', '2', '3', 'title', '11', 'Tops', 'Tops');
INSERT INTO `lang_phrase` VALUES ('5428', '3', '3', 'title', '11', 'Tops', 'Tops');
INSERT INTO `lang_phrase` VALUES ('5429', '1', '3', 'title', '12', 'Underwear', 'Нижнее белье');
INSERT INTO `lang_phrase` VALUES ('5430', '2', '3', 'title', '12', 'Underwear', 'Underwear');
INSERT INTO `lang_phrase` VALUES ('5431', '3', '3', 'title', '12', 'Underwear', 'sous-vêtements');
INSERT INTO `lang_phrase` VALUES ('5432', '1', '3', 'title', '13', 'evening dresses', 'вечерние платья');
INSERT INTO `lang_phrase` VALUES ('5433', '2', '3', 'title', '13', 'evening dresses', 'evening dresses');
INSERT INTO `lang_phrase` VALUES ('5434', '3', '3', 'title', '13', 'evening dresses', 'Robes de soirée');
INSERT INTO `lang_phrase` VALUES ('5435', '1', '3', 'title', '14', 'evening skirt', 'вечерние юбки');
INSERT INTO `lang_phrase` VALUES ('5436', '2', '3', 'title', '14', 'evening skirt', 'evening skirt');
INSERT INTO `lang_phrase` VALUES ('5437', '3', '3', 'title', '14', 'evening skirt', 'Soirée Jupe');
INSERT INTO `lang_phrase` VALUES ('5438', '1', '3', 'title', '15', 'coats', 'дубленки');
INSERT INTO `lang_phrase` VALUES ('5439', '2', '3', 'title', '15', 'coats', 'coats');
INSERT INTO `lang_phrase` VALUES ('5440', '3', '3', 'title', '15', 'coats', 'manteaux');
INSERT INTO `lang_phrase` VALUES ('5441', '1', '3', 'title', '16', 'Evening blouses', 'Вечерние блузки');
INSERT INTO `lang_phrase` VALUES ('5442', '2', '3', 'title', '16', 'Evening blouses', 'Evening blouses');
INSERT INTO `lang_phrase` VALUES ('5443', '3', '3', 'title', '16', 'Evening blouses', 'blouses de soirée');
INSERT INTO `lang_phrase` VALUES ('5444', '1', '3', 'title', '17', 'cocktail dress', 'коктельные платья');
INSERT INTO `lang_phrase` VALUES ('5445', '2', '3', 'title', '17', 'cocktail dress', 'cocktail dress');
INSERT INTO `lang_phrase` VALUES ('5446', '3', '3', 'title', '17', 'cocktail dress', 'robes de cocktail');
INSERT INTO `lang_phrase` VALUES ('5447', '1', '3', 'title', '18', 'evening pants', 'вечерние штаны');
INSERT INTO `lang_phrase` VALUES ('5448', '2', '3', 'title', '18', 'evening pants', 'evening pants');
INSERT INTO `lang_phrase` VALUES ('5449', '3', '3', 'title', '18', 'evening pants', 'pantalon de soirée');
INSERT INTO `lang_phrase` VALUES ('5450', '1', '3', 'title', '19', 'swimwear', 'купальники');
INSERT INTO `lang_phrase` VALUES ('5451', '2', '3', 'title', '19', 'swimwear', 'swimwear');
INSERT INTO `lang_phrase` VALUES ('5452', '3', '3', 'title', '19', 'swimwear', 'maillots de bain');
INSERT INTO `lang_phrase` VALUES ('5453', '1', '3', 'title', '20', 'fur', 'меховые изделия');
INSERT INTO `lang_phrase` VALUES ('5454', '2', '3', 'title', '20', 'fur', 'fur');
INSERT INTO `lang_phrase` VALUES ('5455', '3', '3', 'title', '20', 'fur', 'fourrure');
INSERT INTO `lang_phrase` VALUES ('5456', '1', '3', 'title', '21', 'T-shirts', 'майки');
INSERT INTO `lang_phrase` VALUES ('5457', '2', '3', 'title', '21', 'T-shirts', 'T-shirts');
INSERT INTO `lang_phrase` VALUES ('5458', '3', '3', 'title', '21', 'T-shirts', 'T-shirts');
INSERT INTO `lang_phrase` VALUES ('5459', '1', '3', 'title', '22', 'shorts', 'шорты');
INSERT INTO `lang_phrase` VALUES ('5460', '2', '3', 'title', '22', 'shorts', 'shorts');
INSERT INTO `lang_phrase` VALUES ('5461', '3', '3', 'title', '22', 'shorts', 'short');
INSERT INTO `lang_phrase` VALUES ('5462', '1', '3', 'title', '23', 'pareos', 'парео');
INSERT INTO `lang_phrase` VALUES ('5463', '2', '3', 'title', '23', 'pareos', 'pareos');
INSERT INTO `lang_phrase` VALUES ('5464', '3', '3', 'title', '23', 'pareos', 'paréos');
INSERT INTO `lang_phrase` VALUES ('5465', '1', '3', 'title', '24', 'Shirts', 'Футболки');
INSERT INTO `lang_phrase` VALUES ('5466', '2', '3', 'title', '24', 'Shirts', 'Shirts');
INSERT INTO `lang_phrase` VALUES ('5467', '3', '3', 'title', '24', 'Shirts', 'shirts');
INSERT INTO `lang_phrase` VALUES ('5468', '1', '3', 'title', '25', 'Polo', 'Поло');
INSERT INTO `lang_phrase` VALUES ('5469', '2', '3', 'title', '25', 'Polo', 'Polo');
INSERT INTO `lang_phrase` VALUES ('5470', '3', '3', 'title', '25', 'Polo', 'polo');
INSERT INTO `lang_phrase` VALUES ('5471', '1', '3', 'title', '26', 'Costumes', 'Костюмы');
INSERT INTO `lang_phrase` VALUES ('5472', '2', '3', 'title', '26', 'Costumes', 'Costumes');
INSERT INTO `lang_phrase` VALUES ('5473', '3', '3', 'title', '26', 'Costumes', 'costumes');
INSERT INTO `lang_phrase` VALUES ('5474', '1', '3', 'title', '27', 'Underwear and socks', 'Нижнее белье и носки');
INSERT INTO `lang_phrase` VALUES ('5475', '2', '3', 'title', '27', 'Underwear and socks', 'Underwear and socks');
INSERT INTO `lang_phrase` VALUES ('5476', '3', '3', 'title', '27', 'Underwear and socks', 'Sous-vêtements et chaussettes');
INSERT INTO `lang_phrase` VALUES ('5477', '1', '3', 'title', '28', 'Blazers', 'Пиджаки');
INSERT INTO `lang_phrase` VALUES ('5478', '2', '3', 'title', '28', 'Blazers', 'Blazers');
INSERT INTO `lang_phrase` VALUES ('5479', '3', '3', 'title', '28', 'Blazers', 'Blazers');
INSERT INTO `lang_phrase` VALUES ('5480', '1', '3', 'title', '29', 'The tuxedo', 'Смокинг');
INSERT INTO `lang_phrase` VALUES ('5481', '2', '3', 'title', '29', 'The tuxedo', 'The tuxedo');
INSERT INTO `lang_phrase` VALUES ('5482', '3', '3', 'title', '29', 'The tuxedo', 'Tuxedo');
INSERT INTO `lang_phrase` VALUES ('5483', '1', '3', 'title', '30', 'Shuba', 'Шубы');
INSERT INTO `lang_phrase` VALUES ('5484', '2', '3', 'title', '30', 'Shuba', 'Shuba');
INSERT INTO `lang_phrase` VALUES ('5485', '3', '3', 'title', '30', 'Shuba', 'Shuba');
INSERT INTO `lang_phrase` VALUES ('5486', '1', '3', 'title', '31', 'Shoes', 'Туфли');
INSERT INTO `lang_phrase` VALUES ('5487', '2', '3', 'title', '31', 'Shoes', 'Shoes');
INSERT INTO `lang_phrase` VALUES ('5488', '3', '3', 'title', '31', 'Shoes', 'Chaussures');
INSERT INTO `lang_phrase` VALUES ('5489', '1', '3', 'title', '32', 'Boots and ankle boots', 'Сапоги и ботильоны');
INSERT INTO `lang_phrase` VALUES ('5490', '2', '3', 'title', '32', 'Boots and ankle boots', 'Boots and ankle boots');
INSERT INTO `lang_phrase` VALUES ('5491', '3', '3', 'title', '32', 'Boots and ankle boots', 'Bottes et bottines');
INSERT INTO `lang_phrase` VALUES ('5492', '1', '3', 'title', '33', 'Sneakers', 'Кроссовки');
INSERT INTO `lang_phrase` VALUES ('5493', '2', '3', 'title', '33', 'Sneakers', 'Sneakers');
INSERT INTO `lang_phrase` VALUES ('5494', '3', '3', 'title', '33', 'Sneakers', 'formateurs');
INSERT INTO `lang_phrase` VALUES ('5495', '1', '3', 'title', '34', 'Ballet shoes', 'Балетки');
INSERT INTO `lang_phrase` VALUES ('5496', '2', '3', 'title', '34', 'Ballet shoes', 'Ballet shoes');
INSERT INTO `lang_phrase` VALUES ('5497', '3', '3', 'title', '34', 'Ballet shoes', 'Ballerines');
INSERT INTO `lang_phrase` VALUES ('5498', '1', '3', 'title', '35', 'Lofer', 'Лоферы');
INSERT INTO `lang_phrase` VALUES ('5499', '2', '3', 'title', '35', 'Lofer', 'Lofer');
INSERT INTO `lang_phrase` VALUES ('5500', '3', '3', 'title', '35', 'Lofer', 'Lofer');
INSERT INTO `lang_phrase` VALUES ('5501', '1', '3', 'title', '36', 'sleepers', 'Слиперы');
INSERT INTO `lang_phrase` VALUES ('5502', '2', '3', 'title', '36', 'sleepers', 'sleepers');
INSERT INTO `lang_phrase` VALUES ('5503', '3', '3', 'title', '36', 'sleepers', 'Sleepers');
INSERT INTO `lang_phrase` VALUES ('5504', '1', '3', 'title', '37', 'Sport shoes', 'Спортивная обувь');
INSERT INTO `lang_phrase` VALUES ('5505', '2', '3', 'title', '37', 'Sport shoes', 'Sport shoes');
INSERT INTO `lang_phrase` VALUES ('5506', '3', '3', 'title', '37', 'Sport shoes', 'Chaussures de sport');
INSERT INTO `lang_phrase` VALUES ('5507', '1', '3', 'title', '38', 'Haytopy', 'Хайтопы');
INSERT INTO `lang_phrase` VALUES ('5508', '2', '3', 'title', '38', 'Haytopy', 'Haytopy');
INSERT INTO `lang_phrase` VALUES ('5509', '3', '3', 'title', '38', 'Haytopy', 'Haytopy');
INSERT INTO `lang_phrase` VALUES ('5510', '1', '3', 'title', '39', 'Sandals', 'Сандали');
INSERT INTO `lang_phrase` VALUES ('5511', '2', '3', 'title', '39', 'Sandals', 'Sandals');
INSERT INTO `lang_phrase` VALUES ('5512', '3', '3', 'title', '39', 'Sandals', 'sandales');
INSERT INTO `lang_phrase` VALUES ('5513', '1', '3', 'title', '40', 'espadrilles', 'Эспадрилы');
INSERT INTO `lang_phrase` VALUES ('5514', '2', '3', 'title', '40', 'espadrilles', 'espadrilles');
INSERT INTO `lang_phrase` VALUES ('5515', '3', '3', 'title', '40', 'espadrilles', 'Espadrilles');
INSERT INTO `lang_phrase` VALUES ('5516', '1', '3', 'title', '41', 'Thongs', 'Шлепанцы');
INSERT INTO `lang_phrase` VALUES ('5517', '2', '3', 'title', '41', 'Thongs', 'Thongs');
INSERT INTO `lang_phrase` VALUES ('5518', '3', '3', 'title', '41', 'Thongs', 'Tongs');
INSERT INTO `lang_phrase` VALUES ('5519', '1', '3', 'title', '42', 'Bots', 'Боты');
INSERT INTO `lang_phrase` VALUES ('5520', '2', '3', 'title', '42', 'Bots', 'Bots');
INSERT INTO `lang_phrase` VALUES ('5521', '3', '3', 'title', '42', 'Bots', 'Moteurs de recherche');
INSERT INTO `lang_phrase` VALUES ('5522', '1', '3', 'title', '43', 'Hats', 'Головные уборы');
INSERT INTO `lang_phrase` VALUES ('5523', '2', '3', 'title', '43', 'Hats', 'Hats');
INSERT INTO `lang_phrase` VALUES ('5524', '3', '3', 'title', '43', 'Hats', 'Couvre-chef');
INSERT INTO `lang_phrase` VALUES ('5525', '1', '3', 'title', '44', 'Scarves', 'Шарфы');
INSERT INTO `lang_phrase` VALUES ('5526', '2', '3', 'title', '44', 'Scarves', 'Scarves');
INSERT INTO `lang_phrase` VALUES ('5527', '3', '3', 'title', '44', 'Scarves', 'Echarpes');
INSERT INTO `lang_phrase` VALUES ('5528', '1', '3', 'title', '45', 'Gloves and mittens', 'Перчатки и варежки');
INSERT INTO `lang_phrase` VALUES ('5529', '2', '3', 'title', '45', 'Gloves and mittens', 'Gloves and mittens');
INSERT INTO `lang_phrase` VALUES ('5530', '3', '3', 'title', '45', 'Gloves and mittens', 'Gants et mitaines');
INSERT INTO `lang_phrase` VALUES ('5531', '1', '3', 'title', '46', 'Belts', 'Ремни');
INSERT INTO `lang_phrase` VALUES ('5532', '2', '3', 'title', '46', 'Belts', 'Belts');
INSERT INTO `lang_phrase` VALUES ('5533', '3', '3', 'title', '46', 'Belts', 'Ceintures');
INSERT INTO `lang_phrase` VALUES ('5534', '1', '3', 'title', '47', 'Sunglasses', 'Солнцезащитные очки');
INSERT INTO `lang_phrase` VALUES ('5535', '2', '3', 'title', '47', 'Sunglasses', 'Sunglasses');
INSERT INTO `lang_phrase` VALUES ('5536', '3', '3', 'title', '47', 'Sunglasses', 'Lunettes de soleil');
INSERT INTO `lang_phrase` VALUES ('5537', '1', '3', 'title', '48', 'Glasses and rims', 'Очки и оправы');
INSERT INTO `lang_phrase` VALUES ('5538', '2', '3', 'title', '48', 'Glasses and rims', 'Glasses and rims');
INSERT INTO `lang_phrase` VALUES ('5539', '3', '3', 'title', '48', 'Glasses and rims', 'Lunettes et jantes');
INSERT INTO `lang_phrase` VALUES ('5540', '1', '3', 'title', '49', 'neckties', 'Галстуки');
INSERT INTO `lang_phrase` VALUES ('5541', '2', '3', 'title', '49', 'neckties', 'neckties');
INSERT INTO `lang_phrase` VALUES ('5542', '3', '3', 'title', '49', 'neckties', 'Cravates');
INSERT INTO `lang_phrase` VALUES ('5543', '1', '3', 'title', '50', 'Cufflinks', 'Запонки');
INSERT INTO `lang_phrase` VALUES ('5544', '2', '3', 'title', '50', 'Cufflinks', 'Cufflinks');
INSERT INTO `lang_phrase` VALUES ('5545', '3', '3', 'title', '50', 'Cufflinks', 'Boutons de manchette');
INSERT INTO `lang_phrase` VALUES ('5546', '1', '3', 'title', '51', 'Men beauticians', 'Мужские косметички');
INSERT INTO `lang_phrase` VALUES ('5547', '2', '3', 'title', '51', 'Men beauticians', 'Men beauticians');
INSERT INTO `lang_phrase` VALUES ('5548', '3', '3', 'title', '51', 'Men beauticians', 'hommes esthéticiennes');
INSERT INTO `lang_phrase` VALUES ('5549', '1', '3', 'title', '52', 'Wallets and business card holders', 'Кошельки и визитницы');
INSERT INTO `lang_phrase` VALUES ('5550', '2', '3', 'title', '52', 'Wallets and business card holders', 'Wallets and business card holders');
INSERT INTO `lang_phrase` VALUES ('5551', '3', '3', 'title', '52', 'Wallets and business card holders', 'Portefeuilles et les détenteurs de cartes de visite');
INSERT INTO `lang_phrase` VALUES ('5552', '1', '3', 'title', '53', 'Cases for phones and tablets', 'Чехлы для телефонов и планшетов');
INSERT INTO `lang_phrase` VALUES ('5553', '2', '3', 'title', '53', 'Cases for phones and tablets', 'Cases for phones and tablets');
INSERT INTO `lang_phrase` VALUES ('5554', '3', '3', 'title', '53', 'Cases for phones and tablets', 'Étuis pour téléphones et tablettes');
INSERT INTO `lang_phrase` VALUES ('5555', '1', '3', 'title', '54', 'scarves and shawls', 'платки и шали');
INSERT INTO `lang_phrase` VALUES ('5556', '2', '3', 'title', '54', 'scarves and shawls', 'scarves and shawls');
INSERT INTO `lang_phrase` VALUES ('5557', '3', '3', 'title', '54', 'scarves and shawls', 'écharpes et châles');
INSERT INTO `lang_phrase` VALUES ('5558', '1', '3', 'title', '55', 'Lighters', 'Зажигалки');
INSERT INTO `lang_phrase` VALUES ('5559', '2', '3', 'title', '55', 'Lighters', 'Lighters');
INSERT INTO `lang_phrase` VALUES ('5560', '3', '3', 'title', '55', 'Lighters', 'Briquets');
INSERT INTO `lang_phrase` VALUES ('5561', '1', '3', 'title', '56', 'Pens', 'Ручки');
INSERT INTO `lang_phrase` VALUES ('5562', '2', '3', 'title', '56', 'Pens', 'Pens');
INSERT INTO `lang_phrase` VALUES ('5563', '3', '3', 'title', '56', 'Pens', 'poignées');
INSERT INTO `lang_phrase` VALUES ('5564', '1', '3', 'title', '57', 'Necklaces and pendants', 'Колье и подвески');
INSERT INTO `lang_phrase` VALUES ('5565', '2', '3', 'title', '57', 'Necklaces and pendants', 'Necklaces and pendants');
INSERT INTO `lang_phrase` VALUES ('5566', '3', '3', 'title', '57', 'Necklaces and pendants', 'Colliers et pendentifs');
INSERT INTO `lang_phrase` VALUES ('5567', '1', '3', 'title', '58', 'Earrings', 'Серьги');
INSERT INTO `lang_phrase` VALUES ('5568', '2', '3', 'title', '58', 'Earrings', 'Earrings');
INSERT INTO `lang_phrase` VALUES ('5569', '3', '3', 'title', '58', 'Earrings', 'Boucles d\'oreilles');
INSERT INTO `lang_phrase` VALUES ('5570', '1', '3', 'title', '59', 'Bracelets', 'Браслеты');
INSERT INTO `lang_phrase` VALUES ('5571', '2', '3', 'title', '59', 'Bracelets', 'Bracelets');
INSERT INTO `lang_phrase` VALUES ('5572', '3', '3', 'title', '59', 'Bracelets', 'Bracelets');
INSERT INTO `lang_phrase` VALUES ('5573', '1', '3', 'title', '60', 'Rings', 'Кольца');
INSERT INTO `lang_phrase` VALUES ('5574', '2', '3', 'title', '60', 'Rings', 'Rings');
INSERT INTO `lang_phrase` VALUES ('5575', '3', '3', 'title', '60', 'Rings', 'anneaux');
INSERT INTO `lang_phrase` VALUES ('5576', '1', '3', 'title', '61', 'Brooches and decorative pins', 'Броши и декоративные булавки');
INSERT INTO `lang_phrase` VALUES ('5577', '2', '3', 'title', '61', 'Brooches and decorative pins', 'Brooches and decorative pins');
INSERT INTO `lang_phrase` VALUES ('5578', '3', '3', 'title', '61', 'Brooches and decorative pins', 'Broches et épingles décoratifs');
INSERT INTO `lang_phrase` VALUES ('5579', '1', '3', 'title', '62', 'Jewelry', 'Ювелирные украшения');
INSERT INTO `lang_phrase` VALUES ('5580', '2', '3', 'title', '62', 'Jewelry', 'Jewelry');
INSERT INTO `lang_phrase` VALUES ('5581', '3', '3', 'title', '62', 'Jewelry', 'bijoux');
INSERT INTO `lang_phrase` VALUES ('5582', '1', '3', 'title', '63', 'Clock', 'Часы');
INSERT INTO `lang_phrase` VALUES ('5583', '2', '3', 'title', '63', 'Clock', 'Clock');
INSERT INTO `lang_phrase` VALUES ('5584', '3', '3', 'title', '63', 'Clock', 'Montres');
INSERT INTO `lang_phrase` VALUES ('5585', '1', '3', 'title', '64', 'Vintage ornaments', 'Винтажные украшения');
INSERT INTO `lang_phrase` VALUES ('5586', '2', '3', 'title', '64', 'Vintage ornaments', 'Vintage ornaments');
INSERT INTO `lang_phrase` VALUES ('5587', '3', '3', 'title', '64', 'Vintage ornaments', 'ornements Vintage');
INSERT INTO `lang_phrase` VALUES ('5588', '1', '3', 'title', '65', 'Category', 'Категория');
INSERT INTO `lang_phrase` VALUES ('5589', '2', '3', 'title', '65', 'Category', 'Category');
INSERT INTO `lang_phrase` VALUES ('5590', '3', '3', 'title', '65', 'Category', 'catégorie');
INSERT INTO `lang_phrase` VALUES ('5591', '1', '3', 'title', '66', 'Cufflinks (Jewelry)', 'Запонки (ювелирные изделия)');
INSERT INTO `lang_phrase` VALUES ('5592', '2', '3', 'title', '66', 'Cufflinks (Jewelry)', 'Cufflinks (Jewelry)');
INSERT INTO `lang_phrase` VALUES ('5593', '3', '3', 'title', '66', 'Cufflinks (Jewelry)', 'Boutons de manchette (Bijoux)');
INSERT INTO `lang_phrase` VALUES ('5594', '1', '3', 'title', '67', 'chain', 'Цепочки');
INSERT INTO `lang_phrase` VALUES ('5595', '2', '3', 'title', '67', 'chain', 'chain');
INSERT INTO `lang_phrase` VALUES ('5596', '3', '3', 'title', '67', 'chain', 'Chain');
INSERT INTO `lang_phrase` VALUES ('5597', '1', '3', 'title', '68', 'Ring', 'Кольцо');
INSERT INTO `lang_phrase` VALUES ('5598', '2', '3', 'title', '68', 'Ring', 'Ring');
INSERT INTO `lang_phrase` VALUES ('5599', '3', '3', 'title', '68', 'Ring', 'anneau');
INSERT INTO `lang_phrase` VALUES ('5600', '1', '3', 'title', '69', 'Spirits', 'Духи');
INSERT INTO `lang_phrase` VALUES ('5601', '2', '3', 'title', '69', 'Spirits', 'Spirits');
INSERT INTO `lang_phrase` VALUES ('5602', '3', '3', 'title', '69', 'Spirits', 'spiritueux');
INSERT INTO `lang_phrase` VALUES ('5603', '1', '3', 'title', '70', 'Pomade', 'Помада');
INSERT INTO `lang_phrase` VALUES ('5604', '2', '3', 'title', '70', 'Pomade', 'Pomade');
INSERT INTO `lang_phrase` VALUES ('5605', '3', '3', 'title', '70', 'Pomade', 'pommade');
INSERT INTO `lang_phrase` VALUES ('5606', '1', '3', 'title', '71', 'Makeup', 'Макияж');
INSERT INTO `lang_phrase` VALUES ('5607', '2', '3', 'title', '71', 'Makeup', 'Makeup');
INSERT INTO `lang_phrase` VALUES ('5608', '3', '3', 'title', '71', 'Makeup', 'composition');
INSERT INTO `lang_phrase` VALUES ('5609', '1', '3', 'title', '72', 'Powder', 'Пудра');
INSERT INTO `lang_phrase` VALUES ('5610', '2', '3', 'title', '72', 'Powder', 'Powder');
INSERT INTO `lang_phrase` VALUES ('5611', '3', '3', 'title', '72', 'Powder', 'Dust');
INSERT INTO `lang_phrase` VALUES ('5612', '1', '3', 'title', '73', 'Cream', 'Крем');
INSERT INTO `lang_phrase` VALUES ('5613', '2', '3', 'title', '73', 'Cream', 'Cream');
INSERT INTO `lang_phrase` VALUES ('5614', '3', '3', 'title', '73', 'Cream', 'crème');
INSERT INTO `lang_phrase` VALUES ('5615', '1', '3', 'title', '74', 'shadows', 'тени');
INSERT INTO `lang_phrase` VALUES ('5616', '2', '3', 'title', '74', 'shadows', 'shadows');
INSERT INTO `lang_phrase` VALUES ('5617', '3', '3', 'title', '74', 'shadows', 'ombres');
INSERT INTO `lang_phrase` VALUES ('5618', '1', '3', 'title', '75', 'rouge', 'румяна');
INSERT INTO `lang_phrase` VALUES ('5619', '2', '3', 'title', '75', 'rouge', 'rouge');
INSERT INTO `lang_phrase` VALUES ('5620', '3', '3', 'title', '75', 'rouge', 'rouge');
INSERT INTO `lang_phrase` VALUES ('5621', '1', '3', 'title', '76', 'Lotion', 'Лосьон');
INSERT INTO `lang_phrase` VALUES ('5622', '2', '3', 'title', '76', 'Lotion', 'Lotion');
INSERT INTO `lang_phrase` VALUES ('5623', '3', '3', 'title', '76', 'Lotion', 'lotion');
INSERT INTO `lang_phrase` VALUES ('5624', '1', '3', 'title', '77', 'night Cream', 'ночной крем');
INSERT INTO `lang_phrase` VALUES ('5625', '2', '3', 'title', '77', 'night Cream', 'night Cream');
INSERT INTO `lang_phrase` VALUES ('5626', '3', '3', 'title', '77', 'night Cream', 'crème de Nuit');
INSERT INTO `lang_phrase` VALUES ('5627', '1', '3', 'title', '78', 'day Cream', 'дневной крем');
INSERT INTO `lang_phrase` VALUES ('5628', '2', '3', 'title', '78', 'day Cream', 'day Cream');
INSERT INTO `lang_phrase` VALUES ('5629', '3', '3', 'title', '78', 'day Cream', 'crème de Jour');
INSERT INTO `lang_phrase` VALUES ('5630', '1', '3', 'title', '79', 'Foundation', 'тональный крем');
INSERT INTO `lang_phrase` VALUES ('5631', '2', '3', 'title', '79', 'Foundation', 'Foundation');
INSERT INTO `lang_phrase` VALUES ('5632', '3', '3', 'title', '79', 'Foundation', 'fondation');
INSERT INTO `lang_phrase` VALUES ('5633', '1', '3', 'title', '80', 'corrector', 'корректор');
INSERT INTO `lang_phrase` VALUES ('5634', '2', '3', 'title', '80', 'corrector', 'corrector');
INSERT INTO `lang_phrase` VALUES ('5635', '3', '3', 'title', '80', 'corrector', 'correcteur');
INSERT INTO `lang_phrase` VALUES ('5636', '1', '3', 'title', '81', 'scrub', 'скраб');
INSERT INTO `lang_phrase` VALUES ('5637', '2', '3', 'title', '81', 'scrub', 'scrub');
INSERT INTO `lang_phrase` VALUES ('5638', '3', '3', 'title', '81', 'scrub', 'broussailles');
INSERT INTO `lang_phrase` VALUES ('5639', '1', '3', 'title', '82', 'ink', 'тушь');
INSERT INTO `lang_phrase` VALUES ('5640', '2', '3', 'title', '82', 'ink', 'ink');
INSERT INTO `lang_phrase` VALUES ('5641', '3', '3', 'title', '82', 'ink', 'encre');
INSERT INTO `lang_phrase` VALUES ('5642', '1', '3', 'title', '83', 'kits', 'Комплекты');
INSERT INTO `lang_phrase` VALUES ('5643', '2', '3', 'title', '83', 'kits', 'kits');
INSERT INTO `lang_phrase` VALUES ('5644', '3', '3', 'title', '83', 'kits', 'Kits');
INSERT INTO `lang_phrase` VALUES ('5645', '1', '3', 'title', '84', 'pillowcases', 'Наволочки');
INSERT INTO `lang_phrase` VALUES ('5646', '2', '3', 'title', '84', 'pillowcases', 'pillowcases');
INSERT INTO `lang_phrase` VALUES ('5647', '3', '3', 'title', '84', 'pillowcases', 'taies d\'oreiller');
INSERT INTO `lang_phrase` VALUES ('5648', '1', '3', 'title', '85', 'Blankets', 'Одеяла');
INSERT INTO `lang_phrase` VALUES ('5649', '2', '3', 'title', '85', 'Blankets', 'Blankets');
INSERT INTO `lang_phrase` VALUES ('5650', '3', '3', 'title', '85', 'Blankets', 'couvertures');
INSERT INTO `lang_phrase` VALUES ('5651', '1', '3', 'title', '86', 'Cushions', 'Подушки');
INSERT INTO `lang_phrase` VALUES ('5652', '2', '3', 'title', '86', 'Cushions', 'Cushions');
INSERT INTO `lang_phrase` VALUES ('5653', '3', '3', 'title', '86', 'Cushions', 'coussins');
INSERT INTO `lang_phrase` VALUES ('5654', '1', '3', 'title', '87', 'Vases', 'Вазы');
INSERT INTO `lang_phrase` VALUES ('5655', '2', '3', 'title', '87', 'Vases', 'Vases');
INSERT INTO `lang_phrase` VALUES ('5656', '3', '3', 'title', '87', 'Vases', 'vases');
INSERT INTO `lang_phrase` VALUES ('5657', '1', '3', 'title', '88', 'Decorative pillows', 'Декоративные подушки');
INSERT INTO `lang_phrase` VALUES ('5658', '2', '3', 'title', '88', 'Decorative pillows', 'Decorative pillows');
INSERT INTO `lang_phrase` VALUES ('5659', '3', '3', 'title', '88', 'Decorative pillows', 'coussins');
INSERT INTO `lang_phrase` VALUES ('5660', '1', '3', 'title', '89', 'Furniture', 'Мебель');
INSERT INTO `lang_phrase` VALUES ('5661', '2', '3', 'title', '89', 'Furniture', 'Furniture');
INSERT INTO `lang_phrase` VALUES ('5662', '3', '3', 'title', '89', 'Furniture', 'Meubles');
INSERT INTO `lang_phrase` VALUES ('5663', '1', '3', 'title', '90', 'blinds', 'Шторы');
INSERT INTO `lang_phrase` VALUES ('5664', '2', '3', 'title', '90', 'blinds', 'blinds');
INSERT INTO `lang_phrase` VALUES ('5665', '3', '3', 'title', '90', 'blinds', 'stores');
INSERT INTO `lang_phrase` VALUES ('5666', '1', '3', 'title', '91', 'Covers', 'Покрывала');
INSERT INTO `lang_phrase` VALUES ('5667', '2', '3', 'title', '91', 'Covers', 'Covers');
INSERT INTO `lang_phrase` VALUES ('5668', '3', '3', 'title', '91', 'Covers', 'couvertures');
INSERT INTO `lang_phrase` VALUES ('5669', '1', '3', 'title', '92', 'Kitchen', 'Кухня');
INSERT INTO `lang_phrase` VALUES ('5670', '2', '3', 'title', '92', 'Kitchen', 'Kitchen');
INSERT INTO `lang_phrase` VALUES ('5671', '3', '3', 'title', '92', 'Kitchen', 'Cuisine');
INSERT INTO `lang_phrase` VALUES ('5672', '1', '3', 'title', '93', 'Dishes', 'Посуда');
INSERT INTO `lang_phrase` VALUES ('5673', '2', '3', 'title', '93', 'Dishes', 'Dishes');
INSERT INTO `lang_phrase` VALUES ('5674', '3', '3', 'title', '93', 'Dishes', 'vaisselle');
INSERT INTO `lang_phrase` VALUES ('5675', '1', '3', 'title', '94', 'Textile', 'Текстиль');
INSERT INTO `lang_phrase` VALUES ('5676', '2', '3', 'title', '94', 'Textile', 'Textile');
INSERT INTO `lang_phrase` VALUES ('5677', '3', '3', 'title', '94', 'Textile', 'textiles');
INSERT INTO `lang_phrase` VALUES ('5678', '1', '3', 'title', '95', 'plaids', 'Пледы');
INSERT INTO `lang_phrase` VALUES ('5679', '2', '3', 'title', '95', 'plaids', 'plaids');
INSERT INTO `lang_phrase` VALUES ('5680', '3', '3', 'title', '95', 'plaids', 'plaids');
INSERT INTO `lang_phrase` VALUES ('5681', '1', '3', 'title', '96', 'Towels', 'Полотенца');
INSERT INTO `lang_phrase` VALUES ('5682', '2', '3', 'title', '96', 'Towels', 'Towels');
INSERT INTO `lang_phrase` VALUES ('5683', '3', '3', 'title', '96', 'Towels', 'serviettes');
INSERT INTO `lang_phrase` VALUES ('5684', '1', '3', 'title', '97', 'Candlesticks', 'Подсвечники');
INSERT INTO `lang_phrase` VALUES ('5685', '2', '3', 'title', '97', 'Candlesticks', 'Candlesticks');
INSERT INTO `lang_phrase` VALUES ('5686', '3', '3', 'title', '97', 'Candlesticks', 'chandeliers');
INSERT INTO `lang_phrase` VALUES ('5687', '1', '3', 'title', '98', 'Photo frame', 'Рамки для фотографий');
INSERT INTO `lang_phrase` VALUES ('5688', '2', '3', 'title', '98', 'Photo frame', 'Photo frame');
INSERT INTO `lang_phrase` VALUES ('5689', '3', '3', 'title', '98', 'Photo frame', 'Cadres photos');
INSERT INTO `lang_phrase` VALUES ('5690', '1', '3', 'title', '99', 'Fixtures', 'Светильники');
INSERT INTO `lang_phrase` VALUES ('5691', '2', '3', 'title', '99', 'Fixtures', 'Fixtures');
INSERT INTO `lang_phrase` VALUES ('5692', '3', '3', 'title', '99', 'Fixtures', 'Calendrier');
INSERT INTO `lang_phrase` VALUES ('5693', '1', '3', 'title', '100', 'Candles', 'Свечи');
INSERT INTO `lang_phrase` VALUES ('5694', '2', '3', 'title', '100', 'Candles', 'Candles');
INSERT INTO `lang_phrase` VALUES ('5695', '3', '3', 'title', '100', 'Candles', 'bougies');
INSERT INTO `lang_phrase` VALUES ('5696', '1', '3', 'title', '101', 'Figurines', 'Статуэтки');
INSERT INTO `lang_phrase` VALUES ('5697', '2', '3', 'title', '101', 'Figurines', 'Figurines');
INSERT INTO `lang_phrase` VALUES ('5698', '3', '3', 'title', '101', 'Figurines', 'Figurines');
INSERT INTO `lang_phrase` VALUES ('5699', '1', '3', 'title', '102', 'Caskets', 'Шкатулки');
INSERT INTO `lang_phrase` VALUES ('5700', '2', '3', 'title', '102', 'Caskets', 'Caskets');
INSERT INTO `lang_phrase` VALUES ('5701', '3', '3', 'title', '102', 'Caskets', 'cercueils');
INSERT INTO `lang_phrase` VALUES ('5702', '1', '3', 'title', '103', 'Glasses', 'Стаканы');
INSERT INTO `lang_phrase` VALUES ('5703', '2', '3', 'title', '103', 'Glasses', 'Glasses');
INSERT INTO `lang_phrase` VALUES ('5704', '3', '3', 'title', '103', 'Glasses', 'lunettes');
INSERT INTO `lang_phrase` VALUES ('5705', '1', '3', 'title', '104', 'Plugs', 'Вилки');
INSERT INTO `lang_phrase` VALUES ('5706', '2', '3', 'title', '104', 'Plugs', 'Plugs');
INSERT INTO `lang_phrase` VALUES ('5707', '3', '3', 'title', '104', 'Plugs', 'Plugs');
INSERT INTO `lang_phrase` VALUES ('5708', '1', '3', 'title', '105', 'Knives', 'Ножы');
INSERT INTO `lang_phrase` VALUES ('5709', '2', '3', 'title', '105', 'Knives', 'Knives');
INSERT INTO `lang_phrase` VALUES ('5710', '3', '3', 'title', '105', 'Knives', 'couteaux');
INSERT INTO `lang_phrase` VALUES ('5711', '1', '3', 'title', '106', 'Spoons', 'Ложки');
INSERT INTO `lang_phrase` VALUES ('5712', '2', '3', 'title', '106', 'Spoons', 'Spoons');
INSERT INTO `lang_phrase` VALUES ('5713', '3', '3', 'title', '106', 'Spoons', 'Cuiller');
INSERT INTO `lang_phrase` VALUES ('5714', '1', '3', 'title', '107', 'sets', 'Сервизы');
INSERT INTO `lang_phrase` VALUES ('5715', '2', '3', 'title', '107', 'sets', 'sets');
INSERT INTO `lang_phrase` VALUES ('5716', '3', '3', 'title', '107', 'sets', 'ensembles');
INSERT INTO `lang_phrase` VALUES ('5717', '1', '3', 'title', '108', 'Frying Pan', 'Сковородка');
INSERT INTO `lang_phrase` VALUES ('5718', '2', '3', 'title', '108', 'Frying Pan', 'Frying Pan');
INSERT INTO `lang_phrase` VALUES ('5719', '3', '3', 'title', '108', 'Frying Pan', 'Frying Pan');
INSERT INTO `lang_phrase` VALUES ('5720', '1', '3', 'title', '109', 'Lamps', 'Лампы');
INSERT INTO `lang_phrase` VALUES ('5721', '2', '3', 'title', '109', 'Lamps', 'Lamps');
INSERT INTO `lang_phrase` VALUES ('5722', '3', '3', 'title', '109', 'Lamps', 'lampes');
INSERT INTO `lang_phrase` VALUES ('5723', '1', '3', 'title', '110', 'Lighting', 'Освещение');
INSERT INTO `lang_phrase` VALUES ('5724', '2', '3', 'title', '110', 'Lighting', 'Lighting');
INSERT INTO `lang_phrase` VALUES ('5725', '3', '3', 'title', '110', 'Lighting', 'Éclairage');
INSERT INTO `lang_phrase` VALUES ('5726', '1', '3', 'title', '111', 'iPhone', 'Айфон');
INSERT INTO `lang_phrase` VALUES ('5727', '2', '3', 'title', '111', 'iPhone', 'iPhone');
INSERT INTO `lang_phrase` VALUES ('5728', '3', '3', 'title', '111', 'iPhone', 'iPhone');
INSERT INTO `lang_phrase` VALUES ('5729', '1', '3', 'title', '112', 'iPad', 'Айпад');
INSERT INTO `lang_phrase` VALUES ('5730', '2', '3', 'title', '112', 'iPad', 'iPad');
INSERT INTO `lang_phrase` VALUES ('5731', '3', '3', 'title', '112', 'iPad', 'iPad');
INSERT INTO `lang_phrase` VALUES ('5732', '1', '3', 'title', '113', 'iWatch', 'АйВатч');
INSERT INTO `lang_phrase` VALUES ('5733', '2', '3', 'title', '113', 'iWatch', 'iWatch');
INSERT INTO `lang_phrase` VALUES ('5734', '3', '3', 'title', '113', 'iWatch', 'iWatch');
INSERT INTO `lang_phrase` VALUES ('5735', '1', '3', 'title', '114', 'Smartphones Vertu', 'Смартфоны Верту');
INSERT INTO `lang_phrase` VALUES ('5736', '2', '3', 'title', '114', 'Smartphones Vertu', 'Smartphones Vertu');
INSERT INTO `lang_phrase` VALUES ('5737', '3', '3', 'title', '114', 'Smartphones Vertu', 'Smartphones Vertu');
INSERT INTO `lang_phrase` VALUES ('5738', '1', '3', 'title', '115', '  shirts', 'рубашки');
INSERT INTO `lang_phrase` VALUES ('5739', '2', '3', 'title', '115', '  shirts', '  shirts');
INSERT INTO `lang_phrase` VALUES ('5740', '3', '3', 'title', '115', '  shirts', '  chemises');
INSERT INTO `lang_phrase` VALUES ('5741', '1', '3', 'title', '116', 'Toys', 'Игрушки');
INSERT INTO `lang_phrase` VALUES ('5742', '2', '3', 'title', '116', 'Toys', 'Toys');
INSERT INTO `lang_phrase` VALUES ('5743', '3', '3', 'title', '116', 'Toys', 'Jouets');
INSERT INTO `lang_phrase` VALUES ('5744', '1', '3', 'title', '117', 'baby clothes', 'Детская одежда');
INSERT INTO `lang_phrase` VALUES ('5745', '2', '3', 'title', '117', 'baby clothes', 'baby clothes');
INSERT INTO `lang_phrase` VALUES ('5746', '3', '3', 'title', '117', 'baby clothes', 'vêtements pour enfants');
INSERT INTO `lang_phrase` VALUES ('5747', '1', '3', 'title', '118', '  Mikey', 'Майки');
INSERT INTO `lang_phrase` VALUES ('5748', '2', '3', 'title', '118', '  Mikey', '  Mikey');
INSERT INTO `lang_phrase` VALUES ('5749', '3', '3', 'title', '118', '  Mikey', '  Mikey');
INSERT INTO `lang_phrase` VALUES ('5750', '1', '3', 'title', '119', 'Bags', 'Сумки');
INSERT INTO `lang_phrase` VALUES ('5751', '2', '3', 'title', '119', 'Bags', 'Bags');
INSERT INTO `lang_phrase` VALUES ('5752', '3', '3', 'title', '119', 'Bags', 'sacs');
INSERT INTO `lang_phrase` VALUES ('5753', '1', '3', 'title', '120', 'Baggage', 'Багаж');
INSERT INTO `lang_phrase` VALUES ('5754', '2', '3', 'title', '120', 'Baggage', 'Baggage');
INSERT INTO `lang_phrase` VALUES ('5755', '3', '3', 'title', '120', 'Baggage', 'bagages');
INSERT INTO `lang_phrase` VALUES ('5756', '1', '3', 'title', '121', 'Shoulder Bags', 'Сумки на плечо');
INSERT INTO `lang_phrase` VALUES ('5757', '2', '3', 'title', '121', 'Shoulder Bags', 'Shoulder Bags');
INSERT INTO `lang_phrase` VALUES ('5758', '3', '3', 'title', '121', 'Shoulder Bags', 'Sacs à bandoulière');
INSERT INTO `lang_phrase` VALUES ('5759', '1', '3', 'title', '122', 'Tote Bags,', 'Сумки-тоут');
INSERT INTO `lang_phrase` VALUES ('5760', '2', '3', 'title', '122', 'Tote Bags,', 'Tote Bags,');
INSERT INTO `lang_phrase` VALUES ('5761', '3', '3', 'title', '122', 'Tote Bags,', 'Sacs fourre-tout,');
INSERT INTO `lang_phrase` VALUES ('5762', '1', '3', 'title', '123', 'Backpacks', 'Рюкзаки');
INSERT INTO `lang_phrase` VALUES ('5763', '2', '3', 'title', '123', 'Backpacks', 'Backpacks');
INSERT INTO `lang_phrase` VALUES ('5764', '3', '3', 'title', '123', 'Backpacks', 'Sacs à dos');
INSERT INTO `lang_phrase` VALUES ('5765', '1', '3', 'title', '124', 'clutches', 'Клатчи');
INSERT INTO `lang_phrase` VALUES ('5766', '2', '3', 'title', '124', 'clutches', 'clutches');
INSERT INTO `lang_phrase` VALUES ('5767', '3', '3', 'title', '124', 'clutches', 'embrayages');
INSERT INTO `lang_phrase` VALUES ('5768', '1', '3', 'title', '125', 'Sport bags', 'Cпортивные сумки');
INSERT INTO `lang_phrase` VALUES ('5769', '2', '3', 'title', '125', 'Sport bags', 'Sport bags');
INSERT INTO `lang_phrase` VALUES ('5770', '3', '3', 'title', '125', 'Sport bags', 'Sacs de sport');
INSERT INTO `lang_phrase` VALUES ('5771', '1', '3', 'title', '126', 'Notebook bags', 'Сумки для ноутбуков');
INSERT INTO `lang_phrase` VALUES ('5772', '2', '3', 'title', '126', 'Notebook bags', 'Notebook bags');
INSERT INTO `lang_phrase` VALUES ('5773', '3', '3', 'title', '126', 'Notebook bags', 'Sacs pour ordinateurs portables');
INSERT INTO `lang_phrase` VALUES ('5774', '1', '3', 'title', '127', 'Briefcases', 'Портфели');
INSERT INTO `lang_phrase` VALUES ('5775', '2', '3', 'title', '127', 'Briefcases', 'Briefcases');
INSERT INTO `lang_phrase` VALUES ('5776', '3', '3', 'title', '127', 'Briefcases', 'Porte-documents');

-- ----------------------------
-- Table structure for mail_template
-- ----------------------------
DROP TABLE IF EXISTS `mail_template`;
CREATE TABLE `mail_template` (
  `template_id` int(11) NOT NULL auto_increment,
  `code` varchar(100) NOT NULL default '',
  `language_id` int(11) NOT NULL,
  `description` text NOT NULL,
  `m_subject` varchar(255) NOT NULL default '',
  `m_text` text NOT NULL,
  `m_html` text NOT NULL,
  `m_fname` varchar(100) NOT NULL default '',
  `m_faddr` varchar(100) NOT NULL default '',
  `m_rname` varchar(100) NOT NULL default '',
  `m_raddr` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`template_id`),
  KEY `language_id` (`language_id`),
  CONSTRAINT `mail_template_ibfk_1` FOREIGN KEY (`language_id`) REFERENCES `language` (`language_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of mail_template
-- ----------------------------
INSERT INTO `mail_template` VALUES ('1', 'remind_template', '1', 'Восстановление пароля', 'LiberEye: Ваш  новый  пароль', '{name}.\nВаш новый пароль для входа на сайт LiberEye: {password}\n\nАдминистрация сайта\nhttps://www.libereye.com/', '<p>{name}.<br /> Ваш новый пароль для входа на сайт LiberEye: {password}<br /> <br /> Администрация сайта<br /> <a href=\"https://www.libereye.com/\">www.libereye.com</a></p>', 'LiberEye', 'mailer@libereye.com', 'LiberEye', 'mailer@libereye.com');
INSERT INTO `mail_template` VALUES ('2', 'confirm_template', '1', 'Подтверждение регистрации', 'LiberEye: Подтверждение регистрации', 'Спасибо за регистрацию на портале LiberEye.\r\n\r\nДля завершения регистрации необходимо подтвердить email, перейдя по ссылке: {confirm_code_url}', 'Спасибо за регистрацию на портале LiberEye.<br><br>\r\n\r\nДля завершения регистрации необходимо подтвердить email, перейдя по <a href=\"{confirm_code_url}\">ссылке</a>.', 'LiberEye', 'mailer@libereye.com', 'LiberEye', 'mailer@libereye.com');
INSERT INTO `mail_template` VALUES ('3', 'remind_template', '2', 'Password recovery', 'LiberEye: Your new password', '{name}.\r\nYour new password to access the site LiberEye: {password}\r\n\r\nАдминистрация сайта\r\nwww.libereye.com', '<p>{name}.<br /> Your new password to access the site LiberEye: {password}<br /> <br /> Administration of site<br /> <a href=\"https://www.libereye.com/\">LiberEye.com</a></p>', 'LiberEye', 'mailer@libereye.com', 'LiberEye', 'mailer@libereye.com');
INSERT INTO `mail_template` VALUES ('4', 'confirm_template', '2', 'Confirmation of registration', 'LiberEye: Confirmation of registration', 'Thank you for registering on the portal LiberEye.\r\n\r\nTo complete the registration you must confirm the email, follow the link: {confirm_code_url}', 'Спасибо за регистрацию на портале LiberEye.<br><br>\r\n\r\nTo complete the registration you must confirm the email, follow the <a href=\"{confirm_code_url}\">link</a>.', 'LiberEye', 'mailer@libereye.com', 'LiberEye', 'mailer@libereye.com');
INSERT INTO `mail_template` VALUES ('5', 'remind_template', '3', 'Récupération de mot de passe', 'LiberEye: Votre nouveau mot de passe', '{name}.\r\nVotre nouveau mot de passe pour accéder au site LiberEye: {password}\r\n\r\nL\'administration de ce site\rLiberEye.com', '<p>{name}.<br /> Votre nouveau mot de passe pour accéder au site LiberEye: {password}<br /> <br /> L\'administration de ce site<br /> <a href=\"https://www.libereye.com/\">LiberEye.com</a></p>', 'LiberEye', 'mailer@libereye.com', 'LiberEye', 'mailer@libereye.com');
INSERT INTO `mail_template` VALUES ('6', 'confirm_template', '3', 'Confirmation de l\'inscription', 'LiberEye: Confirmation de l\'inscription', 'Merci de votre inscription sur le portail LiberEye.\r\n\r\nPour terminer l\'enregistrement, vous devez confirmer l\'e-mail, en cliquant sur le lien: {confirm_code_url}', 'Merci de votre inscription sur le portail LiberEye.<br><br>\r\n\r\nPour terminer l\'enregistrement, vous devez confirmer l\'e-mail, en cliquant sur le <a href=\"{confirm_code_url}\">lien</a>.', 'LiberEye', 'mailer@libereye.com', 'LiberEye', 'mailer@libereye.com');

-- ----------------------------
-- Table structure for object_type
-- ----------------------------
DROP TABLE IF EXISTS `object_type`;
CREATE TABLE `object_type` (
  `object_type_id` int(11) NOT NULL auto_increment,
  `type` varchar(20) NOT NULL,
  PRIMARY KEY  (`object_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of object_type
-- ----------------------------
INSERT INTO `object_type` VALUES ('1', 'common');
INSERT INTO `object_type` VALUES ('2', 'product');
INSERT INTO `object_type` VALUES ('3', 'ptype');
INSERT INTO `object_type` VALUES ('4', 'shop');
INSERT INTO `object_type` VALUES ('5', 'open_time');
INSERT INTO `object_type` VALUES ('6', 'brand');
INSERT INTO `object_type` VALUES ('7', 'pgroup');
INSERT INTO `object_type` VALUES ('8', 'country');

-- ----------------------------
-- Table structure for open_time
-- ----------------------------
DROP TABLE IF EXISTS `open_time`;
CREATE TABLE `open_time` (
  `open_time_id` int(11) NOT NULL auto_increment,
  `shop_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `week_day` int(11) NOT NULL COMMENT 'день недели (0-пн, 1-вт, …)',
  `time_from` int(11) NOT NULL COMMENT 'время открытия (10:30 = 10*60+30 = 630)',
  `time_to` int(11) NOT NULL COMMENT 'время закрытия',
  `type` enum('open','close') NOT NULL,
  PRIMARY KEY  (`open_time_id`),
  KEY `shop_id` (`shop_id`),
  CONSTRAINT `open_time_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Таблица времени работы магазина';

-- ----------------------------
-- Records of open_time
-- ----------------------------
INSERT INTO `open_time` VALUES ('1', '1', 'Monday', '0', '570', '1170', 'open');
INSERT INTO `open_time` VALUES ('2', '1', 'Tuesday', '1', '570', '1170', 'open');
INSERT INTO `open_time` VALUES ('3', '1', 'Wednesday', '2', '570', '1170', 'open');
INSERT INTO `open_time` VALUES ('4', '1', 'Thursday', '3', '570', '1260', 'open');
INSERT INTO `open_time` VALUES ('5', '1', 'Friday', '4', '570', '1170', 'open');
INSERT INTO `open_time` VALUES ('6', '1', 'Saturday', '5', '570', '1170', 'open');
INSERT INTO `open_time` VALUES ('7', '1', 'Sunday', '6', '0', '1440', 'close');

-- ----------------------------
-- Table structure for payment_log
-- ----------------------------
DROP TABLE IF EXISTS `payment_log`;
CREATE TABLE `payment_log` (
  `id` int(11) NOT NULL auto_increment,
  `pay_system_id` int(11) default NULL,
  `request` text NOT NULL,
  `response` text NOT NULL,
  `account_id` int(11) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `cdate` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `purchase_id` (`purchase_id`),
  KEY `account_id` (`account_id`),
  KEY `pay_system_id` (`pay_system_id`),
  CONSTRAINT `payment_log_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `account` (`account_id`),
  CONSTRAINT `payment_log_ibfk_2` FOREIGN KEY (`purchase_id`) REFERENCES `purchase` (`purchase_id`),
  CONSTRAINT `payment_log_ibfk_3` FOREIGN KEY (`pay_system_id`) REFERENCES `pay_system` (`pay_system_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of payment_log
-- ----------------------------
INSERT INTO `payment_log` VALUES ('2', null, '{\"METHOD\":\"DoExpressCheckoutPayment\",\"VERSION\":\"74.0\",\"USER\":\"rudserg-facilitator-us_api1.gmail.com\",\"PWD\":\"LA53JX2ZTUDC7RXK\",\"SIGNATURE\":\"AFcWxV21C7fd0v3bYYYRCpSSRl31AxXnrD825ZW4G3P0YF2bHoIWMikk\",\"PAYMENTREQUEST_0_PAYMENTACTION\":\"Sale\",\"PAYMENTREQUEST_0_ITEMAMT\":\"1917.21\",\"PAYMENTREQUEST_0_CURRENCYCODE\":\"USD\",\"PAYMENTREQUEST_0_AMT\":\"1917.21\",\"L_PAYMENTREQUEST_0_AMT0\":\"1917.21\",\"PAYMENTREQUEST_0_INVNUM\":\"66\",\"PAYERID\":\"S86Z2WRTYY58Y\",\"TOKEN\":\"EC-1G834342M5446740E\"}', 'TOKEN=EC%2d1G834342M5446740E&SUCCESSPAGEREDIRECTREQUESTED=false&TIMESTAMP=2015%2d08%2d18T13%3a21%3a23Z&CORRELATIONID=ae43151f59dc0&ACK=SuccessWithWarning&VERSION=74%2e0&BUILD=000000&L_ERRORCODE0=11607&L_SHORTMESSAGE0=Duplicate%20Request&L_LONGMESSAGE0=A%20successful%20transaction%20has%20already%20been%20completed%20for%20this%20token%2e&L_SEVERITYCODE0=Warning&INSURANCEOPTIONSELECTED=false&SHIPPINGOPTIONISDEFAULT=false&PAYMENTINFO_0_TRANSACTIONID=0Y125302XJ7151323&PAYMENTINFO_0_TRANSACTIONTYPE=cart&PAYMENTINFO_0_PAYMENTTYPE=instant&PAYMENTINFO_0_ORDERTIME=2015%2d08%2d18T13%3a05%3a17Z&PAYMENTINFO_0_AMT=1917%2e21&PAYMENTINFO_0_FEEAMT=55%2e90&PAYMENTINFO_0_TAXAMT=0%2e00&PAYMENTINFO_0_CURRENCYCODE=USD&PAYMENTINFO_0_PAYMENTSTATUS=Completed&PAYMENTINFO_0_PENDINGREASON=None&PAYMENTINFO_0_REASONCODE=None&PAYMENTINFO_0_PROTECTIONELIGIBILITY=Eligible&PAYMENTINFO_0_PROTECTIONELIGIBILITYTYPE=ItemNotReceivedEligible%2cUnauthorizedPaymentEligible&PAYMENTINFO_0_SECUREMERCHANTACCOUNTID=VDRLZKBC2XBLC&PAYMENTINFO_0_ERRORCODE=0&PAYMENTINFO_0_ACK=Success', '23', '66', '2015-08-18 20:21:21');
INSERT INTO `payment_log` VALUES ('4', null, '{\"METHOD\":\"DoExpressCheckoutPayment\",\"VERSION\":\"74.0\",\"USER\":\"rudserg-facilitator-us_api1.gmail.com\",\"PWD\":\"LA53JX2ZTUDC7RXK\",\"SIGNATURE\":\"AFcWxV21C7fd0v3bYYYRCpSSRl31AxXnrD825ZW4G3P0YF2bHoIWMikk\",\"PAYMENTREQUEST_0_PAYMENTACTION\":\"Sale\",\"PAYMENTREQUEST_0_ITEMAMT\":\"1917.21\",\"PAYMENTREQUEST_0_CURRENCYCODE\":\"USD\",\"PAYMENTREQUEST_0_AMT\":\"1917.21\",\"L_PAYMENTREQUEST_0_AMT0\":\"1917.21\",\"PAYMENTREQUEST_0_INVNUM\":\"66\",\"PAYERID\":\"S86Z2WRTYY58Y\",\"TOKEN\":\"EC-1G834342M5446740E\"}', 'TOKEN=EC%2d1G834342M5446740E&SUCCESSPAGEREDIRECTREQUESTED=false&TIMESTAMP=2015%2d08%2d18T13%3a21%3a26Z&CORRELATIONID=bf5cdc17c50e0&ACK=SuccessWithWarning&VERSION=74%2e0&BUILD=000000&L_ERRORCODE0=11607&L_SHORTMESSAGE0=Duplicate%20Request&L_LONGMESSAGE0=A%20successful%20transaction%20has%20already%20been%20completed%20for%20this%20token%2e&L_SEVERITYCODE0=Warning&INSURANCEOPTIONSELECTED=false&SHIPPINGOPTIONISDEFAULT=false&PAYMENTINFO_0_TRANSACTIONID=0Y125302XJ7151323&PAYMENTINFO_0_TRANSACTIONTYPE=cart&PAYMENTINFO_0_PAYMENTTYPE=instant&PAYMENTINFO_0_ORDERTIME=2015%2d08%2d18T13%3a05%3a17Z&PAYMENTINFO_0_AMT=1917%2e21&PAYMENTINFO_0_FEEAMT=55%2e90&PAYMENTINFO_0_TAXAMT=0%2e00&PAYMENTINFO_0_CURRENCYCODE=USD&PAYMENTINFO_0_PAYMENTSTATUS=Completed&PAYMENTINFO_0_PENDINGREASON=None&PAYMENTINFO_0_REASONCODE=None&PAYMENTINFO_0_PROTECTIONELIGIBILITY=Eligible&PAYMENTINFO_0_PROTECTIONELIGIBILITYTYPE=ItemNotReceivedEligible%2cUnauthorizedPaymentEligible&PAYMENTINFO_0_SECUREMERCHANTACCOUNTID=VDRLZKBC2XBLC&PAYMENTINFO_0_ERRORCODE=0&PAYMENTINFO_0_ACK=Success', '23', '66', '2015-08-18 20:21:24');
INSERT INTO `payment_log` VALUES ('6', null, '{\"METHOD\":\"DoExpressCheckoutPayment\",\"VERSION\":\"74.0\",\"PAYMENTREQUEST_0_PAYMENTACTION\":\"Sale\",\"PAYMENTREQUEST_0_ITEMAMT\":\"1917.21\",\"PAYMENTREQUEST_0_CURRENCYCODE\":\"USD\",\"PAYMENTREQUEST_0_AMT\":\"1917.21\",\"L_PAYMENTREQUEST_0_AMT0\":\"1917.21\",\"PAYMENTREQUEST_0_INVNUM\":\"66\",\"PAYERID\":\"S86Z2WRTYY58Y\",\"TOKEN\":\"EC-1G834342M5446740E\"}', 'TOKEN=EC%2d1G834342M5446740E&SUCCESSPAGEREDIRECTREQUESTED=false&TIMESTAMP=2015%2d08%2d18T13%3a23%3a40Z&CORRELATIONID=98a5b1c476b80&ACK=SuccessWithWarning&VERSION=74%2e0&BUILD=000000&L_ERRORCODE0=11607&L_SHORTMESSAGE0=Duplicate%20Request&L_LONGMESSAGE0=A%20successful%20transaction%20has%20already%20been%20completed%20for%20this%20token%2e&L_SEVERITYCODE0=Warning&INSURANCEOPTIONSELECTED=false&SHIPPINGOPTIONISDEFAULT=false&PAYMENTINFO_0_TRANSACTIONID=0Y125302XJ7151323&PAYMENTINFO_0_TRANSACTIONTYPE=cart&PAYMENTINFO_0_PAYMENTTYPE=instant&PAYMENTINFO_0_ORDERTIME=2015%2d08%2d18T13%3a05%3a17Z&PAYMENTINFO_0_AMT=1917%2e21&PAYMENTINFO_0_FEEAMT=55%2e90&PAYMENTINFO_0_TAXAMT=0%2e00&PAYMENTINFO_0_CURRENCYCODE=USD&PAYMENTINFO_0_PAYMENTSTATUS=Completed&PAYMENTINFO_0_PENDINGREASON=None&PAYMENTINFO_0_REASONCODE=None&PAYMENTINFO_0_PROTECTIONELIGIBILITY=Eligible&PAYMENTINFO_0_PROTECTIONELIGIBILITYTYPE=ItemNotReceivedEligible%2cUnauthorizedPaymentEligible&PAYMENTINFO_0_SECUREMERCHANTACCOUNTID=VDRLZKBC2XBLC&PAYMENTINFO_0_ERRORCODE=0&PAYMENTINFO_0_ACK=Success', '23', '66', '2015-08-18 20:23:38');
INSERT INTO `payment_log` VALUES ('7', null, '{\"METHOD\":\"SetExpressCheckout\",\"VERSION\":\"74.0\",\"RETURNURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=true\",\"CANCELURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=false\",\"PAYMENTREQUEST_0_AMT\":7095.17,\"PAYMENTREQUEST_0_CURRENCYCODE\":\"USD\",\"PAYMENTREQUEST_0_ITEMAMT\":7095.17,\"PAYMENTREQUEST_0_INVNUM\":\"61\",\"L_PAYMENTREQUEST_0_NAME0\":\"\\u041c\\u043e\\u0439 \\u0437\\u0430\\u043a\\u0430\\u0437 \\u211661\",\"L_PAYMENTREQUEST_0_DESC0\":\"\",\"L_PAYMENTREQUEST_0_AMT0\":7095.17}', 'TOKEN=EC%2d3ME58083T12129829&TIMESTAMP=2015%2d08%2d18T13%3a25%3a54Z&CORRELATIONID=ddbde3f5ecb2c&ACK=Success&VERSION=74%2e0&BUILD=000000', '23', '61', '2015-08-18 20:25:52');
INSERT INTO `payment_log` VALUES ('9', null, '{\"METHOD\":\"DoExpressCheckoutPayment\",\"VERSION\":\"74.0\",\"PAYMENTREQUEST_0_PAYMENTACTION\":\"Sale\",\"PAYMENTREQUEST_0_ITEMAMT\":\"7095.17\",\"PAYMENTREQUEST_0_CURRENCYCODE\":\"USD\",\"PAYMENTREQUEST_0_AMT\":\"7095.17\",\"L_PAYMENTREQUEST_0_AMT0\":\"7095.17\",\"PAYMENTREQUEST_0_INVNUM\":\"61\",\"PAYERID\":\"S86Z2WRTYY58Y\",\"TOKEN\":\"EC-3ME58083T12129829\"}', 'TOKEN=EC%2d3ME58083T12129829&SUCCESSPAGEREDIRECTREQUESTED=false&TIMESTAMP=2015%2d08%2d18T13%3a26%3a16Z&CORRELATIONID=a15dfccd46f95&ACK=Success&VERSION=74%2e0&BUILD=000000&INSURANCEOPTIONSELECTED=false&SHIPPINGOPTIONISDEFAULT=false&PAYMENTINFO_0_TRANSACTIONID=25E08342LT661962G&PAYMENTINFO_0_TRANSACTIONTYPE=cart&PAYMENTINFO_0_PAYMENTTYPE=instant&PAYMENTINFO_0_ORDERTIME=2015%2d08%2d18T13%3a26%3a16Z&PAYMENTINFO_0_AMT=7095%2e17&PAYMENTINFO_0_FEEAMT=206%2e06&PAYMENTINFO_0_TAXAMT=0%2e00&PAYMENTINFO_0_CURRENCYCODE=USD&PAYMENTINFO_0_PAYMENTSTATUS=Completed&PAYMENTINFO_0_PENDINGREASON=None&PAYMENTINFO_0_REASONCODE=None&PAYMENTINFO_0_PROTECTIONELIGIBILITY=Eligible&PAYMENTINFO_0_PROTECTIONELIGIBILITYTYPE=ItemNotReceivedEligible%2cUnauthorizedPaymentEligible&PAYMENTINFO_0_SECUREMERCHANTACCOUNTID=VDRLZKBC2XBLC&PAYMENTINFO_0_ERRORCODE=0&PAYMENTINFO_0_ACK=Success', '23', '61', '2015-08-18 20:26:14');
INSERT INTO `payment_log` VALUES ('10', null, '{\"METHOD\":\"SetExpressCheckout\",\"VERSION\":\"74.0\",\"RETURNURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=true\",\"CANCELURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=false\",\"PAYMENTREQUEST_0_AMT\":2621.24,\"PAYMENTREQUEST_0_CURRENCYCODE\":\"USD\",\"PAYMENTREQUEST_0_ITEMAMT\":2621.24,\"PAYMENTREQUEST_0_INVNUM\":\"58\",\"L_PAYMENTREQUEST_0_NAME0\":\"\\u041c\\u043e\\u0439 \\u0437\\u0430\\u043a\\u0430\\u0437 \\u211658\",\"L_PAYMENTREQUEST_0_DESC0\":\"\",\"L_PAYMENTREQUEST_0_AMT0\":2621.24}', 'TOKEN=EC%2d9F558885UD500070U&TIMESTAMP=2015%2d08%2d18T13%3a46%3a46Z&CORRELATIONID=616ca910a4a04&ACK=Success&VERSION=74%2e0&BUILD=000000', '23', '58', '2015-08-18 20:46:44');
INSERT INTO `payment_log` VALUES ('12', null, '{\"METHOD\":\"DoExpressCheckoutPayment\",\"VERSION\":\"74.0\",\"PAYMENTREQUEST_0_PAYMENTACTION\":\"Sale\",\"PAYMENTREQUEST_0_ITEMAMT\":\"2621.24\",\"PAYMENTREQUEST_0_CURRENCYCODE\":\"USD\",\"PAYMENTREQUEST_0_AMT\":\"2621.24\",\"L_PAYMENTREQUEST_0_AMT0\":\"2621.24\",\"PAYMENTREQUEST_0_INVNUM\":\"58\",\"PAYERID\":\"S86Z2WRTYY58Y\",\"TOKEN\":\"EC-9F558885UD500070U\"}', 'TOKEN=EC%2d9F558885UD500070U&SUCCESSPAGEREDIRECTREQUESTED=false&TIMESTAMP=2015%2d08%2d18T13%3a59%3a40Z&CORRELATIONID=b64287ceb5d9&ACK=Success&VERSION=74%2e0&BUILD=000000&INSURANCEOPTIONSELECTED=false&SHIPPINGOPTIONISDEFAULT=false&PAYMENTINFO_0_TRANSACTIONID=0M247999H7233073A&PAYMENTINFO_0_TRANSACTIONTYPE=cart&PAYMENTINFO_0_PAYMENTTYPE=instant&PAYMENTINFO_0_ORDERTIME=2015%2d08%2d18T13%3a59%3a40Z&PAYMENTINFO_0_AMT=2621%2e24&PAYMENTINFO_0_FEEAMT=76%2e32&PAYMENTINFO_0_TAXAMT=0%2e00&PAYMENTINFO_0_CURRENCYCODE=USD&PAYMENTINFO_0_PAYMENTSTATUS=Completed&PAYMENTINFO_0_PENDINGREASON=None&PAYMENTINFO_0_REASONCODE=None&PAYMENTINFO_0_PROTECTIONELIGIBILITY=Eligible&PAYMENTINFO_0_PROTECTIONELIGIBILITYTYPE=ItemNotReceivedEligible%2cUnauthorizedPaymentEligible&PAYMENTINFO_0_SECUREMERCHANTACCOUNTID=VDRLZKBC2XBLC&PAYMENTINFO_0_ERRORCODE=0&PAYMENTINFO_0_ACK=Success', '23', '58', '2015-08-18 20:59:38');
INSERT INTO `payment_log` VALUES ('13', null, '{\"METHOD\":\"SetExpressCheckout\",\"VERSION\":\"74.0\",\"RETURNURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=true\",\"CANCELURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=false\",\"PAYMENTREQUEST_0_AMT\":6853.03,\"PAYMENTREQUEST_0_CURRENCYCODE\":\"USD\",\"PAYMENTREQUEST_0_ITEMAMT\":6853.03,\"PAYMENTREQUEST_0_INVNUM\":\"57\",\"L_PAYMENTREQUEST_0_NAME0\":\"\\u041c\\u043e\\u0439 \\u0437\\u0430\\u043a\\u0430\\u0437 \\u211657\",\"L_PAYMENTREQUEST_0_DESC0\":\"\",\"L_PAYMENTREQUEST_0_AMT0\":6853.03}', 'TOKEN=EC%2d8S12186447466033P&TIMESTAMP=2015%2d08%2d18T14%3a02%3a17Z&CORRELATIONID=9d6bd880107f7&ACK=Success&VERSION=74%2e0&BUILD=000000', '23', '57', '2015-08-18 21:02:15');
INSERT INTO `payment_log` VALUES ('15', null, '{\"METHOD\":\"DoExpressCheckoutPayment\",\"VERSION\":\"74.0\",\"PAYMENTREQUEST_0_PAYMENTACTION\":\"Sale\",\"PAYMENTREQUEST_0_ITEMAMT\":\"6853.03\",\"PAYMENTREQUEST_0_CURRENCYCODE\":\"USD\",\"PAYMENTREQUEST_0_AMT\":\"6853.03\",\"L_PAYMENTREQUEST_0_AMT0\":\"6853.03\",\"PAYMENTREQUEST_0_INVNUM\":\"57\",\"PAYERID\":\"S86Z2WRTYY58Y\",\"TOKEN\":\"EC-8S12186447466033P\"}', 'TOKEN=EC%2d8S12186447466033P&SUCCESSPAGEREDIRECTREQUESTED=false&TIMESTAMP=2015%2d08%2d18T14%3a03%3a03Z&CORRELATIONID=76683e161a1c2&ACK=Success&VERSION=74%2e0&BUILD=000000&INSURANCEOPTIONSELECTED=false&SHIPPINGOPTIONISDEFAULT=false&PAYMENTINFO_0_TRANSACTIONID=1WB43734K1424900A&PAYMENTINFO_0_TRANSACTIONTYPE=cart&PAYMENTINFO_0_PAYMENTTYPE=instant&PAYMENTINFO_0_ORDERTIME=2015%2d08%2d18T14%3a03%3a03Z&PAYMENTINFO_0_AMT=6853%2e03&PAYMENTINFO_0_FEEAMT=199%2e04&PAYMENTINFO_0_TAXAMT=0%2e00&PAYMENTINFO_0_CURRENCYCODE=USD&PAYMENTINFO_0_PAYMENTSTATUS=Completed&PAYMENTINFO_0_PENDINGREASON=None&PAYMENTINFO_0_REASONCODE=None&PAYMENTINFO_0_PROTECTIONELIGIBILITY=Eligible&PAYMENTINFO_0_PROTECTIONELIGIBILITYTYPE=ItemNotReceivedEligible%2cUnauthorizedPaymentEligible&PAYMENTINFO_0_SECUREMERCHANTACCOUNTID=VDRLZKBC2XBLC&PAYMENTINFO_0_ERRORCODE=0&PAYMENTINFO_0_ACK=Success', '23', '57', '2015-08-18 21:03:01');
INSERT INTO `payment_log` VALUES ('16', null, '{\"METHOD\":\"SetExpressCheckout\",\"VERSION\":\"74.0\",\"RETURNURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=true\",\"CANCELURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=false\",\"PAYMENTREQUEST_0_AMT\":8628.27,\"PAYMENTREQUEST_0_CURRENCYCODE\":\"USD\",\"PAYMENTREQUEST_0_ITEMAMT\":8628.27,\"PAYMENTREQUEST_0_INVNUM\":\"56\",\"L_PAYMENTREQUEST_0_NAME0\":\"\\u041c\\u043e\\u0439 \\u0437\\u0430\\u043a\\u0430\\u0437 \\u211656\",\"L_PAYMENTREQUEST_0_DESC0\":\"\",\"L_PAYMENTREQUEST_0_AMT0\":8628.27}', 'TOKEN=EC%2d0DK376706P7858238&TIMESTAMP=2015%2d08%2d18T14%3a41%3a33Z&CORRELATIONID=160d08a8c219c&ACK=Success&VERSION=74%2e0&BUILD=000000', '23', '56', '2015-08-18 21:41:31');
INSERT INTO `payment_log` VALUES ('17', null, '{\"METHOD\":\"SetExpressCheckout\",\"VERSION\":\"74.0\",\"RETURNURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=true\",\"CANCELURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=false\",\"PAYMENTREQUEST_0_AMT\":6104.9,\"PAYMENTREQUEST_0_CURRENCYCODE\":\"USD\",\"PAYMENTREQUEST_0_ITEMAMT\":6104.9,\"PAYMENTREQUEST_0_INVNUM\":\"60\",\"L_PAYMENTREQUEST_0_NAME0\":\"\\u041c\\u043e\\u0439 \\u0437\\u0430\\u043a\\u0430\\u0437 \\u211660\",\"L_PAYMENTREQUEST_0_DESC0\":\"\",\"L_PAYMENTREQUEST_0_AMT0\":6104.9}', 'TOKEN=EC%2d93E51695XF278633H&TIMESTAMP=2015%2d08%2d25T10%3a23%3a25Z&CORRELATIONID=eb8486696a63b&ACK=Success&VERSION=74%2e0&BUILD=000000', '23', '60', '2015-08-25 17:23:21');
INSERT INTO `payment_log` VALUES ('18', null, '{\"METHOD\":\"SetExpressCheckout\",\"VERSION\":\"74.0\",\"RETURNURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=true\",\"CANCELURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=false\",\"PAYMENTREQUEST_0_AMT\":1100.5,\"PAYMENTREQUEST_0_CURRENCYCODE\":\"EUR\",\"PAYMENTREQUEST_0_ITEMAMT\":1100.5,\"PAYMENTREQUEST_0_INVNUM\":\"1\",\"L_PAYMENTREQUEST_0_NAME0\":\"\\u041c\\u043e\\u0439 \\u0437\\u0430\\u043a\\u0430\\u0437 \\u21161\",\"L_PAYMENTREQUEST_0_DESC0\":\"\\u0422\\u0440\\u0438 \\u043c\\u0430\\u0433\\u043d\\u0438\\u0442\\u043e\\u0444\\u043e\\u043d\\u0430, \\u0442\\u0440\\u0438 \\u043a\\u0438\\u043d\\u043e\\u043a\\u0430\\u043c\\u0435\\u0440\\u044b \\u0437\\u0430\\u0433\\u0440\\u0430\\u043d\\u0438\\u0447\\u043d\\u044b\\u0445, \\u0442\\u0440\\u0438 \\u043f\\u043e\\u0440\\u0442\\u0441\\u0438\\u0433\\u0430\\u0440\\u0430 \\u043e\\u0442\\u0435\\u0447\\u0435\\u0441\\u0442\\u0432\\u0435\\u043d\\u043d\\u044b\\u0445, \\u043a\\u0443\\u0440\\u0442\\u043a\\u0430 \\u0437\\u0430\\u043c\\u0448\\u0435\\u0432\\u0430\\u044f\",\"L_PAYMENTREQUEST_0_AMT0\":1100.5}', 'Error:SSL certificate problem: unable to get local issuer certificate', '23', '1', '2015-09-10 21:31:09');
INSERT INTO `payment_log` VALUES ('19', null, '{\"METHOD\":\"SetExpressCheckout\",\"VERSION\":\"74.0\",\"RETURNURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=true\",\"CANCELURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=false\",\"PAYMENTREQUEST_0_AMT\":1100.5,\"PAYMENTREQUEST_0_CURRENCYCODE\":\"EUR\",\"PAYMENTREQUEST_0_ITEMAMT\":1100.5,\"PAYMENTREQUEST_0_INVNUM\":\"1\",\"L_PAYMENTREQUEST_0_NAME0\":\"\\u041c\\u043e\\u0439 \\u0437\\u0430\\u043a\\u0430\\u0437 \\u21161\",\"L_PAYMENTREQUEST_0_DESC0\":\"\\u0422\\u0440\\u0438 \\u043c\\u0430\\u0433\\u043d\\u0438\\u0442\\u043e\\u0444\\u043e\\u043d\\u0430, \\u0442\\u0440\\u0438 \\u043a\\u0438\\u043d\\u043e\\u043a\\u0430\\u043c\\u0435\\u0440\\u044b \\u0437\\u0430\\u0433\\u0440\\u0430\\u043d\\u0438\\u0447\\u043d\\u044b\\u0445, \\u0442\\u0440\\u0438 \\u043f\\u043e\\u0440\\u0442\\u0441\\u0438\\u0433\\u0430\\u0440\\u0430 \\u043e\\u0442\\u0435\\u0447\\u0435\\u0441\\u0442\\u0432\\u0435\\u043d\\u043d\\u044b\\u0445, \\u043a\\u0443\\u0440\\u0442\\u043a\\u0430 \\u0437\\u0430\\u043c\\u0448\\u0435\\u0432\\u0430\\u044f\",\"L_PAYMENTREQUEST_0_AMT0\":1100.5}', 'Error:SSL certificate problem: unable to get local issuer certificate', '23', '1', '2015-09-10 21:32:45');
INSERT INTO `payment_log` VALUES ('20', null, '{\"METHOD\":\"SetExpressCheckout\",\"VERSION\":\"74.0\",\"RETURNURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=true\",\"CANCELURL\":\"http:\\/\\/libereye.it\\/\\/account\\/mypurchases\\/?act=notify&success=false\",\"PAYMENTREQUEST_0_AMT\":6104.9,\"PAYMENTREQUEST_0_CURRENCYCODE\":\"EUR\",\"PAYMENTREQUEST_0_ITEMAMT\":6104.9,\"PAYMENTREQUEST_0_INVNUM\":\"60\",\"L_PAYMENTREQUEST_0_NAME0\":\"\\u041c\\u043e\\u0439 \\u0437\\u0430\\u043a\\u0430\\u0437 \\u211660\",\"L_PAYMENTREQUEST_0_DESC0\":\"\",\"L_PAYMENTREQUEST_0_AMT0\":6104.9}', 'Error:SSL certificate problem: unable to get local issuer certificate', '23', '60', '2015-09-10 21:33:08');
INSERT INTO `payment_log` VALUES ('21', null, '{\"METHOD\":\"SetExpressCheckout\",\"VERSION\":\"74.0\",\"RETURNURL\":\"http:\\/\\/libereye.it\\/\\/en\\/account\\/mypurchases\\/?act=notify&success=true\",\"CANCELURL\":\"http:\\/\\/libereye.it\\/\\/en\\/account\\/mypurchases\\/?act=notify&success=false\",\"PAYMENTREQUEST_0_AMT\":1436.89,\"PAYMENTREQUEST_0_CURRENCYCODE\":\"EUR\",\"PAYMENTREQUEST_0_ITEMAMT\":1436.89,\"PAYMENTREQUEST_0_INVNUM\":\"66\",\"L_PAYMENTREQUEST_0_NAME0\":\"\\u041c\\u043e\\u0439 \\u0437\\u0430\\u043a\\u0430\\u0437 \\u211666\",\"L_PAYMENTREQUEST_0_DESC0\":\"\\u041e\\u043f\\u0438\\u0441\\u0430\\u043d\\u0438\\u04351\",\"L_PAYMENTREQUEST_0_AMT0\":1436.89}', 'Error:SSL certificate problem: unable to get local issuer certificate', '23', '66', '2015-09-10 21:38:27');

-- ----------------------------
-- Table structure for pay_system
-- ----------------------------
DROP TABLE IF EXISTS `pay_system`;
CREATE TABLE `pay_system` (
  `pay_system_id` int(11) NOT NULL,
  `title` varchar(20) NOT NULL,
  PRIMARY KEY  (`pay_system_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pay_system
-- ----------------------------

-- ----------------------------
-- Table structure for pgroup
-- ----------------------------
DROP TABLE IF EXISTS `pgroup`;
CREATE TABLE `pgroup` (
  `pgroup_id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY  (`pgroup_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Группы типов товаров';

-- ----------------------------
-- Records of pgroup
-- ----------------------------
INSERT INTO `pgroup` VALUES ('1', 'Women\'s Clothing');
INSERT INTO `pgroup` VALUES ('2', 'Men\'s Clothes');
INSERT INTO `pgroup` VALUES ('3', 'Footwear');
INSERT INTO `pgroup` VALUES ('4', 'Accessories');
INSERT INTO `pgroup` VALUES ('5', 'Decorations');
INSERT INTO `pgroup` VALUES ('6', 'Cosmetics & Fragrances');
INSERT INTO `pgroup` VALUES ('7', 'Household products');
INSERT INTO `pgroup` VALUES ('8', 'Smartphones');
INSERT INTO `pgroup` VALUES ('9', 'Products for children');
INSERT INTO `pgroup` VALUES ('10', 'Bags');

-- ----------------------------
-- Table structure for price
-- ----------------------------
DROP TABLE IF EXISTS `price`;
CREATE TABLE `price` (
  `price_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `price` decimal(11,2) NOT NULL,
  `currency_id` int(11) NOT NULL,
  `cdate` datetime NOT NULL,
  PRIMARY KEY  (`price_id`),
  KEY `product_id` (`product_id`),
  KEY `shop_id` (`shop_id`),
  KEY `currency_id` (`currency_id`),
  CONSTRAINT `price_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
  CONSTRAINT `price_ibfk_2` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`),
  CONSTRAINT `price_ibfk_3` FOREIGN KEY (`currency_id`) REFERENCES `currency` (`currency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of price
-- ----------------------------

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `product_id` int(11) NOT NULL auto_increment,
  `brand_id` int(11) NOT NULL,
  `ptype_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `article` varchar(255) NOT NULL,
  PRIMARY KEY  (`product_id`),
  KEY `brand_id` USING BTREE (`brand_id`),
  KEY `ptype_id` USING BTREE (`ptype_id`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`brand_id`),
  CONSTRAINT `product_ibfk_2` FOREIGN KEY (`ptype_id`) REFERENCES `ptype` (`ptype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Таблица товаров';

-- ----------------------------
-- Records of product
-- ----------------------------

-- ----------------------------
-- Table structure for product2purchase
-- ----------------------------
DROP TABLE IF EXISTS `product2purchase`;
CREATE TABLE `product2purchase` (
  `product2purchase_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `amount` decimal(11,2) NOT NULL,
  `price` decimal(11,2) NOT NULL,
  `price_sum` decimal(11,2) NOT NULL,
  `vat` decimal(11,2) NOT NULL,
  `vat_sum` decimal(11,2) NOT NULL,
  `discount` decimal(11,2) NOT NULL,
  `discount_sum` decimal(11,2) NOT NULL,
  PRIMARY KEY  (`product2purchase_id`),
  KEY `purchase_id` (`purchase_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product2purchase_ibfk_1` FOREIGN KEY (`purchase_id`) REFERENCES `purchase` (`purchase_id`),
  CONSTRAINT `product2purchase_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of product2purchase
-- ----------------------------

-- ----------------------------
-- Table structure for ptype
-- ----------------------------
DROP TABLE IF EXISTS `ptype`;
CREATE TABLE `ptype` (
  `ptype_id` int(11) NOT NULL auto_increment,
  `shop_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `cdate` datetime NOT NULL,
  PRIMARY KEY  (`ptype_id`),
  KEY `shop_id` (`shop_id`),
  CONSTRAINT `ptype_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of ptype
-- ----------------------------
INSERT INTO `ptype` VALUES ('1', '1', 'Dresses', '2015-12-09 13:56:24');
INSERT INTO `ptype` VALUES ('2', '1', 'Coat', '2015-12-09 13:56:24');
INSERT INTO `ptype` VALUES ('3', '1', 'Jackets', '2015-12-09 13:56:24');
INSERT INTO `ptype` VALUES ('4', '1', 'Parks', '2015-12-09 13:56:24');
INSERT INTO `ptype` VALUES ('5', '1', 'Skirts', '2015-12-09 13:56:24');
INSERT INTO `ptype` VALUES ('6', '1', 'Pants', '2015-12-09 13:56:25');
INSERT INTO `ptype` VALUES ('7', '1', 'Blouses and shirts', '2015-12-09 13:56:25');
INSERT INTO `ptype` VALUES ('8', '1', 'Jeans', '2015-12-09 13:56:25');
INSERT INTO `ptype` VALUES ('9', '1', 'Sweaters and Knitwear', '2015-12-09 13:56:25');
INSERT INTO `ptype` VALUES ('10', '1', 'coveralls', '2015-12-09 13:56:25');
INSERT INTO `ptype` VALUES ('11', '1', 'Tops', '2015-12-09 13:56:25');
INSERT INTO `ptype` VALUES ('12', '1', 'Underwear', '2015-12-09 13:56:26');
INSERT INTO `ptype` VALUES ('13', '1', 'evening dresses', '2015-12-09 13:56:26');
INSERT INTO `ptype` VALUES ('14', '1', 'evening skirt', '2015-12-09 13:56:26');
INSERT INTO `ptype` VALUES ('15', '1', 'coats', '2015-12-09 13:56:26');
INSERT INTO `ptype` VALUES ('16', '1', 'Evening blouses', '2015-12-09 13:56:26');
INSERT INTO `ptype` VALUES ('17', '1', 'cocktail dress', '2015-12-09 13:56:27');
INSERT INTO `ptype` VALUES ('18', '1', 'evening pants', '2015-12-09 13:56:27');
INSERT INTO `ptype` VALUES ('19', '1', 'swimwear', '2015-12-09 13:56:27');
INSERT INTO `ptype` VALUES ('20', '1', 'fur', '2015-12-09 13:56:27');
INSERT INTO `ptype` VALUES ('21', '1', 'T-shirts', '2015-12-09 13:56:27');
INSERT INTO `ptype` VALUES ('22', '1', 'shorts', '2015-12-09 13:56:28');
INSERT INTO `ptype` VALUES ('23', '1', 'pareos', '2015-12-09 13:56:28');
INSERT INTO `ptype` VALUES ('24', '1', 'Shirts', '2015-12-09 13:56:28');
INSERT INTO `ptype` VALUES ('25', '1', 'Polo', '2015-12-09 13:56:28');
INSERT INTO `ptype` VALUES ('26', '1', 'Costumes', '2015-12-09 13:56:29');
INSERT INTO `ptype` VALUES ('27', '1', 'Underwear and socks', '2015-12-09 13:56:29');
INSERT INTO `ptype` VALUES ('28', '1', 'Blazers', '2015-12-09 13:56:29');
INSERT INTO `ptype` VALUES ('29', '1', 'The tuxedo', '2015-12-09 13:56:29');
INSERT INTO `ptype` VALUES ('30', '1', 'Shuba', '2015-12-09 13:56:30');
INSERT INTO `ptype` VALUES ('31', '1', 'Shoes', '2015-12-09 13:56:30');
INSERT INTO `ptype` VALUES ('32', '1', 'Boots and ankle boots', '2015-12-09 13:56:30');
INSERT INTO `ptype` VALUES ('33', '1', 'Sneakers', '2015-12-09 13:56:30');
INSERT INTO `ptype` VALUES ('34', '1', 'Ballet shoes', '2015-12-09 13:56:30');
INSERT INTO `ptype` VALUES ('35', '1', 'Lofer', '2015-12-09 13:56:31');
INSERT INTO `ptype` VALUES ('36', '1', 'sleepers', '2015-12-09 13:56:31');
INSERT INTO `ptype` VALUES ('37', '1', 'Sport shoes', '2015-12-09 13:56:31');
INSERT INTO `ptype` VALUES ('38', '1', 'Haytopy', '2015-12-09 13:56:31');
INSERT INTO `ptype` VALUES ('39', '1', 'Sandals', '2015-12-09 13:56:31');
INSERT INTO `ptype` VALUES ('40', '1', 'espadrilles', '2015-12-09 13:56:32');
INSERT INTO `ptype` VALUES ('41', '1', 'Thongs', '2015-12-09 13:56:32');
INSERT INTO `ptype` VALUES ('42', '1', 'Bots', '2015-12-09 13:56:32');
INSERT INTO `ptype` VALUES ('43', '1', 'Hats', '2015-12-09 13:56:32');
INSERT INTO `ptype` VALUES ('44', '1', 'Scarves', '2015-12-09 13:56:32');
INSERT INTO `ptype` VALUES ('45', '1', 'Gloves and mittens', '2015-12-09 13:56:32');
INSERT INTO `ptype` VALUES ('46', '1', 'Belts', '2015-12-09 13:56:33');
INSERT INTO `ptype` VALUES ('47', '1', 'Sunglasses', '2015-12-09 13:56:33');
INSERT INTO `ptype` VALUES ('48', '1', 'Glasses and rims', '2015-12-09 13:56:33');
INSERT INTO `ptype` VALUES ('49', '1', 'neckties', '2015-12-09 13:56:33');
INSERT INTO `ptype` VALUES ('50', '1', 'Cufflinks', '2015-12-09 13:56:33');
INSERT INTO `ptype` VALUES ('51', '1', 'Men beauticians', '2015-12-09 13:56:34');
INSERT INTO `ptype` VALUES ('52', '1', 'Wallets and business card holders', '2015-12-09 13:56:34');
INSERT INTO `ptype` VALUES ('53', '1', 'Cases for phones and tablets', '2015-12-09 13:56:34');
INSERT INTO `ptype` VALUES ('54', '1', 'scarves and shawls', '2015-12-09 13:56:34');
INSERT INTO `ptype` VALUES ('55', '1', 'Lighters', '2015-12-09 13:56:34');
INSERT INTO `ptype` VALUES ('56', '1', 'Pens', '2015-12-09 13:56:35');
INSERT INTO `ptype` VALUES ('57', '1', 'Necklaces and pendants', '2015-12-09 13:56:35');
INSERT INTO `ptype` VALUES ('58', '1', 'Earrings', '2015-12-09 13:56:35');
INSERT INTO `ptype` VALUES ('59', '1', 'Bracelets', '2015-12-09 13:56:35');
INSERT INTO `ptype` VALUES ('60', '1', 'Rings', '2015-12-09 13:56:35');
INSERT INTO `ptype` VALUES ('61', '1', 'Brooches and decorative pins', '2015-12-09 13:56:35');
INSERT INTO `ptype` VALUES ('62', '1', 'Jewelry', '2015-12-09 13:56:36');
INSERT INTO `ptype` VALUES ('63', '1', 'Clock', '2015-12-09 13:56:36');
INSERT INTO `ptype` VALUES ('64', '1', 'Vintage ornaments', '2015-12-09 13:56:36');
INSERT INTO `ptype` VALUES ('65', '1', 'Category', '2015-12-09 13:56:36');
INSERT INTO `ptype` VALUES ('66', '1', 'Cufflinks (Jewelry)', '2015-12-09 13:56:36');
INSERT INTO `ptype` VALUES ('67', '1', 'chain', '2015-12-09 13:56:36');
INSERT INTO `ptype` VALUES ('68', '1', 'Ring', '2015-12-09 13:56:37');
INSERT INTO `ptype` VALUES ('69', '1', 'Spirits', '2015-12-09 13:56:37');
INSERT INTO `ptype` VALUES ('70', '1', 'Pomade', '2015-12-09 13:56:37');
INSERT INTO `ptype` VALUES ('71', '1', 'Makeup', '2015-12-09 13:56:37');
INSERT INTO `ptype` VALUES ('72', '1', 'Powder', '2015-12-09 13:56:37');
INSERT INTO `ptype` VALUES ('73', '1', 'Cream', '2015-12-09 13:56:38');
INSERT INTO `ptype` VALUES ('74', '1', 'shadows', '2015-12-09 13:56:38');
INSERT INTO `ptype` VALUES ('75', '1', 'rouge', '2015-12-09 13:56:38');
INSERT INTO `ptype` VALUES ('76', '1', 'Lotion', '2015-12-09 13:56:38');
INSERT INTO `ptype` VALUES ('77', '1', 'night Cream', '2015-12-09 13:56:38');
INSERT INTO `ptype` VALUES ('78', '1', 'day Cream', '2015-12-09 13:56:38');
INSERT INTO `ptype` VALUES ('79', '1', 'Foundation', '2015-12-09 13:56:39');
INSERT INTO `ptype` VALUES ('80', '1', 'corrector', '2015-12-09 13:56:39');
INSERT INTO `ptype` VALUES ('81', '1', 'scrub', '2015-12-09 13:56:39');
INSERT INTO `ptype` VALUES ('82', '1', 'ink', '2015-12-09 13:56:39');
INSERT INTO `ptype` VALUES ('83', '1', 'kits', '2015-12-09 13:56:40');
INSERT INTO `ptype` VALUES ('84', '1', 'pillowcases', '2015-12-09 13:56:40');
INSERT INTO `ptype` VALUES ('85', '1', 'Blankets', '2015-12-09 13:56:41');
INSERT INTO `ptype` VALUES ('86', '1', 'Cushions', '2015-12-09 13:56:41');
INSERT INTO `ptype` VALUES ('87', '1', 'Vases', '2015-12-09 13:56:42');
INSERT INTO `ptype` VALUES ('88', '1', 'Decorative pillows', '2015-12-09 13:56:43');
INSERT INTO `ptype` VALUES ('89', '1', 'Furniture', '2015-12-09 13:56:44');
INSERT INTO `ptype` VALUES ('90', '1', 'blinds', '2015-12-09 13:56:46');
INSERT INTO `ptype` VALUES ('91', '1', 'Covers', '2015-12-09 13:56:47');
INSERT INTO `ptype` VALUES ('92', '1', 'Kitchen', '2015-12-09 13:56:48');
INSERT INTO `ptype` VALUES ('93', '1', 'Dishes', '2015-12-09 13:56:48');
INSERT INTO `ptype` VALUES ('94', '1', 'Textile', '2015-12-09 13:56:49');
INSERT INTO `ptype` VALUES ('95', '1', 'plaids', '2015-12-09 13:56:50');
INSERT INTO `ptype` VALUES ('96', '1', 'Towels', '2015-12-09 13:56:50');
INSERT INTO `ptype` VALUES ('97', '1', 'Candlesticks', '2015-12-09 13:56:51');
INSERT INTO `ptype` VALUES ('98', '1', 'Photo frame', '2015-12-09 13:56:52');
INSERT INTO `ptype` VALUES ('99', '1', 'Fixtures', '2015-12-09 13:56:52');
INSERT INTO `ptype` VALUES ('100', '1', 'Candles', '2015-12-09 13:56:53');
INSERT INTO `ptype` VALUES ('101', '1', 'Figurines', '2015-12-09 13:56:54');
INSERT INTO `ptype` VALUES ('102', '1', 'Caskets', '2015-12-09 13:56:54');
INSERT INTO `ptype` VALUES ('103', '1', 'Glasses', '2015-12-09 13:56:55');
INSERT INTO `ptype` VALUES ('104', '1', 'Plugs', '2015-12-09 13:56:56');
INSERT INTO `ptype` VALUES ('105', '1', 'Knives', '2015-12-09 13:56:56');
INSERT INTO `ptype` VALUES ('106', '1', 'Spoons', '2015-12-09 13:56:57');
INSERT INTO `ptype` VALUES ('107', '1', 'sets', '2015-12-09 13:56:58');
INSERT INTO `ptype` VALUES ('108', '1', 'Frying Pan', '2015-12-09 13:56:59');
INSERT INTO `ptype` VALUES ('109', '1', 'Lamps', '2015-12-09 13:56:59');
INSERT INTO `ptype` VALUES ('110', '1', 'Lighting', '2015-12-09 13:57:00');
INSERT INTO `ptype` VALUES ('111', '1', 'iPhone', '2015-12-09 13:57:00');
INSERT INTO `ptype` VALUES ('112', '1', 'iPad', '2015-12-09 13:57:00');
INSERT INTO `ptype` VALUES ('113', '1', 'iWatch', '2015-12-09 13:57:00');
INSERT INTO `ptype` VALUES ('114', '1', 'Smartphones Vertu', '2015-12-09 13:57:00');
INSERT INTO `ptype` VALUES ('115', '1', '  shirts', '2015-12-09 13:57:01');
INSERT INTO `ptype` VALUES ('116', '1', 'Toys', '2015-12-09 13:57:01');
INSERT INTO `ptype` VALUES ('117', '1', 'baby clothes', '2015-12-09 13:57:01');
INSERT INTO `ptype` VALUES ('118', '1', '  Mikey', '2015-12-09 13:57:02');
INSERT INTO `ptype` VALUES ('119', '1', 'Bags', '2015-12-09 13:57:02');
INSERT INTO `ptype` VALUES ('120', '1', 'Baggage', '2015-12-09 13:57:02');
INSERT INTO `ptype` VALUES ('121', '1', 'Shoulder Bags', '2015-12-09 13:57:02');
INSERT INTO `ptype` VALUES ('122', '1', 'Tote Bags,', '2015-12-09 13:57:02');
INSERT INTO `ptype` VALUES ('123', '1', 'Backpacks', '2015-12-09 13:57:03');
INSERT INTO `ptype` VALUES ('124', '1', 'clutches', '2015-12-09 13:57:03');
INSERT INTO `ptype` VALUES ('125', '1', 'Sport bags', '2015-12-09 13:57:03');
INSERT INTO `ptype` VALUES ('126', '1', 'Notebook bags', '2015-12-09 13:57:03');
INSERT INTO `ptype` VALUES ('127', '1', 'Briefcases', '2015-12-09 13:57:03');

-- ----------------------------
-- Table structure for ptype2group
-- ----------------------------
DROP TABLE IF EXISTS `ptype2group`;
CREATE TABLE `ptype2group` (
  `ptype2group_id` int(11) NOT NULL auto_increment,
  `ptype_id` int(11) NOT NULL,
  `pgroup_id` int(11) NOT NULL,
  PRIMARY KEY  (`ptype2group_id`),
  KEY `ptype_id` (`ptype_id`),
  KEY `ptype_group_id` (`pgroup_id`),
  CONSTRAINT `ptype2group_ibfk_2` FOREIGN KEY (`pgroup_id`) REFERENCES `pgroup` (`pgroup_id`),
  CONSTRAINT `ptype2group_ibfk_1` FOREIGN KEY (`ptype_id`) REFERENCES `ptype` (`ptype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of ptype2group
-- ----------------------------
INSERT INTO `ptype2group` VALUES ('1', '1', '1');
INSERT INTO `ptype2group` VALUES ('2', '2', '1');
INSERT INTO `ptype2group` VALUES ('3', '3', '1');
INSERT INTO `ptype2group` VALUES ('4', '3', '1');
INSERT INTO `ptype2group` VALUES ('5', '4', '1');
INSERT INTO `ptype2group` VALUES ('6', '5', '1');
INSERT INTO `ptype2group` VALUES ('7', '6', '1');
INSERT INTO `ptype2group` VALUES ('8', '7', '1');
INSERT INTO `ptype2group` VALUES ('9', '8', '1');
INSERT INTO `ptype2group` VALUES ('10', '9', '1');
INSERT INTO `ptype2group` VALUES ('11', '10', '1');
INSERT INTO `ptype2group` VALUES ('12', '11', '1');
INSERT INTO `ptype2group` VALUES ('13', '12', '1');
INSERT INTO `ptype2group` VALUES ('14', '13', '1');
INSERT INTO `ptype2group` VALUES ('15', '14', '1');
INSERT INTO `ptype2group` VALUES ('16', '15', '1');
INSERT INTO `ptype2group` VALUES ('17', '16', '1');
INSERT INTO `ptype2group` VALUES ('18', '17', '1');
INSERT INTO `ptype2group` VALUES ('19', '18', '1');
INSERT INTO `ptype2group` VALUES ('20', '19', '1');
INSERT INTO `ptype2group` VALUES ('21', '20', '1');
INSERT INTO `ptype2group` VALUES ('22', '3', '1');
INSERT INTO `ptype2group` VALUES ('23', '21', '1');
INSERT INTO `ptype2group` VALUES ('24', '22', '1');
INSERT INTO `ptype2group` VALUES ('25', '23', '1');
INSERT INTO `ptype2group` VALUES ('26', '15', '1');
INSERT INTO `ptype2group` VALUES ('27', '6', '1');
INSERT INTO `ptype2group` VALUES ('28', '24', '2');
INSERT INTO `ptype2group` VALUES ('29', '25', '2');
INSERT INTO `ptype2group` VALUES ('30', '3', '2');
INSERT INTO `ptype2group` VALUES ('31', '3', '2');
INSERT INTO `ptype2group` VALUES ('32', '2', '2');
INSERT INTO `ptype2group` VALUES ('33', '4', '2');
INSERT INTO `ptype2group` VALUES ('34', '24', '2');
INSERT INTO `ptype2group` VALUES ('35', '8', '2');
INSERT INTO `ptype2group` VALUES ('36', '6', '2');
INSERT INTO `ptype2group` VALUES ('37', '26', '2');
INSERT INTO `ptype2group` VALUES ('38', '9', '2');
INSERT INTO `ptype2group` VALUES ('39', '27', '2');
INSERT INTO `ptype2group` VALUES ('40', '28', '2');
INSERT INTO `ptype2group` VALUES ('41', '29', '2');
INSERT INTO `ptype2group` VALUES ('42', '30', '2');
INSERT INTO `ptype2group` VALUES ('43', '6', '2');
INSERT INTO `ptype2group` VALUES ('44', '31', '3');
INSERT INTO `ptype2group` VALUES ('45', '32', '3');
INSERT INTO `ptype2group` VALUES ('46', '31', '3');
INSERT INTO `ptype2group` VALUES ('47', '33', '3');
INSERT INTO `ptype2group` VALUES ('48', '34', '3');
INSERT INTO `ptype2group` VALUES ('49', '35', '3');
INSERT INTO `ptype2group` VALUES ('50', '36', '3');
INSERT INTO `ptype2group` VALUES ('51', '37', '3');
INSERT INTO `ptype2group` VALUES ('52', '38', '3');
INSERT INTO `ptype2group` VALUES ('53', '31', '3');
INSERT INTO `ptype2group` VALUES ('54', '39', '3');
INSERT INTO `ptype2group` VALUES ('55', '40', '3');
INSERT INTO `ptype2group` VALUES ('56', '39', '3');
INSERT INTO `ptype2group` VALUES ('57', '41', '3');
INSERT INTO `ptype2group` VALUES ('58', '42', '3');
INSERT INTO `ptype2group` VALUES ('59', '43', '4');
INSERT INTO `ptype2group` VALUES ('60', '44', '4');
INSERT INTO `ptype2group` VALUES ('61', '45', '4');
INSERT INTO `ptype2group` VALUES ('62', '46', '4');
INSERT INTO `ptype2group` VALUES ('63', '47', '4');
INSERT INTO `ptype2group` VALUES ('64', '48', '4');
INSERT INTO `ptype2group` VALUES ('65', '49', '4');
INSERT INTO `ptype2group` VALUES ('66', '50', '4');
INSERT INTO `ptype2group` VALUES ('67', '51', '4');
INSERT INTO `ptype2group` VALUES ('68', '52', '4');
INSERT INTO `ptype2group` VALUES ('69', '53', '4');
INSERT INTO `ptype2group` VALUES ('70', '54', '4');
INSERT INTO `ptype2group` VALUES ('71', '55', '4');
INSERT INTO `ptype2group` VALUES ('72', '56', '4');
INSERT INTO `ptype2group` VALUES ('73', '57', '5');
INSERT INTO `ptype2group` VALUES ('74', '58', '5');
INSERT INTO `ptype2group` VALUES ('75', '59', '5');
INSERT INTO `ptype2group` VALUES ('76', '60', '5');
INSERT INTO `ptype2group` VALUES ('77', '61', '5');
INSERT INTO `ptype2group` VALUES ('78', '62', '5');
INSERT INTO `ptype2group` VALUES ('79', '63', '5');
INSERT INTO `ptype2group` VALUES ('80', '64', '5');
INSERT INTO `ptype2group` VALUES ('81', '65', '5');
INSERT INTO `ptype2group` VALUES ('82', '66', '5');
INSERT INTO `ptype2group` VALUES ('83', '67', '5');
INSERT INTO `ptype2group` VALUES ('84', '68', '5');
INSERT INTO `ptype2group` VALUES ('85', '69', '6');
INSERT INTO `ptype2group` VALUES ('86', '70', '6');
INSERT INTO `ptype2group` VALUES ('87', '71', '6');
INSERT INTO `ptype2group` VALUES ('88', '72', '6');
INSERT INTO `ptype2group` VALUES ('89', '73', '6');
INSERT INTO `ptype2group` VALUES ('90', '74', '6');
INSERT INTO `ptype2group` VALUES ('91', '75', '6');
INSERT INTO `ptype2group` VALUES ('92', '76', '6');
INSERT INTO `ptype2group` VALUES ('93', '77', '6');
INSERT INTO `ptype2group` VALUES ('94', '78', '6');
INSERT INTO `ptype2group` VALUES ('95', '79', '6');
INSERT INTO `ptype2group` VALUES ('96', '80', '6');
INSERT INTO `ptype2group` VALUES ('97', '81', '6');
INSERT INTO `ptype2group` VALUES ('98', '76', '6');
INSERT INTO `ptype2group` VALUES ('99', '82', '6');
INSERT INTO `ptype2group` VALUES ('100', '83', '7');
INSERT INTO `ptype2group` VALUES ('101', '84', '7');
INSERT INTO `ptype2group` VALUES ('102', '85', '7');
INSERT INTO `ptype2group` VALUES ('103', '86', '7');
INSERT INTO `ptype2group` VALUES ('104', '87', '7');
INSERT INTO `ptype2group` VALUES ('105', '88', '7');
INSERT INTO `ptype2group` VALUES ('106', '89', '7');
INSERT INTO `ptype2group` VALUES ('107', '90', '7');
INSERT INTO `ptype2group` VALUES ('108', '91', '7');
INSERT INTO `ptype2group` VALUES ('109', '92', '7');
INSERT INTO `ptype2group` VALUES ('110', '93', '7');
INSERT INTO `ptype2group` VALUES ('111', '94', '7');
INSERT INTO `ptype2group` VALUES ('112', '95', '7');
INSERT INTO `ptype2group` VALUES ('113', '96', '7');
INSERT INTO `ptype2group` VALUES ('114', '97', '7');
INSERT INTO `ptype2group` VALUES ('115', '98', '7');
INSERT INTO `ptype2group` VALUES ('116', '99', '7');
INSERT INTO `ptype2group` VALUES ('117', '100', '7');
INSERT INTO `ptype2group` VALUES ('118', '101', '7');
INSERT INTO `ptype2group` VALUES ('119', '102', '7');
INSERT INTO `ptype2group` VALUES ('120', '103', '7');
INSERT INTO `ptype2group` VALUES ('121', '104', '7');
INSERT INTO `ptype2group` VALUES ('122', '105', '7');
INSERT INTO `ptype2group` VALUES ('123', '106', '7');
INSERT INTO `ptype2group` VALUES ('124', '107', '7');
INSERT INTO `ptype2group` VALUES ('125', '108', '7');
INSERT INTO `ptype2group` VALUES ('126', '109', '7');
INSERT INTO `ptype2group` VALUES ('127', '110', '7');
INSERT INTO `ptype2group` VALUES ('128', '111', '8');
INSERT INTO `ptype2group` VALUES ('129', '112', '8');
INSERT INTO `ptype2group` VALUES ('130', '113', '8');
INSERT INTO `ptype2group` VALUES ('131', '114', '8');
INSERT INTO `ptype2group` VALUES ('132', '1', '9');
INSERT INTO `ptype2group` VALUES ('133', '2', '9');
INSERT INTO `ptype2group` VALUES ('134', '3', '9');
INSERT INTO `ptype2group` VALUES ('135', '3', '9');
INSERT INTO `ptype2group` VALUES ('136', '4', '9');
INSERT INTO `ptype2group` VALUES ('137', '5', '9');
INSERT INTO `ptype2group` VALUES ('138', '6', '9');
INSERT INTO `ptype2group` VALUES ('139', '115', '9');
INSERT INTO `ptype2group` VALUES ('140', '8', '9');
INSERT INTO `ptype2group` VALUES ('141', '9', '9');
INSERT INTO `ptype2group` VALUES ('142', '10', '9');
INSERT INTO `ptype2group` VALUES ('143', '116', '9');
INSERT INTO `ptype2group` VALUES ('144', '117', '9');
INSERT INTO `ptype2group` VALUES ('145', '118', '9');
INSERT INTO `ptype2group` VALUES ('146', '8', '9');
INSERT INTO `ptype2group` VALUES ('147', '6', '9');
INSERT INTO `ptype2group` VALUES ('148', '6', '9');
INSERT INTO `ptype2group` VALUES ('149', '119', '10');
INSERT INTO `ptype2group` VALUES ('150', '120', '10');
INSERT INTO `ptype2group` VALUES ('151', '121', '10');
INSERT INTO `ptype2group` VALUES ('152', '122', '10');
INSERT INTO `ptype2group` VALUES ('153', '123', '10');
INSERT INTO `ptype2group` VALUES ('154', '124', '10');
INSERT INTO `ptype2group` VALUES ('155', '125', '10');
INSERT INTO `ptype2group` VALUES ('156', '126', '10');
INSERT INTO `ptype2group` VALUES ('157', '127', '10');

-- ----------------------------
-- Table structure for purchase
-- ----------------------------
DROP TABLE IF EXISTS `purchase`;
CREATE TABLE `purchase` (
  `purchase_id` int(11) NOT NULL auto_increment,
  `seller_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `booking_id` int(11) default NULL,
  `track_id` varchar(50) NOT NULL,
  `pay_system_id` int(11) default NULL,
  `description` text NOT NULL,
  `price` decimal(11,2) NOT NULL,
  `currency_id` int(11) NOT NULL default '0',
  `vat` decimal(11,2) NOT NULL,
  `delivery` decimal(11,2) NOT NULL,
  `status` enum('pending','paid','accepted') NOT NULL,
  `cdate` datetime NOT NULL,
  `udate` datetime NOT NULL,
  `accepted_date` datetime NOT NULL,
  `discount` decimal(11,2) NOT NULL,
  `discount_sum` decimal(11,2) NOT NULL,
  PRIMARY KEY  (`purchase_id`),
  KEY `account_id` (`account_id`),
  KEY `seller_id` (`seller_id`),
  KEY `booking_id` (`booking_id`),
  KEY `track_id` (`track_id`),
  KEY `currency_id` (`currency_id`),
  KEY `pay_system_id` (`pay_system_id`),
  CONSTRAINT `purchase_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `account` (`account_id`),
  CONSTRAINT `purchase_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `account` (`account_id`),
  CONSTRAINT `purchase_ibfk_3` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`),
  CONSTRAINT `purchase_ibfk_4` FOREIGN KEY (`currency_id`) REFERENCES `currency` (`currency_id`),
  CONSTRAINT `purchase_ibfk_5` FOREIGN KEY (`pay_system_id`) REFERENCES `pay_system` (`pay_system_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='InnoDB free: 8192 kB; (`account_id`) REFER `libereye2/accoun';

-- ----------------------------
-- Records of purchase
-- ----------------------------
INSERT INTO `purchase` VALUES ('1', '20', '23', null, '', null, 'Три магнитофона, три кинокамеры заграничных, три портсигара отечественных, куртка замшевая', '1000.00', '1', '20.00', '200.50', 'pending', '2015-08-12 19:54:04', '2015-08-12 19:54:04', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('2', '20', '23', null, '', null, '', '556.04', '1', '17.06', '73.62', 'pending', '2015-08-17 13:07:39', '2015-08-17 13:07:39', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('3', '20', '23', null, '', null, '', '1797.34', '1', '4.06', '81.88', 'pending', '2015-08-17 13:07:39', '2015-08-17 13:07:39', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('4', '20', '23', null, '', null, '', '8774.00', '1', '14.20', '62.63', 'pending', '2015-08-17 13:07:39', '2015-08-17 13:07:39', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('5', '20', '23', null, '', null, '', '3392.02', '1', '1.74', '99.34', 'pending', '2015-08-17 13:07:39', '2015-08-17 13:07:39', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('6', '20', '23', null, '', null, '', '4463.55', '1', '5.96', '255.91', 'pending', '2015-08-17 13:07:39', '2015-08-17 13:07:39', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('7', '20', '23', null, '', null, '', '5499.09', '1', '4.76', '90.75', 'pending', '2015-08-17 13:07:39', '2015-08-17 13:07:39', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('8', '20', '23', null, '', null, '', '9411.30', '1', '19.95', '50.24', 'pending', '2015-08-17 13:07:39', '2015-08-17 13:07:39', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('9', '20', '23', null, '', null, '', '4428.92', '1', '17.80', '69.41', 'pending', '2015-08-17 13:07:39', '2015-08-17 13:07:39', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('10', '20', '23', null, '', null, '', '208.11', '1', '10.25', '296.20', 'pending', '2015-08-17 13:07:39', '2015-08-17 13:07:39', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('11', '20', '23', null, '', null, '', '7067.78', '1', '14.30', '221.77', 'pending', '2015-08-17 13:07:39', '2015-08-17 13:07:39', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('12', '20', '23', null, '', null, '', '9803.62', '1', '17.10', '143.91', 'pending', '2015-08-17 13:07:39', '2015-08-17 13:07:39', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('13', '20', '23', null, '', null, '', '3459.75', '1', '7.27', '124.84', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('14', '20', '23', null, '', null, '', '2082.07', '1', '19.82', '101.59', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('15', '20', '23', null, '', null, '', '3152.63', '1', '14.01', '256.84', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('16', '20', '23', null, '', null, '', '5994.61', '1', '10.72', '103.90', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('17', '20', '23', null, '', null, '', '4447.88', '1', '4.62', '177.15', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('18', '20', '23', null, '', null, '', '3976.25', '1', '5.41', '267.03', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('19', '20', '23', null, '', null, '', '8007.43', '1', '8.33', '79.42', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('20', '20', '23', null, '', null, '', '3235.47', '1', '20.59', '44.05', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('21', '20', '23', null, '', null, '', '2637.29', '1', '21.95', '179.81', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('22', '20', '23', null, '', null, '', '3625.73', '1', '0.37', '295.76', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('23', '20', '23', null, '', null, '', '8851.67', '1', '11.71', '205.72', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('24', '20', '23', null, '', null, '', '238.71', '1', '1.55', '71.80', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('25', '20', '23', null, '', null, '', '101.52', '1', '8.32', '189.95', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('26', '20', '23', null, '', null, '', '1676.65', '1', '23.47', '57.33', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('27', '20', '23', null, '', null, '', '1390.58', '1', '3.05', '57.82', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('28', '20', '23', null, '', null, '', '5976.67', '1', '10.25', '77.36', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('29', '20', '23', null, '', null, '', '588.43', '1', '13.01', '127.93', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('30', '20', '23', null, '', null, '', '5704.41', '1', '14.32', '45.91', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('31', '20', '23', null, '', null, '', '465.32', '1', '19.34', '218.48', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('32', '20', '23', null, '', null, '', '3206.48', '1', '10.46', '39.04', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('33', '20', '23', null, '', null, '', '3954.55', '1', '14.67', '224.37', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('34', '20', '23', null, '', null, '', '9788.78', '1', '16.27', '95.11', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('35', '20', '23', null, '', null, '', '6329.99', '1', '5.35', '51.11', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('36', '20', '23', null, '', null, '', '2102.02', '1', '13.50', '20.70', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('37', '20', '23', null, '', null, '', '7252.19', '1', '10.48', '275.96', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('38', '20', '23', null, '', null, '', '3420.84', '1', '23.77', '218.29', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('39', '20', '23', null, '', null, '', '7858.35', '1', '18.66', '112.16', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('40', '20', '23', null, '', null, '', '6305.22', '1', '0.78', '79.03', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('41', '20', '23', null, '', null, '', '2242.19', '1', '8.27', '294.34', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('42', '20', '23', null, '', null, '', '9134.46', '1', '15.59', '113.59', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('43', '20', '23', null, '', null, '', '217.30', '1', '24.32', '239.62', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('44', '20', '23', null, '', null, '', '753.82', '1', '24.52', '203.15', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('45', '20', '23', null, '', null, '', '4438.82', '1', '4.70', '182.33', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('46', '20', '23', null, '', null, '', '4752.09', '1', '13.82', '101.41', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('47', '20', '23', null, '', null, '', '319.15', '1', '3.64', '189.54', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('48', '20', '23', null, '', null, '', '7225.27', '1', '17.93', '125.52', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('49', '20', '23', null, '', null, '', '9404.30', '1', '11.17', '124.02', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('50', '20', '23', null, '', null, '', '7261.46', '1', '9.76', '232.31', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('51', '20', '23', null, '', null, '', '7001.16', '1', '4.44', '236.15', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('52', '20', '23', null, '', null, '', '4033.31', '1', '16.38', '19.73', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('54', '20', '23', null, '', null, '', '1769.27', '1', '21.59', '236.08', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('55', '20', '23', null, '', null, '', '3440.75', '1', '8.99', '229.66', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('56', '20', '23', null, '', null, '', '7490.08', '1', '11.21', '298.55', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('57', '20', '23', null, '1WB43734K1424900A', null, '', '6305.88', '1', '4.18', '283.56', 'paid', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('58', '20', '23', null, '0M247999H7233073A', null, '', '2238.53', '1', '7.09', '224.00', 'paid', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('59', '20', '23', null, '', null, '', '8823.49', '1', '4.29', '63.55', 'pending', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('60', '20', '23', null, '', null, 'bbb', '5438.87', '1', '2.10', '236.36', 'pending', '2015-08-17 13:07:40', '2015-11-19 14:55:46', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('61', '20', '23', null, '25E08342LT661962G', null, '', '6875.48', '1', '1.85', '92.49', 'paid', '2015-08-17 13:07:40', '2015-08-17 13:07:40', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('66', '20', '23', '65', '', null, 'Описание1', '1501.00', '1', '21.00', '101.00', '', '2015-08-17 15:55:16', '2015-08-17 17:15:29', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('67', '20', '23', '65', '', null, 'товара', '1500.00', '1', '20.00', '100.00', 'pending', '2015-08-17 16:28:49', '2015-08-17 16:28:49', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('68', '20', '23', '72', '', null, 'ddd', '100.00', '1', '10.00', '10.00', 'pending', '2015-09-08 08:20:07', '2015-11-19 14:49:27', '0000-00-00 00:00:00', '0.00', '0.00');
INSERT INTO `purchase` VALUES ('69', '20', '23', '75', '', null, '111', '11.00', '1', '11.00', '111.00', 'pending', '2015-11-19 14:56:52', '2015-11-19 14:56:52', '0000-00-00 00:00:00', '0.00', '0.00');

-- ----------------------------
-- Table structure for setting
-- ----------------------------
DROP TABLE IF EXISTS `setting`;
CREATE TABLE `setting` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL default '',
  `code` varchar(100) NOT NULL default '',
  `val` mediumtext NOT NULL,
  `descr` text NOT NULL,
  `validation` varchar(20) NOT NULL default '',
  `pos` smallint(6) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of setting
-- ----------------------------
INSERT INTO `setting` VALUES ('1', 'Email суппорта', 'EMAIL_CONTACT', 'info@libereyes.com', '', 'email', '1');
INSERT INTO `setting` VALUES ('6', 'PayPal USER', 'PAYPAL_USER', 'rudserg-facilitator-us_api1.gmail.com', '', '', '4');
INSERT INTO `setting` VALUES ('4', 'Zoom API Key', 'ZOOM_API_KEY', 'mvo2zbQaQPyjRTF1i06r0g', '', '', '1');
INSERT INTO `setting` VALUES ('5', 'Zoom API Secret', 'ZOOM_API_SECRET', 'TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O', '', '', '1');
INSERT INTO `setting` VALUES ('7', 'PayPal PWD', 'PAYPAL_PWD', 'LA53JX2ZTUDC7RXK', '', '', '5');
INSERT INTO `setting` VALUES ('8', 'PayPal SIGNATURE', 'PAYPAL_SIGNATURE', 'AFcWxV21C7fd0v3bYYYRCpSSRl31AxXnrD825ZW4G3P0YF2bHoIWMikk', '', '', '6');
INSERT INTO `setting` VALUES ('9', 'PayPal Sandbox', 'PAYPAL_TEST_MODE', '1', '', 'bool', '6');
INSERT INTO `setting` VALUES ('10', 'Валюта оплаты по умолчанию', 'CURRENCYCODE', 'EUR', '', '', '1');
INSERT INTO `setting` VALUES ('11', 'OGONE_API_USER', 'OGONE_API_USER', 'libereye888', '', '', '1');
INSERT INTO `setting` VALUES ('12', 'OGONE_API_PASS', 'OGONE_API_PASS', 'PassPh8123234234', '', '', '1');
INSERT INTO `setting` VALUES ('13', 'OGONE_PSPID', 'OGONE_PSPID', 'libereye888', '', '', '1');
INSERT INTO `setting` VALUES ('14', 'OGONE_SHAIN', 'OGONE_SHAIN', 'PassPh8123234234', '', '', '1');
INSERT INTO `setting` VALUES ('15', 'OGONE_TEST_MODE', 'OGONE_TEST_MODE', '1', '', '', '1');
INSERT INTO `setting` VALUES ('16', 'OGONE_SHAOUT', 'OGONE_SHAOUT', 'PassPh8123234234', '', '', '1');

-- ----------------------------
-- Table structure for shop
-- ----------------------------
DROP TABLE IF EXISTS `shop`;
CREATE TABLE `shop` (
  `shop_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `timezone_id` int(11) default NULL,
  `promo_head` int(11) default NULL,
  `cdate` datetime NOT NULL,
  PRIMARY KEY  (`shop_id`),
  KEY `promo_head` (`promo_head`),
  KEY `timezone_id` (`timezone_id`),
  CONSTRAINT `shop_ibfk_1` FOREIGN KEY (`promo_head`) REFERENCES `image` (`image_id`),
  CONSTRAINT `shop_ibfk_2` FOREIGN KEY (`timezone_id`) REFERENCES `timezone` (`timezone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of shop
-- ----------------------------
INSERT INTO `shop` VALUES ('1', 'Galeries Lafayette', null, null, '2015-11-23 18:28:36');

-- ----------------------------
-- Table structure for shop2brand
-- ----------------------------
DROP TABLE IF EXISTS `shop2brand`;
CREATE TABLE `shop2brand` (
  `shop2brand_id` int(11) NOT NULL auto_increment,
  `shop_id` int(11) NOT NULL,
  `brand_id` int(11) NOT NULL,
  PRIMARY KEY  (`shop2brand_id`),
  KEY `shop_id` (`shop_id`),
  KEY `brand_id` (`brand_id`),
  CONSTRAINT `shop2brand_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`),
  CONSTRAINT `shop2brand_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`brand_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Связь магазина и бренда	';

-- ----------------------------
-- Records of shop2brand
-- ----------------------------

-- ----------------------------
-- Table structure for subscribe
-- ----------------------------
DROP TABLE IF EXISTS `subscribe`;
CREATE TABLE `subscribe` (
  `subscribe_id` int(11) NOT NULL auto_increment,
  `fname` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `cdate` datetime NOT NULL,
  PRIMARY KEY  (`subscribe_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of subscribe
-- ----------------------------
INSERT INTO `subscribe` VALUES ('1', 'sdfsd', 'sdf@gdf.fg', '2015-08-20 13:20:54');
INSERT INTO `subscribe` VALUES ('2', 'sdfsdf', 'sdsdf@sdfsdf.df', '2015-08-20 13:21:20');
INSERT INTO `subscribe` VALUES ('3', 'sdfsdf', 'sdfsd@sfsdf.df', '2015-08-20 13:22:08');
INSERT INTO `subscribe` VALUES ('4', 'sdfsdf', 'sdfsd@sdfsdf.df', '2015-08-20 13:22:37');
INSERT INTO `subscribe` VALUES ('5', 'Андрей', 'sdfsdf@sdfsdf.df', '2015-08-20 13:24:29');
INSERT INTO `subscribe` VALUES ('6', 'sdfsdf', 'sdfsd@sdfds.df', '2015-08-20 13:24:58');
INSERT INTO `subscribe` VALUES ('7', 'sdfsdfs', 'dfsdf@dfdfg.fg', '2015-08-20 13:25:27');
INSERT INTO `subscribe` VALUES ('8', 'Андрей', 'rudserggb@tut.by', '2015-09-09 16:10:18');

-- ----------------------------
-- Table structure for timezone
-- ----------------------------
DROP TABLE IF EXISTS `timezone`;
CREATE TABLE `timezone` (
  `timezone_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `code` varchar(50) NOT NULL,
  PRIMARY KEY  (`timezone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of timezone
-- ----------------------------

-- ----------------------------
-- Table structure for zoom_api
-- ----------------------------
DROP TABLE IF EXISTS `zoom_api`;
CREATE TABLE `zoom_api` (
  `id` int(11) NOT NULL auto_increment,
  `request` text NOT NULL,
  `response` text NOT NULL,
  `account_id` int(11) NOT NULL,
  `cdate` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `account_id` (`account_id`),
  CONSTRAINT `zoom_api_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `account` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of zoom_api
-- ----------------------------
INSERT INTO `zoom_api` VALUES ('1', '{\"id\":\"\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"error\":{\"code\":300,\"message\":\"Invalid input parameter: id\"}}', '23', '2015-08-15 14:37:53');
INSERT INTO `zoom_api` VALUES ('2', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"deleted_at\":\"2015-08-15T10:39:12Z\"}', '23', '2015-08-15 18:39:11');
INSERT INTO `zoom_api` VALUES ('3', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"email\":\"rudserg2@tut.by\",\"first_name\":\"\\u041d\\u0438\\u043a\\u043e\\u043b\\u0430\\u0439\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"error\":{\"code\":300,\"message\":\"Invalid input parameter: type\"}}', '23', '2015-08-15 18:39:12');
INSERT INTO `zoom_api` VALUES ('4', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"error\":{\"code\":1010,\"message\":\"User not belong to this account\"}}', '23', '2015-08-15 18:39:54');
INSERT INTO `zoom_api` VALUES ('5', '{\"email\":\"rudserg@tut.by\",\"type\":1,\"first_name\":\"\\u0412\\u0430\\u0441\\u044f\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"email\":\"rudserg@tut.by\",\"first_name\":\"Николай\",\"last_name\":\"\",\"pic_url\":\"\",\"type\":1,\"disable_chat\":false,\"disable_private_chat\":false,\"enable_e2e_encryption\":false,\"enable_silent_mode\":false,\"disable_group_hd\":false,\"disable_recording\":false,\"enable_large\":false,\"enable_webinar\":false,\"disable_feedback\":false,\"disable_jbh_reminder\":false,\"enable_cmr\":false,\"verified\":1,\"pmi\":2187930501,\"meeting_capacity\":0,\"dept\":\"\",\"created_at\":\"2015-08-15T10:10:48Z\",\"token\":\"\"}', '23', '2015-08-15 16:41:21');
INSERT INTO `zoom_api` VALUES ('6', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"deleted_at\":\"2015-08-15T10:42:04Z\"}', '23', '2015-08-15 15:12:04');
INSERT INTO `zoom_api` VALUES ('7', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"type\":1,\"email\":\"rudserg3@tut.by\",\"first_name\":\"\\u0412\\u0430\\u0441\\u044f2\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"GL66507sR5aRwBeY4wsqfA\",\"email\":\"rudserg3@tut.by\",\"first_name\":\"Вася2\",\"last_name\":\"\",\"pic_url\":\"\",\"type\":1,\"disable_chat\":false,\"disable_private_chat\":false,\"enable_e2e_encryption\":false,\"enable_silent_mode\":false,\"disable_group_hd\":false,\"disable_recording\":false,\"enable_large\":false,\"enable_webinar\":false,\"disable_feedback\":false,\"disable_jbh_reminder\":false,\"enable_cmr\":false,\"verified\":1,\"pmi\":7091542634,\"meeting_capacity\":0,\"created_at\":\"2015-08-15T10:42:05Z\",\"token\":\"\"}', '23', '2015-08-15 15:12:04');
INSERT INTO `zoom_api` VALUES ('8', '{\"id\":\"GL66507sR5aRwBeY4wsqfA\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"GL66507sR5aRwBeY4wsqfA\",\"deleted_at\":\"2015-08-15T10:42:36Z\"}', '23', '2015-08-15 15:12:35');
INSERT INTO `zoom_api` VALUES ('9', '{\"id\":\"GL66507sR5aRwBeY4wsqfA\",\"type\":1,\"email\":\"rudserg@tut.by\",\"first_name\":\"\\u0412\\u0430\\u0441\\u044f2\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"email\":\"rudserg@tut.by\",\"first_name\":\"Николай\",\"last_name\":\"\",\"pic_url\":\"\",\"type\":1,\"disable_chat\":false,\"disable_private_chat\":false,\"enable_e2e_encryption\":false,\"enable_silent_mode\":false,\"disable_group_hd\":false,\"disable_recording\":false,\"enable_large\":false,\"enable_webinar\":false,\"disable_feedback\":false,\"disable_jbh_reminder\":false,\"enable_cmr\":false,\"verified\":1,\"pmi\":2187930501,\"meeting_capacity\":0,\"created_at\":\"2015-08-15T10:10:48Z\",\"token\":\"\"}', '23', '2015-08-15 15:12:36');
INSERT INTO `zoom_api` VALUES ('10', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"first_name\":\"\\u0412\\u0430\\u0441\\u044f23\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"error\":{\"code\":300,\"message\":\"Invalid input parameter: type\"}}', '23', '2015-08-15 15:18:38');
INSERT INTO `zoom_api` VALUES ('11', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"type\":1,\"first_name\":\"\\u0412\\u0430\\u0441\\u044f23\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"updated_at\":\"2015-08-15T10:49:14Z\"}', '23', '2015-08-15 15:19:14');
INSERT INTO `zoom_api` VALUES ('12', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"type\":1,\"first_name\":\"\\u0410\\u043d\\u0434\\u0440\\u0435\\u0439\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"updated_at\":\"2015-08-15T10:53:52Z\"}', '23', '2015-08-15 15:23:52');
INSERT INTO `zoom_api` VALUES ('13', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"type\":1,\"first_name\":\"\\u0410\\u043d\\u0434\\u0440\\u0435\\u04392\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"updated_at\":\"2015-08-15T11:04:14Z\"}', '23', '2015-08-15 15:04:14');
INSERT INTO `zoom_api` VALUES ('14', '{\"email\":\"lenokru@gmail.com\",\"type\":1,\"first_name\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 #3\",\"timezone\":\"Asia\\/Kuala_Lumpur\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"25SXkeZHT3ac0JENaq6FUg\",\"email\":\"lenokru@gmail.com\",\"first_name\":\"Продавец #3\",\"last_name\":\"\",\"pic_url\":\"\",\"type\":1,\"disable_chat\":false,\"disable_private_chat\":false,\"enable_e2e_encryption\":false,\"enable_silent_mode\":false,\"disable_group_hd\":false,\"disable_recording\":false,\"enable_large\":false,\"enable_webinar\":false,\"disable_feedback\":false,\"disable_jbh_reminder\":false,\"enable_cmr\":false,\"verified\":1,\"pmi\":2901445176,\"meeting_capacity\":0,\"created_at\":\"2015-08-15T12:37:02Z\",\"token\":\"\"}', '23', '2015-08-15 16:37:01');
INSERT INTO `zoom_api` VALUES ('15', '{\"email\":\"lenokru@gmail.com\",\"type\":1,\"first_name\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 #3\",\"timezone\":\"Australia\\/Darwin\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"error\":{\"code\":1000,\"message\":\"Only available for Enabled Pre-provisioning SSO Partners\"}}', '23', '2015-08-15 17:05:25');
INSERT INTO `zoom_api` VALUES ('16', '{\"email\":\"lenokru@gmail.com\",\"type\":1,\"first_name\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 #3\",\"timezone\":\"Australia\\/Darwin\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"error\":{\"code\":1000,\"message\":\"Only available for Enabled Pre-provisioning SSO Partners\"}}', '23', '2015-08-15 17:06:42');
INSERT INTO `zoom_api` VALUES ('17', '{\"email\":\"rudserg@gmail.com\",\"type\":1,\"first_name\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 #4\",\"timezone\":\"Asia\\/Irkutsk\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"UUsQvKoZQX-49t1vAZDlYw\",\"email\":\"rudserg@gmail.com\",\"first_name\":\"Sergey\",\"last_name\":\"Ru\",\"pic_url\":\"null/p/UUsQvKoZQX-49t1vAZDlYw/0113c140-a748-4613-8438-cfc79d6cc578-9928\",\"type\":1,\"disable_chat\":false,\"disable_private_chat\":false,\"enable_e2e_encryption\":false,\"enable_silent_mode\":false,\"disable_group_hd\":false,\"disable_recording\":false,\"enable_large\":false,\"enable_webinar\":false,\"disable_feedback\":false,\"disable_jbh_reminder\":false,\"enable_cmr\":false,\"verified\":1,\"pmi\":5997423002,\"meeting_capacity\":0,\"dept\":\"\",\"timezone\":\"Europe/Moscow\",\"created_at\":\"2015-08-05T08:53:47Z\",\"token\":\"\"}', '23', '2015-08-15 17:52:21');
INSERT INTO `zoom_api` VALUES ('18', '{\"host_id\":\"UUsQvKoZQX-49t1vAZDlYw\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 #4 16\\/08\\/2015 09:00\",\"type\":2,\"start_type\":\"2015-08-16T09:00:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Irkutsk\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"s93oyU5zSEG79kW5XmtoNw==\",\"id\":337644188,\"host_id\":\"UUsQvKoZQX-49t1vAZDlYw\",\"topic\":\"Продавец #4 16/08/2015 09:00\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"\",\"duration\":30,\"timezone\":\"Asia/Irkutsk\",\"start_url\":\"https://api.zoom.us/s/337644188?zpk=gR1AWV-BqPFkNZi0-JrkJLNq8uJ3BM3e9_MLDQ2bp-0.BwYAAAFPMczOPQAAHCAkOWZlMDA3MTQtY2E3My00YmZlLWI5ZTQtOTM0NzUyZWRkMTNkFlVVc1F2S29aUVgtNDl0MXZBWkRsWXcWVVVzUXZLb1pRWC00OXQxdkFaRGxZdwlTZXJnZXkgUnVkALN4azdQYk9tV1BxUFNuVGZZYjVFLW8wZEtmT0YzWTJOd2kxRzZQcThKNk9NLkJnSWdVRkowYjJSR1J6Wm1jWEIzUzJWdGVGUm9TMEZ3WkVKM1JrcFNMMnBPU3paQVlXRTJObU13T0RsalpUQmtOalE0Tldaak5HSmxaVFZtWVRneU5HUmlZVGxsT1dGbU9UQXpPRGxpTmpNMk16VTBaREExTkRCbE1USmlOVEkxTkRKbU5nQQAAFlRhbU1LVWxGUjJlVndjZC1xN1Jnb3cCAQE\",\"join_url\":\"https://api.zoom.us/j/337644188\",\"created_at\":\"2015-08-15T14:39:09Z\"}', '23', '2015-08-15 23:39:09');
INSERT INTO `zoom_api` VALUES ('19', '{\"host_id\":\"UUsQvKoZQX-49t1vAZDlYw\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 #4 16\\/08\\/2015 09:30\",\"type\":2,\"start_type\":\"2015-08-16T09:30:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Irkutsk\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"fvakrcZSSAiAbkv63yO2Ag==\",\"id\":228348684,\"host_id\":\"UUsQvKoZQX-49t1vAZDlYw\",\"topic\":\"Продавец #4 16/08/2015 09:30\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"\",\"duration\":30,\"timezone\":\"Asia/Irkutsk\",\"start_url\":\"https://api.zoom.us/s/228348684?zpk=Um3NTsaKIqURjcBOtDeB1IG_o7VYYvYxI6TKtaZwMe8.BwYAAAFPMc8CVQAAHCAkMDIwYWFmYzktYmE5NC00NTkyLWI0OWEtYmJmMmYyOTJlYzBiFlVVc1F2S29aUVgtNDl0MXZBWkRsWXcWVVVzUXZLb1pRWC00OXQxdkFaRGxZdwlTZXJnZXkgUnVkALN4azdQYk9tV1BxUFNuVGZZYjVFLW8wZEtmT0YzWTJOd2kxRzZQcThKNk9NLkJnSWdVRkowYjJSR1J6Wm1jWEIzUzJWdGVGUm9TMEZ3WkVKM1JrcFNMMnBPU3paQVlXRTJObU13T0RsalpUQmtOalE0Tldaak5HSmxaVFZtWVRneU5HUmlZVGxsT1dGbU9UQXpPRGxpTmpNMk16VTBaREExTkRCbE1USmlOVEkxTkRKbU5nQQAAFlRhbU1LVWxGUjJlVndjZC1xN1Jnb3cCAQE\",\"join_url\":\"https://api.zoom.us/j/228348684\",\"created_at\":\"2015-08-15T14:41:34Z\"}', '23', '2015-08-15 23:41:33');
INSERT INTO `zoom_api` VALUES ('20', '{\"email\":\"paouccello@gmail.com\",\"type\":1,\"first_name\":\"\\u041a\\u043b\\u0438\\u0435\\u043d\\u0442\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"QWzkOYNCTrWmrOWWfWD3ew\",\"email\":\"paouccello@gmail.com\",\"first_name\":\"Клиент\",\"last_name\":\"\",\"pic_url\":\"\",\"type\":1,\"disable_chat\":false,\"disable_private_chat\":false,\"enable_e2e_encryption\":false,\"enable_silent_mode\":false,\"disable_group_hd\":false,\"disable_recording\":false,\"enable_large\":false,\"enable_webinar\":false,\"disable_feedback\":false,\"disable_jbh_reminder\":false,\"enable_cmr\":false,\"verified\":1,\"pmi\":8332273658,\"meeting_capacity\":0,\"created_at\":\"2015-08-15T14:58:21Z\",\"token\":\"\"}', '23', '2015-08-15 20:58:20');
INSERT INTO `zoom_api` VALUES ('21', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 16\\/08\\/2015 09:00\",\"type\":2,\"start_type\":\"2015-08-16T09:00:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"M/dOXgRTRZqyG9nVuyvqSg==\",\"id\":141660314,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 16/08/2015 09:00\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://api.zoom.us/s/141660314?zpk=o6U-p-u8AsOXwADo-KMRpAw0Z6UQeJm4uUBn2UT-2Yk.AwYkMjkwMzNjZWUtYjU0My00ZGEwLThmNDAtY2FhMmRjMjhkMDNjFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://api.zoom.us/j/141660314\",\"created_at\":\"2015-08-15T14:59:27Z\"}', '23', '2015-08-15 21:59:26');
INSERT INTO `zoom_api` VALUES ('22', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 16\\/08\\/2015 09:30\",\"type\":2,\"start_type\":\"2015-08-16ICT09:30:0025200\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"8XVt6cX+Q5ONzpX58eo3cw==\",\"id\":611635480,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 16/08/2015 09:30\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://api.zoom.us/s/611635480?zpk=uJciaH2Mri4BGmZBg6xK-_Fkzl_7v8y7QMCfyiZFjhg.AwYkMDNhNWUzMWYtODRlZS00YzExLWIyYTktZjNlOTIxOWRkYWM0FndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://api.zoom.us/j/611635480\",\"created_at\":\"2015-08-15T15:05:20Z\"}', '23', '2015-08-15 22:05:19');
INSERT INTO `zoom_api` VALUES ('23', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 16\\/08\\/2015 10:00\",\"type\":2,\"start_time\":\"2015-08-16ICT10:00:0025200\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"qOUix8nOTK243Bkt92PknQ==\",\"id\":742853696,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 16/08/2015 10:00\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://api.zoom.us/s/742853696?zpk=nvcsXPJ4D9XtFqb9BI6sF6qOIjpQKnIq7aXvo1CJwio.AwYkZDA4MWQwNmQtYzUyMS00NDRiLWI3MDMtMzFiMDkzNzNkZWNiFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://api.zoom.us/j/742853696\",\"created_at\":\"2015-08-15T15:06:21Z\"}', '23', '2015-08-15 22:06:20');
INSERT INTO `zoom_api` VALUES ('24', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 16\\/08\\/2015 10:30\",\"type\":2,\"start_time\":\"2015-08-16T10:30:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"tE+I21YGQci6hlnwcIIBtQ==\",\"id\":829105873,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 16/08/2015 10:30\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-08-16T10:30:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://api.zoom.us/s/829105873?zpk=LvvS6qpN1JZEh9fk5umOb9wKRTqVymCytIjp1jTC-VY.AwYkNTcyMjViZTAtZjZmYi00M2Y5LWE4NTItZjg5MTJkMWJkMDQ4FndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://api.zoom.us/j/829105873\",\"created_at\":\"2015-08-15T15:07:25Z\"}', '23', '2015-08-15 22:07:25');
INSERT INTO `zoom_api` VALUES ('25', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 16\\/08\\/2015 11:00\",\"type\":2,\"start_time\":\"2015-08-16T11:00:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"n8fVRPJOQtKg+VD0ZEtAhQ==\",\"id\":649787376,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 16/08/2015 11:00\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-08-16T11:00:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://api.zoom.us/s/649787376?zpk=y4yCM4VFimd1ZRCP9dKITGPsp_ROmnBJ_Cmh6jOBk74.AwYkNDkwYTRiYzktNGRkNS00MDc3LWJiZjctN2U4ODZkMzc1YjY4FndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://api.zoom.us/j/649787376\",\"created_at\":\"2015-08-15T15:09:57Z\"}', '23', '2015-08-15 22:09:56');
INSERT INTO `zoom_api` VALUES ('26', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 16\\/08\\/2015 15:30\",\"type\":2,\"start_time\":\"2015-08-16T15:30:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"nFgtA8vEQuy+vH9W2sEMtg==\",\"id\":250587742,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 16/08/2015 15:30\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-08-16T15:30:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://api.zoom.us/s/250587742?zpk=ZQLQvazHJPQyI3S2XOLJeCmUPsxiu5z3spf6enlpP9A.AwYkNGU1YzQzZDMtMmY1OS00YjI1LTk2MzQtNThkNThmNDMxY2I5FndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://api.zoom.us/j/250587742\",\"created_at\":\"2015-08-16T06:34:11Z\"}', '23', '2015-08-16 13:34:11');
INSERT INTO `zoom_api` VALUES ('27', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 16\\/08\\/2015 14:30\",\"type\":2,\"start_time\":\"2015-08-16T14:30:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"yZZlXFCjTuOV9agRvKEu3Q==\",\"id\":907973924,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 16/08/2015 14:30\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-08-16T14:30:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://api.zoom.us/s/907973924?zpk=Lo60wArLvhpOdnC2gLfHFpOXFrAGCaVPDJ6VaAGXkTU.AwYkMTBhMTFjNDktMjEzZC00YjMwLTliOTctOTM0NTZhNDkwOWIzFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://api.zoom.us/j/907973924\",\"created_at\":\"2015-08-16T06:55:45Z\"}', '23', '2015-08-16 13:55:45');
INSERT INTO `zoom_api` VALUES ('28', '{\"id\":\"907973924\",\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"907973924\",\"deleted_at\":\"2015-08-16T07:00:15Z\"}', '23', '2015-08-16 14:00:14');
INSERT INTO `zoom_api` VALUES ('29', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 16\\/08\\/2015 17:00\",\"type\":2,\"start_time\":\"2015-08-16T17:00:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"/26UuqNRQDayKRxngxR/LA==\",\"id\":119383373,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 16/08/2015 17:00\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-08-16T17:00:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://api.zoom.us/s/119383373?zpk=koC6Hpf7rjAZAaPL5HUBHKBdSER4Z9Xmsy9PAyPeSfY.AwYkYmQwNGQ0MWEtNDllNC00MjYyLTgzOGUtOGVhOWMzNWI1YmM2FndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://api.zoom.us/j/119383373\",\"created_at\":\"2015-08-16T07:00:52Z\"}', '23', '2015-08-16 14:00:51');
INSERT INTO `zoom_api` VALUES ('30', '{\"id\":\"119383373\",\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"119383373\",\"deleted_at\":\"2015-08-16T07:02:12Z\"}', '23', '2015-08-16 14:02:12');
INSERT INTO `zoom_api` VALUES ('31', '{\"id\":\"829105873\",\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"829105873\",\"deleted_at\":\"2015-08-16T07:50:12Z\"}', '23', '2015-08-16 09:50:12');
INSERT INTO `zoom_api` VALUES ('32', '{\"id\":\"742853696\",\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"742853696\",\"deleted_at\":\"2015-08-16T07:51:13Z\"}', '23', '2015-08-16 09:51:13');
INSERT INTO `zoom_api` VALUES ('33', '{\"id\":\"649787376\",\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"id\":\"649787376\",\"deleted_at\":\"2015-08-16T07:51:54Z\"}', '23', '2015-08-16 09:51:53');
INSERT INTO `zoom_api` VALUES ('34', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 18\\/08\\/2015 10:30\",\"type\":2,\"start_time\":\"2015-08-18T10:30:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"saIBuAUVTReaiJ3PrWGEvg==\",\"id\":737591994,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 18/08/2015 10:30\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-08-18T10:30:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://api.zoom.us/s/737591994?zpk=jNDvEAPrlsCtfREJdmjKEAoNNO8VLwH9y1oUkTMbLws.AwYkYTUwNDQ4YTgtMDk4My00YzJkLWE0YjAtMDM4Zjk4N2U2NTExFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://api.zoom.us/j/737591994\",\"created_at\":\"2015-08-17T10:35:34Z\"}', '23', '2015-08-17 17:35:33');
INSERT INTO `zoom_api` VALUES ('35', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 19\\/08\\/2015 15:30\",\"type\":2,\"start_time\":\"2015-08-19T15:30:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"Otri/p9FSfGJCZ485rQueQ==\",\"id\":204342116,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 19/08/2015 15:30\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-08-19T15:30:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://api.zoom.us/s/204342116?zpk=L7GA-eaazck49jvB1Eqq7oPDQecshdHEMEKKkmrKxqo.AwYkY2U0ZjdhMWMtOWZlMC00YTc0LWJkM2YtYjI1MzI1MjA4Y2ExFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://api.zoom.us/j/204342116\",\"created_at\":\"2015-08-17T15:35:59Z\"}', '23', '2015-08-17 22:35:58');
INSERT INTO `zoom_api` VALUES ('36', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 21\\/08\\/2015 10:30\",\"type\":2,\"start_time\":\"2015-08-21T10:30:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"LQIxIlPCRp6ZJGFbDiwCpw==\",\"id\":664866602,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 21/08/2015 10:30\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-08-21T10:30:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://api.zoom.us/s/664866602?zpk=l5eoKFuOAHdmN1wh3ObjHkBu_3k1-5WPNKRrwY6uPMY.AwYkZjJlMjIyNzItNTA5Mi00MjVlLWI3ZmQtYTNmMzNjODE0N2ZkFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://api.zoom.us/j/664866602\",\"created_at\":\"2015-08-17T18:40:19Z\"}', '23', '2015-08-18 01:40:17');
INSERT INTO `zoom_api` VALUES ('37', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 21\\/08\\/2015 15:30\",\"type\":2,\"start_time\":\"2015-08-21T15:30:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"V3eYEe76Sy2q1pfwP3gkXQ==\",\"id\":363443518,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 21/08/2015 15:30\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-08-21T15:30:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://api.zoom.us/s/363443518?zpk=1POkKlgp8IyEiZjlrWRxkebzg-kZsnHQvjNkWtp9Ydg.AwYkMjZjYWZjMjgtNjZlYS00OTNiLTlmYTEtMzI3ODVmMTMxMTcyFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://api.zoom.us/j/363443518\",\"created_at\":\"2015-08-17T18:40:24Z\"}', '23', '2015-08-18 01:40:22');
INSERT INTO `zoom_api` VALUES ('38', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 23\\/08\\/2015 11:00\",\"type\":2,\"start_time\":\"2015-08-23T11:00:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"LluU3bxoQtCyLwPlo3a7uw==\",\"id\":714422916,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 23/08/2015 11:00\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-08-23T11:00:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://api.zoom.us/s/714422916?zpk=wmHqjqTfpwFKS2CsPATiMyEdSFz0tyYrNxE_YktmJrc.AwYkOGU4MjkyNGQtZTRjNC00Yjg0LTk0OTAtODgxYzcyYzE5MGJjFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://api.zoom.us/j/714422916\",\"created_at\":\"2015-08-17T18:40:28Z\"}', '23', '2015-08-18 01:40:26');
INSERT INTO `zoom_api` VALUES ('39', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 21\\/08\\/2015 09:30\",\"type\":2,\"start_time\":\"2015-08-21T09:30:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"d3Ykg7UCRg2lUdPJw/AK5Q==\",\"id\":961460875,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 21/08/2015 09:30\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-08-21T09:30:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://libereye.zoom.us/s/961460875?zpk=YwgEupL8JbFcik455Sinz265Nqr4lTWsRSLrb1_immQ.AwYkYzE3ZGNhYzktZWJiNC00ZTMzLTgwNDItMGEyODliNDM5NTQwFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://libereye.zoom.us/j/961460875\",\"created_at\":\"2015-08-20T08:37:45Z\"}', '23', '2015-08-20 15:37:40');
INSERT INTO `zoom_api` VALUES ('40', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 21\\/08\\/2015 09:00\",\"type\":2,\"start_time\":\"2015-08-21T09:00:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"jDfkyIyyTryiOExcT/MFyg==\",\"id\":843360256,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 21/08/2015 09:00\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-08-21T09:00:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://libereye.zoom.us/s/843360256?zpk=ZcjH2AhFBfqUI9aCYJZvdn8hG60gecfUFOSkfLfr7Qw.AwYkMzljYmI4NTYtZWI3Yi00NTdjLWI1ZjYtNjI0MDAxN2E4NGNjFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://libereye.zoom.us/j/843360256\",\"created_at\":\"2015-08-20T08:43:48Z\"}', '23', '2015-08-20 15:43:44');
INSERT INTO `zoom_api` VALUES ('41', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 21\\/08\\/2015 11:00\",\"type\":2,\"start_time\":\"2015-08-21T11:00:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"ujc/WGJ1TgSAddTp3AdTgQ==\",\"id\":414477283,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 21/08/2015 11:00\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-08-21T11:00:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://libereye.zoom.us/s/414477283?zpk=_TkPDhZsi5kMSBkrVpjlyRzoQQTSd4_Snsva9-EAM4U.AwYkNzM0Y2U0M2QtZDkzYi00ZTExLWIzN2EtNDJjNmFhMTM1N2JjFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://libereye.zoom.us/j/414477283\",\"created_at\":\"2015-08-20T08:44:34Z\"}', '23', '2015-08-20 15:44:30');
INSERT INTO `zoom_api` VALUES ('42', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 21\\/08\\/2015 12:00\",\"type\":2,\"start_time\":\"2015-08-21T12:00:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"0iXe/Pd/S2G2G9P++uQeUA==\",\"id\":780402473,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 21/08/2015 12:00\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-08-21T12:00:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://libereye.zoom.us/s/780402473?zpk=OVk2dM-XdBVn8QpmlP3hUEDS0K8b_U6HQb9gvrGZCDM.AwYkZjNmYTYzNjMtNDg5Yi00OTBlLTgxMWItNzMwNzEwMWQ0ZjAyFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://libereye.zoom.us/j/780402473\",\"created_at\":\"2015-08-20T09:00:26Z\"}', '23', '2015-08-20 16:00:22');
INSERT INTO `zoom_api` VALUES ('43', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 21\\/08\\/2015 14:30\",\"type\":2,\"start_time\":\"2015-08-21T14:30:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"OLPbB/zOSsGcR4zF9AJkkg==\",\"id\":677100381,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 21/08/2015 14:30\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-08-21T14:30:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://libereye.zoom.us/s/677100381?zpk=uY29_aBrm2YU3MwF1Ka2n6unQqyytYlu3LIq10P9AZA.AwYkZTMyNmQ0MGMtNjg1Yy00YjQ5LTg3ZTYtM2ExNDI0NjRjMmRhFndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://libereye.zoom.us/j/677100381\",\"created_at\":\"2015-08-20T09:02:50Z\"}', '23', '2015-08-20 16:02:46');
INSERT INTO `zoom_api` VALUES ('44', '{\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"\\u041f\\u0440\\u043e\\u0434\\u0430\\u0432\\u0435\\u0446 \\u21161 12\\/09\\/2015 15:00\",\"type\":2,\"start_time\":\"2015-09-12T15:00:00Z\",\"duration\":30,\"timezone\":\"Asia\\/Saigon\",\"api_key\":\"mvo2zbQaQPyjRTF1i06r0g\",\"api_secret\":\"TeIIP1O0UKJgWwokw9pyGWyrABcuvBWTJm3O\"}', '{\"uuid\":\"Kt9MxleCRgW8PfywglLNTw==\",\"id\":100746364,\"host_id\":\"wEeMIWpXQsitCGb-WlFLPg\",\"topic\":\"Продавец №1 12/09/2015 15:00\",\"password\":\"\",\"h323_password\":\"\",\"status\":0,\"option_jbh\":false,\"option_start_type\":\"video\",\"option_host_video\":true,\"option_participants_video\":true,\"option_audio\":\"both\",\"type\":2,\"start_time\":\"2015-09-12T15:00:00Z\",\"duration\":30,\"timezone\":\"Asia/Saigon\",\"start_url\":\"https://libereye.zoom.us/s/100746364?zpk=MeIqCpKa8oWcTKRWGmuUuZIeB1C88PqaRC4JwwRFSsw.AwYkY2RhOGYwZjctNzdiOS00NThmLWE2ODgtZjhmOGRlNmYxN2E1FndFZU1JV3BYUXNpdENHYi1XbEZMUGcWd0VlTUlXcFhRc2l0Q0diLVdsRkxQZw3QkNC90LTRgNC10LkyYwBTYy1hX2NQa0Z5R0J6dmN1N3NfUWVBT3g3TksybkhlQXlKOUVxdi1wQXdXMC5CZ0lZVUZKMGIyUkdSelptY1hGUlkwcGlhM05pTlRVeWR6MDlBQUEAABZUYW1NS1VsRlIyZVZ3Y2QtcTdSZ293AgEB\",\"join_url\":\"https://libereye.zoom.us/j/100746364\",\"created_at\":\"2015-09-10T14:58:30Z\"}', '23', '2015-09-10 21:58:30');
