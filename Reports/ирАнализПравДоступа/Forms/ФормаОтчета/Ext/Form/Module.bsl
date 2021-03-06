﻿Перем ТаблицаПравСтарая;
Перем ПользовательСтарый;
Перем РольСтарый;
Перем ПолеОбъектаСтарый;
Перем ОбъектМетаданныхСтарый;
Перем СтарыйИспользоватьНаборПолей;
Перем СтарыйВычислятьФункциональныеОпции;
Перем СтарыйОтборПоПраву;
Перем СтарыйОтборПоДоступу;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Реквизит.ИзвлечьСвойстваРолей, Реквизит.ИспользоватьНаборПолей, Реквизит.ВычислятьФункциональныеОпции, Реквизит.НаборПолей, Реквизит.ОбъектМетаданных, Реквизит.ПолеОбъекта, Реквизит.Пользователь, Реквизит.Роль, Форма.Авторасшифровка";
	Результат = Новый Структура;
	Результат.Вставить("НастройкаКомпоновки", КомпоновщикНастроек.ПолучитьНастройки());
	Возврат Результат;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	Если ИспользоватьНаборПолей Тогда
		ЭлементыФормы.ПанельПараметровМетаданных.ТекущаяСтраница = ЭлементыФормы.ПанельПараметровМетаданных.Страницы.НаборПолей;
	Иначе
		ЭлементыФормы.ПанельПараметровМетаданных.ТекущаяСтраница = ЭлементыФормы.ПанельПараметровМетаданных.Страницы.ОбъектМетаданных;
	КонецЕсли; 
	Если НастройкаФормы <> Неопределено И НастройкаФормы.Свойство("НастройкаКомпоновки") Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкаФормы.НастройкаКомпоновки);
	КонецЕсли; 

КонецПроцедуры

Процедура ТабличныйДокументОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	ирОбщий.ОтчетКомпоновкиОбработкаРасшифровкиЛкс(ЭтаФорма, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры, Элемент, ДанныеРасшифровки, Авторасшифровка);
	
КонецПроцедуры

