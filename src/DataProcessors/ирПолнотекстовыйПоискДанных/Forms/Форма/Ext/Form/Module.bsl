﻿Перем мПорцияРезультата;
Перем ИмяСвойстваНомера;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.ПоказыватьОписания, Форма.Нечеткость, Форма.СписокМетаданных, Форма.ОграничитьОбъектыПоиска, Форма.ПрименитьНечеткийПоиск, Форма.РазмерПорции";
	Возврат Неопределено;
КонецФункции

Процедура НачатьПоиск()

	Если ПолеВводаПоиска = "" Тогда 
		Возврат;
	КонецЕсли;
	Если ОграничитьОбъектыПоиска = Истина Тогда
		МассивМД = Новый Массив();
		Для Каждого МД Из СписокМетаданных Цикл
			Если ТипЗнч(МД.Значение) <> Тип("Строка") Тогда
				Продолжить;
			КонецЕсли;
			МассивМД.Добавить(ирКэш.ОбъектМДПоПолномуИмениЛкс(МД.Значение));
		КонецЦикла;	
		мПорцияРезультата.ОбластьПоиска = МассивМД;
	Иначе	
		МассивМД = Новый Массив();
		мПорцияРезультата.ОбластьПоиска = МассивМД;
	КонецЕсли;
	Если ПрименитьНечеткийПоиск = Истина Тогда
		мПорцияРезультата.ПорогНечеткости = Нечеткость;
	Иначе	
		мПорцияРезультата.ПорогНечеткости = 0;
	КонецЕсли;
	мПорцияРезультата.СтрокаПоиска = ПолеВводаПоиска;
	мПорцияРезультата.РазмерПорции = РазмерПорции;
	мПорцияРезультата.ПерваяЧасть();
	Колво = мПорцияРезультата.ПолноеКоличество();
	ЗаполнитьСписокНайденных();
	
КонецПроцедуры

Процедура ПолучитьТекстДатыИндекса()
	
	ИндексАктуален = ПолнотекстовыйПоиск.ИндексАктуален();
	ЭлементыФормы.НадписьДатаАктуальностиИндекса.Заголовок = "Дата актуальности индекса " + ПолнотекстовыйПоиск.ДатаАктуальности() + ", " 
		+ ?(ИндексАктуален, "актуален", "не актуален");
	Если ИндексАктуален Тогда
		ЭлементыФормы.НадписьДатаАктуальностиИндекса.ЦветТекста = Новый Цвет;
	Иначе
		ЭлементыФормы.НадписьДатаАктуальностиИндекса.ЦветТекста = WebЦвета.Красный;
	КонецЕсли; 
		
Конецпроцедуры

