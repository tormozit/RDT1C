﻿Перем ВКОбщая;
Перем СтруктураТипаКонтекста; 
Перем СтараяСтрокаОписания; 
Перем КонечнаяКолонка;
Перем КонечнаяСтрока;
Перем НачальнаяКолонка;
Перем НачальнаяСтрока;
Перем ЛиТекущийВариантУстановленВручную;
Перем АктивироватьВладельцаФормы;
Перем ПоследнееОбновление;

Процедура ОбновлениеОтображения()
	
	Если ВКОбщая <> Неопределено Тогда
		ЭтаФорма.Активизировать(); // Нужно для перемещения уже открытого окна
		Если ВводДоступен() Тогда
			Если ВКОбщая <> "" Тогда
				РазрешитьВыходЗаГраницыЭкрана = Истина;
				ВКОбщая.ПереместитьОкноВПозициюКаретки(РазрешитьВыходЗаГраницыЭкрана);
			КонецЕсли;
			ВКОбщая = Неопределено;
			
			// Восстановим фокус ввода и мигание каретки https://www.hostedredmine.com/issues/936823
			// Теперь это лечится в ирКлсПолеТекстаПрограммы.УстановитьГраницыВыделения()
			//#Если Сервер И Не Сервер Тогда
			//	АктивироватьВладельца();
			//#КонецЕсли
			//ПодключитьОбработчикОжидания("АктивироватьВладельца", 0.1, Истина); // Так работает, но слишком большая задержка
			//ОткрытьИЗакрытьПустуюФормуЛкс(); // В данном случае не помогает
			//ирКлиент.ОтправитьНажатияКлавишЛкс("%"); // Так будет переключение ScrollLock
			//ирКлиент.ОтправитьНажатияКлавишЛкс("%");
			АктивироватьВладельца();
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры

Процедура АктивироватьВладельца()
	Если ВладелецФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ВладелецФормы.Активизировать();
КонецПроцедуры

// Надо вызывать до начала открытия (до ПередОткрытием), иначе недоступность формы-владельца будет сброшена
Процедура ЗапомнитьПозициюКаретки(Знач СмещениеГориз = 0, Знач СмещениеВерт = 0) Экспорт 
	
	Если ВводДоступен() Тогда // Так при двойном открытии почему то меняется позиция главного окна
	//Если Открыта() Тогда
		Возврат;
	КонецЕсли; 
	Если Не ирКэш.ЛиПлатформаWindowsЛкс() Тогда
		ВКОбщая = "";
		Возврат;
	КонецЕсли; 
	ВКОбщая = ирОбщий.НоваяВКОбщаяЛкс();
	ОбработкаПрерыванияПользователя();
	Если Истина
		И ВКОбщая <> Неопределено 
		//И ФормаВладелец <> Неопределено 
	Тогда
		#Если Сервер И Не Сервер Тогда
			ПолеТекста = Обработки.ирОболочкаПолеТекста.Создать();
		#КонецЕсли
		ПолеТекста.ПолучитьПозициюКаретки(ВКОбщая, ФормаВладелец,, СмещениеГориз, СмещениеВерт);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ПриОткрытии = Истина;
	ЭтаФорма.Автообновление = Истина 
		И Автообновление
		И ФормаВладелец <> Неопределено
		И (Ложь
			Или ирКэш.ЛиСеансТолстогоКлиентаУПЛкс() 
			Или СостояниеОкна = ВариантСостоянияОкна.Свободное);
	ЭлементыФормы.ТаблицаПараметров.Шапка = Не Автообновление;
	ЭлементыФормы.ТаблицаПараметров.Колонки.Описание.Видимость = Не Автообновление;
	Если МодальныйРежим Тогда
		ЭлементыФормы.Автообновление.Видимость = Ложь;
	КонецЕсли; 
	НачалоБездействия = ТекущаяДата();
	ПриЛюбомОтрытии();
	Если Открыта() Или МодальныйРежим Тогда // Могли уже закрыть программно
		ирКлиент.УстановитьПрикреплениеФормыВУправляемомПриложенииЛкс(Этаформа);
		Если Истина
			И ПолеТекста <> Неопределено
			И ТипЗнч(ПолеТекста.ЭлементФормы) = Тип("ПолеHTMLДокумента") 
		Тогда
			РедакторHTML_ОтключитьСочетанияПереключенияСигнатуры();
		КонецЕсли; 
	КонецЕсли; 
	Если МодальныйРежим Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ТаблицаПараметров;
	КонецЕсли; 
	ПриОткрытии = Ложь;
	
КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	
	ЭтаФорма.Автообновление = Ложь;
	ПриЛюбомОтрытии();
	
