-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 06, 2023 at 07:47 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `player_injury_database`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddInjury` (IN `p_PlayerID` VARCHAR(10), IN `p_FacilityID` VARCHAR(10), IN `p_StaffID` VARCHAR(10), IN `p_InjuryType` VARCHAR(50), IN `p_InjuryStartDate` DATE, IN `p_ExpectedReturnDate` DATE)   BEGIN
    DECLARE playerExists INT;
    DECLARE facilityExists INT;
    DECLARE staffExists INT;

    SELECT COUNT(*) INTO playerExists FROM PlayerList WHERE PlayerID = p_PlayerID;
    SELECT COUNT(*) INTO facilityExists FROM TeamFacility WHERE FacilityID = p_FacilityID;
    SELECT COUNT(*) INTO staffExists FROM HealthDirector WHERE StaffID = p_StaffID;

    IF playerExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'PlayerID does not exist in PlayerList table';
    END IF;

    IF facilityExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FacilityID does not exist in TeamFacility table';
    END IF;

    IF staffExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'StaffID does not exist in HealthDirector table';
    END IF;

    INSERT INTO InjuryList (PlayerID, FacilityID, StaffID, InjuryType, InjuryStartDate, ExpectedReturnDate)
    VALUES (p_PlayerID, p_FacilityID, p_StaffID, p_InjuryType, p_InjuryStartDate, p_ExpectedReturnDate);

    SELECT 'Injury added successfully' AS Result;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InputInjury` (IN `p_InjuryID` VARCHAR(10), IN `p_PlayerID` VARCHAR(10), IN `p_FacilityID` VARCHAR(10), IN `p_StaffID` VARCHAR(10), IN `p_InjuryType` VARCHAR(50), IN `p_InjuryStartDate` DATE, IN `p_ExpectedReturnDate` DATE)   BEGIN
    -- Check if the PlayerID, FacilityID, and StaffID exist
    DECLARE playerExists INT;
    DECLARE facilityExists INT;
    DECLARE staffExists INT;

    SELECT COUNT(*) INTO playerExists FROM PlayerList WHERE PlayerID = p_PlayerID;
    SELECT COUNT(*) INTO facilityExists FROM TeamFacility WHERE FacilityID = p_FacilityID;
    SELECT COUNT(*) INTO staffExists FROM HealthDirector WHERE StaffID = p_StaffID;

    IF playerExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'PlayerID does not exist in PlayerList table';
    END IF;

    IF facilityExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FacilityID does not exist in TeamFacility table';
    END IF;

    IF staffExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'StaffID does not exist in HealthDirector table';
    END IF;

    -- Insert the injury record
    INSERT INTO InjuryList (InjuryID, PlayerID, FacilityID, StaffID, InjuryType, InjuryStartDate, ExpectedReturnDate)
    VALUES (p_InjuryID, p_PlayerID, p_FacilityID, p_StaffID, p_InjuryType, p_InjuryStartDate, p_ExpectedReturnDate);

    -- Update player status to 'Injured' in PlayerMetrics table
    UPDATE PlayerMetrics SET Status = 'Injured' WHERE PlayerID = p_PlayerID;

    SELECT 'Injury added successfully' AS Result;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `CalculateAge` (`p_PlayerID` VARCHAR(10)) RETURNS INT(11)  BEGIN
    DECLARE playerDOB DATE;
    DECLARE playerAge INT;

    SELECT PlayerDOB INTO playerDOB
    FROM PlayerList
    WHERE PlayerID = p_PlayerID;

    SET playerAge = YEAR(CURDATE()) - YEAR(playerDOB) - (RIGHT(CURDATE(), 5) < RIGHT(playerDOB, 5));

    RETURN playerAge;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `CalculatePlayerAge` (`PlayerID` VARCHAR(10)) RETURNS INT(11)  BEGIN
    DECLARE playerDOB DATE;
    DECLARE playerAge INT;

    SELECT PlayerDOB INTO playerDOB
    FROM PlayerList
    WHERE PlayerID = CalculatePlayerAge.PlayerID;

    SET playerAge = YEAR(CURDATE()) - YEAR(playerDOB) - (RIGHT(CURDATE(), 5) < RIGHT(playerDOB, 5));

    RETURN playerAge;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `CalculaterAge` (`p_PlayerID` VARCHAR(10)) RETURNS INT(11)  BEGIN
    DECLARE playerDOB DATE;
    DECLARE playerAge INT;

    SELECT PlayerDOB INTO playerDOB
    FROM PlayerList
    WHERE PlayerID = p_PlayerID;

    SET playerAge = YEAR(CURDATE()) - YEAR(playerDOB) - (RIGHT(CURDATE(), 5) < RIGHT(playerDOB, 5));

    RETURN playerAge;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `CountAge` (`p_PlayerID` VARCHAR(10)) RETURNS INT(11)  BEGIN
    DECLARE playerDOB DATE;
    DECLARE playerAge INT;

    SELECT PlayerDOB INTO playerDOB
    FROM PlayerList
    WHERE PlayerID = p_PlayerID;

    SET playerAge = YEAR(CURDATE()) - YEAR(playerDOB) - (RIGHT(CURDATE(), 5) < RIGHT(playerDOB, 5));

    RETURN playerAge;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `CountPlayerAge` (`p_PlayerID` VARCHAR(10)) RETURNS INT(11)  BEGIN
    DECLARE playerDOB DATE;
    DECLARE playerAge INT;

    SELECT PlayerDOB INTO playerDOB
    FROM PlayerList
    WHERE PlayerID = p_PlayerID;

    IF playerDOB IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'PlayerID does not exist in PlayerList table';
    END IF;

    SET playerAge = YEAR(CURDATE()) - YEAR(playerDOB) - (RIGHT(CURDATE(), 5) < RIGHT(playerDOB, 5));

    RETURN playerAge;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `GetInjuryCount` (`PlayerID` VARCHAR(10)) RETURNS INT(11)  BEGIN
    DECLARE injuryCount INT;

    SELECT COUNT(*) INTO injuryCount
    FROM InjuryList
    WHERE PlayerID = GetInjuryCount.PlayerID;

    RETURN injuryCount;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `GetTotalPlayerCount` () RETURNS INT(11)  BEGIN
    DECLARE totalPlayers INT;

    SELECT COUNT(*) INTO totalPlayers
    FROM PlayerList;

    RETURN totalPlayers;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `currently_injured`