Процедура ЗаполнитьСписокНайденных()
	
	Если мПорцияРезультата.ПолноеКоличество() = 0 Тогда
		ЭлементыФормы.Найдено.Значение = "Не найдено";
		ЭлементыФормы.КнопкаВперед.Видимость = Ложь;
		ЭлементыФормы.КнопкаНазад.Видимость = Ложь;
		ЭлементыФормы.HTMLОтображение.УстановитьТекст("");
		Возврат;
	КонецЕсли;
	Если ЭлементыФормы.ПолеВводаПоиска.СписокВыбора.НайтиПоЗначению(мПорцияРезультата.СтрокаПоиска) = Неопределено Тогда
		ЭлементыФормы.ПолеВводаПоиска.СписокВыбора.Вставить(0, мПорцияРезультата.СтрокаПоиска);
		ирОбщий.СохранитьЗначениеЛкс("Строки для полнотекстового поиска", ЭлементыФормы.ПолеВводаПоиска.СписокВыбора.ВыгрузитьЗначения());
	КонецЕсли;
	ЭлементыФормы.КнопкаВперед.Видимость = Истина;
	ЭлементыФормы.КнопкаНазад.Видимость = Истина;
	ЭлементыФормы.Найдено.Значение = 
		"Показаны " + 
		Строка(мПорцияРезультата.НачальнаяПозиция() + 1) + " - " +  
		Строка(мПорцияРезультата.НачальнаяПозиция() + мПорцияРезультата.Количество()) + 
		" из " + мПорцияРезультата.ПолноеКоличество();
	
	СтрHTML = мПорцияРезультата.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.HTMLТекст);
	СтрHTML = СтрЗаменить(СтрHTML, "<td>", "<td><font face=""MS Sans Serif"" size=""1"">");
	СтрHTML = СтрЗаменить(СтрHTML, "<td valign=top width=1>", "<td valign=top width=1><font face=""MS Sans Serif"" size=""1"">");
	СтрHTML = СтрЗаменить(СтрHTML, "<body>", "<body><body topmargin=0 leftmargin=0>");
	СтрHTML = СтрЗаменить(СтрHTML, "</td>", "</font></td>");
	СтрHTML = СтрЗаменить(СтрHTML, "<b>", "");
	СтрHTML = СтрЗаменить(СтрHTML, "</b>", "");
	СтрHTML = СтрЗаменить(СтрHTML, "FFFF00", "FFFFC8");  
	
	ЭлементыФормы.HTMLОтображение.УстановитьТекст(СтрHTML);
	ТаблицаПорции.Очистить();
	Для Каждого ЭлементПорции Из мПорцияРезультата Цикл
		#Если Сервер И Не Сервер Тогда
			ЭлементПорции = ПолнотекстовыйПоиск.СоздатьСписок()[0];
		#КонецЕсли
		СтрокаПорции = ТаблицаПорции.Добавить();
		СтрокаПорции.Объект = ЭлементПорции.Значение;
		СтрокаПорции.Метаданные = ЭлементПорции.Метаданные.ПолноеИмя();
		ПредставлениеПоля = СокрЛП(ирОбщий.ПервыйФрагментЛкс(ЭлементПорции.Описание, ":"));
		ПредставлениеЗначения = СокрЛП(Сред(ЭлементПорции.Описание, СтрДлина(ПредставлениеПоля + ": ") + 1));
		СтрокаПорции.Описание = ПредставлениеЗначения;
		СтрокаПорции.Поле = ПредставлениеПоля;
	КонецЦикла;
	Если мПорцияРезультата.СлишкомМногоРезультатов() Тогда
		Предупреждение("Слишком много результатов, уточните запрос.");
	КонецЕсли;
	ДоступностьКнопок();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирКлиент.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	Если Истина
		И ТипЗнч(КлючУникальности) = Тип("Строка")
		И ирКэш.ОбъектМДПоПолномуИмениЛкс(КлючУникальности) <> Неопределено 
	Тогда
		СписокМетаданных.Очистить();
		СписокМетаданных.Добавить(КлючУникальности);
		ЭтаФорма.ОграничитьОбъектыПоиска = Истина;
	КонецЕсли; 
	Массив = ирОбщий.ВосстановитьЗначениеЛкс("Строки для полнотекстового поиска");
	Если Массив <> Неопределено Тогда
		ЭлементыФормы.ПолеВводаПоиска.СписокВыбора.ЗагрузитьЗначения(Массив);
	КонецЕсли;	
	Если ирОбщий.РежимСовместимостиМеньше8_3_4Лкс() Тогда
		ИмяСвойстваНомера = "nameProp";
	Иначе
		ИмяСвойстваНомера = "sel_num";
	КонецЕсли; 
	ЭлементыФОрмы.СписокМетаданных.Доступность = Ложь;
	ЭлементыФормы.ОбновитьИндекс.Доступность = ПравоДоступа("Администрирование",Метаданные);
	ПолучитьТекстДатыИндекса();
	ИзменитьСвернутостьПанельНастроек(Ложь);
	ирКлиент.УстановитьПрикреплениеФормыВУправляемомПриложенииЛкс(Этаформа);
	
