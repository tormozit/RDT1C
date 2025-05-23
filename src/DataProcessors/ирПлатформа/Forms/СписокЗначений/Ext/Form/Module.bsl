﻿Перем РасширениеФайла;
Перем мИмяОткрытогоФайла;

Функция ПолучитьРезультат()
	
	Результат = Новый СписокЗначений;
	Результат.ТипЗначения = ОписаниеТипов;
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		ЭлементСписка = Результат.Добавить();
		ЗаполнитьЗначенияСвойств(ЭлементСписка, СтрокаТаблицы,, "Картинка"); 
	КонецЦикла; 
	ПолеЗначения = ЭлементыФормы.Таблица.Колонки.ПредставлениеЗначения.ЭлементУправления;
	Если ПолеЗначения.РежимВыбораИзСписка Тогда
		Результат.ДоступныеЗначения = ПолеЗначения.СписокВыбора;
	КонецЕсли;
	Возврат Результат;

КонецФункции

Процедура ОсновныеДействияФормыОК(Кнопка = Неопределено)
	
	Если ЛиОсновнойПриемникФайл() Тогда 
		Если Не ЭтаФорма.Модифицированность Или СохранитьВФайл() Тогда 
			Закрыть();
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	ЭтаФорма.Модифицированность = Ложь;
	Если РежимВыбора Тогда
		Если МножественныйВыбор Тогда
			Результат = Таблица.НайтиСтроки(Новый Структура("Пометка", Истина));
			//Если Результат.Количество() = 0 Тогда
			//	Возврат;
			//КонецЕсли; 
		Иначе
			Результат = ЭлементыФормы.Таблица.ТекущаяСтрока;
			Если Результат = Неопределено Тогда
				Возврат;
			КонецЕсли; 
		КонецЕсли; 
	Иначе
		Результат = ПолучитьРезультат();
	КонецЕсли; 
	ирКлиент.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, Результат);
	
КонецПроцедуры

Функция ЛиОсновнойПриемникФайл()
	Возврат Не ЭтаФорма.МодальныйРежим И ЭтаФорма.ВладелецФормы = Неопределено;
КонецФункции

