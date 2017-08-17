SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `visaScan`
--

-- --------------------------------------------------------

DROP TABLE IF EXISTS `Countries`;
DROP TABLE IF EXISTS `CountriesAliases`;

--
-- Table structure for table `Countries`
--

CREATE TABLE IF NOT EXISTS `Countries` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `country` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `link` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=212 ;

--
-- Dumping data for table `Countries`
--

INSERT INTO `Countries` (`id`, `country`, `link`) VALUES
(1, 'Angola', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Angolan_citizens'),
(2, 'Cameroon', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Cameroonian_citizens'),
(3, 'Central African Republic', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Central_African_Republic_citizens'),
(4, 'Chad', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Chadian_citizens'),
(5, 'Congo, Democratic Republic of', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Democratic_Republic_of_the_Congo_citizens'),
(6, 'Congo, Republic of', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Republic_of_the_Congo_citizens'),
(7, 'Equatorial Guinea', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Equatorial_Guinean_citizens'),
(8, 'Gabon', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Gabonese_citizens'),
(9, 'Sao Tome and Principe', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Santomean_citizens'),
(10, 'Burundi', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Burundian_citizens'),
(11, 'Comoros', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Comorian_citizens'),
(12, 'Djibouti', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Djiboutian_citizens'),
(13, 'Eritrea', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Eritrean_citizens'),
(14, 'Ethiopia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Ethiopian_citizens'),
(15, 'Kenya', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Kenyan_citizens'),
(16, 'Madagascar', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Malagasy_citizens'),
(17, 'Malawi', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Malawian_citizens'),
(18, 'Mauritius', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Mauritian_citizens'),
(19, 'Mozambique', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Mozambican_citizens'),
(20, 'Rwanda', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Rwandan_citizens'),
(21, 'Seychelles', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Seychellois_citizens'),
(22, 'Somalia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Somali_citizens'),
(23, 'South Sudan', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_South_Sudanese_citizens'),
(24, 'Tanzania', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Tanzanian_citizens'),
(25, 'Uganda', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Ugandan_citizens'),
(26, 'Zambia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Zambian_citizens'),
(27, 'Zimbabwe', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Zimbabwean_citizens'),
(28, 'Algeria', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Algerian_citizens'),
(29, 'Libya', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Libyan_citizens'),
(30, 'Morocco', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Moroccan_citizens'),
(31, 'Sudan', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Sudanese_citizens'),
(32, 'Tunisia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Tunisian_citizens'),
(33, 'Botswana', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Botswana_citizens'),
(34, 'Lesotho', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Lesotho_citizens'),
(35, 'Namibia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Namibian_citizens'),
(36, 'Saint Helena', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_British_Overseas_Territories_Citizens_of_Saint_Helena'),
(37, 'South Africa', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_South_African_citizens'),
(38, 'Swaziland', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Swazi_citizens'),
(39, 'Benin', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Beninese_citizens'),
(40, 'Burkina Faso', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Burkinabe_citizens'),
(41, 'Cape Verde', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Cape_Verdean_citizens'),
(42, 'Gambia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Gambian_citizens'),
(43, 'Ghana', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Ghanaian_citizens'),
(44, 'Guinea', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Guinean_citizens'),
(45, 'Guinea-Bissau', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Guinea-Bissauan_citizens'),
(46, 'Ivory Coast', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Ivorian_citizens'),
(47, 'Liberia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Liberian_citizens'),
(48, 'Mali', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Malian_citizens'),
(49, 'Mauritania', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Mauritanian_citizens'),
(50, 'Nigeria', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Nigerian_citizens'),
(51, 'Niger', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Nigerien_citizens'),
(52, 'Senegal', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Senegalese_citizens'),
(53, 'Sierra Leone', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Sierra_Leonean_citizens'),
(54, 'Togo', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Togolese_citizens'),
(55, 'Anguilla', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_British_Overseas_Territories_Citizens_of_Anguilla'),
(56, 'Antigua and Barbuda', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Antigua_and_Barbuda_citizens'),
(57, 'Bahamas', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Bahamian_citizens'),
(58, 'Barbados', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Barbadian_citizens'),
(59, 'British Virgin Islands', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_British_Overseas_Territories_Citizens_of_British_Virgin_Islands'),
(60, 'Cayman Islands', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_British_Overseas_Territories_Citizens_of_Cayman_Islands'),
(61, 'Cuba', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Cuban_citizens'),
(62, 'Dominica', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Dominica_citizens'),
(63, 'Dominican Republic', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Dominican_Republic_citizens'),
(64, 'Grenada', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Grenadian_citizens'),
(65, 'Haiti', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Haitian_citizens'),
(66, 'Jamaica', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Jamaican_citizens'),
(67, 'Montserrat', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_British_Overseas_Territories_Citizens_of_Montserrat'),
(68, 'Saint Kitts and Nevis', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Saint_Kitts_and_Nevis_citizens'),
(69, 'Saint Lucia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Saint_Lucian_citizens'),
(70, 'Saint Vincent and the Grenadines', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Saint_Vincent_and_the_Grenadines_citizens'),
(71, 'Trinidad and Tobago', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Trinidad_and_Tobago_citizens'),
(72, 'Turks and Caicos Islands', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_British_Overseas_Territories_Citizens_of_Turks_and_Caicos_Islands'),
(73, 'Belize', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Belizean_citizens'),
(74, 'Costa Rica', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Costa_Rican_citizens'),
(75, 'El Salvador', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_El_Salvador_citizens'),
(76, 'Guatemala', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Guatemalan_citizens'),
(77, 'Honduras', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Honduran_citizens'),
(78, 'Nicaragua', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Nicaraguan_citizens'),
(79, 'Panama', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Panamanian_citizens'),
(80, 'Bermuda', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_British_Overseas_Territories_Citizens_of_Bermuda'),
(81, 'Canada', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Canadian_citizens'),
(82, 'Mexico', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Mexican_citizens'),
(83, 'United States', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_United_States_citizens'),
(84, 'Argentina', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Argentine_citizens'),
(85, 'Bolivia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Bolivian_citizens'),
(86, 'Brazil', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Brazilian_citizens'),
(87, 'Chile', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Chilean_citizens'),
(88, 'Colombia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Colombian_citizens'),
(89, 'Ecuador', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Ecuadorian_citizens'),
(90, 'Guyana', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Guyanese_citizens'),
(91, 'Paraguay', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Paraguayan_citizens'),
(92, 'Peru', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Peruvian_citizens'),
(93, 'Suriname', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Surinamese_citizens'),
(94, 'Uruguay', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Uruguayan_citizens'),
(95, 'Venezuela', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Venezuelan_citizens'),
(96, 'Afghanistan', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Afghan_citizens'),
(97, 'Kazakhstan', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Kazakhstani_citizens'),
(98, 'Kyrgyzstan', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Kyrgyzstani_citizens'),
(99, 'Russia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Russian_citizens'),
(100, 'Tajikistan', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Tajik_citizens'),
(101, 'Turkmenistan', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Turkmen_citizens'),
(102, 'China', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Chinese_citizens'),
(103, 'Hong Kong', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Chinese_citizens_of_Hong_Kong'),
(104, 'Macau', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Chinese_citizens_of_Macau'),
(105, 'Japan', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Japanese_citizens'),
(106, 'North Korea', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_North_Korean_citizens'),
(107, 'South Korea', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_South_Korean_citizens'),
(108, 'Mongolia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Mongolian_citizens'),
(109, 'Taiwan', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Taiwanese_citizens'),
(110, 'Bangladesh', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Bangladeshi_citizens'),
(111, 'Bhutan', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Bhutanese_citizens'),
(112, 'India', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Indian_citizens'),
(113, 'Maldives', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Maldivian_citizens'),
(114, 'Nepal', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Nepalese_citizens'),
(115, 'Pakistan', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Pakistani_citizens'),
(116, 'Sri Lanka', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Sri_Lankan_citizens'),
(117, 'Brunei', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Bruneian_citizens'),
(118, 'Cambodia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Cambodian_citizens'),
(119, 'East Timor', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_East_Timorese_citizens'),
(120, 'Philippines', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Filipino_citizens'),
(121, 'Indonesia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Indonesian_citizens'),
(122, 'Laos', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Laotian_citizens'),
(123, 'Malaysia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Malaysian_citizens'),
(124, 'Myanmar', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Myanmar_citizens'),
(125, 'Singapore', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Singaporean_citizens'),
(126, 'Thailand', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Thai_citizens'),
(127, 'Vietnam', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Vietnamese_citizens'),
(129, 'Armenia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Armenian_citizens'),
(130, 'Azerbaijan', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Azerbaijani_citizens'),
(131, 'Bahrain', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Bahraini_citizens'),
(132, 'Egypt', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Egyptian_citizens'),
(133, 'United Arab Emirates', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Emirati_citizens'),
(134, 'Iran', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Iranian_citizens'),
(135, 'Iraq', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Iraqi_citizens'),
(136, 'Israel', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Israeli_citizens'),
(137, 'Jordan', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Jordanian_citizens'),
(138, 'Kuwait', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Kuwaiti_citizens'),
(139, 'Lebanon', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Lebanese_citizens'),
(142, 'Oman', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Omani_citizens'),
(143, 'Palestine', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Palestinian_citizens'),
(144, 'Qatar', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Qatari_citizens'),
(145, 'Saudi Arabia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Saudi_citizens'),
(147, 'Syria', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Syrian_citizens'),
(148, 'Turkey', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Turkish_citizens'),
(149, 'Yemen', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Yemeni_citizens'),
(150, 'Austria', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Austrian_citizens'),
(151, 'Belgium', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Belgian_citizens'),
(152, 'United Kingdom', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_British_citizens'),
(153, 'Bulgaria', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Bulgarian_citizens'),
(154, 'Croatia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Croatian_citizens'),
(155, 'Cyprus', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Cypriot_citizens'),
(156, 'Czech Republic', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Czech_citizens'),
(157, 'Denmark', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Danish_citizens'),
(158, 'Netherlands', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Dutch_citizens'),
(159, 'Estonia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Estonian_citizens'),
(160, 'Finland', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Finnish_citizens'),
(161, 'France', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_French_citizens'),
(162, 'Germany', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_German_citizens'),
(163, 'Greece', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Greek_citizens'),
(164, 'Hungary', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Hungarian_citizens'),
(165, 'Ireland', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Irish_citizens'),
(166, 'Italy', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Italian_citizens'),
(167, 'Latvia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Latvian_citizens'),
(168, 'Lithuania', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Lithuanian_citizens'),
(169, 'Luxembourg', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Luxembourgian_citizens'),
(170, 'Malta', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Maltese_citizens'),
(171, 'Poland', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Polish_citizens'),
(172, 'Portugal', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Portuguese_citizens'),
(173, 'Romania', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Romanian_citizens'),
(174, 'Slovakia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Slovak_citizens'),
(175, 'Slovenia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Slovenian_citizens'),
(176, 'Spain', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Spanish_citizens'),
(177, 'Sweden', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Swedish_citizens'),
(178, 'Albania', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Albanian_citizens'),
(179, 'Andorra', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Andorran_citizens'),
(180, 'Belarus', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Belarusian_citizens'),
(181, 'Bosnia and Herzegovina', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Bosnia_and_Herzegovina_citizens'),
(182, 'Georgia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Georgian_citizens'),
(183, 'Gibraltar', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_British_Overseas_Territories_Citizens_of_Gibraltar'),
(184, 'Iceland', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Icelandic_citizens'),
(185, 'Kosovo', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Kosovan_citizens'),
(186, 'Liechtenstein', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Liechtenstein_citizens'),
(187, 'Macedonia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Macedonian_citizens'),
(188, 'Moldova', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Moldovan_citizens'),
(189, 'Monaco', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Mon%C3%A9gasque_citizens'),
(190, 'Montenegro', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Montenegrin_citizens'),
(191, 'Norway', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Norwegian_citizens'),
(192, 'San Marino', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_San_Marino_citizens'),
(193, 'Serbia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Serbian_citizens'),
(194, 'Switzerland', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Swiss_citizens'),
(195, 'Ukraine', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Ukrainian_citizens'),
(196, 'Vatican City', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Vatican_citizens'),
(197, 'Australia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Australian_citizens'),
(198, 'Fiji', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Fijian_citizens'),
(199, 'Kiribati', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Kiribati_citizens'),
(200, 'Marshall Islands', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Marshall_Islands_citizens'),
(201, 'Micronesia', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Micronesian_citizens'),
(202, 'Nauru', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Nauruan_citizens'),
(203, 'New Zealand', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_New_Zealand_citizens'),
(204, 'Palau', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Palauan_citizens'),
(205, 'Papua New Guinea', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Papua_New_Guinean_citizens'),
(206, 'Samoa', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Samoan_citizens'),
(207, 'Solomon Islands', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Solomon_Islands_citizens'),
(208, 'Tonga', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Tongan_citizens'),
(209, 'Tuvalu', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Tuvaluan_citizens'),
(210, 'Vanuatu', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Vanuatuan_citizens'),
(211, 'Uzbekistan', 'https://en.m.wikipedia.org/wiki/Visa_requirements_for_Uzbekistani_citizens');

-- --------------------------------------------------------

--
-- Table structure for table `CountriesAliases`
--

CREATE TABLE IF NOT EXISTS `CountriesAliases` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `countryId` int(12) NOT NULL,
  `alias` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=9 ;

--
-- Dumping data for table `CountriesAliases`
--

INSERT INTO `CountriesAliases` (`id`, `countryId`, `alias`) VALUES
(1, 102, 'People%27s Republic of China'),
(2, 6, 'Republic of the Congo'),
(3, 5, 'Democratic Republic of the Congo'),
(4, 46, 'C%C3%B4te d%27Ivoire'),
(5, 42, 'The Gambia'),
(6, 201, 'Federated States of Micronesia'),
(7, 102, 'Republic of China'),
(8, 203, 'Niue');

-- --------------------------------------------------------

--
-- Table structure for table `VisaInfo`
--

CREATE TABLE IF NOT EXISTS `VisaInfo` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `countryFromId` int(12) NOT NULL,
  `countryToId` int(12) NOT NULL,
  `visaInfo` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `additionalInfo` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