КонецПроцедуры

Процедура ДоступностьКнопок()
	
	Если (мПорцияРезультата.ПолноеКоличество() - мПорцияРезультата.НачальнаяПозиция()) > мПорцияРезультата.Количество() ИЛИ (мПорцияРезультата.НачальнаяПозиция() > 0) Тогда
		Видимость = Истина;
	Иначе	
		Видимость = Ложь;
	КонецЕсли;	
		
	ЭлементыФормы.КнопкаВперед.Видимость = Видимость;
	ЭлементыФормы.КнопкаНазад.Видимость = Видимость;

	ЭлементыФормы.КнопкаВперед.Доступность = (мПорцияРезультата.ПолноеКоличество() - мПорцияРезультата.НачальнаяПозиция()) > мПорцияРезультата.Количество();
	ЭлементыФормы.КнопкаНазад.Доступность = (мПорцияРезультата.НачальнаяПозиция() > 0);
	
КонецПроцедуры

Процедура КнопкаВпередНажатие(Элемент)
	
	мПорцияРезультата.СледующаяЧасть();
	ЗаполнитьСписокНайденных();
	
КонецПроцедуры

Процедура КнопкаНазадНажатие(Элемент)
	
	мПорцияРезультата.ПредыдущаяЧасть();
	ЗаполнитьСписокНайденных();
	
КонецПроцедуры

Процедура ПоказыватьОписанияПриИзменении(Элемент)
	
	мПорцияРезультата.ПолучатьОписание = ПоказыватьОписания;
	
КонецПроцедуры

Процедура HTMLОтображениеonclick(Элемент, pEvtObj)
	
	htmlElement = pEvtObj.srcElement;
	Если (htmlElement.id = "FullTextSearchListItem") Тогда
		Если ирОбщий.РежимСовместимостиМеньше8_3_4Лкс() Тогда
			номерВСписке = Число(htmlElement[ИмяСвойстваНомера]);
		Иначе
			номерВСписке = Число(htmlElement.attributes[ИмяСвойстваНомера].value);
		КонецЕсли; 
		ВыбраннаяСтрока = мПорцияРезультата[номерВСписке];
		Если ОткрыватьВРедактореОбъектаБД Тогда
			РедакторОбъектаБД = ирКлиент.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ВыбраннаяСтрока.Значение);
			ПредставлениеПоля = СокрЛП(ирОбщий.ПервыйФрагментЛкс(ВыбраннаяСтрока.Описание, ":"));
			ПредставлениеЗначения = СокрЛП(Сред(ВыбраннаяСтрока.Описание, СтрДлина(ПредставлениеПоля + ": ") + 1));
			РедакторОбъектаБД.НайтиПоказатьПолеПоПредставлению(ПредставлениеПоля, ПредставлениеЗначения);
		Иначе
			ирКлиент.ОткрытьЗначениеЛкс(ВыбраннаяСтрока.Значение);
		КонецЕсли; 
		pEvtObj.returnValue = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура КнопкаДобавитьМетаданныеНажатие(Элемент)
	
	Форма = ирКлиент.ФормаВыбораОбъектаМетаданныхЛкс(,, СписокМетаданных.ВыгрузитьЗначения(), Истина, Истина, , Истина,,,,,,, Истина);
	РезультатВыбора = Форма.ОткрытьМодально();
	Если РезультатВыбора <> Неопределено Тогда
		СписокМетаданных.Очистить();
		Для Каждого ПолноеИмяОбъекта Из РезультатВыбора Цикл
			ОграничитьОбъектыПоиска = Истина;
			ЭлементыФОрмы.СписокМетаданных.Доступность = Истина;
			СписокМетаданных.Добавить(ПолноеИмяОбъекта);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОграничитьОбъектыПоискаПриИзменении(Элемент)
	
	Если ОграничитьОбъектыПоиска = Истина Тогда
		ЭлементыФОрмы.СписокМетаданных.Доступность = Истина;
	Иначе	
		ЭлементыФОрмы.СписокМетаданных.Доступность = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПрименитьНечеткийПоискПриИзменении(Элемент)
	
	Если ПрименитьНечеткийПоиск = Истина Тогда
		ЭлементыФормы.Нечеткость.Доступность = Истина;
	Иначе	
		ЭлементыФормы.Нечеткость.Доступность = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ДействияФормыПоказатьНастройки(Кнопка)
	
	ИзменитьСвернутостьПанельНастроек(Не ЭлементыФормы.ДействияФормы.Кнопки.ПоказатьНастройки.Пометка);

