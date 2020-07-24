CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authority` smallint(6) DEFAULT NULL,
  `user_id` varchar(50) DEFAULT NULL,
  `user_name` varchar(30) DEFAULT NULL,
  `dp_domain` varchar(50) DEFALUT NULL,
  `user_name` varchar(30) DEFAULT NULL,
  `department` varchar(128) DEFAULT NULL,
  `password_hash` varchar(128) DEFAULT NULL,
  `password_salt` varchar(128) DEFAULT NULL,
  `issue_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;