Процедура УстановитьРедактируемоеЗначение(НовоеЗначение, РазрешитьПропускНеуникальных = Истина)
	
	#Если Сервер И Не Сервер Тогда
		НовоеЗначение = Новый СписокЗначений;
	#КонецЕсли
	ОчиститьПередЗагрузкой = Истина; 
	ОписаниеТиповНовогоСписка = НовоеЗначение.ТипЗначения;
	Если ОписаниеТиповНовогоСписка.Типы().Количество() = 0 Тогда
		ВременнаяТаблица = ирОбщий.ЗагрузитьВКолонкуТаблицыЛкс(НовоеЗначение.ВыгрузитьЗначения(), "Значение");  
		ВременнаяТаблица = ирОбщий.СузитьТипыКолонокТаблицыБезПотериДанныхЛкс(ВременнаяТаблица);
		ОписаниеТиповНовогоСписка = ВременнаяТаблица.Колонки[0].ТипЗначения;
	КонецЕсли;
	Если Истина
		И Таблица.Количество() > 0
		И ирОбщий.ЛиОписаниеТипов1ВходитВОписаниеТипов2Лкс(ОписаниеТиповНовогоСписка, ОписаниеТипов)
	Тогда
		ОчиститьПередЗагрузкой = ПредложитьДополнениеКоллекции();
	КонецЕсли;
	Если ОчиститьПередЗагрузкой Тогда
		ЭтаФорма.ОписаниеТипов = НовоеЗначение.ТипЗначения;
	КонецЕсли;
	ЗагрузитьЭлементыСписка(НовоеЗначение, ОчиститьПередЗагрузкой, РазрешитьПропускНеуникальных);
	НастроитьЭлементыФормы();
	Если НовоеЗначение.ДоступныеЗначения <> Неопределено Тогда
		ПолеЗначения = ЭлементыФормы.Таблица.Колонки.ПредставлениеЗначения.ЭлементУправления;
		ПолеЗначения.СписокВыбора = НовоеЗначение.ДоступныеЗначения;
		ПолеЗначения.РежимВыбораИзСписка = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция ПредложитьДополнениеКоллекции()
	
	Ответ = Вопрос("Дополнить коллекцию (иначе заменить)?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	ОчиститьПередЗагрузкой = Ответ = КодВозвратаДиалога.Нет;
	Возврат ОчиститьПередЗагрузкой;

КонецФункции

Процедура ЗагрузитьЭлементыСписка(НовоеЗначение, ОчиститьПередЗагрузкой = Истина, РазрешитьПропускНеуникальных = Истина)

	Если ОчиститьПередЗагрузкой Тогда
		Таблица.Очистить();
	КонецЕсли; 
	ЕстьПометки = Ложь;
	ЕстьПредставление = Ложь;
	ПропускатьНеуникальные = РазрешитьПропускНеуникальных = Истина И Уникальные И НовоеЗначение.Количество() < 1000;
	Для Индекс = 0 По НовоеЗначение.Количество() - 1 Цикл
		ЗначениеЭлемента = НовоеЗначение[Индекс];
		Если ПропускатьНеуникальные Тогда 
			СтрокаТаблицы = Таблица.Найти(ЗначениеЭлемента.Значение, "Значение");
			Если СтрокаТаблицы <> Неопределено Тогда
				Продолжить;
			КонецЕсли; 
		КонецЕсли;
	    НоваяСтрока = Таблица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЗначениеЭлемента); 
		ОбновитьПредставлениеИТипЗначенияВСтроке(НоваяСтрока);
		Если НоваяСтрока.Пометка Тогда
			ЕстьПометки = Истина;
		КонецЕсли; 
		Если ЗначениеЗаполнено(НоваяСтрока.Представление) Тогда
			ЕстьПредставление = Истина;
		КонецЕсли; 
		Если НачальныйЭлементСписка = ЗначениеЭлемента Тогда
			ЭлементыФормы.Таблица.ТекущаяСтрока = НоваяСтрока;
		КонецЕсли; 
	КонецЦикла;
	ЭлементыФормы.Таблица.Колонки.Пометка.Видимость = ЕстьПометки Или (РежимВыбора И МножественныйВыбор);
	ЭлементыФормы.Таблица.Колонки.Представление.Видимость = ЕстьПредставление;
	ЭлементыФормы.Таблица.Колонки.Картинка.Видимость = Таблица.НайтиСтроки(Новый Структура("Картинка", Новый Картинка)).Количество() < Таблица.Количество();      

КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭтаФорма.Таблица = ТаблицаОтобранное;
	Если ТипЗнч(НачальноеЗначениеВыбора) <> Тип("СписокЗначений") Тогда
		СписокЗначений = Новый СписокЗначений;
		Типы = Новый Соответствие;
		Для Каждого Элемент Из НачальноеЗначениеВыбора Цикл
			Типы[ТипЗнч(Элемент)] = 1;
		КонецЦикла;
		Если Типы.Количество() = 1 Тогда
			СписокЗначений.ТипЗначения = Новый ОписаниеТипов(ирОбщий.ВыгрузитьСвойствоЛкс(Типы));
		КонецЕсли;
		Если ТипЗнч(НачальноеЗначениеВыбора) = Тип("Массив") Тогда
			СписокЗначений.ЗагрузитьЗначения(НачальноеЗначениеВыбора);
		КонецЕсли;
		НачальноеЗначениеВыбора = СписокЗначений;
	КонецЕсли;
	ирКлиент.ФормаОбъекта_ОбновитьЗаголовокЛкс(ЭтаФорма);
	УстановитьРедактируемоеЗначение(НачальноеЗначениеВыбора, Ложь);
	Если РежимВыбора Тогда
		КолонкиТП = ЭлементыФормы.Таблица.Колонки; 
		РазницаПозицийКолонок = КолонкиТП.Индекс(КолонкиТП.ПредставлениеЗначения) - КолонкиТП.Индекс(КолонкиТП.Представление);
		Если Таблица.НайтиСтроки(Новый Структура("Представление", "")).Количество() = 0 Тогда
			Если РазницаПозицийКолонок < 0 Тогда
				КолонкиТП.Сдвинуть(КолонкиТП.Представление, РазницаПозицийКолонок);
			КонецЕсли;
			Если КолонкиТП.Представление.Видимость Тогда
				ЭлементыФормы.Таблица.ТекущаяКолонка = КолонкиТП.Представление;
			КонецЕсли;
		Иначе 
			Если РазницаПозицийКолонок > 0 Тогда
				КолонкиТП.Сдвинуть(КолонкиТП.ПредставлениеЗначения, -РазницаПозицийКолонок);
			КонецЕсли;
			ЭлементыФормы.Таблица.ТекущаяКолонка = КолонкиТП.ПредставлениеЗначения;
		КонецЕсли;
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОК.ИзменяетДанные = Ложь;
		ЭлементыФормы.Таблица.ИзменятьСоставСтрок = Ложь;
		Для Каждого КолонкаТП Из КолонкиТП Цикл
			Если МножественныйВыбор И КолонкаТП = КолонкиТП.Пометка Тогда
				Продолжить;
			КонецЕсли; 
			КолонкаТП.ТолькоПросмотр = Истина;
		КонецЦикла;
		Если МножественныйВыбор Тогда
			КолонкиТП.Пометка.Видимость = Истина;
		КонецЕсли;
	КонецЕсли; 
	ЭлементыФормы.Таблица.ТолькоПросмотр = ТолькоПросмотр; // Чтобы открытие ссылок из ячеек работало
	ирКлиент.ДопСвойстваЭлементаФормыЛкс(ЭтаФорма, ЭлементыФормы.Таблица).МенеджерПоиска = ирКлиент.СоздатьМенеджерПоискаВТабличномПолеЛкс(); // Для отключения раскраски
	ЭтаФорма.Модифицированность = Ложь; 
	Если ЛиОсновнойПриемникФайл() Тогда
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОК.Подсказка = "Сохранить в файл и закрыть";
	КонецЕсли;
	Если ПараметрИндексЭлемента > 0 Тогда
		ЭлементыФормы.Таблица.ТекущаяСтрока = Таблица[ПараметрИндексЭлемента];
	КонецЕсли;
	Если РежимВыбора И МожноФокусВФильтр И НачальноеЗначениеВыбора.Количество() > 20 Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ТаблицаСтрокаПоиска;
	КонецЕсли;
	ирКлиент.ПоследниеВыбранныеЗаполнитьПодменюЛкс(ЭтаФорма, ЭлементыФормы.КПТаблица.Кнопки.ПоследниеВыбранные,,,,  КлючХраненияВыбора);

КонецПроцедуры

Процедура ТабличноеПоле1ПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки,,, Новый Структура("ПредставлениеЗначения", "Значение"));
	//ирКлиент.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.ПредставлениеЗначения, ДанныеСтроки.Значение, Элемент.Колонки.ПредставлениеЗначения);
	ОформлениеСтроки.Ячейки.ТипЗначения.УстановитьТекст(ТипЗнч(ДанныеСтроки.Значение));
	ОформлениеСтроки.Ячейки.Номер.УстановитьТекст(Элемент.Значение.Индекс(ДанныеСтроки) + 1);
	Если ДанныеСтроки.Картинка <> Неопределено Тогда
		ОформлениеСтроки.Ячейки.Картинка.УстановитьКартинку(ДанныеСтроки.Картинка);
	КонецЕсли;

