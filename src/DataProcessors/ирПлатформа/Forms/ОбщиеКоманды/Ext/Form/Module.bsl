﻿
Процедура КлсКомандаНажатие(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
	ПолноеИмяФормы = "Обработка.ирПлатформа.Форма.ОбщиеКоманды";
	Выполнить("ирПортативный.ИнициализироватьФорму_" + ирОбщий.ИдентификаторИзПредставленияЛкс(ПолноеИмяФормы) + "(ЭтаФорма)");
КонецЕсли;
