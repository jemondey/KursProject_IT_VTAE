-- Пользователи
create table users (
	user_id serial primary key,
	email varchar(50) unique, 
	password varchar(255) not null,
	balance numeric(10,2) not null default 0 check (balance>=0),
	role varchar(20) check (role in('Клиент', 'Модератор', 'Администратор')) default 'Клиент',
	blocked boolean default false,
	avatar_url varchar(255),
	created_at timestamp not null default now()
);

--Игры
create table games(
	game_id serial primary key,
	title varchar(200) not null,
	description text, 
	price numeric(10,2) not null check (price>=0),
	date_of_release date,
	developer varchar(100),
	publisher varchar(100),
	cover_url varchar(255),
	published boolean default false 
);


-- Жанры
create table genres(
	genre_id serial primary key,
	name varchar(30) unique not null
);


-- Связь игры и жанров
create table game_genres(
	game_id int references games(game_id) on delete cascade,
	genre_id int references genres(genre_id) on delete cascade,
	primary key (game_id, genre_id)
);


-- Корзина
create table cart_items(
	cart_id serial primary key,
	user_id int references users(user_id) on delete cascade,
	game_id int references games(game_id) on delete cascade,
	price_at_add numeric(10,2) not null,
	added_at timestamp default now(),
	unique (user_id, game_id)
);



-- Вишлист
create table wishlist(
	wishlist_id serial primary key,
	user_id int references users(user_id) on delete cascade,
	game_id int references games(game_id) on delete cascade,
	added_at timestamp default now(),
	unique(user_id, game_id)
);


-- Заказ
create table orders(
	order_id serial primary key,
	user_id int references users(user_id) on delete cascade,
	total_amount numeric(10,2) not null check (total_amount >= 0),
	status varchar(20) check (status in ('Оплачен', 'Ожидает', 'Отменен')) default 'Ожидает',
	created_at timestamp default now()
);


-- Подробности заказа
create table order_items(
	order_item_id serial primary key,
	order_id int references orders(order_id) on delete cascade,
	game_id int references games(game_id) on delete cascade,
	price numeric(10,2) not null check (price >= 0)
);


-- Библиотека
create table library_items(
	library_item_id serial primary key,
	user_id int references users(user_id) on delete cascade,
	game_id int references games(game_id) on delete cascade,
	purchased_at timestamp default now(),
	play_time_minutes int default 0 check(play_time_minutes >=0),
	last_launch_at timestamp,
	unique(user_id, game_id)
);


-- Отзывы
create table reviews(
	reviews_id serial primary key,
	user_id int references users(user_id) on delete cascade,
	game_id int references games(game_id) on delete cascade,
	text_content text not null,
	recommended boolean not null,
	created_at timestamp default now(),
	unique (user_id, game_id)
);


-- Скриншоты
create table screenshots(
	screenshot_id serial primary key,
	game_id int references games(game_id) on delete cascade,
	image_url varchar(255) not null,
	created_at timestamp default now()
);


insert into genres (name) values ('Стратегия'), ('Экшен'), ('Инди'), ('Хоррор'), ('RPG');
select * from genres;


insert into users (email, password, role) values ('admin123@gmail.com','admin123','Администратор'), 
('client123@gmail.com','client123','Клиент');
select * from users;


insert into games (title, description, price, date_of_release, developer, publisher, cover_url, published) VALUES 
('Cyberpunk 2077', 'Ролевая игра в открытом мире', 1999.00, '2020-12-10', 'CD Projekt RED', 'CD Projekt', 'https://example.com/cyberpunk.jpg', TRUE);
select * from games;


insert into game_genres (game_id, genre_id) values (1,5);
select * from game_genres;

insert into cart_items (user_id, game_id, price_at_add) values (2,1,1999);
select * from cart_items;

insert into wishlist(user_id, game_id) values (1,1);
select * from wishlist;