КонецПроцедуры

Процедура ПриЛюбомОтрытии() 
	
	ОтключитьОбработчикОжидания("ОбновитьФормуОбработчикОжидания");
	ОбновитьИлиЗакрытьФорму();
	//ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ТипЗначения;

КонецПроцедуры

Процедура ОбновитьФормуОбработчикОжидания()
	
	ОбновитьИлиЗакрытьФорму(Истина);
	
КонецПроцедуры 

Процедура ОткрытьОтложенно() Экспорт   
	Если Не Открыта() Тогда
		Открыть();
		АктивироватьВладельца();
	КонецЕсли;
КонецПроцедуры

Процедура ОбновитьИлиЗакрытьФорму(ЭтоВызовЧерезОжидание = Ложь, Необязательное = Ложь) Экспорт 
	Перем КонечнаяКолонкаЛ;
	Перем КонечнаяСтрокаЛ;
	Перем НачальнаяКолонкаЛ;
	Перем НачальнаяСтрокаЛ;
	Перем ПозицияДвумернаяЛ;
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	МоментВремени = ирОбщий.ТекущееВремяВМиллисекундахЛкс();
	Если Истина
		И Необязательное 
		И ПоследнееОбновление <> Неопределено
		И МоментВремени - ПоследнееОбновление < 50
	Тогда
		// Защита от слишком частого обновления. Такое возможно по клавиатурному вводу.
		Возврат;
	КонецЕсли;
	ПоследнееОбновление = МоментВремени;
	Если Ложь
		//Или ФормаВладелец = Неопределено // Так при закрытии консоли кода - связанное с формой общих методов окно тоже закроется
		Или (Истина
			И ПараметрПостояннаяСтруктураТипа = Неопределено
			И мФормаАвтодополнение <> Неопределено
			И мФормаАвтодополнение.Открыта())
	Тогда
		Если Открыта() Тогда 
			Закрыть();
		КонецЕсли; 
		Возврат;
	КонецЕсли;
	АктивироватьВладельцаФормы = Ложь;
	Если ПараметрПостояннаяСтруктураТипа <> Неопределено Тогда 
		// режим статического метода (не считываем позицию в тексте)
		СтруктураТипаКонтекста = ПараметрПостояннаяСтруктураТипа;
		Если ВладелецФормы <> Неопределено Тогда 
			АктивироватьВладельцаФормы = Не ЭтоВызовЧерезОжидание;
		КонецЕсли; 
	Иначе
		Если Не ЗначениеЗаполнено(мВызовМетода) Тогда
			ПолучитьТекущийКонтекстПараметра();
		КонецЕсли;                                                                                     
		ТаблицаТиповКонтекста = ВычислитьТипЗначенияВыражения(мВызовМетода,,,, мЭтоКонструктор,,,,,,, мПозицияВБлоке);
		мВызовМетода = "";                                    
		Если ТаблицаТиповКонтекста.Количество() > 0 Тогда
			СтруктураТипаКонтекста = ТаблицаТиповКонтекста[0];
		Иначе
			// Например после "(("
			СтруктураТипаКонтекста = Неопределено;
		КонецЕсли;
	КонецЕсли; 
	Если СтруктураТипаКонтекста = Неопределено Или СтруктураТипаКонтекста.СтрокаОписания = Неопределено Тогда
		СтараяСтрокаОписания = Неопределено;
		ОчиститьДанные();
		Если Открыта() Тогда 
			Если Автообновление Тогда
				Закрыть();
			Иначе
				ОбновитьОбработчикОжиданияОбновления();
			КонецЕсли;
		ИначеЕсли МодальныйРежим Тогда
			ОбновитьОбработчикОжиданияОбновления(0.1);
		КонецЕсли; 
		Возврат;
	КонецЕсли;
	ФормаНеИмеетФокуса = АктивироватьВладельцаФормы = Истина Или Не ВводДоступен(); // Так надо делать, т.к. иногда ВводДоступен() возвращает Истина, хотя фокуса нет
	Если Истина
		И Автообновление
		И ФормаНеИмеетФокуса
	Тогда 
		АктивнаяФорма = ирКлиент.АктивнаяФормаЛкс();
		Если Ложь
			Или мНомерПараметра = Неопределено 
			Или АктивнаяФорма <> Неопределено И АктивнаяФорма <> ВладелецФормы
		Тогда
			Если Открыта() Тогда
				Закрыть();
			КонецЕсли; 
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Если Ложь 
		Или ФормаНеИмеетФокуса
		Или Не Открыта() 
	Тогда
		СтрокаОписания = СтруктураТипаКонтекста.СтрокаОписания; // см. мПлатформа.НоваяТаблицаМетодовМодуля()[0]
		Попытка
			СтараяСтрокаОписания.Владелец();
		Исключение
			СтараяСтрокаОписания = Неопределено;
		КонецПопытки;
		Если Истина
			И СтараяСтрокаОписания <> СтрокаОписания 
			И Не (Истина 
				// одинаковый локальный метод 
				И СтараяСтрокаОписания <> Неопределено
				И ТипЗнч(СтрокаОписания) <> Тип("COMОбъект")
				И СтрокаОписания.Владелец().Колонки.Найти("ЛиЭкспорт") <> Неопределено
				И СтараяСтрокаОписания.Владелец().Колонки.Найти("ЛиЭкспорт") <> Неопределено
				И СтараяСтрокаОписания.Имя = СтрокаОписания.Имя
				И СтараяСтрокаОписания.ДлинаОпределения = СтрокаОписания.ДлинаОпределения)
		Тогда
			Если ТипЗнч(СтрокаОписания) = Тип("COMОбъект") Тогда
				НовоеИмяМетода = СтрокаОписания.Name;
			ИначеЕсли СтрокаОписания.Владелец().Колонки.Найти("ЛиЭкспорт") <> Неопределено Тогда
				НовоеИмяМетода = СтрокаОписания.Имя;
			ИначеЕсли Истина
				И СтрокаОписания.Владелец().Колонки.Найти("ТипСлова") <> Неопределено 
				И СтрокаОписания.ТипСлова = "Конструктор"
			Тогда
				НовоеИмяМетода = "Новый " + СтрокаОписания.ТипКонтекста;
			Иначе
				НовоеИмяМетода = СтрокаОписания.Слово;
			КонецЕсли; 
			ирОбщий.ОбновитьТекстПослеМаркераЛкс(ЭтаФорма.Заголовок,, НовоеИмяМетода, ": ");
			ИмяМетода = НовоеИмяМетода;
			СтараяСтрокаОписания = СтрокаОписания;
			ЛиТекущийВариантУстановленВручную = Ложь;
			Если ПараметрПостояннаяСтруктураТипа = Неопределено Тогда
				ЗапомнитьПозициюКаретки(); 
			КонецЕсли; 
			Если Ложь
				Или Не ЭтоВызовЧерезОжидание 
				Или (Истина
					И ПараметрПостояннаяСтруктураТипа = Неопределено
					И ирКлиент.Форма_ВводДоступенЛкс(ФормаВладелец))
			Тогда
				ОчиститьДанные();
				ВариантыСинтаксиса.Добавить();
				Если ТипЗнч(СтрокаОписания) = Тип("COMОбъект") Тогда
					ИнфоТипа = мПлатформа.ПолучитьИнфоТипаCOMОбъекта(СтруктураТипаКонтекста.Метаданные);
					ЭтаФорма.ТекущийВариант = Неопределено;
					ЭтаФорма.ОписаниеМетода = СокрЛ(СтрокаОписания.HelpString);
					Для Каждого ОписаниеПараметра Из СтрокаОписания.Parameters Цикл
						СтрокаПараметра = ТаблицаПараметров.Добавить();
						СтрокаПараметра.Имя = ОписаниеПараметра.Name;
						Если ОписаниеПараметра.Default Тогда
							СтрокаПараметра.Значение = ОписаниеПараметра.DefaultValue;
							Если Не ЗначениеЗаполнено(СтрокаПараметра.Значение) Тогда
								Попытка
									СтрокаПараметра.Значение = ирОбщий.ПредставлениеЗначенияВоВстроенномЯзыкеЛкс(ОписаниеПараметра.DefaultValue);
								Исключение
								КонецПопытки;
							КонецЕсли; 
							Если Не ЗначениеЗаполнено(СтрокаПараметра.Значение) Тогда
								СтрокаПараметра.Значение = "?";
							КонецЕсли; 
						КонецЕсли; 
						СтрокаПараметра.ТипЗначения = мПлатформа.ПолучитьТипЗначенияЧленаИнтерфейса(ОписаниеПараметра.VarTypeInfo,, ИнфоТипа.Parent);
					КонецЦикла;
					ЭтаФорма.ТипЗначенияМетода = мПлатформа.ПолучитьТипЗначенияЧленаИнтерфейса(СтрокаОписания.ReturnType,, ИнфоТипа.Parent);
					УстановитьТекущийПараметр();
				ИначеЕсли СтрокаОписания.Владелец().Колонки.Найти("ЛиЭкспорт") <> Неопределено Тогда
					ЭтаФорма.ТекущийВариант = Неопределено;
					СтрокиПараметров = мПлатформа.ПараметрыМетодаМодуля(СтрокаОписания);
					Если СтрокиПараметров <> Неопределено Тогда
						ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(СтрокиПараметров, ТаблицаПараметров);
					КонецЕсли;
					ШаблоныЯзыка = мПлатформа.ШаблоныДляАнализаВстроенногоЯзыка();
					ЭтаФорма.ОписаниеМетода = "";
					ОписаниеРезультата = ирОбщий.НайтиРегВыражениеЛкс(СтрокаОписания.Описание, ШаблоныЯзыка.СтруктураКомментарияВозвр);
					если ОписаниеРезультата.Количество() > 0 Тогда  
						ОписаниеМетода = СокрЛП(ОписаниеРезультата[0].ТекстВхождения);
					КонецЕсли;
					Если ЗначениеЗаполнено(ЭтаФорма.ОписаниеМетода) Тогда
						ЭтаФорма.ОписаниеМетода = ЭтаФорма.ОписаниеМетода + Символы.ПС + "Описание метода:" + Символы.ПС;
					КонецЕсли;
					ЭтаФорма.ОписаниеМетода = ЭтаФорма.ОписаниеМетода + СокрЛП(ирОбщий.ЗаменитьРегВыражениеЛкс(СтрокаОписания.Описание, ШаблоныЯзыка.СтруктураКомментарияПарам, "", Ложь));
					ОбновитьТипЗначенияИзТаблицыТипов(СтрокаОписания, СтрокаОписания.ТаблицаТипов, Ложь);
					ЭтаФорма.ТипЗначенияМетода = СтрокаОписания.ТипЗначения;
					ОбработкаТекста = ирКэш.ВычислительРегВыраженийЛкс();
					ОбработкаТекста.Global = Истина;
					ОбработкаТекста.Pattern = "(\n\s+)";
					Для Каждого СтрокаПараметра Из ТаблицаПараметров Цикл
						Если СтрокаПараметра.Знач = Истина Тогда
							СтрокаПараметра.Знач = "Знач";
						Иначе
							СтрокаПараметра.Знач = "!";
						КонецЕсли; 
						СтрокаПараметра.Описание = СокрЛ(ОбработкаТекста.Заменить(СтрокаПараметра.Описание, Символы.ПС));
					КонецЦикла;
					УстановитьТекущийПараметр();
				ИначеЕсли СтрокаОписания.Владелец().Колонки.Найти("ТипКонтекста") <> Неопределено Тогда
					ЗагрузитьВариантМетода();
				Иначе
					// Пользовательский метод
				КонецЕсли;
				ЭлементыФормы.ВариантПредыдущий.Доступность = ВариантыСинтаксиса.Количество() > 1;
				ЭлементыФормы.ВариантСледующий.Доступность = ВариантыСинтаксиса.Количество() > 1;
			КонецЕсли;
			ЕстьПолезнаяИнформация = ТаблицаПараметров.Количество() > 0;
			Если Истина
				И ЕстьПолезнаяИнформация
				И Не ЗначениеЗаполнено(ТаблицаПараметров[0].Имя) 
			Тогда
				// Функции языка запросов. Для них нет стандарта описания параметров. Поэтому в общей таблице параметров для каждой добавляется безымянный параметр
				ЕстьПолезнаяИнформация = ЗначениеЗаполнено(ОписаниеМетода);
				ТаблицаПараметров[0].Имя = "<Параметры неизвестны>";
			КонецЕсли; 
		Иначе
			Если ЗначениеЗаполнено(ТекущийВариант) И СтрокаОписания.Владелец().Колонки.Найти("ТипКонтекста") <> Неопределено Тогда
				ЗагрузитьВариантМетода();
			Иначе
				УстановитьТекущийПараметр();
			КонецЕсли; 
		КонецЕсли;
		Если Истина
			И Не ЕстьПолезнаяИнформация 
			И Автообновление
			И ФормаНеИмеетФокуса
		Тогда 
			Если ЭтаФорма.Открыта() Тогда
				Закрыть();
			КонецЕсли;
			Возврат;
		КонецЕсли;
		Если Истина
			И СостояниеОкна = ВариантСостоянияОкна.Свободное
			И Открыта() 
		Тогда
			Если ЭтоВызовЧерезОжидание Тогда 
				УстановитьВысотуФормы();
			Иначе
				// https://www.hostedredmine.com/issues/910184 
				#Если Сервер И Не Сервер Тогда
					УстановитьВысотуФормы();
				#КонецЕсли
				ПодключитьОбработчикОжидания("УстановитьВысотуФормы", 0.1, Истина);
			КонецЕсли; 
		КонецЕсли;
		Если ПараметрПостояннаяСтруктураТипа = Неопределено Тогда
			ПолеТекста.ПолучитьГраницыВыделения(НачальнаяСтрокаЛ, НачальнаяКолонкаЛ, КонечнаяСтрокаЛ, КонечнаяКолонкаЛ);
			Если Ложь
				Или НачальнаяСтрока <> НачальнаяСтрокаЛ 
				Или НачальнаяКолонка <> НачальнаяКолонкаЛ 
				Или КонечнаяСтрока <> КонечнаяСтрокаЛ
				Или КонечнаяКолонка <> КонечнаяКолонкаЛ
			Тогда
				Если Ложь
					Или НачальнаяСтрока <> НачальнаяСтрокаЛ 
					Или КонечнаяСтрока <> КонечнаяСтрокаЛ
				Тогда
					ЗапомнитьПозициюКаретки(); 
				КонецЕсли; 
				//Сообщить("изменилось положение курсора " + ТекущаяДата());
				НачальнаяСтрока = НачальнаяСтрокаЛ;
				НачальнаяКолонка = НачальнаяКолонкаЛ;
				КонечнаяСтрока = КонечнаяСтрокаЛ;
				КонечнаяКолонка = КонечнаяКолонкаЛ;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	ОбновлениеОтображения();
	ОбновитьОбработчикОжиданияОбновления();
	Если АктивироватьВладельцаФормы Тогда
		АктивироватьВладельца();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьДанные()
	
	ЕстьПолезнаяИнформация = Истина;
	ЭтаФорма.ОписаниеМетода = "";
	ТаблицаПараметров.Очистить();
	ВариантыСинтаксиса.Очистить();

