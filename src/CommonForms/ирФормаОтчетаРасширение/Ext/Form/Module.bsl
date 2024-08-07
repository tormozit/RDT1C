﻿
&НаКлиенте
Процедура ирОтладить(Команда)
	
	#Если ТонкийКлиент Или ВебКлиент Тогда
		ОткрытьФорму("Обработка.ирКонсольКомпоновокДанных.Форма");
		Возврат;
	#Иначе
		СхемаКомпоновки = ПолучитьИзВременногоХранилища(ПолучитьАдресСхемы());
		ирОбщий.ОтладитьЛкс(СхемаКомпоновки,, ЭтаФорма.Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресСхемы()
	Перем НастройкиОтчета;
	
	Попытка
		НастройкиОтчета = ЭтаФорма.НастройкиОтчета;
	Исключение
		НастройкиОтчета = Неопределено;
	КонецПопытки;
	Если НастройкиОтчета <> Неопределено И НастройкиОтчета.СхемаМодифицирована Тогда
		// Стандартная форма отчета БСП
		АдресСхемы = НастройкиОтчета.АдресСхемы;
	Иначе
		ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
		#Если Сервер И Не Сервер Тогда
			ОтчетОбъект = Обработки.ирКонсольКомпоновокДанных.Создать();
		#КонецЕсли
		АдресСхемы = ПоместитьВоВременноеХранилище(ОтчетОбъект.СхемаКомпоновкиДанных);
	КонецЕсли;
	Возврат АдресСхемы;
	
КонецФункции

&НаСервере
Процедура ирПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Родитель = Элементы.Найти("ГруппаВывод");
	Если Истина
		И Родитель <> Неопределено
		И Родитель.Вид <> ВидГруппыФормы.КоманднаяПанель 
		И Родитель.Вид <> ВидГруппыФормы.ГруппаКнопок
	Тогда
		Родитель = Неопределено;
	КонецЕсли; 
	Если Родитель = Неопределено Тогда
		КнопкаСформироватьОтчет = Элементы.Найти("ФормаСформироватьОтчет");
		Если КнопкаСформироватьОтчет = Неопределено Тогда
			КнопкаСформироватьОтчет = Элементы.Найти("СформироватьОтчет");
		КонецЕсли; 
		Если КнопкаСформироватьОтчет <> Неопределено Тогда
			Родитель = КнопкаСформироватьОтчет.Родитель;
		ИначеЕсли ЭтаФорма.ПоложениеКоманднойПанели <> ПоложениеКоманднойПанелиФормы.Нет Тогда 
			Родитель = ЭтаФорма.КоманднаяПанель;
		Иначе
			Родитель = ЭтаФорма;
		КонецЕсли; 
	КонецЕсли; 
	Кнопка = Элементы.Добавить("ирОтладитьИР", Тип("КнопкаФормы"), Родитель);
	Кнопка.ИмяКоманды = "ирОтладить";
	
КонецПроцедуры

