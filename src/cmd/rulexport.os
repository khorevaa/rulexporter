#Использовать cli
#Использовать "../.."
#Использовать "."
///////////////////////////////////////////////////////////////////////////////

Процедура ВыполнитьПриложение()

	Приложение = Новый КонсольноеПриложение(ПараметрыПриложения.Имя(), "Разбор правил КД2 на отдельные файлы для версионирования в git");
	Приложение.Версия("v version", ПараметрыПриложения.Версия());

	Приложение.ДобавитьКоманду("e export", "Разбор правил КД2", Новый КомандаЭкспортПравил);
	Приложение.ДобавитьКоманду("i install", "Установка хука pre-commit в git репозиторий", Новый КомандаУстановкаХука);

	Приложение.Запустить(АргументыКоманднойСтроки);

КонецПроцедуры

///////////////////////////////////////////////////////

Попытка

    ВыполнитьПриложение();

Исключение
	Сообщить(ОписаниеОшибки());
	ЗавершитьРаботу(1);
КонецПопытки;
