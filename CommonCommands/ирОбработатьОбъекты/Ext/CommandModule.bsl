﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	#Если ВебКлиент Тогда
		Сообщить("Команда недоступна в вебклиенте");
	#ИначеЕсли ТонкийКлиент Тогда
		ОткрытьФорму("Обработка.ирПортативный.Форма.ПерезапускСеансаУправляемая");
	#Иначе
		ирОбщий.ОткрытьМассивОбъектовВПодбореИОбработкеОбъектовЛкс(ПараметрКоманды);
	#КонецЕсли 
	
КонецПроцедуры
