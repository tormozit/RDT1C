﻿
Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.ПересобратьТекст, Форма.ПереводитьСПотерейСинтаксиса, Форма.ПереводитьВМета, Форма.ПоказыватьРазмеры";
	Возврат Неопределено;
КонецФункции

Процедура КоманднаяПанель1КонсольЗапросов(Кнопка)
	
	Если Не ЗначениеЗаполнено(ЭлементыФормы.Результат.ПолучитьТекст()) Тогда
		ОбновитьЗапрос();
	КонецЕсли; 
	ТекстЗапроса = ЭлементыФормы.Результат.ПолучитьТекст();
	Если Не ЗначениеЗаполнено(ТекстЗапроса) Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоТекстSDBL И ПереводитьВМета Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапроса;
		Для Каждого СтрокаПараметра Из Параметры Цикл
			Запрос.Параметры.Вставить(СтрокаПараметра.Имя, СтрокаПараметра.Значение);
		КонецЦикла;
		ирОбщий.ОтладитьЛкс(Запрос);
	Иначе
		////СоединениеADO = ПодключенияИис.ПолучитьСоединениеADOПоСсылкеИис(Инфобаза.ИнфобазаСУБД,, Ложь);
		//СоединениеADO = Новый COMОбъект("ADODB.Connection");
		//ирОбщий.ОтладитьЛкс(СоединениеADO,, ТекстЗапроса);
		ирКлиент.ОткрытьЗапросСУБДЛкс(ТекстЗапроса,, Параметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанель1ОбновитьЗапрос(Кнопка)
	
	ОбновитьЗапрос();
	
КонецПроцедуры

Процедура ОбновитьЗапрос()
	
	ТипСУБДЛ = ТипСУБД;
	Если ЭтоТекстSDBL Тогда
		ТипСУБДЛ = "";
	КонецЕсли; 
	Индексы.Очистить();
	СтруктураЗапроса = СтруктураЗапросаИзТекстаБД(ЭлементыФормы.ТекстБД.ПолучитьТекст(), ТипСУБДЛ, ПересобратьТекст, ПереводитьСПотерейСинтаксиса, ПереводитьВМета);
	Граница1 = 0; Граница2 = 0; Граница3 = 0; Граница4 = 0;
	ЭлементыФормы.Результат.ПолучитьГраницыВыделения(Граница1, Граница2, Граница3, Граница4);
	ЭлементыФормы.Результат.УстановитьТекст(СтруктураЗапроса.Текст);
	ЭлементыФормы.Результат.УстановитьГраницыВыделения(Граница1, Граница2, Граница3, Граница4);
	Если ЗначениеЗаполнено(СтруктураЗапроса.Текст) Тогда
		ПанельОсновная = ЭлементыФормы.ПанельОсновная;
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(ПанельОсновная.ТекущаяСтраница, ПанельОсновная.Страницы.Результат);
	КонецЕсли; 
	ЭтаФорма.Параметры = СтруктураЗапроса.Параметры;
	ЭтаФорма.Таблицы.Очистить();
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(СтруктураЗапроса.Таблицы, ЭтаФорма.Таблицы);
	Если Таблицы.Количество() > 0 Тогда
		СтруктураХраненияБД = ирКэш.СтруктураХраненияБДЛкс(Не ЭтоТекстSDBL, мАдресЧужойСхемыБД);
		Если ПоказыватьРазмеры Тогда
			СтруктураХраненияСРазмерами = ирОбщий.СтруктураХраненияБДСРазмерамиЛкс();
		КонецЕсли;
		Для Каждого СтрокаТаблицыБД Из Таблицы Цикл
			СтрокаСтруктурыХрания = СтруктураХраненияБД.Найти(СтрокаТаблицыБД.ИмяБД, "КраткоеИмяТаблицыХранения");
			Если СтрокаСтруктурыХрания = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			СтрокаТаблицыБД.ИмяБД = СтрокаСтруктурыХрания.ИмяТаблицыХранения;
			Если ПоказыватьРазмеры Тогда 
				ОтборТаблицы = Новый Структура;
				Если ЭтоТекстSDBL Тогда
					ОтборТаблицы.Вставить("Назначение", СтрокаСтруктурыХрания.Назначение);
					ОтборТаблицы.Вставить("Метаданные", СтрокаСтруктурыХрания.Метаданные);
				Иначе
					ОтборТаблицы.Вставить("ИмяТаблицыХранения", СтрокаСтруктурыХрания.ИмяТаблицыХранения);
				КонецЕсли;
				СтрокаСтруктурыХрания = СтруктураХраненияСРазмерами.Таблицы.НайтиСтроки(ОтборТаблицы);
				Если СтрокаСтруктурыХрания.Количество() > 0 Тогда
					СтрокаСтруктурыХрания = СтрокаСтруктурыХрания[0];
					СтрокаТаблицыБД.КоличествоСтрок = СтрокаСтруктурыХрания.КоличествоСтрок;
					СтрокаТаблицыБД.ДанныеKB = СтрокаСтруктурыХрания.РазмерДанные;
					СтрокаТаблицыБД.ИндексыKB = СтрокаСтруктурыХрания.РазмерИндексы;
				КонецЕсли; 
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли Параметры.Количество() > 0 Тогда 
		ЭлементыФормы.ПанельВерхняя.ТекущаяСтраница = ЭлементыФормы.ПанельВерхняя.Страницы.Параметры;
	КонецЕсли; 
	ЭлементыФормы.Параметры.Колонки.ТипЗначения1С.ТолькоПросмотр = ЭтоТекстSDBL;

КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	ЭлементыФормы.Таблицы.Колонки.КоличествоСтрок.Видимость = Не ирКэш.ЛиФайловаяБазаЛкс();
	ЭтоТекстSDBLПриИзменении();
	ОбновитьЗапрос();
	ОбновитьДоступность();
	ПодключитьОбработчикОжидания("ОбновитьРазмерТекста", 2);
	
КонецПроцедуры

Процедура ПанельОсновнаяПриСменеСтраницы(Элемент = Неопределено, ТекущаяСтраница = Неопределено)
	
	Если Не ЗначениеЗаполнено(ЭлементыФормы.Результат.ПолучитьТекст()) Тогда
		Если ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.Результат Тогда
			ОбновитьЗапрос();
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПараметрыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Ложь
		ИЛи Колонка = Элемент.Колонки.Значение 
		ИЛи Колонка = Элемент.Колонки.Значение1С 
	Тогда
		ирКлиент.ОткрытьЗначениеЛкс(ВыбраннаяСтрока[Колонка.Данные]);
	Иначе
		Если Ложь
			Или Не ЗначениеЗаполнено(ВыбраннаяСтрока.Значение)
			Или Не ирКлиент.НайтиПоказатьФрагментВПолеТекстаЛкс(ЭтаФорма, ЭлементыФормы.Результат, ВыбраннаяСтрока.Значение, Истина) 
		Тогда 
			ирКлиент.НайтиПоказатьФрагментВПолеТекстаЛкс(ЭтаФорма, ЭлементыФормы.Результат, ВыбраннаяСтрока.Имя, Истина,,,,,, Истина);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирКлиент.Форма_ОбновлениеОтображенияЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ТаблицыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	КонтекстноеМенюТаблицНайтиВТексте();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ТипСУБДПриИзменении(Элемент)
	
	ОбновитьЗапрос();
	
КонецПроцедуры

Процедура КоманднаяПанель1НовоеОкно(Кнопка)
	
	Форма = ПолучитьФорму("КонверторТекстаСУБД",, Новый УникальныйИдентификатор);
	Форма.Открыть();

КонецПроцедуры

Процедура ДействияФормыВыполнить(Кнопка)

	ОбновитьЗапрос();
	//ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.Результат;
	
КонецПроцедуры

Процедура ОбновитьРазмерТекста()
	
	ЭтаФорма.КоличествоСимволов = СтрДлина(ЭлементыФормы.ТекстБД.ПолучитьТекст());
	
КонецПроцедуры

Процедура ЭтоТекстSDBLПриИзменении(Элемент = Неопределено)
	
	ЭлементыФормы.ТипСУБД.Доступность = Не ЭтоТекстSDBL;
	
КонецПроцедуры

Процедура НастроитьТехножурналПоТексту(Кнопка)
	
	ОткрытьНастройкуТехножурналаДляРегистрацииВыполненияЗапроса(ЭлементыФормы.ТекстБД.ПолучитьТекст(), ЭтоТекстSDBL, ТипСУБД);

КонецПроцедуры

Функция ПолучитьТекстДляПоискаВТехножурнале()
	
	Результат = ЭлементыФормы.ТекстБД.ПолучитьТекст();
	Если Не ЭтоТекстSDBL Тогда
		Результат = ПолучитьТекстSQLДляПоискаВТехножурнале(Результат);
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Процедура НайтиВТаблицеТехножурнала(Кнопка)
	
	Если ЭтоТекстSDBL Тогда
		ИмяЭлементаОтбора = "ТекстSDBL";
	Иначе
		ИмяЭлементаОтбора = "ТекстСУБД";
	КонецЕсли; 
	ТекстПоиска = ПолучитьТекстДляПоискаВТехножурнале();
	//ФормаЖурнала = ВладелецФормы;
	ФормаЖурнала = ПолучитьФорму();
	ФормаЖурнала.УстановитьРежимИтогов(Ложь);
	ФормаЖурнала.ЭлементыФормы.ТаблицаЖурнала.ОтборСтрок.Сбросить();
	ЭлементОтбора = ФормаЖурнала.ЭлементыФормы.ТаблицаЖурнала.ОтборСтрок[ИмяЭлементаОтбора];
	ЭлементОтбора.ВидСравнения = ВидСравнения.Содержит;
	ЭлементОтбора.Значение = ТекстПоиска;
	ЭлементОтбора.Использование = Истина;
	ФормаЖурнала.Открыть();

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирКлиент.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ТаблицыПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ТекущаяСтрокаТаблиц = ЭлементыФормы.Таблицы.ТекущаяСтрока;
	Индексы.Очистить();
	Если ТекущаяСтрокаТаблиц = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтруктуруХраненияБД = ирКэш.СтруктураХраненияБДЛкс(Не ЭтоТекстSDBL, мАдресЧужойСхемыБД);
	КлючПоиска = Новый Структура("КраткоеИмяТаблицыХранения", НРег(ТекущаяСтрокаТаблиц.ИмяБД));
	НайденныеСтроки = СтруктуруХраненияБД.НайтиСтроки(КлючПоиска);
	Если НайденныеСтроки.Количество() > 0 Тогда
		СтрокаТаблицыХранения = НайденныеСтроки[0];
		ирОбщий.ПеревестиКолонкиСтруктурыХраненияБДИндексыЛкс(СтрокаТаблицыХранения.Индексы);
		Для Каждого ИндексТаблицыБД Из СтрокаТаблицыХранения.Индексы Цикл
			ирОбщий.ПеревестиКолонкиСтруктурыХраненияБДПоляЛкс(ИндексТаблицыБД.Поля);
			СтрокаИндекса = Индексы.Добавить();
			СтрокаИндекса.ИндексМета = ирОбщий.ПредставлениеИндексаХраненияЛкс(ИндексТаблицыБД,, СтрокаТаблицыХранения, Ложь);
			СтрокаИндекса.ИндексБД = ирОбщий.ПредставлениеИндексаХраненияЛкс(ИндексТаблицыБД,, СтрокаТаблицыХранения, Истина);
			СтрокаИндекса.ИмяХранения = ИндексТаблицыБД.ИмяИндексаХранения;
		КонецЦикла;
		Индексы.Сортировать("ИндексМета");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ИндексыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ПоказатьСтруктуруХранения(ЭлементыФормы.Индексы.ТекущаяСтрока);

КонецПроцедуры

Процедура КоманднаяПанель1ПоказатьСтруктуруХранения(Кнопка)
	
	ПоказатьСтруктуруХранения();
	
КонецПроцедуры

Процедура ПоказатьСтруктуруХранения(Знач ТекущаяСтрокаИндексов = Неопределено)
	
	ТекущаяСтрокаТаблиц = ЭлементыФормы.Таблицы.ТекущаяСтрока;
	Если ТекущаяСтрокаТаблиц = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ТекущаяСтрокаИндексов <> Неопределено Тогда
		ПараметрИмяИндексаХранения = ТекущаяСтрокаИндексов.ИмяХранения;
	КонецЕсли;
	Форма = ирКлиент.ФормаСтруктурыХраненияТаблицыБДЛкс();
	Если ЗначениеЗаполнено(ТекущаяСтрокаТаблиц.ИмяМета) Тогда
		Форма.ПараметрИмяТаблицы = ТекущаяСтрокаТаблиц.ИмяМета;
	Иначе
		Форма.ПараметрИмяТаблицыХранения = ТекущаяСтрокаТаблиц.ИмяБД;
	КонецЕсли;
	Форма.ПараметрИмяИндексаХранения = ПараметрИмяИндексаХранения;
	Форма.ПараметрПоказыватьSDBL = ЭтоТекстSDBL;
	//Форма.ПараметрПоказыватьСУБД = Не ЭтоТекстSDBL;
	Форма.Открыть();

КонецПроцедуры

Процедура КонтекстноеМенюТаблицНайтиВТексте(Кнопка = Неопределено)
	
	ИмяСтраницы = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя;
	ТекущаяСтрока = ЭлементыФормы.Таблицы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СловоНайдено = ирКлиент.НайтиПоказатьФрагментВПолеТекстаЛкс(ЭтаФорма, ЭлементыФормы[ИмяСтраницы], ТекущаяСтрока.ИмяБД, Истина); 
	Если Не СловоНайдено Тогда
		СловоНайдено = ирКлиент.НайтиПоказатьФрагментВПолеТекстаЛкс(ЭтаФорма, ЭлементыФормы[ИмяСтраницы], ТекущаяСтрока.ИмяМета, Истина);
	КонецЕсли;
	Если Не СловоНайдено Тогда
		СловоНайдено = ирКлиент.НайтиПоказатьФрагментВПолеТекстаЛкс(ЭтаФорма, ЭлементыФормы[ИмяСтраницы], ТекущаяСтрока.ИмяБД, Истина, Истина); 
	КонецЕсли;
	Если Не СловоНайдено Тогда
		СловоНайдено = ирКлиент.НайтиПоказатьФрагментВПолеТекстаЛкс(ЭтаФорма, ЭлементыФормы[ИмяСтраницы], ТекущаяСтрока.ИмяМета, Истина, Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПереводитьВМетаПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ОбновитьДоступность()
	
	ЭлементыФормы.ПереводитьСПотерейСинтаксиса.Доступность = ПереводитьВМета;
	
КонецПроцедуры

Процедура ПослеВосстановленияЗначений()
	
	ОбновитьДоступность();

КонецПроцедуры

Процедура КонтекстноеМенюКонстантаНайтиВТексте(Кнопка)
	
	ИмяСтраницы = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя;
	ТекущаяСтрока = ЭлементыФормы.Параметры.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если Ложь
		Или Не ЗначениеЗаполнено(ТекущаяСтрока.Значение)
		Или Не ирКлиент.НайтиПоказатьФрагментВПолеТекстаЛкс(ЭтаФорма, ЭлементыФормы[ИмяСтраницы], ТекущаяСтрока.Значение, Истина) 
	Тогда 
		Если ПереводитьСПотерейСинтаксиса Тогда
			СтрокаПоиска = ТекущаяСтрока.Значение;
		Иначе
			СтрокаПоиска = ТекущаяСтрока.Имя;
		КонецЕсли; 
		ирКлиент.НайтиПоказатьФрагментВПолеТекстаЛкс(ЭтаФорма, ЭлементыФормы[ИмяСтраницы], СтрокаПоиска, Истина);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыСравнить(Кнопка)
	
	ирКлиент.ЗапомнитьСодержимоеЭлементаФормыДляСравненияЛкс(ЭтаФорма, ЭлементыФормы[ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя], "ЯзыкЗапросов");
	
КонецПроцедуры

Процедура ДействияФормыПараметрыСУБД(Кнопка)
	
	ирКлиент.ОткрытьФормуСоединенияСУБДЛкс();
	
КонецПроцедуры

Процедура ПараметрыПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ПараметрыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ТаблицыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт 
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ДействияФормыЗагрузитьИзФайла(Кнопка)
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Если Не ВыборФайла.Выбрать() Тогда
		Возврат;
	КонецЕсли;
	ЭлементыФормы.ТекстБД.УстановитьТекст(ирОбщий.ПрочитатьТекстИзФайлаЛкс(ВыборФайла.ПолноеИмяФайла));
КонецПроцедуры

Процедура КонтекстноеМенюКонстантРедакторОбъектаБД(Кнопка)
	ТекущаяСтрока = ЭлементыФормы.Параметры.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ирОбщий.ЛиСсылкаНаОбъектБДЛкс(ТекущаяСтрока.Значение1С) Тогда
		ирКлиент.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ТекущаяСтрока.Значение1С);
	КонецЕсли;
КонецПроцедуры

Процедура ПараметрыМетаданныеПриИзменении(Элемент = Неопределено)
	
	ТекущаяСтрока = ЭлементыФормы.Параметры.ТекущаяСтрока;
	УИД = мПлатформа.УникальныйИдентификаторИзСтроки(ТекущаяСтрока.Значение);
	ТекущаяСтрока.Значение1С = ирОбщий.ПолучитьМенеджерЛкс(ТекущаяСтрока.ТипЗначения1С.Типы()[0]).ПолучитьСсылку(УИД);
	
КонецПроцедуры

Процедура ПараметрыТипЗначения1СНачалоВыбора(Элемент, СтандартнаяОбработка)
	Если ирКлиент.ПолеВводаРасширенногоЗначения_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка) Тогда
		ПараметрыМетаданныеПриИзменении();
	КонецЕсли;
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализТехножурнала.Форма.КонверторТекстаСУБД");
ПереводитьВМета = Истина;
//ПереводитьСПотерейСинтаксиса = Истина;
ЭлементыФормы.ТипСУБД.СписокВыбора.Добавить("DBMSSQL");
ЭлементыФормы.ТипСУБД.СписокВыбора.Добавить("DBPOSTGRS");
ЭлементыФормы.ТипСУБД.СписокВыбора.Добавить("DB2");
ЭлементыФормы.ТипСУБД.СписокВыбора.Добавить("DBORACLE");
ЭлементыФормы.ТипСУБД.СписокВыбора.Добавить("DBV8DBENG");
Если ирКэш.ЛиФайловаяБазаЛкс() Тогда
	ТипСУБД = "DBV8DBENG";
Иначе
	ТипСУБД = "DBMSSQL";
КонецЕсли; 