КонецПроцедуры

Процедура ИзменитьСвернутостьПанельНастроек(Видимость = Истина)
	
	ЭлементыФормы.ДействияФормы.Кнопки.ПоказатьНастройки.Пометка = Видимость;
	ирКлиент.ИзменитьСвернутостьЛкс(ЭтаФорма, Видимость, ЭлементыФормы.ПанельНастройки, ЭтаФорма.ЭлементыФормы.РазделительГоризонтальный, ЭтаФорма.Панель, "верх");

КонецПроцедуры

Процедура КоманднаяПанельПоиск(Кнопка)
	НачатьПоиск();
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	ТекущийЭлемент = ЭлементыФормы.ПолеВводаПоиска;
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	Если Не ПроверитьДоступностьПоиска() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	мПорцияРезультата = ПолнотекстовыйПоиск.СоздатьСписок("", РазмерПорции);
	мПорцияРезультата.ПолучатьОписание = ПоказыватьОписания;
КонецПроцедуры

Функция РеквизитыДляСервера(Параметры) Экспорт 
	Результат = ирОбщий.РеквизитыОбработкиЛкс(ЭтотОбъект);
	Возврат Результат;
КонецФункции

Процедура ОбновитьИндексНажатие(Элемент)
	#Если Сервер И Не Сервер Тогда
		ОбновитьИндекс();
		ОбновитьИндексЗавершение();
	#КонецЕсли
	ирОбщий.ВыполнитьЗаданиеФормыЛкс("ОбновитьИндекс",, ЭтаФорма, "ОбновлениеИндекса", "Обновление индекса полнотекстового поиска", ЭлементыФормы.ОбновитьИндекс, "ОбновитьИндексЗавершение");
КонецПроцедуры

// Предопределеный метод
Процедура ПроверкаЗавершенияФоновыхЗаданий() Экспорт 
	
	ирКлиент.ПроверитьЗавершениеФоновыхЗаданийФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ОбновитьИндексЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		ПолучитьТекстДатыИндекса();
	КонецЕсли; 

КонецПроцедуры

