﻿
Процедура ПриОткрытии()
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ПрочитатьОсновныеВерсииПлатформы();
КонецПроцедуры

Функция ПрочитатьОсновныеВерсииПлатформы() Экспорт
	ОсновныеВерсииПлатформы.Очистить();
	Файл = Новый Файл(УказательОбщийПользователя);
	Если Файл.Существует() Тогда
		ЧтениеФайла = Новый ЧтениеТекста;
		Попытка
			//ЧтениеФайла.Открыть(Файл.ПолноеИмя, КодировкаТекста.UTF8); // Так текст читался некорректно
			ЧтениеФайла.Открыть(Файл.ПолноеИмя);
			СтрокаИзФайла = ЧтениеФайла.ПрочитатьСтроку();
		Исключение
			ОписаниеОшибки = ОписаниеОшибки(); // Для отладки
			СтрокаИзФайла = Неопределено;
		КонецПопытки; 
		Пока СтрокаИзФайла <> Неопределено Цикл
			ТекущаяСтрока = СокрЛП(СтрокаИзФайла);
			ИмяПараметра = ирОбщий.ПервыйФрагментЛкс(ТекущаяСтрока, "=", Ложь);
			Если ИмяПараметра = "DefaultVersion" Тогда
				Фрагменты = ирОбщий.СтрРазделитьЛкс(ирОбщий.СтрокаБезПервогоФрагментаЛкс(ТекущаяСтрока, "="), "-");
				Если Фрагменты.Количество() > 1 Тогда
					СтрокаТаблицы = ОсновныеВерсииПлатформы.Добавить();
					СтрокаТаблицы.ДляВерсий = Фрагменты[0];
					СтрокаТаблицы.ИспользоватьВерсию = Фрагменты[1];
				КонецЕсли;
			КонецЕсли; 
			СтрокаИзФайла = ЧтениеФайла.ПрочитатьСтроку();
		КонецЦикла;
	КонецЕсли; 
КонецФункции

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);
КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура КаталогОбъектовДляОтладкиНачалоВыбора(Элемент, СтандартнаяОбработка)
	ВыбранныйКаталог = Элемент.Значение;
	Если ирКлиент.ВыбратьКаталогВФормеЛкс(ВыбранныйКаталог, ЭтаФорма) <> Неопределено Тогда
		Файл = ИмяБазовогоФайлаПортативного(ВыбранныйКаталог);
		Если Файл.Существует() Тогда
			Элемент.Значение = ВыбранныйКаталог;
		Иначе
			ирОбщий.СообщитьЛкс("Файл " + Файл.Имя + " не найден в указанном каталоге");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОткрытьФайлВПроводнике(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ирКлиент.ОткрытьФайлВПроводникеЛкс(Элемент.Значение);
КонецПроцедуры

Процедура КаталогиПоискаПлатформыКаталогНачалоВыбора(Элемент, СтандартнаяОбработка)
	ирКлиент.ВыбратьКаталогВФормеЛкс(Элемент.Значение, ЭтаФорма);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирБазыПользователяОС.Форма.Настройки");
