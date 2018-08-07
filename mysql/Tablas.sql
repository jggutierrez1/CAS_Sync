-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         5.5.34-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             9.5.0.5282
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Volcando estructura de base de datos para cas
CREATE DATABASE IF NOT EXISTS `cas` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `cas`;

-- Volcando estructura para tabla cas.boletasf
DROP TABLE IF EXISTS `boletasf`;
CREATE TABLE IF NOT EXISTS `boletasf` (
  `autoin` bigint(20) NOT NULL AUTO_INCREMENT,
  `ncliente` char(5) NOT NULL,
  `tipobol` decimal(2,0) DEFAULT NULL,
  `fechabol` date DEFAULT NULL,
  `comentab1` char(60) DEFAULT NULL,
  `comentab2` char(60) DEFAULT NULL,
  `comentab3` char(60) DEFAULT NULL,
  `montotr` decimal(10,2) DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  `usuario` char(3) DEFAULT NULL,
  `horatran` char(8) DEFAULT NULL,
  `flag_modif` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`autoin`),
  UNIQUE KEY `ncliente` (`ncliente`),
  KEY `tipobol` (`tipobol`),
  KEY `fechabol` (`fechabol`),
  KEY `status` (`status`),
  KEY `usuario` (`usuario`),
  KEY `flag_modif` (`flag_modif`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Volcando datos para la tabla cas.boletasf: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `boletasf` DISABLE KEYS */;
/*!40000 ALTER TABLE `boletasf` ENABLE KEYS */;

-- Volcando estructura para tabla cas.derechos
DROP TABLE IF EXISTS `derechos`;
CREATE TABLE IF NOT EXISTS `derechos` (
  `autoin` bigint(20) NOT NULL AUTO_INCREMENT,
  `socioder` char(5) NOT NULL,
  `sociode2` char(5) DEFAULT NULL,
  `nombreder` char(25) DEFAULT NULL,
  `direccder` char(25) DEFAULT NULL,
  `porcender` decimal(6,2) DEFAULT NULL,
  `parentder` char(10) DEFAULT NULL,
  `flag_modif` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`autoin`),
  UNIQUE KEY `socioder` (`socioder`),
  KEY `sociode2` (`sociode2`),
  KEY `nombreder` (`nombreder`),
  KEY `flag_modif` (`flag_modif`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Volcando datos para la tabla cas.derechos: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `derechos` DISABLE KEYS */;
/*!40000 ALTER TABLE `derechos` ENABLE KEYS */;

-- Volcando estructura para tabla cas.sociofin
DROP TABLE IF EXISTS `sociofin`;
CREATE TABLE IF NOT EXISTS `sociofin` (
  `autoin` bigint(20) NOT NULL AUTO_INCREMENT,
  `socio` char(5) NOT NULL,
  `empleado` char(8) DEFAULT NULL,
  `tactivos1` char(50) DEFAULT NULL,
  `mtavaluo1` decimal(12,2) DEFAULT NULL,
  `tactivos2` char(50) DEFAULT NULL,
  `mtavaluo2` decimal(12,2) DEFAULT NULL,
  `tactivos3` char(50) DEFAULT NULL,
  `mtavaluo3` decimal(12,2) DEFAULT NULL,
  `depoxmes1` decimal(12,2) DEFAULT NULL,
  `numdepoxm` decimal(6,0) DEFAULT NULL,
  `retixmes1` decimal(12,2) DEFAULT NULL,
  `numretixm` decimal(6,0) DEFAULT NULL,
  `pagoxmes1` decimal(12,2) DEFAULT NULL,
  `numpagoxm` decimal(6,0) DEFAULT NULL,
  `transaint` char(1) DEFAULT NULL,
  `transagob` char(1) DEFAULT NULL,
  `nomterce1` char(35) DEFAULT NULL,
  `relterce1` char(15) DEFAULT NULL,
  `telterce1` char(9) DEFAULT NULL,
  `nomterce2` char(35) DEFAULT NULL,
  `relterce2` char(15) DEFAULT NULL,
  `telterce2` char(9) DEFAULT NULL,
  `personpep` char(1) DEFAULT NULL,
  `detalepep` char(45) DEFAULT NULL,
  `familipep` char(1) DEFAULT NULL,
  `detalfpep` char(5) DEFAULT NULL,
  `strtemtom` decimal(12,2) DEFAULT NULL,
  `strtecanm` decimal(6,0) DEFAULT NULL,
  `totseman1` decimal(12,2) DEFAULT NULL,
  `totseman2` decimal(12,2) DEFAULT NULL,
  `totseman3` decimal(12,2) DEFAULT NULL,
  `totseman4` decimal(12,2) DEFAULT NULL,
  `nriesgo` decimal(3,0) DEFAULT NULL,
  `flag_modif` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`autoin`),
  UNIQUE KEY `socio` (`socio`),
  KEY `tactivos1` (`tactivos1`),
  KEY `empleado` (`empleado`),
  KEY `flag_modif` (`flag_modif`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Volcando datos para la tabla cas.sociofin: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `sociofin` DISABLE KEYS */;
/*!40000 ALTER TABLE `sociofin` ENABLE KEYS */;

-- Volcando estructura para tabla cas.socios
DROP TABLE IF EXISTS `socios`;
CREATE TABLE IF NOT EXISTS `socios` (
  `autoin` bigint(20) NOT NULL AUTO_INCREMENT,
  `socio` char(5) DEFAULT NULL,
  `socio2` char(5) DEFAULT NULL,
  `cedula` char(13) DEFAULT NULL,
  `segsocial` char(12) DEFAULT NULL,
  `apellido` char(29) DEFAULT NULL,
  `nombre` char(29) DEFAULT NULL,
  `fecnacim` date DEFAULT NULL,
  `fecingreso` date DEFAULT NULL,
  `fecsalida` date DEFAULT NULL,
  `sexo` char(1) DEFAULT NULL,
  `estado` char(1) DEFAULT NULL,
  `profesion` char(25) DEFAULT NULL,
  `lugtrabajo` char(25) DEFAULT NULL,
  `depto` char(25) DEFAULT NULL,
  `seccion` char(15) DEFAULT NULL,
  `empleado` char(10) DEFAULT NULL,
  `salario` decimal(8,2) DEFAULT NULL,
  `direccionr` char(50) DEFAULT NULL,
  `direcciont` char(50) DEFAULT NULL,
  `apartado` char(20) DEFAULT NULL,
  `telefonor` char(9) DEFAULT NULL,
  `telefonot` char(9) DEFAULT NULL,
  `email` char(60) DEFAULT NULL,
  `conyuge` char(25) DEFAULT NULL,
  `aportacion` decimal(6,2) DEFAULT NULL,
  `feincia` date DEFAULT NULL,
  `fecrein` date DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  `plani` char(1) DEFAULT NULL,
  `acti` char(1) DEFAULT NULL,
  `salcor` decimal(10,2) DEFAULT NULL,
  `empresa` char(3) DEFAULT NULL,
  `escuela` char(3) DEFAULT NULL,
  `tippla` char(1) DEFAULT NULL,
  `fecpla` char(6) DEFAULT NULL,
  `salpla` decimal(10,2) DEFAULT NULL,
  `segvida` char(1) DEFAULT NULL,
  `ahorromes` decimal(8,2) DEFAULT NULL,
  `msgrare` char(50) DEFAULT NULL,
  `hijos` decimal(2,0) DEFAULT NULL,
  `chkach` char(1) DEFAULT NULL,
  `netsocio` decimal(9,0) DEFAULT NULL,
  `tarjeachg` char(13) DEFAULT NULL,
  `tarjeach` char(10) DEFAULT NULL,
  `iapc` char(1) DEFAULT NULL,
  `hijo1` char(25) DEFAULT NULL,
  `fecnach1` date DEFAULT NULL,
  `hijo2` char(25) DEFAULT NULL,
  `fecnach2` date DEFAULT NULL,
  `hijo3` char(25) DEFAULT NULL,
  `fecnach3` date DEFAULT NULL,
  `hijo4` char(25) DEFAULT NULL,
  `fecnach4` date DEFAULT NULL,
  `hijo5` char(25) DEFAULT NULL,
  `fecnach5` date DEFAULT NULL,
  `hijo6` char(25) DEFAULT NULL,
  `fecnach6` date DEFAULT NULL,
  `hijo7` char(25) DEFAULT NULL,
  `fecnach7` date DEFAULT NULL,
  `hijo8` char(25) DEFAULT NULL,
  `fecnach8` date DEFAULT NULL,
  `dv` char(2) DEFAULT NULL,
  `totmontos` decimal(10,2) DEFAULT NULL,
  `cantimtos` decimal(7,0) DEFAULT NULL,
  `sangre` char(10) DEFAULT NULL,
  `flag_modif` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`autoin`),
  UNIQUE KEY `socio` (`socio`),
  KEY `socio2` (`socio2`),
  KEY `cedula` (`cedula`),
  KEY `segsocial` (`segsocial`),
  KEY `apellido` (`apellido`),
  KEY `nombre` (`nombre`),
  KEY `estado` (`estado`),
  KEY `depto` (`depto`),
  KEY `flag_modif` (`flag_modif`),
  KEY `status` (`status`),
  KEY `fecnacim` (`fecnacim`),
  KEY `fecingreso` (`fecingreso`),
  KEY `fecsalida` (`fecsalida`),
  KEY `sexo` (`sexo`)
) ENGINE=InnoDB AUTO_INCREMENT=322 DEFAULT CHARSET=utf8;

-- Volcando datos para la tabla cas.socios: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `socios` DISABLE KEYS */;
INSERT INTO `socios` (`autoin`, `socio`, `socio2`, `cedula`, `segsocial`, `apellido`, `nombre`, `fecnacim`, `fecingreso`, `fecsalida`, `sexo`, `estado`, `profesion`, `lugtrabajo`, `depto`, `seccion`, `empleado`, `salario`, `direccionr`, `direcciont`, `apartado`, `telefonor`, `telefonot`, `email`, `conyuge`, `aportacion`, `feincia`, `fecrein`, `status`, `plani`, `acti`, `salcor`, `empresa`, `escuela`, `tippla`, `fecpla`, `salpla`, `segvida`, `ahorromes`, `msgrare`, `hijos`, `chkach`, `netsocio`, `tarjeachg`, `tarjeach`, `iapc`, `hijo1`, `fecnach1`, `hijo2`, `fecnach2`, `hijo3`, `fecnach3`, `hijo4`, `fecnach4`, `hijo5`, `fecnach5`, `hijo6`, `fecnach6`, `hijo7`, `fecnach7`, `hijo8`, `fecnach8`, `dv`, `totmontos`, `cantimtos`, `sangre`, `flag_modif`) VALUES
	(1, '99998', '99998', '02  011300967', '2311239', 'RODRIGUEZ TORRES', 'PLACIDO', '1961-10-04', '1993-09-20', '1900-01-01', 'M', 'S', 'NO TIENE', NULL, 'PRODUCCION ARTESANAL', 'PIZZAS', '237', 1500.69, ' LA ALAMBRA PRINCIPAL  0', 'TRANSISTMICA', '0', '6411-7831', '225-6247', 'placidor@hotmail.com', 'NO TIENE', 0.00, '1969-12-31', '1900-01-01', '1', 'Q', 'S', 100.00, '1', NULL, NULL, NULL, NULL, 'N', 0.00, 'AH.CTE.300.00 M.COMPLETA LETRA P.CTE  GC.', 1, 'S', 22447609, '0472990561937', NULL, NULL, 'GALEN RODRIGUEZ', '1969-12-31', NULL, '1969-12-31', NULL, '1969-12-31', NULL, '1969-12-31', NULL, '1969-12-31', NULL, '2018-08-06', NULL, '1900-01-01', NULL, '1900-01-01', '91', 0.00, 0, 'O+', 0),
	(2, '00237', '00237', '02  011300967', '2311239', 'RODRIGUEZ TORRES', 'PLACIDO', '1961-10-04', '1993-09-20', '1900-01-01', 'M', 'S', 'NO TIENE', NULL, 'PRODUCCION ARTESANAL', 'PIZZAS', '237', 1500.69, ' LA ALAMBRA PRINCIPAL  0', 'TRANSISTMICA', '0', '6411-7831', '225-6247', 'placidor@hotmail.com', 'NO TIENE', 0.00, '1969-12-31', '1900-01-01', '1', 'Q', 'S', 100.00, '1', NULL, NULL, NULL, NULL, 'N', 0.00, 'AH.CTE.300.00 M.COMPLETA LETRA P.CTE  GC.', 1, 'S', 22447609, '0472990561937', NULL, NULL, 'GALEN RODRIGUEZ', '1969-12-31', NULL, '1969-12-31', NULL, '1969-12-31', NULL, '1969-12-31', NULL, '1969-12-31', NULL, '1969-12-31', NULL, '1900-01-01', NULL, '1900-01-01', '91', 0.00, 0, 'O+', 0),
	(318, '00579', '00579', '08  072502109', NULL, 'MERCADO REYES', 'LIANA IBET', '2018-08-06', '2018-08-06', '1900-01-01', 'F', 'S', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, '1900-01-01', '1900-01-01', '1', 'Q', 'N', 0.00, '1', NULL, NULL, NULL, NULL, 'N', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1900-01-01', NULL, '1900-01-01', NULL, '1900-01-01', NULL, '1900-01-01', NULL, '1900-01-01', NULL, '1900-01-01', NULL, '1900-01-01', NULL, '1900-01-01', NULL, 0.00, 0, NULL, 0);
/*!40000 ALTER TABLE `socios` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
