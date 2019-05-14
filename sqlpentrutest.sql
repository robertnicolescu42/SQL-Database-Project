create database dbpregatirepentrutest

use dbpregatirepentrutest

-- Crearea de tabele

create table books
(
book_id int constraint pk_bookid primary key,
book_author varchar(30) not null,
book_pubdate varchar(20) not null,
book_isbn varchar(15) not null,
book_stock int
)

create table users
(
user_id int constraint pk_userid primary key,
user_name varchar(30) not null
)

create table adresses
(
user_id int not null constraint fk_userid references users(user_id),
adr_street varchar(40) not null
)

create table reviews
(
review_id int not null constraint pk_reviewid primary key,
user_id int not null,
book_id int not null,
review_desc varchar(255) not null,
published_date varchar(20) not null
)

alter table reviews add foreign key(user_id) references users(user_id)
alter table reviews add foreign key(book_id) references books(book_id)

create table bookRatings
(
book_id int not null,
review_id int not null,
rating_number int not null
)

alter table bookRatings add foreign key(book_id) references books(book_id)
alter table bookRatings add foreign key(review_id) references reviews(review_id)

-- ALTER
-- se adauga o coloana in tabelul adresses si books
alter table adresses
add adr_city varchar(40) not null

alter table books
add book_title varchar(100) not null

--INSERT
insert into users (user_id,user_name)
values(1, 'Nicolescu Robert'),
      (2, 'Popescu Ion'),
	  (3, 'Laura Bogza'),
	  (4, 'Alin Ghica'),
	  (5, 'Zoe Trahanache')

insert into adresses(user_id,adr_street,adr_city)
values(1, 'Aleea Voinicilor', 'Pitesti'),
	  (2, 'Pasaj Scarilor', 'Pitesti'),
	  (3, 'Aleea Teilor', 'Pitesti'),
	  (4, 'Strada Banat', 'Pitesti'),
	  (5, 'Strada Postei', 'Mioveni')
	 
insert into books(book_id, book_title, book_author, book_pubdate, book_isbn)
values (1, 'Plansul lui Nietzsche', 'Irvin Yalom', '1992-07-03', 9788522008278),
	   (2, 'Pur si simplu despre muzica', 'Haruki Murakami', '2018-03-06' , 9789734675531),
	   (3, 'Caderea in timp', 'Emil Cioran', '1964-05-04', 9788476682050),
	   (4, 'Amintiri din copilarie', 'Ion Creanga', '1892-02-11', 9786065112476),
	   (5, 'Colt Alb', 'Jack London', '1906-05-05', 9780615844688),
	   (6, 'Sacrul si profanul', 'Mircea Eliade', '1959-04-06', 9788361182160),
	   (7, 'Efemeride', 'Irvin Yalom', '2015-02-02', 9786068642208),
	   (8, 'Un studiu in rosu', 'Arthur Conan Doyle', '1888-07-10', 9783036991276),
	   (9, 'Semnul celor patru', 'Arthur Conan Doyle', '1890-02-09', 9781511934343),
	   (10, 'Aventurile lui Sherlock Holmes', 'Arthur Conan Doyle', '1892-01-03', 9781731172853)

insert into reviews(review_id, reviews.user_id, book_id, review_desc, published_date)
values
	(1,1,1,'Mauris consequat tristique dui, at auctor justo lobortis eget. Mauris mollis ultrices lacus, sit amet venenatis erat.', '2018-04-01'),
	(2,1,2,'Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Pellentesque aliquam tortor vitae nunc efficitur.', '2018-04-01'),
	(3,1,3,'Duis dapibus malesuada lobortis. Curabitur sollicitudin nec quam sed dignissim.', '2018-03-12'),
	(4,3,1,'Quisque pharetra tristique odio, in lacinia mi laoreet at.', '2017-12-20'),
	(5,4,9,'Araesent pharetra augue nulla, maximus maximus est laoreet eu.', '2018-02-15')

insert into bookRatings(review_id, book_id, rating_number)
values (1,1,0),
	   (2,2,0),
	   (3,3,0),
	   (4,1,0),
	   (5,8,0)

--populez tabelul bookRatings cu note random pentru fiecare carte
update bookRatings
set rating_number = abs(checksum(NewId())%100)

--setez numere random pentru stocul de carti
update books 
set book_stock = abs(checksum(NewId())%100)

--Sa se afiseze toate cartile disponibile in librarie si autorul lor

select book_title as [Titlul cartii], book_author as [Autor]
from books

--Sa se afiseze o lista cu toti userii inregistrati pe site

select user_id, user_name as [Username]
from users

--Sa se afiseze cartea cu cele mai multe copii in stocul librariei

select TOP 1 book_id, book_title as [Titlul cartii],
	         book_stock as [Nr. carti]
from books
order by book_stock DESC

--sa se numere cate carti sunt in total in catalogul librariei --

