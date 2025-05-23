﻿
&НаКлиенте
Процедура КаталогФайловогоКэшаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ВыборФайла.Каталог = КаталогФайловогоКэша;
	Если Не ВыборФайла.Выбрать() Тогда
		Возврат;
	КонецЕсли;
	ЭтаФорма.КаталогФайловогоКэша = ВыборФайла.Каталог;
	КаталогФайловогоКэшаПриИзменении();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Автотест") Тогда  
		Возврат;
	КонецЕсли;
	Если Не ирОбщий.ПроверитьЧтоСеансТолстогоКлиентаЛкс() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Если ирКэш.НомерВерсииБСПЛкс() >= 204 Тогда
		Если Не ирКэш.ЛиЭтоРасширениеКонфигурацииЛкс() Тогда
			ирОбщий.СообщитьЛкс("Работа инструмента с БСП 2.4 и выше поддерживается только в варианте Расширение",,, Истина);
			Отказ = Истина;
			Возврат;
		КонецЕсли; 
		Если Метаданные.ОбщиеМодули.Найти("ДополнительныеОтчетыИОбработки") = Неопределено Тогда
			ирОбщий.СообщитьЛкс("Подсистема БСП внедрена без блока дополнительных отчетов и обработок",,, Истина);
			Отказ = Истина;
			Возврат;
		КонецЕсли; 
		Элементы.ПерехватВнешнихОбработок.Видимость = Ложь;
	    _ДополнительныеОтчетыИОбработки = Вычислить("ДополнительныеОтчетыИОбработки");
			#Если Сервер И Не Сервер Тогда
			    _ДополнительныеОтчетыИОбработки = ДополнительныеОтчетыИОбработки;
			#КонецЕсли
		Попытка
			_ДополнительныеОтчетыИОбработки.ирПроверкаПодключенияРасширенияМодуля();
		Исключение
			ирОбщий.СообщитьЛкс("Необходимо адаптировать расширение командой ""Адаптация расширения"" в разделе ""Инструменты разработчика""/""Администрирование""",,, Истина);
			Отказ = Истина;
			Возврат;
		КонецПопытки; 
	ИначеЕсли ирКэш.НомерВерсииБСПЛкс() < 200 Тогда
		ирОбщий.СообщитьЛкс("Поддерживаются версии БСП 2.0 и выше. Обнаружена БСП версии """ + ирКэш.ВерсияБСПЛкс() + """",,, Истина);
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	Элементы.НадписьНеРаботаютТочкиОстанова.Видимость = ирКэш.НомерВерсииПлатформыЛкс() = 803006;
	ПрочитатьНастройкиНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиНаСервере()
	
	Обработчик = ирСервер.НайтиПерехватВнешнихОбработокБСПЛкс();
	ЭтаФорма.ПерехватВнешнихОбработок = Обработчик <> Неопределено;
	Если ПерехватВнешнихОбработок Тогда
		ЭтаФорма.КаталогФайловогоКэша = Обработчик.КаталогФайловогоКэша;
		ЭтаФорма.СозданиеВнешнихОбработокЧерезФайл = ХранилищеСистемныхНастроек.Загрузить("ирОтладкаВнешнихОбработок", "СозданиеВнешнихОбработокЧерезФайл");
		ОбновитьСписокНаСервере();
	Иначе
		ЭтаФорма.СозданиеВнешнихОбработокЧерезФайл = Ложь;
		СохранитьНастройкиПользователяНаСервере();
	КонецЕсли; 
	ОбновитьДоступность();

КонецПроцедуры

&НаКлиенте
Процедура СозданиеВнешнихОбработокЧерезФайлПриИзменении(Элемент)
	Если СозданиеВнешнихОбработокЧерезФайл Тогда
		Если ЭтаФорма.ПерехватВнешнихОбработок <> Истина Тогда 
			ЭтаФорма.ПерехватВнешнихОбработок = Истина;
			Если Не СохранитьНастройкиНаСервере() Тогда 
				Возврат;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	СохранитьНастройкиПользователяНаСервере();

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиПользователяНаСервере()
	
	ХранилищеСистемныхНастроек.Сохранить("ирОтладкаВнешнихОбработок", "СозданиеВнешнихОбработокЧерезФайл", СозданиеВнешнихОбработокЧерезФайл);

КонецПроцедуры

&НаКлиенте
Процедура КаталогФайловогоКэшаПриИзменении(Элемент = Неопределено)
	
	СохранитьНастройкиНаСервере();
	ОбновитьСписокНаСервере();
	
КонецПроцедуры

&НаСервере
Функция СохранитьНастройкиНаСервере()
	
	Если ПерехватВнешнихОбработок Тогда
		ФайлКаталога = Новый Файл(КаталогФайловогоКэша);
		Если Не ФайлКаталога.Существует() Тогда
			Сообщить("Выбранный каталог недоступен серверу. Выберите другой каталог");
			ПрочитатьНастройкиНаСервере();
			ЭтаФорма.СозданиеВнешнихОбработокЧерезФайл = Ложь;
			СохранитьНастройкиПользователяНаСервере();
			Возврат Ложь;
		КонецЕсли; 
		ирСервер.ВключитьПерехватВнешнихОбработокБСПЛкс(КаталогФайловогоКэша);
	Иначе
		ирСервер.НайтиПерехватВнешнихОбработокБСПЛкс(Истина);
	КонецЕсли; 
	//ПрочитатьНастройкиНаСервере();
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОбновитьСписокНаСервере()
	
	Список.Очистить();
	ОбновитьДоступность();
	Если Не ЗначениеЗаполнено(КаталогФайловогоКэша) Тогда
		Возврат;
	КонецЕсли; 
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	ДополнительныеОтчетыИОбработки.Ссылка КАК Ссылка,
				   |	ДополнительныеОтчетыИОбработки.ПометкаУдаления КАК ПометкаУдаления,
				   |	ДополнительныеОтчетыИОбработки.Версия КАК Версия,
				   |	ДополнительныеОтчетыИОбработки.ИмяФайла КАК ИмяФайла,
				   |	ДополнительныеОтчетыИОбработки.Публикация КАК Публикация
				   |ИЗ
				   |	Справочник.ДополнительныеОтчетыИОбработки КАК ДополнительныеОтчетыИОбработки
				   |ГДЕ ДополнительныеОтчетыИОбработки.ЭтоГруппа = ЛОЖЬ
				   |УПОРЯДОЧИТЬ ПО
				   |	Ссылка
				   |АВТОУПОРЯДОЧИВАНИЕ";
	Результат = Запрос.Выполнить().Выгрузить();
	СравнениеЗначений = Новый СравнениеЗначений;
	Для Каждого СтрокаРезультата Из Результат Цикл
		СтрокаТаблицы = Список.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаРезультата); 
		ПолноеИмяФайла = ирСервер.ПолноеИмяФайлаВнешнейОбработкиВФайловомКэшеЛкс(СтрокаТаблицы.Ссылка, КаталогФайловогоКэша);
		Файл = Новый Файл(ПолноеИмяФайла);
		СтрокаТаблицы.ИмяФайла = Файл.Имя;
		Если Файл.Существует() Тогда
			Попытка
				ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ПолноеИмяФайла);
			Исключение
				Сообщить("Ошибка доступа к файлу """ + ПолноеИмяФайла + """: " + ОписаниеОшибки());
				Продолжить;
			КонецПопытки; 
			СтрокаТаблицы.ДатаИзмененияФайла = Файл.ПолучитьВремяИзменения() + ирКэш.ПолучитьСмещениеВремениЛкс();
			СтрокаТаблицы.ФайлОтличаетсяОтХранилища = СравнениеЗначений.Сравнить(ДвоичныеДанныеФайла, СтрокаТаблицы.Ссылка.ХранилищеОбработки.Получить()) <> 0;
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступность()
	
	Элементы.ВнешниеОбработкиЗагрузитьИзФайла.Доступность = ЗначениеЗаполнено(КаталогФайловогоКэша);
	Элементы.ВнешниеОбработкиОткрытьВОтладчике.Доступность = ЗначениеЗаполнено(КаталогФайловогоКэша);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок(Команда = Неопределено)
	
	КлючСтроки = ирКлиент.ТабличноеПолеКлючСтрокиЛкс(Элементы.Список);
	ОбновитьСписокНаСервере();
	ирКлиент.ТабличноеПолеВосстановитьТекущуюСтрокуЛкс(Элементы.Список, КлючСтроки, Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВОтладчике(Команда)
	
	Если Не ирКэш.ЭтоТолстыйКлиентЛкс() Тогда 
		Сообщить("Функция доступна только в толстом клиенте");
		Возврат;
	КонецЕсли;  
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ПолноеИмяФайла = ирСервер.ПолноеИмяФайлаВнешнейОбработкиВФайловомКэшеЛкс(ТекущиеДанные.Ссылка, КаталогФайловогоКэша);
	Файл = Новый Файл(ПолноеИмяФайла);
	Если Не Файл.Существует() Тогда
		ТекущиеДанные.Ссылка.ХранилищеОбработки.Получить().Записать(ПолноеИмяФайла);
	КонецЕсли; 
	ирКэш.Получить().ОткрытьФайлВКонфигураторе(ПолноеИмяФайла, "Модуль");
	ОбновитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешниеОбработкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элемент.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерехватВнешнихОбработокПриИзменении(Элемент)
	
	Если Не ПерехватВнешнихОбработок Тогда
		ЭтаФорма.СозданиеВнешнихОбработокЧерезФайл = Ложь;
		СохранитьНастройкиПользователяНаСервере();
	КонецЕсли; 
	СохранитьНастройкиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьАктуальныеНастройки(Команда)
	
	ПрочитатьНастройкиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ирКэш.НомерВерсииБСПЛкс() >= 300 Тогда
		Форма = ПолучитьФорму("Справочник.ДополнительныеОтчетыИОбработки.ФормаОбъекта", Новый Структура("Ключ", ТекущиеДанные.Ссылка));
		ПолноеИмяФайла = ирСервер.ПолноеИмяФайлаВнешнейОбработкиВФайловомКэшеЛкс(ТекущиеДанные.Ссылка, КаталогФайловогоКэша);
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(ПолноеИмяФайла, ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПолноеИмяФайла)));
		Попытка
			Форма.ОбновитьИзФайлаПослеВыбораФайла(ОписаниеФайла, Новый Структура("АдресДанныхОбработки"));
			Форма.Записать();
			Если Форма.Открыта() Тогда
				Форма.Закрыть();
			КонецЕсли;
		Исключение
			Форма = Неопределено;
			ирОбщий.СообщитьЛкс(ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;
	Если Форма = Неопределено Тогда
		ЗагрузитьИзФайлаНаСервере(ТекущиеДанные.Ссылка, КаталогФайловогоКэша);
	КонецЕсли;
	ОбновитьСписок();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗагрузитьИзФайлаНаСервере(Ссылка, КаталогФайловогоКэша)
	
	#Если Сервер И Не Сервер Тогда
	    Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка();
	#КонецЕсли
	ПолноеИмяФайла = ирСервер.ПолноеИмяФайлаВнешнейОбработкиВФайловомКэшеЛкс(Ссылка, КаталогФайловогоКэша);
	Файл = Новый Файл(ПолноеИмяФайла);
	Если Не Файл.Существует() Тогда
		Возврат;
	КонецЕсли; 
	ЭтоОтчет = НРег(Файл.Расширение) = ".erf";
	Если ЭтоОтчет Тогда
		ОбъектМодуля = ВнешниеОтчеты.Создать(Файл.ПолноеИмя, Ложь);
	Иначе
		ОбъектМодуля = ВнешниеОбработки.Создать(Файл.ПолноеИмя, Ложь);
	КонецЕсли; 
	СведенияМодуля = ОбъектМодуля.СведенияОВнешнейОбработке();
	УстановитьПривилегированныйРежим(Истина);
	Объект = Ссылка.ПолучитьОбъект();
	Объект.Версия = СведенияМодуля.Версия;
	Объект.ХранилищеОбработки = Новый ХранилищеЗначения(Новый ДвоичныеДанные(Файл.ПолноеИмя));
	Объект.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогФайловогоКэшаОткрытие(Элемент, СтандартнаяОбработка)
	
	ЗапуститьПриложение(КаталогФайловогоКэша);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

&НаКлиенте
Процедура ЗаменитьФайлы(Команда)
	
	Ответ = Вопрос("Уверены, что хотите удалить выделенные файлы?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	Для Каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		СтрокаТаблицы = Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока);
		ПолноеИмяФайла = ирСервер.ПолноеИмяФайлаВнешнейОбработкиВФайловомКэшеЛкс(СтрокаТаблицы.Ссылка, КаталогФайловогоКэша);
		УдалитьФайлы(ПолноеИмяФайла); 
	КонецЦикла;
	ОбновитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОПодсистеме(Команда)
	
	ирКлиент.ОткрытьСправкуПоПодсистемеЛкс(ЭтаФорма);
	
КонецПроцедуры

