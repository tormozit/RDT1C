﻿
Процедура ПолеHTMLДокументаonclick(Элемент, pEvtObj)
	
	Если ирКлиент.ОткрытьГиперссылкуИзПоляHTMLЛкс(pEvtObj.srcElement, pEvtObj.ctrlKey) Тогда 
		pEvtObj.returnValue = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ПриОткрытии()
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.HTML");
