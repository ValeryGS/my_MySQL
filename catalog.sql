DROP DATABASE if EXISTS catalog;
-- SET NAMES 'latin1';
/* Каталог предприятий, производимой продукции и используемого сырья. 
	Поиск поставщиков и заказчиков. Покупка, продажа компаний. Поиск инвестров.
	Инвест профиль - 
    Потребность в инвестициях - 
    Возможности расширения -
*/

/*
DROP TABLE IF EXISTS business_indicators;
CREATE TABLE business indicators (
	id_company BIGINT UNSIGNED NOT NULL UNIQUE COMMENT 'Должен совпадать с id компании.',
    income_expenses BIGINT  NOT NULL COMMENT 'Дходы и расходы',
    cost_of_production BIGINT  NOT NULL COMMENT ' Себестоимость продукции',
	profitability BIGINT  NOT NULL COMMENT 'Рентабельность',
    equity capital BIGINT  NOT NULL COMMENT 'Собственный капитал',
    money movement BIGINT  NOT NULL COMMENT 'Движене денег',
    sales volume BIGINT  NOT NULL COMMENT 'Объём продаж')
    */
CREATE DATABASE catalog;
USE catalog;

/* Таблица предложений поставки товара. */
DROP TABLE IF EXISTS company_products_out;
CREATE TABLE company_products_out (
	id SERIAL COMMENT 'Идентификатор строки',
    company_id BIGINT UNSIGNED NOT NULL ,
    out_products_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на вид продукции.',
    volume BIGINT UNSIGNED NOT NULL COMMENT 'Объём предлагаемой продукции.',
    units ENUM('pc.', 'kg.', 'tons', 'liters', 'cub. m.', 'sq. m.', 'lin. m.') NOT NULL COMMENT 'Единицы измерения объёма продукции.',
    to_date DATETIME DEFAULT NOW() COMMENT 'Планируемая дата отгрузки.',
    created_at DATETIME DEFAULT NOW() COMMENT 'Дата и время создания строки.',
    updated_at DATETIME DEFAULT NOW() ON UPDATE NOW() COMMENT 'Дата и время обновленния строки.') COMMENT 'Производимая продукция';
    
/* Таблица запросов не поставку товара */
DROP TABLE IF EXISTS company_products_in;
CREATE TABLE company_products_in (
	id SERIAL COMMENT 'Идентификатор строки',
    company_id BIGINT UNSIGNED NOT NULL ,
    in_products_id BIGINT UNSIGNED NOT NULL,
    volume BIGINT UNSIGNED NOT NULL COMMENT 'Объём продукции.' COMMENT ' Требуемый объём поставок.',
    units ENUM('pc.', 'kg.', 'tons', 'liters', 'cub. m.', 'sq. m.', 'lin. m.') NOT NULL COMMENT 'Единицы измерения объёма продукции.',
    to_date DATETIME DEFAULT NOW() COMMENT 'Предполагаемая дата поставки.',
    created_at DATETIME DEFAULT NOW() COMMENT 'Дата и время создания строки.',
    updated_at DATETIME DEFAULT NOW() ON UPDATE NOW() COMMENT 'Дата и время обновленния строки.') COMMENT 'Сырьё, материалы.';

/* Таблица админов .*/
DROP TABLE IF EXISTS user_db;
CREATE TABLE user_db (
	id SERIAL PRIMARY KEY COMMENT 'Идентификатор строки', -- искуственный ключ
	first_name VARCHAR(100) NOT NULL COMMENT 'Имя пользователя.',
    last_name VARCHAR(100) NOT NULL COMMENT 'Фамилия пользователя.',
    birthday DATE NOT NULL COMMENT 'Дата рождения.',
    gender ENUM ('F','M') NOT NULL COMMENT 'Пол. И ни каких не определившися!',
    phone VARCHAR(12) UNIQUE NOT NULL COMMENT 'Телефон.',
    email VARCHAR(50) UNIQUE NOT NULL COMMENT 'Почта.',
    site VARCHAR(100) COMMENT 'Адрес вебсайта.',
    created_at DATETIME DEFAULT NOW() COMMENT 'Дата и время создания строки.',
    updated_at DATETIME DEFAULT NOW() ON UPDATE NOW() COMMENT 'Дата и время обновленния строки.') COMMENT 'Таблица составителей базы данных';