КонецПроцедуры

Процедура ОсновныеДействияФормыИсследовать()
	
	ирОбщий.ИсследоватьЛкс(ПолучитьРезультат());
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	Количество = Таблица.Количество();
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Ответ = ирКлиент.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма, Отказ);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОсновныеДействияФормыОК();
	КонецЕсли;

КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ЛиПростойСписок = ОписаниеТипов.Типы().Количество() = 1;
	ЭлементыФормы.Таблица.Колонки.ТипЗначения.Видимость = Не ЛиПростойСписок;
	ЭлементыФормы.КПТаблица.Кнопки.Подбор.Доступность = Ложь
		Или Не ЛиПростойСписок 
		Или ирОбщий.ЛиОписаниеТиповПростогоСсылочногоТипаЛкс(ОписаниеТипов,, Ложь);
	
КонецПроцедуры

Процедура ОписаниеТиповНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	РезультатВыбора = ирКлиент.РедактироватьОписаниеРедактируемыхТиповЛкс(Элемент);
	Если РезультатВыбора <> Неопределено Тогда
		Элемент.Значение = РезультатВыбора;
		НастроитьЭлементыФормы();
	КонецЕсли; 
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура КоманднаяПанель1ЗагрузитьИзФайла(Кнопка)
	
	ИмяФайла = мИмяОткрытогоФайла;
	Результат = ирКлиент.ЗагрузитьЗначениеИзФайлаИнтерактивноЛкс(РасширениеФайла,,, ИмяФайла);
	Если ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
		мИмяОткрытогоФайла = ИмяФайла;
		ОбновитьЗаголовокОтФайла();
		УстановитьРедактируемоеЗначение(Результат, Истина);
	КонецЕсли; 
	 
КонецПроцедуры

Функция СохранитьВФайл(РазрешитьВТекущийФайл = Истина)
	
	Если РазрешитьВТекущийФайл Тогда
		ИмяФайла = мИмяОткрытогоФайла;
	КонецЕсли;
	Результат = ирКлиент.СохранитьЗначениеВФайлИнтерактивноЛкс(ПолучитьРезультат(), РасширениеФайла, "Список значений",,,, ИмяФайла);
	Если Результат Тогда
		мИмяОткрытогоФайла = ИмяФайла;
		ОбновитьЗаголовокОтФайла();
	КонецЕсли;
	Возврат Результат;

КонецФункции

Процедура ОбновитьЗаголовокОтФайла()
	ирКлиент.ФормаОбъекта_ОбновитьЗаголовокЛкс(ЭтаФорма, мИмяОткрытогоФайла);
КонецПроцедуры

Функция КоманднаяПанель1СохранитьВФайл(Кнопка)
	СохранитьВФайл(Ложь);
КонецФункции

Процедура КПТаблицаСохранитьВТекущийФайл(Кнопка)
	СохранитьВФайл();
КонецПроцедуры