Функция ПроверитьДоступностьПоиска()
	Если ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить Тогда
		// поиск разрешен
		Возврат Истина;
	КонецЕсли;
	
	СтрОшибки = "В текущей информационной базе отключена возможность полнотекстового поиска." + Символы.ПС;
	
	// Проверим, есть ли права на включение поиска
	Если Не ПравоДоступа("Администрирование", Метаданные) Тогда
		Предупреждение(СтрОшибки + "Для включения поиска обратитесь к администратору.");
		Возврат Ложь;
	КонецЕсли;
	
	
	// Проверим, работают ли другие пользователи в базе
	МассивСоединений = ПолучитьСоединенияИнформационнойБазы();
	ВсегоСоединений  = ?(МассивСоединений = Неопределено, 0, МассивСоединений.Количество());
	Если  ВсегоСоединений <> 1 Тогда
		// работают другие пользователи
		
		Сообщение = СтрОшибки + "Для включения полнотекстового поиска попросите пользователей выйти из программы и повторно запустите поиск.
		|
		|Текущие соединения:
		|";
		
		Для каждого Соединение Из МассивСоединений Цикл
			Если Не Соединение.НомерСоединения = НомерСоединенияИнформационнойБазы() Тогда
				Сообщение = Сообщение + Символы.ПС + " - " + Соединение;
			КонецЕсли;
		КонецЦикла; 
		
		Предупреждение(Сообщение);
		Возврат Ложь;
	КонецЕсли;
	
	// Спросим, нужно ли включать поиск
	СтрВопроса = СтрОшибки + "Включить полнотекстовый поиск?";
	Если Вопрос(СтрВопроса, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет  Тогда
		Возврат Ложь;
	КонецЕсли;
		
	// Пробуем включить полнотекстовый поиск
	МасОшибок = Новый Массив;
	Попытка
		ПолнотекстовыйПоиск.УстановитьРежимПолнотекстовогоПоиска(РежимПолнотекстовогоПоиска.Разрешить);
	Исключение
		Предупреждение("Ошибка при включении полнотекстового поиска:
		|" + ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;	
	
	// Если были ошибки, то выведем предупреждения
	Для Каждого Ошибка Из МасОшибок Цикл
		Предупреждение(Ошибка);
	КонецЦикла;
	
	Если МасОшибок.Количество() <> 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Проверим, нужно ли индексировать
	Если Не ПолнотекстовыйПоиск.ИндексАктуален() Тогда
		СтрВопроса = "Индекс не актуален. Обновление индекса может занять длительное время.
		|Индекс можно обновить позднее в форме поиска данных.
		|Обновить индекс прямо сейчас?";
		Если Вопрос(СтрВопроса, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			Попытка
				ПолнотекстовыйПоиск.ОбновитьИндекс(Истина, Ложь);
			Исключение
				Предупреждение("Ошибка при обновлении индекса:
				|" + ОписаниеОшибки());
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;

	Возврат Истина;
КонецФункции

Процедура ПолеВводаПоискаПриИзменении(Элемент)
	
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ДобавкаЗаголовка = "";
	Если КлючУникальности <> Неопределено Тогда
		ДобавкаЗаголовка = ДобавкаЗаголовка + КлючУникальности;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ПолеВводаПоиска) Тогда
		Если ЗначениеЗаполнено(ДобавкаЗаголовка) Тогда
			ДобавкаЗаголовка = ДобавкаЗаголовка + ": ";
		КонецЕсли; 
		ДобавкаЗаголовка = ДобавкаЗаголовка + ПолеВводаПоиска;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ДобавкаЗаголовка) Тогда
		ЭтаФорма.Заголовок = "ППД(ИР): " + ДобавкаЗаголовка;
	Иначе
		ирКлиент.Форма_ВосстановитьЗаголовокЛкс(ЭтаФорма);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельОткрыватьВРедактореОбъектаБД(Кнопка)
	
	ЭтаФорма.ОткрыватьВРедактореОбъектаБД = Не ОткрыватьВРедактореОбъектаБД;
	Кнопка.Пометка = ОткрыватьВРедактореОбъектаБД;
	
КонецПроцедуры

Процедура КоманднаяПанельКонсольОбработки(Кнопка)
	
	Если ЭлементыФормы.ПанельРезультат.ТекущаяСтраница = ЭлементыФормы.ПанельРезультат.Страницы.HtmlПорции Тогда
		ШаблонПоиска = ИмяСвойстваНомера + "=""(\d+)""";
		МассивСсылок = Новый Массив;
		ВыделенныйТекстHtml = ирОбщий.ПолучитьHtmlТекстВыделенияЛкс(ЭлементыФормы.HTMLОтображение.Документ);
		Вхождения = ирОбщий.НайтиРегВыражениеЛкс(ВыделенныйТекстHtml, ШаблонПоиска, "Индекс");
		Для Каждого Вхождение Из Вхождения Цикл
			НомерВСписке = Число(Вхождение.Индекс);
			ВыбраннаяСтрока = мПорцияРезультата[НомерВСписке];
			МассивСсылок.Добавить(ВыбраннаяСтрока.Значение);
		КонецЦикла; 
		ирКлиент.ОткрытьМассивОбъектовВПодбореИОбработкеОбъектовЛкс(МассивСсылок);
	Иначе
		ирКлиент.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭлементыФормы.ТаблицаПорции, "Объект");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 
	
КонецПроцедуры

Процедура КоманднаяПанельФормыОткрытьИТС(Кнопка)
	
	ирКлиент.ОткрытьСсылкуИТСЛкс("https://its.1c.ru/db/v?doc#bookmark:dev:TI000000799");
	ирКлиент.ОткрытьСсылкуИТСЛкс("https://its.1c.ru/db/v?doc#bookmark:dev:TI000001240");
	ирКлиент.ОткрытьСсылкуИТСЛкс("https://its.1c.ru/db/v?doc/bookmark/utx/TI000000308/%EF%EE%EB%ED%EE%F2%E5%EA%F1%F2%EE%E2%FB%E9%20%EF%EE%E8%F1%EA");
	
КонецПроцедуры

Процедура ПолеВводаПоискаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не Отказ Тогда
		ИзменитьСвернутостьПанельНастроек(Истина);
	КонецЕсли; 

КонецПроцедуры

Процедура ТаблицаПорцииВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ОткрыватьВРедактореОбъектаБД Тогда
		РедакторОбъектаБД = ирКлиент.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ВыбраннаяСтрока.Объект);
		РедакторОбъектаБД.НайтиПоказатьПолеПоПредставлению(ВыбраннаяСтрока.Поле, ВыбраннаяСтрока.Описание);
	Иначе
		ирКлиент.ОткрытьЗначениеЛкс(ВыбраннаяСтрока.Объект);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыСсылкиОтобратьПоТипам(Кнопка)
	
	ирКлиент.ИзменитьОтборКлиентаПоМетаданнымЛкс(ЭлементыФормы.ТаблицаПорции,, Истина);
	