/* Таблица типов медиафайлов.*/
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
  id SERIAL PRIMARY KEY COMMENT 'Идентификатор строки',
  `name` VARCHAR(255) NOT NULL UNIQUE COMMENT 'Название типа',
  created_at DATETIME DEFAULT NOW() COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW() COMMENT 'Время обновления строки') COMMENT 'Типы медиафайлов';

/* Таблица медиафайлов.*/
DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id SERIAL PRIMARY KEY COMMENT 'Идентификатор строки',
	filename VARCHAR(255) NOT NULL COMMENT 'Полный путь к файлу',
    media_type_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на тип файла',
    -- user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на компанию',
	created_at DATETIME DEFAULT NOW() COMMENT 'Время создания строки',
	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW() COMMENT 'Время обновления строки',
    CONSTRAINT fk_media_type FOREIGN KEY (media_type_id) REFERENCES media_types (id));

/* Таблица форм собствености.*/
DROP TABLE if EXISTS ownership;
CREATE TABLE ownership(
	id SERIAL PRIMARY KEY,
    ownership_type VARCHAR(150) NOT NULL COMMENT 'Форма собственности');

/* Таблица типов деятельности.*/                        
DROP TABLE if EXISTS activity;
CREATE TABLE activity(
	id SERIAL PRIMARY KEY,
    activity_type VARCHAR(150) NOT NULL);

/* Таблица профилей.*/
DROP TABLE if EXISTS `profiles`;
CREATE TABLE `profiles`(
	id SERIAL PRIMARY KEY,
	doc_img_id BIGINT UNSIGNED NOT NULL COMMENT 'ID Скрина документа подтверждающего гос. регистрацию',
    country VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    street VARCHAR(50) NOT NULL,
    building VARCHAR(9) NOT NULL,
    office VARCHAR(10),
    email VARCHAR(50) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL);
    -- CONSTRAINT fk_doc_img FOREIGN KEY  (doc_img_id) REFERENCES media(id));
    
/* Таблица видов продукции.*/
DROP TABLE if EXISTS products;
CREATE TABLE products(
	id SERIAL PRIMARY KEY,
    `name` VARCHAR(255));

/* Таблица сообщений.*/
DROP TABLE IF EXISTS messages;
CREATE TABLE messages(
    id SERIAL PRIMARY KEY,
    `subject` ENUM('New order', 'New supplier') NOT NULL,
    to_company_id VARCHAR(125) NOT NULL,
    from_company_id VARCHAR(125) NOT NULL,
    product VARCHAR(255),
    volume BIGINT,
    units ENUM('pc.', 'kg.', 'tons', 'liters', 'cub. m.', 'sq. m.', 'lin. m.') NOT NULL);

/* Таблица статусов.*/
DROP TABLE IF EXISTS `status`;
CREATE TABLE `status`(
	id SERIAL PRIMARY KEY,
    `name` VARCHAR(255));

/* Таблица компаний.*/
DROP TABLE IF EXISTS company;
CREATE TABLE company(
	id SERIAL PRIMARY KEY,
    `name` VARCHAR(125) NOT NULL COMMENT 'Наименование.' ,
    user_id BIGINT UNSIGNED NOT NULL COMMENT 'Идентификатор вносившего запись.',
    ownership_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на таблицу форм собственности.',
    activity_id BIGINT UNSIGNED NOT NULL COMMENT ' Ссылка на таблицу сфер деятельности.',
    profile_id BIGINT UNSIGNED NOT NULL,
    -- out_products_id BIGINT UNSIGNED NOT NULL COMMENT ' Ссылка на таблицу продукции.Что производим',
    -- in_products_id BIGINT UNSIGNED NOT NULL COMMENT ' Ссылка на таблицу продукции. Что требуется',
    -- invest_profile_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на инвестиционный профиль',
    status_id BIGINT UNSIGNED NOT NULL COMMENT 'Продается, ищет инвесторов ...',
    profit_$ DECIMAL UNSIGNED NOT NULL  COMMENT 'Прибыль за последний год.',
    payback_period_month INT UNSIGNED NOT NULL  COMMENT 'Период окупаемости вложений.',
    created_at DATETIME DEFAULT NOW() COMMENT 'Время создания строки.',
	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW() COMMENT 'Время обновления строки.',
    CONSTRAINT fk_ownership FOREIGN KEY  (ownership_id) REFERENCES ownership(id),
    CONSTRAINT fk_user FOREIGN KEY  (user_id) REFERENCES user_db(id),
    CONSTRAINT fk_activity FOREIGN KEY (activity_id) REFERENCES activity (id),
    CONSTRAINT fk_status FOREIGN KEY (status_id) REFERENCES `status`(id));

