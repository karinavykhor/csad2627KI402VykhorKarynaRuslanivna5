# Copilot instructions for this repository

This repository is a VS Code Copilot scaffold for a small Java + Maven + JUnit project. The real work in this repo is the build and validation flow: generating a consistent Java Hello World application, wiring Maven and JUnit, and validating the result on Windows, Linux, and macOS via GitHub Actions.

The relevant parts of the repo are:

- [README.md](../README.md) is the project brief and explains the lab goal and the Copilot-driven workflow.
- [docs/architecture.md](../docs/architecture.md) describes the intended build and CI layout.
- `.github/agents/build-engineer.agent.md` defines the build-agent workflow.
- `.github/skills/` contains the Java/Maven, test, and GitHub Actions skills used for scaffolding and validation.
- `.github/prompts/` contains the entry points (`/git-init`, `/create-project`, `/create-build`, `/create-actions`, `/check`, and `/init`).

## Build, test, and validation commands

Use the repo's Maven commands directly instead of ad hoc variants. There is no separate repo-specific lint tool; validation is Maven-based and CI-driven.

```bash
mvn -B -ntp verify
```

For a targeted regression check, prefer a single JUnit method:

```bash
mvn -Dtest=BasicTest#basicAddition test
```

The class-level form is also valid when you want the whole test class:

```bash
mvn -Dtest=BasicTest test
```

The expected packaged artifact is a runnable JAR:

```bash
java -jar dist/hello.jar
```

The output should be exactly:

```text
Hello, World!
```

The canonical OS-specific validation entry points are the repo scripts:

```bash
./ci.sh
```

On Windows, use PowerShell or Git Bash:

```powershell
.\ci.bat
```

When workflow files are edited, validate YAML before committing. A simple Python check is:

```bash
python -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml', encoding='utf-8'))"
```

If `actionlint` is installed, prefer:

```bash
actionlint .github/workflows/ci.yml
```

## High-level architecture

The project is intentionally small and template-driven rather than a large application:

- The Java source lives under `src/main/java/com/example/hello/`.
- The tests live under `src/test/java/com/example/hello/` and use JUnit 5.
- `pom.xml` is the build definition and Maven test driver.
- `src/main/java/com/example/hello/Main.java` is the application entry point; `Calculator.java` is the helper class used by the generated example.
- `src/test/java/com/example/hello/BasicTest.java` contains the `basicAddition` regression that verifies `Calculator.add(2, 3) == 5`.
- The expected final artifact is `dist/hello.jar`; compiles and cached output live in `target/`.
- `.github/` contains the scaffolding and validation layer: skills, prompts, and the build-engineer agent.
- CI is organized around root-level scripts (`ci.sh` and `ci.bat`) and a cross-platform workflow matrix for Ubuntu, Windows, and macOS.

This repo is not a monorepo or business application. It is a small build-automation project with a minimal Java sample app whose correctness is validated end-to-end.

## Key conventions

- Keep Java package naming and file layout consistent with `com.example.hello` under `src/main/java/com/example/hello/`.
- Keep tests under `src/test/java/com/example/hello/`; do not move them into ad hoc folders like `tests/` unless the repo explicitly changes that convention.
- Favor the repo's generated commands (`/init`, `/create-build`, `/create-actions`, `/check`) over custom scripts when making changes in this scaffold.
- Preserve cross-platform compatibility: shell scripts must work in Linux/macOS and Windows PowerShell or Git Bash contexts.
- Do not commit build artifacts in `target/` or `dist/`; those directories are local outputs and should stay out of Git.
- The CI workflow should only invoke the platform script (`./ci.sh` or `ci.bat`) and should not shell out directly to Maven or `java` in the same step.
- Keep naming and workflow decisions aligned with the generated Java project conventions: `Main`, `Calculator`, and `BasicTest`.
- When validating changes, prefer the same command the repo uses in the check flow: `mvn verify` or the OS-specific script, then confirm the artifact still prints exactly `Hello, World!`.

## Working expectations

- Treat this repo as a Java scaffolding and CI project rather than a large application codebase.
- When adding or changing build logic, verify with Maven first and then with the relevant CI script.
- Preserve the repo's generated conventions and avoid inventing a parallel structure or package layout.
