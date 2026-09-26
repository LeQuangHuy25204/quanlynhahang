SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE TABLE `area` (
  `AreaID` bigint(20) NOT NULL AUTO_INCREMENT,
  `BranchID` bigint(20) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `IsActive` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`AreaID`),
  UNIQUE KEY `UQ_Area` (`BranchID`,`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `branch` (
  `BranchID` bigint(20) NOT NULL AUTO_INCREMENT,
  `RestaurantID` bigint(20) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Address` varchar(500) NOT NULL,
  `Phone` varchar(20) NOT NULL,
  `BussinessStartHour` time NOT NULL,
  `TaxCode` varchar(50) DEFAULT NULL,
  `VATRate` decimal(5,2) NOT NULL,
  `ServiceFeeRate` decimal(5,2) NOT NULL,
  `IsActive` tinyint(4) NOT NULL DEFAULT 1,
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp(),
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`BranchID`),
  UNIQUE KEY `UQ_Branch` (`RestaurantID`,`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `branchmenuoverride` (
  `BranchMenuOverrideID` bigint(20) NOT NULL AUTO_INCREMENT,
  `BranchID` bigint(20) NOT NULL,
  `MenuItemID` bigint(20) NOT NULL,
  `OverridePrice` decimal(18,2) DEFAULT NULL,
  `IsAvailable` tinyint(4) NOT NULL DEFAULT 1,
  `StartDate` datetime DEFAULT NULL,
  `EndDate` datetime DEFAULT NULL,
  PRIMARY KEY (`BranchMenuOverrideID`),
  UNIQUE KEY `UQ_Override` (`BranchID`,`MenuItemID`),
  KEY `FK_BranchMenuOverride_MenuItem` (`MenuItemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `category` (
  `CategoryID` bigint(20) NOT NULL AUTO_INCREMENT,
  `RestaurantID` bigint(20) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`CategoryID`),
  UNIQUE KEY `UQ_Category` (`RestaurantID`,`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `invoice` (
  `InvoiceID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PaymentID` bigint(20) NOT NULL,
  `InvoiceNumber` varchar(50) NOT NULL,
  `InvoiceDate` datetime NOT NULL DEFAULT current_timestamp(),
  `SubTotal` decimal(18,2) NOT NULL,
  `VATAmount` decimal(18,2) NOT NULL,
  `ServiceFeeAmount` decimal(18,2) NOT NULL,
  `DiscountAmount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `TotalAmount` decimal(18,2) NOT NULL,
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`InvoiceID`),
  UNIQUE KEY `UQ_Invoice_PaymentID` (`PaymentID`),
  UNIQUE KEY `UQ_Invoice_InvoiceNumber` (`InvoiceNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `menuitem` (
  `MenuItemID` bigint(20) NOT NULL AUTO_INCREMENT,
  `RestaurantID` bigint(20) NOT NULL,
  `CategoryID` bigint(20) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Unit` varchar(50) NOT NULL DEFAULT 'Phần',
  `Description` longtext DEFAULT NULL,
  `BasePrice` decimal(18,2) NOT NULL,
  `url_Image` varchar(500) DEFAULT NULL,
  `IsActive` tinyint(4) NOT NULL DEFAULT 1,
  `IsWeightBased` tinyint(4) NOT NULL DEFAULT 0,
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`MenuItemID`),
  UNIQUE KEY `UQ_MenuItem` (`RestaurantID`,`Name`),
  KEY `FK_MenuItem_Category` (`CategoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `order` (
  `OrderID` bigint(20) NOT NULL AUTO_INCREMENT,
  `SessionID` bigint(20) NOT NULL,
  `ParticipantID` bigint(20) NOT NULL,
  `OrderNumber` varchar(50) NOT NULL,
  `CreatedByStaffID` bigint(20) DEFAULT NULL,
  `Status` tinyint(4) NOT NULL,
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp(),
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`OrderID`),
  KEY `FK_Order_Participant` (`ParticipantID`),
  KEY `FK_Order_Session` (`SessionID`),
  KEY `FK_Order_Staff` (`CreatedByStaffID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `orderline` (
  `OrderLineID` bigint(20) NOT NULL AUTO_INCREMENT,
  `OrderID` bigint(20) NOT NULL,
  `MenuItemID` bigint(20) NOT NULL,
  `Quantity` decimal(10,3) NOT NULL,
  `UnitPrice` decimal(18,2) NOT NULL,
  `DiscountApplied` decimal(18,2) NOT NULL DEFAULT 0.00,
  `Note` varchar(500) DEFAULT NULL,
  `Status` tinyint(4) NOT NULL,
  `CancelledAt` datetime DEFAULT NULL,
  `CancelledBy` bigint(20) DEFAULT NULL,
  `CancelReason` varchar(500) DEFAULT NULL,
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp(),
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`OrderLineID`),
  KEY `FK_OrderLine_CancelledStaff` (`CancelledBy`),
  KEY `FK_OrderLine_MenuItem` (`MenuItemID`),
  KEY `FK_OrderLine_Order` (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `payment` (
  `PaymentID` bigint(20) NOT NULL AUTO_INCREMENT,
  `OrderID` bigint(20) NOT NULL,
  `Amount` decimal(18,2) NOT NULL,
  `PaymentMethod` varchar(50) NOT NULL,
  `Status` tinyint(4) NOT NULL,
  `PaidAt` datetime DEFAULT NULL,
  `TransactionNo` varchar(100) DEFAULT NULL,
  `Note` varchar(500) DEFAULT NULL,
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`PaymentID`),
  KEY `FK_Payment_Order` (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `promotion` (
  `PromotionID` bigint(20) NOT NULL AUTO_INCREMENT,
  `RestaurantID` bigint(20) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Description` varchar(500) DEFAULT NULL,
  `DiscountType` varchar(20) NOT NULL,
  `DiscountValue` decimal(18,2) NOT NULL,
  `StartDate` datetime NOT NULL,
  `EndDate` datetime DEFAULT NULL,
  `IsActive` tinyint(4) NOT NULL DEFAULT 1,
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp(),
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`PromotionID`),
  KEY `FK_Promotion_Restaurant` (`RestaurantID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `restaurant` (
  `RestaurantID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Logo` varchar(500) DEFAULT NULL,
  `Description` longtext DEFAULT NULL,
  `Address` varchar(500) NOT NULL,
  `Phone` varchar(20) NOT NULL,
  `TaxCode` varchar(20) NOT NULL,
  `Status` tinyint(4) NOT NULL,
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp(),
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`RestaurantID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `role` (
  `RoleID` bigint(20) NOT NULL AUTO_INCREMENT,
  `RoleCode` varchar(50) NOT NULL,
  `RoleName` varchar(100) NOT NULL,
  `Description` longtext DEFAULT NULL,
  `IsActive` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`RoleID`),
  UNIQUE KEY `UQ_Role_RoleCode` (`RoleCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `session` (
  `SessionID` bigint(20) NOT NULL AUTO_INCREMENT,
  `TableID` bigint(20) NOT NULL,
  `SessionToken` varchar(255) NOT NULL,
  `JoinCode` varchar(20) NOT NULL,
  `Status` tinyint(4) NOT NULL,
  `StartTime` datetime NOT NULL DEFAULT current_timestamp(),
  `EndTime` datetime DEFAULT NULL,
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`SessionID`),
  UNIQUE KEY `UQ_Session_SessionToken` (`SessionToken`),
  UNIQUE KEY `UQ_Session_JoinCode` (`JoinCode`),
  KEY `FK_Session_Table` (`TableID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `sessionparticipant` (
  `ParticipantID` bigint(20) NOT NULL AUTO_INCREMENT,
  `SessionID` bigint(20) NOT NULL,
  `JoinedAt` datetime NOT NULL DEFAULT current_timestamp(),
  `Status` tinyint(4) NOT NULL DEFAULT 1,
  `GuestName` varchar(100) NOT NULL,
  PRIMARY KEY (`ParticipantID`),
  KEY `FK_SessionParticipant_Session` (`SessionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `staff` (
  `StaffID` bigint(20) NOT NULL AUTO_INCREMENT,
  `BranchID` bigint(20) NOT NULL,
  `RoleID` bigint(20) NOT NULL,
  `FullName` varchar(255) NOT NULL,
  `Phone` varchar(20) NOT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Username` varchar(100) NOT NULL,
  `PasswordHash` varchar(255) NOT NULL,
  `Status` tinyint(4) NOT NULL DEFAULT 1,
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp(),
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `Column` int(11) DEFAULT NULL,
  PRIMARY KEY (`StaffID`),
  UNIQUE KEY `UQ_Staff_Username` (`Username`),
  KEY `FK_Staff_Branch` (`BranchID`),
  KEY `FK_Staff_Role` (`RoleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `table` (
  `TableID` bigint(20) NOT NULL AUTO_INCREMENT,
  `AreaID` bigint(20) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `QRCode` varchar(255) NOT NULL,
  `IsActive` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`TableID`),
  UNIQUE KEY `UQ_Table_Name` (`AreaID`,`Name`),
  UNIQUE KEY `UQ_Table_QR` (`AreaID`,`QRCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


ALTER TABLE `area`
  ADD CONSTRAINT `FK_Area_Branch` FOREIGN KEY (`BranchID`) REFERENCES `branch` (`BranchID`);
ALTER TABLE `branch`
  ADD CONSTRAINT `FK_Branch_Restaurant` FOREIGN KEY (`RestaurantID`) REFERENCES `restaurant` (`RestaurantID`);
ALTER TABLE `branchmenuoverride`
  ADD CONSTRAINT `FK_BranchMenuOverride_Branch` FOREIGN KEY (`BranchID`) REFERENCES `branch` (`BranchID`),
  ADD CONSTRAINT `FK_BranchMenuOverride_MenuItem` FOREIGN KEY (`MenuItemID`) REFERENCES `menuitem` (`MenuItemID`);
ALTER TABLE `category`
  ADD CONSTRAINT `FK_Category_Restaurant` FOREIGN KEY (`RestaurantID`) REFERENCES `restaurant` (`RestaurantID`);
ALTER TABLE `invoice`
  ADD CONSTRAINT `FK_Invoice_Payment` FOREIGN KEY (`PaymentID`) REFERENCES `payment` (`PaymentID`);
ALTER TABLE `menuitem`
  ADD CONSTRAINT `FK_MenuItem_Category` FOREIGN KEY (`CategoryID`) REFERENCES `category` (`CategoryID`),
  ADD CONSTRAINT `FK_MenuItem_Restaurant` FOREIGN KEY (`RestaurantID`) REFERENCES `restaurant` (`RestaurantID`);
ALTER TABLE `order`
  ADD CONSTRAINT `FK_Order_Participant` FOREIGN KEY (`ParticipantID`) REFERENCES `sessionparticipant` (`ParticipantID`),
  ADD CONSTRAINT `FK_Order_Session` FOREIGN KEY (`SessionID`) REFERENCES `session` (`SessionID`),
  ADD CONSTRAINT `FK_Order_Staff` FOREIGN KEY (`CreatedByStaffID`) REFERENCES `staff` (`StaffID`);
ALTER TABLE `orderline`
  ADD CONSTRAINT `FK_OrderLine_CancelledStaff` FOREIGN KEY (`CancelledBy`) REFERENCES `staff` (`StaffID`),
  ADD CONSTRAINT `FK_OrderLine_MenuItem` FOREIGN KEY (`MenuItemID`) REFERENCES `menuitem` (`MenuItemID`),
  ADD CONSTRAINT `FK_OrderLine_Order` FOREIGN KEY (`OrderID`) REFERENCES `order` (`OrderID`);
ALTER TABLE `payment`
  ADD CONSTRAINT `FK_Payment_Order` FOREIGN KEY (`OrderID`) REFERENCES `order` (`OrderID`);
ALTER TABLE `promotion`
  ADD CONSTRAINT `FK_Promotion_Restaurant` FOREIGN KEY (`RestaurantID`) REFERENCES `restaurant` (`RestaurantID`);
ALTER TABLE `session`
  ADD CONSTRAINT `FK_Session_Table` FOREIGN KEY (`TableID`) REFERENCES `table` (`TableID`);
ALTER TABLE `sessionparticipant`
  ADD CONSTRAINT `FK_SessionParticipant_Session` FOREIGN KEY (`SessionID`) REFERENCES `session` (`SessionID`);
ALTER TABLE `staff`
  ADD CONSTRAINT `FK_Staff_Branch` FOREIGN KEY (`BranchID`) REFERENCES `branch` (`BranchID`),
  ADD CONSTRAINT `FK_Staff_Role` FOREIGN KEY (`RoleID`) REFERENCES `role` (`RoleID`);
ALTER TABLE `table`
  ADD CONSTRAINT `FK_Table_Area` FOREIGN KEY (`AreaID`) REFERENCES `area` (`AreaID`);
COMMIT;



-- BẮT ĐẦU DỮ LIỆU MẪU --

INSERT INTO `role` (`RoleID`, `RoleCode`, `RoleName`, `Description`, `IsActive`) VALUES
(1, 'RestaurantAdmin', 'Quản trị viên', 'Quản lý toàn bộ nhà hàng', 1),
(2, 'BranchManager', 'Quản lý chi nhánh', 'Quản lý 1 chi nhánh', 1),
(3, 'Cashier', 'Thu ngân', 'Quản lý thanh toán', 1),
(4, 'Waiter', 'Phục vụ', 'Order món ăn', 1);

INSERT INTO `restaurant` (`RestaurantID`, `Name`, `Logo`, `Description`, `Address`, `Phone`, `TaxCode`, `Status`) VALUES
(1, 'Hệ thống BBQ KLTN', 'https://logo.com/bbq.png', 'Thịt nướng siêu ngon', '123 Đường B, Quận 1', '0901234567', 'TAX-12345', 1);

INSERT INTO `branch` (`BranchID`, `RestaurantID`, `Name`, `Address`, `Phone`, `BussinessStartHour`, `TaxCode`, `VATRate`, `ServiceFeeRate`, `IsActive`) VALUES
(1, 1, 'Chi nhánh Quận 1', '123 Trần Hưng Đạo, Q1', '0901111111', '10:00:00', 'TAX-1', 8.00, 5.00, 1),
(2, 1, 'Chi nhánh Quận 3', '456 Lê Văn Sỹ, Q3', '0902222222', '10:00:00', 'TAX-2', 8.00, 5.00, 1);

INSERT INTO `staff` (`StaffID`, `BranchID`, `RoleID`, `FullName`, `Phone`, `Email`, `Username`, `PasswordHash`, `Status`) VALUES
(1, 1, 1, 'Nguyễn Admin', '0988888888', 'admin@bbq.com', 'admin1', '$2a$12$WhGmYA8krsZ/18MqdTp.2ukxCvtDam1nkycsVktqO9Q49wC3xzdLe', 1),
(2, 1, 2, 'Trần Quản Lý Q1', '0988888881', 'ql1@bbq.com', 'manager1', '$2a$12$WhGmYA8krsZ/18MqdTp.2ukxCvtDam1nkycsVktqO9Q49wC3xzdLe', 1),
(3, 2, 2, 'Lê Quản Lý Q3', '0988888882', 'ql2@bbq.com', 'manager2', '$2a$12$WhGmYA8krsZ/18MqdTp.2ukxCvtDam1nkycsVktqO9Q49wC3xzdLe', 1),
(4, 1, 3, 'Phạm Thu Ngân 1', '0988888883', 'tn1@bbq.com', 'cashier1', '$2a$12$WhGmYA8krsZ/18MqdTp.2ukxCvtDam1nkycsVktqO9Q49wC3xzdLe', 1),
(5, 1, 4, 'Hoàng Phục Vụ 1', '0988888884', 'pv1@bbq.com', 'waiter1', '$2a$12$WhGmYA8krsZ/18MqdTp.2ukxCvtDam1nkycsVktqO9Q49wC3xzdLe', 1);

INSERT INTO `category` (`CategoryID`, `RestaurantID`, `Name`, `Description`) VALUES
(1, 1, 'Thịt nướng', 'Các loại thịt bò, heo nướng'),
(2, 1, 'Hải sản nướng', 'Tôm, mực, hàu'),
(3, 1, 'Nước uống', 'Nước ngọt, bia, rượu');

INSERT INTO `menuitem` (`MenuItemID`, `RestaurantID`, `CategoryID`, `Name`, `Unit`, `Description`, `BasePrice`, `url_Image`, `IsActive`, `IsWeightBased`) VALUES
(1, 1, 1, 'Bò Tảng Mỹ nướng đá', 'Phần', 'Bò tảng nhập khẩu', 250000.00, NULL, 1, 0),
(2, 1, 1, 'Ba chỉ heo cuộn nấm', 'Phần', 'Heo tươi', 120000.00, NULL, 1, 0),
(3, 1, 2, 'Mực lá khổng lồ', 'Kg', 'Bán theo cân lượng', 450000.00, NULL, 1, 1),
(4, 1, 3, 'Coca Cola', 'Lon', 'Nước ngọt', 25000.00, NULL, 1, 0);

INSERT INTO `area` (`AreaID`, `BranchID`, `Name`, `IsActive`) VALUES
(1, 1, 'Tầng Trệt - Sảnh', 1),
(2, 1, 'Tầng 1 - VIP', 1),
(3, 2, 'Sân Vườn', 1);

INSERT INTO `table` (`TableID`, `AreaID`, `Name`, `QRCode`, `IsActive`) VALUES
(1, 1, 'Bàn T1-01', 'table_qr_1', 1),
(2, 1, 'Bàn T1-02', 'table_qr_2', 1),
(3, 2, 'Bàn VIP-01', 'table_qr_3', 1),
(4, 3, 'Bàn V-01', 'table_qr_4', 1);

INSERT INTO `promotion` (`PromotionID`, `RestaurantID`, `Name`, `Description`, `DiscountType`, `DiscountValue`, `StartDate`, `EndDate`, `IsActive`) VALUES
(1, 1, 'Khai trương giảm 10%', 'Giảm trực tiếp 10% tổng bill', 'PERCENT', 10.00, '2020-01-01 00:00:00', '2030-12-31 23:59:59', 1);