-- ALTER TABLE `profiles` ADD CONSTRAINT fk_profile FOREIGN KEY (id) REFERENCES company(id);   
-- ALTER TABLE media ADD CONSTRAINT fk_media_company FOREIGN KEY (user_id) REFERENCES company (id);
/* Эти два ключа не добавляются так и не понял почему. Да и скорее всего они лишние... Там не будет 
	фактора ч.
ALTER TABLE messages ADD CONSTRAINT fk_message_to_comp FOREIGN KEY (to_company_id) REFERENCES company(`name`);
ALTER TABLE messages ADD CONSTRAINT fk_message_from_comp FOREIGN KEY (from_company_id) REFERENCES company(`name`);
*/
ALTER TABLE company_products_out ADD CONSTRAINT fk_company_out_product FOREIGN KEY (company_id) REFERENCES company (id);
ALTER TABLE company_products_in ADD CONSTRAINT fk_company_in_product FOREIGN KEY (company_id) REFERENCES company (id);
ALTER TABLE company_products_out ADD CONSTRAINT fk_product_out FOREIGN KEY (out_products_id) REFERENCES products (id);
ALTER TABLE company_products_in ADD CONSTRAINT fk_product_in FOREIGN KEY (in_products_id) REFERENCES products (id);
ALTER TABLE company ADD CONSTRAINT fk_profile_id FOREIGN KEY (id) REFERENCES `profiles`(id);

-- ALTER TABLE messages ADD CONSTRAINT fk_message_product FOREIGN KEY (product) REFERENCES products(id);

-- Заполнял в основном через filldb.info

INSERT `status`(`name`) VALUES
	('For sale'), ('Waiting for investors'), ('Ready to invest'), ('Ready to merge');

INSERT INTO `user_db` VALUES 
	(1,'Paige','Grady','2005-01-06','M','331-770-2209','ankunding.raphaelle@example.org',NULL,'1978-02-21 11:03:39','1987-04-28 16:37:08'),
    (2,'Kirk','Moore','2015-01-15','M','(580)198-546','guadalupe.stanton@example.net',NULL,'1997-03-04 03:25:34','1974-08-15 09:50:37'),
    (3,'Anya','Medhurst','1993-01-06','F','643.053.7627','melany.fay@example.org',NULL,'1972-08-28 13:51:56','1972-09-19 18:59:32'),
    (4,'Tressa','Macejkovic','2004-02-14','F','1-491-649-62','shields.dorian@example.net',NULL,'1997-10-17 11:56:49','2007-06-09 17:01:40'),
    (5,'Godfrey','Harris','1976-04-27','M','00647240593','umarquardt@example.com',NULL,'1998-08-03 09:48:18','1979-08-11 12:48:00'),
    (6,'Darlene','Lubowitz','1979-04-07','M','04837520818','keely27@example.com',NULL,'2004-03-18 12:19:02','1995-11-30 07:58:30'),
    (7,'Anjali','Torphy','1973-06-23','M','(441)697-605','leanna28@example.net',NULL,'1996-01-06 15:50:23','2020-11-10 20:14:24'),
    (8,'Kameron','Heathcote','2018-06-27','F','1-475-850-83','aisha08@example.com',NULL,'1982-03-09 09:06:29','2019-11-30 01:50:36'),
    (9,'Lauriane','Strosin','1996-11-08','F','00285104828','adelbert35@example.org',NULL,'1996-12-31 23:01:29','1970-02-22 00:11:14'),
    (10,'Breanne','Blick','2012-08-29','M','+46(9)219978','harris.jeanie@example.com',NULL,'2000-01-28 08:38:06','2020-06-15 02:02:10');