Процедура КоманднаяПанель1Подбор(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.Таблица.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		НачальноеЗначениеВыбораЛ = ТекущаяСтрока.Значение;
	КонецЕсли;
	ирКлиент.ОткрытьПодборСВыборомТипаЛкс(ЭлементыФормы.Таблица, ОписаниеТипов, НачальноеЗначениеВыбораЛ,, Истина, СтруктураОтбора);

КонецПроцедуры

Процедура ТаблицаОбработкаВыбора(Элемент = Неопределено, ВыбранноеЗначение, СтандартнаяОбработка = Неопределено)
	
	Если Истина
		И ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") 
		И ТипЗнч(ВыбранноеЗначение) <> Тип("Структура")
	Тогда
		лЗначение = ВыбранноеЗначение;
		ВыбранноеЗначение = Новый Массив();
		ВыбранноеЗначение.Добавить(лЗначение);
	КонецЕсли; 
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда 
		ЛиПроизвольныйТип = ОписаниеТипов.Типы().Количество() = 0;
		ПроверятьУникальность = Уникальные И ВыбранноеЗначение.Количество() < 1000;
		Для Каждого лЗначение Из ВыбранноеЗначение Цикл
			Если Ложь
				Или ЛиПроизвольныйТип
				Или ОписаниеТипов.СодержитТип(ТипЗнч(лЗначение)) 
			Тогда
				Если ПроверятьУникальность Тогда 
					СтрокаТаблицы = Таблица.Найти(лЗначение, "Значение");
				Иначе
					СтрокаТаблицы = Неопределено;
				КонецЕсли;
				Если СтрокаТаблицы = Неопределено Тогда
					СтрокаТаблицы = Таблица.Добавить();
					СтрокаТаблицы.Значение = лЗначение;
					ОбновитьПредставлениеИТипЗначенияВСтроке(СтрокаТаблицы);
					ЭтаФорма.Модифицированность = Истина;
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла;
		Если СтрокаТаблицы <> Неопределено Тогда
			ЭлементыФормы.Таблица.ТекущаяСтрока = СтрокаТаблицы;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыРедактироватьКопию(Кнопка)
	
	ирКлиент.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирКлиент.ОткрытьЗначениеЛкс(ПолучитьРезультат(),,, ирКлиент.ЗаголовокДляКопииОбъектаЛкс(ЭтаФорма), Ложь);

КонецПроцедуры

Процедура ТаблицаПредставлениеЗначенияПриИзменении(Элемент)
	
	ТабличноеПоле = ЭтаФорма.ЭлементыФормы.Таблица;
	ТабличноеПоле.ТекущиеДанные.Значение = Элемент.Значение;
	ОбновитьПредставлениеИТипЗначенияВСтроке();

КонецПроцедуры

Процедура ТаблицаПредставлениеЗначенияНачалоВыбора(Элемент, СтандартнаяОбработка)

	ирКлиент.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.Таблица, СтандартнаяОбработка, ЭлементыФормы.Таблица.ТекущаяСтрока.Значение, ЗначениеЗаполнено(ОписаниеТипов),
		СтруктураОтбора);
	ОбновитьПредставлениеИТипЗначенияВСтроке();

КонецПроцедуры

Процедура ТаблицаПредставлениеЗначенияОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирКлиент.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка, ЭлементыФормы.Таблица.ТекущаяСтрока.Значение);

КонецПроцедуры

Процедура ОбновитьПредставлениеИТипЗначенияВСтроке(СтрокаТаблицы = Неопределено)
	
	Если СтрокаТаблицы = Неопределено Тогда
		СтрокаТаблицы = ЭлементыФормы.Таблица.ТекущиеДанные;
	КонецЕсли; 
	//СтрокаТаблицы.ТипЗначения = ТипЗнч(СтрокаТаблицы.Значение);
	СтрокаТаблицы.ПредставлениеЗначения = СтрокаТаблицы.Значение;
	
КонецПроцедуры

