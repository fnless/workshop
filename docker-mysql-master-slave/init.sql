create database mydb;
use mydb;
CREATE TABLE `student`(
    `id` INT AUTO_INCREMENT,
    `name` varchar(10) NOT NULL DEFAULT '',
    `age` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
)charset=utf8mb4;

CREATE TABLE `course`(
    `id` INT AUTO_INCREMENT,
    `name` varchar(20) NOT NULL DEFAULT '',
    `credit` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
)charset=utf8mb4;

CREATE TABLE `sc` (
    `id` INT AUTO_INCREMENT,
    `student_id` INT NOT NULL,
    `course_id` INT NOT NULL,
    `grade` INT NOT NULL,
    PRIMARY KEY (`id`)
);

insert student (name,age) values ("you", 20);
insert course (name,credit) values ("Math", 3);
insert sc (student_id, course_id, grade) values (1, 1, 90);