INSERT media_types(`name`) values 
	('Video. '),
    ('Image.'),
    ('Document.'),
    ('Hyperlink.');

INSERT activity(activity_type) values 
	('household services'),
	('business services'),
	('internet business'),
	('Housing and communal services'),
	('beauty salons'),
	('the medicine'),
	('education'),
	('public catering'),
	('production'),
	('agricultural, farming'),
	('Media'),
	('construction'),
	('trading'),
	('transport'),
	('tourism business'),
	('entertainment activities'),
	('organization of holidays, holidays, etc.');
    
INSERT INTO `media` VALUES 
	(1,'non',1,'2021-12-18 01:05:29','1976-08-15 21:37:33'),
    (2,'fugit',2,'2007-12-15 23:44:21','1981-04-17 08:35:29'),
    (3,'est',3,'2018-11-10 12:53:40','2018-11-25 18:34:27'),
    (4,'ab',4,'2016-12-27 03:07:46','1983-11-22 14:26:55'),
    (5,'voluptatem',1,'2001-03-27 15:58:31','2019-10-29 10:08:40'),
    (6,'ratione',2,'1981-06-27 18:45:23','2010-02-17 11:21:55'),
    (7,'reprehenderit',3,'2001-12-13 00:35:47','1983-12-01 07:38:24'),
    (8,'ut',4,'2021-05-22 20:28:06','1975-10-15 07:26:43'),
    (9,'ea',1,'1994-01-22 01:35:39','2016-10-08 05:02:17'),
    (10,'aut',2,'1972-11-03 09:37:20','2005-12-14 03:44:51');
    
INSERT ownership(ownership_type)  VALUES 
	( 'Individual businessman'),
	( 'Individual (family) enterprise'),
	( 'Full partnership'),
	( 'Mixed partnership'),
	( 'Limited Liability Partnership (closed joint stock company)'),
	( 'Open Joint Stock Company');
    
-- ******************* filldb *******************

INSERT INTO `products` VALUES 
	(1,'vel'),
    (2,'cupiditate'),
    (3,'voluptatem'),
    (4,'quis'),
    (5,'quia'),
    (6,'anuptanium'),
    (7,'praesentium'),
    (8,'qunto'),
    (9,'molesan'),
    (10,'aperiam'),
    (11,'paperiam');

INSERT INTO `profiles` VALUES 
	(1,1,'Saudi Arabia','North Coralie','Jammie Track','954','8','labadie.aracely@example.org','(407)481-1001x6'),
    (2,2,'Guatemala','Auerland','Juston Neck','210','2','marcelo95@example.net','328.625.0611x76'),
    (3,3,'Romania','Hahnfort','Clinton Lodge','403','4','wilfredo.hoeger@example.net','245.190.4029x31'),
    (4,4,'San Marino','West Madalyn','Kennedy Station','17001','4','o\'reilly.jarod@example.net','1-656-337-5640x'),
    (5,5,'Romania','Prosaccoberg','Collier Oval','6284','8','freda01@example.com','(217)162-6413x5'),
    (6,6,'American Samoa','Lake Bethel','Bashirian Ways','591','7','candice52@example.org','09560398125'),
    (7,7,'Mauritius','Port Madysonfurt','Kellen Key','246','9','ashlee.strosin@example.com','472.850.8310x44'),
    (8,8,'United States Minor Outlying Islands','Hicklefort','Deja Estates','1101','6','sframi@example.org','658-045-6107x18'),
    (9,9,'Guam','Bashiriantown','Cydney Islands','9378','3','thelma15@example.com','+96(0)641560882'),
    (10,10,'Haiti','Port Marina','Juliana Valley','695','6','dstiedemann@example.org','(569)345-3229');