КонецПроцедуры

Процедура ДействияФормыМенеджерТабличногоПоля(Кнопка)
	
	ирКлиент.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.ТаблицаПорции, ЭтаФорма);
	
КонецПроцедуры

Процедура КП_ТаблицаПорцииСсылкиОтборБезЗначенияВТекущейКолонке(Кнопка)
	
	ирКлиент.ТабличноеПолеОтборДляЗначенияВТекущейКолонкеЛкс(ЭлементыФормы.ТаблицаПорции);
	
КонецПроцедуры

Процедура КП_ТаблицаПорцииРазличныеЗначенияКолонки(Кнопка)
	
	ирКлиент.ОткрытьРазличныеЗначенияКолонкиЛкс(ЭлементыФормы.ТаблицаПорции);
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирКлиент.Форма_ОбновлениеОтображенияЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура КП_ТаблицаПорцииСравнить(Кнопка)
	
	ирКлиент.ЗапомнитьСодержимоеЭлементаФормыДляСравненияЛкс(ЭтаФорма, ЭлементыФормы.ТаблицаПорции);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПолнотекстовыйПоискДанных.Форма.Форма");
РазмерПорции = 20;
Нечеткость = 25;
ПоказыватьОписания = Истина;
ЭлементыФормы.Нечеткость.СписокВыбора.Добавить(25);
ЭлементыФормы.Нечеткость.СписокВыбора.Добавить(50);
ЭлементыФормы.Нечеткость.СписокВыбора.Добавить(75);
ЭлементыФормы.РазмерПорции.СписокВыбора.Добавить(20);
ЭлементыФормы.РазмерПорции.СписокВыбора.Добавить(60);
ЭлементыФормы.РазмерПорции.СписокВыбора.Добавить(200);
ЭлементыФормы.РазмерПорции.СписокВыбора.Добавить(600);
ЭлементыФормы.РазмерПорции.СписокВыбора.Добавить(2000);