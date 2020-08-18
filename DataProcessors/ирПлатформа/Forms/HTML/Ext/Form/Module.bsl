
Процедура ПолеHTMLДокументаonclick(Элемент, pEvtObj)
	
	htmlElement = pEvtObj.srcElement;
	Пока htmlElement <> Неопределено И htmlElement <> Null И ВРег(htmlElement.tagName) <> "A" Цикл
		htmlElement = htmlElement.parentElement;
	КонецЦикла;
	Если htmlElement = Неопределено Или htmlElement = Null Тогда
		Возврат;
	КонецЕсли;
	НовыйАдрес = htmlElement.href;
	Если Найти(НовыйАдрес, "http://") = 1 Тогда
		ЗапуститьПриложение(НовыйАдрес);
		pEvtObj.returnValue = Ложь;
	КонецЕсли; 
	
КонецПроцедуры