INSERT INTO `company` VALUES 
	(1,'minus',1,1,1,1,1,0,0,'1970-04-29 16:47:55','1989-05-31 23:51:07'),
    (2,'illum',2,2,2,2,2,0,0,'1973-03-27 20:00:28','2020-03-26 20:57:50'),
    (3,'consequatur',3,3,3,3,3,0,0,'2008-12-06 23:32:40','2013-08-16 13:02:01'),
    (4,'molestan',4,4,4,4,4,0,0,'1988-12-30 04:57:11','1988-04-14 23:57:35'),
    (5,'optio',5,5,5,5,1,0,0,'1999-05-07 23:41:46','1998-02-12 01:20:10'),
    (6,'perferendis',6,6,6,6,2,0,0,'2021-09-04 03:22:26','1991-05-18 23:42:33'),
    (7,'excepturi',7,1,7,7,3,0,0,'2011-04-09 20:34:47','1980-08-04 20:57:17'),
    (8,'sferum',8,2,8,8,4,0,0,'1972-09-24 22:15:53','1975-04-23 21:36:47'),
    (9,'alias',9,3,9,9,1,0,0,'1985-05-21 20:19:30','1975-06-16 04:31:31'),
    (10,'sunt',10,4,10,10,2,0,0,'2008-11-15 20:06:14','1975-12-27 09:22:38');
    
-- рандомизируем значения 
update company set payback_period_month = round((rand() * 60),0);
update company set profit_$ = round((rand() * 100000),0);
update company set status_id = round((rand() * 3),0) + 1;
update company set activity_id = round((rand() * 16),0) + 1;
update company set ownership_id = round((rand() * 5),0) + 1;

INSERT INTO `company_products_in` VALUES 
	(1,1,1,0,'kg.','2020-09-27 08:55:15','2008-11-04 13:32:09','1991-11-24 01:47:46'),
    (2,2,2,0,'pc.','1971-07-30 21:26:01','1982-01-28 23:08:46','2010-11-02 01:24:22'),
    (3,3,3,0,'lin. m.','1990-04-08 18:40:27','1983-11-13 14:57:13','1994-09-15 12:23:03'),
    (4,4,4,0,'tons','1971-07-23 02:41:19','1977-07-19 02:30:42','2002-12-04 18:36:47'),
    (5,5,5,0,'kg.','1984-03-27 10:40:12','1988-04-11 06:45:38','1985-04-21 11:34:45'),
    (6,6,6,0,'sq. m.','1973-05-24 02:18:45','1992-07-31 01:55:08','1974-01-07 15:08:00'),
    (7,7,7,0,'kg.','1972-08-27 18:10:27','1977-05-01 08:46:22','1972-05-18 21:12:53'),
    (8,8,8,0,'pc.','1971-05-31 11:06:28','1999-05-01 19:30:49','1991-08-16 14:46:06'),
    (9,9,9,0,'cub. m.','1980-12-26 10:43:06','1995-05-18 19:54:49','2016-05-27 23:31:19'),
    (10,10,10,0,'sq. m.','2019-09-09 02:13:31','1997-08-23 09:08:00','2007-07-19 04:32:40'),
    (11,1,11,0,'lin. m.','1979-04-10 10:48:55','1995-06-24 09:40:44','1997-06-10 23:38:16'),
    (12,2,1,0,'kg.','2006-03-11 11:22:04','1983-01-21 12:25:58','1995-11-07 19:48:40'),
    (13,3,2,0,'lin. m.','1974-12-18 15:56:14','1981-06-16 12:27:37','1984-10-09 03:37:26'),
    (14,4,3,0,'liters','2014-07-23 21:35:53','2004-02-21 01:19:45','1993-12-07 14:02:00'),
    (15,5,4,0,'liters','1992-12-06 09:55:33','1974-11-28 12:47:01','2019-12-01 08:17:52'),
    (16,6,5,0,'pc.','1982-11-19 12:26:29','1970-12-01 16:19:59','1998-09-25 16:41:53'),
    (17,7,6,0,'pc.','2009-02-01 07:14:17','1976-07-19 15:01:20','2003-02-19 06:56:34'),
    (18,8,7,0,'kg.','1978-09-25 03:17:33','2020-11-19 23:49:19','2012-03-22 16:38:59'),
    (19,9,8,0,'kg.','1979-09-17 07:48:24','1994-09-05 07:36:40','2017-04-01 03:11:31'),
    (20,10,9,0,'liters','2017-02-01 05:12:49','2020-12-08 16:43:39','1985-01-20 06:16:16');
    
