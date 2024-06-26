﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирКлиент Экспорт;

Процедура УстановитьФлажкиПотомков(СтрокаДерева) Экспорт

	Для Каждого СтрокаДереваПотомок Из СтрокаДерева.Строки Цикл
		
		СтрокаДереваПотомок.Метка = СтрокаДерева.Метка;
		УстановитьФлажкиПотомков(СтрокаДереваПотомок);
		
	КонецЦикла; 	
	
КонецПроцедуры // ЭлементыФормы.ДеревоПолей.ТекущаяСтрока()
    
Процедура УстановитьФлажкиРодителей(СтрокаДерева, ТрехЗначныйФлажок = Ложь) Экспорт

	Родитель = СтрокаДерева.Родитель;
	Если Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ИтоговаяМетка = Истина;
	КоличествоЛожь = 0;
	Для Каждого СтрокаСосед Из Родитель.Строки Цикл
		Если СтрокаСосед.Метка = 0 Тогда
			КоличествоЛожь = КоличествоЛожь + 1;                 
			Если Не ТрехЗначныйФлажок Тогда
				ИтоговаяМетка = Ложь;
				Прервать;
			КонецЕсли; 
		КонецЕсли;
	КонецЦикла;   
	Если ТрехЗначныйФлажок Тогда
		ИтоговаяМетка = ?(КоличествоЛожь = Родитель.Строки.Количество(), 0, ?(КоличествоЛожь = 0, 1, 2));
	КонецЕсли; 
	Если ИтоговаяМетка <> Родитель.Метка Тогда
		Родитель.Метка = ИтоговаяМетка;
		УстановитьФлажкиРодителей(Родитель, ТрехЗначныйФлажок);
	КонецЕсли; 
	
КонецПроцедуры // УстановитьФлажкиРодителей()  

Процедура УстановитьФлажокСтрокиПоПодчиненным(СтрокаДерева, ТрехЗначныйФлажок = Ложь) Экспорт
	
	Если СтрокаДерева.Строки.Количество() = 0  Тогда		
		Возврат;                                    		
	КонецЕсли; 
	
	ИтоговаяМетка = Истина;
	КоличествоЛожь = 0;
	
	Для Каждого ПодчиненнаяСтрока Из СтрокаДерева.Строки Цикл
		
		УстановитьФлажокСтрокиПоПодчиненным(ПодчиненнаяСтрока, ТрехЗначныйФлажок);  					
		Если ПодчиненнаяСтрока.Метка = 0 Тогда
			КоличествоЛожь = КоличествоЛожь + 1;			
		КонецЕсли; 
		ИтоговаяМетка = ИтоговаяМетка И ПодчиненнаяСтрока.Метка ;  		
				
	КонецЦикла; 
	
	Если ТрехЗначныйФлажок Тогда
		ИтоговаяМетка = ?(КоличествоЛожь = СтрокаДерева.Строки.Количество(), 0, ?(КоличествоЛожь = 0, 1, 2)); 	
	КонецЕсли; 
	
	СтрокаДерева.Метка = ИтоговаяМетка;
	
КонецПроцедуры

Функция ЕстьПолеСсылкаВТаблицеПолейРегистрации(ТаблицаПолейРегистрации) Экспорт
	
	Результат = Ложь;
	
	Для Каждого СтрокаТаблицы Из ТаблицаПолейРегистрации Цикл
		Если СтрокаТаблицы.ПолеРегистрации.Количество() = 1  И СтрокаТаблицы.ПолеРегистрации[0].Значение = "Ссылка" Тогда
			Результат = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;

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
