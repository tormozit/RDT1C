﻿// Здесь нельзя использовать общие модули!

&НаКлиенте
Процедура ЗапуститьНовоеПриложение(Знач ОбычноеПриложение = Истина)
	
	#Если ВебКлиент Или МобильныйКлиент Тогда
		Сообщить("Команда недоступна в веб клиенте");
	#Иначе
		Если ТекущийПользователь Тогда
			НастроитьПользователяНаСервере();
		КонецЕсли; 
		ПараметрыЗапуска = "";
		СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
		ПараметрыЗапуска = ПараметрыЗапуска + " ENTERPRISE";
		ПараметрыЗапуска = ПараметрыЗапуска + " /IBConnectionString""" + СтрЗаменить(СтрокаСоединения, """", """""") + """";
		Если ОбычноеПриложение Тогда
			ПараметрыЗапуска = ПараметрыЗапуска + " /RunModeOrdinaryApplication";
		Иначе
			ПараметрыЗапуска = ПараметрыЗапуска + " /RunModeManagedApplication";
		КонецЕсли; 
		ПараметрыЗапуска = ПараметрыЗапуска + " /Debug";
		ПараметрыЗапуска = ПараметрыЗапуска + " /UC""" + КодРазрешения + """";
		ИспользуемоеИмяФайлаЛ = ПолучитьИспользуемоеИмяФайла();
		Если ЗначениеЗаполнено(ИспользуемоеИмяФайлаЛ) Тогда
			ПараметрыЗапуска = ПараметрыЗапуска + " /Execute""" + ИспользуемоеИмяФайлаЛ + """";
		КонецЕсли; 
		Если ТекущийПользователь Тогда
			ПараметрыЗапуска = ПараметрыЗапуска + " /WA-";
			ПараметрыЗапуска = ПараметрыЗапуска + " /N""" + ИмяПользователя() + """";
			Если ЗначениеЗаполнено(ПарольТекущегоПользователя) Тогда
				ПараметрыЗапуска = ПараметрыЗапуска + " /P""" + ПарольТекущегоПользователя + """";
			КонецЕсли; 
		КонецЕсли;
		Если ЗначениеЗаполнено(ДополнительныеПараметры) Тогда
			ПараметрыЗапуска = ПараметрыЗапуска + " " + ДополнительныеПараметры;
		КонецЕсли; 
		Если ЗначениеЗаполнено(НавигационнаяСсылкаИзПараметра) Тогда
			ПараметрыЗапуска = ПараметрыЗапуска + " /URL" + НавигационнаяСсылкаИзПараметра;
		КонецЕсли; 
		Если ЗначениеЗаполнено(ИмяФормыДляОткрытия) Тогда
			ПараметрыЗапуска = ПараметрыЗапуска + " /C""ОткрытьФормуИР." + ИмяФормыДляОткрытия + """";
		КонецЕсли; 
		Если ПрименитьТекущиеПараметрыЗапуска Тогда
			Попытка
				ВК = Новый ("AddIn.ирОбщая.AddIn");
			Исключение
				// https://partners.v8.1c.ru/forum/t/1265923/m/1555146
				//АдресКомпоненты = ПолучитьАдресВнешнейКомпоненты();
				//УстановитьВнешнююКомпоненту(АдресКомпоненты); // Выдает предупреждение пользователю каждый раз
				//
				Это64битныйПроцесс = Это64битныйПроцесс();
				ДвоичныеДанные = ПолучитьДвоичныеДанныеВК(Это64битныйПроцесс);
				АдресКомпоненты = ПолучитьИмяВременногоФайла("dll");
				ДвоичныеДанные.Записать(АдресКомпоненты);
				
				Попытка
					Результат = ПодключитьВнешнююКомпоненту(АдресКомпоненты, "ирОбщая", ТипВнешнейКомпоненты.Native);
				Исключение
					// В тонком клиенте: Использование синхронных методов на клиенте запрещено!
					ОписаниеОшибки = ОписаниеОшибки();
					ПоказатьОповещениеПользователя("",, "Флажок ""Применить текущие параметры запуска"" снят, т.к. в конфигурации запрещены синхронные вызовы"); 
					ЭтаФорма.ПрименитьТекущиеПараметрыЗапуска = Ложь;
					ЗапуститьНовоеПриложение(ОбычноеПриложение);
					Возврат;
				КонецПопытки;
				Если Не Результат Тогда
					ВызватьИсключение "Не удалось подключить внешнюю компоненту Общая. Она требуется для флажка ""Применить текущие параметры запуска"""; 
				КонецЕсли; 
				ВК = Новый ("AddIn.ирОбщая.AddIn");
			КонецПопытки; 
			ИдентификаторПроцессаОС = ВК.PID();
			ПараметрыЗапускаТекущие = ПараметрыЗапускаСеансаТекущие(ИдентификаторПроцессаОС);
			ПараметрыЗапуска = ПараметрыЗапуска + " " + ПараметрыЗапускаТекущие;
		КонецЕсли; 
		
		ИсполняемыйФайл = Новый Файл(ИмяИсполняемогоФайлаПлатформы());
		Попытка
			ИсполняемыйФайлСуществует = ИсполняемыйФайл.Существует();
		Исключение
			// В тонком клиенте: Использование синхронных методов на клиенте запрещено!
			ОписаниеОшибки = ОписаниеОшибки();
			ИсполняемыйФайлСуществует = Истина;
		КонецПопытки;
		Если Не ИсполняемыйФайлСуществует Тогда
			ВызватьИсключение "Необходимо установить толстый клиент 1С. Обратитесь к системому администратору.";
		КонецЕсли; 
		СтрокаЗапуска = """" + ИсполняемыйФайл.ПолноеИмя + """ " + ПараметрыЗапуска;
		Попытка
			ЗапуститьПриложение(СтрокаЗапуска);
		Исключение
			// В тонком клиенте: Использование синхронных методов на клиенте запрещено!
			ОписаниеОшибки = ОписаниеОшибки();
			Выполнить("НачатьЗапускПриложения(Новый ОписаниеОповещения, СтрокаЗапуска)");  // 8.3
		КонецПопытки;
		Если ЗакрытьФорму Тогда
			Закрыть();
		КонецЕсли; 
		Если ЗавершитьСеанс Тогда
			ЗавершитьРаботуСистемы();
		КонецЕсли; 
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Функция ЛиПлатформаWindows() Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	Результат = Ложь
		Или СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86
		Или СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64;
	Возврат Результат;

КонецФункции

&НаКлиенте
// Добавляет если нужно расширение ".exe"
Функция ИмяИсполняемогоФайла(Знач ИмяБезРасширения)
	Результат = ИмяБезРасширения;
	Если ЛиПлатформаWindows() Тогда
		Результат = Результат + ".exe";
	КонецЕсли;
	Возврат Результат;
КонецФункции

Процедура НастроитьПользователяНаСервере()
	
	ИмяПользователя = ИмяПользователя();
	Если Элементы.ВключитьКомпактныйВариантФорм.Доступность И ВключитьКомпактныйВариантФорм Тогда
		НастройкиКлиентскогоПриложения = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиКлиентскогоПриложения",,, ИмяПользователя);
		Если НастройкиКлиентскогоПриложения = Неопределено Тогда
			НастройкиКлиентскогоПриложения = Новый НастройкиКлиентскогоПриложения;
		КонецЕсли;
		НастройкиКлиентскогоПриложения.ВариантМасштабаФормКлиентскогоПриложения = Вычислить("ВариантМасштабаФормКлиентскогоПриложения.Компактный");
		ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиКлиентскогоПриложения", "", НастройкиКлиентскогоПриложения, , ИмяПользователя);
	КонецЕсли; 
	Если Элементы.ОтключитьЗащитуОтОпасныхДействий.Доступность И ОтключитьЗащитуОтОпасныхДействий И ЗначениеЗаполнено(ИмяПользователя) Тогда
		Пользователь = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяПользователя);
		Если Пользователь <> Неопределено Тогда
			Пользователь.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = Ложь;
			Пользователь.Записать();
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Функция ДоступнаЗащитаОтОпасныхДействий() Экспорт 
	
	Перем ТекущийПользователь;
	ЗащитаОтОпасныхДействийЛ = Неопределено;
	Попытка
		ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
		ЗащитаОтОпасныхДействийЛ = ТекущийПользователь.ЗащитаОтОпасныхДействий;
	Исключение
	КонецПопытки;
	Возврат ЗащитаОтОпасныхДействийЛ <> Неопределено;
	
