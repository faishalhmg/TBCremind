-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 08, 2023 at 12:32 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tbc_remind`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth`
--

CREATE TABLE `auth` (
  `id` int(255) NOT NULL,
  `email` varchar(50) NOT NULL,
  `nik` int(20) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth`
--

INSERT INTO `auth` (`id`, `email`, `nik`, `password`) VALUES
(1, 'faishalhmg@yahoo.co.id', 1917051065, 'b1ea29596227c836f0e497f069df3f68');

-- --------------------------------------------------------

--
-- Table structure for table `data_keluarga`
--

CREATE TABLE `data_keluarga` (
  `id` int(255) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `usia` int(3) NOT NULL,
  `riwayat` varchar(100) DEFAULT NULL,
  `jenis` varchar(50) NOT NULL,
  `id_pasien` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `data_keluarga`
--

INSERT INTO `data_keluarga` (`id`, `nama`, `usia`, `riwayat`, `jenis`, `id_pasien`) VALUES
(1, 'Desy', 55, 'tidak ada', 'ibu', 1),
(2, 'farid', 57, 'tidak ada', 'ayah', 1),
(5, 'mama', 54, 'tidak ada', 'ibu', 6);

-- --------------------------------------------------------

--
-- Table structure for table `edukasi`
--

CREATE TABLE `edukasi` (
  `id` int(255) NOT NULL,
  `judul` varchar(100) NOT NULL,
  `isi` mediumtext NOT NULL,
  `media` varchar(300) NOT NULL,
  `created_by` int(255) NOT NULL,
  `created_at` int(11) NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `edukasi`
--

INSERT INTO `edukasi` (`id`, `judul`, `isi`, `media`, `created_by`, `created_at`, `update_at`) VALUES
(3, 'contoh', 'sebuah contoh', 'Untitled video - Made with Clipchamp (2).gif', 1, 2147483647, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `efekobat`
--

CREATE TABLE `efekobat` (
  `id` int(255) NOT NULL,
  `awal` date NOT NULL,
  `akhir` date NOT NULL,
  `lupa` varchar(255) DEFAULT NULL,
  `efeksamping` varchar(300) DEFAULT NULL,
  `judul` varchar(100) NOT NULL,
  `id_pasien` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hasil_kuis`
--

CREATE TABLE `hasil_kuis` (
  `id` int(255) NOT NULL,
  `id_pasien` int(255) NOT NULL,
  `hasil` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kader`
--

CREATE TABLE `kader` (
  `id` int(11) NOT NULL,
  `nip` int(20) NOT NULL,
  `email` int(50) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `jk` varchar(12) DEFAULT NULL,
  `alamat` varchar(300) DEFAULT NULL,
  `usia` int(3) DEFAULT NULL,
  `no_hp` int(15) DEFAULT NULL,
  `goldar` varchar(2) DEFAULT NULL,
  `posisi` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kuis`
--

CREATE TABLE `kuis` (
  `id` int(255) NOT NULL,
  `pertanyaan` varchar(255) NOT NULL,
  `jawaban_baik` varchar(255) NOT NULL,
  `jawaban_buruk` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pasien`
--

CREATE TABLE `pasien` (
  `id` int(11) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `nik` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `alamat` varchar(300) DEFAULT NULL,
  `usia` int(3) DEFAULT NULL,
  `no_hp` int(15) DEFAULT NULL,
  `goldar` varchar(2) DEFAULT NULL,
  `bb` varchar(8) DEFAULT NULL,
  `kaderTB` varchar(50) DEFAULT NULL,
  `pmo` varchar(50) DEFAULT NULL,
  `pet_kesehatan` varchar(50) DEFAULT NULL,
  `jk` varchar(12) NOT NULL,
  `Created_at` int(11) NOT NULL DEFAULT current_timestamp(),
  `Update_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pasien`
--

INSERT INTO `pasien` (`id`, `nama`, `username`, `email`, `nik`, `password`, `alamat`, `usia`, `no_hp`, `goldar`, `bb`, `kaderTB`, `pmo`, `pet_kesehatan`, `jk`, `Created_at`, `Update_at`) VALUES
(1, 'faishal', '', 'faishalhmg@yahoo.co.id', '1917051065', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 2147483647, NULL),
(6, 'Faishal Hariz Makaarim Gandadipoera', 'faishal', 'faishalhmg00@gmail.com', '3674040607010011', '$2y$10$86OhI3JUmZiCezFM9i2VweoNai3WKn5y7rnVTpvm4n0IqGDkhzHgi', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 2147483647, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pengambilan_obat`
--

CREATE TABLE `pengambilan_obat` (
  `id` int(255) NOT NULL,
  `awal` date NOT NULL,
  `ambil` date NOT NULL,
  `lokasi` varchar(255) NOT NULL,
  `id_pasien` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pengingat_obat`
--

CREATE TABLE `pengingat_obat` (
  `id` int(255) NOT NULL,
  `judul` varchar(255) NOT NULL,
  `hari` varchar(255) NOT NULL,
  `waktu` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_pasien` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `periksa_dahak`
--

CREATE TABLE `periksa_dahak` (
  `id` int(255) NOT NULL,
  `sebelumnya` date NOT NULL,
  `selanjutnya` date NOT NULL,
  `lokasi_periksa` varchar(255) NOT NULL,
  `id_pasien` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `petugas`
--

CREATE TABLE `petugas` (
  `id` int(11) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `nik` int(20) NOT NULL,
  `jk` varchar(12) DEFAULT NULL,
  `alamat` varchar(50) DEFAULT NULL,
  `usia` int(3) DEFAULT NULL,
  `no_hp` int(15) DEFAULT NULL,
  `goldar` int(2) DEFAULT NULL,
  `posisi` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `token`
--

CREATE TABLE `token` (
  `id` int(11) NOT NULL,
  `token` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `token`
--

INSERT INTO `token` (`id`, `token`) VALUES
(1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImZhaXNoYWxobWdAeWFob28uY28uaWQiLCJpYXQiOjE2ODMzMzY4ODUsImV4cCI6MTY4MzM0MDQ4NX0.DvMSNWef4SKTfCSCuFSOKEkBd0tBZb9cmDbp8PdtmTQ');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth`
--
ALTER TABLE `auth`
  ADD PRIMARY KEY (`id`),
  ADD KEY `email_pasien` (`email`),
  ADD KEY `nik_pasien` (`nik`);

--
-- Indexes for table `data_keluarga`
--
ALTER TABLE `data_keluarga`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_pasien` (`id_pasien`);

--
-- Indexes for table `edukasi`
--
ALTER TABLE `edukasi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `efekobat`
--
ALTER TABLE `efekobat`
  ADD UNIQUE KEY `id_pasien` (`id_pasien`);

--
-- Indexes for table `hasil_kuis`
--
ALTER TABLE `hasil_kuis`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kader`
--
ALTER TABLE `kader`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kuis`
--
ALTER TABLE `kuis`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pasien`
--
ALTER TABLE `pasien`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `pengambilan_obat`
--
ALTER TABLE `pengambilan_obat`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pengingat_obat`
--
ALTER TABLE `pengingat_obat`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `periksa_dahak`
--
ALTER TABLE `periksa_dahak`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `petugas`
--
ALTER TABLE `petugas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `nik` (`nik`);

--
-- Indexes for table `token`
--
ALTER TABLE `token`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth`
--
ALTER TABLE `auth`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `data_keluarga`
--
ALTER TABLE `data_keluarga`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `edukasi`
--
ALTER TABLE `edukasi`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `hasil_kuis`
--
ALTER TABLE `hasil_kuis`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kader`
--
ALTER TABLE `kader`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kuis`
--
ALTER TABLE `kuis`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pasien`
--
ALTER TABLE `pasien`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `pengambilan_obat`
--
ALTER TABLE `pengambilan_obat`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pengingat_obat`
--
ALTER TABLE `pengingat_obat`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `periksa_dahak`
--
ALTER TABLE `periksa_dahak`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `petugas`
--
ALTER TABLE `petugas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `token`
--
ALTER TABLE `token`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth`
--
ALTER TABLE `auth`
  ADD CONSTRAINT `email_pasien` FOREIGN KEY (`email`) REFERENCES `pasien` (`email`) ON UPDATE CASCADE;

--
-- Constraints for table `data_keluarga`
--
ALTER TABLE `data_keluarga`
  ADD CONSTRAINT `data_keluarga_ibfk_1` FOREIGN KEY (`id_pasien`) REFERENCES `pasien` (`id`);

--
-- Constraints for table `efekobat`
--
ALTER TABLE `efekobat`
  ADD CONSTRAINT `efekobat_ibfk_1` FOREIGN KEY (`id_pasien`) REFERENCES `pasien` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