КонецПроцедуры

Процедура УстановитьВысотуФормы()
	
	НеобходимаяВысота = 19 * (ТаблицаПараметров.Количество() + 3); // одну строку добавляем на случай превышения количеством запятых количества формальных параметров
	Если Высота < НеобходимаяВысота Тогда
		ЭтаФорма.Высота = НеобходимаяВысота;
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьТекущийПараметр()
	
	Для Счетчик = ТаблицаПараметров.Количество() + 1 По мФактическиеПараметры.Количество() Цикл
		СтрокаПараметра = ТаблицаПараметров.Добавить();
		СтрокаПараметра.Имя = "?";
	КонецЦикла;
	Для Каждого СтрокаПараметра Из ТаблицаПараметров Цикл
		ИндексПараметра = ТаблицаПараметров.Индекс(СтрокаПараметра);
		Если мФактическиеПараметры.Количество() > ИндексПараметра Тогда
			СтрокаПараметра.Выражение = мФактическиеПараметры[ИндексПараметра];
		КонецЕсли;
	КонецЦикла;   
	Если Истина
		И ФормаВладелец = ВладелецФормы 
		И (Ложь
			Или Открыта() 
			Или МодальныйРежим)
		И (Ложь
			Или мНомерПараметра > 0
			Или ЭлементыФормы.ТаблицаПараметров.ТекущаяСтрока = Неопределено) 
	Тогда
		НомерПараметра = Макс(1, мНомерПараметра);
		Если ТаблицаПараметров.Количество() >= НомерПараметра Тогда
			НоваяТекущаяСтрока = ТаблицаПараметров[НомерПараметра - 1];
			ирОбщий.ПрисвоитьЕслиНеРавноЛкс(ЭлементыФормы.ТаблицаПараметров.ТекущаяСтрока, НоваяТекущаяСтрока); // тяжелая операция
		КонецЕсли; 
	КонецЕсли;
	Если ВариантыСинтаксиса.Количество() > 1 Тогда
		ЭлементыФормы.НадписьКоличествоВариантов.Шрифт = Новый Шрифт(,, Истина);
		ЭлементыФормы.НадписьКоличествоВариантов.ЦветТекста = Новый Цвет;
		ЭлементыФормы.НадписьТекущийВариант.ЦветТекста = Новый Цвет;
	Иначе
		ЭлементыФормы.НадписьКоличествоВариантов.ЦветТекста = ЭлементыФормы.Автообновление.ЦветТекста;
		ЭлементыФормы.НадписьТекущийВариант.ЦветТекста = ЭлементыФормы.Автообновление.ЦветТекста;
	КонецЕсли; 

