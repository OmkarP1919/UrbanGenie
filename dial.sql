/*
MySQL Data Transfer
Source Host: localhost
Source Database: dial
Target Host: localhost
Target Database: dial
Date: 30-05-2024 13:14:13
*/

CREATE DATABASE IF NOT EXISTS `dial` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `dial`;

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `name` varchar(80) NOT NULL default '',
  `pwd` varchar(64) NOT NULL default '',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for booking
-- ----------------------------
DROP TABLE IF EXISTS `booking`;
CREATE TABLE `booking` (
  `sr` int(11) NOT NULL auto_increment,
  `ureg` int(11) default NULL,
  `uname` varchar(50) default NULL,
  `uemail` varchar(70) default NULL,
  `umob` varchar(50) default NULL,
  `uadr` varchar(50) default NULL,
  `udate` varchar(100) default NULL,
  `preg` int(11) default NULL,
  `shop` varchar(100) default NULL,
  `category` varchar(100) default NULL,
  `pemail` varchar(100) default NULL,
  `pmob` varchar(50) default NULL,
  `padr` varchar(100) default NULL,
  `status` varchar(30) default 'Pending',
  `slot` varchar(60) default 'Standard (Morning)',
  `notes` varchar(500) default '',
  PRIMARY KEY (`sr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for feedback
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `sr` int(11) NOT NULL auto_increment,
  `shop` varchar(80) default NULL,
  `feedb` varchar(500) default NULL,
  `uname` varchar(100) default NULL,
  PRIMARY KEY (`sr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for provider
-- ----------------------------
DROP TABLE IF EXISTS `provider`;
CREATE TABLE `provider` (
  `reg` int(11) NOT NULL default '0',
  `shop` varchar(80) default NULL,
  `name` varchar(80) default NULL,
  `category` varchar(80) default NULL,
  `adr` varchar(100) default NULL,
  `no` varchar(50) default NULL,
  `email` varchar(80) default NULL,
  `time` varchar(80) default NULL,
  `about` text,
  `pwd` varchar(64) default NULL,
  `status` varchar(20) default 'approved',
  PRIMARY KEY (`reg`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `reg` int(11) NOT NULL default '0',
  `name` varchar(80) default NULL,
  `email` varchar(80) default NULL,
  `no` varchar(50) default NULL,
  `adr` varchar(100) default NULL,
  `gen` varchar(10) default NULL,
  `pwd` varchar(64) default NULL,
  `status` varchar(20) default 'approved',
  PRIMARY KEY (`reg`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `admin` VALUES ('admin', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5'); -- SHA-256 for '12345'

INSERT INTO `feedback` (`shop`, `feedb`, `uname`) VALUES 
('Raj Electronics', '[5★] Excellent repair service and quick turnaround. Highly recommended!', 'Jay'),
('Jay Plumbing Services', '[5★] Very professional plumber, fixed pipeline leakage in 30 minutes.', 'Jay'),
('Raj Electronics', '[4★] Prompt service at home, very honest diagnosis.', 'Amol'),
('Aarti Electricals', '[5★] Reasonable pricing, neat wiring work, polite staff.', 'Pooja'),
('Ambajogai Home Painters', '[5★] Transformative paint finish, clean work without any mess.', 'Jay'),
('Shree Samarth Carpentry', '[5★] Custom furniture repaired perfectly on the same day.', 'Sachin');

-- Seeded Providers (Password '123' for all)
INSERT INTO `provider` VALUES 
('1', 'Raj Electronics', 'Raj Kale', 'Electronics', 'Mandi Bazar, Ambajogai', '9898989898', 'raj@gmail.com', '9:00 AM - 8:00 PM', 'Expert in TV, Microwave, Refrigerator and washing machine repair with 10+ years experience.', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'approved'),
('2', 'Aarti Electricals', 'Aarti Joshi', 'Electronics', 'Near Bus Stand, Ambajogai', '7878787878', 'arti@gmail.com', '8:30 AM - 7:30 PM', 'Fast domestic electrical wiring, inverter backup installation, and appliance servicing.', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'approved'),
('3', 'Jay Plumbing Services', 'Jay Patil', 'Plumber', 'Shivaji Chowk, Ambajogai', '8989898989', 'jayp@gmail.com', '8:00 AM - 8:00 PM', 'Certified plumbing specialist. Emergency water leakage, bathroom fittings, motor installation.', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'approved'),
('4', 'Ambajogai Home Painters', 'Ganesh Shinde', 'Painter', 'Parli Road, Ambajogai', '9123456780', 'ganesh@painters.com', '9:00 AM - 7:00 PM', 'Interior & exterior waterproof painting, texture art, wall putty and wallpaper installation.', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'approved'),
('5', 'Shree Samarth Carpentry', 'Vishnu Sutar', 'Carpenter', 'Ring Road, Ambajogai', '9876543210', 'vishnu@carpentry.com', '8:30 AM - 8:30 PM', 'Modular kitchen assembly, wooden door repairs, lock replacement, and bespoke woodwork.', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'approved'),
('6', 'CleanPro Deep Cleaning', 'Sunil Jadhav', 'Cleaning', 'Morewadi, Ambajogai', '9012345678', 'sunil@cleanpro.com', '8:00 AM - 6:00 PM', 'Comprehensive sofa shampooing, water tank disinfection, bathroom deep scrubbing.', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'approved');

INSERT INTO `user` VALUES 
('1', 'Jay', 's73385@gmail.com', '9090909090', 'Shivaji Chowk, Ambajogai', 'male', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'approved');

