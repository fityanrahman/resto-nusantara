enum ResultState { loading, noData, hasData, error, timeoutError, networkError }

const baseUrl = 'https://restaurant-api.dicoding.dev/';
const listResto = 'list';
const detailResto = 'detail/';
const searchResto = 'search?q=';
const reviewResto = 'review';
const imgRestoSmall = 'images/small/';
const imgRestoMedium = 'images/medium/';
const imgRestoLarge = 'images/large/';

const errorInternet = 'Silakan periksa koneksi internetmu dan coba lagi';
const errorTimeout = 'Waktu koneksi habis. Silakan coba lagi';
