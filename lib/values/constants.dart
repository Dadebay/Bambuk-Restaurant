// ignore_for_file: non_constant_identifier_names

library constants;

import 'models.dart';

const String logoImage = 'assets/icons/logo.png';
const String gilroyBold = 'GilroyBold';
const String gilroySemiBold = 'GilroySemiBold';
const String gilroyMedium = 'GilroyMedium';
const String gilroyRegular = 'GilroyRegular';
bool send_order = false;
List<items> item = [];
List<categorys> category = [];
List<categorys> categoryhome = [];
var children;
List<sliders> banner = [];
List<products> product = [];
List<products> op_product = [];
List<products> discount_products = [];
List<products> new_products = [];
List<products> hit_products = [];
List<orders> activ = [];
List<orders> dis_activ = [];
String phone = "";
String myCatName = '';
//String token='0';
String token = '';
String name = '';
String email = '';
// String api = 'bambukresto.com.tm';
String api = 'bambukresto.com.tm:4443';
bool dil = false;
int options_id = 0;
int categoryId = 0;
String bonusMoney = "0.0";
int myCatID = 0;
bool enter = false;
String name1 = '';
String name2 = '';

Map<String, dynamic> home_data = {};
Map<String, dynamic> subcats = {};
String or_track_code = '';
String or_total_price = '';
int or_status = 0;
List<CommentBanner> commentBanner = [];

String bash_cat = '0';
var sub_children;
int sub_id = 0;

//options
int op_id = 0;
String op_name_tm = "";
String op_name_ru = "";
String op_name_en = "";

String op_description_tm = "";
String op_description_ru = "";
String op_description_en = "";
String op_image = "";
double op_price = 0.00;
int op_count = 0;
double op_rating = 0.00;
int op_discount = 0;
double op_discount_price = 0.00;
String op_category = ' ';
var op_values;

//for tm language
String tm_onum = 'Gündelik harytlar';
String tm_category = 'Kategoriýalar';
String tm_favourites = 'Halanlarym';
String tm_orders = 'Sargytlarym';
String tm_product = 'Haryt';
String tm_products = 'Harytlar';
String tm_show_all = 'ählisini görkez';
String tm_discounts = 'Aksiýalar';
String tm_discounts_products = 'Aksiýa we arzanladyş';
String tm_product_category = 'Kategoriýadaky harytlar';
String tm_product_same = 'Meňzeş harytlar';
String tm_rate = 'Bahalandyrmak';
String tm_full_dep = 'Tagamyň düzümi';
String tm_login = 'Içeri gir';
String tm_language = 'Dil';
String tm_help = 'Kömek';
String tm_about_us = 'Biz barada';
String tm_contuct_us = 'Habarlashmak';
String tm_address = 'Salgy';
String tm_basket = 'Sebet';
String tm_basket_product = 'Sebetdäki harytlar';
String tm_extra_info = 'Eltip bermäniň goşmaça jemi';
String tm_product_price = 'Harytlaryň bahalary';
String tm_discount_info = 'Aksiýa boýunça arzanladyş';
String tm_net_price = 'Jemi';
String tm_order = 'SARGYT ET';
String tm_did_login = 'Siziň hasabyňyz ýokmy?';
String tm_sign = "Hasab aç";
String tm_control_order = "Sargydy yzarla";
String tm_name = 'Ady';
String tm_surname = 'Familýasy';
String tm_did_signin = 'Siziň hasabyňyz barmy?';
String tm_telefon = 'Telefon belgiňiz';
String tm_adres = 'Salgyňyz';
String tm_today = 'Şugün';
String tm_tomorrow = 'Ertir';
String tm_type = 'Tölegiň görnüşi';
String tm_note = 'Bellik';
String tm_cash = 'Nagt';
String tm_kart = 'Mobil terminal';
String tm_cancel = 'Bes etmek';
String tm_send = 'Eltip bermek';

//for ru language