КонецФункции

#Если Не ВебКлиент И Не МобильныйКлиент Тогда
&НаКлиенте
// р5яф67оыйи
Функция ПараметрыЗапускаСеансаТекущие(Знач ИдентификаторПроцессаОС) Экспорт 
	
	Результат = "";
	ТекущийПроцесс = ПолучитьCOMОбъект("winmgmts:{impersonationLevel=impersonate}!\\.\root\CIMV2:Win32_Process.Handle='" + XMLСтрока(ИдентификаторПроцессаОС) + "'");
	КоманднаяСтрокаПроцесса = ТекущийПроцесс.CommandLine;
	РегВыражение = Новый COMОбъект("VBScript.RegExp");
	РегВыражение.IgnoreCase = Истина;
	РегВыражение.Global = Истина;
	РегВыражение.Pattern = "(/DebuggerUrl\s*.+?)(?: /|$)";
	Вхождения = РегВыражение.Execute(КоманднаяСтрокаПроцесса);
	КоличествоВхождений = Вхождения.Count;
	Если КоличествоВхождений > 0 Тогда
		Результат = Вхождения.Item(КоличествоВхождений - 1).SubMatches(0);
	КонецЕсли; 
	РегВыражение.Pattern = "(/Debug\s+.+?)(?: /|$)";
	Вхождения = РегВыражение.Execute(КоманднаяСтрокаПроцесса);
	КоличествоВхождений = Вхождения.Count;
	Если КоличествоВхождений > 0 Тогда
		СтрокаОтладчика = Вхождения.Item(КоличествоВхождений - 1).SubMatches(0);
	Иначе
		СтрокаОтладчика = "/Debug";
	КонецЕсли;
	Результат = Результат + " " + СтрокаОтладчика;
	
	СохраняемыеПараметры = Новый Массив;
	СохраняемыеПараметры.Добавить("TechnicalSpecialistMode");
	СохраняемыеПараметры.Добавить("UseHwLicenses");
	СохраняемыеПараметры.Добавить("L");
	СохраняемыеПараметры.Добавить("VL");
	//СохраняемыеПараметры.Добавить("C");
	СохраняемыеПараметры.Добавить("UC");
	Для Каждого ИмяПараметра Из СохраняемыеПараметры Цикл
		РегВыражение.Pattern = "(/" + ИмяПараметра + ".*?)(?:\s/|$)";
		Вхождения = РегВыражение.Execute(КоманднаяСтрокаПроцесса);
		КоличествоВхождений = Вхождения.Count;
		Если КоличествоВхождений > 0 Тогда
			ПараметрКоманднойСтроки = Вхождения.Item(КоличествоВхождений - 1).SubMatches(0);
			Результат = Результат + " " + ПараметрКоманднойСтроки;
		КонецЕсли; 
	КонецЦикла;
	Возврат Результат;
	