-- (See below for the actual view)
--
CREATE TABLE `currently_injured` (
`Injury ID` varchar(10)
,`Player Name` varchar(50)
,`Recovery Centre` varchar(50)
,`Health Director` varchar(50)
,`Injury Type` varchar(50)
,`Days Left` int(7)
);

-- --------------------------------------------------------

--
-- Table structure for table `healthdirector`
--

CREATE TABLE `healthdirector` (
  `TeamID` varchar(10) DEFAULT NULL,
  `StaffID` varchar(10) NOT NULL,
  `StaffName` varchar(50) DEFAULT NULL,
  `StaffEmail` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `healthdirector`
--

INSERT INTO `healthdirector` (`TeamID`, `StaffID`, `StaffName`, `StaffEmail`) VALUES
('TM01', 'HD001', 'John Doe', 'john.doe@gmail.com'),
('TM02', 'HD002', 'Jane Smith', 'jane.smith@gmail.com'),
('TM03', 'HD003', 'Robert Johnson', 'robert.johnson@gmail.com'),
('TM04', 'HD004', 'Emily Davis', 'emily.davis@gmail.com'),
('TM05', 'HD005', 'Mike Hawk', 'michael.wilson@gmail.com'),
('TM06', 'HD006', 'Samantha White', 'samantha.white@gmail.com'),
('TM07', 'HD007', 'Christopher Taylor', 'christopher.taylor@gmail.com'),
('TM08', 'HD008', 'Olivia Brown', 'olivia.brown@gmail.com'),
('TM09', 'HD009', 'Matthew Miller', 'matthew.miller@gmail.com'),
('TM010', 'HD010', 'Emma Frost', 'emma.moore@gmail.com'),
('TM011', 'HD011', 'David Johnson', 'david.johnson@gmail.com'),
('TM012', 'HD012', 'Isabella Martinez', 'isabella.martinez@gmail.com'),
('TM013', 'HD013', 'James Anderson', 'james.anderson@gmail.com'),
('TM014', 'HD014', 'Sophia Taylor', 'sophia.taylor@gmail.com'),
('TM015', 'HD015', 'Daniel Davis', 'daniel.davis@gmail.com'),
('TM016', 'HD016', 'Ava Wilson', 'ava.wilson@gmail.com'),
('TM017', 'HD017', 'Logan Brown', 'logan.brown@gmail.com'),
('TM018', 'HD018', 'Mia Moore', 'mia.moore@gmail.com'),
('TM019', 'HD019', 'Elijah White', 'elijah.white@gmail.com'),
('TM020', 'HD020', 'Avery Smith', 'avery.smith@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `injurylist`
--

CREATE TABLE `injurylist` (
  `InjuryID` varchar(10) NOT NULL,
  `PlayerID` varchar(10) DEFAULT NULL,
  `FacilityID` varchar(10) DEFAULT NULL,
  `StaffID` varchar(10) DEFAULT NULL,
  `InjuryType` varchar(50) DEFAULT NULL,
  `InjuryStartDate` date DEFAULT NULL,
  `ExpectedReturnDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `injurylist`
--

INSERT INTO `injurylist` (`InjuryID`, `PlayerID`, `FacilityID`, `StaffID`, `InjuryType`, `InjuryStartDate`, `ExpectedReturnDate`) VALUES
('IN001', 'P001', 'FC002', 'HD012', 'Hamstring', '2022-07-31', '2022-09-30'),
('IN002', 'P004', 'FC004', 'HD003', 'ACL', '2023-05-12', '2023-12-28'),
('IN003', 'P007', 'FC003', 'HD002', 'Ankle Sprain', '2023-12-09', '2024-01-17'),
('IN004', 'P010', 'FC009', 'HD017', 'MCL Sprain', '2023-07-31', '2023-11-03'),
('IN005', 'P014', 'FC017', 'HD015', 'ACL', '2023-09-13', '2024-04-22'),
('IN006', 'P016', 'FC002', 'HD012', 'Ankle Sprain', '2023-12-01', '2023-12-15');

-- --------------------------------------------------------

--
-- Table structure for table `playerlist`
--

CREATE TABLE `playerlist` (
  `PlayerID` varchar(10) NOT NULL,
  `PlayerName` varchar(50) DEFAULT NULL,
  `PlayerNationality` varchar(50) DEFAULT NULL,
  `PlayerPosition` varchar(20) DEFAULT NULL,
  `PlayerDOB` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `playerlist`
--

INSERT INTO `playerlist` (`PlayerID`, `PlayerName`, `PlayerNationality`, `PlayerPosition`, `PlayerDOB`) VALUES
('P001', 'Harry Kane', 'English', 'Forward', '1993-07-28'),
('P002', 'Mohamed Salah', 'Egyptian', 'Forward', '1992-06-15'),
('P003', 'Bruno Fernandes', 'Portuguese', 'Midfielder', '1994-09-08'),
('P004', 'Kevin De Bruyne', 'Belgian', 'Midfielder', '1991-06-28'),
('P005', 'Jack Grealish', 'English', 'Midfielder', '1995-09-10'),
('P006', 'Sadio Mane', 'Senegalese', 'Forward', '1992-04-10'),
('P007', 'Marcus Rashford', 'English', 'Forward', '1997-10-31'),
('P008', 'Raheem Sterling', 'English', 'Forward', '1994-12-08'),
('P009', 'Trent Alexander-Arnold', 'English', 'Defender', '1998-10-07'),
('P010', 'Phil Foden', 'English', 'Midfielder', '2000-05-28'),
('P011', 'Robert Lewandowski', 'Polish', 'Forward', '1988-08-21'),
('P012', 'Lionel Messi', 'Argentinian', 'Forward', '1987-06-24'),
('P013', 'Cristiano Ronaldo', 'Portuguese', 'Forward', '1985-02-05'),
('P014', 'Neymar Jr.', 'Brazilian', 'Forward', '1992-02-05'),
('P015', 'Kylian Mbappé', 'French', 'Forward', '1998-12-20'),
('P016', 'Luka Modric', 'Croatian', 'Midfielder', '1985-09-09'),
('P017', 'Virgil van Dijk', 'Dutch', 'Defender', '1991-07-08'),
('P018', 'Alphonso Davies', 'Canadian', 'Defender', '2000-11-02'),
('P019', 'Jadon Sancho', 'English', 'Forward', '2000-03-25'),
('P020', 'Erling Haaland', 'Norwegian', 'Forward', '2000-07-21'),
('P021', 'Sergio Ramos', 'Spanish', 'Defender', '1986-03-30'),
('P022', 'Eden Hazard', 'Belgian', 'Forward', '1991-01-07'),
('P023', 'Paul Pogba', 'French', 'Midfielder', '1993-03-15'),
('P024', 'Antoine Griezmann', 'French', 'Forward', '1991-03-21'),
('P025', 'Joshua Kimmich', 'German', 'Midfielder', '1995-02-08'),
('P026', 'Andrew Robertson', 'Scottish', 'Defender', '1994-03-11'),
('P027', 'Thiago Alcantara', 'Spanish', 'Midfielder', '1991-04-11'),
('P028', 'Heung-Min Son', 'South Korean', 'Forward', '1992-07-08'),
('P029', 'Christian Pulisic', 'American', 'Forward', '1998-09-18'),
('P030', 'Gianluigi Donnarumma', 'Italian', 'Goalkeeper', '1999-02-25'),
('P031', 'David De Gea', 'Spanish', 'Goalkeeper', '1990-11-07'),
('P032', 'Harry Maguire', 'English', 'Defender', '1993-03-05'),
('P033', 'Jamie Vardy', 'English', 'Forward', '1987-01-11'),
('P034', 'Hakim Ziyech', 'Moroccan', 'Midfielder', '1993-03-19'),
('P035', 'Jordan Henderson', 'English', 'Midfielder', '1990-06-17'),
('P036', 'Timo Werner', 'German', 'Forward', '1996-03-06'),
('P037', 'Romelu Lukaku', 'Belgian', 'Forward', '1993-05-13'),
('P038', 'N Golo Kanté', 'French', 'Midfielder', '1991-03-29'),
('P039', 'Fabinho', 'Brazilian', 'Midfielder', '1993-10-23'),
('P040', 'Ruben Dias', 'Portuguese', 'Defender', '1997-05-14'),
('P041', 'Kalvin Phillips', 'English', 'Midfielder', '1995-12-02'),
('P042', 'Mason Mount', 'English', 'Midfielder', '1999-01-10'),
('P043', 'Declan Rice', 'English', 'Midfielder', '1999-01-14'),
('P044', 'João Cancelo', 'Portuguese', 'Defender', '1994-05-27'),
('P045', 'Philipp Lahm', 'German', 'Defender', '1983-11-11'),
('P046', 'Zlatan Ibrahimović', 'Swedish', 'Forward', '1981-10-03'),
('P047', 'Luis Suárez', 'Uruguayan', 'Forward', '1987-01-24'),
('P048', 'Frenkie de Jong', 'Dutch', 'Midfielder', '1997-05-12'),
('P049', 'Ciro Immobile', 'Italian', 'Forward', '1990-02-20'),
('P050', 'Gareth Bale', 'Welsh', 'Forward', '1989-07-16'),
('P051', 'Sergio Aguero', 'Argentinian', 'Forward', '1988-06-02'),
('P052', 'Gianluigi Buffon', 'Italian', 'Goalkeeper', '1978-01-28'),
('P053', 'Sergio Busquets', 'Spanish', 'Midfielder', '1988-07-16'),
('P054', 'Aymeric Laporte', 'French', 'Defender', '1994-05-27'),
('P055', 'Thomas Müller', 'German', 'Forward', '1989-09-13'),
('P056', 'Karim Benzema', 'French', 'Forward', '1987-12-19'),
('P057', 'Thibaut Courtois', 'Belgian', 'Goalkeeper', '1992-05-11'),
('P058', 'Vinicius Jr.', 'Brazilian', 'Forward', '2000-07-12'),
('P059', 'Paulo Dybala', 'Argentinian', 'Forward', '1993-11-15'),
('P060', 'Raphael Varane', 'French', 'Defender', '1993-04-25');

-- --------------------------------------------------------

--
-- Table structure for table `playermetrics`
--

CREATE TABLE `playermetrics` (
  `PlayerID` varchar(10) DEFAULT NULL,
  `Height` float DEFAULT NULL,
  `Weight` float DEFAULT NULL,
  `HeartRate` int(11) DEFAULT NULL,
  `BMI` float DEFAULT NULL,
  `StrongFoot` varchar(10) DEFAULT NULL,
  `Status` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `playermetrics`
--

INSERT INTO `playermetrics` (`PlayerID`, `Height`, `Weight`, `HeartRate`, `BMI`, `StrongFoot`, `Status`) VALUES
('P001', 182, 83, 82, 23.98, 'Right', 'Injured'),
('P002', 176.5, 75, 78, 22.15, 'Left', 'Healthy'),
('P003', 185, 82.5, 85, 24.01, 'Right', 'Healthy'),
('P004', 170, 68, 75, 23.48, 'Left', 'Injured'),
('P005', 178, 80, 80, 23.94, 'Right', 'Healthy'),
('P006', 183.5, 85.5, 88, 25.3, 'Left', 'Healthy'),
('P007', 177, 76.5, 79, 22.89, 'Right', 'Injured'),
('P008', 181, 78, 84, 23.12, 'Left', 'Healthy'),
('P009', 175.5, 74.5, 77, 22.45, 'Right', 'Healthy'),
('P010', 184, 87, 87, 25.72, 'Left', 'Injured'),
('P011', 179, 79.5, 81, 23.76, 'Right', 'Healthy'),
('P012', 172, 71, 76, 22.62, 'Left', 'Healthy'),
('P013', 186.5, 88.5, 86, 26.14, 'Right', 'Healthy'),
('P014', 174, 73.5, 78, 22.3, 'Left', 'Injured'),
('P015', 180, 77, 82, 23.34, 'Right', 'Healthy'),
('P016', 175, 74, 79, 22.5, 'Left', 'Injured'),
('P017', 182.5, 83.5, 88, 24.89, 'Right', 'Injured'),
('P018', 178.5, 81, 85, 23.76, 'Left', 'Injured'),
('P019', 183, 86, 87, 25.12, 'Right', 'Healthy'),
('P020', 177.5, 77.5, 80, 23.01, 'Left', 'Injured'),
('P021', 180.5, 79, 83, 23.45, 'Right', 'Healthy'),
('P022', 176, 76.5, 79, 22.4, 'Left', 'Injured'),
('P023', 181.5, 82, 84, 23.61, 'Right', 'Healthy'),
('P024', 177.5, 79.5, 81, 23.18, 'Left', 'Healthy'),
('P025', 182, 84, 86, 24.01, 'Right', 'Injured'),
('P026', 178.5, 80.5, 83, 23.45, 'Left', 'Healthy'),
('P027', 183.5, 86.5, 88, 25, 'Right', 'Healthy'),
('P028', 175.5, 75, 78, 22.15, 'Left', 'Healthy'),
('P029', 180, 81.5, 85, 23.94, 'Right', 'Healthy'),
('P030', 176.5, 77, 80, 22.62, 'Left', 'Healthy'),
('P031', 181, 83.5, 87, 24.32, 'Right', 'Injured'),
('P032', 177, 79, 82, 23.34, 'Left', 'Healthy'),
('P033', 182.5, 85, 89, 24.76, 'Right', 'Healthy'),
('P034', 178, 80, 83, 23.76, 'Left', 'Healthy'),
('P035', 183, 86.5, 87, 25.3, 'Right', 'Healthy'),
('P036', 179.5, 82, 84, 23.61, 'Left', 'Injured'),
('P037', 184, 88, 88, 25.89, 'Right', 'Healthy'),
('P038', 180.5, 84.5, 86, 24.45, 'Left', 'Injured'),
('P039', 185.5, 89, 89, 26.01, 'Right', 'Healthy'),
('P040', 181, 85.5, 87, 25.12, 'Left', 'Healthy'),
('P041', 186, 90, 90, 26.45, 'Right', 'Injured'),
('P042', 175, 75, 78, 22.5, 'Left', 'Healthy'),
('P043', 180.5, 82, 83, 23.76, 'Right', 'Healthy'),
('P044', 176, 78.5, 81, 23.05, 'Left', 'Healthy'),
('P045', 181, 84, 86, 24.31, 'Right', 'Healthy'),
('P046', 177.5, 80, 82, 23.18, 'Left', 'Injured'),
('P047', 182.5, 86.5, 88, 25, 'Right', 'Healthy'),
('P048', 178, 81, 83, 23.61, 'Left', 'Healthy'),
('P049', 183, 87.5, 87, 25.31, 'Right', 'Healthy'),
('P050', 179.5, 83, 85, 24.01, 'Left', 'Injured'),
('P051', 184, 89, 89, 26.01, 'Right', 'Healthy'),
('P052', 180, 85.5, 86, 24.55, 'Left', 'Healthy'),
('P053', 185.5, 90.5, 90, 26.4, 'Right', 'Healthy'),
('P054', 176.5, 76, 79, 22.15, 'Left', 'Healthy'),
('P055', 181, 81.5, 84, 23.94, 'Right', 'Injured'),
('P056', 177, 79.5, 80, 23.34, 'Left', 'Healthy'),
('P057', 182.5, 85, 87, 24.76, 'Right', 'Healthy'),
('P058', 178.5, 82, 85, 24.31, 'Left', 'Healthy'),
('P059', 183, 88.5, 88, 25.89, 'Right', 'Healthy'),
('P060', 179, 84, 86, 24.45, 'Left', 'Injured');

-- --------------------------------------------------------

--
-- Stand-in structure for view `tall_forwards`
-- (See below for the actual view)
--
CREATE TABLE `tall_forwards` (
`Player Name` varchar(50)
,`Player Position` varchar(20)
,`Player Height (cm)` float
,`Player Weight (kg)` float
,`Player Status` varchar(10)
);

-- --------------------------------------------------------

--
-- Table structure for table `teamfacility`
--

CREATE TABLE `teamfacility` (
  `FacilityID` varchar(10) NOT NULL,
  `TeamID` varchar(10) DEFAULT NULL,
  `StaffID` varchar(10) DEFAULT NULL,
  `RecoveryCentre` varchar(50) DEFAULT NULL,
  `Gym` varchar(50) DEFAULT NULL,
  `TrainingGround` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teamfacility`
--

INSERT INTO `teamfacility` (`FacilityID`, `TeamID`, `StaffID`, `RecoveryCentre`, `Gym`, `TrainingGround`) VALUES
('FC001', 'TM020', 'HD018', 'Hercules Recovery Centre', 'Hercules Fitness Centre', 'Hercules Training Ground'),
('FC002', 'TM016', 'HD012', 'Goliath Recovery Centre', 'Goliath Fitness Centre', 'Goliath Training Ground'),
('FC003', 'TM018', 'HD002', 'Colossus Recovery Centre', 'Colossus Fitness Centre', 'Colossus Training Ground'),
('FC004', 'TM013', 'HD003', 'Titan Recovery Centre', 'Titan Fitness Centre', 'Titan Training Ground'),
('FC005', 'TM019', 'HD013', 'Superstar Recovery Centre', 'Superstar Fitness Centre', 'Superstar Training Ground'),
('FC006', 'TM010', 'HD011', 'Virtuoso Recovery Centre', 'Virtuoso Fitness Centre', 'Virtuoso Training Ground'),
('FC007', 'TM015', 'HD019', 'Leviathan Recovery Centre', 'Leviathan Fitness Centre', 'Leviathan Training Ground'),
('FC008', 'TM04', 'HD001', 'Phenom Recovery Centre', 'Phenom Fitness Centre', 'Phenom Training Ground'),
('FC009', 'TM08', 'HD017', 'Juggernaut Recovery Centre', 'Juggernaut Fitness Centre', 'Juggernaut Training Ground'),
('FC010', 'TM02', 'HD016', 'Maestro Recovery Centre', 'Maestro Fitness Centre', 'Maestro Training Ground'),
('FC011', 'TM03', 'HD004', 'Icon Recovery Centre', 'Icon Fitness Centre', 'Icon Training Ground'),
('FC012', 'TM07', 'HD009', 'Elite Recovery Centre', 'Elite Fitness Centre', 'Elite Training Ground'),
('FC013', 'TM09', 'HD014', 'Behemoth Recovery Centre', 'Behemoth Fitness Centre', 'Behemoth Training Ground'),
('FC014', 'TM01', 'HD010', 'Prodigy Recovery Centre', 'Prodigy Fitness Centre', 'Prodigy Training Ground'),
('FC015', 'TM014', 'HD006', 'Premier Recovery Centre', 'Premier Fitness Centre', 'Premier Training Ground'),
('FC016', 'TM06', 'HD005', 'Ace Recovery Centre', 'Ace Fitness Centre', 'Ace Training Ground'),
('FC017', 'TM012', 'HD015', 'Legend Recovery Centre', 'Legend Fitness Centre', 'Legend Training Ground'),
('FC018', 'TM017', 'HD008', 'Champion Recovery Centre', 'Champion Fitness Centre', 'Champion Training Ground'),
('FC019', 'TM011', 'HD009', 'Thor Recovery Centre', 'Thor Fitness Centre', 'Thor Training Ground'),
('FC020', 'TM05', 'HD007', 'Atlas Recovery Centre', 'Atlas Fitness Centre', 'Atlas Training Ground');

-- --------------------------------------------------------

--
-- Table structure for table `teamlist`
--

CREATE TABLE `teamlist` (
  `TeamID` varchar(10) NOT NULL,
  `TeamName` varchar(50) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `HomeStadium` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teamlist`
--

INSERT INTO `teamlist` (`TeamID`, `TeamName`, `City`, `HomeStadium`) VALUES
('TM01', 'Manchester City', 'Manchester', 'Etihad'),
('TM010', 'West Ham United FC', 'London', 'London'),
('TM011', 'Everton FC', 'Liverpool', 'Goodison Park'),
('TM012', 'Nottingham Forest', 'West Bridgford', 'City Ground'),
('TM013', 'Wolverhampton Wanderers FC', 'Wolverhampton', 'Molineux'),
('TM014', 'Luton Town FC', 'Luton', 'Kenilworth Road'),
('TM015', 'Fulham FC', 'London', 'Craven Cottage'),
('TM016', 'Crystal Palace FC', 'London', 'Selhurst Park'),
('TM017', 'Brentford FC', 'Brentford', 'Gtech Community'),
('TM018', 'Burnley FC', 'Burnley', 'Turf Moor'),
('TM019', 'Sheffield United FC', 'Sheffield', 'Bramall Lane'),
('TM02', 'Manchester United', 'Manchester', 'Old Trafford'),
('TM020', 'AFC Bournemouth', 'Bournemouth', 'Vitality'),
('TM03', 'Liverpool FC', 'Liverpool', 'Anfield'),
('TM04', 'Tottenham Hotspur', 'London', 'Tottenham Hotspur'),
('TM05', 'Arsenal FC', 'London', 'Emirates'),
('TM06', 'Chelsea FC', 'London', 'Stamford Bridge'),
('TM07', 'Newcastle United', 'St. James Park', 'Newcastle'),
('TM08', 'Aston Villa FC', 'Birmingham', 'Villa Park'),
('TM09', 'Brighton Hove Albion FC', 'Brighton Hove', 'American Express');

-- --------------------------------------------------------

--
-- Table structure for table `teamroster`
--

CREATE TABLE `teamroster` (
  `TeamID` varchar(10) DEFAULT NULL,
  `PlayerID` varchar(10) DEFAULT NULL,
  `JerseyNumber` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teamroster`
--

INSERT INTO `teamroster` (`TeamID`, `PlayerID`, `JerseyNumber`) VALUES
('TM01', 'P009', 7),
('TM01', 'P020', 5),
('TM01', 'P012', 4),
('TM02', 'P031', 10),
('TM02', 'P008', 11),
('TM02', 'P041', 9),
('TM03', 'P011', 1),
('TM03', 'P042', 2),
('TM03', 'P019', 3),
('TM04', 'P043', 21),
('TM04', 'P032', 22),
('TM04', 'P054', 30),
('TM05', 'P027', 19),
('TM05', 'P055', 7),
('TM05', 'P044', 9),
('TM06', 'P026', 11),
('TM06', 'P053', 10),
('TM06', 'P060', 15),
('TM07', 'P033', 10),
('TM07', 'P045', 13),
('TM07', 'P052', 11),
('TM08', 'P028', 20),
('TM08', 'P010', 22),
('TM08', 'P021', 29),
('TM09', 'P034', 50),
('TM09', 'P013', 12),
('TM09', 'P029', 13),
('TM010', 'P022', 16),
('TM010', 'P035', 17),
('TM010', 'P030', 32),
('TM011', 'P046', 33),
('TM011', 'P003', 13),
('TM011', 'P056', 25),
('TM012', 'P036', 23),
('TM012', 'P002', 17),
('TM012', 'P014', 10),
('TM013', 'P057', 9),
('TM013', 'P047', 13),
('TM013', 'P004', 8),
('TM014', 'P037', 9),
('TM014', 'P025', 10),
('TM014', 'P048', 16),
('TM015', 'P015', 4),
('TM015', 'P023', 10),
('TM015', 'P038', 3),
('TM016', 'P001', 17),
('TM016', 'P016', 20),
('TM016', 'P049', 32),
('TM017', 'P058', 33),
('TM017', 'P039', 10),
('TM017', 'P017', 9),
('TM018', 'P050', 23),
('TM018', 'P007', 34),
('TM018', 'P059', 25),
('TM019', 'P040', 33),
('TM019', 'P005', 10),
('TM019', 'P024', 7),
('TM020', 'P018', 10),
('TM020', 'P006', 5),
('TM020', 'P051', 19);

-- --------------------------------------------------------

--
-- Structure for view `currently_injured`
--
DROP TABLE IF EXISTS `currently_injured`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `currently_injured`  AS SELECT `i`.`InjuryID` AS `Injury ID`, `pl`.`PlayerName` AS `Player Name`, `tf`.`RecoveryCentre` AS `Recovery Centre`, `hd`.`StaffName` AS `Health Director`, `i`.`InjuryType` AS `Injury Type`, to_days(`i`.`ExpectedReturnDate`) - to_days(curdate()) AS `Days Left` FROM ((((`injurylist` `i` join `playerlist` `pl` on(`i`.`PlayerID` = `pl`.`PlayerID`)) join `teamfacility` `tf` on(`i`.`FacilityID` = `tf`.`FacilityID`)) join `healthdirector` `hd` on(`i`.`StaffID` = `hd`.`StaffID`)) join `playermetrics` `pm` on(`i`.`PlayerID` = `pm`.`PlayerID`)) WHERE `pm`.`Status` = 'Injured' AND `i`.`ExpectedReturnDate` >= curdate() ;

-- --------------------------------------------------------

--
-- Structure for view `tall_forwards`
--
DROP TABLE IF EXISTS `tall_forwards`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tall_forwards`  AS SELECT `pl`.`PlayerName` AS `Player Name`, `pl`.`PlayerPosition` AS `Player Position`, `pm`.`Height` AS `Player Height (cm)`, `pm`.`Weight` AS `Player Weight (kg)`, `pm`.`Status` AS `Player Status` FROM (`playerlist` `pl` join `playermetrics` `pm` on(`pl`.`PlayerID` = `pm`.`PlayerID`)) WHERE `pl`.`PlayerPosition` = 'Forward' AND `pm`.`Status` = 'Healthy' AND `pm`.`Height` >= 180 ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `healthdirector`
--
ALTER TABLE `healthdirector`
  ADD PRIMARY KEY (`StaffID`),
  ADD KEY `TeamID` (`TeamID`);

--
-- Indexes for table `injurylist`
--
ALTER TABLE `injurylist`
  ADD PRIMARY KEY (`InjuryID`),
  ADD KEY `PlayerID` (`PlayerID`),
  ADD KEY `FacilityID` (`FacilityID`),
  ADD KEY `StaffID` (`StaffID`);

--
-- Indexes for table `playerlist`
--
ALTER TABLE `playerlist`
  ADD PRIMARY KEY (`PlayerID`);

--
-- Indexes for table `playermetrics`
--
ALTER TABLE `playermetrics`
  ADD KEY `PlayerID` (`PlayerID`);

--
-- Indexes for table `teamfacility`
--
ALTER TABLE `teamfacility`
  ADD PRIMARY KEY (`FacilityID`),
  ADD KEY `TeamID` (`TeamID`),
  ADD KEY `StaffID` (`StaffID`);

--
-- Indexes for table `teamlist`
--
ALTER TABLE `teamlist`
  ADD PRIMARY KEY (`TeamID`);

--
-- Indexes for table `teamroster`
--
ALTER TABLE `teamroster`
  ADD KEY `TeamID` (`TeamID`),
  ADD KEY `PlayerID` (`PlayerID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `healthdirector`
--
ALTER TABLE `healthdirector`
  ADD CONSTRAINT `healthdirector_ibfk_1` FOREIGN KEY (`TeamID`) REFERENCES `teamlist` (`TeamID`) ON UPDATE CASCADE;

--
-- Constraints for table `injurylist`
--
ALTER TABLE `injurylist`
  ADD CONSTRAINT `injurylist_ibfk_1` FOREIGN KEY (`PlayerID`) REFERENCES `playerlist` (`PlayerID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `injurylist_ibfk_2` FOREIGN KEY (`FacilityID`) REFERENCES `teamfacility` (`FacilityID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `injurylist_ibfk_3` FOREIGN KEY (`StaffID`) REFERENCES `healthdirector` (`StaffID`) ON UPDATE CASCADE;

--
-- Constraints for table `playermetrics`
--
ALTER TABLE `playermetrics`
  ADD CONSTRAINT `playermetrics_ibfk_1` FOREIGN KEY (`PlayerID`) REFERENCES `playerlist` (`PlayerID`) ON UPDATE CASCADE;

--
-- Constraints for table `teamfacility`
--
ALTER TABLE `teamfacility`
  ADD CONSTRAINT `teamfacility_ibfk_1` FOREIGN KEY (`TeamID`) REFERENCES `teamlist` (`TeamID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `teamfacility_ibfk_2` FOREIGN KEY (`StaffID`) REFERENCES `healthdirector` (`StaffID`) ON UPDATE CASCADE;

--
-- Constraints for table `teamroster`
--
ALTER TABLE `teamroster`
  ADD CONSTRAINT `teamroster_ibfk_1` FOREIGN KEY (`TeamID`) REFERENCES `teamlist` (`TeamID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `teamroster_ibfk_2` FOREIGN KEY (`PlayerID`) REFERENCES `playerlist` (`PlayerID`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
