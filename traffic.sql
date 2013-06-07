drop table if exists traffic.traffic;
create table traffic.traffic (
	`id` integer auto_increment not null primary key,
	`timestamp` datetime not null,
	`from` varchar(200) not null,
	`to` varchar(200) not null,
	`route` varchar(200) not null,
	`time` integer not null
);