select count(*) from books

--Sa se afiseze titlul fiecarei carti si ISBN-ul acesteia

select book_id, book_title as [Titlul cartii],
	   book_isbn as [ISBN]
from books

--Sa se creeze schema librarie

create schema librarie

--sa se adauge schemei librarie tabelele de pana acum

alter schema librarie transfer adresses
alter schema librarie transfer bookRatings
alter schema librarie transfer books
alter schema librarie transfer reviews
alter schema librarie transfer users

--sa se creeze sinonime

create synonym books for librarie.books
create synonym users for librarie.users
create synonym bookRatings for librarie.bookRatings
create synonym reviews for librarie.reviews
create synonym adresses for librarie.adresses

--sa se adauge in tabelul books coloana "recomandata"
--care marcheaza daca acea carte este recomandata de librarie
--si va contine DA sau NU

alter table librarie.books
add recomandata varchar(3) constraint ckrecomandata check(recomandata in ('DA', 'NU'))

--sa se declare toate cartile ca si recomandate

update books
set recomandata = 'DA'

update books
set recomandata = 'NU'
where book_id in (3,4,5,6)

--sa se afiseze id-ul, autorul, titlul cartilor recomandate

select book_id, book_author, book_title, recomandata
from books
where recomandata = 'DA'

--sa se afiseze cartile aparute inainte de 1950

select book_id, book_title, book_author, book_pubdate
from books
where substring(book_pubdate, 1, 4) < 1950

--sau

select book_id, book_title, book_author, book_pubdate
from books
where book_pubdate< '1950-01-01'

--sa se afiseze cartile aparute in secolul 21

select * from books
	where book_pubdate > '2001-01-01'

--sa se afiseze cartile aparute in anii 1900

select * from books
	where book_pubdate > '1899-12-31' and book_pubdate < '2000-01-01'

--sa se afiseze username-ul si adresa fiecarui utilizator

select A.user_id, user_name, adr_city, adr_street
from adresses as A inner join users as B on A.user_id = B.user_id

--sa se afiseze utilizatorii care nu locuiesc in pitesti

select A.user_id, user_name, adr_city
from adresses as A inner join users as B on A.user_id = B.user_id
where adr_city != 'Pitesti'
order by user_id

--sa se afiseze utilizatorii care locuiesc in Pitesti --

select users.user_id, user_name as [Nume si prenume], adr_city as [Orasul]
from adresses, users
where adr_city = 'Pitesti'
group by user_name, users.user_id, adr_city

--sa se afiseze cartile aparute in luna curenta (aceeasi luna de lansare)

select book_id, book_title, book_author, book_pubdate
from books
where month(book_pubdate) = month(getdate())

--sa se afiseze cartile ale caror nume incepe cu litera 'P'

select book_id, book_title, book_author
from books
where book_title like 'P%'

--sa se afiseze cartile ale caror nume incepe cu litera 'P' sau 'C'

select book_id, book_title, book_author
from books
where book_title like '[PC]%'

--sa se afiseze cartile ale caror nume se termina cu 'e'

select book_id, book_title, book_author
from books
where book_title like '%e'

--sa se afiseze cartile ale caror nume nu se termina cu 'a' sau cu 'b'

select book_id, book_title, book_author
from books
where book_title not like '%[ab]'

--sa se afiseze autorii ale caror prenume incepe cu una din literele : 'A,B,C,D,E,F,G'

select book_author
from books
where substring(book_author,1,1) like '[A-G]'

--sa se afiseze cele mai recente doua review-uri

select top 2 * 
from reviews
order by published_date desc

--sa se afiseze review-urile postate de utilizatori si detalii despre cartea respectiva

select B.review_id, A.user_id, user_name as [Nume], book_title as [Titlul cartii],
	review_desc as [Continut]
		from users as A inner join reviews as B on A.user_id = B.user_id 
		inner join books as C on B.book_id = C.book_id

--sa se afiseze numarul de review-uri la fiecare carte in ordine descrescatoare

select A.book_title, count(B.review_id) as [Nr. Review-uri]
from books as A
inner join reviews as B on A.book_id=B.book_id
group by A.book_title
order by [Nr. Review-uri] DESC

--sa se afiseze numarul de carti recomandate in stoc

select sum(book_stock) as [Nr. carti in stoc (total)]
from books
where recomandata = 'DA'

--sa se afiseze autorii care au mai mult de o carte in catalogul librariei,
--si numarul de carti pe care il au

select book_author as [Autor], count(book_id) as [Nr. de Carti]
	from books
	group by book_author
	having count(book_id)>1
	order by [Nr. de Carti]

--sa se afiseze autorul care are cele mai multe review-uri
select TOP 1  book_author, count(A.book_id) as [Nr. review-uri]
from reviews as A inner join books as B on A.book_id=B.book_id
group by book_author
order by [Nr. review-uri] DESC

