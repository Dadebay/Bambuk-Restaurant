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
List<String> emptyFavouritesTitle = ['Нет избранных товаров', 'Halanan önüm ýok', 'No favourite items'];
List<String> emptyFavouritesSubtitle = [
  'Нажмите на сердечко, чтобы сохранить понравившийся товар',
  'Haladyňyz önümi ýürek belgisine basyp saklap bilersiňiz',
  'Tap the heart icon to save your favourite items'
];
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

List<String> ruCykmak = ['Вы уверены, что хотите выйти из программы?', 'Siz hakykatdanda programmadan çykmak isleýärsiňizmi ?', 'Are you sure you want to exit the program?'];
List<String> ruCykmakYes = ['Да', 'Hawwa', 'Yes'];
List<String> bonus = ['Ваш бонус', 'Bonusyňyz', 'Your bonus'];
List<String> ruCykmakNo = ['Нет', 'Ýok', 'No'];
List<String> ru_onum = ['Повседневные товары', 'Gündelik harytlar', 'Everyday goods'];
List<String> ru_bonus = [
  'Бонус',
  'Bonus',
  'Bonus',
];
List<String> tabBarName1 = [
  'Ресторан',
  'Restoran',
  'Restaurant',
];
List<String> tabBarName2 = [
  'История блюд',
  'Tagam taryhy',
  'Food History',
];
List<String> tabBarName3 = [
  'Интересно',
  'Gyzykly',
  'Interesting',
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
  'Mobil goşundy barada',
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
List<String> service = [
  'Услуга для (+10%)',
  'Hyzmat üçin (+10%)',
  'Service for (+10%)',
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
  'Отзывы и предложения чат',
  'Bellikler we teklipler çaty',
  'Comments and suggestions chat',
];
List<String> ru_ttt_empty = [
  'Пока нет комментариев',
  'Häzirlikçe teswir ýok',
  'No comments yet',
];
List<String> ru_ttt_hint = [
  'Написать...',
  'Ýaz...',
  'Write...',
];
List<String> ru_ttt_subtitle = [
  'Замечания и предложения доступны только руководству ресторана. Спасибо за ваш вклад в совершенствование ресторана!',
  'Bellikler we teklipler diňe Restoranyň ýolbaşçylaryna elýeterlidir. Restoranyň kämilleşmegine berýän ýardamyňyza sag boluň ! ',
  'Notes and suggestions are available only to the restaurant management. Thank you for your contribution to the improvement of the restaurant!',
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
  'О приложении',
  'Mobil goşundy barada',
  'About app',
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
  'Версия 2.2.0',
  'Wersiýa 2.2.0',
  'Version 2.2.0',
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

List<String> ru_notifications = [
  'Уведомления',
  'Bildirişler',
  'Notifications',
];

List<String> ru_chat = [
  'Чат с админом',
  'Admin bilen chat',
  'Chat with admin',
];

List<String> ru_chat_empty = [
  'Сообщений пока нет',
  'Häzirlikçe habar ýok',
  'No messages yet',
];

List<String> ru_chat_customer_id_error = [
  'Пользователь не найден. Войдите заново.',
  'Ulanyjy tapylmady. Täzeden giriň.',
  'User not found. Please log in again.',
];

List<String> ru_no_notifications = [
  'Уведомлений пока нет.',
  'Häzirlikçe bildiriş ýok.',
  'No notifications yet.',
];

List<String> ru_failed_to_load = [
  'Не удалось загрузить уведомления.',
  'Bildirişleri ýükläp bolmady.',
  'Failed to load notifications.',
];

List<String> ru_error_occurred = [
  'Произошла ошибка:',
  'Ýalňyşlyk ýüze çykdy:',
  'An error occurred:',
];

// Banner/Announcements
List<String> announcements_title = [
  'Объявления',
  'Habarlar',
  'Announcements',
];

List<String> announcements_subtitle = [
  'Акции и новости',
  'Kampaniýalar we habarlar',
  'Promotions and news',
];

List<String> view_details = [
  'Посмотреть детали',
  'Jikme-jiklikleri gör',
  'View details',
];

// Reviews
List<String> customer_reviews_title = [
  'Отзывы наших клиентов',
  'Müşderilerimizin pikirleri',
  'Our customers\' opinions',
];

List<String> no_reviews_yet = [
  'Пока нет отзывов',
  'Henizçe syn ýok',
  'No reviews yet',
];

List<String> review_label = [
  'Отзыв',
  'Syn',
  'Review',
];

List<String> no_image = [
  'Нет изображения',
  'Surat ýok',
  'No image',
];

// Location Services
List<String> location_service_disabled = [
  'Служба определения местоположения отключена',
  'Ýerleşiş hyzmaty ýapyk',
  'Location service is disabled',
];

List<String> location_permission_required = [
  'Требуется разрешение на определение местоположения',
  'Ýerleşiş rugsady gerek',
  'Location permission required',
];

List<String> location_permission_message = [
  'Для отображения местоположения ресторана необходимо разрешение.',
  'Restoranyň ýerleşişini görmek üçin rugsat gerek.',
  'Permission is required to view the restaurant location.',
];

List<String> location_service_message = [
  'Служба определения местоположения отключена. Пожалуйста, включите в настройках устройства.',
  'Ýerleşiş hyzmaty ýapyk. Enjam sazlamalaryndan açyň.',
  'Location service is disabled. Please enable it in device settings.',
];

List<String> go_to_settings = [
  'Перейти в настройки',
  'Sazlamalara git',
  'Go to settings',
];

List<String> our_address = [
  'Наш адрес',
  'Bizin salgymyz',
  'Our address',
];

List<String> press_map_to_find_us = [
  'Нажмите на карту, чтобы найти нас',
  'Bizi tapmak üçin karta basyň',
  'Press on the map to find us',
];

List<String> choose_what_you_need = [
  'Выберите то, что вам нужно',
  'Size gerekli zady saýlaň',
  'Choose what you need',
];

// Map page UI strings
List<String> open_map = [
  'Открыть карту',
  'Kartany aç',
  'Open map',
];

List<String> route_showing_subtitle = [
  'Маршрут отображается',
  'Ugur görkezilýär',
  'Route is showing',
];

List<String> clear_route_tooltip = [
  'Очистить маршрут',
  'Ugury arassala',
  'Clear route',
];

List<String> focus_restaurant_tooltip = [
  'Сосредоточиться на ресторане',
  'Restorana üns çek',
  'Focus on restaurant',
];

List<String> location_permission_needed = [
  'Необходимо разрешение на местоположение',
  'Ýerleşiş rugsady gerek',
  'Location permission required',
];

List<String> location_found = [
  'Ваше местоположение найдено',
  'Siziň ýeriňiz tapyldy',
  'Your location found',
];

List<String> location_timeout_msg = [
  'Местоположение не получено. Включите GPS/Wi-Fi и попробуйте на открытом месте.',
  'Ýerleşiş alynmady. GPS/Wi-Fi-ny açyň we açyk ýerde synanyşyň.',
  'Location not found. Please enable GPS/Wi-Fi and try in an open area.',
];

List<String> location_error_msg = [
  'Ошибка при получении местоположения: ',
  'Ýerleşiş alnyşynda ýalňyşlyk: ',
  'Error getting location: ',
];

List<String> activate_location_first = [
  'Сначала активируйте местоположение',
  'Ilki ýerleşişiňizi işjeňleşdiriň',
  'Activate your location first',
];

List<String> route_error_msg = [
  'Не удалось получить маршрут. Проверьте подключение к Интернету и повторите попытку.',
  'Ugur alynmady. Internet baglanyşygyňyzy barlaň we gaýtadan synanyşyň.',
  'Could not get route. Check your internet connection and try again.',
];

List<String> route_drawn = [
  'Маршрут нарисован',
  'Ugur çekildi',
  'Route drawn',
];

List<String> route_cleared = [
  'Маршрут очищен',
  'Ugur arassalandy',
  'Route cleared',
];

List<String> calculating_route = [
  'Расчет маршрута...',
  'Ugur hasaplanylýar...',
  'Calculating route...',
];

List<String> show_route = [
  'Показать маршрут',
  'Ugry Görkez',
  'Show route',
];

List<String> route_active_label = [
  'Маршрут показывается',
  'Ugur Görkezilýär',
  'Route showing',
];

// Splash screen strings
List<String> splash_slogan = [
  'УДИВИТЕЛЬНАЯ АЗИАТСКАЯ КУХНЯ',
  'AJAÝYP AZIÝA TAGAMLARY',
  'AMAZING ASIAN CUISINE',
];

List<String> splash_loading = [
  'Загрузка...',
  'Ýüklenýär...',
  'Loading...',
];

List<String> splash_no_internet = [
  'Нет интернет-соединения',
  'Internet birikmesi ýok',
  'No internet connection',
];

List<String> splash_check_internet = [
  'Проверьте интернет-соединение',
  'Internet birikmesini barlaň',
  'Check your internet connection',
];

//Доставка
List<String> ru_irrev_warning = [
  'Это действие нельзя отменить!',
  'Bu amal yzyna alynmaz!',
  'This action cannot be undone!',
];

List<String> ru_acc_deleted = [
  'Аккаунт удалён!',
  'Hasap pozuldy!',
  'Account deleted!',
];

List<String> ru_acc_delete_error = [
  'Произошла ошибка, попробуйте снова!',
  'Ýalňyşlyk ýüze çykdy, täzeden synanyşyň!',
  'An error occurred, try again!',
];
