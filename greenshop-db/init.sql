/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.6.21-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: greenshop
-- ------------------------------------------------------
-- Server version	10.6.21-MariaDB-0ubuntu0.22.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `products`
--
CREATE DATABASE IF NOT EXISTS greenshop;
USE greenshop;

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Tomato','Fresh organic tomatoes from local farms.',2.50,NULL),(2,'Carrot','Crunchy and sweet organic carrots.',1.80,NULL),(3,'Zucchini','Green organic zucchini, perfect for grilling.',2.00,NULL),(4,'Strawberry','Sweet and juicy organic strawberries.',3.00,NULL),(5,'Spinach','Freshly harvested organic spinach.',1.50,NULL),(6,'Banana','Ripe organic bananas, naturally sweet.',2.20,NULL),(7,'Apple','Crisp and delicious organic apples.',2.80,NULL);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'machin','machin@truc.com','$2y$10$ZabHGAasSKNZIHkOD4AhiO.YOTijPvPj0VZ4xRzCrGheLmuv6wdFq','2025-05-04 09:42:10'),(2,'Emma Dupuis','emma.dupuis@example.com','$2y$10$E7byyT0YgV5bqvq8YSHCE.sgkZY7qpycV4mI1I2nKl/6.CpDTX.Si','2025-05-04 09:55:48'),(3,'Léo Martin','leo.martin@example.com','$2y$10$B8KUl9d6pqXU6w4EcmJ.F.cXkJHpaPSQAk2cdP0CKfb7n0Ewnhuwy','2025-05-04 09:55:48'),(4,'Sophie Lefevre','sophie.lefevre@example.com','$2y$10$EKByRHG3tO0EfpYzGeXZPpYoVxXSP4Rmz.D1wUijxxkGoCmZ6nsia','2025-05-04 09:55:48'),(5,'Lucas Bernard','lucas.bernard@example.com','$2y$10$M8Xhw7EZ73.FVz8cgs7FfOlL72TRFzHGy2DOEX8bF9sOjX/qHHHZq','2025-05-04 09:55:48'),(6,'Charlotte Renault','charlotte.renault@example.com','$2y$10$0ljlWkcNVhDJfI5vWv4XbXwwZtrKTwOuAdlX4YmIObJthY0qjWcwy','2025-05-04 09:55:48'),(7,'Maxime Laurent','maxime.laurent@example.com','$2y$10$yOZvAh08n0yXX9tgmVZ02eIwhWVXx3wR7dL0FDnpNxsI6A7RJwrWS','2025-05-04 09:55:48'),(8,'Juliette Moreau','juliette.moreau@example.com','$2y$10$lbGmbJ2cDvmQ8ITRhfMw9czkSYvMPXUgyTohMQpYchv5QJdHiqyeO','2025-05-04 09:55:48'),(9,'Pierre Dubois','pierre.dubois@example.com','$2y$10$FZVhfV4mG6nVYd7v07sePceZbD1f04xyhmgZ79jZtr61t5OBvmw7A','2025-05-04 09:55:48'),(10,'Camille Petit','camille.petit@example.com','$2y$10$5HbA9QbbYtveFA1j3PYn5ugRdtZZ2g9htrhzlIs1BdGVyM9cYv7nS','2025-05-04 09:55:48'),(11,'Antoine Lefevre','antoine.lefevre@example.com','$2y$10$O1UddX21XnB2W1n6C8cVveLRGrI9z8DniXUUMDi8zMjqkl7DrDGrq','2025-05-04 09:55:48'),(12,'Lucie Lefevre','lucie.lefevre@example.com','$2y$10$ThgsPqDSoA.ZtstVmlN57jfnh2Ubzn2iO.Qfn/q2tMt.WnHKTzY.O','2025-05-04 09:55:48'),(13,'Hugo Lefevre','hugo.lefevre@example.com','$2y$10$gfON2vZpyOXEXI1A4XGdIu/Zjxn5YZNYyxtltVvHlDEeDtwGhzvmO','2025-05-04 09:55:48'),(14,'Clara Lemoine','clara.lemoine@example.com','$2y$10$Yo.Lu1QHlti7DThh7w8nMWW3uf7Y9mQXgGhbsnQnRmn6WygtqDW2K','2025-05-04 09:55:48'),(15,'Marius Faure','marius.faure@example.com','$2y$10$kbTLZX3MSBaZEvSxqNcTb.JulHJz.DjOE1XkJ2vOjoA6NmcDZwEOA','2025-05-04 09:55:48'),(16,'Isabelle Girard','isabelle.girard@example.com','$2y$10$tnVzzccLIXK2TVtICcV5nq2HlhH42lUL3TbgN/xgKnKLOsEjH2uZi','2025-05-04 09:55:48'),(17,'Olivier Lemoine','olivier.lemoine@example.com','$2y$10$CxwWn5O0qz9QsoIsSm2H5yrsyPFRt7nX78BlNUq1IgRI92cIu3jse','2025-05-04 09:55:48'),(18,'Julien Arnaud','julien.arnaud@example.com','$2y$10$YfESz.7PwwFmwcfI1v9q6oMYu76Fdyhwm9jQhOcd9OhOxVG0jr2Te','2025-05-04 09:55:48'),(19,'Léa Girard','lea.girard@example.com','$2y$10$nl3MFOSV9iGHv9al66ZSKhQZErvgchPgfSyKrw7jLOPqc9Nhk9jiG','2025-05-04 09:55:48'),(20,'Georges Robert','georges.robert@example.com','$2y$10$8mH2LHYjJGRWqaeHUcOepeYY9uDbk27xVlhgE9gNxwHt4GQ0TzVhS','2025-05-04 09:55:48'),(21,'Alice Lefevre','alice.lefevre@example.com','$2y$10$flPi5iymtXyfnXosLPmpvq6mr2jmXeOLZp4xqz1FnIxkSxZc9L0w6','2025-05-04 09:55:48'),(22,'David Lefevre','david.lefevre@example.com','$2y$10$OZZXjOVCdugmp6GowIdO6mkAHYNkBoWnUzLQ0rNhtTZQduBR6S0My','2025-05-04 09:55:48'),(23,'Fanny Perrot','fanny.perrot@example.com','$2y$10$dsE0taJmvZ5.s5t6ZXA4HYYLhXx6nLCX2QhJ5FzckTw41tn.m1Pf2','2025-05-04 09:55:48'),(24,'Louis Roux','louis.roux@example.com','$2y$10$8iKzOMg1PkpV4jmSSQUbgG0VG9LtjUwFeA5vcYijPZn8.VnlYHp5e','2025-05-04 09:55:48'),(25,'Emma Picard','emma.picard@example.com','$2y$10$B38XMpwptmvJqhoYWY.mXa9n6Lxl7mCU4Ymlt7.P5ymSYNeFgM8r2','2025-05-04 09:55:48'),(26,'Marc Hebert','marc.hebert@example.com','$2y$10$ntk9.rqKZ8XmYqJbsF6biBRcbxYm9gJqBb7nJ3zN5XQI1iHws7C1y','2025-05-04 09:55:48'),(27,'Zoé Lefevre','zoe.lefevre@example.com','$2y$10$RthgiVgCqIfg3GnmxgBe1kmDdBlvg2BBs0Bdf8hz0mfJ7yI1QLbCi','2025-05-04 09:55:48'),(28,'Benjamin Robert','benjamin.robert@example.com','$2y$10$3nnhLbZRdKHAtgTISop1kTt2TLyZtJqMIAKDe7dfLYU2gJ3hfTcyO','2025-05-04 09:55:48'),(29,'Sarah Lefevre','sarah.lefevre@example.com','$2y$10$GdD7m2q0tuOvX4w7gUwR6iBFFZyFmdphHtY10FMiNnFcBCTOmjB1e','2025-05-04 09:55:48'),(30,'Théo Martin','theo.martin@example.com','$2y$10$hyWtnvKrsFOnh0nMNPL9R51.k.bJrd7DZ9r.l9fnK5mcCZyYXJ7ne','2025-05-04 09:55:48'),(31,'Amandine Charpentier','amandine.charpentier@example.com','$2y$10$fdZY9SJL03bRP2.EvmlOLpx42W2vh0SY7jtJ5DgmL6.kXwbJmFMze','2025-05-04 09:55:48'),(32,'Vincent Lefevre','vincent.lefevre@example.com','$2y$10$wBoRIvh3jgnLxS0XqO4z7aJ62UOoD6CINmHfSb6BqLlxjMSwTj4tK','2025-05-04 09:55:48'),(33,'Noémie Deleuze','noemie.deleuze@example.com','$2y$10$0J13TrKfcsDeVdiT8TOIMjQLLf79FZzLDm4USkIc26owI3m0Qyz8m','2025-05-04 09:55:48'),(34,'Claire Robert','claire.robert@example.com','$2y$10$QxFz.rmjOZ.tTGM2Y47BpqbnK.JD1HUGQUrNfgZz5GEhBOibLhzZG','2025-05-04 09:55:48'),(35,'Mathieu Perrot','mathieu.perrot@example.com','$2y$10$wrEm1jW4zNGLw3ZLoV5WRJlknsbchb3sqGV17RGxB/2pjywBixHb6','2025-05-04 09:55:48'),(36,'Paul Hebert','paul.hebert@example.com','$2y$10$yRAHVh5c16Bjf7fgcob5rK1wOxjN9yJzFFktwTg3quU0bRvlc.XXS','2025-05-04 09:55:48'),(37,'Thomas Arnaud','thomas.arnaud@example.com','$2y$10$4X7BLPVR5wPrYlEuRShg9WIs.dKl0pmgwmWGtFfEjIfvX2xEIBK2O','2025-05-04 09:55:48'),(38,'Nina Roux','nina.roux@example.com','$2y$10$Tb7LFUjpzvDBli9OdzJ6yKhD4Ij7TnEs54Bl2H1gryyRYs8gBGYje','2025-05-04 09:55:48'),(39,'Clément Faure','clement.faure@example.com','$2y$10$8qYwnE1MZVR8DMyxzN.x2zRGyYr0p5k6QWuSQVh7fvEvC9Gnfa98K','2025-05-04 09:55:48'),(40,'Alice Picard','alice.picard@example.com','$2y$10$hXMNXHzUlmzDYXStwqLQ5FOVC.LDq2FjTb7fvGvECXnS1x62b9Htu','2025-05-04 09:55:48'),(41,'Lucie Dubois','lucie.dubois@example.com','$2y$10$sKNquDDsNjG3XyD2BLo7YOg0dMGj5h47/JHbARrxrKks2mESzkmr2','2025-05-04 09:55:48'),(42,'Valérie Charpentier','valerie.charpentier@example.com','$2y$10$hbaXHPA7riwWpBdG3YEqb3qO68dpBKMEXpcg8MBjcb1w9rRZmZlZO','2025-05-04 09:55:48'),(43,'Jules Lefevre','jules.lefevre@example.com','$2y$10$gt3l5Wi5G9D4iTjL37Z9cmq4ct4Bfl72zFuWbFAIuAO0jDwtfPLmu','2025-05-04 09:55:48');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-06 14:27:51