--sa se afiseze mediile ratingurilor

select A.review_id, avg(rating_number) as [Medie]
from reviews as A inner join bookRatings as B on A.review_id = B.review_id
group by A.review_id
order by [Medie] DESC

--sa se afiseze autorul cu cea mai mare medie a review-urilor cartilor sale

select book_author, X.Medie
from 
	(select TOP 1 book_id, avg(rating_number) as [Medie]
	from bookRatings
	group by book_id
	order by Medie DESC) as X
inner join books as A on X.book_id = A.book_id
group by A.book_author, X.Medie

--sa se afiseze cartile care nu au review-uri

select A.book_id, A.book_title, A.book_author
from books as A
			left join (
				select A.book_id, book_title, book_author
				from books as A inner join reviews as B on A.book_id = B.book_id
			) as B on A.book_id = B.book_id
where B.book_id is null

--sa se afiseze numarul maxim de carti din stoc

select max(book_stock)
from books

--sa se afiseze numarul minim de carti din stoc

select min(book_stock)
from books

--sa se afiseze media numarului de carti din stoc

select avg(book_stock)
from books

--sa se afle numarul de autori din librarie

select count(distinct (book_author))
from books

-- sa se afiseze cate review-uri are fiecare utilizator
select A.user_id, user_name, count(A.review_id) as [Nr.Review-uri]
from reviews as A inner join reviews as B on A.review_id = B.review_id inner join users as C on B.user_id = C.user_id
group by A.user_id, user_name

--sa se afiseze numele cartii, media ratingului pentru cele care au un rating

select A.book_title, avg(rating_number) as [Medie]
from books as A inner join bookRatings as B on A.book_id = B.book_id
group by A.book_title

--sa se afiseze cartile care au un rating mai mare decat media ratingului generala

select book_title, avg(rating_number) as [media]
from books as A inner join bookRatings as B on A.book_id = B.book_id
group by A.book_id, book_title, B.rating_number
having rating_number > (select avg(rating_number) as [media]
						from bookRatings)


--TABELE PIVOT--
--sa se afiseze cate review-uri au fost postate in fiecare luna de fiecare utilizator

--creez un view vNrReviews ca sa-mi fie mai simplu sa lucrez cu el in pivot

create view vNrReviews
as
select A.user_id, user_name, count(A.review_id) as [Nr.Review-uri]
from reviews as A inner join reviews as B on A.review_id = B.review_id inner join users as C on B.user_id = C.user_id
group by A.user_id, user_name

--fara pivot:

select A.user_id,
	book_id,
	A.user_name, 
	DATENAME(MONTH, published_date) as [Month],
	review_desc,
	[Nr.Review-uri]
from users as A inner join reviews as B on A.user_id = B.user_id inner join vNrReviews as C on B.user_id = C.user_id
group by A.user_id, book_id, A.user_name, review_desc, DATENAME(MONTH, published_date), [Nr.Review-uri]

--cu pivot:

select user_id, user_name, [February], [March], [April], [December]
from 
(	select A.user_id,
	book_id,
	A.user_name, 
	DATENAME(MONTH, published_date) as [Month],
	review_desc,
	B.review_id
from users as A inner join reviews as B on A.user_id = B.user_id inner join vNrReviews as C on B.user_id = C.user_id
group by A.user_id, B.review_id, book_id, A.user_name, review_desc, DATENAME(MONTH, published_date), [Nr.Review-uri]
) as SRC	
pivot
(	
	count(review_id) for [Month] in ([January], [February], [March], [April], [May], [June], [July], [August], [September], [October], [November], [December])
) as PVT

--alt exemplu care nu se leaga cu tabelele deja existente

create table sales
(	customer_id int not null,
	sales_date varchar(20) not null,
	sales_amount int
)

insert into sales
values
	(1, '2018-01-09', 245),
	(1, '2018-02-05', 239),
	(1, '2018-03-12', 500),
	(1, '2018-04-09', 631),

	(2, '2018-01-09', 122),
	(2, '2018-02-09', 23),
	(2, '2018-03-09', 324),

	(3, '2018-01-09', 155),
	(3, '2018-02-09', 257),
	(3, '2018-03-09', 385),
	(3, '2018-04-09', 980),

	(4, '2018-01-09', 312),
	(4, '2018-02-09', 345),

	(5, '2018-01-09', 753),
	(5, '2018-02-09', 859)

select * from sales

--sa se selecteze vanzarile per customer pe fiecare luna

--fara pivot

select customer_id, datename(month, sales_date) as [Month], sum(sales_amount) as Total
from sales
group by customer_id, datename(month, sales_date)

--cu pivot

select customer_id, [January], [February], [March], [April]
from
(
	select customer_id, datename(month, sales_date) as [Month], sales_amount
	from sales
) as SRC
pivot
( 
	sum(sales_amount)
	for [Month] in ([January], [February], [March], [April])
) as PVT