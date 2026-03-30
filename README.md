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
