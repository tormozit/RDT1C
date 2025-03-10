﻿Перем мОтказОтЗакрытия;
Перем мТекущийШаблон;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Реквизит.ВариантРасположенияФайлаНастроек, Реквизит.КаталогНастройки, Реквизит.ЛиТолькоПомеченныеСобытия, Реквизит.НаСервере, Реквизит.ОсновнойКаталогДампов,
	|Реквизит.ОсновнойКаталогЖурнала, Реквизит.УстанавливатьОсновныеКаталоги";
	Возврат Неопределено;
КонецФункции

Процедура СохранитьШаблон(Знач Представление, Знач Описание = "")
	
	Если Не ЗначениеЗаполнено(Описание) Тогда
		Описание = "Сохранен " + ТекущаяДата();
	КонецЕсли;
	ИмяШаблона = ирОбщий.ИдентификаторИзПредставленияЛкс(Представление);
	СписокВыбораШаблона = ЗаполнитьСписокВыбораШаблона();
	ИмяШаблона = ирОбщий.АвтоУникальноеИмяВКоллекцииЛкс(СписокВыбораШаблона, ИмяШаблона);
	ДокументДОМ = ДокументДОМ();
	
	Элемент = СоздатьЭлементДОМ("draft");
	Шаблон = ДокументДОМ.ПервыйДочерний.ДобавитьДочерний(Элемент);
	
	Элемент = СоздатьЭлементДОМ("presentation");
	Предст = Шаблон.ДобавитьДочерний(Элемент);
	Предст.ТекстовоеСодержимое = Представление;
	                                       
	Элемент = СоздатьЭлементДОМ("description");
	Опис = Шаблон.ДобавитьДочерний(Элемент);
	Опис.ТекстовоеСодержимое = Описание;
	
	лИмяФайла = ПолучитьИмяФайлаШаблона(ИмяШаблона);
	ЗаписатьДОМ(ДокументДОМ, лИмяФайла);
	Сообщить("Шаблон """ + ИмяШаблона + """ сохранен в файл """ + лИмяФайла + """");
	ДобавитьОписаниеШаблона(ИмяШаблона, Описание);
	
КонецПроцедуры

// Инициализация формы
//
Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	мОтказОтЗакрытия = Ложь;
	
	// Если нет подкаталога conf, создадим его
	ПолучитьКаталогНастроекПриложения(, Истина);
	ИмяСервера = ирСервер.ИмяКомпьютераЛкс();
	ЭлементыФормы.ФлажокНаСервере.Доступность = Истина
		И Не ирКэш.ЛиФайловаяБазаЛкс()
		//И (Ложь
		//	Или Не ирКэш.ЛиПортативныйРежимЛкс() 
		//	//Или ирПортативный.ЛиСерверныйМодульДоступенЛкс()
		//	//Или ирОбщий.СтрокиРавныЛкс(ИмяСервера, ИмяКомпьютера())
		//	)
		;
	Если Не ЭлементыФормы.ФлажокНаСервере.Доступность Тогда
		ЭтотОбъект.НаСервере = Ложь;
	КонецЕсли; 
	Если Не ирКэш.ЛиФайловаяБазаЛкс() Тогда 
		ЭлементыФормы.ФлажокНаСервере.Заголовок = "На сервере " + ИмяСервера;
	КонецЕсли; 
	ВариантРасположенияФайлаНастроекПриИзменении(Неопределено);
	Если Истина
		И ВариантРасположенияФайлаНастроек = мВариантыРасположенияФайла.АктивныйФайл 
		И Не ЗначениеЗаполнено(ПолноеИмяФайлаНастройки)
	Тогда
		ВариантРасположенияФайлаНастроек = мВариантыРасположенияФайла.ДляТекущегоПользователя;
		ВариантРасположенияФайлаНастроекПриИзменении(Неопределено);
	КонецЕсли; 
	
	Если ТипДампа = 0 Тогда
		ПолеСпискаФлагиДампа.Добавить("0", "Минимальный", Истина);
	Иначе
		ПолеСпискаФлагиДампа.Добавить("0", "Минимальный", Ложь);
	КонецЕсли;
	ПолеСпискаФлагиДампа.Добавить("1", "Сегмент данных", ПроверитьБитЛкс(1, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("2", "Содержимое всей памяти процесса", ПроверитьБитЛкс(2, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("4", "Данные дескрипторов", ПроверитьБитЛкс(3, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("8", "Только информация, необходимая для восстановления стека вызовов", ПроверитьБитЛкс(4, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("16", "Ссылки на память модулей в стеке", ПроверитьБитЛкс(5, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("32", "Дамп памяти из-под выгруженных модулей", ПроверитьБитЛкс(6, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("64", "Дамп памяти, на которую есть ссылки", ПроверитьБитЛкс(7, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("128", "Подробная информация о файлах модулей", ПроверитьБитЛкс(8, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("256", "Локальные данные потоков", ПроверитьБитЛкс(9, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("512", "Память из всего доступного виртуального адресного пространства", ПроверитьБитЛкс(10, ТипДампа));
		
КонецПроцедуры

// Закрыть все возможно открытые формы, связанные с главной формой
//
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		ирКлиент.ПередОтображениемДиалогаПередЗакрытиемФормыЛкс(ЭтаФорма);
		Ответ = Вопрос("Сохранить изменения?",
					   РежимДиалогаВопрос.ДаНетОтмена,, КодВозвратаДиалога.Да);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
			мОтказОтЗакрытия = Истина;
			Возврат;
		КонецЕсли;   
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Если Не СохранитьВФорме() Тогда
				Отказ = Истина;
			КонецЕсли; ;
		КонецЕсли;
	Иначе
		мОтказОтЗакрытия = Ложь;
	КонецЕсли;
	// Закрываем возможно открытые формы, связанные с главной формой
	Форма = ОбработкаОбъект.ПолучитьФорму("НастройкаКаталога", ЭтаФорма);
	Если Форма.Открыта() Тогда
		Форма.Закрыть();
	КонецЕсли;
		
КонецПроцедуры

// Сохранить настройки технологического журнала
//
Процедура КнопкаСохранитьНажатие(Элемент = Неопределено)
	
	СохранитьВФорме();
	
КонецПроцедуры

Функция СохранитьВФорме()
	
	// Проверка настройки
	НеуникальныйКаталог = "";
	РазныеКаталоги = Новый Соответствие();
	Для Каждого СтрокаЖурнала Из ТабличноеПолеЖурналы Цикл
		Если РазныеКаталоги[СтрокаЖурнала.Местоположение] = 1 Тогда
			НеуникальныйКаталог = СтрокаЖурнала.Местоположение;
			Прервать;
		КонецЕсли; 
		РазныеКаталоги[СтрокаЖурнала.Местоположение] = 1;
	КонецЦикла;
	Если СоздаватьДамп Тогда
		Если Не ПустаяСтрока(РасположениеДампа) Тогда
			Если РазныеКаталоги[РасположениеДампа] = 1 Тогда
				НеуникальныйКаталог = РасположениеДампа;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	Если Не ПустаяСтрока(КаталогСистемногоЖурнала) Тогда
		Если РазныеКаталоги[КаталогСистемногоЖурнала] = 1 Тогда
			НеуникальныйКаталог = КаталогСистемногоЖурнала;
		КонецЕсли; 
	КонецЕсли; 
	Если НЕ ПустаяСтрока(НеуникальныйКаталог) Тогда
		Предупреждение("Каталог """ + НеуникальныйКаталог + """ указан в настройке более одного раза. Сохранение невозможно", 20);
		Возврат Ложь;
	КонецЕсли; 
	Если РазныеКаталоги[""] = 1 Тогда
		Предупреждение("Для журналов не допускается указание пустых каталогов. Сохранение невозможно", 20);
		Возврат Ложь;
	КонецЕсли; 
	Для Каждого СтрокаЖурнала Из ТабличноеПолеЖурналы Цикл
		Если ПустаяСтрока(СтрокаЖурнала.События) Тогда 
			ЭлементыФормы.ТабличноеПолеЖурналы.ТекущаяСтрока = СтрокаЖурнала;
			Предупреждение("Для журнала """ + СтрокаЖурнала.Местоположение + """ не задано условие регистрации событий. Сохранение невозможно", 20);
			Возврат Ложь;
		КонецЕсли; 
	КонецЦикла;
	ЗаписатьКонфигурационныйXML();
	Модифицированность = Ложь;
	ОтключитьБолееПриоритетныеФайлы();
	ПриИзмененииПравилаПолученияФайлаНастройки();
	Возврат Истина;
	
КонецФункции

Процедура ОтключитьБолееПриоритетныеФайлы(ОтключитьВсе = Ложь)
	
	СписокВыбораВарианта = мСписокВариантовРасположенияКонфигурационногоФайла;
	Если ОтключитьВсе Тогда
		ИмяВыбранногоФайла = "";
		ИндексТекущегоВарианта = СписокВыбораВарианта.Количество();
	Иначе
		ИмяВыбранногоФайла = ПолучитьПолноеИмяКонфигурационногоФайла();
		ИндексТекущегоВарианта = СписокВыбораВарианта.Индекс(СписокВыбораВарианта.НайтиПоЗначению(ВариантРасположенияФайлаНастроек));
	КонецЕсли; 
	Для Индекс = 0 По ИндексТекущегоВарианта - 1 Цикл
		ИмяВарианта = СписокВыбораВарианта[Индекс].Значение;
		Если ИмяВарианта = мВариантыРасположенияФайла.АктивныйФайл Тогда
			Продолжить;
		КонецЕсли; 
		ИмяФайлаНастройки = ПолучитьКаталогНастроекПриложения(ИмяВарианта) + "\logcfg.xml";
		Если Не ирОбщий.СтрокиРавныЛкс(ИмяВыбранногоФайла, ИмяФайлаНастройки) Тогда
			ФайлСуществует = ЛиФайлСуществует(ИмяФайлаНастройки);
			Если ФайлСуществует Тогда
				ФайлИндивидуальнойНастройки = Новый Файл(ИмяФайлаНастройки);
				КраткоеИмяФайлаШаблона = ФайлИндивидуальнойНастройки.ИмяБезРасширения + ".bak";
				ПолноеИмяФайлаШаблона = ФайлИндивидуальнойНастройки.Путь + КраткоеИмяФайлаШаблона;
				мПереместитьФайл(ФайлИндивидуальнойНастройки.ПолноеИмя, ПолноеИмяФайлаШаблона);
				ирОбщий.СообщитьЛкс("Файл настройки техножурнала """ + ИмяФайлаНастройки + """ отключен (переименован в """ + КраткоеИмяФайлаШаблона + """)");
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

// Обновить состояние главной формы
//
Процедура КнопкаОбновитьНажатие(Элемент)
	
	Если Модифицированность Тогда
		Ответ = Вопрос("Все несохраненные настройки будут потеряны. Продолжить?",
					   РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	ЗагрузитьФайлНастройки();
	ПриИзмененииПравилаПолученияФайлаНастройки();
	
КонецПроцедуры

// Сохранение шаблона
//
Процедура КнопкаСохранитьШаблонНажатие(Элемент)
	
	Имя = ?(мТекущийШаблон = Неопределено, "", мТекущийШаблон.Значение);
	Представление = ?(мТекущийШаблон = Неопределено, "", мТекущийШаблон.Представление);
	ФормаУстановкиИмени = ОбработкаОбъект.ПолучитьФорму("СохранениеШаблона", ЭтаФорма);
	ФормаУстановкиИмени.ПолеВводаПредставлениеШаблона = Представление;
	ФормаУстановкиИмени.ПолеВводаОписаниеШаблона = ПолучитьОписаниеШаблона(Имя);
	Результат = ФормаУстановкиИмени.ОткрытьМодально();
	Если Результат = "ОК" Тогда
		Представление = ФормаУстановкиИмени.ПолеВводаПредставлениеШаблона;
		Описание = ФормаУстановкиИмени.ПолеВводаОписаниеШаблона;
		СохранитьШаблон(Представление, Описание);
	ИначеЕсли Истина
		И ТипЗнч(Результат) = Тип("Строка")
		И ЗначениеЗаполнено(Результат)
	Тогда
		ДокументДОМ = ДокументДОМ();
		ЗаписатьДОМ(ДокументДОМ, Результат);
	КонецЕсли;
	
КонецПроцедуры

// Выбор шаблона
//
Процедура КнопкаВыбратьШаблон(Кнопка)
	
	ФормаВыбораШаблона = ОбработкаОбъект.ПолучитьФорму("ВыборШаблона", ЭтаФорма);
	ФормаВыбораШаблона.НачальноеЗначениеВыбора = мТекущийШаблон;
	РезультатВыбора = ФормаВыбораШаблона.ОткрытьМодально();
	Если ТипЗнч(РезультатВыбора) = Тип("ЭлементСпискаЗначений") Тогда
		//Если мТекущийШаблон <> Неопределено И Шаблон.Значение = мТекущийШаблон.Значение Тогда
		//	Возврат;
		//КонецЕсли;
		лИмяФайла = РезультатВыбора.Значение;
		ЗагрузитьФайлНастройки(лИмяФайла, Истина, УстанавливатьОсновныеКаталоги,, Истина);
		мТекущийШаблон = РезультатВыбора;
	ИначеЕсли ТипЗнч(РезультатВыбора) = Тип("Строка") Тогда
		ЗагрузитьФайлНастройки(РезультатВыбора, Истина, УстанавливатьОсновныеКаталоги, Ложь, Истина);
	Иначе
		Возврат;
	КонецЕсли;
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

Функция ПереключитьТрассировкуЗапросов(НовыйРежим = Истина) Экспорт 
	
	ЭтотОбъект.ФиксироватьПланыЗапросовSQL = Истина;
	КаталогЛогов = ирСервер.СоздатьКаталогТрассыПоПользователюЛкс();
	СтрокаКаталога = ТабличноеПолеЖурналы.Найти(КаталогЛогов, "Местоположение");
	Если СтрокаКаталога <> Неопределено Тогда
		ЭлементыФормы.ТабличноеПолеЖурналы.ТекущаяСтрока = СтрокаКаталога;
	КонецЕсли; 
	ФормаЖурнала = ОткрытьФормуРедактированияЖурнала(СтрокаКаталога = Неопределено);
	ФормаЖурнала.МестоположениеЖурнала = КаталогЛогов;
	ФормаЖурнала.ВремяХраненияЖурнала = 1;
	ФормаЖурнала.УстановитьРегистрациюСобытия("SDBL", Истина);
	ФормаЖурнала.УстановитьРегистрациюСобытия("DB2", Истина);
	ФормаЖурнала.УстановитьРегистрациюСобытия("DBMSSQL", Истина);
	ФормаЖурнала.УстановитьРегистрациюСобытия("DBMSSQLCONN", Истина);
	ФормаЖурнала.УстановитьРегистрациюСобытия("DBPOSTGRS", Истина);
	ФормаЖурнала.УстановитьРегистрациюСобытия("DBORACLE", Истина);
	ФормаЖурнала.УстановитьРегистрациюСобытия("DBV8DBENG", Истина);
	ФормаЖурнала.УстановитьРегистрациюСобытия("EXCP", Истина);
	ФормаЖурнала.УстановитьРегистрациюСобытия("QERR", Истина);
	ТабличноеПолеСписокСобытий = ФормаЖурнала.ЭлементыФормы.ТабличноеПолеСписокСобытий;
	Для Каждого СтрокаТП Из ТабличноеПолеСписокСобытий.Значение Цикл
		ТабличноеПолеСписокСобытий.ВыделенныеСтроки.Добавить(СтрокаТП);
	КонецЦикла;
	ФормаЖурнала.КП_ДетальныйФильтрСобытийТекущийПользователь();
	//ФормаЖурнала.УстановитьЭлементОтбораВВыделенныхГруппахИ("t:applicationName", "1CV8"); // Толстый клиент, отбрасывает фоновые задания
	Если Не ирКэш.ЛиФайловаяБазаЛкс() Тогда
		// К сожалению в файловой СУБД это свойство не заполняется
		ФормаЖурнала.КП_ДетальныйФильтрСобытийТекущаяБаза();
	КонецЕсли; 

КонецФункции

Функция ЗагрузитьФайлНастройки(пИмяФайла = Неопределено, УстановитьПризнакИзменения = Ложь, УстанавливатьОсновныеКаталоги = Ложь, пНаСервере = Неопределено, РазрешитьВопросы = Ложь) Экспорт

	Если пНаСервере = Неопределено Тогда
		пНаСервере = НаСервере;
	КонецЕсли; 
	ДокументДОМСчитанный = ЗагрузитьКонфигурационныйXML(пИмяФайла, пНаСервере);
	Если ДокументДОМСчитанный = Неопределено Тогда
		ирОбщий.СообщитьСУчетомМодальностиЛкс("Ошибка при чтении XML (" + пИмяФайла + ").", МодальныйРежим);
		Возврат Неопределено;
	КонецЕсли;
	СтарыйИндексЖурнала = 0;
	Если ЭлементыФормы.ТабличноеПолеЖурналы.ТекущаяСтрока <> Неопределено Тогда
		СтарыйИндексЖурнала = ЭлементыФормы.ТабличноеПолеЖурналы.Значение.Индекс(ЭлементыФормы.ТабличноеПолеЖурналы.ТекущаяСтрока);
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
		ДокументДОМСчитанный = Новый ДокументDOM;
		мДокументДОМ = Новый ДокументDOM;
	#КонецЕсли
	Если РазрешитьВопросы Тогда
		Ответ = Вопрос("Загрузить настройку полностью (иначе только в текущий журнал)?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		Ответ = КодВозвратаДиалога.Да;
	КонецЕсли; 
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		ЖурналыСОсновнымМестоположением = ТабличноеПолеЖурналы.НайтиСтроки(Новый Структура("Местоположение", ОсновнойКаталогЖурнала));
		Если Истина
			И УстанавливатьОсновныеКаталоги 
			И (Ложь
				Или ЖурналыСОсновнымМестоположением.Количество() = 0
				Или (Истина
					И ЖурналыСОсновнымМестоположением.Количество() = 1 
					И ЖурналыСОсновнымМестоположением[0] = ЭлементыФормы.ТабличноеПолеЖурналы.ТекущаяСтрока))
		Тогда
			УстановитьПути(ОсновнойКаталогЖурнала, ОсновнойКаталогДампов, ДокументДОМСчитанный);
		КонецЕсли; 
		УзлыЖурналовСчитанные = ДокументДОМСчитанный.ПолучитьЭлементыПоИмени("log");
		НовыйУзел = мДокументДОМ.ИмпортироватьУзел(УзлыЖурналовСчитанные[0], Истина);
		Если мДокументДОМ.ПолучитьЭлементыПоИмени("log").Количество() = 0 Тогда
			ирОбщий.СообщитьЛкс("Текущий журнал не найден");
			Возврат Неопределено;
		КонецЕсли;
		ТекущийУзелЖурнала = мДокументДОМ.ПолучитьЭлементыПоИмени("log")[СтарыйИндексЖурнала];
		ТекущийУзелЖурнала.РодительскийУзел.ЗаменитьДочерний(НовыйУзел, ТекущийУзелЖурнала);
		ПрочитатьНастройкиЖурналов(ТабличноеПолеЖурналы);
		ЭлементыФормы.ТабличноеПолеЖурналы.ТекущаяСтрока = ТабличноеПолеЖурналы[СтарыйИндексЖурнала];
		ЗагрузитьОбщиеФлагиИзДокументаДОМ(Истина);
		Возврат Неопределено;
	КонецЕсли;
	ЭтотОбъект.мДокументДОМ = ДокументДОМСчитанный;
	Если УстанавливатьОсновныеКаталоги Тогда
		УстановитьПути(ОсновнойКаталогЖурнала, ОсновнойКаталогДампов);
	КонецЕсли;
	ПрочитатьНастройкиЖурналов(ТабличноеПолеЖурналы);
	ПрочитатьНастройкиДампа();
	СистемныйЖурнал = мДокументДОМ.ПолучитьЭлементыПоИмени("defaultlog");
	Если СистемныйЖурнал.Количество() > 0 Тогда
		ИзФайла = СистемныйЖурнал[0].ПолучитьАтрибут("location");
		КаталогСистемногоЖурнала = ?(ИзФайла = Неопределено, "", ИзФайла);
		ИзФайла = СистемныйЖурнал[0].ПолучитьАтрибут("history");
		СрокХраненияСистемногоЖурнала = ?(ИзФайла = Неопределено, 24, XMLЗначение(Тип("Число"), ИзФайла));
	Иначе
		СрокХраненияСистемногоЖурнала = 24;
		КаталогСистемногоЖурнала = "";
	КонецЕсли;
	ЗагрузитьОбщиеФлагиИзДокументаДОМ();
	ЭтотОбъект.КонтрольнаяТочкаУтечкиКлиент = Ложь;
	ЭтотОбъект.КонтрольнаяТочкаУтечкиСервер = Ложь;
	УтечкиМетоды.Очистить();
	//УтечкиПроцедуры.Очистить();
	Утечки = мДокументДОМ.ПолучитьЭлементыПоИмени("leaks");
	ЭтотОбъект.СледитьЗаУтечкамиПамятиВПрикладномКоде = (Утечки.Количество() > 0);
	Если СледитьЗаУтечкамиПамятиВПрикладномКоде Тогда
		Элемент = Утечки.Элемент(0);
		Если Элемент <> Неопределено Тогда
			ИзФайла = Элемент.ПолучитьАтрибут("collect");
			РежимУтечки = ?(ИзФайла = Неопределено, Ложь, XMLЗначение(Тип("Булево"), ИзФайла));
			Точки = Элемент.ПолучитьЭлементыПоИмени("point");
			Для каждого Точка из Точки Цикл
				ИзФайла = Точка.ПолучитьАтрибут("call");
				Если ИзФайла <> Неопределено Тогда
					Если НРег(ИзФайла) = "server" Тогда
						ЭтотОбъект.КонтрольнаяТочкаУтечкиСервер = Истина;
					ИначеЕсли НРег(ИзФайла) = "client" Тогда
						ЭтотОбъект.КонтрольнаяТочкаУтечкиКлиент = Истина;
					КонецЕсли;
					Продолжить;
				КонецЕсли;
				ИзФайла = Точка.ПолучитьАтрибут("proc");
				Если ИзФайла <> Неопределено Тогда
					СтрокаДанных = УтечкиМетоды.Добавить();
					СтрокаДанных.Метод = ИзФайла;
					Продолжить;
				КонецЕсли;
				//ИзФайла = Точка.ПолучитьАтрибут("on");
				//ИзФайла2 = Точка.ПолучитьАтрибут("off");
				//Если ИзФайла <> Неопределено И ИзФайла2 <> Неопределено Тогда
				//	СтрокаДанных = УтечкиПроцедуры.Добавить();
				//	СтрокаДанных.Строка1 = ИзФайла;
				//	СтрокаДанных.Строка2 = ИзФайла2;
				//КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	// настройки системных событий (/system)
	СистемныеСобытия.Очистить();
	лСистемныеСобытия = мДокументДОМ.ПолучитьЭлементыПоИмени("system");
	Если лСистемныеСобытия.Количество() > 0 Тогда
		СистемныеУровни = УровниСистемныхСобытий();
		Для каждого ЭлементСобытия Из лСистемныеСобытия Цикл
			Уровень = ЭлементСобытия.ПолучитьАтрибут("level");
			Если ПустаяСтрока(Уровень) Тогда
				//Сообщить(НСтр("ru = 'В элементе <system> не указано значение атрибута ""level"". Элемент игнорируется'", "ru"));
				Продолжить;
			КонецЕсли;
			Если СистемныеУровни.НайтиПоЗначению(Уровень) = Неопределено Тогда
				//Сообщить(Форматировать(НСтр("ru = 'В элементе <system> указано неизвестно значение атрибута. level = ""%1%"". Элемент игнорируется'", "ru"), Уровень));
				Продолжить;
			КонецЕсли;
			СтрокаСобытия = СистемныеСобытия.Добавить();
			СтрокаСобытия.Уровень = Уровень;
			СтрокаСобытия.Компонент = ЭлементСобытия.ПолучитьАтрибут("component");
			СтрокаСобытия.Класс = ЭлементСобытия.ПолучитьАтрибут("class");
		КонецЦикла;
	КонецЕсли;
	Панель1ПриСменеСтраницы();
	Модифицированность = УстановитьПризнакИзменения;
	Если ТабличноеПолеЖурналы.Количество() > СтарыйИндексЖурнала Тогда
		ЭлементыФормы.ТабличноеПолеЖурналы.ТекущаяСтрока = ТабличноеПолеЖурналы[СтарыйИндексЖурнала];
	КонецЕсли; 
	//ВычислитьРазмерыКаталогов(); // Может долго выполняться
	Возврат Неопределено;

КонецФункции

Процедура ЗагрузитьОбщиеФлагиИзДокументаДОМ(Объединить = Ложь)
	
	НовоеЗначение = мДокументДОМ.ПолучитьЭлементыПоИмени("mem").Количество() > 0;
	Если НовоеЗначение Или Не Объединить Тогда
		ЭтотОбъект.СледитьЗаУтечкамиПамятиВРабочихПроцессах = НовоеЗначение;
	КонецЕсли;
	НовоеЗначение = мДокументДОМ.ПолучитьЭлементыПоИмени("plansql").Количество() > 0;
	Если НовоеЗначение Или Не Объединить Тогда
		ЭтотОбъект.ФиксироватьПланыЗапросовSQL = НовоеЗначение;
	КонецЕсли;
	НовоеЗначение = мДокументДОМ.ПолучитьЭлементыПоИмени("dbmslocks").Количество() > 0;
	Если НовоеЗначение Или Не Объединить Тогда
		ЭтотОбъект.СобиратьБлокировкиСУБД = НовоеЗначение;
	КонецЕсли;
	НовоеЗначение = мДокументДОМ.ПолучитьЭлементыПоИмени("scriptcircrefs").Количество() > 0;
	Если НовоеЗначение Или Не Объединить Тогда
		ЭтотОбъект.КонтрольЦиклическихСсылок = НовоеЗначение;
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ

Процедура ТабличноеПолеЖурналыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	Ответ = Вопрос("Действительно удалить настройку каталога журнала?",
				   РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да,
				   "Удалить настройку каталога журнала?");
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	Инд = ТабличноеПолеЖурналы.Индекс(Элемент.ТекущаяСтрока);
	ДокументДОМ = ДокументДОМ();
	УзелЖурнала = ПолучитьУзелЖурнала(Инд);
	Если УзелЖурнала <> Неопределено Тогда
		УзелКонфигурации = ДокументДОМ.ПервыйДочерний;
		УзелКонфигурации.УдалитьДочерний(УзелЖурнала);
		ПрочитатьНастройкиЖурналов(ТабличноеПолеЖурналы);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТабличноеПолеЖурналыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОткрытьФормуРедактированияЖурнала();
	
КонецПроцедуры

Функция ОткрытьФормуРедактированияЖурнала(ДобавлениеНового = Ложь) Экспорт
	
	Если Не ДобавлениеНового Тогда
		ЭтотОбъект.ТекущийЖурнал = ТабличноеПолеЖурналы.Индекс(ЭлементыФормы.ТабличноеПолеЖурналы.ТекущаяСтрока);
	КонецЕсли; 
	ФормаКаталога = ОбработкаОбъект.ПолучитьФорму("НастройкаКаталога", ЭтаФорма);
	ФормаКаталога.ДобавлениеНового = ДобавлениеНового;
	ФормаКаталога.Открыть();
	Возврат ФормаКаталога;
	
КонецФункции

Процедура ТабличноеПолеЖурналыПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	ОткрытьФормуРедактированияЖурнала(Истина);
	
КонецПроцедуры

Процедура ВариантРасположенияФайлаНастроекПриИзменении(Элемент)
	
	ПриИзмененииПравилаПолученияФайлаНастройки();
	
КонецПроцедуры

Процедура ФлажокНаСервереПриИзменении(Элемент)
	
	ПриИзмененииПравилаПолученияФайлаНастройки();
	
КонецПроцедуры

Процедура ПриИзмененииПравилаПолученияФайлаНастройки() Экспорт
	
	ЭлементыФормы.КаталогНастройки.ОтметкаНезаполненного = Ложь;
	ЭлементыФормы.КаталогНастройки.АвтоОтметкаНезаполненного = ирКэш.ЛиПортативныйРежимЛкс() И ЭтотОбъект.НаСервере;
	ЭлементыФормы.ВариантРасположенияФайлаНастроек.Доступность = Не ЭлементыФормы.КаталогНастройки.АвтоОтметкаНезаполненного И Не ЗначениеЗаполнено(КаталогНастройки);
	ЭтаФорма.ПолноеИмяФайлаНастройки = ПолучитьПолноеИмяКонфигурационногоФайла();
	ИмяФайлаВычислено = ЗначениеЗаполнено(ПолноеИмяФайлаНастройки);
	ЭлементыФормы.ДействияФормы.Кнопки.КнопкаСохранить.Доступность = ИмяФайлаВычислено;
	ЭлементыФормы.ДействияФормы.Кнопки.КнопкаОбновить.Доступность = ИмяФайлаВычислено;
	ЭлементыФормы.ДействияФормы.Кнопки.Выключить.Доступность = ИмяФайлаВычислено;
	лДатаИзмененияФайла = 0;
	ФайлНайден = ЛиФайлСуществует(ПолноеИмяФайлаНастройки, , лДатаИзмененияФайла);
	Если ЗначениеЗаполнено(лДатаИзмененияФайла) Тогда
		ДатаИзмененияФайла = лДатаИзмененияФайла;
	Иначе
		ДатаИзмененияФайла = Неопределено;
	КонецЕсли; 
	ОбновлениеВремениДоСчитывания();
	Если ФайлНайден Тогда
		//Если ДатаИзмененияФайла + 60 > ТекущаяДата() Тогда
		//	СостояниеФайла = "Обновление";
		//	ЭлементыФормы.СостояниеФайла.ЦветТекстаПоля = Новый Цвет(0, 0, 150);
		//Иначе
			СостояниеФайла = "Присутствует";
			ЭлементыФормы.СостояниеФайла.ЦветТекстаПоля = Новый Цвет(0, 150, 0);
		//КонецЕсли; 
	Иначе
		СостояниеФайла = "Отсутствует";
		ЭлементыФормы.СостояниеФайла.ЦветТекстаПоля = Новый Цвет(150, 0, 0);
	КонецЕсли;
	ПодключитьОбработчикОжидания("ОбновлениеВремениДоСчитывания", 1);
	Если Не Модифицированность Тогда
		ЗагрузитьФайлНастройки();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновлениеВремениДоСчитывания()
	
	ВремяДоСчитывания = ДатаИзмененияФайла + 60 - ирОбщий.ТекущаяДатаЛкс(НаСервере, Истина);
	Если ВремяДоСчитывания < 0 Тогда
		ВремяДоСчитывания = 0;
		ОтключитьОбработчикОжидания("ОбновлениеВремениДоСчитывания");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыВыключить(Кнопка)
	
	Ответ = Вопрос("Считать активную настройку перед отключением?", РежимДиалогаВопрос.ДаНетОтмена);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		СчитатьНастройку = Истина;
	Иначе
		СчитатьНастройку = Ложь;
	КонецЕсли;
	ИмяИндивидуальнойНастройки = ПолучитьПолноеИмяКонфигурационногоФайла(мВариантыРасположенияФайла.АктивныйФайл);
	ФайлСуществует = ЛиФайлСуществует(ИмяИндивидуальнойНастройки);
	Если ФайлСуществует И СчитатьНастройку Тогда
		ЗагрузитьФайлНастройки(ИмяИндивидуальнойНастройки, Истина);
		Модифицированность = Истина;
		ЭтаФорма.ДатаИзмененияФайла = ТекущаяДата();
	КонецЕсли; 
	Если ФайлСуществует Тогда
		СохранитьШаблон("" + ТекущаяДата(), "Отключенная настройка " + ТекущаяДата());
	КонецЕсли;
	ОтключитьБолееПриоритетныеФайлы(Истина);
	ПриИзмененииПравилаПолученияФайлаНастройки();
	
КонецПроцедуры

Процедура КоманднаяПанель1Анализ(Кнопка)
	
	ТекущаяСтрока = ПолучитьТекущуюСтрокуКаталоговЖурнала();
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ТекущаяСтрока.Местоположение) Тогда
		//Если НаСервере Тогда
		//	Сообщить("Внимание! Анализ техножурнала выполняется только на клиенте!", СтатусСообщения.Информация);
		//КонецЕсли; 
		АнализТехножурнала = ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирАнализТехножурнала");
		#Если Сервер И Не Сервер Тогда
			АнализТехножурнала = Обработки.ирАнализТехножурнала.Создать();
		#КонецЕсли
		АнализТехножурнала.ОткрытьСПараметрами(ТекущаяСтрока.Местоположение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанель1ОчиститьКаталогЖурнала(Кнопка)
	
	ТекущаяСтрока = ПолучитьТекущуюСтрокуКаталоговЖурнала();
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ТекущаяСтрока.Местоположение) Тогда
		ирОбщий.ОчиститьКаталогТехножурналаЛкс(ТекущаяСтрока.Местоположение, НаСервере);
		ТекущаяСтрока.Доступен = Не ирОбщий.ЛиКаталогТехножурналаНедоступенЛкс(ТекущаяСтрока.Местоположение, НаСервере, Ложь);
	КонецЕсли; 
	
КонецПроцедуры

Функция ПолучитьТекущуюСтрокуКаталоговЖурнала()

	ТекущаяСтрока = ЭлементыФормы.ТабличноеПолеЖурналы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Если ТабличноеПолеЖурналы.Количество() = 1 Тогда
			ТекущаяСтрока = ТабличноеПолеЖурналы[0];
			ЭлементыФормы.ТабличноеПолеЖурналы.ТекущаяСтрока = ТекущаяСтрока;
		КонецЕсли; 
	КонецЕсли; 
	Возврат ТекущаяСтрока;

КонецФункции

Процедура КоманднаяПанель1ОбновитьРазмер(Кнопка)
	
	ВычислитьРазмерыКаталогов();
	
КонецПроцедуры

Процедура ВычислитьРазмерыКаталогов() Экспорт
	
	Для Каждого СтрокаКаталога Из ТабличноеПолеЖурналы Цикл
		Если НаСервере Тогда
			ОбщийРазмер = ирСервер.ВычислитьРазмерКаталогаЛкс(СтрокаКаталога.Местоположение);
		Иначе
			ОбщийРазмер = ирОбщий.ВычислитьРазмерКаталогаЛкс(СтрокаКаталога.Местоположение);
		КонецЕсли; 
		СтрокаКаталога.Размер = ОбщийРазмер / 1024;
		СтрокаКаталога.Доступен = Не ирОбщий.ЛиКаталогТехножурналаНедоступенЛкс(СтрокаКаталога.Местоположение, НаСервере);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОсновнойКаталогЖурналаПриИзменении(Элемент)
	
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ОсновнойКаталогДамповПриИзменении(Элемент)
	
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ОсновнойКаталогЖурналаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирКлиент.ПолеФайловогоКаталога_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОсновнойКаталогДамповНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирКлиент.ПолеФайловогоКаталога_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОсновнойКаталогЖурналаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ОсновнойКаталогДамповНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ОсновнойКаталогЖурналаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);
		
КонецПроцедуры

Процедура ОсновнойКаталогДамповОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);

КонецПроцедуры

Процедура КоманднаяПанель1ОткрытьКаталог(Кнопка)
	
	ТекущаяСтрока = ПолучитьТекущуюСтрокуКаталоговЖурнала();
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ТекущаяСтрока.Местоположение) Тогда
		ЗапуститьПриложение(ТекущаяСтрока.Местоположение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура РасположениеДампаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.Значение = ОсновнойКаталогДампов;

КонецПроцедуры

Процедура РасположениеДампаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);

КонецПроцедуры

Процедура РасположениеДампаПриИзменении(Элемент)
	
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОбновитьРазмерКаталогаДампов();
	ЭтотОбъект.СоздаватьДамп = Истина;
	
КонецПроцедуры

Процедура РасположениеДампаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

// Обработка события изменения состояния флажков
// 
Процедура ПолеСпискаФлагиДампаПриИзмененииФлажка(Элемент)
	
	ФлагДампа = Элемент.ТекущаяСтрока;
	Если ФлагДампа.Пометка Тогда
		ЭтотОбъект.ТипДампа = ЭтотОбъект.ТипДампа + Число(ФлагДампа.Значение);
	Иначе
		ЭтотОбъект.ТипДампа = ЭтотОбъект.ТипДампа - Число(ФлагДампа.Значение);
	КонецЕсли;
	Если ТипДампа = 0 Тогда
		Элемент.Значение[0].Пометка = Истина;
	Иначе
		Элемент.Значение[0].Пометка = Ложь;
	КонецЕсли;
	ТипДампа = 0;
	Для Каждого ФлагДампа Из ПолеСпискаФлагиДампа Цикл
		Если ФлагДампа.Пометка Тогда
			ТипДампа = ТипДампа + ФлагДампа.Значение;
		КонецЕсли;
	КонецЦикла;
	ЭтотОбъект.СоздаватьДамп = Истина;
	
КонецПроцедуры

// Установить все флажки
// 
Процедура КоманднаяПанельСпискаДампаУстановитьФлажки(Кнопка)
	
	ТипДампа = 0;
	Для Каждого ФлагДампа Из ПолеСпискаФлагиДампа Цикл
		Если ФлагДампа.Значение = "0" Тогда
			Продолжить;
		КонецЕсли;
		ФлагДампа.Пометка = Истина;
		ТипДампа = ТипДампа + ФлагДампа.Значение;
	КонецЦикла;
	ЭлементыФормы.ПолеСпискаФлагиДампа.Значение[0].Пометка = Ложь;
	
КонецПроцедуры

// Снять все флажки
// 
Процедура КоманднаяПанельСпискаДампаСнятьФлажки(Кнопка)
	
	Для Каждого ФлагДампа Из ПолеСпискаФлагиДампа Цикл
		Если ФлагДампа.Значение = "0" Тогда
			Продолжить
		КонецЕсли;
		ФлагДампа.Пометка = Ложь;
	КонецЦикла;
	ЭтотОбъект.ТипДампа = 0;
	ЭлементыФормы.ПолеСпискаФлагиДампа.Значение[0].Пометка = Истина;
	
КонецПроцедуры

// Выбор каталога расположения дампа
// 
Процедура РасположениеДампаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирКлиент.ПолеФайловогоКаталога_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура Панель1ПриСменеСтраницы(Элемент = Неопределено, ТекущаяСтраница = Неопределено)
	
    Элемент = ЭлементыФормы.ПанельРедактируемаяНастройка;
	ТекущаяСтраница = Элемент.ТекущаяСтраница.Имя;
	Если Элемент.Страницы[ТекущаяСтраница] = Элемент.Страницы.XML Тогда
		ЭлементыФормы.СодержимоеКонфигурационногоФайла.УстановитьТекст(ПолучитьСтрокуХМЛ(ПолучитьОбновитьДокументДОМ()));
	ИначеЕсли Элемент.Страницы[ТекущаяСтраница] = Элемент.Страницы.Дамп Тогда
		ОбновитьРазмерКаталогаДампов();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьРазмерКаталогаДампов()
	
	АктивноеРасположениеДампа = РасположениеДампа;
	Если Не ЗначениеЗаполнено(АктивноеРасположениеДампа) Тогда
		АктивноеРасположениеДампа = КаталогДампаПоУмолчанию;
	КонецЕсли; 
	ЭлементыФормы.НадписьРазмерКаталогаДампов.Заголовок = "" + Цел(ирОбщий.ВычислитьРазмерКаталогаЛкс(АктивноеРасположениеДампа, Ложь) / 1000000) + " МБ";

КонецПроцедуры

Процедура ТабличноеПолеЖурналыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	Если Ложь
		Или ПустаяСтрока(ДанныеСтроки.Местоположение)
		Или ПустаяСтрока(ДанныеСтроки.События)
		Или Не ДанныеСтроки.Доступен
	Тогда
		ОформлениеСтроки.ЦветФона = Новый Цвет(255, 240, 240);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КонтрольнаяТочкаУтечкиКлиентПриИзменении(Элемент)
	
	Если Элемент.Значение Тогда
		ЭтотОбъект.СледитьЗаУтечкамиПамятиВПрикладномКоде = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КаталогСистемногоЖурналаПоУмолчаниюОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);
	
КонецПроцедуры

Процедура ДействияФормыITS(Кнопка)
	
	//ирКлиент.ОткрытьСсылкуИТСЛкс();
	ЗапуститьПриложение("http://its.1c.ru/db/v8doc#content:26:1:issogl1_3.14.logcfg.xml");

КонецПроцедуры

Процедура УтечкиПоМодулямПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если Не ОтменаРедактирования Тогда
		ЭтотОбъект.СледитьЗаУтечкамиПамятиВПрикладномКоде = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПолноеИмяФайлаНастройкиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь; 
	Файл = Новый Файл(Элемент.Значение);
	Если Файл.Существует() Тогда
		ирКлиент.ОткрытьФайлВПроводникеЛкс(Файл.ПолноеИмя);
	Иначе
		ЗапуститьПриложение(Файл.Путь);
	КонецЕсли;
	
КонецПроцедуры

Процедура КаталогНастройкиПриИзменении(Элемент)
	
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ПриИзмененииПравилаПолученияФайлаНастройки();

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если ВремяДоСчитывания > 0 Тогда 
		// Тут может возникать ошибка платформы 8.3.17+ https://www.hostedredmine.com/issues/899714
		ирОбщий.СообщитьЛкс("" + ТекущаяДата() + " до считывания всеми процессами последних изменений настройки техножурнала осталось " + ВремяДоСчитывания + "с");
	КонецЕсли; 
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ТабличноеПолеЖурналыПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ФлажокСкриншотПриИзменении(Элемент)
	
	ЭтотОбъект.СоздаватьДамп = Истина;
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура Надпись22Нажатие(Элемент)
	ЗапуститьПриложение("%LOCALAPPDATA%\CrashDumps");
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирНастройкаТехножурнала.Форма.НастройкаТехножурнала");

КаталогСистемногоЖурналаПоУмолчанию = ирКэш.КаталогИзданияПлатформыВПрофилеЛкс() + "\logs";
КаталогДампаПоУмолчанию = ирКэш.КаталогИзданияПлатформыВПрофилеЛкс() + "\dumps";
ЗаполнитьСписокВыбораСрокаХранения(ЭлементыФормы.СрокХраненияСистемногоЖурнала.СписокВыбора);
ЭлементыФормы.СистемныеСобытия.Колонки.Уровень.ЭлементУправления.СписокВыбора = УровниСистемныхСобытий();
ЗаполнитьТаблицуТиповСобытий();
ЗаполнитьСписокСвойствСобытий();
СписокВыбораВарианта = ЭлементыФормы.ВариантРасположенияФайлаНастроек.СписокВыбора;
Для Каждого ЭлементСписка Из мСписокВариантовРасположенияКонфигурационногоФайла Цикл
	СписокВыбораВарианта.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
КонецЦикла;