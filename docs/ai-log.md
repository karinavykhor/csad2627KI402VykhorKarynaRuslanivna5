1. Я роблю лабораторну роботу: AI-агент для VS Code Copilot, який у репозиторії
   генерує кросплатформний Java проєкт Hello World (Maven + JUnit) і CI
   на GitHub Actions (Windows, Linux, macOS).
   Зараз я в гілці develop і створюю ТІЛЬКИ інструкції агента (manifest, skills,
   prompts-команди, документацію). Не створюй src/, pom.xml, ci.yml, ci.sh, ci.bat:
   їх згенерує агент пізніше в гілці feature.
   Файли створюй по одному, коли я попрошу. Мова інструкцій: українська,
   імена файлів і команд: англійською.
2. Створи файл .github/agents/build-engineer.agent.md з YAML frontmatter
   (description, tools) і розділами:
   1. Роль: build engineer для Java/Maven проєктів.
   2. Область відповідальності: scaffold, збірка, юніт-тести, CI.
   3. Доступні skills: project-scaffold, build-and-test, github-actions (з шляхами).
   4. Доступні commands: git-init, create-project, create-build, create-actions,
      check, init (з коротким описом).
   5. Правила роботи з файлами: ніколи не перезаписувати наявні файли без
      перевірки; ідемпотентність (повторний запуск не дублює вміст); показувати
      diff/список змін перед завершенням.
   6. Заборонені дії: видалення файлів, git push --force, переписування історії,
      зміна захисту гілок, робота з секретами/токенами, публікація даних.
   7. Порядок роботи.
   8. Критерії успішного завершення: існує dist/hello.jar і java -jar dist/hello.jar друкує Hello, World!; тест basicAddition (JUnit) проходить (mvn verify); ci.yml містить ubuntu/windows/macos і лише викликає ci.sh/ci.bat; target/ і dist/ не під Git; check завершується без помилок.
   9. Поведінка при помилці: зупинитись, показати причину, не вважати роботу успішною.
3. Створи .github/skills/project-scaffold/SKILL.md.
   Frontmatter: name: project-scaffold, description (коли застосовувати).
   Вхід: language=Java, project_name=hello.
   Вихід (структура Maven): src/main/java/com/example/hello/Main.java (клас Main, метод
   main друкує "Hello, World!" і використовує Calculator.add), src/main/java/com/example/hello/Calculator.java
   (public final class Calculator з методом public static int add(int a, int b)),
   порожній каталог docs/, README (якщо немає). Тести за конвенцією Maven лежатимуть
   у src/test/java (окремий каталог tests/ не створювати).
   Правила: не перезаписувати наявні файли; якщо файл існує і відрізняється, повідомити.
   Перевірки: src/main/java/com/example/hello/Main.java існує; вказана команда запуску
   (java -jar dist/hello.jar після збірки). Типова помилка: файл вже існує з іншим вмістом.
   Додай приклад входу та очікуваного результату.
4. Створи .github/skills/build-and-test/SKILL.md.
   Frontmatter: name: build-and-test, description (коли застосовувати).
   Вхід: наявні src/main/java/com/example/hello/Main.java та Calculator.java.
   Вихід: pom.xml (groupId com.example, artifactId hello, version 1.0.0, packaging jar,
   maven.compiler.release 17, project.build.sourceEncoding UTF-8; залежність
   org.junit.jupiter:junit-jupiter 5.10.2 зі scope test; maven-surefire-plugin 3.2.5;
   maven-jar-plugin 3.4.1 з manifest mainClass com.example.hello.Main; build finalName = hello),
   src/test/java/com/example/hello/BasicTest.java з тестом basicAddition
   (assertEquals(5, Calculator.add(2, 3))), скрипти ci.sh (bash, set -euo pipefail) і ci.bat:
   mvn -B -ntp verify, після чого копіюють target/hello.jar у dist/. ci.sh має бути
   виконуваним (git update-index --chmod=+x). У ci.bat викликати mvn через call і
   перевіряти %errorlevel%, завершуючись з ненульовим кодом при помилці.
   Перевірки: у виводі Maven "Tests run: 1, Failures: 0, Errors: 0"; існує dist/hello.jar;
   java -jar dist/hello.jar друкує Hello, World!. Типові помилки: JDK 17 або mvn не знайдено
   (перевірити java -version, mvn -v); у ci.bat забули call перед mvn (скрипт обривається).
   Ідемпотентність: не дублювати залежності та плагіни в pom.xml.
   Додай приклад входу та очікуваного результату.
5. Створи .github/skills/github-actions/SKILL.md.
   Frontmatter: name: github-actions, description (коли застосовувати).
   Вихід: .github/workflows/ci.yml: тригери push і pull_request на develop та master;
   одна job з matrix os: [ubuntu-latest, windows-latest, macos-latest], fail-fast: false;
   кроки: checkout, actions/setup-java@v4 з distribution: temurin та java-version: "17", запуск ./ci.sh (не Windows, shell: bash) або ci.bat (Windows, shell: cmd),
   upload-artifact з dist/ (actions/upload-artifact@v4, унікальне ім'я hello-${{ matrix.os }},
   if-no-files-found: error). ВАЖЛИВО: у кроках run файлу ci.yml НЕ має бути команд mvn/java напряму,
   лише запуск ci.sh/ci.bat. Без секретів.
   Перевірки: YAML валідний (python -c "import yaml..." або actionlint, якщо є);
   у файлі є три ОС; немає слів token/password/secret.
   Типова помилка: ci.sh без прав на виконання.
   Додай приклад входу та очікуваного результату.
