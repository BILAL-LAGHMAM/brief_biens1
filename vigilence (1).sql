-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : lun. 22 mars 2021 à 21:06
-- Version du serveur :  5.7.31
-- Version de PHP : 7.3.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `vigilence`
--

-- --------------------------------------------------------

--
-- Structure de la table `bien_immobilier`
--

DROP TABLE IF EXISTS `bien_immobilier`;
CREATE TABLE IF NOT EXISTS `bien_immobilier` (
  `code_bien` int(11) NOT NULL AUTO_INCREMENT,
  `adresse_bien` varchar(21) DEFAULT NULL,
  `num_enregistrement` int(11) DEFAULT NULL,
  `superficie` varchar(21) DEFAULT NULL,
  `type` varchar(21) DEFAULT NULL,
  `code_quartier` int(11) DEFAULT NULL,
  `date_construction` date DEFAULT NULL,
  PRIMARY KEY (`code_bien`),
  KEY `code_quartier` (`code_quartier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `contrat`
--

DROP TABLE IF EXISTS `contrat`;
CREATE TABLE IF NOT EXISTS `contrat` (
  `nummcontrat` int(11) NOT NULL AUTO_INCREMENT,
  `prix_mensuel` double DEFAULT NULL,
  `code_bien` int(11) DEFAULT NULL,
  `code_syndic` int(11) DEFAULT NULL,
  `etat` varchar(21) DEFAULT NULL,
  PRIMARY KEY (`nummcontrat`),
  KEY `code_syndic` (`code_syndic`),
  KEY `code_bien` (`code_bien`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `quartier`
--

DROP TABLE IF EXISTS `quartier`;
CREATE TABLE IF NOT EXISTS `quartier` (
  `code_quartier` int(11) NOT NULL AUTO_INCREMENT,
  `nom_quartier` varchar(21) DEFAULT NULL,
  `population_quartier` varchar(21) DEFAULT NULL,
  `code_ville` int(11) DEFAULT NULL,
  `totel_quartier` double DEFAULT NULL,
  PRIMARY KEY (`code_quartier`),
  KEY `code_ville` (`code_ville`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `region`
--

DROP TABLE IF EXISTS `region`;
CREATE TABLE IF NOT EXISTS `region` (
  `code_region` int(11) NOT NULL AUTO_INCREMENT,
  `nom_region` varchar(21) DEFAULT NULL,
  `population_region` varchar(21) DEFAULT NULL,
  `total_region` double DEFAULT NULL,
  PRIMARY KEY (`code_region`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `syndic`
--

DROP TABLE IF EXISTS `syndic`;
CREATE TABLE IF NOT EXISTS `syndic` (
  `code_syndic` int(11) NOT NULL AUTO_INCREMENT,
  `nom_syndic` varchar(21) DEFAULT NULL,
  `prenom_syndic` varchar(21) DEFAULT NULL,
  `telephone_syndic` varchar(21) DEFAULT NULL,
  `mot_depasse` text,
  PRIMARY KEY (`code_syndic`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `ville`
--

DROP TABLE IF EXISTS `ville`;
CREATE TABLE IF NOT EXISTS `ville` (
  `code_ville` int(11) NOT NULL AUTO_INCREMENT,
  `nom_ville` varchar(21) DEFAULT NULL,
  `code_region` int(11) DEFAULT NULL,
  `total_ville` double DEFAULT NULL,
  PRIMARY KEY (`code_ville`),
  KEY `code_region` (`code_region`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `bien_immobilier`
--
ALTER TABLE `bien_immobilier`
  ADD CONSTRAINT `bien_immobilier_ibfk_1` FOREIGN KEY (`code_quartier`) REFERENCES `quartier` (`code_quartier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `contrat`
--
ALTER TABLE `contrat`
  ADD CONSTRAINT `contrat_ibfk_1` FOREIGN KEY (`code_syndic`) REFERENCES `syndic` (`code_syndic`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `contrat_ibfk_2` FOREIGN KEY (`code_bien`) REFERENCES `bien_immobilier` (`code_bien`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `quartier`
--
ALTER TABLE `quartier`
  ADD CONSTRAINT `quartier_ibfk_1` FOREIGN KEY (`code_ville`) REFERENCES `ville` (`code_ville`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `ville`
--
ALTER TABLE `ville`
  ADD CONSTRAINT `ville_ibfk_1` FOREIGN KEY (`code_region`) REFERENCES `region` (`code_region`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
INSERT INTO `contrat`(`nummcontrat`, `prix_mensuel`, `code_bien`, `code_syndic`, `etat`) VALUES (null,100.2,1,2,'actif');
INSERT INTO `contrat`(`nummcontrat`, `prix_mensuel`, `code_bien`, `code_syndic`, `etat`) VALUES (null,140.2,3,3,'actif');
INSERT INTO `contrat`(`nummcontrat`, `prix_mensuel`, `code_bien`, `code_syndic`, `etat`) VALUES (null,600.2,2,1,'resilie');
-- 2
SELECT b.num_enregitrement,v.nom_ville from bien_immobilier b INNER JOIN quartier q on q.code_quartier = b.code_quartier 
INNER JOIN ville v on v.code_ville = q.code_ville 
group by nom_ville
;
-- 3
SELECT count(*) as nember_contrat , b.code_bien  from bien_immobilier INNER join contrat c on c.code_bien = b.code_bien
group by b.code_bien
having count(*) =  
(SELECT COUNT(*) from contrat c 
group by c.code_bien
order by count(*)
limit 1)
-- 4
SELECT s.nom_syndic from syndic s 
WHERE  s.code_syndic not in  (SELECT  c.code_syndic from contrat INNER join bien_immobilier b on b.code_bien = c.code_bien  INNER join quartier  q on b.code_quartier = q.code_quartier INNER join ville v on v.code_ville = q.code_ville INNER join region r on r.code_region = v.code_region 
WHERE r.nom_region = 'oriental' ) ;
-- 5 -->
-- SELECT b.code_bien  from bien_immobilier b INNER join contrat c on c.code_bien = b.code_bien 
-- group by b.code_bien
-- WHERE prix_mensuel*12 = (SELECT c.prix_mensuel from contrat c INNER join bien_immobilier b on b.code_bien = c.code_bien group by b.code_bien order by prix_mensuel limit 1)*12 
-- 6
SELECT b.code_bien from bien_immobilier b 
WHERE b.date_construction  =  (SELECT MIN(date_construction) from bien_immobilier );
-- 7
