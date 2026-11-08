# Архітектура AI-агента

## 1. Які проблеми вирішує агент

Агент автоматизує створення та перевірку кросплатформного Java-проєкту з Maven і JUnit, зменшуючи ручне налаштування структури каталогів, збірки, тестів і CI. Він допомагає підтримувати однаковий процес для Windows, Linux і macOS, а також перевіряє результат і повідомляє про помилки, не оголошуючи невдалий запуск успішним.

## 2. Skills та їх відповідальність

- `project-scaffold` — створює каркас Maven-проєкту, Java-класи `Main` і `Calculator`, каталог `docs/` та README за його відсутності.
- `build-and-test` — налаштовує Maven, JUnit-тест `basicAddition` і скрипти збірки та перевірки `ci.sh` / `ci.bat`.
- `github-actions` — описує GitHub Actions workflow для Linux, Windows і macOS, який запускає відповідні CI-скрипти та завантажує артефакти.

## 3. Commands для користувача

- `/git-init` — перевіряє Git-репозиторій і створює або доповнює `.gitignore`.
- `/create-project` — створює каркас Java-проєкту `hello`.
- `/create-build` — налаштовує Maven-збірку, JUnit-тест і CI-скрипти.
- `/create-actions` — створює GitHub Actions workflow.
- `/check` — перевіряє файли проєкту, збірку, тести, JAR, CI та відстеження файлів Git у режимі лише читання.
- `/init` — послідовно запускає команди ініціалізації, зупиняється при помилці та завершує роботу успішно лише після статусу `PASSED` від `/check`.

## 4. Дані між етапами

Потік конфігурації та артефактів:

```text
project_name=hello
    -> src/main/java/com/example/hello/
    -> pom.xml
    -> ci.sh / ci.bat
    -> .github/workflows/ci.yml
```

`project_name` визначає назву застосунку, а для `hello` використовується Java package `com.example.hello`. Етап scaffold створює `Main.java` та `Calculator.java` у відповідному каталозі `src/main/java`. Етап збірки задає в `pom.xml` координати Maven, версію Java, JUnit і головний клас; тест розміщується за Maven-конвенцією в `src/test/java`, а не в окремому `tests/`. Скрипти `ci.sh` і `ci.bat` виконують Maven-перевірку та готують JAR. Workflow `ci.yml` вибирає скрипт відповідно до операційної системи й завантажує результат із `dist/`; сам workflow не запускає Maven чи Java напряму.

## 5. Обробка помилок оркестратором `init`

Оркестратор виконує prompt-файли в заданому порядку: `git-init`, `create-project`, `create-build`, `create-actions`, `check`. Після кожного кроку він перевіряє його результат і переходить далі лише після успіху. Якщо крок або його перевірка завершується помилкою, оркестратор зупиняється, не запускає наступні кроки, вказує номер і причину помилки та описує, що потрібно виправити. Наступні кроки позначаються `NOT RUN`; загальний статус `PASSED` дозволений лише після успішного `check`.

## 6. Відповідність файлів їхнім ролям

| Роль | Каталог або шлях | Призначення |
|---|---|---|
| Agent | `.github/agents/` | Визначає роль build engineer, доступні засоби, правила роботи та критерії завершення. |
| Skills | `.github/skills/` | Містить спеціалізовані інструкції для scaffold, збірки й тестування та GitHub Actions. |
| Commands | `.github/prompts/` | Містить prompts команд `git-init`, `create-project`, `create-build`, `create-actions`, `check` і `init`. |
| Java-код | `src/main/java/` | Містить вихідний код застосунку; для `hello` — `com/example/hello/`. |
| Maven-тести | `src/test/java/` | Містить JUnit-тести згідно з Maven-конвенцією. Тести лежать тут, а не в окремому каталозі `tests/`. |
| CI | `.github/workflows/` | Містить workflow GitHub Actions, який запускає CI-скрипти для відповідних платформ. |

## 7. Формат VS Code Copilot

У проєкті використано формат VS Code Copilot: custom agent (`.github/agents/`), prompt files (`.github/prompts/`) і agent skills (`.github/skills/`). Відповідні файли дають змогу Copilot Chat вибрати агента, виконувати команди та застосовувати спеціалізовані інструкції.