List<String> ru_onum = ['Повседневные товары', 'Gündelik harytlar', 'Everyday goods'];
List<String> ru_bonus = [
  'Бонус',
  'Bonus',
  'Bonus',
];
List<String> ru_use_bonus = [
  'Использовать бонус',
  'Bonus ulan',
  'Use bonus',
];
List<String> review_user = [
  'Отзывы клиентов',
  'Muşderileriň seslenmeleri',
  'User reviews',
];
List<String> ru_category = [
  'Категории',
  'Kategoriýalar',
  'Categories',
];
List<String> ru_favourites = [
  'Избранные',
  'Halanlarym',
  'Favorites',
];
List<String> ru_orders = ['История заказов', 'Sargytlarym', 'History of orders'];
List<String> ru_product = [
  'Продукт',
  'Haryt',
  'Product',
];
List<String> ru_products = [
  'Продукты',
  'Harytlar',
  'Products',
];
List<String> ru_show_all = [
  'Посмотреть все',
  'ählisini görkez',
  'View all',
];
List<String> ru_discounts = [
  'Акции',
  'Aksiýalar',
  'Promotions',
];
List<String> ru_discounts_products = ['Акции и скидки', 'Aksiýa we arzanladyş', 'Promotions and discounts'];
List<String> ru_product_category = ['Товары категории', 'Kategoriýadaky harytlar', 'Category products'];
List<String> ru_product_same = ['Похожие товары', 'Meňzeş harytlar', 'Similar products'];
List<String> ru_rate = [
  'Оценить',
  'Bahalandyrmak',
  'Estimate',
];
List<String> ru_full_dep = ['Описание блюда', 'Tagamyň düzümi', 'Description of the dish'];
List<String> ru_login = [
  'Войти',
  'Içeri gir',
  'Login',
];
List<String> ru_language = [
  'Язык',
  'Dil',
  'Language',
];
List<String> ru_help = [
  'Информация',
  'Maglumat',
  'Information',
];
List<String> ru_about_us = [
  'О приложении',
  'Programma barada',
  'About app',
];
List<String> ru_contuct_us = [
  'Свяжитесь с нами',
  'Habarlashmak',
  'Contact us',
];
List<String> ru_address = [
  'Адрес',
  'Salgy',
  'Address',
];
List<String> ru_basket = [
  'Корзина',
  'Sebet',
  'Basket',
];
List<String> ru_products2 = [
  'Товары',
  'Harytlar',
  'Products',
];
List<String> ru_basket_product = [
  'Товары в корзине',
  'Sebetdäki harytlar',
  'Items in the cart',
];
List<String> ru_extra_info = [
  'Стоимость доставки',
  'Eltip bermäniň goşmaça jemi',
  'Cost of delivery',
];
List<String> ru_product_price = ['Цены на товары', 'Harytlaryň bahalary', 'Commodity prices'];
List<String> ru_discount_info = [
  'Скидка',
  'Aksiýa boýunça arzanladyş',
  'Discount',
];
List<String> ru_net_price = [
  'Общий',
  'Jemi',
  'Total',
];
List<String> ru_order = [
  'ЗАКАЗАТЬ',
  'SARGYT ET',
  'ORDER',
];
bool which_sign = false;
List<String> ru_did_login = [
  'У вас нет учетной записи',
  'Siziň hasabyňyz ýokmy?',
  'You do not have an account?',
];
List<String> ru_sign = [
  'Регистрация',
  'Hasab aç',
  'Registration',
];
List<String> ru_control_oder = [
  'Следить за доставкой',
  'Sargydy yzarla',
  'Follow the delivery',
];
List<String> ru_name = [
  'Имя',
  'Ady',
  'Name',
];
List<String> ru_surname = [
  'Фамилия',
  'Familýasy',
  'Surname',
];
List<String> ru_did_signin = [
  'Вы зарегистрированы?',
  'Siziň hasabyňyz barmy?',
  'Are you registered',
];