КонецФункции
#КонецЕсли 

Функция ОбработкаОбъект()
	
	Если ТипЗнч(ЭтаФорма) = Тип("УправляемаяФорма") Тогда
		ОбработкаОбъект = ЭтаФорма.РеквизитФормыВЗначение("Объект");
	Иначе
		ОбработкаОбъект = Вычислить("ЭтотОбъект");
	КонецЕсли; 
	Возврат ОбработкаОбъект;

КонецФункции

Функция ПолучитьДвоичныеДанныеВК(x64 = Ложь)
	ОбработкаОбъект = ОбработкаОбъект();
	ИмяМакета = "ВК";
	Если x64 Тогда
		ИмяМакета = ИмяМакета + "64";
	Иначе
		ИмяМакета = ИмяМакета + "32";
	КонецЕсли; 
	Возврат ОбработкаОбъект.ПолучитьМакет(ИмяМакета);
КонецФункции

Функция ПолучитьАдресВнешнейКомпоненты()
	ОбработкаОбъект = ОбработкаОбъект();
	#Если Сервер И Не Сервер Тогда
	    ОбработкаОбъект = Обработки.ирПортативный.Создать();
	#КонецЕсли
	ОбъектМД = ОбработкаОбъект.Метаданные();
	// Антибаг платформы 8.2.19, исправлен в 8.3, ПолноеИмя() для дочерних метаданных внешней обработки возвращало обрезанное имя
	Адрес = ОбъектМД.ПолноеИмя() + ".Макет." + ОбъектМД.Макеты.ВК.Имя;
	Возврат Адрес;
