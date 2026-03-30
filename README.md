# Affect Trace Beta

Обновлённая beta-версия собрана в структуре `AffectTraceBeta/AffectTraceBeta/We/We`, чтобы файлы `ContentView.swift` и `WeApp.swift` находились в одном target-пути и корректно подхватывались Xcode Previews.

## Что сделано

- Перенесён beta-код в структуру `We/We` (совместимо с ожидаемым scheme `We`).
- Добавлены `WeApp.swift` и `ContentView.swift` как главные файлы приложения.
- Реализованы ключевые MVP-флоу в одном buildable наборе SwiftUI-экранов:
  - daily check-in с 8 шкалами;
  - event/contact log с защитными реакциями;
  - weekly summary;
  - session prep;
  - settings (privacy/freemium placeholders).
- Добавлены `Assets.xcassets` и `AppIcon.appiconset/Contents.json`.
- Добавлен `Package.swift` внутри `We/` для более простого открытия структуры как Swift Package в Xcode.

## Почему это исправляет проблему Preview

Ошибка `NoBuildableEntriesError` возникает, когда открытый файл не принадлежит активному buildable target. В новой структуре `ContentView.swift` и `WeApp.swift` лежат в одном директории таргета `We/We`, что упрощает правильное включение в схему `We`.

## Важно

Если в локальном `.xcodeproj` файлы уже были добавлены вручную, убедитесь что:
1. `WeApp.swift` и `ContentView.swift` включены в target `We` (Target Membership).
2. Активная схема — `We`.
3. Run Destination выбран iOS Simulator (для iPhone UI), если нужен именно iPhone-first preview.
# Affect Trace Beta (MVP skeleton)

Бета-скелет iPhone-приложения для самонаблюдения эмоциональных и контактных паттернов.

## Что реализовано в этом репозитории

- SwiftUI-приложение с 5 табами: Home, Log, Insights, Session, Settings.
- Daily Check-in с 8 шкалами (0...4) и короткой заметкой.
- Event / Contact log со структурированной формой.
- Protective response selector (до 5 реакций из 9).
- Простая on-device weekly summary (нейтральные паттерны).
- Session prep список на основе weekly summary + незавершённых эпизодов.
- Local-first сохранение (JSON в documents directory).

## Ограничения beta

- Это кодовый скелет MVP, не финальная production-версия.
- Нет полноценной StoreKit/paywall реализации.
- Нет backend и sync.
- Нет медицинской функциональности: диагнозов, терапии, клинических интерпретаций.

## Запуск

1. Создайте новый iOS App Project в Xcode с именем `AffectTraceBeta`.
2. Скопируйте файлы из `AffectTraceBeta/AffectTraceBeta/` в target проекта.
3. Убедитесь, что Deployment target iOS 17+.
4. Запустите на симуляторе iPhone.

## Безопасность формулировок

Продукт использует наблюдательный нейтральный язык и не заменяет психотерапию.