List<String> ru_telefon = [
  'Ваш номер телефона',
  'Telefon belgiňiz',
  'Your phone number',
];
List<String> ru_adres = [
  'Ваш адресс',
  'Salgyňyz',
  'Your address',
];
List<String> ru_today = [
  'Сегодня',
  'Şugün',
  'Today',
];
List<String> ru_tomorrow = [
  'Завтра',
  'Ertir',
  'Tomorrow',
];
List<String> ru_type = [
  'Выберите способ оплаты',
  'Tölegiň görnüşi',
  'Select a Payment Method',
];
List<String> ru_note = [
  'Примечания к заказу',
  'Bellik',
  'Order Notes',
];
List<String> ru_cash = [
  ' Наличными',
  'Nagt',
  'Cash',
];
List<String> ru_kart = [
  'Оплата с терминала',
  'Mobil terminal',
  'Payment terminal',
];
List<String> ru_cancel = [
  'Oтменить',
  'Bes etmek',
  'Cancel',
];
List<String> ru_send = [
  'Oформить заказ',
  'Eltip bermek',
  'Checkout',
];
List<String> ru_empty = [
  'Ваша корзина пуста',
  'Siziň sebediňiz boş',
  'Your basket is empty',
];
List<String> ru_profil = [
  'Профиль',
  'Profil',
  'Profile',
];
List<String> ru_ttt = [
  'Отзывы и предложения',
  'Bellikler we teklipler',
  'Comments and suggestions',
];
List<String> ru_addNew = [
  'Добавить новый адрес',
  'Täze salgy goşmak',
  'Add new address',
];
List<String> ru_addSal = [
  'Добавить адрес',
  'Salgy goşmak',
  'Add address',
];
List<String> ru_addtow = ['Добавить товар', 'Haryt goş', 'Add item'];
List<String> ru_programma = [
  'О программе',
  'Programma barada',
  'About the program',
];
List<String> ru_timeDos = [
  'Время доставки',
  'Sargydy eltmeli wagty',
  'Delivery time',
];
List<String> ru_dosType = [
  'Способ заказа',
  'Sargydy görnüşi',
  'Order method',
];
List<String> ru_wynos = [
  'Вынос блюд',
  'Baryp almak',
  'Takeaway',
];
List<String> ru_textr = [
  'Зависимости от района стоимость доставки от 10, 15.. манат',
  'Eltme ýerine baglylykda tölegiň möçberi 10, 15.. manatdan başlanýar.',
  'Depending on the area, the cost of delivery is from 10, 15.. manat',
];
List<String> ru_bron = [
  'Бронь столов',
  'Stol sargamak',
  'Table reservation',
];
List<String> ru_online = [
  'Онлайн оплата',
  'Onlaýn töleg',
  'Online payment',
];
List<String> ru_confirm = [
  'ОФОРМИТЬ ЗАКАЗ',
  'SARGYDY TASSYKLA',
  'CHECKOUT',
];
List<String> ru_razmeshon = [
  'Ваш заказ успешно размещен!',
  'Siziň zakazyňyz kabul edildi!',
  'Your order has been successfully placed!',
];
List<String> ru_potwerdit = [
  'Чтобы подтвердить ваш заказ оператор с Вами свяжется!',
  'Sargydy tassyklamak üçin siz bilen operator habarlaşar!',
  'To confirm your order, the operator will contact you!',
];

List<String> ru_contin = [
  'Продолжить',
  'Dowam et',
  'Continue',
];
List<String> ru_newBlud = [
  'Новые блюда',
  'Täze tagamlar',
  'New dishes',
];
List<String> ru_hitBlud = [
  'Хит продажи',
  'Hit satyşlar',
  'Best selling',
];
List<String> ru_showAll = [
  'Все',
  'Ählisi',
  'All',
];
List<String> ru_active = [
  'Активные',
  'Aktiw',
  'Active',
];
List<String> ru_oldOrder = [
  'Прошлые заказы',
  'Öňki sargytlar',
  'Past Orders',
];
List<String> ru_orderNo = [
  'Заказ',
  'Sargydyn',
  'Order',
];
List<String> ru_fullJem = [
  'Общий',
  'Jemi',
  'Total',
];
List<String> ru_ojidaniya = [
  'Общий',
  'Jemi',
  'Total',
];
List<String> ru_inform = [
  'Информация о товаре',
  'Haryt barada maglumat',
  'Product information',
];

List<String> ru_search = [
  'Поиск...',
  'Gözleg...',
  'Search...',
];

List<String> ru_logout = [
  'Выйти',
  'Ulgamdan çykmak',
  'Log out',
];
List<String> ru_delete = [
  'Удалить аккаунт',
  'Hasaby pozmak',
  'Delete accaunt',
];
List<String> ru_selectLan = [
  'Выберите язык',
  'Dil saýlaň',
  'Select language',
];
List<String> ru_AddCart = [
  'Добавить в корзину',
  'Sebede goş',
  'Add to cart',
];
List<String> ru_version = [
  'Версия 2.0.0',
  'Wersiýa 2.0.0',
  'Version 2.0.0',
];

List<String> ru_sargamak = [
  'Доставка',
  'Sargamak',
  'Order',
];

List<String> ru_selectBank = [
  'Выберите банк',
  'Bank saýlaň',
  'Select bank',
];

//Доставка
