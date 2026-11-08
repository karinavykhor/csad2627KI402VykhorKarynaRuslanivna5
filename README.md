csad2627KI402VykhorKarynaRuslanivna5

## Інформація про лабораторну роботу

- ПІП: [Введіть ПІП]
- Група: [Введіть групу]
- Варіант: 5 (Java, Maven, JUnit)

## Опис проєкту

Репозиторій містить налаштування AI-агента для VS Code Copilot, який створює каркас кросплатформного Java-проєкту з Maven, JUnit-тестом і CI на GitHub Actions для Windows, Linux та macOS.

Згенерований Maven-проєкт компілюється з `maven.compiler.release=25`. Для локальної збірки, тестів і CI потрібні JDK 25 та Maven.

## Запуск агента

1. Відкрийте папку репозиторію у VS Code.
2. Відкрийте Copilot Chat.
3. Виберіть агента `build-engineer`.
4. Виконайте команду `/init`.

## Commands

- `/git-init` — перевірити Git-репозиторій і створити або доповнити `.gitignore`.
- `/create-project` — створити каркас Java-проєкту.
- `/create-build` — налаштувати Maven-збірку, JUnit-тест і CI-скрипти.
- `/create-actions` — створити GitHub Actions workflow.
- `/check` — перевірити структуру проєкту, збірку, тести та CI.
- `/init` — послідовно виконати всі кроки ініціалізації та перевірки.