КонецПроцедуры

Процедура ЗагрузитьВариантМетода(НовыйТекущийВариант = Неопределено) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Если НовыйТекущийВариант <> Неопределено Тогда
		ЭтаФорма.ТекущийВариант = НовыйТекущийВариант;
	КонецЕсли; 
	ТаблицаПараметров.Очистить();
	СтрокаОписания = СтруктураТипаКонтекста.СтрокаОписания;
	Если СтрокаОписания.Владелец().Колонки.Найти("ЛиЭкспорт") <> Неопределено Тогда
		ЭтаФорма.НадписьКоличествоВариантов = "1/1";
		Возврат;
	КонецЕсли;
	КоличествоФактПараметров = мФактическиеПараметры.Количество();
	
	// Мультиметка06322413
	СтрокиПараметров = мПлатформа.ПараметрыМетодаПлатформы(СтрокаОписания);
	#Если Сервер И Не Сервер Тогда
		СтрокиПараметров = Новый ТаблицаЗначений;
	#КонецЕсли
	НомерВарианта = 0;
	ВариантыСинтаксиса = Новый СписокЗначений;
	//Если Не ЛиТекущийВариантУстановленВручную Тогда
		ТаблицаВариантов = СтрокиПараметров.Скопировать();
		ЭтаФорма.ТекущийВариант = мПлатформа.ПодобратьВариантСинтаксисаМетода(ТаблицаВариантов, КоличествоФактПараметров, ТекущийВариант, ЛиТекущийВариантУстановленВручную, НомерВарианта);
		ВариантыСинтаксиса.ЗагрузитьЗначения(ТаблицаВариантов.ВыгрузитьКолонку(0));
		Если ВариантыСинтаксиса.Количество() = 0 Тогда
			ВариантыСинтаксиса.Добавить();
		КонецЕсли; 
		ВариантыСинтаксиса.СортироватьПоЗначению();
	//КонецЕсли;
	
	Если СтрокаОписания.ТипСлова = "Конструктор" И ЗначениеЗаполнено(ТекущийВариант) Тогда
		КлючПоиска = Новый Структура;
		КлючПоиска.Вставить("ТипКонтекста", СтрокаОписания.ТипКонтекста);
		КлючПоиска.Вставить("ТипСлова", "Конструктор");
		КлючПоиска.Вставить("НСлово", НРег(ТекущийВариант));
		КлючПоиска.Вставить("ТипЯзыка", "");
		КлючПоиска.Вставить("ЯзыкПрограммы", 0);
		НайденныеСтроки = мПлатформа.ТаблицаКонтекстов.НайтиСтроки(КлючПоиска);
		Если НайденныеСтроки.Количество() > 0 Тогда
			СтрокаОписания = НайденныеСтроки[0];
		КонецЕсли; 
	КонецЕсли; 
	ЭтаФорма.НадписьКоличествоВариантов = "" + НомерВарианта + "/" + ВариантыСинтаксиса.Количество();
	Попытка
		ЭтаФорма.ОписаниеМетода = СтрокаОписания.Описание;
	Исключение
		ЭтаФорма.ОписаниеМетода = "";
	КонецПопытки; 
	СтруктураТипаКонтекста.ИмяОбщегоТипа = СтрокаОписания.ТипЗначения;
	ЭтаФорма.ТипЗначенияМетода = мПлатформа.ИмяТипаИзСтруктурыТипа(СтруктураТипаКонтекста);
	ПараметрыВарианта = СтрокиПараметров.НайтиСтроки(Новый Структура("ВариантСинтаксиса", ТекущийВариант));
	Для Каждого СтрокаПараметраИсточник Из ПараметрыВарианта Цикл
		СтрокаПараметраПриемник = ТаблицаПараметров.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПараметраПриемник, СтрокаПараметраИсточник); 
		СтрокаПараметраПриемник.Имя = ПодготовитьИмяПараметраМетодаПлатформы(СтрокаПараметраИсточник.Параметр);
		Если Истина
			И Не ЗначениеЗаполнено(СтрокаПараметраПриемник.Значение)
			И СтрокаПараметраИсточник.Необязательный 
		Тогда
			СтрокаПараметраПриемник.Значение = "?";
		КонецЕсли;
	КонецЦикла;
	УстановитьТекущийПараметр();

