.mode column
PRAGMA foreign_keys = ON; -- activates foreign key features in sqlite. It is disabled by default

create table races (
    race_id varchar(50) primary key,
    race_name varchar(100));
    
create table challenges (
    challenge_id varchar(50) primary key,
    challenge_name varchar(100));

create table challenge_race (
    race_id varchar(50),
    challenge_id integer,
    year YEAR,
    FOREIGN KEY (race_id) REFERENCES races(race_id) -- CLIENTNUMBER is the foreign key from Clients table.
    );
    
create table runners (
    runner_id integer auto_increment,
    race_id varchar(50), 
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100),
    sex varchar(10),
    running_time TIME,
    finished boolean,
    PRIMARY KEY (runner_id, race_id),
    FOREIGN KEY (race_id) REFERENCES races(race_id));
    

insert into races values ("ruby", "The Ruby marathon");
insert into races values ("bridge", "The bridge challenge");
insert into races values ("sea_mount", "The sea to mountain sprint");
insert into races values ("flat_fast", "Flat and fast marathon");
insert into races values ("wine", "The wine route stroll");

insert into challenges values ("mara", "Marathon challenge");
insert into challenges values ("terra", "Terrain challenge");

insert into challenge_race values ("ruby", "mara", 2019);
insert into challenge_race values ("ruby", "terra", 2019);
insert into challenge_race values ("flat_fast", "mara", 2019);
insert into challenge_race values ("sea_mount", "terra", 2019);
insert into challenge_race values ("bridge", "terra", 2019);

insert into runners values (null, "ruby", "jackie","trang","@1", "F", "01:00:00", 1 );
insert into runners values (null, "ruby", "mark", "zuck", "@2", "M", "01:13:00", 1);
insert into runners values (null, "ruby", "jeff", "bezos", "@3", "M", "01:13:40", 0);
insert into runners values (null, "ruby", "marilyn", "monroe", "@23","F", "00:59:00", 1);
insert into runners values (null, "ruby", "bobby", "fun", "@4", "F", "02:13:00", 1);
insert into runners values (null, "ruby", "warran", "buffet", "@5", "M", "01:45:00", 1);
insert into runners values (null, "ruby", "black", "pink", "@6", "F", "01:04:50", 1);
insert into runners values (null, "flat_fast", "bun", "zun", "@7", "F", "00:20:00", 1);
insert into runners values (null, "flat_fast", "ben", "li", "@8", "M", "00:23:00", 1);
insert into runners values (null, "flat_fast", "elizabeth", "queen","@9", "F", "00:43:00", 1);
insert into runners values (null, "sea_mount", "angelina", "jolie", "@10", "F", "02:05:07", 1);
insert into runners values (null, "sea_mount", "robin", "kellog", "@11", "F", "02:13:00", 0);
insert into runners values (null, "sea_mount", "Olive", "oily", "@12", "F", "01:18:00", 1);
insert into runners values (null, "sea_mount", "amelia", "rose", "@13", "F", "03:13:00", 1);
insert into runners values (null, "sea_mount", "markoe", "unc", "@14", "M", "03:43:00", 1);
insert into runners values (null, "bridge", "mark", "zuck", "@2", "M", "01:13:00", 1);
insert into runners values (null, "bridge", "charlotte", "wine", "@16", "F", "00:24:00", 1);
insert into runners values (null, "bridge", "simson", "lee", "@17", "M", "00:16:00", 1);
insert into runners values (null, "bridge", "mia", "nguyen", "@18", "F", "00:34:00", 1);
insert into runners values (null, "bridge", "binh", "boong", "@19", "F", "00:45:50", 1);
insert into runners values (null, "wine", "diem", "ta", "@20", "F", "03:23:00", 1);
insert into runners values (null, "wine", "bobby", "lig", "@21", "M", "03:13:00", 0);
insert into runners values (null, "wine", "mark", "ilk", "@22", "M", "04:13:00", 1);

select("Races table");
select * from races;
select("Challenges table");
select * from challenges;
select("Challenge-race table");
select * from challenge_race;

select("Runners table");
select * from runners;

select("Write a SQL query to find the top 3 fastest women runners for a given race.");

select * from runners
    where sex == "F" and finished = 1 and race_id = "ruby"
    order BY running_time ASC limit 3;

select * from runners
    where sex == "F" and finished = 1 and race_id = "flat_fast"
    order BY running_time ASC limit 3;
    
select * from runners
    where sex == "F" and finished = 1 and race_id = "bridge"
    order BY running_time ASC limit 3;
    
select * from runners
    where sex == "F" and finished = 1 and race_id = "wine"
    order BY running_time ASC limit 3;

select("Write a SQL query to find all the runners' email addresses that successfully finished the marathon challenge.");
select runner_id, first_name, last_name, email, runners.race_id, challenge_id, year from runners
    join challenge_race on runners.race_id = challenge_race.race_id
    where finished =1;






