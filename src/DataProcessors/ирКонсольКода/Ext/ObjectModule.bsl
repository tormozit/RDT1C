﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирКлиент Экспорт;

Функция РеквизитыДляСервера(Параметры) Экспорт 
	
	Возврат Неопределено;
	
КонецФункции

Функция ВыполнитьАлгоритмВКонтексте(Параметры) Экспорт 
	#Если Сервер И Не Сервер Тогда
		Параметры = Новый Структура;
	#КонецЕсли
	#Если Сервер И Не Клиент Тогда
		КонтекстВыполнения = ирОбщий;
	#Иначе
		Если Параметры.ВыполнятьНаСервере <> Ложь Тогда
			КонтекстВыполнения = ирСервер;
		Иначе
			КонтекстВыполнения = ирОбщий;
		КонецЕсли;
	#КонецЕсли 
	Параметры.Вставить("ВремяНачала", ирОбщий.ТекущееВремяВМиллисекундахЛкс());
	Если Параметры.ЧерезВнешнююОбработку Тогда
		#Если Сервер И Не Сервер Тогда
			ирОбщий.ВыполнитьАлгоритмЧерезВнешнююОбработкуЛкс();
			ирСервер.ВыполнитьАлгоритмЧерезВнешнююОбработкуЛкс(); 
		#КонецЕсли
		ОписаниеОшибки = КонтекстВыполнения.ВыполнитьАлгоритмЧерезВнешнююОбработкуЛкс(Параметры.ИмяФайлаВнешнейОбработки, Параметры.СтруктураПараметров, Параметры.ВремяНачала, Параметры.ВерсияАлгоритма,
			Параметры.ЛиСинтаксическийКонтроль, Параметры.ЛиМодульОтФормы);
		Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
			// Антибаг платформы. Иначе будет выполняться старая версия файла https://www.hostedredmine.com/issues/966275
			ВызватьИсключение ОписаниеОшибки; // #МеткаПеревыбросИсключения#
		КонецЕсли;
	//ИначеЕсли Контекст = "Тонкий" Тогда
	//	Результат = ирКэш.ПолучитьСеансТонкогоКлиентаЛкс(Ложь);
	//	Если Результат = Неопределено Тогда
	//		ВызватьИсключение "Не удалось создать COM сеанс тонкого клиента";
	//	КонецЕсли;
	//	Результат.ирОбщий.ВыполнитьАлгоритм(Параметры.ТекстДляВыполнения, Параметры.СтруктураПараметров);
	Иначе
		КонтекстВыполнения.ВыполнитьАлгоритм(Параметры.ТекстДляВыполнения, Параметры.СтруктураПараметров);
	КонецЕсли;
	Возврат Параметры;

КонецФункции

//ирПортативный лФайл = Новый Файл(ИспользуемоеИмяФайла);
//ирПортативный ПолноеИмяФайлаБазовогоМодуля = Лев(лФайл.Путь, СтрДлина(лФайл.Путь) - СтрДлина("Модули\")) + "ирПортативный.epf";
//ирПортативный #Если Клиент Тогда
//ирПортативный 	Контейнер = Новый Структура();
//ирПортативный 	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный 	Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 		ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный 		ирПортативный.Открыть();
//ирПортативный 	КонецЕсли; 
//ирПортативный #Иначе
//ирПортативный 	ирПортативный = ВнешниеОбработки.Создать(ПолноеИмяФайлаБазовогоМодуля, Ложь); // Это будет второй экземпляр объекта
//ирПортативный #КонецЕсли
//ирПортативный ирОбщий = ирПортативный.ОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ОбщийМодульЛкс("ирСервер");
//ирПортативный ирКлиент = ирПортативный.ОбщийМодульЛкс("ирКлиент");
