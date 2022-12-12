# TASK Manager

Ruby on Rails приложение для назначения/выполения задач внутри группы.

Доступ только для зарегистрированных. Пользователи приложения могут создавать задачи для других пользователе, изменять статус выполнения своих задач (created, started, finished). На всех этапах предусмотрена email рассылка уведомлений участникам текущей задачи.

### Версии Ruby и Rails:

```
ruby '3.0.1'

rails '~> 7.0.3'

pg '~> 1.1'
```

### Реализовано в приложении:

- Полный CRUD процесс задач: создание, удаление, просмотр, изменение.

- Аутентификация с использованием гема `devise` (Sign in, Sign out, Forgot Password, Unlock, Update Account);

- Авторизация с помощью `pundit` (Ограничен доступ анонимным пользователя, доступы для пользователей и авторов задач в зависимости от статуса задачи);

- Фронтенд с помощью `bootstrap 5`;

- `ActionMailer`, `bootstrap-email` для отправки email уведомлений, настроено тестовое окружение, `letter_opener`;

- Тестирование `models`, `controllers`, `helpers` с помощью `rspec-rails`, `factory_bot_rails`, `faker`, `rails-controller-testing`, `shoulda-matchers`, `simplecov`;

-

### Установка приложения:

Установите `Bundler`:

```
gem install bundler
```

Склонируйте репозиторий:

```
git clone https://github.com/goodquietly/task_manager.git
```

Находясь в папке с игрой `cd task_manager`, установите библиотеки:

```
bundle install
```

Создайте БД

```
bundle exec rake db:create
```

Выполните миграции БД

```
bundle exec rake db:migrate
```

Установите `yarn` :

```
yarn install
```

Соберите библиотеки с помощью `yarn`:

```
yarn build
yarn build:css
```

### Запустите тестирование программы:

```
bundle exec rspec
```

### Проверить покрытие приложения тестами на Ubuntu:

```
xdg-open coverage/index.html
```

### Запустите программу:

```
bundle exec rails s
```

В браузере перейдите по ссылке:

```
http://localhost:3000
```
