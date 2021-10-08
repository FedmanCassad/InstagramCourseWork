# Дипломная работа по курсу [профессии «iOS-разработчик с нуля»](https://netology.ru/programs/ios-developer) онлайн-университета Нетология.

**Язык**: Swift.

**Архитектура**: MVVM.

### Основные возможности
1. Биометрическая авторизация пользователя.
2. Авторизация пользователя по паре логин/пароль, либо при наличии валидного токена.
3. Отображение ленты публикаций пользователей.
4. Публикация новых изображений с применением фильтров.
5. Выражение одобрения/неодобрения публикации путем нажатия лайка/дизлайка.
6. Просмотр списка пользователей лайкнувших публикацию.
7. Функционал подписки/отписки от пользователя
8. Просмотр списка подписчиков текущего пользователя или списка пользователей на которых подписан текущий пользователь.

### Особенности реализации

1. Для работы биометрической авторизации не забудьте при запуске эмулятора выполнить команду Features -> FaceID(TouchID) -> Enrolled.
2. Все "чувствительные" данные(логин, пароль, токен доступа к серверу) сохраняются в **Keychain**.
2. В случае когда данные уже есть в Keychain(после первого запуска приложения) нужда в ручном вводе логина и пароля отпадает, в случае удачной биометрической идентификации.
3. В случае если в Keychain данные есть, но сервер не отвечает(не запущен), то приложение переходит в оффлайн режим.
4. При работе приложения в сети, данные публикаций и пользователей сохраняются в оффлайн хранилище реализованное при помощи **CoreData**. Кеширование осуществляется в момент отображения публикации или профиля пользователя.
5. Взаимодействие с сервером реализованно при помощи собственного класса NetworkEngine на основе нативного **URLSession**.
6. Загрузка изображения и часть функционала кеширования изображений реализована при помощи **Kingfisher** асинхронно.
7. Набор доступныхь для публикации изображений ограничен количеством файлов в директории */Server/New*
8. Интерфейс реализован исключительно в коде. Верстка осуществлялась при помощи *AutoLayout*.
9. Для удобного доступа к ресурсам,в том числе к ключам локализации использован фреймвор **R.swift**
10. Локализация реализована для английского и русского языков.
11. Реализована возможность запуска на реальном устройстве. Инструкции ниже.
12. Для работы приложения необходим локальный сервер. Инструкции ниже.

Дизайн и структура приложения соответствует данному макету:

### Запуск сервера
Все команды выполняются в **Терминале** запущенном по адресу [PROJECT_NAME]/Server.
1) Установка Vapor.(Server-side swift)
`brew install vapor/tap/vapor`
Если package-менеджер **brew** еще не установлен:
`/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
В случае вывода ошибки ссылающейся на отсутствие библиотеки **libressl**:
`brew install libressl`
Для запуска неподписонного приложения нужно разблокировать в Gatekeeper исполняемый файл сервера:
`sudo xattr -d com.apple.quarantine Run`.
2) Запуск сервера в рижиме localhost:
`./Run`.
3) Запуск сервера в режиме,в котором становится возможным запуск на реальном устройстве:/n
    а) Зайдите в настройки вашей Wi-fi сети, скопируйте ip-адрес.
    b) В классе NetworkEngine измените свойство **location** на **.LANIP**
    c)Замените код в enum'е HostLocation на:
"`Swift 
enum HostLocation {
  case localhost
  case LANIP
  var serverURL: URL {
    switch self {
    case .localhost:
      let url = URL(string: "http://localhost:8080")
      return url!
    case .LANIP:
      let url = URL(string: "http://[YOUR_IP]:8080")
      return url!
    }
  }
}
"`

   
    c) Сервер запустить командой './Run - b [YOUR_IP]:8080'
4) Остановка сервера:
Ctrl+C

5)Данные для входа(без кавычек):
login: "user"
password: "qwerty"
