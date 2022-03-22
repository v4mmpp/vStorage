CREATE TABLE IF NOT EXISTS `society_storages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `society` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `count` int(11) NOT NULL,
  PRIMARY KEY (` id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
