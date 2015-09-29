-- MySQL dump 10.13  Distrib 5.5.44, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: nephology
-- ------------------------------------------------------
-- Server version	5.5.44-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `caste`
--

DROP TABLE IF EXISTS `caste`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `caste` (
  `id` int(11) NOT NULL,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `description` varchar(200) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `caste`
--

LOCK TABLES `caste` WRITE;
/*!40000 ALTER TABLE `caste` DISABLE KEYS */;
INSERT INTO `caste` VALUES (10,'2015-09-28 21:37:14','2015-09-28 21:37:14','generic virtualbox vm');
/*!40000 ALTER TABLE `caste` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `caste_rule`
--

DROP TABLE IF EXISTS `caste_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `caste_rule` (
  `id` int(11) NOT NULL,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `description` varchar(200) NOT NULL,
  `url` varchar(200) NOT NULL,
  `template` varchar(200) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `caste_rule`
--

LOCK TABLES `caste_rule` WRITE;
/*!40000 ALTER TABLE `caste_rule` DISABLE KEYS */;
INSERT INTO `caste_rule` VALUES (10,'2015-09-28 21:41:30','2015-09-28 21:41:30','Partition OS disk w/standard layout','/scripts/parted-os-standard.sh',''),(20,'2015-09-28 21:42:39','2015-09-28 21:42:39','Bootstrap with Ubuntu 14.04','','os/trusty.sh'),(9999,'2015-09-28 21:38:46','2015-09-28 21:38:46','Reboot','','os/reboot.sh');
/*!40000 ALTER TABLE `caste_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `map_caste_rule`
--

DROP TABLE IF EXISTS `map_caste_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `map_caste_rule` (
  `caste_id` int(11) NOT NULL,
  `caste_rule_id` int(11) NOT NULL,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `priority` int(11) NOT NULL,
  KEY `caste_id` (`caste_id`,`caste_rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `map_caste_rule`
--

LOCK TABLES `map_caste_rule` WRITE;
/*!40000 ALTER TABLE `map_caste_rule` DISABLE KEYS */;
INSERT INTO `map_caste_rule` VALUES (10,10,'2015-09-28 21:44:18','2015-09-28 21:44:18',100),(10,20,'2015-09-28 21:44:32','2015-09-28 21:44:32',150),(10,9999,'2015-09-28 21:44:39','2015-09-28 21:44:39',9999);
/*!40000 ALTER TABLE `map_caste_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node`
--

DROP TABLE IF EXISTS `node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `asset_tag` varchar(10) NOT NULL,
  `hostname` varchar(50) DEFAULT NULL,
  `boot_mac` varchar(20) NOT NULL,
  `admin_user` varchar(20) NOT NULL,
  `admin_password` varchar(100) NOT NULL,
  `ipmi_user` varchar(20) NOT NULL,
  `ipmi_password` varchar(100) NOT NULL,
  `caste_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL DEFAULT '1',
  `domain` varchar(50) NOT NULL,
  `primary_ip` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `status_id` (`status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node`
--

LOCK TABLES `node` WRITE;
/*!40000 ALTER TABLE `node` DISABLE KEYS */;
/*!40000 ALTER TABLE `node` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_status`
--

DROP TABLE IF EXISTS `node_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_status` (
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `status_id` int(11) NOT NULL,
  `template` varchar(45) NOT NULL,
  `next_status` int(11) DEFAULT NULL,
  KEY `status_id` (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_status`
--

LOCK TABLES `node_status` WRITE;
/*!40000 ALTER TABLE `node_status` DISABLE KEYS */;
INSERT INTO `node_status` VALUES ('2015-09-28 21:34:54','2015-09-28 21:34:54',1,'bootstrap.ipxe',1000),('2015-09-28 21:35:08','2015-09-28 21:35:08',1000,'localboot.ipxe',NULL),('2015-09-28 21:35:58','2015-09-28 21:35:58',2000,'rescue.ipxe',NULL);
/*!40000 ALTER TABLE `node_status` ENABLE KEYS */;
UNLOCK TABLES;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-09-28 21:50:26