Процедура ТаблицаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ЭлементыФормы.Таблица.Колонки.ПредставлениеЗначения.ЭлементУправления.ОграничениеТипа = ОписаниеТипов;
	Если Истина
		И НоваяСтрока 
		И Не Копирование
	Тогда
		СтрокаТаблицы = ЭлементыФормы.Таблица.ТекущиеДанные;
		СтрокаТаблицы.Значение = ОписаниеТипов.ПривестиЗначение(Неопределено);
		СтрокаТаблицы.ПредставлениеЗначения = СтрокаТаблицы.Значение;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанель1ЗаполнитьЗапросом(Кнопка)
	
	КоллекцияДляЗаполнения = Новый ТаблицаЗначений;
	КоллекцияДляЗаполнения.Колонки.Добавить("Значение", ОписаниеТипов);
	КонсольЗапросов = ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирКонсольЗапросов");
	#Если Сервер И Не Сервер Тогда
		КонсольЗапросов = Обработки.ирКонсольЗапросов.Создать();
	#КонецЕсли
	РезультатЗапроса = КонсольЗапросов.ОткрытьДляЗаполненияКоллекции(КоллекцияДляЗаполнения);
	Если РезультатЗапроса = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОчиститьПередЗагрузкой = Ложь;
	Если Таблица.Количество() > 0 Тогда
		ОчиститьПередЗагрузкой = ПредложитьДополнениеКоллекции();
	КонецЕсли; 
	ЗагрузитьЭлементыСписка(РезультатЗапроса, ОчиститьПередЗагрузкой);
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирКлиент.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КоманднаяПанель1РедакторОбъектаБД(Кнопка)
	
	ирКлиент.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирКлиент.ОткрытьСсылкуЯчейкиВРедактореОбъектаБДЛкс(ЭлементыФормы.Таблица, "Значение");
	
КонецПроцедуры

Процедура КоманднаяПанель1ВМассив(Кнопка)
	
	ирКлиент.ОткрытьЗначениеЛкс(ПолучитьРезультат().ВыгрузитьЗначения(),,, ирКлиент.ЗаголовокДляКопииОбъектаЛкс(ЭтаФорма), Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанель1ИзМассива(Кнопка)
	
	Результат = ирКлиент.ЗагрузитьЗначениеИзФайлаИнтерактивноЛкс("VA_");
	Если ТипЗнч(Результат) = Тип("Массив") Тогда
		Список = Новый СписокЗначений;
		Список.ЗагрузитьЗначения(Результат);
		УстановитьРедактируемоеЗначение(Список);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанель1КонсольОбработки(Кнопка)
	
	ирКлиент.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирКлиент.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭлементыФормы.Таблица, "Значение", ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанель1ВТаблицу(Кнопка)
	
	ТаблицаЛ = Новый ТаблицаЗначений;
	ТаблицаЛ.Колонки.Добавить("Значение", ОписаниеТипов);
	ТаблицаЛ.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Для Каждого СтрокаСписка Из Таблица Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаЛ.Добавить(), СтрокаСписка); 
	КонецЦикла;
	ирКлиент.ОткрытьЗначениеЛкс(ТаблицаЛ,,,, Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанель1ИзТекста(Кнопка)
	
	ФормаРазбивки = ПолучитьФорму("РазбивкаТекста");
	РезультатФормы = ФормаРазбивки.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		#Если Сервер И Не Сервер Тогда
			РезультатФормы = Новый Массив;
		#КонецЕсли
		Если Не ирОбщий.ЛиОписаниеТиповПростогоСтроковогоТипаЛкс(ОписаниеТипов) Тогда
			РезультатФормы = ирКлиент.ИнтерактивноКонвертироватьМассивСтрокЛкс(РезультатФормы, ОписаниеТипов);
		КонецЕсли;
		Список = Новый СписокЗначений;
		Список.ТипЗначения = ОписаниеТипов;
		Список.ЗагрузитьЗначения(РезультатФормы);
		УстановитьРедактируемоеЗначение(Список);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ТаблицаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	ТекущаяСтрока = ЭлементыФормы.Таблица.ТекущаяСтрока;
	Если РежимВыбора И Не МножественныйВыбор Тогда
		Если КлючХраненияВыбора <> Неопределено Тогда
			ирКлиент.ПоследниеВыбранныеДобавитьЛкс(ЭтаФорма, ТекущаяСтрока.Значение, ТекущаяСтрока.Представление,,, КлючХраненияВыбора);
		КонецЕсли;
		ирКлиент.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, ТекущаяСтрока);
	Иначе
		Если Колонка = ЭлементыФормы.Таблица.Колонки.ПредставлениеЗначения Тогда 
			ирКлиент.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка, ТекущаяСтрока.Значение);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ТаблицаПриИзмененииФлажка(Элемент, Колонка)
	
	ирКлиент.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);

