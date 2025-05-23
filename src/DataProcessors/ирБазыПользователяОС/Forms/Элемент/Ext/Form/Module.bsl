﻿
Процедура ПриОткрытии()
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	Если ПустаяСтрока(РежимЗапуска) Тогда
		ЭтаФорма.РежимЗапуска = "Авто";
	КонецЕсли;
	Если ПустаяСтрока(Разрядность) Тогда
		ЭтаФорма.Разрядность = "Auto";
	КонецЕсли;
	Если ЗначениеЗаполнено(Идентификатор) Тогда
		ирОбщий.ОбновитьТекстПослеМаркераЛкс(ЭтаФорма.Заголовок,, ИмяВСписке, ": ");
	Иначе
		ирОбщий.ОбновитьТекстПослеМаркераЛкс(ЭтаФорма.Заголовок,, " (Создание)", ": ");
		ТекстИзБуфера = ирКлиент.ТекстИзБуфераОбменаОСЛкс();
		Если ЗначениеЗаполнено(НСтр(ТекстИзБуфера, "srvr")) Тогда
			ЭтаФорма.СтрокаСоединения = ТекстИзБуфера;
		ИначеЕсли ЗначениеЗаполнено(НСтр(ТекстИзБуфера, "file")) Тогда
			ЭтаФорма.СтрокаСоединения = ТекстИзБуфера;
		КонецЕсли;
		ИмяВСпискеПриИзменении(ЭлементыФормы.ИмяВСписке);
	КонецЕсли;
	СтрокаСоединенияПриИзменении();
КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура КоманднаяПанельОбщаяОК(Кнопка = Неопределено)
	Если ПустаяСтрока(СтрокаСоединения) Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.СтрокаСоединения;
		ирОбщий.СообщитьЛкс("Нужно заполнить строку соединения");
		Возврат;
	КонецЕсли;
	Если ПустаяСтрока(ИмяВСписке) Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ИмяВСписке;
		ирОбщий.СообщитьЛкс("Нужно заполнить имя");
		Возврат;
	КонецЕсли;
	ирКлиент.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, ЭтаФорма);
КонецПроцедуры

Процедура СтрокаСоединенияПриИзменении(Элемент = Неопределено)
	ЭтаФорма.Кластер = НСтр(СтрокаСоединения, "srvr");
	ЭтаФорма.ИмяВКластере = НСтр(СтрокаСоединения, "ref");
	ЭтаФорма.Каталог = НСтр(СтрокаСоединения, "file");
	Если ЗначениеЗаполнено(Кластер) Или ПустаяСтрока(СтрокаСоединения) Тогда
		ЭлементыФормы.ПанельТипПодключения.ТекущаяСтраница = ЭлементыФормы.ПанельТипПодключения.Страницы.Серверная;
	ИначеЕсли ЗначениеЗаполнено(Каталог) Тогда
		ЭлементыФормы.ПанельТипПодключения.ТекущаяСтраница = ЭлементыФормы.ПанельТипПодключения.Страницы.Файловая;
	Иначе
		ЭлементыФормы.ПанельТипПодключения.ТекущаяСтраница = ЭлементыФормы.ПанельТипПодключения.Страницы.ВебСервер;
	КонецЕсли;
КонецПроцедуры

Процедура КаталогОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ирКлиент.ОткрытьФайлВПроводникеЛкс(Каталог);
КонецПроцедуры

Процедура ВерсияПлатформыНачалоВыбора(Элемент, СтандартнаяОбработка)
	РезультатВыбора = ОткрытьВыборВерсииПлатформы(Элемент.Значение, "СборкаПлатформы");
	Если РезультатВыбора <> Неопределено Тогда
		ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(Элемент, РезультатВыбора.СборкаПлатформы);
	КонецЕсли;
КонецПроцедуры   

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если Модифицированность Тогда
		Ответ = Вопрос("Данные в форме изменены. Сохранить?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
			Возврат;
		ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
			КоманднаяПанельОбщаяОК();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура КластерПриИзменении(Элемент)
	Элемент.Значение = СокрЛП(Элемент.Значение);
	ДополнительныеПараметрыПриИзменении(Элемент);
	СобратьСтрокуСоединенияСервер();
КонецПроцедуры

Процедура СобратьСтрокуСоединенияСервер() Экспорт
	ЭтаФорма.СтрокаСоединения = "Srvr=""" + Кластер + """;Ref=""" + ИмяВКластере + """;"; // Регистр букв вероятно важен для штатного стартера и точно важен для EDT https://github.com/1C-Company/1c-edt-issues/issues/1789
КонецПроцедуры

Процедура ИмяВКластереПриИзменении(Элемент)
	СобратьСтрокуСоединенияСервер();
КонецПроцедуры

Процедура КаталогПриИзменении(Элемент)
	ЭтаФорма.СтрокаСоединения = "File=""" + Каталог + """;"; // Регистр букв вероятно важен для штатного стартера и точно важен для EDT https://github.com/1C-Company/1c-edt-issues/issues/1789
КонецПроцедуры

Процедура КаталогНачалоВыбора(Элемент, СтандартнаяОбработка)
	НовоеЗначение = ирКлиент.ВыбратьКаталогВФормеЛкс(Элемент.Значение, ЭтаФорма);
	Если НовоеЗначение <> Неопределено Тогда
		ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(Элемент, НовоеЗначение);
	КонецЕсли;
КонецПроцедуры

Процедура ДополнительныеПараметрыНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ДополнительныеПараметрыПриИзменении(Элемент)
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура КластерНачалоВыбора(Элемент, СтандартнаяОбработка)
	Копия = БазыПользователя.Выгрузить(, "Кластер");
	Копия.Сортировать("Кластер");
	Копия.Свернуть("Кластер");
	Список = Новый СписокЗначений;
	Список.ЗагрузитьЗначения(Копия.ВыгрузитьКолонку(0));
	Если Список[0].Значение = "" Тогда
		Список.Удалить(0);
	КонецЕсли;
	НовоеЗначение = ВыбратьИзСписка(Список, Элемент, Список.НайтиПоЗначению(Кластер));
	Если НовоеЗначение <> Неопределено Тогда
		ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(Элемент, НовоеЗначение);
	КонецЕсли;
КонецПроцедуры

Процедура ОткрытьФайлВПроводнике(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ирКлиент.ОткрытьФайлВПроводникеЛкс(Элемент.Значение);
КонецПроцедуры

Процедура ИмяВСпискеПриИзменении(Элемент)
	Если ПустаяСтрока(Элемент.Значение) Тогда
		Элемент.Значение = СтрокаСоединения;
	КонецЕсли;
	Элемент.Значение = ирОбщий.АвтоУникальноеИмяВКоллекцииЛкс(БазыПользователя, Элемент.Значение, "ИмяВСписке", Ложь);
КонецПроцедуры

Процедура ДополнительныеПараметрыНачалоВыбора(Элемент, СтандартнаяОбработка)
	ирКлиент.ПолеВводаРасширенногоЗначения_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирБазыПользователяОС.Форма.Элемент");
Для Каждого РежимыЭлемент Из РежимыЗапускаПриложения() Цикл
	ЭлементыФормы.РежимЗапуска.СписокВыбора.Добавить(РежимыЭлемент.Имя, РежимыЭлемент.Представление);
КонецЦикла;
Для Каждого РежимыЭлемент Из РазрядностиПриложения() Цикл
	ЭлементыФормы.Разрядность.СписокВыбора.Добавить(РежимыЭлемент.Внутр, РежимыЭлемент.Представление);
КонецЦикла;