-- рандомизируем значения  
update company_products_in set company_id = round((rand() * 9), 0)  + 1;
update company_products_in set in_products_id = round((rand() * 10), 0)  + 1;
update company_products_in set volume = round((rand() * 1000), 0)  + 1;

INSERT INTO `company_products_out` VALUES 
	(1,1,1,0,'kg.','1975-06-22 09:10:55','1977-11-17 15:59:28','2018-02-01 13:09:15'),
    (2,2,2,0,'liters','2011-05-27 03:50:16','1991-12-26 21:40:37','1990-02-20 04:10:15'),
    (3,3,3,0,'kg.','1977-01-23 09:17:28','1994-04-18 10:21:15','2018-01-15 08:42:42'),
    (4,4,4,0,'lin. m.','1972-10-19 10:21:04','2001-06-01 02:33:14','1995-12-29 11:09:33'),
    (5,5,5,0,'liters','2015-07-05 15:45:19','1999-12-03 09:37:02','1989-03-24 15:06:17'),
    (6,6,6,0,'sq. m.','2004-01-14 22:36:17','1989-08-17 00:49:35','2016-09-26 07:17:44'),
    (7,7,7,0,'lin. m.','2003-05-05 03:07:08','1993-12-07 23:11:48','1977-02-02 08:10:53'),
    (8,8,8,0,'pc.','1983-01-08 20:05:19','1989-08-18 16:52:34','1983-06-23 14:36:10'),
    (9,9,9,0,'lin. m.','2007-09-09 16:05:33','1984-03-07 23:06:12','2017-03-12 23:17:06'),
    (10,10,10,0,'liters','1984-02-04 03:49:52','2018-08-27 20:35:59','2010-05-30 03:10:31'),
    (11,1,11,0,'lin. m.','1990-09-05 08:55:28','2009-08-13 23:29:18','2014-07-26 12:20:43'),
    (12,2,1,0,'tons','1984-10-10 19:03:35','2000-06-24 17:39:09','2000-06-22 14:29:51'),
    (13,3,2,0,'lin. m.','1985-06-11 19:31:34','2000-02-12 17:52:11','1993-10-18 11:20:36'),
    (14,4,3,0,'tons','1990-07-27 09:43:04','1972-12-09 21:50:32','1991-07-14 11:06:16'),
    (15,5,4,0,'cub. m.','2008-10-01 17:15:35','1977-01-29 01:34:45','1971-02-04 13:54:27'),
    (16,6,5,0,'tons','1970-06-15 06:48:12','1973-03-29 00:32:54','1978-01-20 17:44:07'),
    (17,7,6,0,'pc.','1995-01-17 04:10:05','2017-03-31 06:32:16','2009-08-13 04:56:19'),
    (18,8,7,0,'kg.','1986-03-31 15:05:02','1994-07-15 05:06:01','1973-11-30 09:01:00'),
    (19,9,8,0,'tons','1980-07-08 02:12:51','1979-06-19 09:44:49','1990-02-21 08:40:03'),
    (20,10,9,0,'sq. m.','1982-11-05 22:29:25','1987-11-30 14:11:25','2012-02-25 08:16:45');

-- рандомизируем значения 
update company_products_out set company_id = round((rand() * 9), 0)  + 1;
update company_products_out set out_products_id = round((rand() * 10), 0)  + 1;
update company_products_out set volume = round((rand() * 1000), 0)  + 1;
   
UPDATE company_products_in set to_date = date_add(now(), interval ((rand() * 3) + 1) year);
UPDATE company_products_out set to_date = date_add(now(), interval ((rand() * 3) + 1) year);
UPDATE company_products_in set to_date = date_add(to_date, interval (rand() * 24) hour);
UPDATE company_products_out set to_date = date_add(to_date, interval (rand() * 24) hour);