Процедура ДействиеРасшифровки(ВыбранноеДействие, ПараметрВыбранногоДействия, СтандартнаяОбработка) Экспорт
	
	Перем Пользователь, ОбъектМетаданных;
	#Если Сервер И Не Сервер Тогда
	    ПараметрВыбранногоДействия = Новый Соответствие;
	#КонецЕсли
	Если ВыбранноеДействие = "ОткрытьПользователя" Тогда
		Пользователь = ПараметрВыбранногоДействия["Пользователь"];
		ирОбщий.ОткрытьПользователяИБЛкс(Пользователь);
	ИначеЕсли ВыбранноеДействие = "ОткрытьОбъектМетаданных" Тогда
		ОбъектМетаданных = ПараметрВыбранногоДействия["ОбъектМетаданных"];
		ирОбщий.ОткрытьОбъектМетаданныхЛкс(ОбъектМетаданных);
	ИначеЕсли ВыбранноеДействие = "ОткрытьРедакторОбъектаБД" Тогда
		ОбъектМетаданных = ПараметрВыбранногоДействия["ОбъектМетаданных"];
		ирОбщий.ОткрытьРедакторОбъектаБДЛкс(ОбъектМетаданных, ПолеОбъекта);
	ИначеЕсли ВыбранноеДействие = "ОткрытьОграничениеДоступа" Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ТаблицаБД", ПараметрВыбранногоДействия["ОбъектМетаданных"]);
		СтруктураПараметров.Вставить("Роль", ПараметрВыбранногоДействия["Роль"]);
		СтруктураПараметров.Вставить("Право", ирОбщий.ПоследнийФрагментЛкс(ПараметрВыбранногоДействия["Право"], "."));
		Если Не ЗначениеЗаполнено(СтруктураПараметров.Роль) Тогда
			Сообщить("Для открытия ограничения доступа необходима группировка либо отбор на равенство по роли");
			Возврат;
		КонецЕсли; 
		Если Не ЗначениеЗаполнено(СтруктураПараметров.ТаблицаБД) Тогда
			Сообщить("Для открытия ограничения доступа необходима группировка либо отбор на равенство по объекту метаданных");
			Возврат;
		КонецЕсли; 
		Если Не ЗначениеЗаполнено(СтруктураПараметров.Право) Тогда
			Сообщить("Для открытия ограничения доступа необходима группировка либо отбор на равенство по праву");
			Возврат;
		КонецЕсли; 
		ФормаОграниченияДоступа = ирОбщий.ПолучитьФормуЛкс("Обработка.ирРедакторОграниченияДоступа.Форма",,, ЗначениеВСтрокуВнутр(СтруктураПараметров));
		ЗаполнитьЗначенияСвойств(ФормаОграниченияДоступа, СтруктураПараметров); 
		ФормаОграниченияДоступа.Открыть();
	ИначеЕсли ВыбранноеДействие = "ОткрытьФункциональныеОпции" Тогда
		ОбъектМетаданных = ирКэш.ОбъектМДПоПолномуИмениЛкс(ПараметрВыбранногоДействия["ОбъектМетаданных"]);
		Если ЗначениеЗаполнено(ПараметрВыбранногоДействия["ТабличнаяЧасть"]) Тогда
			МетаТЧ = ОбъектМетаданных.ТабличныеЧасти.Найти(ПараметрВыбранногоДействия["ТабличнаяЧасть"]);
			Если МетаТЧ <> Неопределено Тогда
				ОбъектМетаданных = МетаТЧ;
			КонецЕсли; 
		КонецЕсли; 
		Если ЗначениеЗаполнено(ПараметрВыбранногоДействия["Поле"]) Тогда
			ОбъектМетаданных = ирОбщий.ДочернийОбъектМДПоИмениЛкс(ОбъектМетаданных, ПараметрВыбранногоДействия["Поле"]);
		КонецЕсли; 
		ЗначенияФункОпций = Неопределено;
		ирОбщий.ФункциональныеОпцииОбъектаМДЛкс(ОбъектМетаданных, ЗначенияФункОпций);
		мПлатформа = ирКэш.Получить();
		#Если Сервер И Не Сервер Тогда
			мПлатформа = Обработки.ирПлатформа.Создать();
		#КонецЕсли
		ФормаПросмотра = мПлатформа.ПолучитьФорму("ЗначенияФункциональныхОпций", , ОбъектМетаданных.ПолноеИмя());
		ФормаПросмотра.НачальноеЗначениеВыбора = ЗначенияФункОпций;
		ФормаПросмотра.Открыть();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаРасшифровки(ДанныеРасшифровки, ЭлементРасшифровки, ТабличныйДокумент, ДоступныеДействия, СписокДополнительныхДействий, РазрешитьАвтовыборДействия, ЗначенияВсехПолей) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
		ЭлементРасшифровки = ДанныеРасшифровки.Элементы[0];
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ДоступныеДействия = Новый Массив;
		СписокДополнительныхДействий = Новый СписокЗначений;
	#КонецЕсли
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Отфильтровать);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Оформить);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Сгруппировать);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Упорядочить);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Расшифровать);
	ЗначенияПолей = ЭлементРасшифровки.ПолучитьПоля();
	Если ЗначенияПолей.Найти("Пользователь") <> Неопределено Тогда 
		СписокДополнительныхДействий.Вставить(0, "ОткрытьПользователя", "Открыть пользователя",, ирКэш.КартинкаПоИмениЛкс("ирПользователь"));
	КонецЕсли; 
	Если ЗначенияПолей.Найти("ОбъектМетаданных") <> Неопределено Тогда 
		СписокДополнительныхДействий.Вставить(0, "ОткрытьОбъектМетаданных", "Открыть объект метаданных",, ирКэш.КартинкаИнструментаЛкс("Обработка.ирИнтерфейснаяПанель"));
		СписокДополнительныхДействий.Вставить(0, "ОткрытьРедакторОбъектаБД", "Открыть редактор объекта БД",, ирКэш.КартинкаИнструментаЛкс("Обработка.ирРедакторОбъектаБД"));
	КонецЕсли; 
	Если Истина
		И ЗначенияПолей.Найти("Доступ") <> Неопределено 
		И Найти(ЗначенияПолей.Найти("Доступ").Значение, "да") = 1 
	Тогда 
		Если Ложь
			Или ЗначенияВсехПолей["Право"] = Неопределено
			Или ирОбщий.ПраваСОграничениямиДоступаКДаннымЛкс().НайтиПоЗначению(ирОбщий.ПоследнийФрагментЛкс(ЗначенияВсехПолей["Право"], ".")) <> Неопределено 
		Тогда 
			СписокДополнительныхДействий.Вставить(0, "ОткрытьОграничениеДоступа", "Открыть ограничение доступа",, ирКэш.КартинкаИнструментаЛкс("Обработка.ирРедакторОграниченияДоступа"));
		КонецЕсли; 
	КонецЕсли; 
	Если Истина
		И ЗначенияПолей.Найти("ФункциональнаяОпция.Включена") <> Неопределено 
		И ТипЗнч(ЗначенияПолей.Найти("ФункциональнаяОпция.Включена").Значение) = Тип("Булево")
	Тогда 
		СписокДополнительныхДействий.Вставить(0, "ОткрытьФункциональныеОпции", "Открыть функциональные опции",, ирКэш.КартинкаПоИмениЛкс("ирФункциональнаяОпция"));
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	СхемаКомпоновкиДанных.НаборыДанных.Основной.Поля.Найти("Право").УстановитьДоступныеЗначения(ДоступныеПрава(Ложь));
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	ЗагрузитьНастройкуПоУмолчанию = Истина
		И Не ЗначениеЗаполнено(ОбъектМетаданных)
		И Не ЗначениеЗаполнено(ПолеОбъекта)
		И Не ЗначениеЗаполнено(Пользователь)
		И Не ЗначениеЗаполнено(Роль)
		И НаборПолей.Количество() = 0;
	ЭтотОбъект.ИспользоватьНаборПолей = НаборПолей.Количество() > 0;
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма,, ЗагрузитьНастройкуПоУмолчанию);
	КнопкиПодменю = ЭлементыФормы.ДействияФормы.Кнопки.Варианты.Кнопки;
	Для Каждого ВариантНастроек Из СхемаКомпоновкиДанных.ВариантыНастроек Цикл
		Кнопка = КнопкиПодменю.Добавить();
		Кнопка.ТипКнопки = ТипКнопкиКоманднойПанели.Действие;
		Кнопка.Имя = ВариантНастроек.Имя;
		Кнопка.Текст = ВариантНастроек.Представление;
		Кнопка.Действие = Новый Действие("КнопкаВариантаНастроек");
	КонецЦикла;
	Если ЗначениеЗаполнено(ПараметрКлючВарианта) Тогда
		ЗагрузитьВариант(ПараметрКлючВарианта);
	КонецЕсли;
	Если ПараметрТолькоПравоПросмотр Тогда
		СписокПрав = Новый СписокЗначений;
		//СписокПрав.Добавить("2.Просмотр");
		СписокПрав.Добавить("Просмотр");
		СписокПрав.Добавить("");
		ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КомпоновщикНастроек.Настройки.Отбор, "Право", СписокПрав, ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЕсли; 
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(ЭлементыФормы.Пользователь, ЭтаФорма);
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(ЭлементыФормы.Роль, ЭтаФорма);
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(ЭлементыФормы.ОбъектМетаданных, ЭтаФорма);

