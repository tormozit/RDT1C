﻿Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
		
	Отказ = Истина;
	// Может, ссылки еще не существует? надо сначала записать объект
	Если Не ЗначениеЗаполнено(ПараметрОснование) Тогда
		Сообщить("Сначала запишите объект!");
		Возврат;
	КонецЕсли;
	ирКлиент.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ПараметрОснование);
	
КонецПроцедуры