КонецФункции

Функция ПолучитьИспользуемоеИмяФайла()
	
	ОбработкаОбъект = ОбработкаОбъект();
	Попытка
		ИспользуемоеИмяФайлаЛ = ОбработкаОбъект.ИспользуемоеИмяФайла;
	Исключение
	КонецПопытки; 
	Возврат ИспользуемоеИмяФайлаЛ;
	
КонецФункции

&НаКлиенте
// Метка_9в6676вап6438о
Функция Это64битныйПроцесс() Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	Результат = Ложь
		Или СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64
		Или СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86_64
		//Или СисИнфо.ТипПлатформы = ТипПлатформы.MacOS_x86_64  // Появилось в 8.3
		;
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ЗапуститьОбычноеПриложение(Команда)
	
	ЗапуститьНовоеПриложение(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьТолстыйКлиент(Команда)
	
	ЗапуститьНовоеПриложение(Ложь);
		
КонецПроцедуры

&НаКлиенте
Процедура ТекущийПользовательПриИзменении(Элемент)
	
	ОбновитьДоступность(ЭтаФорма);
	
КонецПроцедуры

// Реальная директива здесь - &НаКлиентеНаСервереБезКонтекста, остальные директивы нужны для контекстной подсказки по параметру ЭтаФорма
#Если Сервер И Не Сервер Тогда
	&НаСервере
#Иначе
	&НаКлиентеНаСервереБезКонтекста
#КонецЕсли
Процедура ОбновитьДоступность(ЭтаФорма)
	
	ЭтаФорма.Элементы.ГруппаПараметрыПользователя.Доступность = ЭтаФорма.ТекущийПользователь;
	
КонецПроцедуры

/////////////////////////////////////

Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СисИнфо = Новый СистемнаяИнформация;
	ЭтаФорма.НавигационнаяСсылкаИзПараметра = Параметры.НавигационнаяСсылка;
	ЭтаФорма.ИмяФормыДляОткрытия = Параметры.ИмяФормыДляОткрытия;
	ЭтаФорма.ПрименитьТекущиеПараметрыЗапуска = Истина;
	ЭтаФорма.ЗакрытьФорму = Истина;
	ЭтаФорма.ТекущийПользователь = Истина;
	ЭтаФорма.ОтключитьЗащитуОтОпасныхДействий = Истина;
	//ЭтаФорма.ВключитьКомпактныйВариантФорм = Истина;
	Если Метаданные.Обработки.Найти("ирПлатформа") = Неопределено Тогда
		Элементы.Текст.Заголовок = "Работа портативных инструментов разработчика в режиме управляемого приложения не поддерживается";
		Элементы.ЗапуститьТолстыйКлиент.Доступность = Ложь;
	Иначе
		Если Найти(ЭтаФорма.ИмяФормы, "ВнешняяОбработка.") = 1 Тогда
			Элементы.ЗапуститьТолстыйКлиент.Доступность = Ложь;
			Элементы.ЗапуститьОбычноеПриложение.Доступность = Ложь;
			Элементы.Текст.Заголовок = "Невозможно использовать портативные инструменты. В базе присутствуют не портативные инструменты. Необходимо использовать их.";
			Пользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
			Если Пользователь <> Неопределено И Не Пользователь.Роли.Содержит(Метаданные.Роли.ирРазработчик) Тогда
				Пользователь.Роли.Добавить(Метаданные.Роли.ирРазработчик);
				Пользователь.Записать();
				ДобавленаРоль = Истина;
			КонецЕсли;
		Иначе
			Элементы.Текст.Заголовок = "";
			Элементы.ПерейтиНаРасширение.Видимость = Ложь;
		КонецЕсли; 
	КонецЕсли;
	Элементы.ВключитьКомпактныйВариантФорм.Доступность = Найти(СисИнфо.ВерсияПриложения, "8.2") <> 1;
	Элементы.ОтключитьЗащитуОтОпасныхДействий.Доступность = ДоступнаЗащитаОтОпасныхДействий();
	ОбновитьДоступность(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбновитьДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не Элементы.ЗапуститьОбычноеПриложение.Доступность Тогда
		Если ДобавленаРоль Тогда
			Ответ = Вопрос("Вам предоставлена роль ирРазработчик. Необходимо перезапустить сеанс для возможности работы с непортативными инструментами", РежимДиалогаВопрос.ОКОтмена);
			Если Ответ = КодВозвратаДиалога.ОК Тогда
				ЗавершитьРаботуСистемы(, Истина);
			КонецЕсли; 
		КонецЕсли; 
	ИначеЕсли Элементы.ЗапуститьТолстыйКлиент.Доступность Тогда
	// Тут может работать баг платформы http://www.hostedredmine.com/issues/878182
	#Если ТонкийКлиент Тогда
		Элементы.Текст.Заголовок = "Функция в режиме тонкого клиента не поддерживается";
	#Иначе
		Элементы.Текст.Видимость = Ложь;
	#КонецЕсли
	КонецЕсли; 
	
КонецПроцедуры

#Если Не ВебКлиент Тогда

&НаКлиенте
Функция ИмяИсполняемогоФайлаПлатформы(Полное = Истина, Тонкий = Ложь) Экспорт 
	Результат = "1cv8";
	Если Тонкий Тогда
		Результат = Результат + "c";
	КонецЕсли; 
	Если ЭтоУчебнаяПлатформа() Тогда
		Результат = Результат + "t";
	КонецЕсли; 
	Результат = ИмяИсполняемогоФайла(Результат);
	Если Полное Тогда
		Результат = КаталогПрограммы() + Результат;
	КонецЕсли; 
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ПерейтиНаРасширение(Команда)
	
	ЭтотФайл = Новый Файл(ПолучитьИспользуемоеИмяФайла());
	ИмяФайла = ЭтотФайл.Путь + "/Модули/ирУстановщикРасширения.epf";
	ЗапуститьСистему("/RunModeManagedApplication /Execute""" + ИмяФайла + """");

КонецПроцедуры

&НаКлиенте
Функция ЭтоУчебнаяПлатформа() Экспорт 

	ВременныйФайл = ПолучитьИмяВременногоФайла("mxl");
	ТабДок = Новый ТабличныйДокумент;
	Попытка
		ТабДок.Записать(ВременныйФайл, ТипФайлаТабличногоДокумента.MXL7); // В учебной версии платформы это запрещено https://www.hostedredmine.com/issues/923942
	Исключение
		ОписаниеОшибки = ОписаниеОшибки(); 
		Если Найти(ОписаниеОшибки, "синхронных") > 0 Тогда
			// Использование синхронных методов на клиенте запрещено!
			Возврат Ложь;
		КонецЕсли;
		Возврат Истина;
	КонецПопытки; 
	УдалитьФайлы(ВременныйФайл);
	Возврат Ложь;

КонецФункции

#КонецЕсли