КонецПроцедуры

Процедура КнопкаВариантаНастроек(Кнопка)
	
	ЗагрузитьВариант(Кнопка.Имя);
	
КонецПроцедуры

Процедура ЗагрузитьВариант(Знач ИмяВарианта) 
	
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек[ИмяВарианта].Настройки);

КонецПроцедуры

Функция РеквизитыДляСервера(Параметры) Экспорт 
	
	Результат = ирОбщий.РеквизитыОбработкиЛкс(ЭтотОбъект);
	#Если Сервер И Не Сервер Тогда
		Результат = Новый Структура;
	#КонецЕсли
	Результат.Вставить("НаборПолейТаблица", НаборПолейТаблица.Выгрузить());
	Возврат Результат;
	
КонецФункции

Процедура ДействияФормыСформировать(Кнопка = Неопределено) Экспорт 
	
	ЭтотОбъект.РежимОтладки = 0;
	ЭтотОбъект.ИспользоватьНаборПолей = ЭлементыФормы.ПанельПараметровМетаданных.ТекущаяСтраница = ЭлементыФормы.ПанельПараметровМетаданных.Страницы.НаборПолей;
	Если ИспользоватьНаборПолей И НаборПолей.Количество() = 0 Тогда
		ирОбщий.СообщитьЛкс("Необходимо заполнить набор полей", СтатусСообщения.Внимание);
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.НаборПолей;
		Возврат;
	КонецЕсли; 
	#Если _ Тогда
		СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
		КонечнаяНастройка = Новый НастройкиКомпоновкиДанных;
		ВнешниеНаборыДанных = Новый Структура;
		ДокументРезультат = Новый ТабличныйДокумент;
	#КонецЕсли
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Роль) Тогда
		Роли = Новый Массив;
		МетаРоль = Метаданные.Роли.Найти(Роль);
		Если МетаРоль <> Неопределено Тогда
			Роли.Добавить(МетаРоль);
		Иначе
			Сообщить("Роль """ + Роль + """ не найдена в метаданных");
			Возврат;
		КонецЕсли; 
	ИначеЕсли ЗначениеЗаполнено(Пользователь) Тогда
		Если Пользователь = ИмяПользователя() Тогда
			ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
		Иначе
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(Пользователь);
		КонецЕсли; 
		Если ПользовательИБ = Неопределено Тогда
			Сообщить("Пользователь с именем """ + Пользователь + """ не найден", СтатусСообщения.Внимание);
			Возврат;
		КонецЕсли; 
		Роли = ПользовательИБ.Роли;
	Иначе
		Роли = Метаданные.Роли;
	КонецЕсли;
	ИменаРолей = Новый Массив;
	Для Каждого РольЦикл Из Роли Цикл
		ИменаРолей.Добавить(РольЦикл.Имя);
	КонецЦикла;
	Если ИспользоватьНаборПолей Тогда
		НаборПолейТаблица.Очистить();
		Для Каждого ЭлементСписка Из НаборПолей Цикл
			СтрокаПоля = НаборПолейТаблица.Добавить();
			СтрокаПоля.ПолеПолноеИмя = ЭлементСписка.Значение;
			СтрокаПоля.ОбъектМДПолноеИмя = ирОбщий.СтрокаБезПоследнегоФрагментаЛкс(СтрокаПоля.ПолеПолноеИмя);
			ТипТаблицы = ирОбщий.ТипТаблицыБДЛкс(СтрокаПоля.ОбъектМДПолноеИмя);
			Если ирОбщий.ЛиТипВложеннойТаблицыБДЛкс(ТипТаблицы) Тогда
				СтрокаПоля.ТабличнаяЧасть = ирОбщий.ПоследнийФрагментЛкс(СтрокаПоля.ОбъектМДПолноеИмя);
				СтрокаПоля.ОбъектМДПолноеИмя = ирОбщий.СтрокаБезПоследнегоФрагментаЛкс(СтрокаПоля.ОбъектМДПолноеИмя);
			КонецЕсли; 
			СтрокаПоля.Поле = ирОбщий.ПоследнийФрагментЛкс(СтрокаПоля.ПолеПолноеИмя);
		КонецЦикла;
	КонецЕсли;
	ОтборПоПраву = ирОбщий.НайтиЭлементОтбораЛкс(КомпоновщикНастроек.Настройки.Отбор, "Право",,,,, Истина);
	ОтборПоДоступу = ирОбщий.НайтиЭлементОтбораЛкс(КомпоновщикНастроек.Настройки.Отбор, "Доступ",,,,, Истина);
	Если Ложь
		Или ТаблицаПравСтарая = Неопределено 
		Или ИспользоватьНаборПолей <> СтарыйИспользоватьНаборПолей
		Или ВычислятьФункциональныеОпции И ВычислятьФункциональныеОпции <> СтарыйВычислятьФункциональныеОпции
		Или (Истина
			И СтарыйОтборПоПраву <> Неопределено 
			И (Ложь
				Или ОтборПоПраву = Неопределено
				Или ОтборПоПраву.ПравоеЗначение <> СтарыйОтборПоПраву.ПравоеЗначение
				Или ОтборПоПраву.ВидСравнения <> СтарыйОтборПоПраву.ВидСравнения))
		Или (Истина
			И СтарыйОтборПоДоступу <> Неопределено 
			И (Ложь
				Или ОтборПоДоступу = Неопределено
				Или ОтборПоДоступу.ПравоеЗначение <> СтарыйОтборПоДоступу.ПравоеЗначение
				Или ОтборПоДоступу.ВидСравнения <> СтарыйОтборПоДоступу.ВидСравнения))
		Или (Истина
			И ЗначениеЗаполнено(ОбъектМетаданныхСтарый)
			И ОбъектМетаданных <> ОбъектМетаданныхСтарый) 
		Или (Истина
			//И ЗначениеЗаполнено(ПолеОбъектаСтарый)
			И ПолеОбъекта <> ПолеОбъектаСтарый) 
		Или (Истина
			И ЗначениеЗаполнено(ПользовательСтарый)
			И Пользователь <> ПользовательСтарый) 
		Или (Истина
			И ЗначениеЗаполнено(РольСтарый)
			И Роль <> РольСтарый) 
	Тогда
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИменаРолей", ИменаРолей);
		ПараметрыЗадания.Вставить("КонечныеНастройки", КомпоновщикНастроек.ПолучитьНастройки());
		#Если Сервер И Не Сервер Тогда
			ВычислитьПрава();
			СформироватьЗавершение();
		#КонецЕсли
		ирОбщий.ВыполнитьЗаданиеФормыЛкс("ВычислитьПрава", ПараметрыЗадания, ЭтаФорма, "Сформировать",, ЭлементыФормы.ДействияФормы.Кнопки.Сформировать, "СформироватьЗавершение",,, Истина);
	Иначе
		СкомпоноватьРезультатПоГотовымТаблицам();
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		ТаблицаПрав = РезультатЗадания.ТаблицаПрав;
		ФункциональныеОпцииПолей.Загрузить(РезультатЗадания.ФункциональныеОпцииПолей);
		ОбъектыМетаданных.Загрузить(РезультатЗадания.ОбъектыМетаданных);
		ТабличныеЧасти.Загрузить(РезультатЗадания.ТабличныеЧасти);
		ПоляМетаданных.Загрузить(РезультатЗадания.ПоляМетаданных);
		
		ПользовательСтарый = Пользователь;
		РольСтарый = Роль;
		Если ИспользоватьНаборПолей Тогда
			ОбъектМетаданныхСтарый = Неопределено;
		Иначе
			ОбъектМетаданныхСтарый = ОбъектМетаданных;
		КонецЕсли;
		ПолеОбъектаСтарый = ПолеОбъекта;
		ТаблицаПравСтарая = ТаблицаПрав;
		СтарыйИспользоватьНаборПолей = ИспользоватьНаборПолей;
		СтарыйВычислятьФункциональныеОпции = ВычислятьФункциональныеОпции;
		СтарыйОтборПоПраву = ирОбщий.НайтиЭлементОтбораЛкс(РезультатЗадания.КонечныеНастройки.Отбор, "Право",,,,, Истина);
		СтарыйОтборПоДоступу = ирОбщий.НайтиЭлементОтбораЛкс(РезультатЗадания.КонечныеНастройки.Отбор, "Доступ",,,,, Истина);
		
		СкомпоноватьРезультатПоГотовымТаблицам();
	КонецЕсли; 

КонецПроцедуры

Процедура СкомпоноватьРезультатПоГотовымТаблицам()
	
	СкомпоноватьРезультат(ЭлементыФормы.ТабличныйДокумент, ДанныеРасшифровки);
	//ЭлементыФормы.ТабличныйДокумент.ПоказатьУровеньГруппировокСтрок(0);

КонецПроцедуры

// Предопределеный метод
Процедура ПроверкаЗавершенияФоновыхЗаданий() Экспорт 
	
	ирОбщий.ПроверитьЗавершениеФоновыхЗаданийФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыКопия(Кнопка)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Вывести(ЭлементыФормы.ТабличныйДокумент);
	ЗаполнитьЗначенияСвойств(ТабличныйДокумент, ЭлементыФормы.ТабличныйДокумент); 
	Результат = ирОбщий.ОткрытьЗначениеЛкс(ТабличныйДокумент,,,, Ложь);

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ДействияФормыИсполняемаяКомпоновка(Кнопка)
	
	РежимОтладки = 2;
	СкомпоноватьРезультат(ЭлементыФормы.ТабличныйДокумент, ДанныеРасшифровки);
	
КонецПроцедуры

Процедура ПользовательНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ПользовательПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ПользовательНачалоВыбора(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаПользователя_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбъектМетаданныхПриИзменении(Элемент)
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ОбъектМетаданныхНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ОбъектМетаданныхНачалоВыбора(Элемент, СтандартнаяОбработка)
	ирОбщий.ОбъектМетаданныхНачалоВыбораЛкс(Элемент, ПараметрыВыбораОбъектаМетаданных(), СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбъектМетаданныхОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	ирОбщий.ОбъектМетаданныхОкончаниеВводаТекстаЛкс(Элемент, ПараметрыВыбораОбъектаМетаданных(), Текст, Значение, СтандартнаяОбработка);
КонецПроцедуры

Функция ПараметрыВыбораОбъектаМетаданных()
	Возврат ирОбщий.ПараметрыВыбораОбъектаМетаданныхЛкс(Истина, Истина, Истина, Истина, Истина,,, Истина,,,, Истина, Истина);
КонецФункции

Процедура ДействияФормыОграничениеДоступаКДанным(Кнопка)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ТаблицаБД", ОбъектМетаданных);
	СтруктураПараметров.Вставить("Роль", Роль);
	ФормаОграниченияДоступа = ирОбщий.ПолучитьФормуЛкс("Обработка.ирРедакторОграниченияДоступа.Форма",,, ЗначениеВСтрокуВнутр(СтруктураПараметров));
	ЗаполнитьЗначенияСвойств(ФормаОграниченияДоступа, СтруктураПараметров); 
	ФормаОграниченияДоступа.Открыть();
		
КонецПроцедуры

Процедура РольПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура РольНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаРоли_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура РольНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ПорядокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ТабличноеПолеПорядкаКомпоновкиВыборЛкс(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыКэшРолей(Кнопка)
	
	ирОбщий.ОткрытьФормуЛкс("Обработка.ирРедакторОграниченияДоступа.Форма.КэшРолей");
	
КонецПроцедуры

Процедура ПолеОбъектаПриИзменении(Элемент)
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ПолеОбъектаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ПолеОбъектаНачалоВыбора(Элемент, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(ОбъектМетаданных) Тогда
		Возврат;
	КонецЕсли;
	ПоляТаблицы = ирКэш.ПоляТаблицыБДЛкс(ирКэш.ИмяТаблицыИзМетаданныхЛкс(ОбъектМетаданных));
	#Если Сервер И Не Сервер Тогда
		ПоляТаблицы = Новый ТаблицаЗначений;
	#КонецЕсли
	РезультатВыбора = ирОбщий.ВыбратьСтрокуТаблицыЗначенийЛкс(ПоляТаблицы, ПоляТаблицы.Найти(ПолеОбъекта, "Имя"),, "Выберите поле");
	Если РезультатВыбора <> Неопределено Тогда
		ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(ЭлементыФормы.ПолеОбъекта, РезультатВыбора.Имя);
	КонецЕсли; 
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура НаборПолейНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ФормаВыбора = ирОбщий.ФормаВыбораКолонокБДЛкс(ЭтаФорма, Элемент.Значение.ВыгрузитьЗначения());
	РезультатФормы = ФормаВыбора.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		Элемент.Значение.ЗагрузитьЗначения(РезультатФормы.ВыгрузитьКолонку("ПолноеИмяКолонки"));
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Отчет.ирАнализПравДоступа.Форма.ФормаОтчета");
ЭтаФорма.Авторасшифровка = Истина;
//ЭтаФорма.ВычислятьФункциональныеОпции = Истина; // Очень долго при большом числе опций