-- добавлю пару колонок для обработки в функции
ALTER TABLE company_products_out ADD price DECIMAL(10,2);
UPDATE company_products_out SET price = ROUND((RAND()*1000),2);
ALTER TABLE company_products_out CHANGE  price price DECIMAL(10,2) UNSIGNED NOT NULL;
ALTER TABLE company_products_in ADD price DECIMAL(10,2) UNSIGNED NOT NULL;
UPDATE company_products_in SET price = ROUND((RAND()*1000),2);
ALTER TABLE company ADD  investment DECIMAL(10,0) UNSIGNED NOT NULL;
UPDATE company SET investment = ROUND((RAND()*1000000),0);

use catalog;
-- *************************** Триггеры ***************************
/* После появления нового заказа отправляем сообщение о новых заказах тем кто выставил 
	предложение на аналогичный товар. */
DELIMITER //
DROP TRIGGER IF EXISTS new_order //
CREATE TRIGGER new_order AFTER INSERT ON company_products_in
	FOR EACH ROW
    BEGIN
		INSERT messages (`subject`, to_company_id, from_company_id, product, volume, units) 
        (SELECT 'New order', c.`name`, nc.`name`, p.`name`, NEW.volume, NEW.units
        FROM company_products_out AS cpo
        JOIN company as nc ON NEW.company_id = nc.id
        JOIN company AS c ON cpo.company_id = c.id
        JOIN products as p ON NEW.in_products_id = p.id
        WHERE cpo.out_products_id = NEW.in_products_id);
    END //
DELIMITER ;
-- смотрим количество сообщений
SELECT * FROM messages;
-- созадем ключевое событие для триггера
INSERT INTO `company_products_in` VALUES 
	(DEFAULT,1,11,220,'kg.','2020-09-27 08:55:15', DEFAULT,'1991-11-24 01:47:46', 9999991.00);
-- проверяем сообщения должны появиться новые
SELECT * FROM messages;
select * from company;
-- добавить еще один для обработки событий в "company_products_in"

-- *************************** Представления ***************************
-- расширенный обзор в удобочитаемом виде

CREATE OR REPLACE VIEW full_review AS
	SELECT 
		c.id, c.`name`, 
		o.ownership_type,
        a.activity_type,
		p.country,
        COUNT(p.country) AS in_country,
        p.city, 
		concat(p.street, ' ', p.building) AS street,
		p.email AS email, p.phone AS phone,
        (SELECT GROUP_CONCAT(`name` SEPARATOR ',') FROM products WHERE id IN 
			(SELECT in_products_id FROM company_products_in WHERE company_id = c.id)) AS sale,
		(SELECT GROUP_CONCAT(p.`name` SEPARATOR ',') FROM products AS p 
			JOIN company_products_out AS cpo ON p.id = out_products_id WHERE company_id = c.id) AS buy
		from company AS c 
		JOIN  ownership AS o ON c.ownership_id = o.id 
		JOIN `profiles` AS p ON c.profile_id = p.id
        JOIN activity AS a ON  a.id = c.activity_id 
		GROUP BY p.country;

-- обзор по одной стране - 'Romania'
CREATE OR REPLACE VIEW romania_review AS
	SELECT 
		c.id, c.`name`, 
		o.ownership_type,
		p.country, p.city, 
		concat(p.street, ' ', p.building) AS street,
		p.email AS email, p.phone AS phone
		from company AS c 
		JOIN  ownership AS o ON c.ownership_id = o.id 
		JOIN `profiles` AS p ON c.profile_id = p.id 
        WHERE country = 'Romania';

SELECT * FROM full_review;
select * from products;
SELECT * FROM company_products_in WHERE in_products_id = 6;
SELECT * FROM company_products_out WHERE out_products_id = 6;

