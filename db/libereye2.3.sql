/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50018
Source Host           : localhost:3306
Source Database       : libereye2

Target Server Type    : MYSQL
Target Server Version : 50018
File Encoding         : 65001

Date: 2015-12-07 18:33:14
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
-- Table structure for currency
-- ----------------------------
DROP TABLE IF EXISTS `currency`;
CREATE TABLE `currency` (
  `currency_id` int(11) NOT NULL,
  `code` varchar(3) NOT NULL,
  PRIMARY KEY  (`currency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
-- Table structure for lang_phrase
-- ----------------------------
DROP TABLE IF EXISTS `lang_phrase`;
CREATE TABLE `lang_phrase` (
  `lang_phrase_id` int(11) NOT NULL auto_increment,
  `language_id` int(11) NOT NULL,
  `object_type` enum('common','product','ptype','shop','open_time','brand','ptype_group','country') NOT NULL,
  `object_field` varchar(50) NOT NULL,
  `object_id` int(11) NOT NULL,
  `alias` varchar(255) NOT NULL,
  `phrase` text NOT NULL,
  PRIMARY KEY  (`lang_phrase_id`),
  UNIQUE KEY `language_id_2` (`language_id`,`alias`),
  KEY `language_id` (`language_id`),
  KEY `alias` (`alias`),
  KEY `object_id` (`object_id`),
  KEY `object_type` (`object_type`),
  KEY `object_field` (`object_field`),
  CONSTRAINT `lang_phrase_ibfk_1` FOREIGN KEY (`language_id`) REFERENCES `language` (`language_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  CONSTRAINT `payment_log_ibfk_3` FOREIGN KEY (`pay_system_id`) REFERENCES `pay_system` (`pay_system_id`),
  CONSTRAINT `payment_log_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `account` (`account_id`),
  CONSTRAINT `payment_log_ibfk_2` FOREIGN KEY (`purchase_id`) REFERENCES `purchase` (`purchase_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
-- Table structure for ptype
-- ----------------------------
DROP TABLE IF EXISTS `ptype`;
CREATE TABLE `ptype` (
  `ptype_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `cdate` datetime NOT NULL,
  PRIMARY KEY  (`ptype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for ptype2group
-- ----------------------------
DROP TABLE IF EXISTS `ptype2group`;
CREATE TABLE `ptype2group` (
  `ptype2group_id` int(11) NOT NULL auto_increment,
  `ptype_id` int(11) NOT NULL,
  `ptype_group_id` int(11) NOT NULL,
  PRIMARY KEY  (`ptype2group_id`),
  KEY `ptype_id` (`ptype_id`),
  KEY `ptype_group_id` (`ptype_group_id`),
  CONSTRAINT `ptype2group_ibfk_2` FOREIGN KEY (`ptype_group_id`) REFERENCES `ptype_group` (`ptype_group_id`),
  CONSTRAINT `ptype2group_ibfk_1` FOREIGN KEY (`ptype_id`) REFERENCES `ptype` (`ptype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for ptype2shop
-- ----------------------------
DROP TABLE IF EXISTS `ptype2shop`;
CREATE TABLE `ptype2shop` (
  `ptype2shop_id` int(11) NOT NULL auto_increment,
  `ptype_id` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  PRIMARY KEY  (`ptype2shop_id`),
  KEY `ptype_id` (`ptype_id`),
  KEY `shop_id` (`shop_id`),
  CONSTRAINT `ptype2shop_ibfk_2` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`),
  CONSTRAINT `ptype2shop_ibfk_1` FOREIGN KEY (`ptype_id`) REFERENCES `ptype` (`ptype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Таблица связи типа товара с мага�';

-- ----------------------------
-- Table structure for ptype_group
-- ----------------------------
DROP TABLE IF EXISTS `ptype_group`;
CREATE TABLE `ptype_group` (
  `ptype_group_id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY  (`ptype_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Группы типов товаров';

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
  CONSTRAINT `shop_ibfk_2` FOREIGN KEY (`timezone_id`) REFERENCES `timezone` (`timezone_id`),
  CONSTRAINT `shop_ibfk_1` FOREIGN KEY (`promo_head`) REFERENCES `image` (`image_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  CONSTRAINT `shop2brand_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`brand_id`),
  CONSTRAINT `shop2brand_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Связь магазина и бренда	';

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
