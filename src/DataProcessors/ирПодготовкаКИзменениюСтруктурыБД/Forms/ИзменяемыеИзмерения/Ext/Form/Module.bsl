﻿Процедура ПриОткрытии()
	
	Для Каждого ЭлементСписка Из ИзменяемыеИзмерения Цикл
		ПолноеИмяПоляБД = ирОбщий.ПолноеИмяКолонкиБДИзМД(ЭлементСписка.Представление);
		СтрокаТаблицы = ТаблицаИзмерений.Добавить();
		СтрокаТаблицы.Измерение = ПолноеИмяПоляБД;
		СтрокаТаблицы.ИзмерениеМД = ЭлементСписка.Представление;
		СтрокаТаблицы.НовыйТип = ЭлементСписка.Значение;
		ОписаниеПоля = ирОбщий.ОписаниеПоляТаблицыБДЛкс(ПолноеИмяПоляБД);
		Если ОписаниеПоля <> Неопределено Тогда
			СтрокаТаблицы.ТекущийТип = ОписаниеПоля.ТипЗначения;
		КонецЕсли;
		ЗаполнитьРазличияТиповВСтроке(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

Процедура ТаблицаИзмеренийНовыйТипНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если ирКлиент.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.ТаблицаИзмерений, СтандартнаяОбработка) Тогда 
		ЗаполнитьРазличияТиповВСтроке(ЭлементыФормы.ТаблицаИзмерений.ТекущаяСтрока);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка = Неопределено)
	
	ЭтаФорма.Модифицированность = Ложь;
	ЭтаФорма.ИзменяемыеИзмерения = Новый СписокЗначений;
	Для Каждого СтрокаТаблицы Из ТаблицаИзмерений Цикл
		ИзменяемыеИзмерения.Добавить(СтрокаТаблицы.НовыйТип, СтрокаТаблицы.ИзмерениеМД);
	КонецЦикла;
	Закрыть();
	
КонецПроцедуры

Процедура ЗаполнитьРазличияТиповВСтроке(СтрокаИзмерения)
	СтрокаИзмерения.Различия = "<двойной клик>";
КонецПроцедуры

Процедура ДействияФормыПодбор(Кнопка)
	
	ФормаВыбора = ирКлиент.ФормаВыбораКолонокБДЛкс(ЭтаФорма,, Новый Структура("РольМетаданных, ТипТаблицы", "Измерение", "РегистрСведений"));
	ФормаВыбора.МножественныйВыбор = Истина;
	Если ЭлементыФормы.ТаблицаИзмерений.ТекущаяСтрока <> Неопределено Тогда
		ФормаВыбора.ПараметрТекущаяСтрока = ЭлементыФормы.ТаблицаИзмерений.ТекущаяСтрока.Измерение;
	КонецЕсли;
	РезультатФормы = ФормаВыбора.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		Для Каждого СтрокаРезультата Из РезультатФормы Цикл
			Если ТаблицаИзмерений.Найти(СтрокаРезультата.ПолноеИмяКолонки, "Измерение") <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ОписаниеПоля = ирОбщий.ОписаниеПоляТаблицыБДЛкс(СтрокаРезультата.ПолноеИмяКолонки);
			СтрокаИзмерения = ТаблицаИзмерений.Добавить();
			СтрокаИзмерения.Измерение = СтрокаРезультата.ПолноеИмяКолонки;
			СтрокаИзмерения.ИзмерениеМД = СтрокаРезультата.ПолноеИмяКолонкиМД;
			СтрокаИзмерения.ТекущийТип = ОписаниеПоля.ТипЗначения;
			СтрокаИзмерения.НовыйТип = ОписаниеПоля.ТипЗначения;
			ЭтаФорма.Модифицированность = Истина;
		КонецЦикла;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ТаблицаИзмеренийВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.ТаблицаИзмерений.Колонки.ТекущийТип Тогда
		ирКлиент.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка,, Ложь);
	ИначеЕсли Колонка = ЭлементыФормы.ТаблицаИзмерений.Колонки.Различия Тогда
		Если ВыбраннаяСтрока.НовыйТип.Типы().Количество() > 0 Тогда
			ирКлиент.Сравнить2ЗначенияВФормеЛкс(ирОбщий.СтруктураИзОписанияТиповЛкс(ВыбраннаяСтрока.ТекущийТип), ирОбщий.СтруктураИзОписанияТиповЛкс(ВыбраннаяСтрока.НовыйТип),,
				"ТекущийТип", "НовыйТип",,, ВыбраннаяСтрока.Измерение,,, ВыбраннаяСтрока.Измерение);
		КонецЕсли; 
	ИначеЕсли Колонка = ЭлементыФормы.ТаблицаИзмерений.Колонки.Измерение Тогда
		ирКлиент.ОткрытьКолонкуБДЛкс(ВыбраннаяСтрока.Измерение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ТаблицаИзмеренийПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура ТаблицаИзмеренийПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	Если ДанныеСтроки.НовыйТип.Типы().Количество() = 0 Тогда
		ОформлениеСтроки.Ячейки.НовыйТип.УстановитьТекст("<удалено>");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если ЭтаФорма.Модифицированность Тогда
		Ответ = ирКлиент.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма, Отказ);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ОсновныеДействияФормыОК();
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры


ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодготовкаКИзменениюСтруктурыБД.Форма.ИзменяемыеИзмерения");
