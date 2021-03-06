﻿Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭтаФорма.АутентификацияСервера = ЗначениеЗаполнено(ИмяПользователя); 
	Если Не ЗначениеЗаполнено(ИмяБД) Тогда
		ЭтаФорма.ИмяБД = НСтр(СтрокаСоединенияИнформационнойБазы(), "Ref");
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(ИмяСервера) Тогда
		ЭтаФорма.ИмяСервера = ирОбщий.ПервыйФрагментЛкс(НСтр(СтрокаСоединенияИнформационнойБазы(), "Srvr"), ":");
	КонецЕсли; 
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыКнопкаОК(Кнопка = Неопределено)
	
	Если Ложь
		Или Не ЗначениеЗаполнено(ИмяСервера) 
		Или Не ЗначениеЗаполнено(ИмяБД) 
	Тогда
		Предупреждение("Не заполнены обязательные параметры");
		Возврат;
	КонецЕсли; 
	Если ПроверитьСоединение() Тогда 
		ирОбщий.СохранитьЗначениеЛкс("ирПараметрыСоединенияСУБД.ИмяСервера", ИмяСервера);
		ирОбщий.СохранитьЗначениеЛкс("ирПараметрыСоединенияСУБД.ИмяБД", ИмяБД);
		ирОбщий.СохранитьЗначениеЛкс("ирПараметрыСоединенияСУБД.ИмяПользователя", ИмяПользователя);
		ирОбщий.СохранитьЗначениеЛкс("ирПараметрыСоединенияСУБД.Пароль", Новый ХранилищеЗначения(Пароль));
		ирОбщий.СохранитьЗначениеЛкс("ирПараметрыСоединенияСУБД.НаСервере", НаСервере);
		мПлатформа = ирКэш.Получить();
		мПлатформа.мПроверкаСоединенияADOЭтойБДВыполнялась = Истина;
		Закрыть(Истина);
	КонецЕсли; 
	
КонецПроцедуры

Функция ПроверитьСоединение()
	
	Возврат ирОбщий.ПроверитьСоединениеADOЭтойБДЛкс(ИмяСервера, ИмяБД, ИмяПользователя, Пароль, НаСервере, Ложь);

КонецФункции

Процедура АутентификацияСервераПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ОбновитьДоступность()
	
	ЭлементыФормы.ИмяПользователя.Доступность = АутентификацияСервера;
	ЭлементыФормы.Пароль.Доступность = АутентификацияСервера;
	ЭлементыФормы.НаСервере.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс();

КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	СтрокаСвойств = "";
	ПараметрыСоединения = ирОбщий.ПараметрыСоединенияADOЭтойБДЛкс(СтрокаСвойств);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ПараметрыСоединения, СтрокаСвойств); 
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		ЭтаФорма.НаСервере = Ложь;
	КонецЕсли; 
	Если Истина
		И ЗначениеЗаполнено(ИмяСервера) 
		И ЗначениеЗаполнено(ИмяБД) 
		И Автоподключение 
	Тогда
		Если ПроверитьСоединение() Тогда 
			Отказ = Истина;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ПараметрыСоединенияСУБД");
ЭтаФорма.Автоподключение = Истина;