КонецПроцедуры

Процедура ОбновитьОбработчикОжиданияОбновления(Задержка = 1)
	
	Если Ложь
		Или Не Автообновление
		Или Не Открыта() И Не МодальныйРежим 
	Тогда
		ОтключитьОбработчикОжидания("ОбновитьФормуОбработчикОжидания");
		Возврат;
	КонецЕсли;
	#Если Сервер И Не Сервер Тогда
		ОбновитьФормуОбработчикОжидания();
	#КонецЕсли
	ПодключитьОбработчикОжидания("ОбновитьФормуОбработчикОжидания", Задержка, Истина);

КонецПроцедуры

Процедура ТаблицаПараметровПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	Если ДанныеСтроки.Знач = "!" Тогда
		КартинкаНаправления = ирКэш.КартинкаПоИмениЛкс("ирВыходящий");
	Иначе 
		КартинкаНаправления = ирКэш.КартинкаПоИмениЛкс("ирВходящий");
	КонецЕсли;
	ОформлениеСтроки.Ячейки.Знач.УстановитьКартинку(КартинкаНаправления);
	ОформитьЯчейкуТипаЗначения(ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ТаблицаПараметровВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	//Если СостояниеОкна = ВариантСостоянияОкна.Свободное Тогда
	//	ЭтаФорма.Закрыть();
	//КонецЕсли;
	ЭтаФорма.Автообновление = Ложь;
	ОбновитьОбработчикОжиданияОбновления();
	Если Колонка = ЭлементыФормы.ТаблицаПараметров.Колонки.ТипЗначения Тогда
		ОткрытьСписокТипов(ВыбраннаяСтрока.ТипЗначения);
	ИначеЕсли Колонка = ЭлементыФормы.ТаблицаПараметров.Колонки.Выражение Тогда
		мНомерПараметра = ТаблицаПараметров.Индекс(ВыбраннаяСтрока) + 1;
		ТекущийВызовМетода(мНомерПараметра);
		Если МодальныйРежим Тогда
			Закрыть(Истина); // Для адаптера
		КонецЕсли;
	Иначе
		Если СтараяСтрокаОписания.Владелец().Колонки.Найти("ЛиЭкспорт") <> Неопределено Тогда
			//ОткрытьОпределениеСтруктурыТипа(СтруктураТипаКонтекста,, ВыбраннаяСтрока.Имя);
			СсылкаСтроки = ирОбщий.СсылкаСтрокиМодуляЛкс(СтараяСтрокаОписания.ИмяМодуля,, ИмяМетода,,,, ВыбраннаяСтрока.Имя);
			Если МодальныйРежим И ФормаВладелец = Неопределено Тогда
				Закрыть(СсылкаСтроки); // Для адаптера
			Иначе 
				ПерейтиПоСсылкеСтрокиМодуля(СсылкаСтроки, Ложь);
			КонецЕсли;
		Иначе 
			НайтиПоказатьСправкуПоСтруктуреТипа(, СтруктураТипаКонтекста,,,,, ТаблицаПараметров.Индекс(ВыбраннаяСтрока) + 1);
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры

Процедура ТаблицаПараметровПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ТекущаяСтрока = ЭлементыФормы.ТаблицаПараметров.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		Если ЛиНеОбязательныйПараметр(ТекущаяСтрока) Тогда
			ЭлементыФормы.НадписьОбязательность.Заголовок = "Необяз.";
		Иначе
			ЭлементыФормы.НадписьОбязательность.Заголовок = "Обяз.";
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Функция ЛиНеОбязательныйПараметр(Знач ТекущаяСтрока) Экспорт 
	
	Возврат ЗначениеЗаполнено(ТекущаяСтрока.Значение) Или ТекущаяСтрока.Имя = "?";

КонецФункции
 
Процедура ТипЗначенияОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЭтаФорма.Автообновление = Ложь;
	ОткрытьСписокТипов(Элемент.Значение);
	
КонецПроцедуры

Процедура ВариантСледующийНажатие(Элемент = Неопределено)
	
	ЭлементСписка = ВариантыСинтаксиса.НайтиПоЗначению(ТекущийВариант);
	Индекс = ВариантыСинтаксиса.Индекс(ЭлементСписка);
	Если ВариантыСинтаксиса.Количество() - 1 > Индекс Тогда
		Индекс = Индекс + 1;
	Иначе
		Индекс = 0;
	КонецЕсли; 
	УстановитьВариантСинтаксисаПоИндексу(Индекс);
	
КонецПроцедуры

Процедура ВариантПредыдущийНажатие(Элемент = Неопределено)
	                                       
	ЭлементСписка = ВариантыСинтаксиса.НайтиПоЗначению(ТекущийВариант);
	Индекс = ВариантыСинтаксиса.Индекс(ЭлементСписка);
	Если Индекс > 0 Тогда
		Индекс = Индекс - 1;
	Иначе
		Индекс = ВариантыСинтаксиса.Количество() - 1;
	КонецЕсли; 
	УстановитьВариантСинтаксисаПоИндексу(Индекс);
	
КонецПроцедуры

Процедура УстановитьВариантСинтаксисаПоИндексу(Знач Индекс) Экспорт 
	
	ЭтаФорма.ТекущийВариант = ВариантыСинтаксиса[Индекс].Значение;
	ЛиТекущийВариантУстановленВручную = Истина;
	ЗагрузитьВариантМетода();

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ЛиТекущийВариантУстановленВручную = Ложь;
	ЭтаФорма.ПараметрПостояннаяСтруктураТипа = Неопределено;
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	Если Истина
		И ПолеТекста <> Неопределено 
		И ТипЗнч(ПолеТекста.ЭлементФормы) = Тип("ПолеHTMLДокумента") 
	Тогда
		РедакторHTML_ВключитьСочетанияПереключенияСигнатуры();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьСписокТипов(Знач СтрокаТипов)
	
	ТипКоллекции = "";
	Если Найти(СтрокаТипов, "[") > 0 Тогда
		ТипКоллекции = ирОбщий.ПервыйФрагментЛкс(СтрокаТипов, "[");
		ИменаТипов = ирОбщий.СтрРазделитьЛкс(ирОбщий.ТекстМеждуМаркерамиЛкс(СтрокаТипов, "[", "]"), ",", Истина);
	Иначе
		ИменаТипов = ирОбщий.СтрРазделитьЛкс(СтрокаТипов, ",", Истина);
	КонецЕсли;
	СписокТипов = Новый СписокЗначений;
	СписокТипов.ЗагрузитьЗначения(ИменаТипов);
	СписокТипов.СортироватьПоЗначению();
	Если ТипКоллекции <> "" Тогда
		СписокТипов.Вставить(0, ТипКоллекции);
	КонецЕсли;
	Если СписокТипов.Количество() = 1 Тогда
		РезультатВыбора = СписокТипов[0];
	Иначе
		РезультатВыбора = СписокТипов.ВыбратьЭлемент();
	КонецЕсли; 
	Если РезультатВыбора <> Неопределено Тогда
		Попытка
			Тип = Тип(РезультатВыбора.Значение);
		Исключение
			Тип = Неопределено;
		КонецПопытки;
		Если Тип <> Неопределено Тогда
			ирКлиент.ОткрытьОписаниеТипаПоТипуЛкс(Тип, ЭтаФорма);
		Иначе
			ОткрытьКонтекстнуюСправку(РезультатВыбора.Значение, ЭтаФорма);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

// Этот обработчик нельзя подключать статически. Иначе он можно дублировать обработку внешнего события вместе с глобальным механизмом
Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);
	Если Источник = "KeyboardHook" Тогда
		Если Открыта() Тогда 
			КодыКлавиш = ирКэш.КодыКлавишЛкс();
			Если ЭлементыФормы.ВариантСледующий.Доступность Тогда
				Если Найти(Данные, КодыКлавиш["ALT+Up"]) = 1 Тогда
					ВариантПредыдущийНажатие();
				ИначеЕсли Найти(Данные, КодыКлавиш["ALT+Down"]) = 1 Тогда
					ВариантСледующийНажатие();
				КонецЕсли;
			КонецЕсли; 
			Если Найти(Данные, КодыКлавиш["Esc"]) = 1 Тогда  // Esc // Работает только в поле HTML документа. В остальных местах платформа делает полный перехват 
				Закрыть();
			КонецЕсли; 
		КонецЕсли;
		Если Не ЭтаФорма.ВводДоступен() Тогда
			Возврат;
		КонецЕсли;
		Если Ложь
			Или ТекущийЭлемент = ЭлементыФормы.ТипЗначения 
			Или ТекущийЭлемент = ЭлементыФормы.ТипЗначенияМетода 
		Тогда
			Если Найти(Данные, "00013") = 1 Тогда  // {ENTER}
				ТипЗначенияОткрытие(ТекущийЭлемент, );
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт 
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 
	Если ИмяСобытия = "ПоказатьОписаниеСлова" Тогда
		КолонкиВладельца = Параметр.СтрокаОписания.Владелец().Колонки;
		Если КолонкиВладельца.Найти("ТелоБезВозвратов") <> Неопределено Тогда  
			//ЗапомнитьПозициюКаретки(Источник.Ширина + 4);
			ЭтаФорма.ПараметрПостояннаяСтруктураТипа = Параметр;
			ОбновитьИлиЗакрытьФорму();
			ЭтаФорма.ПараметрПостояннаяСтруктураТипа = Неопределено;
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

Процедура АвтообновлениеПриИзменении(Элемент)
	ОбновитьОбработчикОжиданияОбновления();
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстаПрограммы.Форма.ВызовМетода");
ЭлементыФормы.ТаблицаПараметров.Колонки.НомерСтроки.Имя = ирКэш.ИмяКолонкиНомерСтрокиЛкс();
ЭтаФорма.Автообновление = Истина;