КонецПроцедуры

Процедура ТаблицаПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура КоманднаяПанель1УстановитьФлажки(Кнопка)
	
	ирКлиент.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭтаФорма, ЭлементыФормы.Таблица,, Истина);

КонецПроцедуры

Процедура КоманднаяПанель1СнятьФлажки(Кнопка)
	
	ирКлиент.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭтаФорма, ЭлементыФормы.Таблица,, Ложь);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура УникальныеПриИзменении(Элемент)
	
	Если Уникальные Тогда
		СостояниеСтрок = ирКлиент.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.Таблица, "Значение");
		ЗагрузитьЭлементыСписка(ПолучитьРезультат());
		ирКлиент.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.Таблица, СостояниеСтрок);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура КоманднаяПанель1ВБуферОбмена(Кнопка)
	
	ирКлиент.БуферОбменаПриложения_УстановитьЗначениеЛкс(ПолучитьРезультат());
	
КонецПроцедуры

Процедура КоманднаяПанель1ИзБуферОбмена(Кнопка)
	
	ОбъектИзБуфера = ирКлиент.БуферОбменаПриложения_ЗначениеЛкс();
	Если ТипЗнч(ОбъектИзБуфера) = Тип("СписокЗначений") Тогда
		УстановитьРедактируемоеЗначение(ОбъектИзБуфера);
		ЭтаФорма.Модифицированность = Истина;
	ИначеЕсли ТипЗнч(ОбъектИзБуфера) = Тип("Массив") Тогда
		Список = Новый СписокЗначений;
		Список.ЗагрузитьЗначения(ОбъектИзБуфера);
		УстановитьРедактируемоеЗначение(Список);
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ОтобратьСтроки()
	ТаблицаСУзкимиТипами = ирОбщий.СузитьТипыКолонокТаблицыБезПотериДанныхЛкс(Таблица,,,,,, ирОбщий.ЗначенияВМассивЛкс("Значение"));
	ТаблицаСУзкимиТипами.Колонки.Удалить("Значение");
	ирКлиент.ТабличноеПолеСОтборомПросмотраОбновитьКомпоновщикЛкс(ЭтаФорма, ЭлементыФормы.Таблица,, ТаблицаСУзкимиТипами);
	ирКлиент.ТабличноеПолеСОтборомПросмотраОтобратьЛкс(ЭтаФорма, ЭлементыФормы.Таблица,,, Истина);
КонецПроцедуры

Процедура КоллекцияИскомаяСтрокаПриИзменении(Элемент)
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОтобратьСтроки();
КонецПроцедуры

Процедура КоллекцияИскомаяСтрокаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура КоллекцияПодстрокаОтбораАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	Если ирКлиент.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, Элемент, Текст) Тогда 
		ОтобратьСтроки();
	КонецЕсли;
КонецПроцедуры

Процедура ТаблицаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ирКлиент.ТабличноеПолеСОтборомПросмотраПриОкончанииРедактированияЛкс(ЭтаФорма, Элемент);
КонецПроцедуры

Процедура ТаблицаПредставлениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирКлиент.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.Таблица, СтандартнаяОбработка);
	
КонецПроцедуры

Функция ПоследниеВыбранныеНажатие(Кнопка) Экспорт
	ирКлиент.ПоследниеВыбранныеНажатиеЛкс(ЭтаФорма, ЭлементыФормы.Таблица, Таблица.Колонки.Значение.Имя, Кнопка,, КлючХраненияВыбора);
КонецФункции

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.СписокЗначений");

РасширениеФайла = "VL_";
Уникальные = Истина;
ОписаниеТипов = Новый ОписаниеТипов();
ТаблицаОтобранное.Колонки.Добавить("Значение", ОписаниеТипов);
ТаблицаОтобранное.Колонки.Добавить("Картинка");
