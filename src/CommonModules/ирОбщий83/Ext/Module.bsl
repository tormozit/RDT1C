﻿// Минимальная версия платформы для компиляции модуля 8.3.6
// Все вызовы его методов должны находиться внутри условия ирОбщий.ЛиДоступенМодуль83()
// Запрещено вызывать его методы напрямую. Допускаются только вызовы из ирОбщий 
// Не добавлять методы JSON, т.к. они и в режиме совместимости 8.2 работают

Функция ТекущаяУниверсальнаяДатаВМиллисекундахЛкс() Экспорт 
	Возврат ТекущаяУниверсальнаяДатаВМиллисекундах() 
КонецФункции

Функция СтрНайтиЛкс(Строка, ПодстрокаПоиска, НаправлениеПоиска = Неопределено, НачальнаяПозиция = Неопределено, НомерВхождения = Неопределено) Экспорт 
	Возврат СтрНайти(Строка, ПодстрокаПоиска, НаправлениеПоиска, НачальнаяПозиция, НомерВхождения) 
КонецФункции

Функция СтрРазделитьЛкс(Знач Строка, Знач Разделители, Знач ВключатьПустые = Истина) Экспорт 
	Возврат СтрРазделить(Строка, Разделители, ВключатьПустые) 
КонецФункции

Функция СтрСоединитьЛкс(Знач Строки, Знач Разделитель) Экспорт 
	Возврат СтрСоединить(Строки, Разделитель) 
КонецФункции