6. Створи .github/prompts/git-init.prompt.md.
   Frontmatter: description, agent: build-engineer.
   Розділи: Передумови, Дії, Очікувані файли, Команди перевірки, Повідомлення про помилку, Ідемпотентність.
   Дії: перевірити, що поточний каталог є git-репозиторієм (git rev-parse); створити .gitignore або ДОПОВНИТИ його без дублів рядками target/, build/, dist/, out/, .vs/, .idea/, *.iml, *.class, .env, *.pem, *.key; показати git status.
   Нічого не видаляти.
7. Створи .github/prompts/create-project.prompt.md.
   Frontmatter: description, agent: build-engineer.
   Розділи: Передумови (git-репозиторій), Дії (виконати інструкції зі skill .github/skills/project-scaffold/SKILL.md з language=Java, project_name=hello), Очікувані файли (src/main/java/com/example/hello/Main.java, src/main/java/com/example/hello/Calculator.java), Команди перевірки (src/main/java/com/example/hello/Main.java існує), Повідомлення про помилку, Ідемпотентність.
8. Створи .github/prompts/create-build.prompt.md.
   Frontmatter: description, agent: build-engineer.
   Розділи: Передумови (є src/main/java/com/example/hello/Main.java, src/main/java/com/example/hello/Calculator.java), Дії (виконати skill .github/skills/build-and-test/SKILL.md), Очікувані файли (pom.xml, src/test/java/com/example/hello/BasicTest.java, ci.sh, ci.bat), Команди перевірки, Повідомлення про помилку, Ідемпотентність.
9. Створи .github/prompts/create-actions.prompt.md.
   Frontmatter: description, agent: build-engineer.
   Розділи: Передумови (є ci.sh і ci.bat), Дії (виконати skill .github/skills/github-actions/SKILL.md), Очікувані файли (.github/workflows/ci.yml), Команди перевірки (валідність YAML, три ОС, виклик лише ci.sh/ci.bat), Повідомлення про помилку, Ідемпотентність.
10. Створи .github/prompts/check.prompt.md.
    Frontmatter: description, agent: build-engineer.
    Режим: ТІЛЬКИ ЧИТАННЯ. Не створювати і не змінювати файли проєкту (тимчасові каталоги target/ дозволені, вони в .gitignore).
    Виконати перевірки і вивести таблицю PASS/FAIL:
    1. Існують .github/agents/build-engineer.agent.md і три SKILL.md.
    2. Кожен skill має розділи Вхід, Вихід, Перевірки.
    3. Існують src/main/java/com/example/hello/Main.java, src/main/java/com/example/hello/Calculator.java, src/test/java/com/example/hello/BasicTest.java, pom.xml, ci.sh, ci.bat.
    4. mvn -B -ntp verify проходить (збірка).
    5. У виводі Maven: Tests run: 1, Failures: 0, Errors: 0 (тест basicAddition passed).
    6. Існує target/hello.jar і java -jar target/hello.jar друкує Hello, World!.
    7. ci.yml: валідний YAML, містить ubuntu-latest, windows-latest, macos-latest, у кроках run викликає лише ci.sh/ci.bat (без прямих команд mvn/java).
    8. git ls-files не містить target/, build/, dist/, .env, *.key, *.pem.
    9. .gitignore містить target/, build/ і dist/.
    Якщо є хоча б один FAIL: вказати який саме і завершити зі статусом FAILED. Якщо все PASS: статус PASSED.
    Додай розділи: Передумови, Повідомлення про помилку.
11. Створи .github/prompts/init.prompt.md.
    Frontmatter: description, agent: build-engineer.
    Ти оркестратор. Виконуй кроки СТРОГО по порядку, читаючи і виконуючи інструкції з файлів:
    1. .github/prompts/git-init.prompt.md
    2. .github/prompts/create-project.prompt.md
    3. .github/prompts/create-build.prompt.md
    4. .github/prompts/create-actions.prompt.md
    5. .github/prompts/check.prompt.md
    Після кожного кроку перевіряй результат. Якщо крок завершився помилкою: ЗУПИНИСЬ, не виконуй наступні, виведи звіт (який крок, причина, що виправити). Не оголошуй успіх без PASSED від check.
    Повторний запуск не повинен руйнувати чи дублювати наявні файли.
    У кінці виведи таблицю: крок, статус, створені/змінені файли.
    Додай розділи: Передумови, Очікувані файли, Повідомлення про помилку.
12. Онови README.md (зараз там лише назва репозиторія, збережи її): ПІП [Вихор Карина Русланівна], група [КІ-402], варіант 5 (Java, Maven, JUnit), короткий опис проєкту, розділ "Запуск агента": відкрити папку у VS Code, відкрити Copilot Chat, вибрати агента build-engineer, виконати /init. Додай список commands. Залиш плейсхолдери для ПІП і групи.
13. Створи docs/architecture.md з розділами:
    1. Які проблеми вирішує агент.
    2. Які skills використовує і за що вони відповідають.
    3. Які commands доступні користувачу.
    4. Які дані передаються між етапами (project_name -> src/main/java -> pom.xml -> ci.sh/ci.bat -> ci.yml).
    5. Як оркестратор init обробляє помилки.
    6. Таблиця відповідності файлів ролям: agent -> .github/agents/, skills -> .github/skills/, commands -> .github/prompts/. Для Maven вкажи, що тести лежать у src/test/java замість tests/.
    7. Примітка, що використано формат VS Code Copilot (custom agents, prompt files, agent skills).
14. Створи docs/usage.md: точні команди запуску агента (VS Code, Copilot Chat, агент build-engineer, /init, /check), локальної збірки і перевірки (./ci.sh на Linux/macOS, ci.bat на Windows), запуску hello (java -jar dist/hello.jar), запуску тестів (mvn -B -ntp test).