SELECT * FROM company;
SELECT * FROM ownership; 
SELECT * FROM profiles; 
SELECT * FROM activity; 
SELECT * FROM romania_review;
-- ************************* ВЫборка по названию товара *************************
-- Найдем информацию по компаниям которые  добывают  'anuptanium' 

USE catalog;
DROP FUNCTION IF EXISTS informer;
DELIMITER //
CREATE FUNCTION informer(prod VARCHAR(255), bs ENUM('buyers','sellers'))
RETURNS text READS SQL DATA
BEGIN
	DECLARE id_pr int;
    SET id_pr = (SELECT id FROM products WHERE `name` = prod);
    IF bs = 'sellers' THEN -- Если нужно купить
		RETURN (SELECT  group_concat(c.`name`, CONCAT(' ',cpo.volume,' ',cpo.units) ) 
					FROM company_products_out AS cpo 
                    JOIN company AS c ON cpo.company_id = c.id 
                    WHERE out_products_id = id_pr);
	ELSEIF bs = 'buyers' THEN
		RETURN (SELECT  group_concat(c.`name`,CONCAT(' ',cpi.volume,' ',cpi.units)) 
					FROM company_products_in AS cpi 
                    JOIN company AS c ON cpi.company_id = c.id 
                    WHERE in_products_id = id_pr);
	END IF;
END//
DELIMITER ;

select informer('anuptanium','buyers');


-- *************************** Процедуры и транзакции ***************************
-- пожалуй этот ключ будет мешать
-- ALTER TABLE `profiles` DROP FOREIGN KEY fk_doc_img;
ALTER TABLE `profiles` CHANGE doc_img_id doc_img_id BIGINT UNSIGNED;
-- через процедуру собираем данные для двух таблиц и через транзакцию заносим
DELIMITER //
DROP PROCEDURE IF EXISTS new_company//
CREATE PROCEDURE 
	new_company(doc_img_id BIGINT, country VARCHAR(50), city VARCHAR(50), 
    street VARCHAR(50), building VARCHAR(9), office VARCHAR(10),
    email VARCHAR(50),phone VARCHAR(15),
    --
    `name` VARCHAR(125),user_id BIGINT,ownership_id BIGINT,activity_id BIGINT,
    status_id BIGINT,profit_$ DECIMAL,
    payback_period_month INT, investment DECIMAL)
    
BEGIN
	START TRANSACTION;
		INSERT INTO `profiles` VALUES 
			(DEFAULT,doc_img_id,country,city,street,building,office,email,phone);
		INSERT INTO `company` VALUES 
			(LAST_INSERT_ID(),`name`,user_id,ownership_id,activity_id,LAST_INSERT_ID(),status_id,profit_$,payback_period_month, NOW(),NOW(),investment);
	COMMIT;
END//
DELIMITER ;
-- смотрим сколько записей
use catalog;
SELECT * FROM company;
SELECT * FROM `profiles`;
-- добавляем 
CALL new_company(null,'Saudi Arabia','North Coralie','Jammie Track','94',
	'3508','salabadie.aracely@example.org','(407)481-100156',
    'Endominus',7,3,12,1,999,16, 9558573.00);
    
-- проверяем
SELECT 'company_last_insert_id',id FROM company 
UNION ALL
SELECT 'profiles_last_insert_id',id FROM `profiles` ORDER BY id DESC LIMIT 2;

DELETE FROM company WHERE id = LAST_INSERT_ID();
DELETE FROM `profiles` WHERE id = LAST_INSERT_ID();

-- *************************** Функции ***************************

/* Считаем рентабельность компаний */

DROP FUNCTION IF EXISTS func;
DELIMITER //
CREATE FUNCTION profitability (profit DECIMAL, invest DECIMAL) 
	RETURNS DECIMAL READS SQL DATA
    BEGIN
		RETURN profit / invest * 100;
	END//
DELIMITER ;

SELECT id, `name`, CONCAT(profitability(c.profit_$, c.investment),'%') AS profitability FROM company AS c;

/*
Не особо изощренный функционал. 
В процессе появлялось много идей но что бы их реализовать желательно наполнение осмысленными
данными. Да и задачи должны быть реальными - здесь в основном фантазии, да и времени особо нет.
*/